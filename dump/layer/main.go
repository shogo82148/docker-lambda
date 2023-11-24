package main

import (
	"archive/tar"
	"bytes"
	"compress/gzip"
	"context"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/fs"
	"log"
	"os"
	"os/signal"
	"path/filepath"
	"runtime"
	"slices"
	"sort"
	"strconv"
	"strings"
	"syscall"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
)

func main() {
	var flagBase bool
	var bucket, key string
	flag.BoolVar(&flagBase, "base", false, "dump base files")
	flag.StringVar(&bucket, "bucket", "", "bucket name for uploading")
	flag.StringVar(&key, "key", "", "key name for uploading")
	flag.Parse()

	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer cancel()
	if err := dump(ctx, flagBase, bucket, key); err != nil {
		log.Fatal("failed to dump file system", err)
	}

	if err := dumpEnv(); err != nil {
		log.Fatal("failed to dump environment values", err)
	}

	if err := dumpProcEnviron(); err != nil {
		log.Fatal("failed to dump /proc/1/environ", err)
	}

	if err := dumpCmdline(); err != nil {
		log.Fatal("failed to dump cmdline", err)
	}
}

func dump(ctx context.Context, base bool, bucket, key string) error {
	// archive file system
	log.Println("archiving filesystem")
	d := newDumper()
	if base {
		if err := d.dumpBase(ctx); err != nil {
			return fmt.Errorf("failed to dump base: %w", err)
		}
	} else {
		if err := d.dumpRuntime(ctx); err != nil {
			return fmt.Errorf("failed to dump runtime: %w", err)
		}
	}
	if err := d.close(); err != nil {
		return fmt.Errorf("failed to close: %w", err)
	}
	data := d.buf.Bytes()

	// configure aws client
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return fmt.Errorf("failed to load aws config: %w", err)
	}
	svc := s3.NewFromConfig(cfg)

	// upload to s3
	tgzKey := strings.Replace(key, "__ARCH__", arch(), -1)
	if err := upload(ctx, svc, data, bucket, tgzKey, "application/tar+gzip"); err != nil {
		return err
	}

	// calculate sha256
	h := sha256.New()
	h.Write(data)
	sha256sum := fmt.Sprintf("%x", h.Sum(nil))

	// upload to s3
	idx := strings.LastIndex(tgzKey, ".")
	prefix := tgzKey[:idx]
	tgzKey2 := prefix + "/" + sha256sum + ".tgz"
	if err := upload(ctx, svc, data, bucket, tgzKey2, "application/tar+gzip"); err != nil {
		return err
	}

	// upload metadata to s3
	type Metadata struct {
		SHA256SUM string `json:"sha256sum"`
		Key       string `json:"key"`
		URL       string `json:"url"`
	}
	metadata := Metadata{
		SHA256SUM: sha256sum,
		Key:       tgzKey2,
		URL:       fmt.Sprintf("https://%s.s3.amazonaws.com/%s", bucket, tgzKey2),
	}
	jsonData, err := json.Marshal(metadata)
	if err != nil {
		return err
	}
	jsonKey := prefix + ".json"
	if err := upload(ctx, svc, jsonData, bucket, jsonKey, "application/json"); err != nil {
		return err
	}

	log.Println("done")
	return nil
}

func upload(ctx context.Context, svc *s3.Client, data []byte, bucket, key, contentType string) error {
	log.Printf("uploading to s3://%s/%s", bucket, key)
	body := bytes.NewReader(data)
	_, err := svc.PutObject(ctx, &s3.PutObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
		Body:   body,
		ACL:    types.ObjectCannedACLPublicRead,
	})
	if err != nil {
		return fmt.Errorf("failed to put object: %w", err)
	}
	return nil
}

// arch returns AWS Lambda CPU Architecture
func arch() string {
	switch runtime.GOARCH {
	case "amd64":
		return "x86_64"
	case "arm64":
		return "arm64"
	}
	panic("unknown platform: " + runtime.GOARCH)
}

func dumpEnv() error {
	log.Println("dump environment values")
	data, err := json.Marshal(os.Environ())
	if err != nil {
		return err
	}
	log.Println(string(data))
	return nil
}

func dumpProcEnviron() error {
	log.Println("dump /proc/1/environ")
	env, err := os.ReadFile("/proc/1/environ")
	if err != nil {
		return err
	}
	res := []string{}
	for _, v := range bytes.Split(env, []byte{0x00}) {
		res = append(res, string(v))
	}
	data, err := json.Marshal(res)
	if err != nil {
		return err
	}
	log.Println(string(data))
	return nil
}

func dumpCmdline() error {
	log.Println("dump /proc/${pid}/environ")

	proc, err := os.Open("/proc")
	if err != nil {
		return err
	}
	names, _ := proc.Readdirnames(-1)
	filtered := make([]string, 0, len(names))
	for _, name := range names {
		if _, err := strconv.Atoi(name); err != nil {
			continue
		}
		filtered = append(filtered, name)
	}
	sort.Slice(filtered, func(i, j int) bool {
		a, _ := strconv.Atoi(filtered[i])
		b, _ := strconv.Atoi(filtered[j])
		return a < b
	})

	for _, name := range filtered {
		file := filepath.Join("/proc", name, "cmdline")
		cmdline, err := os.ReadFile(file)
		if err != nil {
			continue
		}
		res := []string{}
		for _, v := range bytes.Split(cmdline, []byte{0x00}) {
			res = append(res, string(v))
		}
		data, err := json.Marshal(res)
		if err != nil {
			return err
		}
		log.Println(file, string(data))
	}

	return nil
}

// excludes the directory itself and its contents.
var excludeDirs = []string{
	"/proc",
	"/sys",
	"/dev",
	"/tmp",
}

func isExcludeDir(path string) bool {
	for _, dir := range excludeDirs {
		if path == dir {
			return true
		}
	}
	return false
}

// excludes its contents, but includes the directory itself.
var excludeDirContents = []string{
	"/var/task",
	"/var/runtime",
	"/var/lang",
	"/var/rapid",
	"/opt",
}

func isExcludeDirContents(path string) bool {
	for _, dir := range excludeDirContents {
		if path == dir {
			return true
		}
	}
	return false
}

type dumper struct {
	buf bytes.Buffer
	gw  *gzip.Writer
	tw  *tar.Writer
}

func newDumper() *dumper {
	d := &dumper{}
	d.gw = gzip.NewWriter(&d.buf)
	d.tw = tar.NewWriter(d.gw)
	return d
}

func (d *dumper) close() error {
	var err error
	if err0 := d.tw.Close(); err == nil && err0 != nil {
		err = err0
	}
	if err0 := d.gw.Close(); err == nil && err0 != nil {
		err = err0
	}
	return err
}

type fileInfo struct {
	Path string
	Info fs.FileInfo
}

// dumpBase do the same as the following command.
//
//	tar -cpzf /tmp/foo.tar.gz \
//	    -C / --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp \
//	    --exclude=/var/task/* --exclude=/var/runtime/* --exclude=/var/lang/* --exclude=/var/rapid/* --exclude=/opt/* \
//	    --numeric-owner --ignore-failed-read /
func (d *dumper) dumpBase(ctx context.Context) error {
	// create a list of files to the archive
	files := []fileInfo{}
	err := filepath.Walk("/", func(path string, info fs.FileInfo, err error) error {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}

		// suppress permission error
		if errors.Is(err, os.ErrPermission) {
			return nil
		}
		if err != nil {
			return err
		}

		if info.IsDir() && isExcludeDir(path) {
			return filepath.SkipDir
		}

		// resolv.conf is not reproducible
		if path == "/etc/resolv.conf" {
			return nil
		}

		files = append(files, fileInfo{
			Path: path,
			Info: info,
		})

		if info.IsDir() && isExcludeDirContents(path) {
			return filepath.SkipDir
		}
		return nil
	})
	if err != nil {
		return err
	}

	// sort by path
	slices.SortFunc(files, func(a, b fileInfo) int {
		return strings.Compare(a.Path, b.Path)
	})

	// add files to the archive
	for _, f := range files {
		err := d.addFile(f.Path, f.Info)
		if errors.Is(err, os.ErrPermission) {
			continue
		}
		if err != nil {
			return err
		}
	}
	return nil
}

// dumpRuntime do the same as the following command.
//
//	tar -cpzf /tmp/foo.tar.gz \
//	    --numeric-owner --ignore-failed-read /var/runtime /var/lang /var/rapid
func (d *dumper) dumpRuntime(ctx context.Context) error {
	// create a list of files to the archive
	files := []fileInfo{}
	dirs := []string{
		"/var/runtime",
		"/var/lang",
		"/var/rapid",
	}
	for _, base := range dirs {
		err := filepath.Walk(base, func(path string, info fs.FileInfo, err error) error {
			select {
			case <-ctx.Done():
				return ctx.Err()
			default:
			}

			// suppress permission error
			if errors.Is(err, os.ErrPermission) {
				return nil
			}
			if err != nil {
				return err
			}

			files = append(files, fileInfo{
				Path: path,
				Info: info,
			})
			return nil
		})
		if err != nil {
			return err
		}
	}

	// sort by path
	slices.SortFunc(files, func(a, b fileInfo) int {
		return strings.Compare(a.Path, b.Path)
	})

	// add files to the archive
	for _, f := range files {
		err := d.addFile(f.Path, f.Info)
		if errors.Is(err, os.ErrPermission) {
			continue
		}
		if err != nil {
			return err
		}
	}
	return nil
}

func (d *dumper) addFile(path string, info fs.FileInfo) error {
	if path == "" || path == "/" {
		return nil
	}
	if (info.Mode() & os.ModeSymlink) != 0 {
		return d.addSymlink(path, info)
	}
	if info.IsDir() {
		return d.addDir(path, info)
	}

	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	sys := info.Sys().(*syscall.Stat_t)
	hdr := &tar.Header{
		Typeflag: tar.TypeReg,
		Name:     strings.TrimPrefix(path, "/"),
		Mode:     int64(info.Mode()),
		Size:     info.Size(),
		Uid:      int(sys.Uid),
		Gid:      int(sys.Gid),
		ModTime:  info.ModTime(),
	}
	if err := d.tw.WriteHeader(hdr); err != nil {
		return err
	}
	if _, err := io.Copy(d.tw, f); err != nil {
		return err
	}
	return nil
}

func (d *dumper) addDir(path string, info fs.FileInfo) error {
	sys := info.Sys().(*syscall.Stat_t)
	hdr := &tar.Header{
		Typeflag: tar.TypeDir,
		Name:     strings.TrimPrefix(path, "/"),
		Mode:     int64(info.Mode()),
		Uid:      int(sys.Uid),
		Gid:      int(sys.Gid),
		ModTime:  info.ModTime(),
	}
	if err := d.tw.WriteHeader(hdr); err != nil {
		log.Fatal(err)
	}
	return nil
}

func (d *dumper) addSymlink(path string, info fs.FileInfo) error {
	link, err := os.Readlink(path)
	if err != nil {
		return err
	}
	sys := info.Sys().(*syscall.Stat_t)
	hdr := &tar.Header{
		Typeflag: tar.TypeSymlink,
		Name:     strings.TrimPrefix(path, "/"),
		Linkname: link,
		Mode:     int64(info.Mode()),
		Uid:      int(sys.Uid),
		Gid:      int(sys.Gid),
		ModTime:  info.ModTime(),
	}
	if err := d.tw.WriteHeader(hdr); err != nil {
		return err
	}
	return nil
}

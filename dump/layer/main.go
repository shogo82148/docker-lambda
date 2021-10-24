package main

import (
	"archive/tar"
	"bytes"
	"compress/gzip"
	"context"
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
	"sort"
	"strconv"
	"strings"
	"syscall"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
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

	log.Println("uploading to s3")

	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return fmt.Errorf("failed to load aws config: %w", err)
	}

	data := d.buf.Bytes()
	body := bytes.NewReader(data)

	svc := s3.NewFromConfig(cfg)
	_, err = svc.PutObject(ctx, &s3.PutObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
		Body:   body,
	})
	if err != nil {
		return fmt.Errorf("failed to put object: %w", err)
	}

	log.Println("done")
	return nil
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

var excludeDirs = []string{
	"/proc",
	"/sys",
	"/dev",
	"/tmp",
	"/var/task",
	"/var/runtime",
	"/var/lang",
	"/var/rapid",
	"/opt",
}

func isExcludeDir(path string) bool {
	for _, dir := range excludeDirs {
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

// dumpBase do the same as the following command.
//
//     tar -cpzf /tmp/foo.tar.gz \
//         -C / --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp \
//         --exclude=/var/task/* --exclude=/var/runtime/* --exclude=/var/lang/* --exclude=/var/rapid/* --exclude=/opt/* \
//         --numeric-owner --ignore-failed-read /
func (d *dumper) dumpBase(ctx context.Context) error {
	return filepath.Walk("/", func(path string, info fs.FileInfo, err error) error {
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
		err = d.addFile(path, info)
		if errors.Is(err, os.ErrPermission) {
			return nil
		}
		return err
	})
}

// dumpRuntime do the same as the following command.
//
//     tar -cpzf /tmp/foo.tar.gz \
//         --numeric-owner --ignore-failed-read /var/runtime /var/lang /var/rapid
func (d *dumper) dumpRuntime(ctx context.Context) error {
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

			err = d.addFile(path, info)
			if errors.Is(err, os.ErrPermission) {
				return nil
			}
			return err
		})
		if err != nil {
			return err
		}
	}
	return nil
}

func (d *dumper) addFile(path string, info fs.FileInfo) error {
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
	}
	if err := d.tw.WriteHeader(hdr); err != nil {
		return err
	}
	return nil
}

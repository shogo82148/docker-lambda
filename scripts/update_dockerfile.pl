#!/usr/bin/env perl

use v5.40;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;
use JSON;

my $runtime = $ARGV[0] or croak "Usage: $0 RUNTIME";
my $basedir = "$FindBin::Bin/../dockerfiles/$runtime";

sub slurp($file) {
    local $/;
    open my $fh, "<", $file or die "Can't open $file: $!";
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub spew($file, $content) {
    open my $fh, ">", "$file.tmp$$" or die "failed to open $file: $!";
    print $fh $content;
    close $fh or die "failed to close $file: $!";
    rename "$file.tmp$$", $file or die "failed to rename $file.tmp$$ to $file: $!";
}

# update_archive updates the archive URL of the runtime.
sub update_archive($name, $arch) {
    # fetch the latest version of the archive url.
    my $url = `curl -sSL --retry 3 'https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$arch/$runtime.json' | jq -r .url`;
    if (!$url) {
        die "failed to get the metadata of $runtime";
    }
    chomp $url;

    say STDERR "updating $name to $url";

    # update dockerfiles
    my $dockerfile_build = slurp("$basedir/build/Dockerfile");
    $dockerfile_build =~ s/^ENV $name=.*$/ENV $name=$url/gm;
    spew("$basedir/build/Dockerfile", $dockerfile_build);

    my $dockerfile_run = slurp("$basedir/run/Dockerfile");
    $dockerfile_run =~ s/^ENV $name=.*$/ENV $name=$url/gm;
    spew("$basedir/run/Dockerfile", $dockerfile_run);

    # dump the file list
    say STDERR "dumping file list of $url";
    system("curl -sSL --retry 3 '$url' | tar -tz | sort > $basedir/fs-$arch.txt");
    if ($? != 0) {
        die "failed to dump the file list of $runtime";
    }
}

sub dump_packages($arch, $image, $command) {
    # fetch the latest version of the archive url.
    my $url = `curl -sSL --retry 3 'https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$arch/$runtime.json' | jq -r .url`;
    if (!$url) {
        die "failed to get the metadata of $runtime";
    }
    chomp $url;

    my $platform = $arch eq "x86_64" ? "linux/amd64" : "linux/arm64";

    # dump the package list
    say STDERR "dumping package list of $url";
    system("rm -rf $basedir/.tmp");
    system("mkdir $basedir/.tmp");
    chdir "$basedir/.tmp" or die "Can't chdir to $runtime/.tmp: $!";

    system("curl -sSL --retry 3 -o base.tgz '$url'");
    if ($? != 0) {
        die "failed to dump the package list of $runtime";
    }
    system("tar xzf base.tgz --strip-components=2 -- var/lib/rpm");
    system(
        "docker run " .
        "--rm " .
        "-v '$basedir/.tmp/rpm':/rpm " .
        "--platform $platform $image $command " .
        "| grep -v ^gpg-pubkey- | sort > $basedir/packages-$arch.txt"
    );

    chdir "$basedir" or die "Can't chdir to $runtime: $!";
}

# update_image updates the base image of the runtime.
sub update_image($runtime, $variant, $image, $tag) {
    my $version = `gh api --jq '[.[].ref] | sort | last' /repos/shogo82148/docker-lambda/git/matching-refs/tags/$runtime-$variant/ | cut -d/ -f4`;
    if ($version !~ /^[0-9.]+$/) {
        die "failed to get the metadata of $runtime";
    }
    chomp $version;

    say STDERR "updating $runtime-$variant to $version";

    my $dockerfile_build = slurp("$basedir/build/Dockerfile");
    $dockerfile_build =~ s(^FROM ghcr.io/shogo82148/lambda-$image:$tag[.][0-9.]+$)(FROM ghcr.io/shogo82148/lambda-$image:$tag.$version)gm;
    spew("$basedir/build/Dockerfile", $dockerfile_build);

    my $dockerfile_run = slurp("$basedir/run/Dockerfile");
    $dockerfile_run =~ s(^FROM ghcr.io/shogo82148/lambda-$image:$tag[.][0-9.]+$)(FROM ghcr.io/shogo82148/lambda-$image:$tag.$version)gm;
    spew("$basedir/run/Dockerfile", $dockerfile_run);
}

sub update_init() {
    my $version = `gh release view --repo shogo82148/docker-lambda-init --template '{{ .tagName }}' --json tagName`;
    if ($version !~ /^v[0-9.]+$/) {
        die "failed to get the metadata of docker-lambda-init";
    }
    chomp $version;

    say STDERR "updating docker-lambda-init to $version";
    $version =~ s/^v//;

    my $dockerfile_build = slurp("$basedir/build/Dockerfile");
    $dockerfile_build =~ s(^ENV DOCKER_LAMBDA_INIT_VERSION=.*$)(ENV DOCKER_LAMBDA_INIT_VERSION=$version)gm;
    spew("$basedir/build/Dockerfile", $dockerfile_build);

    my $dockerfile_run = slurp("$basedir/run/Dockerfile");
    $dockerfile_run =~ s(^ENV DOCKER_LAMBDA_INIT_VERSION=.*$)(ENV DOCKER_LAMBDA_INIT_VERSION=$version)gm;
    spew("$basedir/run/Dockerfile", $dockerfile_run);
}

chdir $basedir or die "Can't chdir to $runtime: $!";
my $script = slurp("$basedir/update.pl");
eval $script;
if ($@) {
    die "failed to update $runtime: $@";
}

#!/usr/bin/env perl

use v5.40;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;

sub docker {
    my @args = @_;
    say STDERR "docker @args";
    if (system('docker', @args) == 0) {
        return;
    }
    say STDERR "failed to build, try...";
    sleep(5);
    if (system('docker', @args) == 0) {
        return;
    }
    say STDERR "failed to build, try...";
    sleep(10);
    if (system('docker', @args) == 0) {
        return;
    }
    croak 'gave up, failed to run docker';
}

my $registry = $ARGV[0];
my $tag = $ARGV[1];

chdir "$FindBin::Bin/..";

docker(
    "tag",
    "$tag-x86_64",
    "$registry/$tag-x86_64",
);

docker(
    "tag",
    "$tag-arm64",
    "$registry/$tag-arm64",
);

my $ref = $ENV{GITHUB_REF} || '';
if ($ref !~ m(^refs/tags/[^/]+/(.*))) {
    say STDERR "skip, '$ref' is not a tag";
    exit 0;
}
my $version = $1;

# push the images for all architectures
docker(
    "push",
    "$registry/$tag-x86_64",
);
docker(
    "push",
    "$registry/$tag-arm64",
);

# create and push the manifest
docker(
    "manifest",
    "create",
    "$registry/$tag",
    "$registry/$tag-x86_64",
    "$registry/$tag-arm64",
);
docker(
    "manifest",
    "push",
    "$registry/$tag",
);

# create and push the images for the version
docker(
    "tag",
    "$tag-x86_64",
    "$registry/$tag.$version-x86_64",
);
docker(
    "push",
    "$registry/$tag.$version-x86_64",
);

docker(
    "tag",
    "$tag-arm64",
    "$registry/$tag.$version-arm64",
);
docker(
    "push",
    "$registry/$tag.$version-arm64",
);

# create and push the manifest for the version
docker(
    "manifest",
    "create",
    "$registry/$tag.$version",
    "$registry/$tag.$version-x86_64",
    "$registry/$tag.$version-arm64",
);
docker(
    "manifest",
    "push",
    "$registry/$tag.$version",
);

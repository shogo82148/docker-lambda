#!/usr/bin/env perl

use 5.38.0;
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

my $ref = $ENV{GITHUB_REF} || '';
if ($ref !~ m(^refs/tags/[^/]+/(.*))) {
    say STDERR "skip, '$ref' is not a tag";
    exit 0;
}
my $version = $1;

chdir "$FindBin::Bin/..";

docker(
    "tag",
    $tag,
    "$registry/$tag",
);
docker(
    "push",
    "$registry/$tag",
);

docker(
    "tag",
    $tag,
    "$registry/$tag.$version",
);
docker(
    "push",
    "$registry/$tag.$version",
);

#!/usr/bin/env perl

use v5.40;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;
use JSON;

sub slurp($file) {
    local $/;
    open my $fh, "<", $file or die "Can't open $file: $!";
    my $content = <$fh>;
    close $fh;
    return $content;
}

my $template = slurp("$FindBin::Bin/template.yml");

my $runtimes = [
    "base.al2",
    "base.al2023",

    "dotnet6",
    "dotnet8",

    "java8.al2",
    "java11",
    "java17",
    "java21",
    "java25",

    "nodejs18.x",
    "nodejs20.x",
    "nodejs22.x",

    "python3.8",
    "python3.9",
    "python3.10",
    "python3.11",
    "python3.12",
    "python3.13",
    "python3.14",

    "ruby3.2",
    "ruby3.3",
    "ruby3.4",

    "provided.al2",
    "provided.al2023",
];

for my $runtime (@$runtimes) {
    for my $variant (qw/run build/) {
        my $workflow = $template;
        $workflow =~ s/__RUNTIME__/$runtime/g;
        $workflow =~ s/__VARIANT__/$variant/g;

        open my $fh, ">:utf8", "$FindBin::Bin/../.github/workflows/$runtime-$variant.yml" or die "Can't open $runtime-$variant.yml: $!";
        print $fh $workflow;
        close $fh;
    }
}

#!/usr/bin/env perl

use 5.38.0;
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
    "base",
    "base.al2",
    "base.al2023",
    "dotnet6",
    "go1.x",
    "java8",
    "java8.al2",
    "java11",
    "java17",
    "nodejs14.x",
    "nodejs16.x",
    "nodejs18.x",
    "python3.7",
    "python3.8",
    "python3.9",
    "python3.10",
    "python3.11",
    "ruby2.7",
    "ruby3.2",
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

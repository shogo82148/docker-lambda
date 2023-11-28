#!/usr/bin/env perl

use 5.38.0;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;
use JSON;
use Time::Piece;

sub new_tag($dic, $dist) {
    my $utc_time = Time::Piece->new()->gmtime();
    my $tag = sprintf("%s-%s/%04d.%02d.%02d", $dic, $dist, $utc_time->year, $utc_time->mon, $utc_time->mday);
    say "New tag: $tag";
    system("git", "tag", $tag);
    system("git", "push", "origin", $tag);
}

chdir "$FindBin::Bin/../dockerfiles" or die "failed to chdir: $!";
my $runtimes = [glob "*"];

for my $runtime(@$runtimes) {
    for my $variant(qw/build run/) {
        my $context = "$runtime/$variant";
        unless (-d $context) {
            next;
        }

        my $latest = `git tag --sort -v:refname --list '$runtime-$variant/*' | head -n 1`;
        chomp $latest;
        unless ($latest) {
            new_tag($runtime, $variant);
            next;
        }

        my $exit_code = system("git", "diff", "--exit-code", "--quiet", $latest, "HEAD", "--", $context);
        if ($exit_code != 0) {
            new_tag($runtime, $variant);
            next;
        }
    }
}

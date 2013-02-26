#!perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use Test::More tests => 10;

use lib 't';
use Util;

use File::Next;

my @sorted_swamp = qw(
    t/swamp/0
    t/swamp/Makefile
    t/swamp/Makefile.PL
    t/swamp/a/a1
    t/swamp/a/a2
    t/swamp/b/b1
    t/swamp/b/b2
    t/swamp/c/c1
    t/swamp/c/c2
    t/swamp/c-header.h
    t/swamp/c-source.c
    t/swamp/javascript.js
    t/swamp/parrot.pir
    t/swamp/perl-test.t
    t/swamp/perl-without-extension
    t/swamp/perl.pl
    t/swamp/perl.pm
    t/swamp/perl.pod
);
my @msorted_files = qw(
    mtime_sort/z
    mtime_sort/o
    mtime_sort/a
    mtime_sort/h
);
foreach my $msorted_file (@msorted_files) {
    unlink("$Bin/$msorted_file");
}

SORT_BOOLEAN: {
    my $iter = File::Next::files( { sort_files => 1 }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = @sorted_swamp;

    sets_match( \@actual, \@expected, 'SORT_BOOLEAN' );
}

SORT_STANDARD: {
    my $iter = File::Next::files( { sort_files => \&File::Next::sort_standard }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = @sorted_swamp;

    sets_match( \@actual, \@expected, 'SORT_STANDARD' );
}

SORT_REVERSE: {
    my $iter = File::Next::files( { sort_files => \&File::Next::sort_reverse }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = reverse @sorted_swamp;

    sets_match( \@actual, \@expected, 'SORT_REVERSE' );
}

## create files for mtime
diag("Test mtime sort");
mkdir("$Bin/mtime_sort") unless -d "$Bin/mtime_sort";
foreach my $msorted_file (@msorted_files) {
    open(my $fh, '>', "$Bin/$msorted_file"); print $fh rand(); close($fh);
    sleep 1;
}

SORT_MTIME_STANDARD: {
    my $iter = File::Next::files( { sort_files => \&File::Next::sort_mtime_standard }, "$Bin/mtime_sort" );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    @msorted_files = map { "$Bin/$_" } @msorted_files;
    my @expected = @msorted_files;

    sets_match( \@actual, \@expected, 'SORT_MTIME_STANDARD' );
}

SORT_MTIME_REVERSE: {
    my $iter = File::Next::files( { sort_files => \&File::Next::sort_mtime_reverse }, "$Bin/mtime_sort" );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = reverse @msorted_files;

    sets_match( \@actual, \@expected, 'SORT_MTIME_REVERSE' );
}
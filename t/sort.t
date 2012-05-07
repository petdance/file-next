#!perl -T

use strict;
use warnings;
use Test::More tests => 6;

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

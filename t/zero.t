#!perl -T

use strict;
use warnings;
use Test::More tests => 2;

use lib 't';
use Util;

use File::Next;

# NOTE!  This block does a chdir.  If you add more tests after it, you
# may be sorry.

HANDLE_ZEROES: {
    chdir 't/swamp' or die "chdir failed: $!";
    my $iter = File::Next::files( '.' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        0
        a/a1
        a/a2
        b/b1
        b/b2
        c/c1
        c/c2
        c-header.h
        c-source.c
        javascript.js
        Makefile
        Makefile.PL
        parrot.pir
        perl-test.t
        perl-without-extension
        perl.pl
        perl.pm
        perl.pod
    );

    sets_match( \@actual, \@expected, 'HANDLE_ZEROES' );
}

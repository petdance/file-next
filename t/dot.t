#!perl -T

use strict;
use warnings;
use Test::More tests => 3;

use lib 't';
use Util;

BEGIN {
    use_ok( 'File::Next' );
}

NO_PARMS: {
    chdir( 't' );
    my $iter = File::Next::files( '.' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        00-load.t
        api.t
        basic.t
        dirs.t
        dot.t
        everything.t
        follow.t
        give-me-a-process-pipe.pl
        methods.t
        parms.t
        pod-coverage.t
        pod.t
        process-substitution.t
        sort.t
        Util.pm
        zero.t
        swamp/a/a1
        swamp/a/a2
        swamp/b/b1
        swamp/b/b2
        swamp/c/c1
        swamp/c/c2
        swamp/c-header.h
        swamp/c-source.c
        swamp/javascript.js
        swamp/0
        swamp/Makefile
        swamp/Makefile.PL
        swamp/parrot.pir
        swamp/perl-test.t
        swamp/perl-without-extension
        swamp/perl.pl
        swamp/perl.pm
        swamp/perl.pod
    );

    sets_match( \@actual, \@expected, 'NO_PARMS' );
}

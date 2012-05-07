#!perl -T

use strict;
use warnings;
use Test::More tests => 10;

use lib 't';
use Util;

use File::Next;

# use Test::Differences;
# eq_or_diff \@got, [qw( a b c )], "testing arrays";

JUST_A_FILE: {
    my $iter = File::Next::files( 't/pod.t' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = qw(
        t/pod.t
    );
    sets_match( \@actual, \@expected, 'JUST_A_FILE' );
}

NO_PARMS: {
    my $iter = File::Next::files( 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/swamp/0
        t/swamp/Makefile
        t/swamp/Makefile.PL
        t/swamp/c-header.h
        t/swamp/c-source.c
        t/swamp/javascript.js
        t/swamp/parrot.pir
        t/swamp/perl-test.t
        t/swamp/perl-without-extension
        t/swamp/perl.pl
        t/swamp/perl.pm
        t/swamp/perl.pod
        t/swamp/a/a1
        t/swamp/a/a2
        t/swamp/b/b1
        t/swamp/b/b2
        t/swamp/c/c1
        t/swamp/c/c2
    );

    sets_match( \@actual, \@expected, 'NO_PARMS' );
}

MULTIPLE_STARTS: {
    my $iter = File::Next::files( 't/swamp/a', 't/swamp/b', 't/swamp/c' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/swamp/a/a1
        t/swamp/a/a2
        t/swamp/b/b1
        t/swamp/b/b2
        t/swamp/c/c1
        t/swamp/c/c2
    );

    sets_match( \@actual, \@expected, 'MULTIPLE_STARTS' );
}

NO_DESCEND: {
    my $iter = File::Next::files( {descend_filter => sub {0}}, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/swamp/0
        t/swamp/Makefile
        t/swamp/Makefile.PL
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

    sets_match( \@actual, \@expected, 'NO_DESCEND' );
}


ONLY_FILES_WITH_AN_EXTENSION: {
    my $file_filter = sub {
        return /^[^.].*\./;
    };

    my $iter = File::Next::files( {file_filter => $file_filter}, 't/swamp' );
    isa_ok( $iter, 'CODE' );


    my @actual = slurp( $iter );

    my @expected = qw(
        t/swamp/Makefile.PL
        t/swamp/c-header.h
        t/swamp/c-source.c
        t/swamp/javascript.js
        t/swamp/parrot.pir
        t/swamp/perl-test.t
        t/swamp/perl.pl
        t/swamp/perl.pm
        t/swamp/perl.pod
    );

    sets_match( \@actual, \@expected, 'ONLY_FILES_WITH_AN_EXTENSION' );
}


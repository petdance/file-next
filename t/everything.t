#!perl -T

use strict;
use warnings;

use Test::More tests => 4;

use lib 't';
use Util;

use File::Next;

NO_PARMS: {
    my $iter = File::Next::everything( 't/' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/
        t/00-load.t
        t/api.t
        t/basic.t
        t/dirs.t
        t/dot.t
        t/everything.t
        t/filelist.txt
        t/filelist-nul.txt
        t/first-and-last-lines-via-process-pipe.pl
        t/follow.t
        t/from_file.t
        t/from_stdin.t
        t/methods.t
        t/named-pipe.t
        t/parms.t
        t/pod-coverage.t
        t/pod.t
        t/sort.t
        t/stdin-iterator.pl
        t/swamp
        t/swamp/0
        t/swamp/a
        t/swamp/a/a1
        t/swamp/a/a2
        t/swamp/b
        t/swamp/b/b1
        t/swamp/b/b2
        t/swamp/c
        t/swamp/c/c1
        t/swamp/c/c2
        t/swamp/c-header.h
        t/swamp/c-source.c
        t/swamp/javascript.js
        t/swamp/Makefile
        t/swamp/Makefile.PL
        t/swamp/parrot.pir
        t/swamp/perl-test.t
        t/swamp/perl-without-extension
        t/swamp/perl.pl
        t/swamp/perl.pm
        t/swamp/perl.pod
        t/Util.pm
        t/zero.t
    );

    sets_match( \@actual, \@expected, 'NO_PARMS' );
}

FILTERED: {
    my $file_filter = sub {
        # Arbitrary filter: "z" anywhere, ends in "b" or digit
        return $File::Next::name =~ /(z|b$|\d$)/;
    };

    my $iter = File::Next::everything( {file_filter => $file_filter}, 't/' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/swamp/0
        t/swamp/a/a1
        t/swamp/a/a2
        t/swamp/b
        t/swamp/b/b1
        t/swamp/b/b2
        t/swamp/c/c1
        t/swamp/c/c2
        t/zero.t
    );

    sets_match( \@actual, \@expected, 'NO_PARMS' );
}

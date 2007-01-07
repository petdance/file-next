#!perl -T

use strict;
use warnings;
use Test::More tests => 3;

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
        follow.t
        parms.t
        pod-coverage.t
        pod.t
        sort.t
        swamp/a/a1
        swamp/a/a2
        swamp/b/b1
        swamp/b/b2
        swamp/c/c1
        swamp/c/c2
        swamp/c-header.h
        swamp/c-source.c
        swamp/javascript.js
        swamp/Makefile
        swamp/Makefile.PL
        swamp/parrot.pir
        swamp/perl-test.t
        swamp/perl-without-extension
        swamp/perl.pl
        swamp/perl.pm
        swamp/perl.pod
    );

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _sets_match( \@actual, \@expected, 'NO_PARMS' );
}

sub slurp {
    my $iter = shift;
    my @files;

    while ( my $file = $iter->() ) {
        push( @files, $file );
    }
    return @files;
}

sub _sets_match {
    my @actual = @{+shift};
    my @expected = @{+shift};
    my $msg = shift;

    # Normalize all the paths
    for my $path ( @expected, @actual ) {
        $path = File::Next::reslash( $path );
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic
    return is_deeply( [sort @actual], [sort @expected], $msg );
}



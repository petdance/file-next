#!perl -T

use strict;
use warnings;
use Test::More tests => 7;

BEGIN {
    use_ok( 'File::Next' );
}

my @sorted_swamp = qw(
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

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _lists_match( \@actual, \@expected, 'SORT_BOOLEAN' );
}

SORT_STANDARD: {
    my $iter = File::Next::files( { sort_files => \&File::Next::sort_standard }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = @sorted_swamp;

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _lists_match( \@actual, \@expected, 'SORT_STANDARD' );
}

SORT_REVERSE: {
    my $iter = File::Next::files( { sort_files => \&File::Next::sort_reverse }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = reverse @sorted_swamp;

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _lists_match( \@actual, \@expected, 'SORT_REVERSE' );
}

sub slurp {
    my $iter = shift;
    my @files;

    while ( my $file = $iter->() ) {
        push( @files, $file );
    }
    return @files;
}


sub _lists_match {
    my @actual = @{+shift};
    my @expected = @{+shift};
    my $msg = shift;

    # Normalize all the paths
    for my $path ( @expected, @actual ) {
        $path = File::Next::reslash( $path );
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic
    return is_deeply( \@actual, \@expected, $msg );
}

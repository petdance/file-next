#!perl

use strict;
use warnings;
use Test::More tests => 5;

BEGIN {
    use_ok( 'File::Next' );
}

SORT_BOOLEAN: {
    my $iter = File::Next::files( { sort_files => 1 }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
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

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _lists_match( \@expected, \@actual, 'SORT_BOOLEAN' );
}

sub sort_reverse($$) { $_[0]->[1] cmp $_[1]->[1] };

SORT_REVERSE: {
    my $iter = File::Next::files( { sort_files => \&sort_reverse }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/swamp/perl.pod
        t/swamp/perl.pm
        t/swamp/perl.pl
        t/swamp/perl-without-extension
        t/swamp/perl-test.t
        t/swamp/parrot.pir
        t/swamp/javascript.js
        t/swamp/c/c2
        t/swamp/c/c1
        t/swamp/c-source.c
        t/swamp/c-header.h
        t/swamp/b/b2
        t/swamp/b/b1
        t/swamp/a/a2
        t/swamp/a/a1
        t/swamp/Makefile.PL
        t/swamp/Makefile
    );

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    is_deeply( \@expected, \@actual, 'SORT_REVERSE' );
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
    my @expected = @{+shift};
    my @actual = @{+shift};
    my $msg = shift;

    # Normalize all the paths
    for my $path ( @expected, @actual ) {
        $path = File::Next::_reslash( $path );
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic
    return is_deeply( \@expected, \@actual, $msg );
}

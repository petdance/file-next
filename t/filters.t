#!perl

use strict;
use warnings;
use Test::More tests => 3;

BEGIN {
    use_ok( 'File::Next' );
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

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    is_deeply( [sort @expected], [sort @actual] );
}


sub slurp {
    my $iter = shift;
    my @files;

    while ( my $file = $iter->() ) {
        push( @files, $file );
    }
    return @files;
}

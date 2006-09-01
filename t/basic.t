#!perl

use strict;
use warnings;
use Test::More tests => 11;

use Carp;

$SIG{__WARN__} = \&Carp;

BEGIN {
    use_ok( 'File::Next' );
}

# use Test::Differences;
# eq_or_diff \@got, [qw( a b c )], "testing arrays";

JUST_A_FILE: {
    my $iter = File::Next::files( 't/pod.t' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = qw(
        t/pod.t
    );
    _sets_match( \@expected, \@actual, 'JUST_A_FILE' );
}

NO_PARMS: {
    my $iter = File::Next::files( 't/swamp' );
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
    _sets_match( \@expected, \@actual, 'NO_PARMS' );
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

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _sets_match( \@expected, \@actual, 'MULTIPLE_STARTS' );
}

NO_DESCEND: {
    my $iter = File::Next::files( {descend_filter => sub {0}}, 't/swamp' );
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
    );

    _sets_match( \@expected, \@actual, 'NO_DESCEND' );
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
    _sets_match( \@expected, \@actual, 'ONLY_FILES_WITH_AN_EXTENSION' );
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
    my @expected = sort @{+shift};
    my @actual = sort @{+shift};
    my $msg = shift;

    for my $path ( @expected ) {
        my @parts = split /\//, $path;
        my $path = File::Spec->catfile( @parts );
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    is_deeply( [@expected], [@actual], $msg );
}

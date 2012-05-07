#!perl

use strict;
use warnings;
use Test::More;

use lib 't';
use Util;

use File::Next;

if ( ! eval { symlink('',''); 1 } ) {
    plan skip_all => 'System does not support symlinks.';
}

plan tests => 6;

my %links = (
    't/swamp/linkfile' => 'Makefile',
    't/swamp/linkdir'  => 'a',
);

for my $link ( sort keys %links ) {
    my $file = $links{$link};
    unlink( $link );
    symlink( $file, $link ) or die "Unable to create symlink $file: $!";
}

my @realfiles = qw(
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

my @symlinkage = qw(
    t/swamp/linkfile
    t/swamp/linkdir/a1
    t/swamp/linkdir/a2
);

DEFAULT: {
    my $iter = File::Next::files( 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = ( @realfiles, @symlinkage );

    sets_match( \@actual, \@expected, 'DEFAULT' );
}

NO_FOLLOW: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = ( @realfiles );

    sets_match( \@actual, \@expected, 'NO_FOLLOW' );
}

NO_FOLLOW_STARTING_WITH_A_SYMLINK: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, 't/swamp/linkdir' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = grep { /linkdir/ } @symlinkage;

    sets_match( \@actual, \@expected, 'NO_FOLLOW_STARTING_WITH_A_SYMLINK' );
}

END {
    unlink( keys %links );
}

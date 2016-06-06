#!perl -T

use strict;
use warnings;
use Test::More;

use lib 't';
use Util;

use File::Next;

use File::Temp qw( tempdir );
use File::Copy;

if ( ! eval { symlink('',''); 1 } ) {
    plan skip_all => 'System does not support symlinks.';
}

plan tests => 6;


# Files to copy out of the swamp into the tempdir.
my @samplefiles = qw(
    0
    c-header.h
    c-source.c
    javascript.js
    Makefile
);

# Create a mini-swamp in the temp directory.
my $tempdir = tempdir( CLEANUP => 1 );
diag "t/follow.t is working with temp directory $tempdir";
mkdir "$tempdir/dir" or die;
for my $filename ( qw( a1 a2 ) ) {
    my $tempfilename = "$tempdir/dir/$filename";
    open( my $fh, '>', $tempfilename ) or die "$tempfilename: $!";
    close $fh or die $!;
    push( @samplefiles, "dir/$filename" );
}

my @realfiles;
for my $file ( @samplefiles ) {
    my $tempfile = "$tempdir/$file";
    copy( "t/swamp/$file", $tempfile );
    push( @realfiles, $tempfile );
}

my %links = (
    "$tempdir/linkfile" => "$tempdir/Makefile",
    "$tempdir/linkdir"  => "$tempdir/dir",
);

for my $link ( sort keys %links ) {
    my $file = $links{$link};
    unlink( $link );
    symlink( $file, $link ) or die "Unable to create symlink $file: $!";
}

my @symlinkage = (
    "$tempdir/linkfile",
    "$tempdir/linkdir/a1",
    "$tempdir/linkdir/a2",
);

DEFAULT: {
    my $iter = File::Next::files( $tempdir );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = ( @realfiles, @symlinkage );

    sets_match( \@actual, \@expected, 'DEFAULT' );
}

NO_FOLLOW: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, $tempdir );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = ( @realfiles );

    sets_match( \@actual, \@expected, 'NO_FOLLOW' );
}

NO_FOLLOW_STARTING_WITH_A_SYMLINK: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, "$tempdir/linkdir" );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = grep { /linkdir/ } @symlinkage;

    sets_match( \@actual, \@expected, 'NO_FOLLOW_STARTING_WITH_A_SYMLINK' );
}

END {
    unlink( keys %links );
}

#!perl -T

use strict;
use warnings;
use Test::More;

use lib 't';
use Util;

use File::Next;

use File::Temp qw( tempdir );
use File::Copy;
use File::Spec;

if ( ( $^O eq 'MSWin32' ) or ( ! eval { symlink('',''); 1 } ) ) {
    plan skip_all => "OS $^O does not support symlinks.";
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
my $test_location = File::Spec->catfile('t', 'follow.t');
note "$test_location is working with temp directory $tempdir";

my $sub_dir = 'dir';
my $sub_temp_dir = File::Spec->catdir($tempdir, $sub_dir);
mkdir $sub_temp_dir or die "Failed to create $sub_temp_dir: $!";

for my $filename ( qw( a1 a2 ) ) {
    my $tempfilename = File::Spec->catfile($sub_temp_dir, $filename);
    open( my $fh, '>', $tempfilename ) or die "Cannot create $tempfilename: $!";
    close $fh or die $!;
    push( @samplefiles, File::Spec->catfile($sub_dir, $filename ));
}

my @realfiles;
for my $file ( @samplefiles ) {
    my $tempfile = File::Spec->catfile($tempdir, $file);
    copy( File::Spec->catfile('t', 'swamp', $file), $tempfile );
    push( @realfiles, $tempfile );
}

my %links = (
    File::Spec->catfile($tempdir, 'linkfile') => File::Spec->catfile($tempdir, 'Makefile'),
    File::Spec->catfile($tempdir, 'linkdir')  => File::Spec->catdir($tempdir, 'dir'),
);

for my $link ( sort keys %links ) {
    my $file = $links{$link};
    unlink( $link );
    symlink( $file, $link ) or die "Unable to create symlink $link for $file: $!";
}

my @symlinkage = (
    File::Spec->catfile($tempdir, 'linkfile'),
    File::Spec->catfile($tempdir, 'linkdir', 'a1'),
    File::Spec->catfile($tempdir, 'linkdir', 'a2'),
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

my $linkdir_regex = qr/linkdir/;

NO_FOLLOW_STARTING_WITH_A_SYMLINK: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, File::Spec->catdir($tempdir, 'linkdir' ));
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = grep { $linkdir_regex } @symlinkage;

    sets_match( \@actual, \@expected, 'NO_FOLLOW_STARTING_WITH_A_SYMLINK' );
}

END {
    unlink( keys %links );
}

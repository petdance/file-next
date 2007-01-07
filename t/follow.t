#!perl

use strict;
use warnings;
use Test::More;

BEGIN {
    eval { symlink('',''); 1 } or
        plan skip_all => 'System does not support symlinks.';
}

BEGIN {
    plan tests => 6;
    use_ok( 'File::Next' );
}

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

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _sets_match( \@actual, \@expected, 'DEFAULT' );
}

NO_FOLLOW: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = ( @realfiles );

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _sets_match( \@actual, \@expected, 'NO_FOLLOW' );
}

NO_FOLLOW_STARTING_WITH_A_SYMLINK: {
    my $iter = File::Next::files( { follow_symlinks => 0 }, 't/swamp/linkdir' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    my @expected = grep { /linkdir/ } @symlinkage;

    @actual = grep { !/\.svn/ } @actual; # If I'm building this in my Subversion dir
    _sets_match( \@actual, \@expected, 'NO_FOLLOW_STARTING_WITH_A_SYMLINK' );
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

    #use Test::Differences;
    #return eq_or_diff( [sort @actual], [sort @expected], $msg );

    local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic
    return is_deeply( [sort @actual], [sort @expected], $msg );
}


END {
    unlink( keys %links );
}

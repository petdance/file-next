#!perl -T

use strict;
use warnings;
use Test::More tests => 3;

BEGIN {
    use_ok( 'File::Next' );
}

NO_PARMS: {
    my $iter = File::Next::dirs( 't/' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );

    my @expected = qw(
        t/
        t/swamp/
        t/swamp/a/
        t/swamp/b/
        t/swamp/c/
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

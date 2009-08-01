#!perl -T

use strict;
use warnings;
use Test::More tests => 3;

use lib 't';
use Util;

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

    sets_match( \@actual, \@expected, 'NO_PARMS' );
}

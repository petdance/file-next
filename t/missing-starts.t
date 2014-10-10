#!perl -T

use strict;
use warnings;
use Test::More tests => 4;

use lib 't';
use Util;

use File::Next;

CHECK_MISSING_START_FILES: {
    ok( !-e '-', 'tests require missing file named "-" in cwd' );

    my $iter = File::Next::files( {}, '-' );
    my $file = $iter->();
    is( $file, '-', 'returns single missing start' );

    ok( !-e '-', 'test requires missing t/swamp/404' );
    my @expected = ('-', 't/swamp/404');
    $iter = File::Next::files( {}, @expected );
    my @actual = slurp( $iter );
    # order is important for this test, hence is_deeply instead of sets_match
    is_deeply( \@actual, \@expected, 'returns multiple missing starts' );
}

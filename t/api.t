#!perl -T

use strict;
use warnings;
use Test::More tests => 11;

BEGIN {
    use_ok( 'File::Next' );
}

CHECK_FILE_FILTER: {
    my $file_filter = sub {
        ok( defined $_, '$_ defined' );
        is( $File::Next::dir, 't/swamp', '$File::Next::dir' );
        is( $File::Next::name, "t/swamp/$_" );
    };

    my $iter = File::Next::files( {file_filter => $file_filter}, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    my $file = $iter->();
    like( $file, qr{^t/swamp/}, 'Reasonable filename returned' );

    my $dir;
    ($dir,$file) = $iter->();
    is( $dir, 't/swamp', 'Correct $dir' );
    unlike( $file, qr{/}, '$file should not have any slash' );
}

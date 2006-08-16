#!perl -T

use strict;
use warnings;
use Test::More tests => 18;

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

    # Return filename in scalar mode
    my $file = $iter->();
    like( $file, qr{^t/swamp/.+}, 'Reasonable filename returned' );

    # Return $dir and $file in list mode
    my $dir;
    ($dir,$file) = $iter->();
    is( $dir, 't/swamp', 'Correct $dir' );
    unlike( $file, qr{/}, '$file should not have any slash' );
}

CHECK_DESCEND_FILTER: {
    my $descend_filter = sub {
        ok( defined $_, '$_ defined' );
        like( $File::Next::dir, qr{^t/swamp}, '$File::Next::dir' );
    };

    my $iter = File::Next::files( {descend_filter => $descend_filter}, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    while ( $iter->() ) {
        # Do nothing, just calling the descend 
    }
}

#!perl -T

use strict;
use warnings;
use Test::More tests => 18;

use lib 't';
use Util;

BEGIN {
    use_ok( 'File::Next' );
}

CHECK_FILE_FILTER: {
    my $file_filter = sub {
        ok( defined $_, '$_ defined' );
        is( $File::Next::dir, reslash( 't/swamp' ), '$File::Next::dir' );
        is( $File::Next::name, reslash( "t/swamp/$_" ) );
    };

    my $iter = File::Next::files( {file_filter => $file_filter}, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    # Return filename in scalar mode
    my $file = $iter->();
    my $swamp = reslash( 't/swamp' );
    like( $file, qr{^\Q$swamp\E.+}, 'swamp filename returned' );

    # Return $dir and $file in list mode
    my $dir;
    ($dir,$file) = $iter->();
    is( $dir, $swamp, 'Correct $dir' );
    unlike( $file, qr{/\\:}, '$file should not have any slashes, backslashes or other pathy things' );
}

CHECK_DESCEND_FILTER: {
    my $swamp = reslash( 't/swamp' );
    my $descend_filter = sub {
        ok( defined $_, '$_ defined' );
        like( $File::Next::dir, qr{^\Q$swamp}, '$File::Next::dir in $descend_filter' );
    };

    my $iter = File::Next::files( {descend_filter => $descend_filter}, $swamp );
    isa_ok( $iter, 'CODE' );

    while ( $iter->() ) {
        # Do nothing, just calling the descend
    }
}

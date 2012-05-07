#!perl -T

use strict;
use warnings;
use Test::More tests => 17;

use File::Next;

CHECK_FILE_FILTER: {
    my $file_filter = sub {
        ok( defined $_, '$_ defined' );
        is( $File::Next::dir, File::Next::reslash( 't/swamp' ), '$File::Next::dir correct in $file_filter' );
        is( $File::Next::name, File::Next::reslash( "t/swamp/$_" ), '$File::Next::name is correct' );
    };

    my $iter = File::Next::files( {
        file_filter => $file_filter,
        sort_files => \&File::Next::sort_reverse,
    }, 't/swamp' );
    isa_ok( $iter, 'CODE' );

    # Return filename in scalar mode
    my $file = $iter->();
    my $swamp = File::Next::reslash( 't/swamp' );
    like( $file, qr{^\Q$swamp\E.+}, 'swamp filename returned' );

    # Return $dir and $file in list mode
    my $dir;
    ($dir,$file) = $iter->();
    is( $dir, $swamp, 'Correct $dir' );
    unlike( $file, qr{/\\:}, '$file should not have any slashes, backslashes or other pathy things' );
}

CHECK_DESCEND_FILTER: {
    my $swamp = File::Next::reslash( 't/swamp' );
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

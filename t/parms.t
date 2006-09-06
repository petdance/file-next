#!perl

use strict;
use warnings;
use Test::More tests => 5;


BEGIN {
    use_ok( 'File::Next' );
}


BAD_PARMS_CAUGHT: {

    my @errors;
    sub error_catcher {
        my $error = shift;

        push( @errors, $error );

        return;
    }

    my $iter =
        File::Next::files( {
            error_handler => \&error_catcher,
            wango => 'ze tango',
        }, 't/pod.t' );

    is( scalar @errors, 1, 'Caught one error' );
    like( $errors[0], qr/Invalid.+wango/, 'And it looks reasonable' );
}


BAD_PARMS_UNCAUGHT: {
    eval {
        my $iter =
            File::Next::files( {
                wango => 'ze tango',
            }, 't/pod.t' );
    };

    ok( defined $@, 'Throws an error' );
    like( $@, qr/Invalid.+wango/, 'And it looks reasonable' );
}

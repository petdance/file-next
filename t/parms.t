#!perl -T

use strict;
use warnings;
use Test::More tests => 4;

use File::Next;

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
    like( $errors[0], qr/Invalid.+files.+wango/, 'And it looks reasonable' );
}


BAD_PARMS_UNCAUGHT: {
    my $bad_iterator = eval {
        my $iter =
            File::Next::dirs( {
                wango => 'ze tango',
            }, 't/pod.t' );
    };

    ok( !defined($bad_iterator), 'Constructor fails with bad parameters' );
    like( $@, qr/Invalid.+dirs.+wango/, 'And it looks reasonable' );
}

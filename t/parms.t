#!perl -T

use strict;
use warnings;

use Test::More tests => 10;

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

FILES_AS_METHOD: {
    my $bad_iterator = eval {
        my $iter =
            File::Next->files( {
                wango => 'ze tango',
            }, 't/pod.t' );
    };

    ok( !defined($bad_iterator), 'Constructor fails with bad parameters' );
    like( $@, qr/File::Next::files must not be invoked as File::Next->files/, 'And it looks reasonable' );
}

DIRS_AS_METHOD: {
    my $bad_iterator = eval {
        my $iter =
            File::Next->dirs( {
                wango => 'ze tango',
            }, 't/pod.t' );
    };

    ok( !defined($bad_iterator), 'Constructor fails with bad parameters' );
    like( $@, qr/File::Next::dirs must not be invoked as File::Next->dirs/, 'And it looks reasonable' );
}

EVERYTHING_AS_METHOD: {
    my $bad_iterator = eval {
        my $iter =
            File::Next->everything( {
                wango => 'ze tango',
            }, 't/pod.t' );
    };

    ok( !defined($bad_iterator), 'Constructor fails with bad parameters' );
    like( $@, qr/File::Next::everything must not be invoked as File::Next->everything/, 'And it looks reasonable' );
}

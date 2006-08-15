#!perl

use strict;
use warnings;
use Test::More tests => 3;


BEGIN {
    use_ok( 'File::Next' );
}

my @errors;
sub error_catcher {
    my $error = shift;

    push( @errors, $error );
}

BAD_PARMS: {
    my $iter =
        File::Next::files( {
            error_handler => \&error_catcher,
            wango => 'ze tango',
        }, 't/pod.t' );

    is( scalar @errors, 1, 'Caught one error' );
    like( $errors[0], qr/Invalid.+wango/, 'And it looks reasonable' );
}

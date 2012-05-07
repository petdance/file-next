#!perl -T

use strict;
use warnings;
use Test::More tests => 6;

use lib 't';
use Util;

use File::Next;

EVERYTHING: {
    my $iter;
    my $rc = eval {
        $iter = File::Next->everything( 't/' );
    };
    ok( !defined($rc), 'Calling everything as method should fail' );

    $rc = eval {
        $iter = File::Next::everything( 't/' );
    };
    ok( defined($rc), 'Calling everything as function should pass' );
}


FILES: {
    my $iter;
    my $rc = eval {
        $iter = File::Next->files( 't/' );
    };
    ok( !defined($rc), 'Calling files as method should fail' );

    $rc = eval {
        $iter = File::Next::files( 't/' );
    };
    ok( defined($rc), 'Calling files as function should pass' );
}

DIRS: {
    my $iter;
    my $rc = eval {
        $iter = File::Next->dirs( 't/' );
    };
    ok( !defined($rc), 'Calling dirs as method should fail' );

    $rc = eval {
        $iter = File::Next::dirs( 't/' );
    };
    ok( defined($rc), 'Calling dirs as function should pass' );
}


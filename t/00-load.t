#!perl -T

use strict;
use warnings;
use Test::More tests => 1;

BEGIN {
    use_ok( 'File::Next' );
}

diag( "Testing File::Next $File::Next::VERSION, Perl $], $^X" );

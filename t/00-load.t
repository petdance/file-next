#!perl -T

use strict;
use warnings;
use Test::More tests => 1;

use File::Next;

diag( "Testing File::Next $File::Next::VERSION, Perl $], $^X" );

pass( 'All modules loaded OK.' );

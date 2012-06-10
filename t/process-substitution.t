#!perl

use strict;
use warnings;

use Test::More;

system 'bash', '-c', 'exit';

if ( $? ) {
    plan skip_all => 'You need bash to run this test';
}

my $perl = $^X;

plan tests => 3;

my @output = qx{bash -c "$perl -Mblib t/give-me-a-process-pipe.pl <(cat Changes)"};
chomp @output;
is( $output[0], 'Revision history for File-Next' );
is( $output[-1], '    First version, released on an unsuspecting world.' );
is( $?, 0, 'passing a named pipe created by a bash process substitution should yield that filename' );
done_testing();

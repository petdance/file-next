#!perl

use strict;
use warnings;

use Test::More;

system 'bash', '-c', 'exit';

if ( $? ) {
    plan skip_all => 'You need bash to run this test';
}

my $perl = $^X;

plan tests => 1;

system 'bash', '-c', "$perl -I blib/lib t/give-me-a-process-pipe.pl <(cat t/give-me-a-process-pipe.pl)";
ok $? == 0 , 'passing a named pipe created by a bash process substitution should yield that filename';

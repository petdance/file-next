#!/usr/bin/perl

use strict;
use warnings;

use Benchmark ( ':hireswallclock', 'cmpthese' );

my $count = 10000000;

my %hash = ( x => 1, y => 1 );

my $path = '/usr/local/bin/whatever';

cmpthese($count, {
        hashed => sub { return !exists $hash{$path} },
        ored   => sub { return $path ne '.git' && $path ne '.svn' },
    } );

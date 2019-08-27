#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Benchmark ( ':hireswallclock', 'cmpthese' );
#use blib;
use File::Next;

{use Data::Dumper; local $Data::Dumper::Sortkeys=1; warn Dumper( \%INC )}

my $count = 10;

my $start = shift or die "Must specify starting point";;

say "$count iterations";
cmpthese( $count,
    {
        walk => sub {
            my $files = File::Next::files(
                {
                    descend_filter => sub { $_ ne '.git' },
                },
                $start
            );
            my $n = 0;
            while ( my $file = $files->() ) {
                ++$n;
            }
            say "$n files found";
        },
    }
);

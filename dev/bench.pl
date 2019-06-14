#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Benchmark ( ':hireswallclock', 'cmpthese' );
use File::Next;

my $count = 1;

my %hash = ( x => 1, y => 1 );

my $path = '/usr/local/bin/whatever';

my $start = '/home/andy/src';

cmpthese($count,
    {
        readdir => \&via_readdir,
        glob    => \&via_glob,
        iter    => \&via_iterator,
    } );



sub via_readdir {
    opendir( my $dh, $start ) or die;
    my @foo = readdir($dh);

    say 'readdir ', scalar @foo;
}


sub via_glob {
    my @foo = glob( "$start/*" );

    say 'glob ', scalar @foo;
}


sub via_iterator {
    my $iter = File::Next::files( $start );
    my @foo;
    while ( my $file = $iter->() ) {
        push( @foo, $file );
    }

    say 'iterator ', scalar @foo;
}

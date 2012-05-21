#!/usr/bin/env perl

use strict;
use warnings;

use File::Next;

my $nul = shift;

my $iter = File::Next::from_file( { nul_separated => $nul }, '-' );
while ( my $file = $iter->() ) {
    print "$file\n";
}

#!/usr/bin/env perl

use strict;
use warnings;

use File::Next;

my ( $input ) = @ARGV;

my $files = File::Next::files( $input );
my $file  = $files->();
if ( open my $f, '<', $file ) {
    my @lines = <$f>;
    print $lines[0];
    print $lines[-1];
    close $f;
    exit 0;
}
else {
    exit 1;
}

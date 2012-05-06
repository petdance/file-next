#!/usr/bin/env perl

use strict;
use warnings;

use File::Next;

my ( $input ) = @ARGV;

my $files = File::Next::files( $input );
my $file  = $files->();
exit( defined($file) ? 0 : 1 );

#!/usr/bin/env perl

use strict;
use warnings;

use File::Next;

my ( $input ) = @ARGV;

my $files = File::Next::files( $input );
my $file  = $files->();
open my $f, '<', $file if defined $file;
exit( defined($file) ? 0 : 1 );

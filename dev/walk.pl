#!/usr/bin/perl

use warnings;
use strict;
use 5.010;

use blib;
use File::Next;


my $dir = shift or die "Must specify a directory to walk\n";

my $files = File::Next::files(
    {
        file_filter    => sub { 1 },
        descend_filter => sub { $_ ne '.git' },
    },
    $dir
);

while ( defined ( my $file = $files->() ) ) {
    say $file;
}

exit 0;

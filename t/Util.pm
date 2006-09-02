package Util;

use warnings;
use strict;

use base 'Exporter';

our @EXPORT_OK = qw( reslash );
our @EXPORT = @EXPORT_OK; ## no critic

use File::Spec;

sub reslash {
    my $path = shift;

    my @parts = split( /\//, $path );

    return $path if @parts < 2;

    return File::Spec->catfile( @parts );
}

1;

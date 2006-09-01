package Util;

use base 'Exporter';

our @EXPORT_OK = qw( reslash );
our @EXPORT = @EXPORT_OK;

use File::Spec;

sub reslash {
    my $path = shift;

    my @parts = split( /\//, $path );

    return $path if @parts < 2;

    return File::Spec->catfile( @parts );
}



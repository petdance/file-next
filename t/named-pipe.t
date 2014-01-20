#!perl

use strict;
use warnings;

use Test::More;

use File::Temp;

plan skip_all => q{Windows doesn't have named pipes} if $^O =~ /MSWin32/;
plan tests => 2;

use POSIX ();

my $tempdir = File::Temp->newdir;
mkdir "$tempdir/foo";
my $pipename = "$tempdir/foo/test.pipe";
my $rc = eval { POSIX::mkfifo( $pipename, oct(666) ) };

my $pid = fork();
if ( $pid == 0 ) {
    open my $fifo, '>', $pipename or die "Couldn't create named pipe $pipename: $!";
    open my $f, '<', 'Changes' or die "Couldn't open Changes: $!";
    while (my $line = <$f>) {
        print {$fifo} $line;
    }
    close $fifo;
    close $f;
    exit 0;
}

my @output = qx{$^X -Mblib t/first-and-last-lines-via-process-pipe.pl $pipename};
is( $?, 0, 'No errors in executing our little named pipe tester' );
unlink $pipename;

chomp @output;

my @expected = (
    'Revision history for File-Next',
    '    First version, released on an unsuspecting world.',
);
is_deeply( \@output, \@expected, 'Output matches' );

done_testing();

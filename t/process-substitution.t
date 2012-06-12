#!perl

use strict;
use warnings;

use Test::More;

plan skip_all => q{Windows doesn't have named pipes} if $^O =~ /MSWin32/;
plan tests => 4;

use POSIX ();

my $pipename = POSIX::tmpnam();
POSIX::mkfifo $pipename, 0666;

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
is( scalar @output, 2, 'Get exactly 2 lines back' );
is( $output[0], 'Revision history for File-Next' );
is( $output[-1], '    First version, released on an unsuspecting world.' );

done_testing();

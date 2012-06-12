#!perl

use strict;
use warnings;
use Test::More tests => 2;

use lib 't';
use Util;

my $CAT = "$^X -pe1";

my @expected = qw(
    t/00-load.t
    t/api.t
    t/basic.t
    t/dirs.t
    t/dot.t
    t/everything.t
    t/follow.t
    t/from_file.t
    t/methods.t
    t/named-pipe.t
    t/parms.t
    t/pod-coverage.t
    t/pod.t
    t/sort.t
    t/swamp/perl-test.t
    t/zero.t
);

FROM_STDIN: {
    # Pipe stuff into the iterator
    my @actual = `$CAT t/filelist.txt | $^X -Mblib t/stdin-iterator.pl`;
    chomp @actual;
    sets_match( \@actual, \@expected, 'FROM_STDIN' );
}

FROM_STDIN_NUL: {
    # Pipe nul-separated stuff into the iterator that handles nul-separated
    my @actual = `$CAT t/filelist-nul.txt | $^X -Mblib t/stdin-iterator.pl 1`;
    chomp @actual;
    sets_match( \@actual, \@expected, 'FROM_STDIN_NUL' );
}

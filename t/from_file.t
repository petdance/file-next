#!perl -T

use strict;
use warnings;
use Test::More tests => 4;

use lib 't';
use Util;

use File::Next;

# use Test::Differences;
# eq_or_diff \@got, [qw( a b c )], "testing arrays";

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
    t/parms.t
    t/pod-coverage.t
    t/pod.t
    t/process-substitution.t
    t/sort.t
    t/swamp/perl-test.t
    t/zero.t
);


FROM_FILESYSTEM_FILE: {
    my $iter = File::Next::from_file( 't/filelist.txt' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    sets_match( \@actual, \@expected, 'FROM_FILESYSTEM_FILE' );
}


FROM_NUL_FILE: {
    my $iter = File::Next::from_file( { nul_separated => 1 }, 't/filelist-nul.txt' );
    isa_ok( $iter, 'CODE' );

    my @actual = slurp( $iter );
    sets_match( \@actual, \@expected, 'FROM_NUL_FILE' );
}

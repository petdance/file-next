#!perl -T

use strict;
use warnings;

use Test::More;

my $module = 'Test::Pod::Coverage 1.04';

if ( eval "use $module; 1;" ) { ## no critic (ProhibitStringyEval)
    all_pod_coverage_ok();
}
else {
    plan skip_all => "$module required for testing POD";
}

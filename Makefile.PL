package main;

use 5.006001;

use strict;
use warnings;
use ExtUtils::MakeMaker;

my %parms = (
    NAME                => 'File::Next',
    AUTHOR              => 'Andy Lester <andy@petdance.com>', ## no critic (RequireInterpolationOfMetachars)
    VERSION_FROM        => 'Next.pm',
    ABSTRACT_FROM       => 'Next.pm',
    PL_FILES            => {},
    LICENSE             => 'artistic_2',
    PREREQ_PM => {
        'Test::More' => 0.88,
        'File::Copy' => 0,
        'File::Spec' => 0,
        'File::Temp' => 0.22,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Next-*' },
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
    $parms{LICENSE} = 'artistic_2';
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.46' ) {
    $parms{META_MERGE} = {
        resources => {
            bugtracker  => 'http://github.com/petdance/file-next/issues',
            repository  => 'http://github.com/petdance/file-next/tree/master',
            license     => 'http://dev.perl.org/licenses/',
        }
    };
}

WriteMakefile( %parms );

sub MY::postamble {
return <<'MAKE_FRAG';
.PHONY: tags critic

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib \
		--exclude=.git \
		--exclude=.svn \
		--exclude='*~' \
		--languages=Perl --langmap=Perl:+.t \

critic:
	perlcritic -profile perlcriticrc -1 -quiet *.pm t/*.t

TARGET_DIRS=~/parrot ~/perl-critic ~/bin

prof: all
	perl -d:DProf -Mblib ./stress $(TARGET_DIRS) > /dev/null
	dprofpp -R

nytprof: all
	perl -d:NYTProf -Mblib ./stress $(TARGET_DIRS) > /dev/null
	nytprofhtml

MAKE_FRAG
}

1;

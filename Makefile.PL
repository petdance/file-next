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
    PREREQ_PM => {
        'Test::More' => 0,
        'File::Spec' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Next-*' },
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
    $parms{LICENSE} = 'perl';
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

prof: all
	perl -d:DProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin > /dev/null
	dprofpp -R

smallprof: all
	perl -d:SmallProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin > /dev/null
	sort -k 2nr,2 smallprof.out | less

nytprof: all
	perl -d:NYTProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin > /dev/null
	nytprofhtml

MAKE_FRAG
}

1;

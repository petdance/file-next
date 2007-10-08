package main;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
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

sub MY::postamble {
return <<'MAKE_FRAG';
.PHONY: tags critic

critic:
	perlcritic -profile perlcriticrc -1 -quiet *.pm t/*.t

prof: all
	perl -d:DProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin > /dev/null
	dprofpp -R

smallprof: all
	perl -d:SmallProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin > /dev/null
	sort -k 2nr,2 smallprof.out | less

MAKE_FRAG
}

1;

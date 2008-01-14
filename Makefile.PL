package main;
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

if ( $ExtUtils::MakeMaker::VERSION ge '6.36' ) {
    $parms{EXTRA_META} = <<EOF;
resources:
    bugtracker: http://code.google.com/p/file-next/issues/list
    license: http://dev.perl.org/licenses/
    Repository: http://code.google.com/p/file-next/source
EOF
    }

WriteMakefile( %parms );

sub MY::postamble {
return <<'MAKE_FRAG';
.PHONY: tags critic

critic:
	perlcritic -profile perlcriticrc -1 -quiet *.pm t/*.t

prof: all
	perl -d:DProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin /Developer > /dev/null
	dprofpp -R

smallprof: all
	perl -d:SmallProf -Mblib ./stress ~/parrot ~/bw/trunk ~/p101 ~/bin /Developer > /dev/null
	sort -k 2nr,2 smallprof.out | less

MAKE_FRAG
}

1;

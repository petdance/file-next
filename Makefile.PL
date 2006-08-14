package main;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'File::Next',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'Next.pm',
    ABSTRACT_FROM       => 'Next.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Next-*' },
);

sub MY::postamble {
return <<'MAKE_FRAG';
.PHONY: tags critic

tags:
	ctags -f tags --recurse --totals \
		exclude=blib/ --exclude=t/lib \
		exclude=.svn --exclude='*~' \
		languages=Perl --langmap=Perl:+.t

critic:
	perlcritic -1 .

MAKE_FRAG
}

1;

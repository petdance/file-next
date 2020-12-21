# Validate with cpanfile-dump
# https://metacpan.org/release/Module-CPANfile

requires 'File::Spec' => 0;

on 'test' => sub {
    requires 'Test::More' => '0.88';
    requires 'File::Copy' => '0';
    requires 'File::Temp' => '0.22',
};

# vi:et:sw=4 ts=4 ft=perl

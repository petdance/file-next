sub slurp {
    my $iter = shift;
    my @files;

    while ( defined ( my $file = $iter->() ) ) {
        push( @files, $file );
    }
    return @files;
}

sub sets_match {
    my @actual = @{+shift};
    my @expected = @{+shift};
    my $msg = shift;

    # Normalize all the paths
    for my $path ( @expected, @actual ) {
        $path = File::Next::reslash( $path );
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic
    return is_deeply( [sort @actual], [sort @expected], $msg );
}

1;

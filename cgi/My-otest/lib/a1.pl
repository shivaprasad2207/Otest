#!perl

my $s = 'hi prasad how are you is it all fine';

$s =~ s/(\w+)/ucfirst($1)/gei;

print "$s\n";


#!/usr/bin/perl
BEGIN {
   push @INC, "./lib";  
   push @INC, '/home/nnsprasad/perl/usr/lib/perl5';
   push @INC, '/home/nnsprasad/perl/usr/lib/perl5/x86_64-linux-thread-multi';
   require '/home/nnsprasad/public_html/cgi-bin/My-otest/debug.pl';
   binmode(STDIN );  # Form data
   binmode(STDOUT, ':encoding(UTF-8)');  # HTML
   binmode(STDERR, ':encoding(UTF-8)');  # Error messages
}
use warnings;
use strict;
use CGI;
use JSON;
use Data::Dumper;
require ("debug.pl");

my $cgi = CGI->new();
my $term = $cgi->param ('term');
my @login_names = get_all_login_names();

my  @ings  = grep {/$term/} @login_names;
print "Content-type: application/json; charset=iso-8859-1\n\n";
print JSON::to_json(\@ings);
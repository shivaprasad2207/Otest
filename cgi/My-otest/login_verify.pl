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
use DBI;
use CGI;
use warnings;
use CGI::Session;
use strict;
use POSIX qw/strftime/;


use DBModule;
our $db_exec;

my $cgi = new CGI;
use CGI qw(:all -utf8);
my %params = $cgi->Vars;
my $session = new CGI::Session(undef, $cgi, undef);
my $sid = $session->id;

my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'+4h',
                        );

$cgi->autoEscape(undef);
my $user_name = $cgi->param('usr_name');
my $passwd = $cgi->param('passwd');

my $sql = "SELECT user_passwd FROM user_info WHERE user_name=?;";

my $qh = $db_exec->prepare ($sql);
$qh->execute($user_name);

my $user_passwd = $qh->fetchrow_array;

if ( "$user_passwd" eq "$passwd" ){
   
    $session->param('usr_name',$user_name);
    $session->param('role','0');
    $sql = "SELECT uid FROM user_info WHERE user_name=?;";
    $qh = $db_exec->prepare ($sql);
    $qh->execute($user_name);
    my $uid = $qh->fetchrow_array;
    my $logged_time = strftime('%Y-%m-%d %H:%M:%S',localtime);
    
    $sql = "insert into t_persession (sid , uid ,o_count, logged_time,is_logged_in, is_logged_out)
            values (\'$sid\' ,  \'$uid\'  , '0'   ,    \'$logged_time\',   '1',   '0')";
    $qh = $db_exec->prepare ($sql);
    $qh->execute();
    
    
    $sql = "SELECT role FROM usr_roles WHERE uid=?;";
    $qh = $db_exec->prepare ($sql);
    $qh->execute($uid);
    my $role = $qh->fetchrow_array;
    $session->param('role',$role);
    
   print $cgi->redirect(-cookie=>$cookie,-location=>"/cgi-bin/My-otest/index.pl");
}else{
    $session->clear;
    $session->delete();
    print $cgi->redirect(-cookie=>$cookie,-location=>"/cgi-bin/My-otest/login.pl?status=error");
}


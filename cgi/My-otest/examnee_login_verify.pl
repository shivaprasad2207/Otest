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


BEGIN {
   push @INC, "./lib";  
   binmode(STDIN);                       # Form data
   binmode(STDOUT, ':encoding(UTF-8)');  # HTML
   binmode(STDERR, ':encoding(UTF-8)');  # Error messages
}


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
   
    my $test_code = $cgi->param('test_code');
    $sql = "SELECT test_set_id FROM t_test_set_info where test_set_id = \'$test_code\';";
    $qh = $db_exec->prepare ($sql) or die ('<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
    $qh->execute()  or die ('<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
    my $ret = $qh->fetchrow_array; 
    
    if ( $ret ){
      $session->param('test_set_id',$test_code);
      $session->param('time_stamp',$logged_time);
       print $cgi->redirect(-cookie=>$cookie,-location=>"/cgi-bin/My-otest/index.pl?AppParam=EXAMNEE");  
    }else{
      $session->clear;
      $session->delete();
      print $cgi->redirect(-cookie=>$cookie,-location=>"/cgi-bin/My-otest/login.pl?status=t_error&code=$test_code"); 
      
    }
    
    
  
}else{
    $session->clear;
    $session->delete();
    print $cgi->redirect(-cookie=>$cookie,-location=>"/cgi-bin/My-otest/login.pl?status=error");
}


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

use CGI;
require 'debug.pl';
use CGI qw(:all -utf8);
use CGI::Carp qw(fatalsToBrowser);
require CGI::Session;
use Template;
use lib::Headers;
use strict;
use warnings;
use Data::Dumper;
use JSON;
use utf8;
use Time::Local;
use Date::Manip;
require File::Basename; 
use File::Copy;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;

our $MainPageHeader;
my $cgi = CGI::new;

my %page_function_hash = (
        'MainPage' => {
                        pFunction => \&F_MainPage,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
        'CRTID' => {
                        pFunction => \&F_CRTID,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'ADDTCS' => {
                        pFunction => \&F_ADDTCS,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'VIEWTCS' => {
                        pFunction => \&F_VIEWTCS,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'MODTCS' => {
                        pFunction => \&F_MODTCS,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'DELTCS' => {
                        pFunction => \&F_DELTCS,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         
         'XLS_UPLOAD' => {
                        pFunction => \&F_XLS_UPLOAD,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         
         'XLS_DOWNLOAD' => {
                        pFunction => \&F_XLS_DOWNLOAD,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         
         'UPLOAD' => {
                        pFunction => \&F_UPLOAD,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         
         'EXAMNEE' => {
                        pFunction => \&F_EXAMNEE,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'EXMNEE_REP' => {
                        pFunction => \&F_EXMNEE_REP,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'USER_N_TESTS'  => {
                        pFunction => \&F_USER_N_TESTS,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'SETTINGS'  => {
                        pFunction => \&F_SETTINGS,
                        pHeader =>  $MainPageHeader,
                        pBody => 'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
         'NEW_USER' => {
                        pFunction => \&F_NEW_USER,u
                        pHeader =>  $MainPageHeader,
                        pBody =>  'F_MainPageBody',
                        pFooter => 'F_MainPageFooter',
                        
                     },
);



&AppInit( $cgi ); 

sub AppInit {
    my ($cgi) = @_;
    my $param = $cgi->param('AppParam');
    if (!$param){
        $param = 'MainPage';
    }elsif ($param =~ /\?/){
        my @params = split '\?' , $param;
        $cgi->{code} = $params[1];
        $param = $params[0];
    }
    $cgi->{'AppParam'} = $param  ;
    my $function_ref = $page_function_hash{$param}->{'pFunction'};
    $function_ref->($cgi);
}


sub F_MainPage {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    my $data = {
                 user_name => $user_name,
                 role  =>   $role,
                 sid =>  $sid,
               };
   my $out = ''; 
   my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();
}


sub F_CRTID {
   my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out; 
   $tt = Template->new;
        $tt->process('t_create_new_test_id_form.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();   
}

sub F_ADDTCS {
   my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   
   $data->{random1} = generate_random_string (4);
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{testsetids} = \@testset_ids;
   
   $tt = Template->new;
        $tt->process('managa_add_test_sets.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();   
}

sub F_VIEWTCS {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   
   $data->{random1} = generate_random_string (4);
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{testsetids} = \@testset_ids;
   
   $tt = Template->new;
        $tt->process('manage_view_test_sets.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();   
}

sub F_MODTCS {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   
   $data->{random1} = generate_random_string (4);
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{testsetids} = \@testset_ids;
   
   $tt = Template->new;
        $tt->process('manage_mod_test_sets.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();   
}

sub F_XLS_UPLOAD{
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   $data->{random1} = generate_random_string (4);
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{testsetids} = \@testset_ids;
   
   $tt = Template->new;
        $tt->process('xslsheet_upload_form.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();    
}

sub F_UPLOAD{
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    my $testsetid = $cgi->param('testid');
    my $upfile = $cgi->param('upfile');
    my $basename = GetBasename($upfile);
    no strict 'refs';
    my $OUTFILE; 
    open($OUTFILE, ">", "/tmp/$basename") || die "can't open UTF-8 encoded filename: $!";
    binmode($OUTFILE);    
    my $nBytes = 0;
    my $totBytes = 0;
    my $buffer = "";
    binmode($upfile);
    while ( $nBytes = read($upfile, $buffer, 1024) ) {
            print $OUTFILE $buffer;
           $totBytes += $nBytes;
    }
    close($OUTFILE);
     my $parser   = Spreadsheet::ParseExcel->new();
     my $workbook = $parser->parse("/tmp/$basename"); 
     die $parser->error(), ".\n" if ( !defined $workbook );
     my %data;
     for my $worksheet ( $workbook->worksheets() ) {
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();
        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {
                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;
                my $value = $cell->value();
                $value =~ s/^\s+//; $value =~ s/\s+$//;
                $data{$row}{$col} = $value;
            }
        }
     }
    my $testcase_count = keys (%data );
    my $test_case_count;
    foreach my $key ( keys (%data)){
      my %hash = %{$data{$key}};
      my ($quesation, $ans_a, $ans_b, $ans_c, $ans_d, $ans_e, $ans) = @hash{0..6}; 
      $test_case_count = get_test_case_count_by_testsetid ($testsetid);
      $test_case_count++;
      my $sql = "insert into t_test_case_info
                                       values
                                              (
                                                \'$testsetid\' , \'$test_case_count\' , \'$quesation\',
                                                \'$ans_a\', \'$ans_b\', \'$ans_c\', \'$ans_d\', \'$ans_e\', \'$ans\'
                                              );
                  
                  ";
             
       my $ret = add_a_testcase_to_testset ( $sql); 
   
   }
   my $out;
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    my $tt = Template->new;
        $tt->process('main_page.html', undef, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   undef %data;
   $data{count} = $testcase_count;
   $data{testsetid} = $testsetid;
   $data{total} = $test_case_count;
   $tt = Template->new;
        $tt->process('xsl_upload_confirm.html', \%data, \$out)
        || die $tt->error;
   print $out;  
   
   print $cgi->end_html(); 
     
}

sub F_XLS_DOWNLOAD{
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   $data->{random1} = generate_random_string (4);
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{testsetids} = \@testset_ids;
   
   $tt = Template->new;
        $tt->process('xls_sheet_download_form.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();    
}


sub F_DELTCS {
   my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   
   $data->{random1} = generate_random_string (4);
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{testsetids} = \@testset_ids;
   
   $tt = Template->new;
        $tt->process('manage_delete_test_sets.html', $data, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();   
}

sub F_EXAMNEE {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $test_set_id = $session->param("test_set_id");
    my $time_stamp = $session->param("time_stamp");
    my %data;
    %data= get_all_testset_info ( $test_set_id );
    my ($uid, $description, $extra_info, $test_case_count, $timeset) =
                                 @data{ 'uid', 'description', 'extra_info', 'test_case_count', 'timeset'};
     
    my $test_set_owner = get_user_name_by_uid ( $uid); 
    
    
    my $out;
    my %info;
    @info{'sid','testset_owner_name','description','details','test_count','time_given','testsetid','logtime','uname'} =
           ($sid,$test_set_owner, $description,$extra_info,$test_case_count,$timeset,$test_set_id,$time_stamp,$user_name);
    
    
    print $cgi->header( );
    print $cgi->start_html($PageHeader);    
    my $tt = Template->new;
        $tt->process('examinee_front_page.html', \%info, \$out)
        || die $tt->error;
   print $out;
   my %reg_data;
   my $ret = is_attempt_registered ( $sid );
   if ( !$ret){
      @reg_data{'testsetid','uname','logtime','sid'} = ($test_set_id, $user_name, $time_stamp ,$sid  );
       my $ret = register_test_attempt( %reg_data); 
       $ret = initialize_the_attempt_table($sid,$test_set_id);  
   }
   my @reg_testcases = get_reg_testcases_from_attempt_table( $sid,$test_set_id );
   undef %info;
   undef $out; 

   @info{'tests','testsetid','sid'} = ( \@reg_testcases, $test_set_id , $sid );
   $tt = Template->new;
        $tt->process('quesation_for_examnee.html', \%info, \$out)
        || die $tt->error;
   print $out;
   print $cgi->end_html();   
}

sub F_EXMNEE_REP {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    my $session = CGI::Session->new( $sid );
    my $test_set_id = $session->param("test_set_id");
    my $time_stamp = $session->param("time_stamp");
    my %data;
    %data= get_all_testset_info ( $test_set_id );
    my ($uid, $description, $extra_info, $test_case_count, $timeset) =
                                 @data{ 'uid', 'description', 'extra_info', 'test_case_count', 'timeset'};
     
    my $test_set_owner = get_user_name_by_uid ( $uid); 
    
    
    my $out;
    my %info;
    @info{'sid','testset_owner_name','description','details','test_count','time_given','testsetid','logtime','uname'} =
           ($sid,$test_set_owner, $description,$extra_info,$test_case_count,$timeset,$test_set_id,$time_stamp,$user_name);
    
    
    print $cgi->header( );
    print $cgi->start_html($PageHeader);    
    my $tt = Template->new;
        $tt->process('examinee_front_page.html', \%info, \$out)
        || die $tt->error;
   print $out;
   
   undef $out;
   undef %data;
   
   my @all_testcases_of_testset = get_all_testcases_of_testset ( $test_set_id );
   my $total_testcases = @all_testcases_of_testset;
   my $pass_count = 0;
   foreach my $key (@all_testcases_of_testset ){
      my %hash = %{$key};
      my $sln = $hash{sln};
      my $u_ans = get_user_ans_by_testsetid ($sln,$sid,$test_set_id );
      $key->{'u_ans'} = $u_ans;
      if ( $u_ans =~ /$hash{answer}/i){
         $pass_count++;
      }
   }
   
   $data{tests} = \@all_testcases_of_testset;
  
   $tt = Template->new;
   $tt->process('examinee_report_tmplt.html', \%data, \$out)
        || die $tt->error;
   
   print $out;
   
   my $test_summary =  "Test Report  Total = $total_testcases  ****** PASSED =  $pass_count";
   my $ret = update_summary_of_test ( $sid,$test_set_id ,$test_summary);  
   
   print "<br><b
               style=\"font-family:Arial, Helvetica, sans-serif;
                       font-size: large;
                       color:red;\">
                       
                       Test Report  Total = $total_testcases  ****** PASSED =  $pass_count
               </b>" ;
   
   $session->delete();
   $session->flush();
   my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'-1d',
                        );            
               
               
   print $cgi->end_html(); 
}


sub F_USER_N_TESTS{
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    
    my $out;
    my $data = {};
    $data->{role} = $role;
    $data->{user_name} = $user_name;
    
    my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;  
   undef $out;
   
   $data->{random1} = generate_random_string (4);
   $data->{uid} = get_user_id_by_name_from_db ( $user_name );
   my @testset_ids = get_test_set_ids_of_by_uid ( $data->{uid} );
   $data->{'testsetids'} = \@testset_ids;
   $tt = Template->new;
        $tt->process('manage_user_n_test.html', $data, \$out)
        || die $tt->error;
   print $out;
   print $cgi->end_html();     
   
}

sub F_SETTINGS {
    my ($cgi) = @_;
    my ($user_name,$role) = is_valid_user($cgi);
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    my $sid = $cgi->cookie('CGISESSID');
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    my $data = {
                 user_name => $user_name,
                 role  =>   $role,
                 sid =>  $sid,
               };
   my $out = ''; 
   my $tt = Template->new;
        $tt->process('main_page.html', $data, \$out)
        || die $tt->error;
   print $out;
   $data = {
                  'name' => $user_name,
               };
   
   $out = ''; 
   $tt = Template->new;
        $tt->process('setting.html', $data, \$out)
        || die $tt->error;
   print $out;
   print $cgi->end_html();
}

sub F_NEW_USER{
    my ($cgi) = @_;
    my $param = $cgi->{'AppParam'};
    my $PageHeader = $page_function_hash{$param}->{'pHeader'};
    print $cgi->header( );
    print $cgi->start_html($PageHeader);
    my $out;    
    my $tt = Template->new;
        $tt->process('new_user_reg.html', undef, \$out)
        || die $tt->error;
   print $out;  
   print $cgi->end_html();     
}



#################################################################################################


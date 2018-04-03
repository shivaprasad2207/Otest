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
require CGI::Session;
use Data::Dumper;
require ("debug.pl");
use CGI::Carp qw(fatalsToBrowser);
use JSON;
our  $MainPageHeader;
use Time::Local;
use Date::Manip;
use POSIX qw/strftime/;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;

my $cgi = CGI->new();
my $flag = $cgi->param('flag');

if ( $flag eq 'CREATE_NEW_TEST_SET_ID' ){
   my $out;
   my %params = $cgi->Vars;
   foreach my $param (keys ( %params)){
      $params{$param} =~ s/^\s+//;
      $params{$param} =~ s/\s+$//;
   }
   my $uid = get_user_id_by_name_from_db ( $params{user_login_name} );
   my $test_set_id = create_uniq_test_set_id (8);
   my $creation_time = strftime('%Y-%m-%d %H:%M:%S',localtime);
   
   my $sql = " insert into t_test_set_info
                                       values
                                             (
                                                \'$test_set_id\' , \'$uid\' , \'$params{description}\',
                                                \'$params{details}\', \'$params{num_of_tcs}\',
                                                \'$params{time}\', \'$creation_time\'
                                             );      
   ";
   my $ret = create_new_test_id ( $sql);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print "&nbsp&nbsp&nbsp&nbsp <b> $test_set_id </b> &nbsp&nbsp&nbsp&nbsp is Created to refer new setof test cases <br><br>";   
   
}elsif ( $flag eq 'SHOW_TEST_ADD_FORM' ){
   my $uid = $cgi->param('uid');
   my $testsetid = $cgi->param('testsetid');
   my $uname = get_user_name_by_uid ($uid );
   my ($description, $detail) = get_test_set_info ( $testsetid );
   my $test_case_count = get_test_case_count_by_testsetid ($testsetid);
   my $data = {};
   $data->{uname} = $uname ;
   $data->{description} =  $description;
   $data->{details} = $detail;
   $data->{count} = $test_case_count;
   $data->{range} = [1..5];
   $data->{testsetid} = $testsetid;
   my $out;
    my $tt = Template->new;
        $tt->process('test_set_add_tmplt.html', $data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;   
}elsif ( $flag eq 'SUBMIT_TEST_ADD_FORM' ){
   my $testsetid = $cgi->param('testsetid');
   my %params = $cgi->Vars;
   my %data;
   foreach my $key (keys (%params )){
      if ( $key =~ /_1/){
         $data{1}->{$key} = $params{$key};
      }elsif( $key =~ /_2/){
         $data{2}->{$key} = $params{$key};
      }elsif( $key =~ /_3/){
         $data{3}->{$key} = $params{$key};  
      }elsif( $key =~ /_4/){
         $data{4}->{$key} = $params{$key};  
      }elsif( $key =~ /_5/){
         $data{5}->{$key} = $params{$key};
      }
   }
   foreach my $key ( keys (%data)){
      my %hash = %{$data{$key}};
      my ($quesation, $ans_a, $ans_b, $ans_c, $ans_d, $ans_e, $ans); 
      foreach my $key ( keys ( %hash)){
          
         if ($key =~ /quesation/){
             $quesation = $hash{$key};
         }
         if($key =~ /ans_a/ ){  
            $ans_a = $hash{$key};
         }
         if($key =~ /ans_b/ ){  
            $ans_b = $hash{$key};
         }
         if($key =~ /ans_c/ ){  
            $ans_c = $hash{$key};
         }
         if($key =~ /ans_d/ ){
            $ans_d = $hash{$key};   
         }
         if($key =~ /ans_e/ ){
            $ans_e = $hash{$key};
         }
         if($key =~ /true_/ ){
            $ans = $hash{$key};   
         }
      }
         my $test_case_count = get_test_case_count_by_testsetid ($testsetid);
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
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print "<br><br><h2>All test cases added<h2>" ;
  
}elsif ( $flag eq 'SHOW_TEST_VIEW_FORM' ){
   my $uid = $cgi->param('uid');
   my $testsetid = $cgi->param('testsetid');
   my $uname = get_user_name_by_uid ($uid );
   my ($description, $detail) = get_test_set_info ( $testsetid );
   my $test_case_count = get_test_case_count_by_testsetid ($testsetid);
   my $data = {};
   $data->{uname} = $uname ;
   $data->{description} =  $description;
   $data->{details} = $detail;
   $data->{count} = $test_case_count;
   $data->{testsetid} = $testsetid;
   my @all_testcases_of_testset = get_all_testcases_of_testset ( $testsetid );
   $data->{tests} = \@all_testcases_of_testset;
   my $out;
    my $tt = Template->new;
        $tt->process('test_set_view_tmplt.html', $data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;
}elsif ( $flag eq 'SHOW_TEST_MOD_FORM' ){
   my $uid = $cgi->param('uid');
   my $testsetid = $cgi->param('testsetid');
   my $uname = get_user_name_by_uid ($uid );
   my ($description, $detail) = get_test_set_info ( $testsetid );
   my $test_case_count = get_test_case_count_by_testsetid ($testsetid);
   my $data = {};
   $data->{uname} = $uname ;
   $data->{description} =  $description;
   $data->{details} = $detail;
   $data->{count} = $test_case_count;
   $data->{testsetid} = $testsetid;
   my @all_testcases_of_testset = get_all_testcases_of_testset ( $testsetid );
   $data->{tests} = \@all_testcases_of_testset;
   my $out;
    my $tt = Template->new;
        $tt->process('test_set_mod_tmplt.html', $data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;
}elsif ( $flag eq 'SUBMIT_TEST_MOD_FORM' ){
   my $sln = $cgi->param('sln');
   my $testsetid = $cgi->param('testsetid');
   my %params = $cgi->Vars;
   my ($quesation, $ans_a, $ans_b, $ans_c, $ans_d, $ans_e, $true );
   foreach my $key ( keys ( %params)){
      if ($key =~ /ans_a/){ $ans_a = $params{$key}}
      if ($key =~ /ans_b/){ $ans_b = $params{$key}}
      if ($key =~ /ans_c/){ $ans_c = $params{$key}}
      if ($key =~ /ans_d/){ $ans_d = $params{$key}}
      if ($key =~ /ans_e/){ $ans_e = $params{$key}}
      if ($key =~ /true/){  $true =  $params{$key}}
      if ($key =~ /ques/){  $quesation =  $params{$key}}
   }
   my $sql = "
               update t_test_case_info set
                                 quesation = \'$quesation\',
                                 q_a = \'$ans_a\',
                                 q_b = \'$ans_b\',
                                 q_c = \'$ans_c\',
                                 q_d = \'$ans_d\',
                                 q_e = \'$ans_e\',
                                 answer = \'$true\'
               where
                     test_set_id =  \'$testsetid\' and sln = \'$sln\' ; 
   ;";
   my $ret = modify_testcase_of_testset ( $sql);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br><b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:green;"> Above Test case Modified</b>';
}elsif ( $flag eq 'SHOW_TEST_DEL_FORM' ){
   my $uid = $cgi->param('uid');
   my $testsetid = $cgi->param('testsetid');
   my $uname = get_user_name_by_uid ($uid );
   my ($description, $detail) = get_test_set_info ( $testsetid );
   my $test_case_count = get_test_case_count_by_testsetid ($testsetid);
   my $data = {};
   $data->{uname} = $uname ;
   $data->{description} =  $description;
   $data->{details} = $detail;
   $data->{count} = $test_case_count;
   $data->{testsetid} = $testsetid;
   my @all_testcases_of_testset = get_all_testcases_of_testset ( $testsetid );
   $data->{tests} = \@all_testcases_of_testset;
   my $out;
    my $tt = Template->new;
        $tt->process('test_set_delete_tmplt.html', $data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;
}elsif ( $flag eq 'DEL_THESE_TESTS' ){
   my $testsetid = $cgi->param('testsetid');
   my %params = $cgi->Vars;
   my @test_ids;
   foreach my $key (keys (%params)){
      if ($key =~ /delete_/ ){
         push @test_ids, $params{$key} ;
      }
   }
   foreach my $testid (@test_ids ){
      my $sql = "DELETE FROM t_test_case_info WHERE test_set_id=\'$testsetid\' and sln=\'$testid\'  ;";
      my $ret = delete_this_testcase_of_testset ( $sql );
   }
     
   my $ret = reset_test_id_sln( $testsetid );
   
   my $del_tcs = join ' ', @test_ids ;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print    "<br><br>"
          . '<b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:red;">'
          . $del_tcs . '</b>'
          . '<b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:red;"> test cases of testsetid </b>'
          . '<b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:red;">'  .  $testsetid
          . '</b> <b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:red;"> are deleted </b> <br> <br>' ;
   
}elsif ( $flag eq 'XML_DOWNLOAD_LINK' ){
   
   my $testsetid = $cgi->param('testsetid');
   my $workbook  = Spreadsheet::WriteExcel->new('TEST_CASES.xls');
   my $worksheet = $workbook->add_worksheet();
   my %t;
   @t {0,1,2,3,4,5,6,7} = ( 'sln', 'Quesation', 'Q_A' , 'Q_B',  'Q_C', 'Q_D', 'Q_E', 'TRUE');   
   
   foreach my $col (keys (%t) ){
         $worksheet->write(0, $col,$t{$col});   
   }
   my @all_testcases_of_testset = get_all_testcases_of_testset ( $testsetid );
   my $i = 1;
   foreach my $record ( @all_testcases_of_testset  ){
         my %hash = %{$record}; 
         $worksheet->write($i , 0 ,$hash{sln});
         $worksheet->write($i , 1 ,$hash{quesation});
         $worksheet->write($i , 2 ,$hash{q_a});
         $worksheet->write($i , 3 ,$hash{q_b});
         $worksheet->write($i , 4 ,$hash{q_c});
         $worksheet->write($i , 5 ,$hash{q_d});
         $worksheet->write($i , 6 ,$hash{q_e});
         $worksheet->write($i , 7 ,$hash{answer});
         $i++;
   }
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
    print '<br><br><br> &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
           &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
           <a href="download_xls.pl" target="_blank"> click to download xls sheet in next tab </a>
           <br><br><br>
         ' ;
  
}elsif ( $flag eq 'SAMPLE_XLS'){
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $image = '<table><tr><td>
               <img id="sample_xls_sheet " hight="400px" width="900px" src="/static/images/My-otest/sample_xls.JPG"  alt="No pic found" />
               </td></tr></table>   
   ';
   print $image;
}elsif ( $flag eq 'GET_TEST_CASE'){
   my $sln = $cgi->param('sln');
   my $testsetid = $cgi->param('testsetid');
   my $atmptid = $cgi->param('atmptid');
    my $last_ans = $cgi->param('atmpt_ans');
   my %data = get_testcase_by_sln ( $sln , $testsetid );
   $data{atmptid} = $atmptid;
   $data{testsetid} = $testsetid;
   $data{sln} = $sln;
   $data{last_ans} = $last_ans;
   my $out; 
   my $tt = Template->new;
        $tt->process('testcase_in_dialog.html', \%data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;
}elsif ( $flag eq 'TCS_SUBMIT'){
   my $sln = $cgi->param('sln');
   my $testsetid = $cgi->param('testsetid_id');
   my $sid = $cgi->param('attempt_id');
   my $ans = 'true_'.$sln;
   my $attempted_ans = $cgi->param("$ans");
   my $sql = "update attempt_table set
                        atmpt_ans = \'$attempted_ans\',
                        attaempt = \'ANWERED\'
                  where
                        test_set_id = \'$testsetid\' and
                        sln = \'$sln\' and
                        sid = \'$sid\';
                  ";
   
   my $ret = update_user_ans ( $sql );
   my $string = '<b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:green;"> You marked Answers as  ';
   $string = $string . $attempted_ans . '</b>';
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $string;
}elsif ( $flag eq 'logout'){
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   $session->delete();
   $session->flush();
   my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'-1d',
                        );
   print $cgi->redirect(-cookie=>$cookie,-location=>"login.pl?status=Alogout"); 
}elsif ( $flag eq 'SHOW_USER_TEST_INFO'){
  my $sid = $cgi->param('sid');
  my $uid = $cgi->param('uid');
  my $testsetid = $cgi->param('testsetid');
  my @ret = get_users_attaempted_tesetid ($testsetid );
  my %data ;
   $data {info} =  \@ret ;
  my $out; 
   my $tt = Template->new;
        $tt->process('user_test_attempt_details.html', \%data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;  
 
}elsif ( $flag eq 'GET_USER_INFO'){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my %data = get_user_details ($user_name);
    my $tt = Template->new;
        $tt->process('user_info_tmplt.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
}elsif ( $flag eq 'GET_USER_TEST_SUMMARY'){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my $sid = $cgi->param("sid"); 
   my $testsetid = $cgi->param("testsetid");
   my ($summary, $logtime)  = get_user_test_summary_info($user_name,$sid,$testsetid);
   my ($description, $detail) = get_test_set_info ( $testsetid );
   my %data;
   @data{'u_name','testsetid','desc','details','logtime','summary'} = ( $user_name, $testsetid, $description, $detail,$logtime,$summary );
   my $tt = Template->new;
        $tt->process('user_test_summary_templt.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
}elsif ( $flag eq 'GET_USER_DETAILED_TEST_SUMMARY'){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my $sid = $cgi->param("sid"); 
   my $testsetid = $cgi->param("testsetid");
   my ($summary, $logtime)  = get_user_test_summary_info($user_name,$sid,$testsetid);
   my ($description, $detail) = get_test_set_info ( $testsetid );
   my %data;
   @data{'u_name','testsetid','desc','details','logtime','summary'} = ( $user_name, $testsetid, $description, $detail,$logtime,$summary );
   my $tt = Template->new;
        $tt->process('user_test_summary_templt.html', \%data,\$out1)
        || die $tt->error;
   
   undef %data;
   
   my @all_testcases_of_testset = get_all_testcases_of_testset ( $testsetid );
   my $total_testcases = @all_testcases_of_testset;
   my $pass_count = 0;
   foreach my $key (@all_testcases_of_testset ){
      my %hash = %{$key};
      my $sln = $hash{sln};
      my $u_ans = get_user_ans_by_testsetid ($sln,$sid,$testsetid );
      $key->{'u_ans'} = $u_ans;
      if ( $u_ans =~ /$hash{answer}/i){
         $pass_count++;
      }
   }
   my $out;
   $data{tests} = \@all_testcases_of_testset;
   $tt = Template->new;
   $tt->process('examinee_report_tmplt.html', \%data, \$out)
        || die $tt->error;
    
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print "<b>Test Candidate : &nbsp&nbsp&nbsp&nbsp$user_name</b><br>".
         "<b>Test Set Id : &nbsp&nbsp&nbsp&nbsp$testsetid</b> <br>" .
         "<b>Test Description : &nbsp&nbsp&nbsp&nbsp$description</b> <br>" .
         "<b>Test Details : &nbsp&nbsp&nbsp&nbsp$detail</b> <br>" .
         "<b>Test Summary : &nbsp&nbsp&nbsp&nbsp$summary </b><br>".
         "<br><br> $out " ; 
}elsif ( $flag eq 'VERIFY_USER_NAME_EXIST'){
     my $uname = $cgi->param ( 'uname');
     my @unames = get_all_login_names ();

     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if (grep(/$uname/, @unames)) {
         print "1"            
     }else{
         print "Further Process to be done";
      
     }
}elsif ( $flag eq 'SHOW_NEW_USER_REG_FORM'){
     my $uname = $cgi->param ( 'uname');
     my (%data,$out);
     $data{uname} = $uname;
     my $tt = Template->new;
     $tt->process('show_new_user_reg_form.html', \%data, \$out)
        || die $tt->error; 
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     print "<br><br><br>$out";
}elsif ( $flag eq 'REGISTER_THIS_USER'){
     my %params = $cgi->Vars;
     foreach my $param ( keys (%params )){
         $params{$param} =~ s/^\s+//;
         $params{$param} =~ s/\s+$//; 
     }
     my %data;
     my ($user_name, $user_passwd, $user_email, $mobile, $Address, $DeliveryAddress, $FirstName, $LastName)
             = @params{ 'uname', 'uname', 'email', 'mobile', 'adress', 'dadress', 'fname', 'lname'};
     my $sql = "insert into user_info
                              ( user_name, user_passwd, user_email, mobile, Address, DeliveryAddress, FirstName, LastName )
                     values         
                           (\'$user_name\', \'$user_passwd\', \'$user_email\', \'$mobile\', \'$Address\', \'$DeliveryAddress\', \'$FirstName\', \'$LastName\')
               ;";
      my $ret = register_new_user($sql);
      
      my $uid = get_user_id_by_name_from_db ( $user_name );
      $sql = "insert into usr_roles values ( \'$uid\', '0' );";
      $ret = regiseter_new_user_role( $sql); 
      print "Content-type: text/plain; charset=iso-8859-1\n\n";
      print '<b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:green;"> Your details are registered, You can login </b><br><br>';
      print '
             <a href="login.pl">  
                <b style="font-family:Arial, Helvetica,sans-serif;font-size: large;color:blue;"> Back to Login</b>
             </a>   
            ';  
}     

1
;
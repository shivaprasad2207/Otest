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
use CGI qw(:all -utf8);
use warnings;
use CGI::Session;
use strict;

my $LoginHeader = {
                        
                        -title => 'Online Objective Test Tool',
                        -style=>[ 
                                       { -type =>'text/css', -src=>'/static/styles/My-otest/lib_1.css'},
                                      
                                    ],  
                         -script=>[
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/jquery.js'},
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/jquery.min.js' },
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/pre_logout.js' },
                                     ],
                    };




my $cgi = new CGI;
$cgi->autoEscape(undef);
print $cgi->header(-type=>"text/html", -charset=>"UTF-8");

print $cgi->start_html($LoginHeader); 

if ($cgi->param('status') eq 'error'){
    print '<p style="background-color:red;border-radius: 10px; width:300px;" border="1">Authontication ..ERROR:</p>';
}
if ($cgi->param('status') eq 'logout'){
    
    print '<p style="background-color:yellow;border-radius: 10px; width:300px;" border="1">Logout Successfully</p>';
}
if ($cgi->param('status') eq 'Alogout'){
    print '<p style="background-color:pink;border-radius: 10px; width:300px;" border="1">You have Logout Previously</p>';
}
if ($cgi->param('status') eq 'jslogout'){
    my $sid = $cgi->param('sid');
    my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'-1d',
                        );
     $cgi->redirect(-cookie=>$cookie,-location=>"login.pl?status=logout"); 
}

if ($cgi->param('status') eq 't_error'){
   my $tesetid = $cgi->param('code');
    print '<p style="background-color:pink;border-radius: 10px; width:300px;" border="1">You Donot have ' . $tesetid .
    ' Check with correct code for exam</p>';
}




print <<H12;

  <br><br>
    <span align="center" style="
                                 margin-top:70px;  
                                 margin-left:330px;
                                 
                                 background-color:#F2F5A9;
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:22px;
                                 text-align: right;
                               " 
            >
            
            Web Based Online Quiz Tool
   
   </span>
  
   
<table id="login" cellspacing="30px" border="10px" style="padding:15px;margin-left:250px">
   <tr>
   <td>
      <label> <b> Examiner Login </b> </label>
      <form  id="examiner" action="login_verify.pl" method="get">
 
         <fieldset>
         <legend> Login </legend></b></h><input type="text" name="usr_name" size="30">
         </fieldset>
 
         <fieldset>
         <legend> Password </legend></b></h><input type="password" name="passwd" size="20">
         </fieldset>
         
         <input type="submit"  name = "submit" value = "Submit" /> &nbsp &nbsp &nbsp
     
      </form>
      <br> <a href="index.pl?AppParam=NEW_USER"> New User Registation </a><br>
  </td> 
  
  
  <td>
       <label> <b> Examinee Login </b> </label>
      <form id="examinee" action="examnee_login_verify.pl" method="get">
         <fieldset>
         <legend> Login </legend></b></h><input type="text" name="usr_name1" size="30">
         </fieldset>
 
         <fieldset>
         <legend> Password </legend></b></h><input type="password" name="ENTER" size="20">
         </fieldset>
         
         <fieldset>
         <legend> Test Code </legend></b></h><input type="text" name="test_code" size="20">
         </fieldset>
         
         <input type="submit"  name = "submit" value = "Submit" /> &nbsp &nbsp &nbsp
     
      </form> 
  </td> 

 </tr>  
  
</table>
<br><br>

<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:20px;
                                 text-align: right;
                               " 
            >
            Read me Text:
   
   </span>

   <span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:15px;
                                 text-align: right;
                               " 
            >
            
           <br>
           It is web tool for meant for taking quiz, A quesation with 5 Answers. Same quiz tool you can find many in internet,<br>
           but is some exception, later explained. Here there are two type of user whose can use this tool 1.Examiner  2.Examinee<br>
           <br>
            
   </span>

<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:20px;
                                 text-align: right;
                               " 
            >
            <br>Who are the users :
   
   </span>  

<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:15px;
                                 text-align: right;
                               " 
            >
            
           <br>
           There are 2 types of user those can use this Quiz tool 1. Examiner [Sets the Quiz quesation] &nbsp&nbsp 2. Examinee [Who takes exam] <br>
           Both users has to register to the tool to work with. <br>
   </span>  
 
<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:20px;
                                 text-align: right;
                               " 
            >
            <br>Examinee :
   
   </span>    
<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:15px;
                                 text-align: right;
                               " 
            >
            
           <br>
           A Examinee can get login name by registering. If he wants take Quiz exam he need to exam Code along with login credential.<br>
           Exam Code will be given by Examiner who sets the test. It is bascially alphanumeric word. <br>
           A examinee can see tests list once logs with mentioned credential. <br>
           Once he click question dialog box will popup with quesation and answers and radio button for right answere , and submit button.<br>
           After taking exam he can see the test summary marks scored, and his session ends..<br>
   </span>     
 
<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:20px;
                                 text-align: right;
                               " 
            >
            <br>Examineer:
   
   </span>

<span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:15px;
                                 text-align: right;
                               " 
            >
            
           <br>
           A Examiner is who sets, manages test cases and reports test results atempted by user. Any register user can act Examiner <br><br>
           <b>Some Facilities provided to Examiner to manage Test cases.</b> <br>
           1. &nbsp If a examiner wants add test cases, he needs to create testset tag. By provideing few details like Description/Some details/number of
              &nbsp&nbsp&nbsp&nbsp&nbsp&nbspQuesation/time given for these testcases to complete, which belonging to testset tag or testsetid<br>
           2. &nbsp Examiner Add/View/Modify/Delete test cases belonging to testset tag. to do this he needs choose related testset tag from drop down menu.<br>
           3. &nbsp There are 2 ways Adding test cases belonging to Testset tag&nbsp&nbsp  1. &nbsp Manual adding 5 test cases each time  &nbsp&nbsp 2. &nbsp Create xls sheet with mentioned<br>
              &nbsp&nbsp&nbsp&nbsp&nbsp format having number of test cases, import sheet relating testset tag<br>
           4. &nbsp Examiner can view user details/testsummary/test result in detail. For each each teset tag [having set of quesation] <br>
           5. &nbsp He can export particul;ar set of test cases belonging to test set tag in xls format.<br>
   </span>
   <span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:15px;
                                 text-align: right;
                               " 
            >
            <br>As a Examinee Take Sample Test after registering your self Test set id : I5IH5B1N , OA5SCYAN<br>
            <br>As a Examiner create your own test sets on any technical, social ,general and ask other people to take test<br>
   
   </span>
   

   
   
   
   
   <span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:20px;
                                 text-align: right;
                               " 
            >
            <br>Scope of Tool :
   
   </span>
   <span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:15px;
                                 text-align: right;
                               " 
            >
            
           <br>
           1. &nbsp In school for objective test.<br>
           2. &nbsp In competive Entrance Objective test.<br>
           3. &nbsp Within comany to check aptitude test..<br>
           4. &nbsp Parents testing children aptitude test.<br>
           5. &nbsp More possiblities are there -:) <br>
           </b> <br>
   </span>
   
    <span align="center" style="
                                 margin-top:70px;  
                                 position:relative;
                                 font-family: verdana,arial,sans-serif;
                                 font-size:20px;
                                 text-align: right;
                               " 
            >
           <b> <br>Plese Explore the Web based Quiz Tool, it is for you to use</b>
           <br><br> 
  </span>    


H12

print '<div style="bottom:0px; float:right">
						<SMALL style="bottom:0px;float:inherit;color:#BC8F8F">
						<a href="http://www.shivaprasad.co.in" target="_blank"> ©Author </a> 
						</SMALL>
          </div>';
          
print $cgi->end_html;
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

my $cgi = CGI->new();
my $flag = $cgi->param('flag');

if ( $flag eq 'USER_DETAILS'){
   my $out1 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %data = get_user_details ($name);
   
    my $tt = Template->new;
        $tt->process('user_details.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out1;
   
}elsif($flag eq 'EDIT_USER_DETAILS'){
   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %data = get_user_details ($name);
   
    my $tt = Template->new;
        $tt->process('edit_user_details.html', \%data,\$out2)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;
}elsif($flag eq 'CHANGE_PASSWD'){
   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %data = get_user_details ($name);
   
    my $tt = Template->new;
        $tt->process('change_passwd.html', \%data,\$out2)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;

}elsif( $flag eq 'GET_USER_ROLE'){
   my $name = $cgi->param('promoted_user');
   my $role = get_user_role_str_by_name ($name);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $role;
}elsif($flag eq 'CREATE_NEW_USER'){
   my $out2 = '';
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   
   my %data = ( admin_name => $name, role => $role);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $role == 3){
         my $tt = Template->new;
        $tt->process('create_new_user.html', \%data,\$out2)
        || die $tt->error;   
   
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">Hi $name .. You are Not Admin to perform this task</b>";   
      
   }
   print $out2;
}elsif($flag eq 'SUBMIT_CREATE_NEW_USER'){
   my $out2 = '';
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %params = $cgi->Vars;
   my %data;
   
   $data{ 'adress' } = $params { 'adress' };
   $data{ 'user_login_name' } = $params { 'user_login_name' };
   $data{ 'mobile' } = $params { 'mobile' };
   $data{ 'delivery_adress' } = $params { 'delivery_adress' };
   $data{ 'last_name' } = $params { 'last_name' };
   $data{ 'user_email' } = $params { 'user_email' };
   $data{ 'first_name' } = $params { 'first_name' };
   $data{ 'role' } = "General User";
   $data{ 'password' } = $data{ 'user_login_name' };
   
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my @ret = create_new_user ( %data);
   if ( $ret[0] =~ /FAIL/){
      print @ret;   
   }else{
      my %data = get_user_details ($data{ 'user_login_name' });
      my $tt = Template->new;
        $tt->process('info_newly_created_user.html', \%data,\$out2)
        || die $tt->error;
      $out2 = $out2 . " <br> <b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\"> User $data{user_login_name} is Created Succefully</b>" ; 
      print $out2;   
   }
}elsif($flag eq 'GET_USER_BY_ROLES'){
   my @out2 = '';
   my $pat = ' <tr width="100%">
                     <td>
                           <a href="#"  onclick="javascript:get_info_of_this_user(\'NAME\');return false">
                                 NAME
                           </a>
                           <div id="load_disp_NAME"> </div>
                     </td>
                </tr>';
                
   my $shop_admin_pat = ' <tr width="100%">
                        <td>
                           <a href="#"  onclick="javascript:get_info_of_this_shop_admin(\'NAME\');return false">
                                 NAME
                           </a>
                           <div id="load_disp_NAME"> </div>
                     </td>
                </tr>';
                
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my $q_role = $cgi->param("role");
   if ( $q_role =~ /shop_admin/){
      $q_role = 1;   
   }elsif($q_role =~ /biz_admin/){
      $q_role = 2;      
   }elsif($q_role =~ /Admin/){
      $q_role = 3;   
   }else{
      $q_role = 0;    
   }

   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $role == 3){
      my @ret = get_user_list_by_role ( $q_role );
      if ( $ret[0] =~ /FAIL/){
         print @ret;   
      }else{
        if ( $q_role =~ /shop_admin/){
            foreach my $name ( @ret){
               my $t_pat =  $shop_admin_pat;
               $t_pat =~ s/NAME/$name/g;
                push ( @out2,$t_pat);
            } 
         
        }else{
            foreach my $name ( @ret){
               my $t_pat =  $pat;
               $t_pat =~ s/NAME/$name/g;
                push ( @out2,$t_pat);
            }
        }
      }
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">Hi $name .. You are Not Admin to perform this task</b>";   
   }
   print @out2;
}elsif( $flag eq 'GET_INFO_BY_LOGIN_NAME' ){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my %data = get_user_details ($user_name);
   my $role = get_user_role_str_by_name ( $user_name);
   $data{role} = $role;
    my $tt = Template->new;
        $tt->process('user_info_show_for_admin.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
   
}elsif($flag eq 'DELETE_THIS_USER'){
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my $del_name = $cgi->param("name");
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
    my @ret ;
   if ( $role == 3){
      @ret = remove_this_user_by_name ($del_name);
      if ( $ret[0] =~ /FAIL/){
         print @ret;   
      }else{
         print " <b style=\"font-family:Times New Roman, serif; font-size:20px;color:green\">
                User Accout of $del_name is deleted  Successfully </b>";
      }
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">Hi $name .. You are Not Admin to perform this task</b>";   
      
   }
   print @ret;
}elsif( $flag eq 'USER_SEARCH_BY_ADMIN' ){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my %data = get_user_details ($user_name);
   my $role = get_user_role_str_by_name ( $user_name);
   $data{role} = $role;
    my $tt = Template->new;
        $tt->process('user_search_by_admin.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
}elsif( $flag eq 'USER_SEARCH_BY_FIELD' ){
   my $out1 = '';
   my $f_name = $cgi->param("field");
   my $fval = $cgi->param("fval");
   my %data = get_user_info_by_field_val ( $f_name , $fval);
   
   print "Content-type: application/json; charset=iso-8859-1\n\n";
   my $json = encode_json \%data ;
   print $json;
}elsif( $flag eq 'GET_EXTRA_USER_FILED' ){
     my $user_role = $cgi->param("user_role");
     my $promoted_user  = $cgi->param("promoted_user");

    my %data = (
                  user_role  => $user_role,
                  promoted_user => $promoted_user,
                );
    my $out1 = '';
    my $tt = Template->new;
        $tt->process('user_search_promote_n_del.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out1; 
}elsif( $flag eq 'CHANGE_USER_ROLE_ADMIN_SEARCH'){
   my $out1 = '';
   
   
   my $name = $cgi->param( 'name' );
   my $role  = $cgi->param( 'role' );

   my $role_s = '';
   if ( $role =~ /shop_admin/){
        $role = 1; $role_s = "Shop Admin";
   }elsif( $role =~ /biz_admin/){
        $role = 2; $role_s = "Biz Admin";
   }elsif( $role =~ /user/){
        $role = 0; $role_s = "General user";
   }else{
      $role = 3;   $role_s = "Admin";
   }
   $role_s =  '<b style="font-family: monospace;color:green;font-size:larger">' . $role_s . '</b>'; 
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $promoter_name = $session->param("usr_name");
   my $promoter_role = $session->param("role");
   
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $promoter_role == 3 ){
       my @ret = commit_role_to_user ($name,$role);    
       if ( $ret[0] =~ /FAIL/){
            print @ret;   
      }else{
         print "<b style=\"font-family:Times New Roman, serif; font-size:15px;color:blue\"> $name is Promoted  to $role_s Successfully</b>";    
      }
   }else{
       print "<b style=\"font-family:Times New Roman, serif; font-size:15px;color:red\"> $promoter_name is Not Admin to perform this task</b>";       
   }
}elsif($flag eq 'SEARCH_BY_USER_FIELDS'){
   my $out2 = '';   
    my $tt = Template->new;
        $tt->process('search_by_user_fields.html', undef, \$out2)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;
}elsif($flag eq 'SEARCH_BY_USER_FIELDS_PARAMS'){
  my %q_hash ;
  
  if (   $cgi->param( 'uname')  =~ /\w+/ ) {  $q_hash{user_name} =  $cgi->param( 'uname'); }
  if (   $cgi->param( 'fname') =~ /\w+/  ) {  $q_hash{FirstName} =  $cgi->param( 'fname'); }
  if (   $cgi->param( 'lname') =~ /\w+/  ) {  $q_hash{LastName} =  $cgi->param( 'lname'); }
  if (   $cgi->param( 'adress') =~ /\w+/    ) {  $q_hash{Address} =  $cgi->param( 'adress'); }
  if (   $cgi->param( 'dadress') =~ /\w+/   ) {  $q_hash{DeliveryAddress} =  $cgi->param( 'dadress'); }
  if (   $cgi->param( 'phone')  =~ /\w+/    ) {  $q_hash{mobile} =  $cgi->param( 'phone'); }
  if (   $cgi->param( 'email')  =~ /\w+/    ) {  $q_hash{user_email} =  $cgi->param( 'email'); }  
   my @out2;
   my @ret = search_for_uname_by_user_info ( %q_hash );
   my $pat = ' <tr width="100%">
                     <td>
                           <a href="#"  onclick="javascript:get_info_of_this_user(\'NAME\');return false">
                                 NAME
                           </a>
                           <div id="load_disp_NAME"> </div>
                     </td>
                </tr>';
   
   
   
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret[0] =~ /PASS/){
         delete ($ret[0]);
          foreach my $name ( @ret){
            my $t_pat =  $pat;
            $t_pat =~ s/NAME/$name/g;
            push ( @out2,$t_pat);
         }
         print @out2;   
    }else{
         print " <b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">
                @ret </b>";
   }
}elsif($flag eq 'CHECK_UNAME_AVAIL'){
   my $uname = $cgi->param("uname");
   my $ret = find_exact_user_name($uname);
   if ( $ret ){
            print "Content-type: text/plain; charset=iso-8859-1\n\n";  
            print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
            print "User with that uname already available, chose different</br>";
   }else{
            print "Content-type: text/plain; charset=iso-8859-1\n\n";  
            print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:green\">" ;
            print "You can Use this uname </br>";
   }
   
}elsif ( $flag eq 'CREATE_FRESH_USER'){
   my %params = $cgi->Vars;
   my %data;
   $data{ 'adress' } = $params { 'adress' };
   
   $data{ 'mobile' } = $params { 'mobile' };
   $data{ 'delivery_adress' } = $params { 'delivery_adress' };
   $data{ 'last_name' } = $params { 'last_name' };
   $data{ 'user_email' } = $params { 'user_email' }; 
   $data{ 'role' } = "General User";
   ($data{ 'first_name' }, $data{ 'user_login_name' }) = split ':' , $params {'first_name' };
   $data{ 'password' } =   $data{ 'user_login_name' };
  
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my @ret = create_new_user ( %data);
   
   if ( $ret[0] =~ /FAIL/){
      print '<b style="font-family:Times New Roman, serif; font-size:20px;color:green">'  . "User Account Not created" . @ret . "</b>";

   }else{
      print '<b style="font-family:Times New Roman, serif; font-size:20px;color:blue">' .
               "User ". $data{ 'user_login_name' } . "  Account created </b>" ;
      print '<a href="http://localhost/cgi-bin/My-Pizza/login.pl">
                  "<b style="font-family:Times New Roman, serif; font-size:20px;color:green">"              
                     Login through Pizza Home Page
                  </b>
            </a> ';
   }
 
}elsif ( $cgi->param('flag') =~ /CHANGE_PASSWD_SUBMIT/ ){
   my $old_passwd =  $cgi->param('old_passwd');
   my $passwd_1 =  $cgi->param('passwd_1');
   my $passwd_2 =  $cgi->param('passwd_2');
   my $user_name =  $cgi->param('user_name');
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( is_user_authorised ( $user_name , $old_passwd )  ){
      if ( $passwd_1 eq $passwd_2){
            my @val = change_user_passwd ( $user_name, $passwd_1 );
            if ( $val[0] =~ /FAIL/){
               print @val;
            }else{
               print '<b style="font-family:Times New Roman, serif; font-size:20px;color:blue">  Password Changed Successfully</b>'; 
            }
      }else{
         print '<b style="font-family:Times New Roman, serif; font-size:20px;color:red"> Passwords Enter are Not Same </b>';     
      } 
   }else{
      print '<b style="font-family:Times New Roman, serif; font-size:20px;color:red">  User Not Authorised change Password</b>';  
   }
   
}elsif ( $cgi->param('flag') =~ /SUBMIT_USER_DETAILS/ ){
   my %params = $cgi->Vars;
    my @ret = edit_user_info ( %params );
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret[0] =~ /FAIL/){
       print @ret;
   }else{
      print '<b style="font-family:Times New Roman, serif; font-size:20px;color:blue">  Edited User infor Succsessfully update</b>'; 
   }
}


1
;







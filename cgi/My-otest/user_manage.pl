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


my $cgi = CGI->new();
my $flag = $cgi->param('flag');

if($flag eq 'CREATE_NEW_USER'){
   my $out2 = '';
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   
   my %data = ( admin_name => $name, role => $role);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $role == 1){     
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
      $out2 = $out2 . " <br> <b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\"> User $data{user_login_name} is Created Succefully</b>" ; 
      print $out2;   
   }
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
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret[0] =~ /PASS/){
         delete ($ret[0]);
         my %data;
         my $out2;
         $data{USERS} = \@ret;
         my $tt = Template->new;
         $tt->process('search_list_by_user_info.html', \%data,\$out2)
             || die $tt->error;
         print $out2;   
    }else{
         print " <b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">
                @ret </b>";
   }
}elsif( $flag eq 'GET_INFO_BY_LOGIN_NAME' ){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my %data = get_user_details ($user_name);
    my $tt = Template->new;
        $tt->process('user_info_show_for_admin.html', \%data,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
   
}elsif( $flag eq 'SHOW_SERACH_BOOK_PID_TMPLT' ){
   my $out1 = '';
    my $tt = Template->new;
        $tt->process('show_book_pid_tmplt.html', undef,\$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
   
}elsif( $flag eq 'SHOW_INFO_OF_BOOK_PID' ){
      my $book_pid = $cgi->param ('book_pid');
      my %book_info   = get_book_info_by_book_pid ( $book_pid);
      my $book_id = $book_info{book_id};
      $book_info{book_pid} = $book_pid;
      my $out;
      my $tt = Template->new;
        $tt->process('book_info_all_by_book_pid.html', \%book_info, \$out)
        || die $tt->error;
      print "Content-type: text/plain; charset=iso-8859-1\n\n";
      print $out;
      my $book_copy = $book_pid;
      $book_copy =~  s/^\s+//;
      $book_copy =~ s/\s+$//;
      my @res_dates = get_reservation_info_by_book_pid ( $book_copy );
      my @res;
      my %data ;
      my $out1;
      foreach my $date_slot ( @res_dates ){
         my ($start_date,$end_date ) = ($date_slot->{start_date}, $date_slot->{end_date});
         my $reservation = "START DATE : &nbsp $start_date  &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp END DATE: &nbsp $end_date" . '<br>' ;
         my $resv_info = {};
         $resv_info->{reservation} = $reservation;
         $resv_info->{uname} = $date_slot->{uname};
         $resv_info->{start_date} = $date_slot->{start_date};
         $resv_info->{end_date} = $date_slot->{end_date};
         $resv_info->{book_pid} = $book_copy;
         push @res , $resv_info ;
      }
      undef $out;
      $data{tag} = $book_copy;
      $data{book_id} = $book_id;
      $data{reservation} = \@res;
      $tt = Template->new;
        $tt->process('admin_view_book_tag_info.html', \%data, \$out)
        || die $tt->error;
      print $out;   
      undef @res; undef %data; undef $out ;
      
}elsif( $flag eq 'DEL_RESRVD_BOOK_TAG' ){
   my $user_name = $cgi->param ('uname');
   my $start_date = $cgi->param ('start_date');
   my $end_date = $cgi->param ('end_date');
   my $book_pid = $cgi->param ('book_pid');
   my $uid = get_user_id_by_name_from_db ( $user_name );
   my $sql = "
               update book_reservation set
                     status = \'0\' 
               where
                     uid = \'$uid\' and
                     start_date = \'$start_date\' and 
                     end_date = \'$end_date\' and
                     book_pid = \'$book_pid\' 
   ;";

   my $ret =  delete_reserve_by_book_id ( $sql);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret ){
      print "<br><br><br><br> <b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">
              Book Reservation of Book TAG $book_pid done by $user_name has been deleted Successfull 
              </b>";
   }else{
      print " <b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">
              Something gone Wrong Book !! <br>
              Not Sure Reservation of Book TAG $book_pid done by $user_name has been deleted Successfully OR Not.
              To be Reported.
              </b>"; 
   }
}elsif($flag eq 'USER_FIELDS_BOOK_CHECK'){
    my $out2 = '';
    my %data ;
    $data{flag} = 1;
    my $tt = Template->new;
        $tt->process('search_by_user_fields.html', \%data , \$out2)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;
}elsif($flag eq 'USER_FIELDS_BOOK_CHECK_PARAMS'){
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
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret[0] =~ /PASS/){
         delete ($ret[0]);
         my %data;
         my $out2;
         $data{USERS} = \@ret;
         $data{flag} = 1;
         my $tt = Template->new;
         $tt->process('search_list_by_user_info.html', \%data,\$out2)
             || die $tt->error;
         print $out2;   
    }else{
         print " <b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">
                @ret </b>";
   }
}elsif( $flag eq 'GET_BOOK_INFO_BY_LOGIN_NAME' ){
   my $out1 = '';
   my $user_name = $cgi->param("user_name");
   my $role = 1;
   my $uid = get_user_id_by_name_from_db ( $user_name );
   my @ret = get_all_reserved_books_by_uid ( $uid);
   my %info;
   %info = ( ret => \@ret );
   my $tt = Template->new;
        $tt->process('saved_reservation.html', \%info, \$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print '<br>'. '<br>' . $out1; 
   
}elsif($flag eq 'DEL_USER'){
    my $out2 = '';
    my %data ;
    $data{flag} = 2;
    my $tt = Template->new;
        $tt->process('search_by_user_fields.html', \%data , \$out2)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;
}elsif($flag eq 'DEL_USER_CHECK_PARAMS'){
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
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret[0] =~ /PASS/){
         delete ($ret[0]);
         my %data;
         my $out2;
         $data{USERS} = \@ret;
         $data{flag} = 2;
         my $tt = Template->new;
         $tt->process('search_list_by_user_info.html', \%data,\$out2)
             || die $tt->error;
         print $out2;   
    }else{
         print " <b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">
                @ret </b>";
   }
}elsif($flag eq 'DELETE_THIS_USER'){
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my $del_name = $cgi->param("name");
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
    my @ret ;
   if ( $role == 1){
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
}elsif($flag eq 'USER_PROMOTE'){
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $out2 ;
   if ( $role == 1){
      my $tt = Template->new;
         $tt->process('user_promote.html', undef ,\$out2)
             || die $tt->error;
         print $out2;         
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">You are Not Admin to perform this task</b>";   
      
   }
}elsif($flag eq 'PROMOTE_USER_TO_ADMN'){
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my $uname = $cgi->param("uname");
   my $uid = get_user_id_by_name_from_db ( $uname );
   my $sql = "update usr_roles set role =\'1\' where uid=\'$uid\';";
   my $ret = promote_user_to_librarian ( $sql );
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print "<br><br>&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp
          <b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">$uname is promoted to Librarian  </b>
           &nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp
          ";  
   
}elsif($flag eq 'DEPROMOTE_USER'){
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $out2 ;
   if ( $role == 1){
      my $tt = Template->new;
         $tt->process('depromote_user.html', undef ,\$out2)
             || die $tt->error;
         print $out2;         
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">You are Not Admin to perform this task</b>";   
      
   }
}elsif($flag eq 'DEPROMOTE_USER_FROM_ADM'){
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my $uname = $cgi->param("uname");
   my $uid = get_user_id_by_name_from_db ( $uname );
   my $sql = "update usr_roles set role =\'0\' where uid=\'$uid\';";
   my $ret = promote_user_to_librarian ( $sql );
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print "<br><br>&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp
          <b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">$uname is Depromoted to general user  </b>
           &nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp
          ";  
   
}




1
;







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
use POSIX qw/strftime/;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
require CGI::Session;
use Data::Dumper;
use lib::DB_OBJ;
use Template;
our  $PizzaOrderHeader;
my %order_info;


sub register_new_user{
   my ($sql) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;  
}

sub regiseter_new_user_role{
   my ($sql) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;  
}


sub get_all_login_names {
   my @ret = get_all_login_names_from_db ();
   return @ret;
}

sub get_user_test_summary_info {
   my($user_name,$sid,$testsetid) = @_;
   my @ret = get_user_test_summary_info_db ($user_name,$sid,$testsetid);
   return @ret;
}

sub get_user_details {
   my ($login_name) = @_;
   my ($status, %data)  = get_user_details_by_login_name ( $login_name );
   if ($status =~ /PASS/){
      $data{status} = 'PASS';
     
   }else{
      $data{status} = 'FAIL';
      @{$data{error}} = %data;
   }
    return %data;
}

sub create_uniq_test_set_id {
         my $length_of_randomstring=shift;
         my @chars=('A'..'Z','0'..'9');
         my $random_string;
         foreach (1..$length_of_randomstring){
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}

sub update_summary_of_test{
   my ( $sid,$test_set_id ,$test_summary) = @_;
   my $sql = "update register_test_attempt
                                 set test_summary=\'$test_summary\'
                                 WHERE sid=\'$sid\' and testsetid=\'$test_set_id\'; "; 
   my $ret = my_sql_exec ( $sql );
   return $ret;
}



sub get_user_ans_by_testsetid {
   my ($sln,$sid,$test_set_id ) = @_;
   my $sql = "select atmpt_ans from attempt_table where sln=\'$sln\' and sid = \'$sid\' and test_set_id = \'$test_set_id\';";   
   my $ret = get_user_ans_by_testsetid_db ( $sql);
   return $ret;
}


sub  get_user_id_by_name_from_db{
   my ( $user_name ) = @_;
   my $user_id = get_user_id_by_name ($user_name);
   return $user_id;
}

sub create_new_test_id {
   my ( $sql ) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;
}

sub delete_this_testcase_of_testset{
   my ( $sql ) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;
}


sub reset_test_id_sln{
   my ($testsetid) = @_;
   my $ret = reset_test_id_sln_db ($testsetid);
   return $ret;
}


sub modify_testcase_of_testset {
   my ( $sql ) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;
   
}

sub get_test_set_ids_of_by_uid {
   my ( $uid) = @_;
   my $sql = "select test_set_id from t_test_set_info where uid=\'$uid\';";
   my @ret = my_sql_exec_ret_array (   $sql );
   return @ret;
}

sub get_user_name_by_uid {
   my ($uid) = @_;
   my $ret = get_user_name_by_id ( $uid);
}

sub get_test_set_info{
   my ( $testsetid ) = @_;
   my $sql = "select description, extra_info from t_test_set_info where test_set_id=\'$testsetid\';"; 
   my @ret = get_test_set_info_from_db ( $sql);  
   return @ret;
}

sub get_all_testset_info{
   my ( $testsetid ) = @_;
   my $sql = "select uid, description, extra_info, test_case_count, timeset from t_test_set_info where test_set_id=\'$testsetid\';"; 
   my %ret = get_all_testset_info_from_db( $sql);  
   return %ret;
}

sub get_testcase_by_sln {
   my ( $sln , $testsetid ) = @_;
   my $sql = "select quesation, q_a, q_b , q_c , q_d , q_e  from t_test_case_info where test_set_id=\'$testsetid\' and sln=\'$sln\';";
   my %ret = get_testcase_by_sln_db ($sql); 
   return %ret;
}


sub get_test_case_count_by_testsetid{
    my ( $testsetid ) = @_;
    my $sql = "select COUNT(*) from t_test_case_info where test_set_id=\'$testsetid\';";
    my $ret = get_test_case_count_by_testsetid_db ( $sql);
    return $ret;
}

sub  update_user_ans {
   my ( $sql ) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;
}   

sub add_a_testcase_to_testset {
   my ( $sql ) = @_;
   my $ret = my_sql_exec ( $sql );
   return $ret;
}

sub get_all_testcases_of_testset {
   my ( $testsetid ) = @_;
   my @ret =  get_all_testcases_of_testset_db ( $testsetid );   
   return  @ret;
}

sub GetBasename {
	my $fullname = shift;
	my(@parts);
	# check which way our slashes go.
	if ( $fullname =~ /(\\)/ ) {
		@parts = split(/\\/, $fullname);
	} else {
		@parts = split(/\//, $fullname);
	}
	return(pop(@parts));
}

sub register_test_attempt {
   my (%data) = @_;
   my ($test_set_id, $user_name, $timestamp, $sid  ) = @data{'testsetid','uname','logtime','sid'};
   my $sql = "insert into register_test_attempt value (\'$test_set_id\', \'$user_name\', \'$timestamp\' , \'$sid\', 'NO Result');";
   my $ret = my_sql_exec ( $sql );
   return $ret;
}

sub is_attempt_registered {
   my ($sid) = @_;
   my $sql = "select COUNT(*) from register_test_attempt where sid=\'$sid\';";
   my $ret = is_attempt_registered_db ( $sql);
   return $ret;
}

sub initialize_the_attempt_table{
   my($sid,$test_set_id) = @_;
   my $ret = initialize_the_attempt_table_db ( $sid, $test_set_id );
   return $ret;
}

sub get_reg_testcases_from_attempt_table {
     my($sid,$test_set_id) = @_;
     my @ret = get_reg_testcases_from_attempt_table_db($sid,$test_set_id );
     return @ret;
}

sub get_users_attaempted_tesetid {
   my ($testsetid ) = @_;
   my @ret = get_users_attaempted_tesetid_db ( $testsetid  );
   return @ret;
   
}


##################################################
sub get_reservation_info_by_book_pid {
    my ( $book_copy ) = @_;
    my @ret = get_reservation_info_by_book_pid_from_db ( $book_copy );
    return @ret;
}


sub get_book_info_by_book_pid {
    my ($book_pid) = @_;
    my %book_info = get_book_info_by_book_pid_from_db ( $book_pid );
    return %book_info;
  
}

sub get_reservation_dates {
   my ( $book_copy ) = @_;
   my @ret = get_reservation_dates_from_db ( $book_copy );
   return @ret;
}

sub get_serached_books {
    my ( $sql ) = @_;
    my @book_info = get_serached_books_from_db ( $sql );
    return @book_info;
}

sub get_time_stamp {
   my $date = strftime('%Y-%m-%d %H:%M:%S',localtime);   
   return $date;
}

sub get_book_details_by_id {
    my ($book_id) = @_; 
    my %data = get_book_details_by_id_from_db ( $book_id);
    return %data;
}

sub get_book_copies_by_id {
   my ($book_id) = @_; 
    my @book_copies  = get_book_copies_by_id_from_db ( $book_id);
    return @book_copies ;
}

sub get_all_category_of_books {
    
    my @ret = get_all_category_of_books_from_db ( );
   
   return @ret; 
   
}

sub get_all_subcategory_of_books {
    
    my @ret = get_all_subcategory_of_books_from_db ( );
   
   return @ret; 
   
}

sub get_all_reserved_books_by_uid {
   my ( $uid) = @_;
   my @ret = get_all_reserved_books_by_uid_from_db ( $uid);
   return @ret;

}
sub create_uniq_mail_index_string {
         my $length_of_randomstring=shift;
         my @chars=('a'..'z','A'..'Z','0'..'9','_');
         my $random_string;
         foreach (1..$length_of_randomstring){
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}

sub get_sender_mail_name {
   my ( $mail_id ) = @_;
   my @sender_name = get_mail_sender_name_from_db ( $mail_id );
   return @sender_name;
}

sub get_reciever_mail_name {
   my ( $mail_id ) = @_;
   my @reciever_name = get_mail_reciever_name_from_db ( $mail_id );
   return @reciever_name;
}

sub get_subject_text_by_mail_id {
      my ( $mail_id ) = @_;
      my @subject = get_subject_text_by_mail_id_from_db ( $mail_id );
      return @subject;
   
}





sub reserve_this_book_copy {
   my ( $sql ) = @_;
   my $mesg = reserve_this_book_copy_into_db ( $sql );
   return $mesg; 
}

sub rev_transform_hash {
   my (%params) = @_;
   my %rev_params;
   foreach my $param (keys (%params)){
      $rev_params{$params{$param}} = $param;
   }
   return %rev_params;
}

sub generate_random_string {
    my $wordsize = shift;
    my @alphanumeric = ('a'..'z', 'A'..'Z', 0..9);
    my $randword = join '', 
           map $alphanumeric[rand @alphanumeric], 0..$wordsize;
    return $randword;
}



sub edit_user_info {
   my (%params) = @_;
   my @ret = update_user_info_to_db(%params) ;
   if ($ret[0] =~ /FAIL/){
     return @ret;
   }else{
      return ( 'PASS');
   }
}



sub is_valid_user {
    my ($cgi) = @_;
    my $sid = $cgi->cookie('CGISESSID');
    if ($sid){
        my $session = CGI::Session->new( $sid );
        my $name = $session->param("usr_name");
        my $role = $session->param("role");
        return ($name,$role);
    }else {
        my $cookie = $cgi->cookie(
                            -name=>'CGISESSID',
                            -value=>$sid,
                            -expires=>'-1d',
                        );
        print $cgi->redirect(-cookie=>$cookie,-location=>"login.pl?status=Alogout"); 
        return;    
    }
}

sub is_user_authorised{
   my  ( $user_name , $user_passwd ) = @_;
   if ( user_authentication ( $user_name , $user_passwd )){
      return 1;   
   }else{
      return 0;
   }
}

sub change_user_passwd {
   my  ( $user_name , $user_passwd ) = @_;
   my @ret = update_user_password ($user_name , $user_passwd );
   return @ret;
}


sub return_setting_page_for_ShopAdmin  {
      my ($user_name ) = @_;
      my $uid =  get_user_id_by_name ($user_name);
      my $data = {
                  'name' => $user_name,
                  'uid' => $uid,
               };
      my $out = ''; 
      my $tt = Template->new;
        $tt->process('ShopAdmin_functions.html', $data, \$out)
        || die $tt->error;
      
      #die $out ;
    return $out;
   
}


sub return_mail_page_for_user {
   my ($user_name,$role ) = @_;
    my $data = {
                  'name' => $user_name,
               };
    
    my $templet_file;
    if ( $role == 0){ #General User
     $templet_file = "general_user_mail_page.html";
    }elsif ( $role == 1){ 
          $templet_file = "shop_admin_mail_page.html"; 
    }elsif ( $role == 2){ 
          $templet_file = "shop_admin_mail_page.html"; 
    }else{ 
          $templet_file = "shop_admin_mail_page.html"; 
    }
    my $out = ''; 
    my $tt = Template->new;
        $tt->process($templet_file, $data, \$out)
        || die $tt->error;
        
    return $out;
  
}

sub get_new_id{
    my $new_book_id = get_new_book_id_from_db ();
    return $new_book_id ;
}


sub promote_user_to_librarian {
   my ( $sql ) = @_;
    my $ret = my_sql_exec ( $sql );
    return $ret;
}


sub get_all_book_info {
      my ($sql) = @_;
      my @book_info = get_all_book_info_from_db($sql);
      return @book_info;
}



sub add_new_book_by_admin {
    my ($sql) = @_;
    my $ret = my_sql_exec ( $sql );
    return $ret;
}

sub add_new_book_tag_by_admin {
    my ($sql) = @_;
    my $ret = my_sql_exec ( $sql );
    return $ret;
}

sub remove_this_user_by_name {
      my ($user_name ) = @_;
      my @ret = delete_this_user_by_name ($user_name );
      return (' PASS USER ACCOUNT Deleted');
}



sub get_user_list_by_role {
   my ( $q_role ) = @_;
   my @ret = get_user_list_by_role_from_db ( $q_role );
   return @ret;
   
}


sub send_mail_to_customer_about_shipment {
    my ( $shipment_id,  $mail_id ,$mail_subject, $mail_content) = @_;
    
    my %ret = get_all_details_about_shop_id ( $shipment_id ) ; 
    if ( defined ($ret{error}) ){
        die ($ret{error});
    }else{
         my $shop_admin_name  = get_user_name_by_id  ( $ret{shop_admin_id} );   
         my $user_name  = get_user_name_by_id  ( $ret{sender_id} );
         my %mail ;

         
         $mail{ r_uid } = $ret{sender_id} ;
         $mail {reciever_name} = $user_name ;
         $mail{ sender_name } =  $shop_admin_name ;
         $mail{ s_uid } = $ret{shop_admin_id};
         $mail{ recieve_group } = $user_name ;
         
         $mail{ mail_unique_id } =  create_uniq_mail_index_string ( 8 );
         $mail{ subject } = $mail_subject;
         $mail{mail_read} = '0';
         $mail{ sent_date } = get_time_stamp ();
         $mail{ delted } = '0';
         
         my $mail_index = update_mail_info ( %mail ) ;
         
         my $mail_fp = 
                  "<pre>________  START OF ORIGINAL MESSAGE_______\n".
                  "SEND DATE : $mail{ sent_date }  \n" .
                  "SENDER NAME :$mail{ sender_name } \n" .
                  "RECIEVER : $mail{reciever_name}   \n".
                  "RECIEVER GROUP: $mail{ recieve_group } \n" .
                  "SUBJECT : $mail_subject  \n" .
                  "Mail Content: $mail_content         \n".
                  "_____________________END OF ORIGINAL MESSAGE  _______</pre>\n"; 
       
        my (
               $included_mail_ids,  $mail_id_inclusion_type,
               $external_mail_id_used, $external_mail_id_used_type
            )
            =
            (  'NA' , 'NA', 'NA' , 'NA'); 
        my @ret_val = insert_mail_content (
                                          $mail{ mail_unique_id } , $mail_subject, $mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
                                        );   
         
         if ( $ret_val[0] eq 'FAIL'){
            die  @ret_val;  
         }else{
            return 1;
            
         }
    }  
   
}

sub delete_reserved_book_pid {
    my ($book_pid) = @_;
    my $sql = "update book_reservation set status=\'0\' WHERE book_pid=\'$book_pid\'; ";
    my $ret = my_sql_exec( $sql );
    return $ret;
   
}



sub search_for_uname_by_user_info {
    my (%q_hash) = @_;
    
    my $sql = 'select user_name from user_info where ';
    my @queries;
    foreach my $field ( keys (%q_hash)){
        my $val = $q_hash{$field};
        my $t_sql = "$field like  \'%$val%\'  " ;
        push @queries, $t_sql ;
    }
    
    my $t_sql = join ' OR ' , @queries;
    $sql = $sql . $t_sql;
   my @ret =  search_for_uname_by_user_info_db ( $sql ); 
   
}

sub create_new_user {
   my (%data) = @_;
   
   my @ret = create_new_user_in_db ( %data);
   if ( $ret[0] =~ /FAIL/ ){
         return @ret;
   }
   return ('PASS');
}

sub get_user_specific_info {
   my ( $id_x, $term ) = @_;
   my ( @ret ,@ings);
   
   if ( $id_x =~ /uname/){ 
      @ret = get_all_login_names_from_db ();
      @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /fname/){ 
      @ret = get_all_login_fnames_from_db ();
      @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /lname/){ 
     @ret = get_all_login_lnames_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /adress/){ 
     @ret = get_all_login_adress_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /dadress/){ 
     @ret = get_all_login_dadress_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /phone/){ 
     @ret = get_all_login_phones_from_db ();
     @ings  = grep {/$term/} @ret;
   }elsif ( $id_x =~ /email/){ 
     @ret = get_all_login_emails_from_db ();
     @ings  = grep {/$term/} @ret;
   }
   return @ings;     
}


sub get_mail_fp_by_mail_id {
   my ($mail_id) = @_;
   my @ret  = get_mail_fp_by_mail_id_from_db ($mail_id);
   
}

sub get_all_included_mailds {
   my ($mail_id) = @_;
   my @all_included_maild_ids = get_all_included_mailds_from_db ( $mail_id );
   
}

sub get_user_info_by_field_val {
   my ( $f_name , $fval) = @_;
   my %data = get_user_info_by_field_val_db ( $f_name , $fval);
   return %data;
}

sub set_all_included_maild_meta {
   my ($mail_id) = @_;
   my @ret = get_all_included_mail_ids_used_by_mail ( $mail_id );
   my @res ;
   if ( $ret[0] !~ /FAIL/ ){
      my @inc_mail_ids = @ret;
      foreach my $Imail_id (@inc_mail_ids ){
         my @ret = update_inc_mail_ids_meta ( $Imail_id ) ;
         push (@res , @ret);
      }
   }
      return @res;
}


sub  fetch_user_mail_by_id {
    my ($name, $uid, $mail_id) = @_;
    my $sql =   "select subject, mail_read, sender_name, sent_date, recieve_group , reciever_name 
                     from
                  t_mail_box
                        where reciever_name=\'$name\' and delted != '1' and mail_unique_id=\'$mail_id\';
                     
                ";
   my %data = get_mail_params_from_db ( $sql );
   if ( $data{status} !~ /FAIL/){    
      $sql =   "select mail_content from t_mail_content mail_unique_id=\'$mail_id\'; "; 
      my @ret = get_mail_content_from_db_by_mail_id  ( $mail_id );
      if ( $ret[0] =~ /FAIL/ ){
         $data{error} = $ret[1];
         return %data;
      }else{
         $data{mail_content} = $ret[1];
         return %data;
      }
   }else{
      return $data{error};  
   }
}

sub update_draft_mail {
   my(%data) = @_;
   my @ret = insert_into_draft_box ( %data);
   return @ret;   
}   

sub fetch_user_mail_by_id_from_table {
     my ($name, $uid, $mail_id , $table) = @_;
   
     my $sql = "
                     select subject, mail_read, sender_name, sent_date, recieve_group , reciever_name 
                     
                     from t_mail_trash_box  
                 
                     where reciever_name=\'$name\' and delted != '1' and mail_unique_id=\'$mail_id\';
                ";
    
      my %data = get_mail_params_from_db ( $sql );
      if ( $data{status} !~ /FAIL/){    
         $sql =   "select mail_content from t_mail_trash_content mail_unique_id=\'$mail_id\'; "; 
         my @ret = get_mail_content_from_db_by_mail_id  ( $mail_id );
      if ( $ret[0] =~ /FAIL/ ){
         $data{error} = $ret[1];
         return %data;
      }else{
         $data{mail_content} = $ret[1];
         return %data;
      }
   }else{
      return $data{error};  
   }
}   


sub get_mail_content {
   my ($mail_id) = @_;
   my $mail_content = get_mail_content_from_db_by_mail_id ($mail_id );
   return  $mail_content;
}


sub get_list_of_uid_and_name_of_Librarian{
    my %data = get_list_of_uid_and_name_of_Library_Admins ( '1') ;
    return %data;
}


sub local_my_get_style(){

my $style =<<"EOT";
 
.new_css {
    border: 1px solid #006;
    background: #ffc;
}
.new_css:hover {
    border: 1px solid #f00;
    background: #ff6;
}

.button {
    border: none;
    background: url('/forms/up.png') no-repeat top left;
    padding: 2px 8px;
}
.button:hover {
    border: none;
    background: url('/forms/down.png') no-repeat top left;
    padding: 2px 8px;
}
label {
    display: block;
    width: 150px;
    float: left;
    margin: 2px 4px 6px 4px;
    text-align: right;
}
br { clear: left; } 

   
EOT

return $style;

}

sub update_mail_info {
   my (%mail) = @_;
   my $sql = "insert into t_mail_box (
                                     
                                       r_uid,         mail_unique_id ,
                                       subject,       mail_read ,
                                       s_uid ,        sender_name,
                                       sent_date ,    delted,
                                       recieve_group, reciever_name
                                   )
                                       values 
                                   (
                                       \'$mail{ r_uid }\'         ,  \'$mail{ mail_unique_id }\' ,
                                       \'$mail{ subject }\'       ,  \'$mail{mail_read}\'         ,
                                       \'$mail{ s_uid }\'         ,  \'$mail{ sender_name}\'   ,
                                       \'$mail{ sent_date }\'     ,  \'$mail{ delted }\'   ,
                                       \'$mail{ recieve_group}\'  ,  \'$mail{reciever_name}\'
                                   );";
      my @ret = insert_mail_header_info ( $sql) ;
      if ( $ret[0] ne 'FAIL' ){
            $sql = " select mail_unique_id from t_mail_box
                                    where
                                          r_uid          =     \'$mail{ r_uid }\'         and
                                          subject        =     \'$mail{ subject }\'       and
                                          mail_read      =     \'$mail{mail_read}\'       and
                                          s_uid          =     \'$mail{ s_uid }\'         and
                                          sender_name    =     \'$mail{ sender_name}\'    and
                                          sent_date      =     \'$mail{ sent_date }\'     and
                                          delted         =     \'$mail{ delted }\'        and
                                          recieve_group  =     \'$mail{ recieve_group}\'  and 
                                          reciever_name  =     \'$mail{reciever_name}\'  
         
               ";
               my @ret = select_mail_uniq_index_from_db ( $sql) ;
               if ( $ret[0] ne 'FAIL' ){
                  return  $ret[1]; 
               }else{
                  return @ret;
               }
      }else{
         return @ret;   
      }
}

sub  rec_find_all_mail_id_inf_action {
   my ( $mail_id ) = @_ ;
   my @mail_ids ;
   my $t_mail_id  = $mail_id ;
   while ( 1 ){
         my $ret =  get_included_mail_id ( $t_mail_id) ;
         if ( !$ret ) {
                  last;
         }elsif ( $ret eq 'NA'){
                  last;
         }else{
            push ( @mail_ids , $ret);
            $t_mail_id = $ret;
         }
   }
   if ( @mail_ids ){
      return @mail_ids ;   
   }else{
      return  ( $mail_id );  
   }
}


sub rec_find_all_mail_id_move_trash_action {
   my ( $mail_id ) = @_ ;  
   my @mail_ids ;
   my $t_mail_id  = $mail_id ;
   while ( 1 ){
         my $ret =  get_included_mail_id_in_trash ( $t_mail_id ) ;
         if ( !$ret ) {
                  last;
         }elsif ( $ret =~ /NA/){
                  last;
         }else{
            my( $table , $mail_id) = split ':', $ret;
            push ( @mail_ids , $ret);
            $t_mail_id = $mail_id;
         }
   }
   if ( @mail_ids ){
      return @mail_ids ;   
   }else{
      return  ( "t_mail_trash_content" . ':' . $mail_id );  
   }

}


sub get_included_mail_id_in_trash {
   my ( $mail_id ) = @_;
   my $sql =   "select included_mail_ids from t_mail_content where mail_unique_id=\'$mail_id\'";  
   my @ret =  db_exec_single_val_ret ( $sql ); 
   if ( $ret[0] eq 'FAIL' ){
      $sql =   "select included_mail_ids from t_mail_trash_content where mail_unique_id=\'$mail_id\'";     
      my @ret =  db_exec_single_val_ret ( $sql );
      if ( $ret[0] eq 'FAIL' ){
         return  0 ;
      }else{
         return "t_mail_trash_content" . ':' . $ret[0] ;    
      }
      return  0 ;
   }else{
      return "t_mail_content" . ':' . $ret[0] ;   
   }
}


sub get_mail_fp_from_a_table_from_db {
    my ( $table , $mail_id ) = @_;
    my $sql = "select mail_fp from " . $table . " where mail_unique_id=\'$mail_id\'" ; 
    my @ret =  db_exec_string_ret ( $sql ); 
   if ( $ret[0] eq 'FAIL' ){
      return  0 ;     
   }else{
      return $ret[0];
   }
   
}

sub get_included_mail_id {
   my ( $mail_id ) = @_;
   my $sql =   "select included_mail_ids from t_mail_content where mail_unique_id=\'$mail_id\'";  
   my @ret =  db_exec_single_val_ret ( $sql ); 
   if ( $ret[0] eq 'FAIL' ){
      return  0 ;
   }else{
      return $ret[0];   
   }
}

sub get_mail_fp_of_mail_id {
   my ($mail_id ) = @_;
   my @ret = get_mail_fp_from_db_by_mail_id( $mail_id  );
   return @ret;
   
}
sub insert_mail_content{
   my (
        $mail_index , $mail_content,$mail_fp ,
        $included_mail_ids,  $mail_id_inclusion_type,
        $external_mail_id_used, $external_mail_id_used_type
     ) = @_;
   
   
   
   my @ret = insert_mail_content_info (
                                          $mail_index , $mail_content,$mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
                                        );
   return @ret;
}

sub delete_this_mail{
   my ( $mail_id) = @_;
   my @ret = delete_this_mail_from_db ($mail_id);
   return @ret;
}

sub delete_this_draft_mail{
   my ( $mail_id) = @_;
   my @ret = delete_this_draft_mail_from_db ($mail_id);
   return @ret;
}

sub find_exact_user_name {
     my ( $uname ) = @_;
     my $sql = "select user_name from user_info where user_name=\'$uname\';";
     my $ret = db_exec_return_boolean ( $sql );
     return $ret;
}

sub fetch_user_mail {
   my ( $uname, $uid) = @_;
   my $sql =   "select  mail_unique_id,   subject,    mail_read,
                        sender_name,      sent_date,  recieve_group , reciever_name 
                        from
                  t_mail_box
                        where r_uid=\'$uid\' and reciever_name=\'$uname\' and delted != '1'
                        order by sent_date desc;
                ";
   my @ret = fetch_user_mail_from_db ( $sql);
   return @ret;
}


sub fetch_user_sent_mail {
   my ( $uname, $uid) = @_;
   my $sql =   "select  mail_unique_id,   subject,    mail_read,
                        sender_name,      sent_date,  recieve_group , reciever_name 
                        from
                  t_mail_box
                        where s_uid=\'$uid\' and sender_name=\'$uname\' and delted != '1'
                        order by sent_date desc;
                ";
   my @ret = fetch_user_mail_from_db ( $sql);
   return @ret;
}

sub fetch_user_trash_mail {
 my ( $uname, $uid) = @_;
   my $sql =   "select  mail_unique_id,   subject,    mail_read,
                        sender_name,      sent_date,  recieve_group , reciever_name 
                        from
                  t_mail_trash_box
                        where r_uid=\'$uid\' and reciever_name=\'$uname\' and delted != '1'
                        order by sent_date desc;
                ";
   my @ret = fetch_user_mail_from_db ( $sql);
   return @ret;   
}

sub fetch_user_draft_mail {
 my ( $uname) = @_;
   my $sql =     "select
                           sender,            recipient,
                           mail_content,      subject_text,
                           sent_date,    drat_mail_id 
                        
                        from
                                 t_draft_mail_box
                        where sender=\'$uname\' order by sent_date desc;
                ";
   my @ret = fetch_user_draft_mail_db ( $sql);
   return @ret;   
}

sub find_this_draft_mail_by_id {
   my ( $mail_id ) = @_;   
   my $sql =      "select
                           sender,        recipient,
                           mail_content,  subject_text,
                           sent_date,     drat_mail_id   
                           
                           from
                                 t_draft_mail_box
                         where drat_mail_id=\'$mail_id\';
                ";
   my %data = find_this_draft_mail_by_id_in_db ( $sql);
   return %data;   
}

sub trash_this_mail {
   my ( $mail_id ) = @_;
   my  @ret = trash_this_mail_in_db ( $mail_id );
   return @ret;
}

sub  get_all_mail_info_by_mail_id{
   
     my ( $mail_index ) = @_;
     my $sql =   "select  subject, sender_name, sent_date, recieve_group , reciever_name 
                        from  t_mail_box where mail_unique_id=\'$mail_index\';
                 ";
     my %data = get_all_mail_content_by_mail_id_from_db ( $sql);
     if (  $data{status} eq 'PASS' ){
         my @ret  = get_mail_content_from_db_by_mail_id ($mail_index ); 
         if ( $ret [0] =~ /PASS/){    
            $data{mail_content} =  $ret [1];      
         }else{
            return @ret;
         }
         return %data;
     }else{
         return %data;
     }
}

sub get_mail_fp_by_mail_id_in_trash {
   my ( $mail_id) = @_; 
   
}


sub get_deliver_adress_of_customer {
   my( $uid ) = @_;
   my $sql = " SELECT DeliveryAddress FROM user_info WHERE uid=\'$uid\';" ;
   my @ret =  db_exec_string_ret ( $sql ); 
   if ( $ret[0] eq 'FAIL' ){
      return  0 ;     
   }else{
      return $ret[0];
   }
}





1
;
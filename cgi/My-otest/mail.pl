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

if($flag eq 'USER_MAIL_COMPOSE'){
   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %data;
   $data{'name'} = $name;
   $data{'role'} = $role;
    my $tt = Template->new;
        $tt->process('user_mail_compser.html', \%data,\$out2)
        || die $tt->error;
  
   my $css_style_code = local_my_get_style ( );
   
   print $cgi->header();
   
   print $cgi->start_html($MainPageHeader);
   
   print $cgi->start_html(
                          -style => {
                                       -code => $css_style_code,
                                    }
                         );
   print $out2;
   print $cgi->end_html();

}elsif($flag eq 'SHOP_AMIN_MAIL_COMPOSE'){
   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %data;
   $data{'name'} = $name;
   
    my $tt = Template->new;
        $tt->process('shop_admin_mail_composer.html', \%data,\$out2)
        || die $tt->error;
  
   my $css_style_code = local_my_get_style ( );
   
   print $cgi->header();
   
   print $cgi->start_html($MainPageHeader);
   
   print $cgi->start_html(
                          -style => {
                                       -code => $css_style_code,
                                    }
                         );
   print $out2;
   print $cgi->end_html();

}elsif( $flag  eq 'SEND_MAIL_TO') {
   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   
   my $sender =  $cgi->param('sender_name');
   my $mail_content = $cgi->param('mail_content');
   $mail_content =~  s/^\s+//;
   $mail_content =~ s/\s+$//;
   
   my $subject_text = $cgi->param('subject_text');
   $subject_text =~ s/^\s+//;
   $subject_text =~ s/\s+$//;
   my %data;
   my $reciever_group = "Librarian";     
   %data =  get_list_of_uid_and_name_of_Librarian ('1');
   
   my %mail ;
   my $mail_sent_count = 0;
   my @error;
   foreach my $uid ( keys ( %data) ){      
      
      $mail{ s_uid } = get_user_id_by_name_from_db ( $sender );
      $mail{ sender_name } = $sender ;
      $mail{ recieve_group } =  $reciever_group; 
      $mail{ r_uid } = $uid; 
      $mail{ mail_unique_id } =  create_uniq_mail_index_string ( 8 );
      $mail{ subject } = $subject_text;
      $mail{ mail_read} = '0';
      $mail{ sent_date } = get_time_stamp ();
      $mail{ delted } = '0';
      $mail {reciever_name} = $data{$uid};  
   
      my $mail_index = update_mail_info ( %mail ) ;
      
      
      my $mail_fp = 
                   "<pre>________  START OF ORIGINAL MESSAGE_______\n".
                   "SEND DATE : $mail{ sent_date }  \n" .
                  "SENDER NAME :$sender \n" .
                  "RECIEVER : $data{$uid}  \n".
                  "RECIEVER GROUP: $mail{ recieve_group } \n" .
                  "SUBJECT : $subject_text  \n" .
                  "Mail Content: $mail_content         \n".
                  "_____________________END OF ORIGINAL MESSAGE  _______</pre>\n" ;   
      my (
               $included_mail_ids,  $mail_id_inclusion_type,
               $external_mail_id_used, $external_mail_id_used_type
         )
           =
            (  'NA' , 'NA', 'NA' , 'NA');
          
          
         my @ret = insert_mail_content (
                                          $mail_index , $mail_content, $mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
   
                                        );
         if ( $ret [ 0 ] ne 'FAIL' ){
            $mail_sent_count++;   
         }else{
            my $err = "Mail not Sent to" . "$data{$uid} <br>" . $ret[1] ;
            push @error , $err;
         }
   }
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $count_of_mail_reciver = keys ( %data );
   if ( $count_of_mail_reciver == $mail_sent_count ){
   
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:green\">" .
             "Mail Sent Successfully" .
             "</b>";   
   }else{
       print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
       print  @error;
       print  "</b>";
   }
}elsif( $flag eq 'USER_MAIL_INBOX' ){
      my $sid = $cgi->cookie('CGISESSID');
      my $session = CGI::Session->new( $sid );
      my $name = $session->param("usr_name");
      my $role = $session->param("role");
      my $uid = get_user_id_by_name_from_db ( $name);
      my @ret = fetch_user_mail ($name, $uid);            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my $out2;
         my %data = ( items => \@ret, role => $role, );
         my $tt = Template->new;
         $tt->process('user_mail_list.html', \%data,\$out2)
        || die $tt->error;
        print $out2; 
     }

}elsif( $flag eq 'USER_SENT_MAIL_BOX' ){
      my $sid = $cgi->cookie('CGISESSID');
      my $session = CGI::Session->new( $sid );
      my $name = $session->param("usr_name");
      my $role = $session->param("role");
      my $uid = get_user_id_by_name_from_db ( $name);
      my @ret = fetch_user_sent_mail ($name, $uid);            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my $out2;
         my %data = ( items => \@ret );
         my $tt = Template->new;
         $tt->process('user_sent_mail.html', \%data,\$out2)
        || die $tt->error;
        print $out2; 
     }

}elsif( $flag eq 'OPEN_THIS_MAIL' ){
     my $name = $cgi->param("name");
     my $mail_id = $cgi->param("mail_id");
     my $uid = get_user_id_by_name_from_db ( $name);
     
     
     my @fmail_ids = rec_find_all_mail_id_inf_action ( $mail_id );
     my @included_mails_fp;
     foreach my $mail_id ( @fmail_ids ){ 
     my @ret = get_mail_fp_by_mail_id ( $mail_id);
     
     if ( $ret[0] =~ /FAIL/ ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";   
      }else{
                  push (@included_mails_fp, $ret[0]);  
      }
    }
       my $included_mail_header = join "\n******************************************\n" , @included_mails_fp;  
       my %data  = fetch_user_mail_by_id ($name, $uid, $mail_id);            
       $data{mail_id} = $mail_id;
       $data{included_mail_header} = $included_mail_header;
   
     if ( defined ( $data{error} ) ){
         print "Content-type: text/plain; charset=iso-8859-1\n\n";
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print $data{error};
         print  "</b>";
     }else{
         my $out2;
         my $tt = Template->new;
         $tt->process('mail_content_open.html', \%data,\$out2)
         || die $tt->error;
         print $cgi->header();
         print $cgi->start_html($MainPageHeader);
         my $css_style_code = local_my_get_style ( );
         print $cgi->start_html(
                          -style => {
                                       -code => $css_style_code,
                                    }
                         );
         print $out2;
         print $cgi->end_html();
     }
     
}elsif( $flag  eq 'SEND_BY_LIBRARIAN') {
    my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   
   my $role = $session->param("role");
   my $sender =  $cgi->param('sender_name');
   
   my $reciever = $cgi->param('recipient_name');
   my $mail_content = $cgi->param('mail_content');
  
   $mail_content =~  s/^\s+//;
   $mail_content =~ s/\s+$//;
   
   my $subject_text = $cgi->param('subject_text');
   $subject_text =~ s/^\s+//;
   $subject_text =~ s/\s+$//;
   
   my %data;
   my $reciever_group = "Librarian";
  
   my %mail ;
   my $mail_sent_count = 0;
   my @error;
   
   $mail{ s_uid } = get_user_id_by_name_from_db ( $name );
   $mail{ sender_name } = $sender ;
   $mail{ recieve_group } = 'USER' ;
   $mail{ r_uid } = get_user_id_by_name_from_db ( $reciever );
   $mail{ mail_unique_id } =  create_uniq_mail_index_string ( 8 );
   $mail{ subject } = $subject_text;
   $mail{mail_read} = '0';
   $mail{ sent_date } = get_time_stamp ();
   $mail{ delted } = '0';
   $mail {reciever_name} = $reciever;
      
   my $mail_index = update_mail_info ( %mail ) ;
   
    my $mail_fp = 
                   "<pre>________  START OF ORIGINAL MESSAGE_______\n".
                   "SEND DATE : $mail{ sent_date }  \n" .
                  "SENDER NAME :$sender \n" .
                  "RECIEVER : $reciever  \n".
                  "RECIEVER GROUP: $mail{ recieve_group } \n" .
                  "SUBJECT : $subject_text  \n" .
                  "Mail Content: $mail_content         \n".
                  "_____________________END OF ORIGINAL MESSAGE  _______</pre>\n"; 
 
     my (
               $included_mail_ids,  $mail_id_inclusion_type,
               $external_mail_id_used, $external_mail_id_used_type
            )
            =
            (  'NA' , 'NA', 'NA' , 'NA');
         
          
      my @ret = insert_mail_content (
                                          $mail_index , $mail_content, $mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
   
                                        );
        print "Content-type: text/plain; charset=iso-8859-1\n\n";
         if ( $ret [ 0 ] eq 'FAIL' ){
             my $err = "Mail not Sent to" . "$reciever <br>" . $ret[1] ;
             print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
             print "$err  ====== $mail_index" ;
             print '</b>'; 
             print "<pre>" , Dumper \%mail , "</pre>";
             
            
         }else{
              print '<b style="font-family:Times New Roman, serif; font-size:20px;color:green">' .
             "Mail Sent Successfully" .
             "</b>";          
         }
}elsif( $flag eq 'GET_ALL_INFO_BY_MAILID' ){
   my $out1 = '';
   my $mail_id = $cgi->param("mail_id");
   my $name = $cgi->param("name");
   my @included_mails_fp ;
   my $out2 = '';
   my %data = ();
   my @fmail_ids = rec_find_all_mail_id_inf_action ( $mail_id );
   
   foreach my $mail_id ( @fmail_ids ){ 
      my @ret = get_mail_fp_by_mail_id ( $mail_id);
      if ( $ret[0] =~ /FAIL/ ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";   
      }else{
                  push (@included_mails_fp, $ret[0]);  
      }
   }
   my $included_mail_header = join "\n******************************************\n" , @included_mails_fp;     
   $data{f_mail_fp} = $included_mail_header;
   $data{f_mail_id} = $mail_id;
   $data{name} = $name;
   $data{ mail_unique_id } =  create_uniq_mail_index_string( 8 );
   
      my $tt = Template->new;
               $tt->process('farward_this_mail.html', \%data,\$out2)
               || die $tt->error;
               print $out2;     

}elsif( $flag eq 'GET_ALL_RINFO_BY_MAILID' ){
   my $out1 = '';
   my $mail_id = $cgi->param("mail_id");
   my $name = $cgi->param("name");
   my @included_mails_fp ;
   my $out2 = '';
   my %data = ();
   my @fmail_ids = rec_find_all_mail_id_inf_action ( $mail_id );
   
   foreach my $mail_id ( @fmail_ids ){ 
      my @ret = get_mail_fp_by_mail_id ( $mail_id);
      if ( $ret[0] =~ /FAIL/ ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";   
      }else{
                  push (@included_mails_fp, $ret[0]);  
      }
   }
   my $included_mail_header = join "\n******************************************\n" , @included_mails_fp;        
   $data{f_mail_fp} = $included_mail_header;
   $data{f_mail_id} = $mail_id;
   $data{name} = $name;
   my @ret = get_sender_mail_name ( $mail_id );
   if ( $ret[0] eq 'FAIL' ){
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
      print  @ret;
      print  "</b>";   
      
   }else{      
      $data{reciever} = $ret[0];    
   }
   $data{ mail_unique_id } =  create_uniq_mail_index_string ( 8 );
      my $tt = Template->new;
               $tt->process('reply_mail.html', \%data,\$out2)
               || die $tt->error;
               print $out2;     

}elsif( $flag eq 'TRNS_SENT_TO_INBOX' ){
   my $out1 = '';
   my $mail_id = $cgi->param("mail_id");
   my $name = $cgi->param("name");
   my @included_mails_fp ;
   my $out2 = '';
   my %mail = ();
   my @fmail_ids = rec_find_all_mail_id_inf_action ( $mail_id );
   
   foreach my $mail_id ( @fmail_ids ){ 
      my @ret = get_mail_fp_by_mail_id ( $mail_id);
      if ( $ret[0] =~ /FAIL/ ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";   
      }else{
                  push (@included_mails_fp, $ret[0]);  
      }
   }
   my $included_mail_header = join "\n******************************************\n" , @included_mails_fp;        
   my @ret = get_reciever_mail_name ($mail_id );
   
   if ( $ret[0] =~ /FAIL/ ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";   
   }
   my $reciever  = $ret[0];
   
    @ret = get_sender_mail_name ($mail_id );
   
   if ( $ret[0] =~ /FAIL/ ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";   
   }
   my $sender  = $ret[0];
   
   $mail{ s_uid } = get_user_id_by_name_from_db ( $reciever );
   $mail{ sender_name } = $reciever ;
   $mail{ recieve_group } = 'USER' ;
   $mail{ r_uid } = get_user_id_by_name_from_db ( $sender  );
   $mail{ mail_unique_id } =  create_uniq_mail_index_string ( 8 );
   
   
   my @subject = get_subject_text_by_mail_id ( $mail_id );
   my $subject_text = $mail{ subject } = $subject [0];
   
   
   
   $mail{mail_read} = '0';
   $mail{ sent_date } = get_time_stamp ();
   $mail{ delted } = '0';
   $mail {reciever_name} = $sender;      
   my $mail_index = update_mail_info ( %mail ) ;
   
    my $mail_fp = 
                   "<pre>________  START OF ORIGINAL MESSAGE_______\n".
                   "SEND DATE : $mail{ sent_date }  \n" .
                  "SENDER NAME :$name \n" .
                  "RECIEVER : $reciever  \n".
                  "RECIEVER GROUP: $mail{ recieve_group } \n" .
                  "SUBJECT : $subject_text  \n" .
                  "Mail Content: $included_mail_header         \n".
                  "_____________________END OF ORIGINAL MESSAGE  _______</pre>\n"; 
 
     my (
               $included_mail_ids,  $mail_id_inclusion_type,
               $external_mail_id_used, $external_mail_id_used_type
            )
            =
            (  'NA' , 'NA', 'NA' , 'NA');
         
          
      @ret = insert_mail_content (
                                          $mail_index , $included_mail_header, $mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
   
                                        );
      print "Content-type: text/plain; charset=iso-8859-1\n\n";
      if ( $ret[0] =~ /FAIL/ ) {
             print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
            print  @ret;
            print  "</b>";    
      }else{
               print '<b style="font-family:Times New Roman, serif; font-size:20px;color:green">' .
                     "Mail Transfered to Inbox Successfully" .
                     "</b>";   
      }   

}elsif( $flag eq 'FARWARD_MAIL' ){
 
  my $sender_name = $cgi->param("sender_name");
  my $reciever_name = $cgi->param("reciever_name");
  my $self_mail_id = $cgi->param("self_mail_id");
  my $included_mail_id = $cgi->param("included_mail_id");
  my $Mail_id_inclusion_type = $cgi->param("mail_id_inclusion_type");
  my $fcompose_text = $cgi->param("fcompose_text");
  my $f_subject_text = $cgi->param("f_subject_text");
  
   $fcompose_text =~ s/^\s+//g;
   $fcompose_text =~ s/\s+$//g;
   $f_subject_text =~ s/^\s+//g;
   $f_subject_text =~ s/\s+$//g;
 
   
    my (%data , $reciever_group) ;
   if ($reciever_name =~ /Biz/i){
      %data =  get_list_of_uid_and_name_of_BizAdmins ();
      $reciever_group = 'BIZ_ADMIN';
   }elsif ( $reciever_name =~ /Shop/i) {
      %data =  get_list_of_uid_and_name_of_ShopAdmins ();
      $reciever_name = 'SHOP_ADMIN';
   }elsif ($reciever_name =~ /Admin/i) {
     %data =  get_list_of_uid_and_name_of_Admins ();
     $reciever_group = 'ADMIN';
   }else{
      $reciever_group = 'General User';
      my $uid = get_user_id_by_name_from_db ( $reciever_name  );
      $data{$uid} = $reciever_name ;
   }
  
   my %mail ;
   my $mail_sent_count = 0;
   my @error;
   foreach my $uid ( keys ( %data) ){
         $mail{ r_uid } = $uid;
         $mail{ mail_unique_id } =  $self_mail_id ;
         $mail{ subject } = $f_subject_text;
         $mail{mail_read} = '0';
         $mail{ s_uid } = get_user_id_by_name_from_db ( $sender_name  );
         $mail{ sender_name } = $sender_name  ;
         $mail{ sent_date } = get_time_stamp ();
         $mail{ delted } = '0';
         $mail{ recieve_group } =  $reciever_group ;
         $mail {reciever_name} = $data{$uid};
         my $mail_index = update_mail_info ( %mail ) ;
         
         
          my $mail_fp = 
                     "<pre>________  START OF ORIGINAL MESSAGE_______\n".
                     "SEND DATE : $mail{ sent_date } \n" .
                     "SENDER NAME :$sender_name \n" .
                     "RECIEVER : $reciever_name  \n".
                     "RECIEVER GROUP: $reciever_name \n" .
                     "SUBJECT : $f_subject_text  \n" .
                     "Mail Content: $fcompose_text  \n".
                     "________END OF ORIGINAL MESSAGE  _______</pre>\n" ;
                     
                     
         my (
               $included_mail_ids,  $mail_id_inclusion_type,
               $external_mail_id_used, $external_mail_id_used_type
            )
            =
            (  $included_mail_id , $Mail_id_inclusion_type, 'NA' , 'NA');
          
          
         my @ret = insert_mail_content (
                                          $self_mail_id , $fcompose_text, $mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
                                        );
         
         if ( $ret [ 0 ] ne 'FAIL' ){
            $mail_sent_count++;   
         }else{
            my $err = "Mail not Sent to" . "$data{$uid} <br>" . $ret[1] ;
            push @error , $err;
         }
   }

   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $count_of_mail_reciver = keys ( %data );
   if ( $count_of_mail_reciver == $mail_sent_count ){
         my @ret = set_all_included_maild_meta ($self_mail_id );
         if ( grep (/FAIL/ ,  @ret ) ) {
             print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
            print  @error;
            print  "</b>";    
         }else{
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:green\">" .
             "Mail Sent Successfully" .
             "</b>";   
         }   
   }
}elsif( $flag eq 'DEL_THIS_MAIL' ){
     my $mail_id = $cgi->param("mail_id");
     my @ret = delete_this_mail ( $mail_id );            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my $name = $cgi->param("name");
         my $uid = get_user_id_by_name_from_db ( $name);
         my @ret = fetch_user_mail ($name, $uid);            
        
         if ( $ret[0] eq 'FAIL' ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";
         }else{
               my $out2;
               my %data = (
                           items => \@ret,
                           role =>
                           );
               my $tt = Template->new;
               $tt->process('user_mail_list.html', \%data,\$out2)
               || die $tt->error;
               print $out2; 
         }    
     }
}elsif( $flag eq 'TRASH_THIS_MAIL' ){
     my $mail_id = $cgi->param("mail_id");
     my @ret = trash_this_mail ( $mail_id );            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my $name = $cgi->param("name");
         my $uid = get_user_id_by_name_from_db ( $name);
         my @ret = fetch_user_mail ($name, $uid);            
        
         if ( $ret[0] eq 'FAIL' ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print @ret;
               print  "</b>";
         }else{
               my $out2;
               my %data = ( items => \@ret );
               my $tt = Template->new;
               $tt->process('user_mail_list.html', \%data,\$out2)
               || die $tt->error;
               print $out2; 
         }    
     }
}elsif( $flag eq 'USER_MAIL_TRASH_BOX' ){
     my $name = $cgi->param("name");
     my $uid = get_user_id_by_name_from_db ( $name);
     my @ret = fetch_user_trash_mail ($name, $uid);            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my $out2;
         my %data = ( items => \@ret );
         my $tt = Template->new;
         $tt->process('user_trash_mail_list.html', \%data,\$out2)
        || die $tt->error;
        print $out2; 
     }
}elsif( $flag eq 'OPEN_THIS_TRASH_MAIL' ){
     my $name = $cgi->param("name");
     my $mail_id = $cgi->param("mail_id");
     my $uid = get_user_id_by_name_from_db ( $name);
    
     my @fmail_ids = rec_find_all_mail_id_move_trash_action ( $mail_id );
     
     my %table_mail_id_map;
     my @included_mails_fp;
     my $ret ;
     foreach my $mail_id ( @fmail_ids){
         my( $table , $mail_id) = split ':', $mail_id;
         $table_mail_id_map{$mail_id} = $table;
          $ret = get_mail_fp_from_a_table_from_db ( $table , $mail_id );
         if ($ret){
            push (@included_mails_fp,$ret);
         }
     }
     my $mail_fps = ' ';
     foreach ( @included_mails_fp ){
         $mail_fps =  $mail_fps . '<pre>'  . $_ . '</pre>' ; 
      
     }
     my %data  = fetch_user_mail_by_id_from_table ($name, $uid, $mail_id , $table_mail_id_map{ $mail_id });            
     $data{mail_id} = $mail_id;
     $data{included_mail_header} = $mail_fps;
     if ( defined ( $data{error} ) ){
         print "Content-type: text/plain; charset=iso-8859-1\n\n";
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print $data{error};
         print  "</b>";
     }else{
         my $out2;
         my $tt = Template->new;
         $tt->process('trash_mail_open.html', \%data,\$out2)
         || die $tt->error;
         print $cgi->header();
         print $cgi->start_html($MainPageHeader);
         my $css_style_code = local_my_get_style ( );
         print $cgi->start_html(
                          -style => {
                                       -code => $css_style_code,
                                    }
                         );
         print $out2;
         print $cgi->end_html();
     }

}elsif (  $flag eq 'SAVE_DRAFT_OF_USER_MAIL_BY_LIB'){

   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   
   my $sender = $name;
   my $role = $session->param("role");
   my $recipient = $cgi->param('recipient');
   my $mail_content = $cgi->param('mail_content');
   my $subject_text = $cgi->param('subject_text');
   my $drat_mail_id  =  create_uniq_mail_index_string ( 8 );
   my $sent_date  = get_time_stamp ();
   
   $subject_text =~ s/^\s+//g;
   $subject_text =~ s/\s+$//g;
   $mail_content =~ s/^\s+//g;
   $mail_content =~ s/\s+$//g;
   my %data;
     (
         $data{sender} , $data{recipient} , $data{mail_content} ,
         $data{subject_text} , $data{sent_date}, $data{drat_mail_id }
      ) =
            ($sender ,$recipient ,$mail_content ,$subject_text ,$sent_date, $drat_mail_id );
   
   
   my @ret  = update_draft_mail (%data);
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $ret[0] =~ /'FAIL'/ ){
       print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
       print  @ret;
       print  "</b>";
   }else{
             print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:green\">" .
             "Mail saved in Draft Box" .
             "</b>";      
   }  
 
}elsif( $flag eq 'USER_MAIL_DRAFT_BOX' ){
     my $name = $cgi->param("name");
     my $uid = get_user_id_by_name_from_db ( $name);
     my @ret = fetch_user_draft_mail ($name, $uid);            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my $out2;
         my %data = ( items => \@ret );
         my $tt = Template->new;
         $tt->process('user_draft_mails.html', \%data,\$out2)
        || die $tt->error;
        print $out2; 
     }
}elsif( $flag eq 'OPEN_THIS_DRAFT_MAIL' ){
     my $mail_id = $cgi->param("mail_id");
     my %data = find_this_draft_mail_by_id( $mail_id );
     
     
      if ( defined ( $data {error} ) ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print '<pre>' , Dumper \%data , '</pre>';
               print  "</b>";   
      }else{
         my $out2;
         my $tt = Template->new;
         $tt->process('draft_content_open.html', \%data,\$out2)
         || die $tt->error;
         print $cgi->header();
         print $cgi->start_html($MainPageHeader);
         my $css_style_code = local_my_get_style ( );
         print $cgi->start_html(
                          -style => {
                                       -code => $css_style_code,
                                    }
                         );
         print $out2;
         print $cgi->end_html();
     }
}elsif( $flag eq 'DEL_THIS_DRAFT_MAIL' ){
     my $mail_id = $cgi->param("mail_id");
     my $name = $cgi->param("name");       
     my @ret = delete_this_draft_mail ( $mail_id );            
     print "Content-type: text/plain; charset=iso-8859-1\n\n";
     if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print @ret;
         print  "</b>";
     }else{
         my %data = find_this_draft_mail_by_id( $mail_id );     
         if ( defined ($data{error}) ){
               print "Content-type: text/plain; charset=iso-8859-1\n\n";
               print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
               print $data{error};
               print  "</b>";
         }else{
               my $uid = get_user_id_by_name_from_db ( $name);
               my @ret = fetch_user_draft_mail ($name, $uid);            
               
               if ( $ret[0] eq 'FAIL' ){
                  print "Content-type: text/plain; charset=iso-8859-1\n\n";
                  print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
                  print @ret;
                  print  "</b>";
               }else{
                  my $out2;
                  my %data = ( items => \@ret );
                  my $tt = Template->new;
                  $tt->process('user_draft_mails.html', \%data,\$out2)
                  || die $tt->error;
                  print $out2; 
                }    
           }
   }
}elsif( $flag eq 'SEND_THIS_DRAFT_MAIL' ){
   my $out2 = '';
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my $mail_id = $cgi->param("mail_id");
   my $s_name = $cgi->param("name"); 
   
   my %data = find_this_draft_mail_by_id( $mail_id );
   
   
    my ( $sender, $recipient, $mail_content,  $subject_text, $sent_date, $drat_mail_id )
     =
   (   
                       $data{sender},        $data{recipient},
                       $data{mail_content},  $data{subject_text},
                       $data{sent_date},     $data{drat_mail_id}
   );
  

   $mail_content =~ s/^\s+//;
   $mail_content =~ s/\s+$//;
   
   $subject_text =~  s/^\s+//;
   $subject_text =~ s/\s+$//;
   
   my %u_data;
   my $reciever_group;  
   if ($recipient =~ /Biz/i){
      %u_data=  get_list_of_uid_and_name_of_BizAdmins ();
      $reciever_group = 'BIZ_ADMIN';   
   }elsif ( $recipient =~ /Shop/i) {      
      %u_data =  get_list_of_uid_and_name_of_ShopAdmins ();
      $reciever_group = 'SHOP_ADMIN';   
   }elsif ($recipient =~ /Admin/i) {     
     %u_data =  get_list_of_uid_and_name_of_Admins ();
     $reciever_group = 'ADMIN';   
   }else{
         my $uid =  get_user_id_by_name_from_db  ( $recipient);
         $u_data{ $uid } =  $recipient;;
          $reciever_group = 'USER'; 
   }
 
   my %mail ;
   my $mail_sent_count = 0;
   my @error;
   foreach my $uid ( keys ( %u_data) ){
         $mail{ r_uid } = $uid;
         $mail{ mail_unique_id } =  $drat_mail_id;
         $mail{ subject } = $subject_text;
         $mail{mail_read} = '0';
         $mail{ s_uid } = get_user_id_by_name_from_db ( $name );
         $mail{ sender_name } = $sender ;
         $mail{ sent_date } = get_time_stamp ();
         $mail{ delted } = '0';
         $mail{ recieve_group } = $reciever_group ;
         $mail {reciever_name} = $u_data{$uid};
         
         my $mail_index = update_mail_info ( %mail ) ;
         my $mail_fp = 
                   "<pre>________  START OF ORIGINAL MESSAGE_______\n".
                   "SEND DATE : $mail{ sent_date }  \n" .
                   "SENDER NAME : $sender \n" .
                   "RECIEVER : $u_data{$uid}  \n".
                   "RECIEVER GROUP: $mail{ recieve_group } \n" .
                   "SUBJECT : $subject_text  \n" .
                   "Mail Content: $mail_content         \n".
                   "_____________________END OF ORIGINAL MESSAGE  _______</pre>\n"; 
       
      ################## DEBUG ###################### 
        #my %test ;
        #$test{mail_index} = $mail_index;
        #$test{mail_fp} = $mail_fp;
        #$test{mail} = \%mail;
        #$test{data} = \%data;
        #$test{u_data} = \%u_data;
        #html_page_gen (%test);   
     #################################################    
         my (
               $included_mail_ids,  $mail_id_inclusion_type,
               $external_mail_id_used, $external_mail_id_used_type
            )
            =
            (  'NA' , 'NA', 'NA' , 'NA');
          
          
         my @ret = insert_mail_content (
                                          $drat_mail_id , $mail_content, $mail_fp ,
                                          $included_mail_ids,  $mail_id_inclusion_type,
                                          $external_mail_id_used, $external_mail_id_used_type
   
                                        );
         if ( $ret [ 0 ] ne 'FAIL' ){
            $mail_sent_count++;   
         }else{
            my $err = "Mail not Sent to" . "$data{$uid} <br>" . $ret[1] ;
            push @error , $err;
         }
   }
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $count_of_mail_reciver = keys ( %u_data );
   if ( $count_of_mail_reciver == $mail_sent_count ){
   
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:green\">" .
             "Mail Sent Successfully" .
             "</b>";
       my @ret = delete_this_draft_mail ( $mail_id );  
       if ( $ret[0] eq 'FAIL' ){
         print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
         print "Problem in deleting this Draft mail from your Draft BOx </br>";
         print @ret;
         print  "</b>";
       }
       
   }else{
       print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:red\">" ;
       print  @error;
       print  "</b>";
   }
}

1
;







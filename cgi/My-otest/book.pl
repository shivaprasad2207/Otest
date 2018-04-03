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

my (  $book_name, $book_publisher, $book_author ,$book_edition, $book_category, $book_sub_category , $isbn_num);


if ( $flag eq 'SEARCH_WITH_PARAM' || $flag eq 'SEARCH_WITH_PARAMundefined'){
   
   my $sql = "select book_name, book_publisher, book_author ,book_edition, book_category, book_sub_category, isbn_num, book_id from t_book where ";
   
   my @search_conditions; 
   my %data = $cgi->Vars;    
   if (defined ($data{book_name})){
      $book_name = $data{book_name};
      push @search_conditions, "book_name like \'%$book_name%\'" ;   
   }
   
   if (defined ($data{book_publisher})){
      $book_publisher = $data{book_publisher};
      push @search_conditions, "book_publisher like \'%$book_publisher%\'" ;   
   }
   
   if (defined ($data{book_author})){
      $book_author = $data{book_author};
      push @search_conditions, "book_author like \'%$book_author%\'" ;   
   }
   
   if (defined ($data{category})){
      $book_category = $data{category};
      push @search_conditions, "book_category like \'%$book_category%\'" ;   
   }
   
   if (defined ($data{subcategory})){
      $book_sub_category = $data{subcategory};
      push @search_conditions, "book_sub_category like \'%$book_sub_category%\'" ;   
   }
   
   if (defined ($data{isbn_num})){
      $isbn_num = $data{isbn_num};
      push @search_conditions, "isbn_num like \'%$isbn_num%\'" ;   
   }
   
   my $sql1 = join ' and ' , @search_conditions ;
   
   $sql = $sql . $sql1 . ';';
   
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print "$sql" ;
}elsif( $flag eq 'SHOW_RESEVATION_DIALOG'){
    my %data;
    my $book_pid = $cgi->param ('book_pid');
    $data{user_name} = $cgi->param ( 'user_name'); 
    my %book_info   = get_book_info_by_book_pid ( $book_pid);
    $data{book_name} = $book_info{book_name};
    $data{book_author} = $book_info{book_author};
    $data{tag} = $book_pid;
    
    my @res_dates = get_reservation_dates ( $book_pid );
    if ( $res_dates[0] =~ 'FAIL'){ die @res_dates};
    my @res;
    foreach my $date_slot ( @res_dates ){
         my ($start_date,$end_date ) = split ':' ,  $date_slot;
         my $reservation = "START DATE : &nbsp $start_date <br> END DATE: &nbsp $end_date<br>-----------------------------" ;
         push @res , $reservation ;
      }
    my $book_existing_reserve = join '<br>'  , @res ;  
    
    $data{ book_existing_reserve } =  $book_existing_reserve;
      
    my $out;
    my $tt = Template->new;
        $tt->process('show_book_resev_dialog.html', \%data, \$out)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out;   
}elsif( $flag eq 'BOOK_RESEVATION'){
   my $book_pid = $cgi->param('book_pid');
   my $user_name = $cgi->param('user_name');
   my $to_date = $cgi->param('to_date');
   my $from_date = $cgi->param('from_date');
   $to_date =  convert_date_to_y_m_d_format ($to_date);
   $from_date =  convert_date_to_y_m_d_format ($from_date);
   
   my $flag_within_range = 0;
   my @res_dates = get_reservation_dates ( $book_pid );
   if ( $res_dates[0] =~ 'FAIL'){ die @res_dates};
 
 
   foreach my $date_slot ( @res_dates ){
         my ($start_date,$end_date ) = split ':' ,  $date_slot;
         $start_date =~ s/-/\//g;
         $end_date =~ s/-/\//g;
         my $start_date_epoc = get_epoc ( $start_date );
         my $end_date_epoc = get_epoc ( $end_date );
         my $from_date_epoc  = get_epoc ( $from_date );
         if ( $start_date_epoc <= $from_date_epoc && $from_date_epoc <= $end_date_epoc){
               $flag_within_range = 1;  
               last;
         }
   }
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $flag_within_range ){
      print '<br><br><b style="font-family:Verdana, sans-serif;color:red;font-size:20px">
               Cannot be Reserved: Reservation Clashes with Other
             </b>';
             
   }else{
        $to_date  =~ s/\//-/g;
        $from_date  =~ s/\//-/g;
        my %book_info   = get_book_info_by_book_pid ( $book_pid);
        my $book_id = $book_info{book_id};
        my $uid = get_user_id_by_name_from_db ( $user_name );
        my $status = 1;
        my $sql = "insert into book_reservation values ( \'$book_id\', \'$book_pid\' , \'$uid\' ,
                                                         \'$status\', \'$from_date\' ,   \'$to_date\'
                                                      );";
        
       my $mesg = reserve_this_book_copy ( $sql ); 
      
       print " RET_VAL = $mesg ";
       print '<br><br> <b style="font-family:Verdana, sans-serif;color:green;font-size:20px">
               Reserved: Reservation Successfull  <br>
             </b>';
   }
}elsif( $flag eq 'GET_ALL_BOOK_INFO_BY_TAG'){
      my $book_pid = $cgi->param ('book_pid');
      my %book_info   = get_book_info_by_book_pid ( $book_pid);
      my $out;
      my $tt = Template->new;
        $tt->process('show_book_details_indialog.html', \%book_info, \$out)
        || die $tt->error;
      print "Content-type: text/plain; charset=iso-8859-1\n\n";
      print $out;
}elsif( $flag eq 'DELTE_THIS_RES_BOOK_PID'){
      my $book_pid = $cgi->param ('book_pid');
      my $ret   = delete_reserved_book_pid ( $book_pid);
       print "Content-type: text/plain; charset=iso-8859-1\n\n";
      if ($ret){
         print '<br><br> <b style="font-family:Verdana, sans-serif;color:green;font-size:20px">
               Reserverd Book Deleted <br>
             </b>';
      }else{
         print '<br><br> <b style="font-family:Verdana, sans-serif;color:green;font-size:20px">
               Reserved Book Not Deleted <br>
             </b>';
      }
      
}


sub get_epoc {
   my ($date) = @_;
   my ($year, $mon, $mday) = split '/', $date;
   my $ret_epoc = timegm(0,0,0,$mday,$mon - 1,$year - 1900);
   return $ret_epoc;
}

sub convert_date_to_y_m_d_format{
    my ($date) = @_;
    my @e = split '/' ,$date;
    my $ret = $e[2] . '/' . $e[0] . '/' . $e[1];
    return $ret;
}


1
;







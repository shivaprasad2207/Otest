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
use utf8;
our  $MainPageHeader;
use Time::Local;
use Date::Manip;
use File::Basename; 
use File::Copy;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
my $cgi = CGI->new();
my $flag = $cgi->param('flag');

if($flag eq 'ADD_NEW_BOOK'){
   my $out2 = '';
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   
   my $random1 = create_uniq_mail_index_string ( 6 );
    my $random2 = create_uniq_mail_index_string ( 6 );
    my @categories = get_all_category_of_books ( );
    if ( $categories[0] =~ 'FAIL'){ die @categories};
    my @sub_categories = get_all_subcategory_of_books ( );
    if ( $sub_categories[0] =~ 'FAIL'){ die @sub_categories};
  
    my %data = (
                 random1=> $random1,
                 random2 => $random2,
                 Category =>  \@categories ,
                 SubCategory => \@sub_categories ,
               );
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   if ( $role == 1){     
       my $tt = Template->new;
       $tt->process('add_new_book_to_lib.html', \%data,\$out2)
        || die $tt->error;   
   
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">Hi $name .. You are Not Admin to perform this task</b>";   
      
   }
   print $out2;
}elsif($flag eq 'ADD_NEW_BOOK_PARAMS'){
   my $out2 = '';
   
   my $sid = $cgi->cookie('CGISESSID');
   my $session = CGI::Session->new( $sid );
   my $name = $session->param("usr_name");
   my $role = $session->param("role");
   my %params = $cgi->Vars;
   my %data;
   my %q_hash ;
  
  if ($cgi->param( 'book_name')  =~ /\w+/){$q_hash{book_name} =  $cgi->param( 'book_name');$q_hash{book_name} =~ s/^\s+//; $q_hash{book_name} =~ s/\s+$//;}
  if ($cgi->param( 'book_publisher') =~ /\w+/){$q_hash{book_publisher} =  $cgi->param( 'book_publisher');$q_hash{book_publisher} =~ s/^\s+//; $q_hash{book_publisher} =~ s/\s+$//; }
  if ($cgi->param( 'book_author') =~ /\w+/){$q_hash{book_author} =  $cgi->param( 'book_author');$q_hash{book_author} =~ s/^\s+//; $q_hash{book_author} =~ s/\s+$//; }
  if ($cgi->param( 'book_isbn') =~ /\w+/){$q_hash{book_isbn} =  $cgi->param( 'book_isbn');$q_hash{book_isbn} =~ s/^\s+//; $q_hash{book_isbn} =~ s/\s+$//; }
  if ($cgi->param( 'book_new_category') =~ /\w+/){$q_hash{book_new_category} =  $cgi->param( 'book_new_category');$q_hash{book_new_category} =~ s/^\s+//; $q_hash{book_new_category} =~ s/\s+$//; }
  if ($cgi->param( 'book_new_subcategory')  =~ /\w+/){$q_hash{book_new_subcategory} =  $cgi->param( 'book_new_subcategory');$q_hash{book_new_subcategory} =~ s/^\s+//; $q_hash{book_new_subcategory} =~ s/\s+$//; }
  if ($cgi->param( 'book_edition')  =~ /\w+/){$q_hash{book_edition} =  $cgi->param( 'book_edition');$q_hash{book_edition} =~ s/^\s+//; $q_hash{book_edition} =~ s/\s+$//; }  
  if ($cgi->param( 'book_copies')  =~ /\w+/){$q_hash{book_copies} =  $cgi->param( 'book_copies');$q_hash{book_copies} =~ s/^\s+//; $q_hash{book_copies} =~ s/\s+$//;}
  if ($cgi->param( 'book_cd')  =~ /\w+/){$q_hash{book_cd} =  $cgi->param( 'book_cd');$q_hash{book_cd} =~ s/^\s+//; $q_hash{book_cd} =~ s/\s+$//;}
  if ($cgi->param( 'subcategory_opt')  =~ /\w+/){$q_hash{subcategory_opt} =  $cgi->param( 'subcategory_opt');$q_hash{subcategory_opt} =~ s/^\s+//; $q_hash{subcategory_opt} =~ s/\s+$//;}
  if ($cgi->param( 'category_opt')  =~ /\w+/){$q_hash{category_opt} =  $cgi->param( 'category_opt');$q_hash{category_opt} =~ s/^\s+//; $q_hash{category_opt} =~ s/\s+$//;}
  if ($cgi->param( 'book_pages')  =~ /\w+/){$q_hash{book_pages} =  $cgi->param( 'book_pages');$q_hash{book_pages} =~ s/^\s+//; $q_hash{book_pages} =~ s/\s+$//;}
  
  if ( defined ( $q_hash{book_new_category})){
       $q_hash{book_category} = $q_hash{book_new_category} ;  
  }else{
      $q_hash{book_category} = $q_hash{category_opt};
  }
  if ( defined ( $q_hash{book_new_subcategory} ) ){
      $q_hash{book_sub_category} = $q_hash{book_new_subcategory};
  }else{
      $q_hash{book_sub_category} =  $q_hash{subcategory_opt};
  }
  my $new_book_id = get_new_id ();
  my $sql = "
               insert into t_book
                             (
                               book_name, isbn_num, book_publisher,
                               book_author, book_edition, book_cd,
                               book_category, book_sub_category,  book_pages, book_id
                             ) 
               values
                           (
                             \'$q_hash{book_name}\' , \'$q_hash{book_isbn}\' , \'$q_hash{book_publisher}\',
                             \'$q_hash{book_author}\' , \'$q_hash{book_edition}\' , \'$q_hash{book_cd}\',
                             \'$q_hash{book_category}\' , \'$q_hash{book_sub_category}\' , \'$q_hash{book_pages}\',\'$new_book_id\'
                           );
               
            ";
   my $ret = add_new_book_by_admin ( $sql);
   
   my @book_tags;
   foreach  (1 .. $q_hash{book_copies}){
      my $book_tag = create_book_tag_string(6);
      my $sql = "
                  insert into book_collection
                                            ( book_id , book_pid )
                  values
                           ( \'$new_book_id\' , \'$book_tag\' ) ;
                   
                ";
      push @book_tags , $book_tag ;         
      my $ret = add_new_book_tag_by_admin ( $sql);       
   }
      
  my $new_book_tags = join '&nbsp&nbsp&nbsp' , @book_tags;
  $data{book_name} =  $q_hash{book_name};
  $data{book_author} = $q_hash{book_author};
  $data{book_publisher} = $q_hash{book_publisher};
  $data{isbn_num} = $q_hash{book_isbn};
  $data{book_pages} = $q_hash{book_pages};
  $data{book_category} = $q_hash{book_category};
  $data{book_sub_category} = $q_hash{book_sub_category};
  $data{book_edition} = $q_hash{book_edition};
  $data{book_cd} =  $q_hash{book_cd};
  $data{tags} =  $new_book_tags;
  print "Content-type: text/plain; charset=iso-8859-1\n\n";
  if ( $role == 1){     
       my $tt = Template->new;
       $tt->process('show_book_details_by_book_id.html', \%data,\$out2)
        || die $tt->error;   
       print $out2;
   }else{
      print "<b style=\"font-family:Times New Roman, serif; font-size:20px;color:blue\">Hi $name .. You are Not Admin to perform this task</b>";   
      
   }
}elsif($flag eq 'ADD_MULTIPLE_BOOKS'){
                
   my $out2 ;
   my $tt = Template->new;
       $tt->process('xls_sheet_uplod_form.html', undef,\$out2)
        || die $tt->error;   
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;
   
}elsif ($flag eq 'UPLOAD_FILE' ){
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
      my(
          $book_name_i, $isbn_num_i, $book_publisher_i,
          $book_author_i, $book_edition_i, $book_cd_i,
          $book_category_i, $book_sub_category_i, $book_pages_i,$copies
        );
      
       my $sql = "
                   insert into t_book
                             (
                               book_name, isbn_num, book_publisher,
                               book_author, book_edition, book_cd,
                               book_category, book_sub_category,  book_pages, book_id
                             ) 
                 values 
       " ; 
      
       my %first_row_hash = %{$data{'0'}};
       foreach my $key (keys ( %first_row_hash )){
         if ($first_row_hash{$key} =~ /name/i){
            $book_name_i = $key;      
         }
         if ($first_row_hash{$key} =~ /isbn/i){
            $isbn_num_i = $key;      
         }
         if ($first_row_hash{$key} =~ /publisher/i){
            $book_publisher_i = $key;      
         }
         if ($first_row_hash{$key} =~ /author/i){
            $book_author_i = $key;      
         }
         if ($first_row_hash{$key} =~ /edition/i){
            $book_edition_i = $key;      
         }
         if ($first_row_hash{$key} =~ /cd/i){
            $book_cd_i = $key;      
         }
         if ($first_row_hash{$key} =~ /category/i && $first_row_hash{$key} =~ /sub/i ){
            $book_sub_category_i = $key;      
         }
         if ($first_row_hash{$key} =~ /^category/i){
            $book_category_i = $key;      
         }
         if ($first_row_hash{$key} =~ /page/i){
            $book_pages_i = $key;      
         }
         if ($first_row_hash{$key} =~ /copi/i){
            $copies = $key;      
         }
       }
       delete ($data{0});
       my @sqls;
       my $book_count = keys(%data) ;
       foreach my $key (keys(%data)){
          my @info; my $sql_vals = "( ";
          my %hash = %{$data{$key}};
          push(@info, $hash{$book_name_i} );
          push(@info, $hash{$isbn_num_i});
          push(@info, $hash{$book_publisher_i});
          push(@info, $hash{$book_author_i});
          push(@info, $hash{$book_edition_i});
          push(@info, $hash{$book_cd_i});
          push(@info, $hash{$book_category_i});
          push(@info, $hash{$book_sub_category_i});
          push(@info, $hash{$book_pages_i});
          my $new_book_id = get_new_id ();
          push(@info,$new_book_id);
       
          foreach my $val (@info){
            $sql_vals = $sql_vals . " \'$val\'," 
          }
          $sql_vals = $sql_vals . ");" ;
          $sql_vals =~ s/,\)/\)/g;
          $sql_vals = $sql .$sql_vals;
          my $ret = add_new_book_by_admin ( $sql_vals );
          
          
          
          my $book_copies = $hash{$copies};
          my @book_tags;
          foreach  (1 .. $book_copies){
               my $book_tag = create_book_tag_string(6);
               my $sql = "
                  insert into book_collection
                                            ( book_id , book_pid )
                  values
                           ( \'$new_book_id\' , \'$book_tag\' ) ;
                   
                ";
               push @book_tags , $book_tag ;         
               my $ret = add_new_book_tag_by_admin ( $sql);     
          }    
       }
       use strict 'refs';
       print $cgi->redirect(-location=>"/cgi-bin/My-Lib/index.pl?AppParam=library_manage&result=success&count=$book_count");
}elsif ( $flag eq 'SAMPLE_XLS'){
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   my $image = '<table><tr><td>
               <img id="sample_xls_sheet " hight="400px" width="900px" src="/static/images/My_lib/sample_xls.JPG"  alt="No pic found" />
               </td></tr></table>   
   ';
   print $image;
}elsif($flag eq 'SHOW_BOOK_SERACH_TMPLT'){
    my $random1 = create_uniq_mail_index_string ( 6 );
    my $random2 = create_uniq_mail_index_string ( 6 );
    my @categories = get_all_category_of_books ( );
    if ( $categories[0] =~ 'FAIL'){ die @categories};
    my @sub_categories = get_all_subcategory_of_books ( );
    if ( $sub_categories[0] =~ 'FAIL'){ die @sub_categories};
    my $data = {
                 random1=> $random1,
                 random2 => $random2,
                 Category =>  \@categories ,
                 SubCategory => \@sub_categories ,
               };
   my $out2 ;
   my $tt = Template->new;
       $tt->process('search_book_form_tmplt.html', $data ,\$out2)
        || die $tt->error;   
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out2;
}elsif($flag eq 'BOOKS_SEARCH_QUERY'){
    my $sql = $cgi->param('sql');
   my @searched_books = get_serached_books ( $sql );
   if ( $searched_books[0] =~ 'FAIL'){ die @searched_books};
   my $data = {
                  'books' => \@searched_books,
               };
   my $out1;
   my $tt = Template->new;
        $tt->process('book_serached_for_modify.html', $data, \$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out1;
}elsif($flag eq 'SHOW_BOOK_INFO_MODIFY'){
    my $book_id = $cgi->param('book_id');
    
    my %book_info = get_book_details_by_id ( $book_id  );
   if ( defined $book_info{ERROR}){ die $book_info{ERROR}; }
   my @book_copies = get_book_copies_by_id ( $book_id  );
   if ( $book_copies [0] =~ 'FAIL'){ die @book_copies};
   my $count = @book_copies;
   
   $book_info{copies} = $count;
   $book_info{book_copies} = \@book_copies;
   $book_info{book_id} = $book_id;
   my $out1;
   my $tt = Template->new;
        $tt->process('show_book_details_to_modify.html', \%book_info, \$out1)
        || die $tt->error;
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out1 ;
}elsif($flag eq 'ADD_BOOK_COPY'){
    my $out1;
    my $book_id = $cgi->param('book_id');
    my $count = $cgi->param('count');
    my @book_tags;
    foreach  (1 .. $count){
               my $book_tag = create_book_tag_string(6);
               my $sql = "
                  insert into book_collection
                                            ( book_id , book_pid )
                  values
                           ( \'$book_id\' , \'$book_tag\' ) ;
                   
                ";
               push @book_tags , $book_tag ;         
               my $ret = add_new_book_tag_by_admin ( $sql);     
          }    
   
   my $tags = join ' ' , @book_tags;
   
   
   $out1 = "<b style=\"
                     font-family:Arial, Helvetica, sans-serif;
                     font-size: large;
                     color:green; 
                  \">
                    New Added Book copies have tags
                  </b>" .   
                  "<b style=\"font-size: large;color:red;\" >  
                     $tags
                   </b>"; 
          
   print "Content-type: text/plain; charset=iso-8859-1\n\n";
   print $out1 ;
}elsif($flag eq 'OUT_PUT_XLS'){
   my $sql = "
               select
                     book_name, isbn_num,   book_publisher,   book_author,
                     book_edition,  book_cd, book_category, book_sub_category,   book_pages
               from t_book;      
             ";
      my @book_info = get_all_book_info ($sql);
      
      my $workbook  = Spreadsheet::WriteExcel->new('book_info.xls');
      my $worksheet = $workbook->add_worksheet();
      my %t;
      @t {0,1,2,3,4,5,6,7,8,9} = ( 'book_name', 'isbn_num' , 'book_publisher',  'book_author',
                                    'book_edition',  'book_cd', 'book_category', 'book_sub_category','book_pages');   
   
      foreach my $col (keys (%t) ){
         $worksheet->write(0, $col,$t{$col});   
      }
      for ( my $i = 0 ; $i < @book_info ; $i++){
         my %hash =  %{$book_info[$i]};   
         $worksheet->write($i+1 , 0 ,$hash{book_name});
         $worksheet->write($i+1 , 1 ,$hash{isbn_num});
         $worksheet->write($i+1 , 2 ,$hash{book_publisher});
         $worksheet->write($i+1 , 3 ,$hash{book_author});
         $worksheet->write($i+1 , 4 ,$hash{book_edition});
         $worksheet->write($i+1 , 5 ,$hash{book_cd});
         $worksheet->write($i+1 , 6 ,$hash{book_category});
         $worksheet->write($i+1 , 7 ,$hash{book_sub_category});
         $worksheet->write($i+1 , 8 ,$hash{book_pages});
      }   
       print "Content-type: text/plain; charset=iso-8859-1\n\n";
       print '<br><br><br>
               <a href="download_xls.pl" target="_blank"> click to download xls sheet in next tab </a>        
            ' ;
            
       
         
}


1
;







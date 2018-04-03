#!perl

BEGIN{
   use Cwd;
   our $directory = cwd;
   require(Exporter);
   use warnings;
   use strict;
   use Data::Dumper;
};

use lib $directory;
use DBModule;

 our $db_exec;
 
   foreach my $book_id (78..124){
      foreach my $i (0..4){
         my $book_pid = create_uniq_mail_index_string (6);   
          my $sql = "insert into book_collection ( book_id, book_pid )  values ( \'$book_id\', \'$book_pid\')";
          my $qh = $db_exec->prepare ($sql) or push (@errors, '<br>' . "* $sql *" . $db_exec->errstr. '<br>' );
          $qh->execute()or die (@errors, '<br>' . "* $sql *" . $qh->errstr. '<br>' );
      }
      
   }
   
  
sub create_uniq_mail_index_string {
         my $length_of_randomstring=shift;
         my @chars=('A'..'Z','0'..'9');
         my $random_string;
         foreach (1..$length_of_randomstring){
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}
 
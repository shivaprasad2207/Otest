package lib::MyPizzaDBDi;
use strict;
use warnings;
use DBI;
use DBD::mysql;
our @ISA = qw(Exporter);

my $user = 'root';
my $pw = '';
my $database = 'mypizza';
my $dsn = "dbi:mysql:".$database.":localhost:3306";


our @EXPORT    = qw (
                      $db_exec_debug
                   );


our $db_exec_debug = DBI->connect("dbi:ODBC:$dsn", $user, $pw,
                        {PrintError => 1, RaiseError => 1});
if (!$db_exec_debug) {
     print "error: connection: $DBI::err\n$DBI::errstr\n$DBI::state\n";
  } 
1
;
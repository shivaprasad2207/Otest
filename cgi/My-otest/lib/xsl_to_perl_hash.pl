#!perl –w

    use strict;
    use Spreadsheet::ParseExcel;
    use Data::Dumper; 
    my $FileName =  "A.xls";
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($FileName);

    die $parser->error(), ".\n" if ( !defined $workbook );

    # Following block is used to Iterate through all worksheets
    # in the workbook and print the worksheet content 
    
     my %data;
    for my $worksheet ( $workbook->worksheets() ) {

        # Find out the worksheet ranges
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();

        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {

                # Return the cell object at $row and $col
                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;

                #print "Row, Col    = ($row, $col)\n";
                #print "Value       = ", $cell->value(),       "\n";
                
                $data{$row}{$col} = $cell->value();
            }
        }
    }
    my @keys = sort {$data{$b} <=> $data{$a}} keys %data;
    foreach my $key (@keys){
        print "$key: $data{$key}\n";
    }
   print Dumper  \%data;
 
 
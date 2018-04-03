package lib::Headers;
require(Exporter);
use warnings;
use strict;
our @ISA = qw(Exporter);
our @EXPORT    = qw (
                      $MainPageHeader
                    );

our $MainPageHeader = {
                        -title => 'Web Based Object Oriented Test Tool',
                        -style=>[ 
                                       #{ -type =>'text/css', -src=>'/static/styles/My-otest/lib_1.css'},
                                       { -type =>'text/css', -src=>'/static/styles/My-otest/dr0.css'},
                                       { -type =>'text/css', -src=>'/static/styles/My-otest/style.css'},
                                       { -type =>'text/css', -src=>'/static/styles/My-otest/jquery-ui-1.8.18.custom.css'},
                                       
                                    ],  
                         -script=>[
                                        
                                
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/jquery.min.js'},
                                        { -type => 'text/javascript', -src => '/static/js/My-Pizza/jquery.ui.core.js' },
                                        { -type => 'text/javascript', -src => '/static/js/My-Pizza/jquery-ui-1.8.18.custom.min.js' },
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/jquery.dropdownPlain.js'},
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/core.js'},
                                        { -type => 'text/javascript', -src => '/static/js/My-otest/setting.js'},
                                     ],
                    };
                       
1
;


                                       
                                       
                                       
                                        
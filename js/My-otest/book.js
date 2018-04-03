
function search_book_with_param ( random1 , random2){
    var form_params = $("#search_book").serialize();
    var param;
    var book_name = document.getElementById("book_name").value;
    var book_name_flag = 1 ;
    if (book_name.length == 0){
        book_name_flag = 0;   
    }else{
        param = '&book_name=' + book_name ;
    }
    
    var book_publisher = document.getElementById("book_publisher").value;
    var book_publisher_flag = 1 ;
    if (book_publisher.length == 0){
        book_publisher_flag = 0;   
    }else{
        param = param + '&book_publisher=' + book_publisher ;
        
    }
    
    var book_author = document.getElementById("book_author").value;
    var book_author_flag = 1 ;
    if (book_author.length == 0){
        book_author_flag = 0;   
    }else{
        param = param + '&book_author=' + book_author ;
        
    }
    
    var book_isbn = document.getElementById("book_isbn").value;
    var book_isbn_flag = 1 ;
    if (book_isbn.length == 0){
        book_isbn_flag = 0;   
    }else{
        param = param + '&isbn_num=' + isbn_num ;    
        
    }
    
    var x= document.getElementById("category").selectedIndex;
    var y = document.getElementById("category").options;
    var category = y[x].text;
    var category_flag = 1 ;
    if (category.length == 0){
        category_flag = 0;
    }else{
        param = param + '&category=' + category ;    
    }
    
    var x= document.getElementById("subcategory").selectedIndex;
    var y = document.getElementById("subcategory").options;
    var subcategory = y[x].text;
    var subcategory_flag = 1 ;
    if (subcategory.length == 0){
        subcategory_flag = 0;
    }else{
        param = param + '&subcategory=' + subcategory ;
        
    }
    if ( book_name_flag || book_publisher_flag || book_author_flag || book_isbn || category_flag || subcategory_flag){
        
        var url = '/cgi-bin/My-lib/book.pl?flag='+'SEARCH_WITH_PARAM'+ param; 
        $.get(
            url,
            function(data, textStatus, jqXHR) {
                      var sql = data.toString();
                      window.location = "index.pl?AppParam=book_search&sql=" + sql;
            },
        "text"
        );  

    }else{
           alert ( 'Need at-least One search Parameter');     
        
    }

}

function delete_this_reservation (book_pid) {
         var url = '/cgi-bin/My-lib/book.pl?flag='+'DELTE_THIS_RES_BOOK_PID'+ '&book_pid=' + book_pid; 
        $.get(
            url,
            function(data, textStatus, jqXHR) {
                      window.location = "index.pl?AppParam=reserved";
            },
        "text"
        );  
}


function get_info_this_book_by_id(book_id){
    
    var url = '/cgi-bin/My-lib/book.pl?flag='+'SHOW_BOOK_DETAILS'+ '&book_id=' + book_id; 
        $.get(
            url,
            function(data, textStatus, jqXHR) {
                      var sql = data.toString();
                      window.location = "index.pl?AppParam=book_search&sql=" + sql;
            },
        "text"
        );  
    
}

function show_book_details_by_book_pid ( book_pid){
 
    var url = '/cgi-bin/My-lib/book.pl?flag=' + 'GET_ALL_BOOK_INFO_BY_TAG&' + 'book_id=' + book_pid;   
    var load_disp = "#load" ;
    $("#book_details_in_dialog").remove();
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />'); 
    
    var tag = $('<div  id="local_dialog_box" style="overflow:scroll"> </div>');
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Book Details \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                </b>' ;
     $.ajax({
            url : url,
            type: 'GET',
            async: true,
            dataType: "html",
            context: document.body,
            processData:true,
            cache:false,
            global:true,
            traditional:true,
            success:function(data, textStatus, jqXHR) {
                       tag.html(data).dialog({
                                modal: true,
                                title: title,
                                hide:"explode",
                                open: function(event, ui) {  
                                        $('.ui-dialog-titlebar-close')
                                        .removeClass("ui-dialog-titlebar-close")
                                        .html('<img src="/static/images/My_lib/closebutton.png" width="25" height="25" style="padding:1px">');
                                        $('.ui-widget-overlay').css('width','100%');
                                },  
				width: 600,
                                height: 600,              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
	 }
    
       }); 
   }


function reserve_this_book_copy( book_tag, user_name , book_id ){
    var load_disp = '#load_' + user_name ;
    $("#book_res_box").remove ();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />'); 
    var url = '/cgi-bin/My-lib/book.pl?flag='+'SHOW_RESEVATION_DIALOG'+ '&book_pid=' + book_tag + '&user_name=' + user_name; 
    var tag = $('<div  id="book_res_box" style="overflow:scroll"> </div>');
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Book Reservation Box \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                </b>' ;
     $.ajax({
            url : url,
            type: 'GET',
            async: true,
            dataType: "html",
            context: document.body,
            processData:true,
            cache:false,
            global:true,
            traditional:true,
            success:function(data, textStatus, jqXHR) {
                       tag.html(data).dialog({
                                modal: true,
                                title: title,
                                hide:"explode",
                                open: function(event, ui) {  
                                        $('.ui-dialog-titlebar-close')
                                        .removeClass("ui-dialog-titlebar-close")
                                        .html('<img src="/static/images/My_lib/closebutton.png" width="25" height="25" style="padding:1px">');
                                        $('.ui-widget-overlay').css('width','100%');
                                },  
				width: 900,
                                height: 700,              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						    $("#book_res_box").remove ();
                                                    window.location = "index.pl?AppParam=book_detail&book_id=" + book_id ; 
                                       } 
                               
                              }).dialog('open');                
        }
    
     });
    
}


function get_to_from_dates (){
    var user_name =  document.getElementById("user_name").value;
    var book_pid =   document.getElementById("tag").value;
    var to_date =   document.getElementById("to").value;
    var from_date =   document.getElementById("from").value;
    var log = '#log_' + book_pid ;
    if ( Date.parse(to_date) <  Date.parse(from_date)){    
        alert ( 'To Date cannot be lesser than From Date' );
    }
    var url = '/cgi-bin/My-lib/book.pl?flag='+'BOOK_RESEVATION'+'&book_pid='+book_pid+'&user_name='+user_name+'&to_date='+to_date+'&from_date='+from_date; 
    $.get(
            url,
            function(data, textStatus, jqXHR) {
                    $(log).html(data); 
            },
        "text"
        );  
    
}

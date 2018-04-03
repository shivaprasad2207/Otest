
var user_role ;

function lib_manage ( name , flag){
    
    switch (flag){
                
        case 'ADD_NEW_BOOK' :        add_new_book ( name , flag );
                                        break;
        case 'ADD_MULTIPLE_BOOKS' :  add_multiple_new_book (name , flag  );
                                       break;
    
    }                      
}


 
function add_new_book ( name , flag ){
    $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=' + 'ADD_NEW_BOOK';
    $("#user_manage_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_image").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );    
}



function get_param_new_book_add ( ) {

    var form_params = $("#add_new_book").serialize();
    $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');
    
    var book_cd;
    var x= document.getElementById("form_cd").selectedIndex;
    var y = document.getElementById("form_cd").options;
    var book_cd = y[x].text;
    
    var category_opt;
    var x= document.getElementById("category").selectedIndex;
    var y = document.getElementById("category").options;
    var category_opt = y[x].text;
    
    var subcategory_opt;
    var x= document.getElementById("subcategory").selectedIndex;
    var y = document.getElementById("subcategory").options;
    var subcategory_opt = y[x].text;
   
    form_params = form_params + '&category_opt='+category_opt + '&subcategory_opt='+subcategory_opt + '&book_cd='+book_cd;
    var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=' + 'ADD_NEW_BOOK_PARAMS&' + form_params;
    $("#search_by_form").html('');
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                  $("#load_image").html('');
			          $("#user_manage_box_disp").html(data);
                        },
        "html"
    );    

}
function add_multiple_new_book ( name , flag ){
    $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=' + 'ADD_MULTIPLE_BOOKS';
    $("#user_manage_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_image").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );    
}

function post_file_upload_function ( ){
   var form_params = $("#my_upload_form").serialize(); 
   $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');  
   var url = '/cgi-bin/My-Lib/lib_manage.pl?' + form_params ;
   $("#user_manage_box_disp").html('');
   $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_image").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );      
    
}

function redirect_to_lib_manage (){
    window.location = "index.pl?AppParam=library_manage";
}


function show_sample_xls_sheet ( ){
 
    var load_disp = "#load" ;
    $("#book_details_in_dialog").remove();
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />'); 
     var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=SAMPLE_XLS' ;
    var tag = $('<div  id="local_dialog_box" style="overflow:scroll"> </div>');
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Sample Xsl Sheet \
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
                                height: 400,              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
	 }
    
       }); 
   }

function show_book_search_tmplt () {
   $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');
   var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=' + 'SHOW_BOOK_SERACH_TMPLT';
   $("#user_manage_box_disp").html('');
   $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_image").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );      
}


function search_book_with_param_ADM ( random1 , random2){
    $("#sql_log").html('<img src="/static/images/My_lib/1.gif" />');
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
   
      $.ajax({
            url : '/cgi-bin/My-Lib/book.pl',
            data: 'flag='+'SEARCH_WITH_PARAM'+ param+'&_=[TIMESTAMP]',
            type: 'POST',
            async: true,
            dataType: "text",
            headers : { "cache-control": "no-cache" },
            cache:false,
            global:false,
            traditional:true,
            ifModified: true,
            cacheKey     : 'post',
            localCache   : true, 
            cacheTTL     : 1,
            isCacheValid : function(){  
            				return true;
        		   },
            success:function(data, textStatus, jqXHR) {   
					var sql = data.toString();
					var url = 'lib_manage.pl?flag=BOOKS_SEARCH_QUERY'+ '&sql=' + sql; 
					$.get(
						url,
						function(data, textStatus, jqXHR) {
						                    $("#sql_log").html('');
								    $("#sql").html(data);
						},
						"html"
					);     
	    },
	    headers : { "cache-control": "no-cache" },
            cache:false
        });    
    }else{
           alert ( 'Need at-least One search Parameter');     
    }
    
}


function add_book_copies_to_book ( book_id){
    var count =  document.getElementById("copies_to_add").value;
    $("#dialog_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=ADD_BOOK_COPY' + '&book_id=' + book_id + '&count=' + count;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
				$("#dialog_load").html(data);
                        },
        "html"
    );         
}






function modify_book_info ( book_id ){
    var load_disp = "#load" ;
    $("#book_details_in_dialog").remove();
    $("#local_dialog_box").remove();
    $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=SHOW_BOOK_INFO_MODIFY' + '&book_id=' + book_id;
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
				width: 900,
                                height: 900,              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
						    $("#load_image").html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
	 }
    
       }); 
   }


function out_put_speard_sheet () {
    $("#load_image").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/lib_manage.pl?flag=' + 'OUT_PUT_XLS';
    $("#user_manage_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_image").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );       
    
    
    
}
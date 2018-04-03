
var user_role ;

function user_manage ( name , flag){
    
    switch (flag){
                
        case 'CREATE_NEW_USER' :        create_new_user ( name , flag );
                                        break;
        case 'USER_CATEGORY_BY_ROLES' : show_users_by_role ( name , flag );
                                        break;
        case 'SEARCH_USER_BY_ADMIN' :  search_user_by_admin ( name , flag );
                                        break;
        case 'SEARCH_BY_USER_FIELDS':  search_by_user_fields( name , flag );
                                        break;
	case 'USER_FIELDS'          :  user_fields_book_check( name , flag );
                                        break;
	case 'DEL_USER'          :     delete_this_user( name , flag );
                                        break;
	case 'USER_PROMOTE'      :     promte_user_to_lib ( name , flag );
	                                break;
	case 'DEPROMOTE_USER'    :    depromte_user ( name , flag );
	                                break;    
    }
}




function depromte_user ( name , flag ){
    var load_disp = 'load_disp' ;
    $(load_disp).html('<img src="/static/images/My-Pizza/1.gif" />'); 
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=DEPROMOTE_USER' ;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                  $("#load_image").html('');
			          $("#user_manage_box_disp").html(data);
                        },
        "html"
    );      
}


function depromote_user_from_lib (){
    $("#load_1").html('<img src="/static/images/My-Pizza/1.gif" />'); 
    var uname = document.getElementById("uname").value
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=DEPROMOTE_USER_FROM_ADM&uname=' + uname ;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                  $("#load_1").html('');
			          $("#msg_1").html(data);
                        },
        "html"
    );        
}

function promte_user_to_lib ( name , flag ){
    var load_disp = 'load_disp' ;
    $(load_disp).html('<img src="/static/images/My-Pizza/1.gif" />'); 
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=USER_PROMOTE' ;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                  $("#load_image").html('');
			          $("#user_manage_box_disp").html(data);
                        },
        "html"
    );      
}

function promote_user_to_lib_admin ( ){
    $("#load").html('<img src="/static/images/My-Pizza/1.gif" />'); 
    var uname = document.getElementById("uname").value
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=PROMOTE_USER_TO_ADMN&uname=' + uname ;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                  $("#load").html('');
			          $("#msg").html(data);
                        },
        "html"
    );      

}



function select_this_user (){
    document.getElementById("selected_uname").value = document.getElementById("search_uname").value;
}

function move_to_trash_this_draft_mail ( mail_id){
    
     alert (  'move_to_trash_this_draft_mail  ' + mail_id);
    
    
}

function assaign_shop_to_shop_admin ( id , uname, uid ){
    
    var load_disp = 'load_disp' ;
    $(load_disp).html('<img src="/static/images/My-Pizza/1.gif" />'); 
    var x= document.getElementById(id).selectedIndex;
    var y = document.getElementById(id ).options;
    var text = y[x].text;
    var param = '&UNAME='+uname  + '&UID='+uid  + '&LOCATION='+text;
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'ALLOCATE_SHOP_ADMIN' + param ;

    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                document.getElementById("shop_admin_tab").style.visibility = 'visible'; 
			         $("#shop_admin_mesg").html(data);
                        },
        "text"
    );    
    
    
}

function search_user_info_by_fields (){
    var form_params = $("#search_by_form").serialize();
    $("#load_image").html('<img src="/static/images/My_Lib/1.gif" />');   
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'SEARCH_BY_USER_FIELDS_PARAMS&' + form_params;
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


function delete_this_user ( name , flag  ){
    $("#load_image").html('<img src="/static/images/My_Lib/1.gif" />');  
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DEL_USER';
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


function delete_this_user_get_param (){
    var form_params = $("#search_by_form").serialize();
    $("#load_image").html('<img src="/static/images/My_Lib/1.gif" />');   
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DEL_USER_CHECK_PARAMS&' + form_params;
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


function delete_this_user_by_admin ( name){
  $("#user_prom_disp").html('<img src="/static/images/My-Pizza/1.gif" />');   
  var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DELETE_THIS_USER' + '&name=' + name;
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


function user_fields_book_check ( name , flag  ){
    $("#load_image").html('<img src="/static/images/My_Lib/1.gif" />');  
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'USER_FIELDS_BOOK_CHECK';
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


function user_info_by_fields_get_param (){
    var form_params = $("#search_by_form").serialize();
    $("#load_image").html('<img src="/static/images/My_Lib/1.gif" />');   
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'USER_FIELDS_BOOK_CHECK_PARAMS&' + form_params;
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


function search_by_user_fields ( name , flag  ){
    $("#load_image").html('<img src="/static/images/My_Lib/1.gif" />');  
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'SEARCH_BY_USER_FIELDS';
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





function search_user_by_admin ( name , flag  ){
    $("#load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');  
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'USER_SEARCH_BY_ADMIN';
    $("#setting_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_disp").html(data);
			    
                        },
        "html"
    );    
 
}






 function show_users_by_role ( name , flag ){
    $("#load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');  
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'USER_CATEGORY_BY_ROLES';
    $("#setting_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_disp").html(data);
			    
                        },
        "html"
    );    
    
 }

function show_search_info_tmplt_by_book_pid ( ){
    $("#load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'SHOW_SERACH_BOOK_PID_TMPLT';
    $("#setting_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );    
    
 }

function search_info_by_book_pid ( ){
    $("#load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');
    var book_pid = document.getElementById("book_pid").value;
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'SHOW_INFO_OF_BOOK_PID' + '&book_pid=' + book_pid;
    $("#setting_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );    
    
}



function delete_this_book_copy( uname , start_date , end_date, book_pid ){
    var load_disp = '#' + uname + '_load';
     $(load_disp).html('<img src="/static/images/My_Lib/1.gif" />');
     var url =  '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DEL_RESRVD_BOOK_TAG' 
     var param = '&uname='+uname + '&start_date='+start_date  + '&end_date='+end_date  + '&book_pid='+book_pid;
     url = url + param;
      $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#user_manage_box_disp").html(data);
			      
                        },
        "html"
    );    
    
}

function get_book_info_of_this_user_by_admin ( user_name){
    
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'GET_BOOK_INFO_BY_LOGIN_NAME' + '&user_name=' + user_name;
    var load_disp = '#' + user_name + '_load';
    $(load_disp).html('<img src="/static/images/My_Lib/1.gif" />');
    var title = '<b style="\
                                                    background-image:url(/static/images/My-Pizza/oinfo_title_bar.png); \
                                                    height:8px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    User Information \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                </b>';
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
                        $(load_disp).html(data).dialog({
                                title: title,
                                open: function(event, ui) {  
                                        $('.ui-dialog-titlebar-close')
                                        .removeClass("ui-dialog-titlebar-close")
                                        .html('<img src="/static/images/My-Pizza/closebutton.png" width="25" height="20" style="padding:1px">');
                                        $('.ui-widget-overlay').css('width','90%');
                                },  
                                
				width: 800,
                                height: 700,
				              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
        }
    });  
}


function get_info_of_this_user_by_admin ( user_name){
    
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'GET_INFO_BY_LOGIN_NAME' + '&user_name=' + user_name;
    var load_disp = '#' + user_name + '_load';
    $(load_disp).html('<img src="/static/images/My_Lib/1.gif" />');
    var title = '<b style="\
                                                    background-image:url(/static/images/My-Pizza/oinfo_title_bar.png); \
                                                    height:8px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    User Information \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                </b>';
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
                        $(load_disp).html(data).dialog({
                                title: title,
                                open: function(event, ui) {  
                                        $('.ui-dialog-titlebar-close')
                                        .removeClass("ui-dialog-titlebar-close")
                                        .html('<img src="/static/images/My-Pizza/closebutton.png" width="25" height="20" style="padding:1px">');
                                        $('.ui-widget-overlay').css('width','90%');
                                },  
                                
				width: 800,
                                height: 700,
				              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
        }
    });  
}





function promote_de_this_user_by_admin ( user_name) {
    $("#user_prom_disp").html('<img src="/static/images/My-Pizza/1.gif" />');
    
    var x= document.getElementById("my_selected").selectedIndex;
    var y = document.getElementById("my_selected").options;
    var text = y[x].text;
    var is_shop_admin = new RegExp(/Shop Admin/i);
    var is_biz_admin = new RegExp(/Biz Admin/i);
    var is_user = new RegExp(/User/i);
    var role ;
    if ( is_shop_admin.test(text) ){
        role = 'shop_admin';
    }
    else if ( is_biz_admin.test(text) ){
        role = 'biz_admin';
    }
    else if ( is_user.test(text) ){
        role = 'user'; 
    }
    else{
        role = 'Admin';   
    }
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'CHANGE_USER_ROLE_BY_NAME' + '&role=' + role + '&name=' + user_name;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#user_prom_disp").html('');
                                document.getElementById("admin_mesg_table").style.visibility = 'visible';                                
				$("#admin_mesg").html(data);
                        },
        "html"
    );    
}

function show_users_of_this_role (){
    $("#category_load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');
    var x= document.getElementById("myselected").selectedIndex;
    var y = document.getElementById("myselected").options;
    var text = y[x].text;
    var is_shop_admin = new RegExp(/shop/i);
    var is_biz_admin = new RegExp(/biz/i);
    var is_Admin = new RegExp(/Admin/i);
    var is_user = new RegExp(/user/i);
    var role ;
    if ( is_shop_admin.test(text) ){
        role = 'shop_admin';
    }
    else if ( is_biz_admin.test(text) ){
        role = 'biz_admin';
    }
    else if ( is_Admin.test(text) ){
        role = 'Admin';
    }
    else{
       role = 'user';
    }
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'GET_USER_BY_ROLES' + '&role=' + role;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#category_load_disp").html('');
                                document.getElementById("category_info_table").style.visibility = 'visible';                                
				$("#category_info_disp").html(data);
			    
                        },
        "html"
    );    
}
 
function create_new_user ( name , flag ){
    $("#create_user_load_disp").html('<img src="/static/images/My_Lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'CREATE_NEW_USER';
    $("#user_manage_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#create_user_load_disp").html('');
				$("#user_manage_box_disp").html(data);
			    
                        },
        "html"
    );    
}



function submit_new_user_create ( ) {
    $("#create_user_load_disp").html('<img src="/static/images/My_Lib/1.gif" />'); 
    var form_params = $("#create_form").serialize();  
    $("#create_form").remove();
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'SUBMIT_CREATE_NEW_USER&' + form_params;
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#create_user_load_disp").html('');
				$("#create_user_log").html(data);
			    
                        },
        "html"
    );        
}


function promote_user_new_role () {
    
    var x= document.getElementById("myselected").selectedIndex;
    var y = document.getElementById("myselected").options;
    var text = y[x].text;
    var is_shop_admin = new RegExp(/shop/i);
    var is_biz_admin = new RegExp(/biz/i);
    var is_Admin = new RegExp(/Admin/i);
    var is_user = new RegExp(/user/i);
    var user =  document.getElementById("selected_user").value;
    var mesg;
    if ( is_shop_admin.test(text) ){
        mesg = user + '  will be promoted to Shop Admin';
    }
    else if ( is_biz_admin.test(text) ){
        mesg = user + '  will be promoted to Biz Admin';
    }
    else if ( is_Admin.test(text) ){
        mesg = user + ' will be promoted to Admin';
    }
    else if ( is_user.test(text) ){
        mesg = user + ' will be demoted to General User';
    }
    document.getElementById("summury_box").value = mesg;
    
}



$("#search_ing").live("keydown",my_auto_complete);

function my_auto_complete () {
            
            $("#search_ing").autocomplete({
               source: "return_user_names.pl",
               minLength: 1,
               select: function(event, ui) {
                                $('#search_ing').val(ui.item.id);
                        }
           });
}


function de_promote_user_to_shop_amin( name , flag ) {
   $("#shop_de_admin_load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DE_PROMOT_SHOP_ADMIN';
    $("#setting_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_de_admin_load_disp").html('');
				$("#setting_disp").html(data);
			    
                        },
        "html"
    );    
    $("#setting_disp").html( name + ' ' + flag );    
    
}

function depromote_shop_admin (){
    var select_ing = document.getElementById("search_ing").value;
    document.getElementById("selected_user").value = select_ing;
    document.getElementById("search_ing").value = "";
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DE_PROMOTED_USER_DETAILS' + '&promoted_user=' + select_ing;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_admin_load_disp").html('');
				$("#promoted_user_info").html(data);
			    
                        },
        "html"
    );

}


function submit_de_promot_user ( name){
    
    $("#shop_admin_deform").html('');
    $("#shop_de_admin_load_disp").html('');
    $("#shop_admin_info_tab").html('');
    document.getElementById("shop_de_admin_mesg").style.visibility = 'visible';
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'COMMIT_DEPROMOTED_USER' + '&promoted_user=' + name;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_de_admin_mesg_disp").html(data);
                        },
        "html"
    );
    
}


function get_details_of_user_for_roles () {
    
    var select_ing = document.getElementById("search_ing").value;
    document.getElementById("selected_user").value = select_ing;
    document.getElementById("search_ing").value = "";
    $("#shop_admin_load_disp").html('<img src="/static/images/My-Pizza/1.gif" />' );
    
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'GET_USER_ROLE' + '&promoted_user=' + select_ing;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                document.getElementById("role_disp").style.visibility = 'visible';
				$("#role_disp_str").html(data);
			    
                        },
        "html"
    );

    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'USER_DETAILS_FOR_NEW_ROLE' + '&promoted_user=' + select_ing;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_admin_load_disp").html('');
				$("#promoted_user_info").html(data);
			    
                        },
        "html"
    );
}


function promote_shop_admin () {
    
    var select_ing = document.getElementById("search_ing").value;
    document.getElementById("selected_user").value = select_ing;
    document.getElementById("search_ing").value = "";
    $("#shop_admin_load_disp").html('<img src="/static/images/My-Pizza/1.gif" />' );
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'PROMOTED_USER_DETAILS' + '&promoted_user=' + select_ing;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_admin_load_disp").html('');
				$("#promoted_user_info").html(data);
			    
                        },
        "html"
    );
}

function submit_promot_user (  user_name ,shop_admin_form, shop_admin_load_disp, shop_admin_info_tab, shop_admin_mesg){
    $("#shop_admin_load_disp").html('');
    $("#shop_admin_form").html('');
    $("#shop_admin_info_tab").html('');
    document.getElementById(shop_admin_mesg).style.visibility = 'visible';
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'COMMIT_PROMOTED_USER' + '&promoted_user=' + user_name;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_admin_mesg_disp").html(data);
                        },
        "html"
    ); 
}
function submit_promot_user_role (user_name ){
    
    var x= document.getElementById("myselected").selectedIndex;
    var y = document.getElementById("myselected").options;
    var role = y[x].text;

    $("#admin_form").html('');
    $("#shop_admin_load_disp").html('');
    $("#user_info" ).html('');
    document.getElementById("shop_admin_mesg").style.visibility = 'visible';
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag='  +  'COMMIT_ROLE_TO_USER' +  '&promoted_user='  + user_name + '&role=' + role;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#shop_admin_mesg_disp").html(data);
                        },
        "html"
    ); 
  
}

function remove_setting_disp ( id ){
    id = '#' + id;
    $(id).remove();
}

function promote_user_to_shop_amin( name , flag ) {
   $("#load_disp").html('<img src="/static/images/My-Pizza/1.gif" />');
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'PROMOT_SHOP_ADMIN';
    $("#setting_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_disp").html(data);
			    
                        },
        "html"
    );
    
    
    $("#setting_disp").html( name + ' ' + flag );    
    
}

$("#search_uname").live("keydown",search_uname_auto_complete);
function search_uname_auto_complete ( ) {
            $("#search_uname").autocomplete({
               source: "user_search_by_id.pl?id_x=uname",
               minLength: 1,
               select: function(event, ui) {
                                $("#search_uname").val(ui.item.id);
                        }
           });
}

$("#search_fname").live("keydown",search_fname_auto_complete);
function search_fname_auto_complete ( ) {
            $("#search_fname").autocomplete({
               source: "user_search_by_id.pl?id_x=fname" ,
               minLength: 1,
               select: function(event, ui) {
                                $("#search_fname").val(ui.item.id);
                        }
           });
}

$("#search_lname").live("keydown",search_lname_auto_complete);
function search_lname_auto_complete ( ) {
            $("#search_lname").autocomplete({
               source: "user_search_by_id.pl?id_x=lname",
               minLength: 1,
               select: function(event, ui) {
                                $("#search_lname").val(ui.item.id);
                        }
           });
}

$("#search_adress").live("keydown",search_adress_auto_complete);
function search_adress_auto_complete ( ) {
            $("#search_adress").autocomplete({
               source: "user_search_by_id.pl?id_x=adress",
               minLength: 1,
               select: function(event, ui) {
                                $("#search_adress").val(ui.item.id);
                        }
           });
}

$("#search_dadress").live("keydown",search_dadress_auto_complete);
function search_dadress_auto_complete ( ) {
            $("#search_dadress").autocomplete({
               source: "user_search_by_id.pl?id_x=dadress",
               minLength: 1,
               select: function(event, ui) {
                                $("#search_dadress").val(ui.item.id);
                        }
           });
}

$("#search_phone").live("keydown",search_phone_auto_complete);
function search_phone_auto_complete ( ) {
            $("#search_phone").autocomplete({
               source: "user_search_by_id.pl?id_x=phone",
               minLength: 1,
               select: function(event, ui) {
                                $("#search_phone").val(ui.item.id);
                        }
           });
}

$("#search_email").live("keydown",search_email_auto_complete);
function search_email_auto_complete ( ) {
            $("#search_email").autocomplete({
               source: "user_search_by_id.pl?id_x=email",
               minLength: 1,
               select: function(event, ui) {
                                $("#search_email").val(ui.item.id);
                        }
           });
}

function auto_populate_form ( id ){
    
    var is_uname = new RegExp(/uname/);
    var is_fname = new RegExp(/fname/);
    var is_lname = new RegExp(/lname/);
    var is_adress = new RegExp(/adress/i);
    var is_dadress = new RegExp(/search_dadress/i);
    var is_phone = new RegExp(/phone/);
    var is_email = new RegExp(/email/);
    var param;
    if ( is_uname.test(id) ){
        param = 'field=uname&fval=' + document.getElementById(id).value ;
    }else if ( is_fname.test(id) ){
        param = 'field=fname&fval=' + document.getElementById(id).value ;      
    }else if ( is_lname.test(id) ){
        param = 'field=lname&fval=' + document.getElementById(id).value ;      
    }else if ( is_adress.test(id) ){
        param = 'field=adress&fval=' + document.getElementById(id).value ;      
    }else if ( is_dadress.test(id) ){
        param = 'field=dadress&fval=' + document.getElementById(id).value ;      
    }else if ( is_phone.test(id) ){
        param = 'field=phone&fval=' + document.getElementById(id).value ;      
    }else if ( is_email.test(id) ){
        param = 'field=email&fval=' + document.getElementById(id).value ;      
    }
    
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'USER_SEARCH_BY_FIELD&' + param;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                
                                $("#search_uname").val(data.search_uname);  
                                $("#search_fname").val(data.search_fname);
                                $("#search_lname").val(data.search_lname);
                                $("#search_adress").val(data.search_adress);  
                                $("#search_dadress").val(data.search_dadress);
                                $("#search_phone").val(data.search_phone);
                                $("#search_email").val(data.search_email);
                                
                        },
        "json"
    );
  
    var user_login_name  =  document.getElementById("search_uname").value;
    var param = '&promoted_user=' + user_login_name;
    
    url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'GET_USER_ROLE&' + param;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                          
                         
                         $.get( 
                                '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'GET_EXTRA_USER_FILED&user_role=' + data + param ,
                                function(data, textStatus, jqXHR) {
                                                    $("#disp_user_search_info").html(data);                                      
                            },
                            "text"
                         );
        },
        "text"
    );    
}

function change_user_role_by_search_admin ( name){
    var x= document.getElementById("myselected_2").selectedIndex;
    var y = document.getElementById("myselected_2").options;
    var text = y[x].text;   
    var is_shop_admin = new RegExp(/Promote to Shop Admin/i);
    var is_biz_admin = new RegExp(/Promote to Biz Admin/i);
    var is_Admin = new RegExp(/Promote to Admin/i);
    var is_user = new RegExp(/Promote to General User/i);
    
     var role ;
    if ( is_shop_admin.test(text) ){
        role = 'shop_admin';
    }
    else if ( is_biz_admin.test(text) ){
        role = 'biz_admin';
    }
    else if ( is_Admin.test(text) ){
        role = 'Admin';
    }
    else{
       role = 'user';
    }
    var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'CHANGE_USER_ROLE_ADMIN_SEARCH' + '&role=' + role + '&name=' + name ;
    $.get(
         url,
         function(data, textStatus, jqXHR ){
                                $("#promoted_mesg").html(data);			    
                        },
        "html"
    );        
}

function delete_user_search_admin ( name){
    //alert ( name);
     var url = '/cgi-bin/My-Lib/user_manage.pl?flag=' + 'DELETE_THIS_USER' + '&name=' + name;  
     $.get(
         url,
         function(data, textStatus, jqXHR) {                          
				$("#del_mesg").html(data);
                        },
        "html"
    );      
    
}

var user_role ;

function settings ( name , flag){
    
    switch (flag){
        
        case 'USER_DETAILS':       settings_user_details ( name , flag );                                
                                    break;
        
        case 'CHANGE_PASSWD':       settings_change_passwd ( name , flag );
                                    break;
        
        case 'CHANGE_LOGIN':        settings_change_login ( name , flag );
                                    break;
        
        case 'EDIT_USER_DETAILS':   settings_edit_user_details ( name , flag );
                                    break;                       
    }
}



function select_this_user (){
    document.getElementById("selected_uname").value = document.getElementById("search_uname").value;
}
 
function create_new_user ( name , flag ){
    $("#load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'CREATE_NEW_USER';
    $("#setting_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_box_disp").html(data);
			    
                        },
        "html"
    );    
    $("#setting_box_disp").html( name + ' ' + flag );    
}
function submit_new_user_create (
                                 create_form,
                                 edit_load_disp,
                                 create_mesg_table,
                                 create_mesg_disp
                                 ) {
 
    var jq_form             = "#" + create_form;
    var jq_load_disp        = "#" + edit_load_disp;
    var jq_mesg_disp        = "#" + create_mesg_disp;
  
    $(jq_load_disp ).html('<img src="/static/images/My-otest/1.gif" />'); 
    var form_params = $(jq_form).serialize();  
    $(jq_form).remove();
    document.getElementById(create_mesg_table).style.visibility = 'visible';
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'SUBMIT_CREATE_NEW_USER&' + form_params;
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $(jq_load_disp ).html('');
				$(jq_mesg_disp).html(data);
			    
                        },
        "html"
    );        
}

function remove_setting_box_disp ( id ){
    id = '#' + id;
    $(id).remove();
}


function settings_user_details ( name , flag ){
    $("#load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'USER_DETAILS';
    $("#setting_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_box_disp").html(data);
			    
                        },
        "html"
    );
    
    
    $("#setting_box_disp").html( name + ' ' + flag );
}

function remove_setting_disp (id){
    var disp = "#" + id ;
    $(disp).remove ();
}

function settings_change_passwd ( name , flag ){
     $("#load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'CHANGE_PASSWD';
    $("#setting_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_box_disp").html(data);
			    
                        },
        "html"
    );
  
    $("#setting_box_disp").html( name + ' ' + flag );
   
}
function settings_change_login ( name , flag ){
     $("#setting_box_disp").html( name + ' ' + flag );
    
}

function settings_edit_user_details ( name , flag ){
     $("#load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'EDIT_USER_DETAILS';
    $("#setting_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#setting_box_disp").html(data);
			    
                        },
        "html"
    );
    
    
    $("#setting_box_disp").html( name + ' ' + flag );
    
}


function submit_user_edit (  ){
    var form_params = $("#edit_form").serialize();
    $("#edit_load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'SUBMIT_USER_DETAILS&' + form_params;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#edit_load_disp").html('');
                                $("#edit_form").remove();
                                $("#setting_box_disp").html(data);
                        },
        "html"
    );
}


function submit_user_passwd ( ){
    var form_params = $("#passwd_form").serialize();
    $("#p_load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var url = '/cgi-bin/My-otest/setting.pl?flag=' + 'CHANGE_PASSWD_SUBMIT&' + form_params;
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#p_load_disp").html('');
                                $("#passwd_form").remove(); 
                                $("#log_1").html(  data );
                        },
        "html"
    );
}

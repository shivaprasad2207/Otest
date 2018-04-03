
var user_role ;


$('#uname').live("keydown",search_uname_auto_complete);
function search_uname_auto_complete ( ) {
             $("#uname").autocomplete({
               source: "auto_complete_login_name.pl",
               minLength: 2,
               select: function(event, ui) {
                                $("#uname").val(ui.item.id);
                        }
           });
}



function user_settings ( name , flag){
    
    switch (flag){
        case 'USER_MAIL_INBOX':   show_user_mail_box ( name , flag );
                                        break;
        case 'USER_SENT_MAIL_BOX' : show_user_sent_mail_box ( name , flag );
                                        break;
        case 'USER_MAIL_COMPOSE' : show_user_mail_composer ( name , flag );
                                        break;
        case 'SHOP_AMIN_MAIL_COMPOSE' : show_shop_admin_mail_composer ( name , flag );
                                        break;
        case 'USER_MAIL_TRASH_BOX':  show_mail_trash_box ( name , flag  );
                                      break;
        case 'USER_MAIL_DRAFT_BOX' : show_mail_draft_box ( name , flag  );
                                      break;
        case 'MANAGE_SHOP_ADMIN' :   manage_shop_admin ( name , flag );
                                     break;
    }
}


function show_mail_draft_box (  name , flag ){
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');   
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'USER_MAIL_DRAFT_BOX&name=' + name; 
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
}


function select_reciepient ( name ){
    var x= document.getElementById("myselecte_c").selectedIndex;
    var y = document.getElementById("myselecte_c").options;
    var text = y[x].text;
    var is_shop_admin = new RegExp(/Shop Admin/i);
    var is_biz_admin = new RegExp(/Biz Admin/i);
    var is_user = new RegExp(/User/i);
    var role ;
    if ( is_shop_admin.test(text) ){
        role = 'Shop admin';
    }
    else if ( is_biz_admin.test(text) ){
        role = 'Biz admin';
    }
    else if ( is_user.test(text) ){
        role = 'user'; 
    }
    else{
        role = 'Admin';   
    }
    
    document.getElementById("reciepient").value = role;
}


function select_reciepient_for_shop_admin ( name ){
    var x= document.getElementById("myselecte_c").selectedIndex;
    var y = document.getElementById("myselecte_c").options;
    var text = y[x].text;
    var is_shop_admin = new RegExp(/Shop Admin/i);
    var is_biz_admin = new RegExp(/Biz Admin/i);
    var is_user = new RegExp(/User/i);
    var role ;
    if ( is_shop_admin.test(text) ){
        role = 'Shop admin';
    }
    else if ( is_biz_admin.test(text) ){
        role = 'Biz admin';
    }
    else if ( is_user.test(text) ){
        role = 'user'; 
    }
    else{
        role = 'Admin';   
    }
    if ( role == 'user'){
          document.getElementById("user").style.visibility = 'visible';
          document.getElementById("group").style.visibility = 'hidden';
    }else{
         document.getElementById("group").style.visibility = 'visible';
         document.getElementById("user").style.visibility = ' hidden';
         document.getElementById("user").value = '';
         var tag = '<b style="font-family:Verdana, sans-serif;color:blue;font-size:13px">&nbsp&nbsp&nbspGroup Reciepient: </b>'
                                 +   '&nbsp <input type="text" id="reciepient" value="' + role+ '">' ; 
        $("#group").html(tag);
    }
}

function show_shop_admin_mail_composer (  name , flag ){
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');       
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'SHOP_AMIN_MAIL_COMPOSE&name=' + name; 
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );       
    
    
}



function send_mail_f ( name, flag){
    var mail_content = document.getElementById("compose_text").value
    var subject_text = document.getElementById("subject_text").value;
    switch (flag){
        case 'SEND':            send_mail_to_librarian ( name , mail_content , subject_text);                                
                                    break;
        case 'DRAFT':           save_as_draft_user ( name , recipient , mail_content , subject_text);                                  
                                    break;
        case 'DEL':             delete_mail_box_content ( name , flag , subject_text);                                
                                    break;
    
    }     
}





function send_mail_by_librarian ( name ){
    var mail_content = document.getElementById("compose_text").value 
    var subject_text = document.getElementById("subject_text").value;
    var recipient = document.getElementById("uname").value;
    
     $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');
    
    var url = '/cgi-bin/My-lib/mail.pl?flag='+'SEND_BY_LIBRARIAN'+'&sender_name='+ name 
              +'&recipient_name='+recipient+'&mail_content='+ mail_content +'&subject_text='+ subject_text ;
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');
			          $("#mail_box_disp").html(data);
                                  
                        },
        "text"
    );    
    $("#load_disp").html('<b color="green"> Mesg Sent to ' + recipient + '</b>');    
}


function send_mail_to_librarian ( name  , mail_content , subject_text){
    
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-lib/mail.pl?flag='+'SEND_MAIL_TO'+'&sender_name='+ name 
              +'&mail_content='+ mail_content +'&subject_text='+ subject_text ;
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');
			          $("#mail_box_disp").html(data);
                                  
                        },
        "text"
    );    
    $("#load_disp").html('<b color="green"> Mesg Sent to ' + recipient + '</b>');

}


function send_mail_admin_f ( name, flag){
    var mail_content = document.getElementById("compose_text").value
    var recipient = document.getElementById("reciepient").value;
    var subject_text = document.getElementById("subject_text").value;
    var ind_recipient = document.getElementById("search_uname").value;
    if ( ind_recipient ){
        ind_recipient = ind_recipient;
    }else{
        ind_recipient = recipient;     
    }
    switch (flag){
        case 'DRAFT':           save_as_draft_by_admin ( name, ind_recipient, mail_content, subject_text );                             
                                    break;
        case 'DEL':             delete_mail_box_content ( name , flag , subject_text);                                
                                    break;
       
    
    }    
    
}


function save_draft_mail_by_librarian ( name){
    var mail_content = document.getElementById("compose_text").value
    var subject_text = document.getElementById("subject_text").value;
    var recipient = document.getElementById("uname").value;
    
    $("#mail_box_disp").html(''); 
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');
    var param = '&name='+name  +  '&recipient='+recipient  +  '&mail_content='+ mail_content   +   '&subject_text='+subject_text ;  
    var url = '/cgi-bin/My-lib/mail.pl?flag=SAVE_DRAFT_OF_USER_MAIL_BY_LIB' + param; 
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
		      $("#load_disp").html('');
                      $("#mail_box_disp").html(data);
		      
        },
        "html"
    );
     $("#load_disp").html('');
}


function save_draft_mail_by_user ( name ) {
    var mail_content = document.getElementById("compose_text").value
    var subject_text = document.getElementById("subject_text").value;
    var recipient = "Librarian";
    
    $("#mail_box_disp").html(''); 
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');
    var param = '&name='+name  +  '&recipient='+recipient  +  '&mail_content='+mail_content   +   '&subject_text='+subject_text ;  
    var url = '/cgi-bin/My-lib/mail.pl?flag=SAVE_DRAFT_OF_USER_MAIL_BY_LIB' + param; 
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                      $("#mail_box_disp").html(data);
        },
        "html"
    );
    
}

function farward_this_mail ( mail_id, name ) {
    var url = '/cgi-bin/My-lib/mail.pl?flag='+'GET_ALL_INFO_BY_MAILID'+'&mail_id='+ mail_id + '&name=' + name; 
    
     $.get(
         url,
         function(data, textStatus, jqXHR) {
                      $("#mail_box_disp").html(data);
        },
        "html"
    );  
}

function tranfer_this_mail_to_inbox (mail_id , name) {
    var url = '/cgi-bin/My-lib/mail.pl?flag='+'TRNS_SENT_TO_INBOX'+'&mail_id='+ mail_id + '&name=' + name; 
     
     $.get(
         url,
         function(data, textStatus, jqXHR) {
                      $("#mail_box_disp").html(data);
        },
        "html"
    );    
    
}






function reply_this_mail ( mail_id , name) {
   var url = '/cgi-bin/My-lib/mail.pl?flag='+'GET_ALL_RINFO_BY_MAILID'+'&mail_id='+ mail_id + '&name=' + name; 
    
     $.get(
         url,
         function(data, textStatus, jqXHR) {
                      $("#mail_box_disp").html(data);
        },
        "html"
    );   
    
}


function send_farward_mail_f ( mail_id, f_mail_id, name){
    var fcompose_text = document.getElementById("fcompose_text").value;
    var f_subject_text = document.getElementById("f_subject_text").value;
    var included_mail_id = f_mail_id
    var self_mail_id = mail_id;
    var sender = name;
    var role = 'user'; 
    var recipient = document.getElementById("uname").value ;
     
    var param = '?flag=FARWARD_MAIL' +  '&sender_name='+sender +  '&reciever_name='+recipient
                + '&self_mail_id='+self_mail_id + '&included_mail_id='+included_mail_id
                + '&mail_id_inclusion_type='+'FARWARD' + '&fcompose_text='+fcompose_text
                + '&f_subject_text='+f_subject_text ;                 
    var url = '/cgi-bin/My-lib/mail.pl' + param;
    
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');
			          $("#mail_box_disp").html(data);
                                  
                        },
        "html"
    );    
                   
}

function select_mail_forward_group ( mail_id ) {
    var x= document.getElementById("myselecte_f").selectedIndex;
    var y = document.getElementById("myselecte_f").options;
    var text = y[x].text;
    var is_shop_admin = new RegExp(/Shop Admin/i);
    var is_biz_admin = new RegExp(/Biz Admin/i);
    var is_user = new RegExp(/User/i);
    var role ;
    if ( is_shop_admin.test(text) ){
        role = 'Shop admin';
    }
    else if ( is_biz_admin.test(text) ){
        role = 'Biz admin';
    }
    else if ( is_user.test(text) ){
        role = 'user'; 
    }
    else{
        role = 'Admin';   
    }
    
    if ( role == 'user'){
          document.getElementById("user").style.visibility = 'visible';
          document.getElementById("search_uname").style.visibility = 'visible'; 
          document.getElementById("select_uname").style.visibility = 'visible';
          document.getElementById("group").style.visibility = 'hidden';
          document.getElementById("farward_selected_g").value = '';
    }else{
         
         document.getElementById("user").style.visibility = ' hidden';
         document.getElementById("search_uname").style.visibility = ' hidden';
         document.getElementById("select_uname").style.visibility = ' hidden';
         document.getElementById("group").style.visibility = 'visible';
         document.getElementById("search_uname").value = '';
         var tag = '<td> <b style="font-family:Verdana, sans-serif;color:blue;font-size:14px">Farwarding This Mail to Group:</b> </td> '
                                 +   '<td> <input class="new_css" type="text" id="farward_selected_g" value="' + role+ '"> </td> '; 
        $("#group").html(tag);
    }
    document.getElementById("farawrd_press_go_d").style.visibility = 'visible';
    
    old_mail_data =  document.getElementById("mail_header").innerHTML ;
   
    var is_g = document.getElementById("farward_selected_g").value ;
    var to_be_reciever;
    if ( is_g ){
        to_be_reciever = document.getElementById("farward_selected_g").value ; 
    }else{
        to_be_reciever = document.getElementById("selected_uname").value;
    }       
    var compose_text = document.getElementById("compose_text").value;
    
    var subject_text = document.getElementById("subject_text").value;
    var to_be_reciever;
    
    var params =  '?flag=FARWARD_MAIL' +  '&org_mail_data='+old_mail_data  +  '&mail_content='+compose_text
                   +  '&subject_text='+subject_text   +    '&recipient_name='+to_be_reciever    +   '&mail_id='+mail_id;

    var url = '/cgi-bin/My-lib/mail.pl' + params;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');
			          $("#mail_box_disp").html(data);
                                  //$("#load_disp").html(data);
                        },
        "text"
    );    
       
    
    
}

function show_draftmail_action ( mail_id , name){
    var x= document.getElementById(mail_id).selectedIndex;
    var y = document.getElementById(mail_id).options;
    var text = y[x].text;
    
   
    var is_send = new RegExp(/SEND/i);
    var is_delete = new RegExp(/DELETE/i);
    var is_trash = new RegExp(/TRASH/i);
   
    if ( is_send.test(text) ){
	alert ( 'send');
        send_this_draft_mail (mail_id,name );          
    }else if ( is_delete.test(text) ){
	alert ( 'Delete');
        delete_this_draft_mail(mail_id,name )
    }else if ( is_trash.test(text) ){
	alert ( 'Trash');
        move_to_trash_this_draft_mail(mail_id)
    }else{
       alert ( 'This mail of ' + name + 'with ID ' +  mail_id + ' to be DOne nothink');
    }  
}    
    
function delete_this_draft_mail ( mail_id, name ){
     $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />');    
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'DEL_THIS_DRAFT_MAIL&' + 'mail_id=' + mail_id + '&name=' + name ;;
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
    
    
}

function move_to_trash_this_draft_mail ( mail_id){
    
     alert (  'move_to_trash_this_draft_mail  ' + mail_id);
    
    
}

function send_this_draft_mail ( mail_id, name ){   
     $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />');    
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'SEND_THIS_DRAFT_MAIL&' + 'mail_id=' + mail_id + '&name=' + name ;;
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
} 

function show_mail_action ( select_id , mail_id , name){
    var param = select_id + mail_id ;
    var x= document.getElementById(param).selectedIndex;
    var y = document.getElementById(param).options;
    var text = y[x].text;
    
    var is_farward = new RegExp(/FARWARD/i);
    var is_reply = new RegExp(/REPLY/i);
    var is_delete = new RegExp(/DELETE/i);
    var is_trash = new RegExp(/TRASH/i);
   
    if ( is_farward.test(text) ){
	farward_this_mail (mail_id , name);
    }
    else if ( is_reply.test(text) ){
	var recieved_by = name ;
	reply_this_mail (mail_id , name);
    }
    else if ( is_delete.test(text) ){
        delete_this_mail_content(mail_id , name )
    }else if ( is_trash.test(text) ){
        move_to_trash_this_mail_content(mail_id , name )
    }else{
       alert ( 'This mail of ' + name + 'with ID ' +  mail_id + ' to be DOne nothink');
    } 
    
}

function  show_sent_mail_action ( select_id , mail_id , name ){
    var param = select_id + mail_id ;
    var x= document.getElementById(param).selectedIndex;
    var y = document.getElementById(param).options;
    var text = y[x].text;
    
    var is_to_inbox = new RegExp(/Send Mail copy To INBOX/i);
    var is_to_draft = new RegExp(/Send Mail Copy to Draft BOX/i);
    var is_delete = new RegExp(/DELETE/i);
    
   
    if ( is_to_inbox.test(text) ){
    
	tranfer_this_mail_to_inbox (mail_id , name);
    }
    else if ( is_to_draft.test(text) ){
	
	tranfer_this_mail_to_draft (mail_id , name);
	     
    }
    else if ( is_delete.test(text) ){
        delete_this_mail_content(mail_id , name )
    }
}



function move_to_trash_this_mail_content(mail_id , name ){
    var load_disp = 'load_disp' ;
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />');    
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'TRASH_THIS_MAIL&' + 'mail_id=' + mail_id + '&name=' + name ;
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );        
}



function remove_box ( id ){
    id = '#' + id;
    $(id).remove();
}

function show_user_mail_composer (  name , flag ){
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'USER_MAIL_COMPOSE';
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');
			          $("#mail_box_disp").html(data);
                        },
        "html"
    );    
    
}

function show_user_mail_box (  name , flag ){
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');   
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'USER_MAIL_INBOX&name=' + name; 
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
}


function show_mail_trash_box (  name , flag ){
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');   
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'USER_MAIL_TRASH_BOX&name=' + name; 
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
}

function show_user_sent_mail_box (  name , flag ){
    $("#load_disp").html('<img src="/static/images/My_lib/1.gif" />');   
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'USER_SENT_MAIL_BOX&name=' + name; 
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
}


function delete_this_mail_content ( mail_id , name ) {
    var load_disp = 'load_disp' ;
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />');    
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'DEL_THIS_MAIL&' + 'mail_id=' + mail_id + '&name=' + name ;
    $("#mail_box_disp").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                 $("#load_disp").html('');				
			         $("#mail_box_disp").html(data);
                        },
        "html"
    );    
}


function open_this_draft_mail(mail_id) {
    var load_disp = 'load_disp' ;
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />'); 
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'OPEN_THIS_DRAFT_MAIL&' + 'mail_id=' + mail_id;
    var tag = $('<div  id="local_dialog_box" style="overflow:scroll"> </div>');
    
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    DRaft Mail \
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
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
        }
    
     });
    
}


function open_this_mail_content ( mail_id , name ) {
    var load_disp = 'load_disp' ;
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />'); 
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'OPEN_THIS_MAIL&' + 'mail_id=' + mail_id + '&name=' + name;
    var tag = $('<div  id="local_dialog_box" style="overflow:scroll"> </div>');
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Mail Content \
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
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
        }
    }); 
}

function open_this_trash_mail_content ( mail_id , name ) {
    var load_disp = 'load_disp' ;
    $("#local_dialog_box").remove();
    $(load_disp).html('<img src="/static/images/My_lib/1.gif" />'); 
    var url = '/cgi-bin/My-lib/mail.pl?flag=' + 'OPEN_THIS_TRASH_MAIL&' + 'mail_id=' + mail_id + '&name=' + name;
    var tag = $('<div  id="local_dialog_box" style="overflow:scroll"> </div>');
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Mail Content \
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
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
        }
    
    });  
}

 
function remove_mail_box_disp ( id ){
    id = '#' + id;
    $(id).remove();
}

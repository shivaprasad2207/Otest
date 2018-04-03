

function create_new_test_set_id (){
    clear();
    $("#load_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var form_params = $("#create_new_test_id_form").serialize();
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'CREATE_NEW_TEST_SET_ID&' + form_params;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#load_disp").html('');
				$("#log").html(data);
			    
                        },
        "html"
    );    
}

function bring_testset_add_info ( uid){
    clear();
    $("#add_container_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;    
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SHOW_TEST_ADD_FORM&uid='+uid + '&testsetid=' + testsetid;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                               $("#add_container_disp").html('');
				$("#add_container_log").html(data);
			    
                        },
        "html"
    );    

}

function get_param_test_case_add ( ){
        $("tc_add_container").html('');
        $("#add_container_disp").html('<img src="/static/images/My-otest/1.gif" />');
        var form_params = $("#test_case_add_form").serialize();
	var testsetid = document.getElementById("testsetid").value;
        var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SUBMIT_TEST_ADD_FORM&' + form_params + '&testsetid=' + testsetid;
	$.get(
	    url,
	    function(data, textStatus, jqXHR) {
                               $("#add_container_disp").html('');
			       $("#tc_add_container").html('');
			       $("#mesg").html(data);
			    
                        },
	 "html"
	);    
}



function bring_testset_view_info ( uid){
    clear();
    $("#view_container_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;    
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SHOW_TEST_VIEW_FORM&uid='+uid + '&testsetid=' + testsetid;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                               $("#view_container_disp").html('');
				$("#view_container_log").html(data);
			    
                        },
        "html"
    );    
}

function show_user_with_test_details ( uid ){
   
    $("#user_test_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SHOW_USER_TEST_INFO&uid='+uid + '&testsetid=' + testsetid ;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                               $("#user_test_disp").html('');
				$("#user_test_log").html(data);
			    
                        },
        "html"
    );    
}


function bring_testset_modift_info ( uid ){
    clear();
    $("#modift_container_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;    
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SHOW_TEST_MOD_FORM&uid='+uid + '&testsetid=' + testsetid;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                               $("#modift_container_disp").html('');
				$("#modift_container_log").html(data);
			    
                        },
        "html"
    );    
    
}

function bring_testset_del_info ( uid){
    clear();
    $("#view_container_disp").html('<img src="/static/images/My-otest/1.gif" />');
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;    
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SHOW_TEST_DEL_FORM&uid='+uid + '&testsetid=' + testsetid;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                               $("#view_container_disp").html('');
				$("#view_container_log").html(data);
			    
                        },
        "html"
    );    
}

function delete_these_tcs ( testsetid ){
   
    $("#load").html('<img src="/static/images/My-otest/1.gif" />');
    var form_params = $("#testcase_del_form").serialize();
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'DEL_THESE_TESTS&' + form_params + '&testsetid=' + testsetid ;

    $.get(
         url,
         function(data, textStatus, jqXHR) {
                               $("#load").html('');
				$("#mesg").html(data);
			    
                        },
        "html"
    );    
}


function modify_testcase_of_testset(sln,testsetid ){
    var form = '#form_'+ testsetid + '_' + sln;
    var load = '#load_'+ testsetid + '_' + sln;
    $(load).html('<img src="/static/images/My-otest/1.gif" />');
    var form_params = $(form).serialize();
     var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SUBMIT_TEST_MOD_FORM&' + form_params + '&sln=' + sln + '&testsetid=' + testsetid;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
				$(load).html(data);
                        },
        "html"
    );    
}



function show_xsl_upload_form (){
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;    
    document.getElementById('upload_form2').style.visibility='visible';
    document.getElementById('testsetid').value= testsetid;
    
}

function show_xsl_download_link (){
    var x= document.getElementById("tsetid").selectedIndex;
    var y = document.getElementById("tsetid").options;
    var testsetid = y[x].text;    
    $("#div_link_show").html('<img src="/static/images/My-otest/1.gif" />'); 
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'XML_DOWNLOAD_LINK&' + 'testsetid=' + testsetid;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
				$("#div_link_show").html(data);
                        },
        "html"
    );    
    
    
    
}

function remove_setting_disp (id){
    var disp = "#" + id ;
    $(disp).remove ();
}


function show_sample_xls_sheet ( ){
    var load_disp = "#load" ;
    $(load_disp).html('<img src="/static/images/My-otest/1.gif" />'); 
    var url = '/cgi-bin/My-otest/core.pl?flag=SAMPLE_XLS' ;
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
                                height: 600,              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
	 }
    
       }); 
   }

function pop_up_quesation ( sln, testsetid, atmptid,atmpt_ans ){ 
    var load_disp = "#load_" + sln ;
    $(load_disp).html('<img src="/static/images/My-otest/1.gif" />'); 
    var url = '/cgi-bin/My-otest/core.pl?flag=GET_TEST_CASE&sln='+sln + '&testsetid='+testsetid + '&atmptid='+atmptid + '&atmpt_ans='+atmpt_ans;
    var tag = $('<div  id="local_dialog_box" style="overflow:scroll"> </div>');
    var title = '<b style="\
                                                    background-image:url(/static/images/My_lib/oinfo_title_bar.png); \
                                                    height:15px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Test Case\
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
				width: 1000,
                                height: 600,              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
	 }
    
       }); 
    
}

function pop_up_tcs_submit (){
    $("#load").html('<img src="/static/images/My-otest/1.gif" />'); 
    var form_params = $("#tcs_pop").serialize();
    var url = '/cgi-bin/My-otest/core.pl?flag=TCS_SUBMIT&'+form_params ;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
				 window.location = "index.pl?AppParam=EXAMNEE";
                        },
        "html"
    );    
    
    
}

function logout( sid ){
    var xmlhttp;
    var url = '/cgi-bin/My-otest/core.pl?term=' + sid  + '&flag=' + 'logout';
    
    if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp=new XMLHttpRequest();
    }else{// code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.open("GET",url,false);
    xmlhttp.send();
    var ret = xmlhttp.responseText;
    window.location = '/cgi-bin/My-otest/login.pl?status=logout';
}


function show_user_info ( uname ,testsetid ,sid  ){
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'GET_USER_INFO' + '&user_name=' + uname;
    var load_disp = '#' + sid + '_user_info';
    $(load_disp).html('<img src="/static/images/My-otest/1.gif" />');
    var title = '<b style="\
                                                    background-image:url(/static/images/My-otest/oinfo_title_bar.png); \
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
                                        .html('<img src="/static/images/My-otest/closebutton.png" width="25" height="20" style="padding:1px">');
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

function show_user_summary_testinfo ( uname ,testsetid ,sid  ){
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'GET_USER_TEST_SUMMARY' + '&user_name='+uname + '&testsetid='+testsetid  + '&sid='+sid ;
    var load_disp = '#' + sid + '_summary_info';
    $(load_disp).html('<img src="/static/images/My-otest/1.gif" />');
    var title = '<b style="\
                                                    background-image:url(/static/images/My-otest/oinfo_title_bar.png); \
                                                    height:8px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Test Summary Information \
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
                                        .html('<img src="/static/images/My-otest/closebutton.png" width="25" height="20" style="padding:1px">');
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


function show_user_detailed_testinfo ( uname ,testsetid ,sid  ){
    
var url = '/cgi-bin/My-otest/core.pl?flag=' + 'GET_USER_DETAILED_TEST_SUMMARY' + '&user_name='+uname + '&testsetid='+testsetid  + '&sid='+sid ;
    var load_disp = '#' + sid + '_summary_info';
    $(load_disp).html('<img src="/static/images/My-otest/1.gif" />');
    var title = '<b style="\
                                                    background-image:url(/static/images/My-otest/oinfo_title_bar.png); \
                                                    height:8px; \
                                                    width:200px; color:white;padding:0px"> \
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp\
                                                    Test Detailed Information \
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
                                        .html('<img src="/static/images/My-otest/closebutton.png" width="25" height="20" style="padding:1px">');
                                        $('.ui-widget-overlay').css('width','90%');
                                },  
                                
				width: 900,
                                height: 900,
				              
                                close: function(event, ui){
                                                    $('body').css('overflow','auto');
                                                    $(load_disp).html('');
						   
                                                    
                                       } 
                               
                              }).dialog('open');                
        }
    });    
}

function recieve_new_uname (){
    $("#load_mesg").html('verifying if same user_name exist .....');
    $("#load").html('<img src="/static/images/My-otest/1.gif" />');
    var uname =  document.getElementById("uname").value;
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'VERIFY_USER_NAME_EXIST&' + 'uname=' + uname;   
    $.get(
         url,
         function(data, textStatus, jqXHR) {
	                        var ret = data.toString();
	                        if ( ret == '1'){
				    $("#load_mesg").html('<br><b>Choose another user_name as it is already used</b>');
				    $("#load").html('');
				}else{
				    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'SHOW_NEW_USER_REG_FORM&' + 'uname=' + uname;      
				    $.get(
					    url,
					    function(data, textStatus, jqXHR) {
						$("#init_form").html('');
						$("#load").html('');
						$("#load_mesg").html('');
				                $("#new_user_form").html(data);
					    },
					    "html"
					);    
				
				}
				
				
                        },
        "text"
    );     
    
    
}

function recieve_register_form (uname) {
   
    $("#from_load").html('<img src="/static/images/My-otest/1.gif" />');
    var form_params = $("#new_user_form_reg1").serialize();
    form_params = form_params + '&uname=' + uname;
    var url = '/cgi-bin/My-otest/core.pl?flag=' + 'REGISTER_THIS_USER&' + form_params;
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#new_user_form_reg1").html('');
				$("#reg_mesg").html(data);
			    
                        },
        "html"
    );    
    
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ask_librarian (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'ASK_LIBRARIAN';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );    
}


function visitor_notes (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'VISITOR_NOTES';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );    
}

function research_paper (){
    clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'RESEARCH_PAPER';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );      
    
}

function need_lib_perm (){
    alert ( 'Need Librarian permission' );
}

function xerox(){
    clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'XEROX';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );       
    
}



function scan(){
    clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'SCAN';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );       
    
}

function print(){
    clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'PRINT';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );       
    
}

function conference_room (){
    clear();
  $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'CONFERENCE_ROOM';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );         
}

function stationaries(){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'STATIONARIES';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );         
  
}

function book_delivery (){
    clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'BOOK_DELIVERY';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );          
  
}


function learing_center (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'LEARNING_CENTER';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );          
 
}

function lib_management (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'LIB_MANGEMENT';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );          
 
}

function announcement() {
    clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'ANNOUNCEMENT';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );           

}

function calender_events() {
    clear();
  $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'CALENDER_EVENTS';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );           
    
}

function sponsered_events() {
  clear();
  $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'SPONCER_EVENTS';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );           
    
}



function gallery() {
   clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'GALLERY';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );           
}

function timings() {
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'TIMINGS';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );               
}

function lib_map() {
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'LIB_MAP';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );               
    
    
}

function staff_dirs() {
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'PAGE_UNDER_CONSTUCTION';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );               
    
    
}

function employment() {
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'PAGE_UNDER_CONSTUCTION';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );               
    
    
}

function funds_contribution() {
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'FUND_CONTRIBUTION';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );               
    
}

function rules_and_guidelines (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'RULES_GUIDELINES';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );                 
    
}

function borrowing_guidelines (){
   clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'BORROWING_RULES';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );                  
}

function fees_and_fines (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'FEES_FINES';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );                   
}


function material_donation (){
    clear();
    $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'MATRIEAL_DONATION';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );                
}

function monetory_donation (){
   clear();
   $("#core_load").html('<img src="/static/images/My_lib/1.gif" />');
    var url = '/cgi-bin/My-Lib/core.pl?flag=' + 'MONETORY_DONATION';
    $("#core_msg").html('');
    $.get(
         url,
         function(data, textStatus, jqXHR) {
                                $("#core_load").html('');
				$("#core_msg").html(data);
			    
                        },
        "html"
    );                 
       
}

function clear(){
    $("#user_manage").remove();
    $("#lib_manage").remove();
    $("#setting").remove();
    $("#reservation_saved").remove();
    $("#mail_menu").remove();
    $("#book_details_in_dialog").remove();
    $("#local_dialog_box").remove();

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


function search_book_with_param_adm ( random1 , random2){
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
	var sql;
        $.get(
            url,
            function(data, textStatus, jqXHR) {
                      sql = data.toString();
		      url = '/cgi-bin/My-lib/lib_manage.pl?flag=BOOKS_SEARCH_QUERY'+ '&sql=' + sql; 
		      $.get(
			    url,
			    function(data, textStatus, jqXHR) {
				    $("#sql").html(data);
			    },
			    "html"
		    );     
	    },
        "text"
        );
        

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
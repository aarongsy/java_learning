<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="java.util.Date"%>
<%@page import="com.eweaver.base.util.DateHelper"%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<head>
<!--<link href="/htfapp/web/css/common.css" rel="stylesheet" type="text/css" />-->
<!--<link href="/htfapp/web/css/oa.css" rel="stylesheet" type="text/css" />-->
<script src="/app/js/jquery.js" type="text/javascript" charset="utf-8"></script>
<!--<script src="/htfapp/web/js/jquery.easing.1.3.js" type="text/javascript" charset="utf-8"></script>-->
<link rel="stylesheet" href="/app/schedule/css/schedule.css" type="text/css"></link>
<!--<link rel="stylesheet" href="../culture/css/culture_association.css" type="text/css"></link>-->
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>

<script type="text/javascript" src="/app/schedule/js/schedule.js"></script>
<script type="text/javascript" src="/js/orgsubjectbudget.js"></script>

</head>

<body>
            
           
<%
			String date = StringHelper.trimToNull(request.getParameter("date"));
			DataService dataService = new DataService();      
            Date currentDate = null;
            if (StringHelper.isEmpty(date)){
            	currentDate = new Date();
            }else{
            	currentDate = DateHelper.stringtoDate(date);
            }
           
            
           String getdates = DateHelper.getCurrentDate();
           if(!StringHelper.isEmpty(date)){
        	   getdates = date;
           }
            int dayOfWeek = DateHelper.getDayOfWeek(currentDate); 
           	String weekfirst = "";           
            String weeklast = "";
            if (dayOfWeek==1){
            
            	weekfirst = DateHelper.getShortDate(DateHelper.getDay(currentDate,(dayOfWeek-7)));
            	weeklast = DateHelper.getShortDate(DateHelper.getDay(currentDate,0));
            }else{
            	weekfirst = DateHelper.getShortDate(DateHelper.getDay(currentDate,2-dayOfWeek));
            	weeklast = DateHelper.getShortDate(DateHelper.getDay(currentDate,8-dayOfWeek));
            }
           String startdate = weekfirst.replace("-",".");
           String enddate = weeklast.replace("-",".");
           
%>
 <div class="maindiv" style="overflow: hidden;">
 	 <div class="detaildiv">
 	    <div class="maindiv">
 	    	<p>日期：<input type="text" id="date" name="date" value="<%=getdates %>" onclick="WdatePicker()"/>
 	    		<a href="javascript:void(0)" id="newasso" onclick="onsearch1()"><span>搜 索</span></a>
 	    		<input type="hidden" name="selecttype" id="selecttype" value="" />
 	    		<a href="javascript:void(0)" id="newasso" onclick="selectAgendainfo(this)"><span>按时间列表</span></a>&nbsp;
 	    		<!-- <a href="javascript:void(0)" id="newasso" onclick="selectdept()"><span>部门负责人日程查询 </span></a> -->
 	    		</p>
 	    		<input type="hidden" id="hiddentime"/>
 	    </div>
 	    <div id="mailhtml"></div>
 	    <%-- 
 	    <div class="maindiv">
	 	    <table class="maintable" border="0px;" cellpadding="0" cellspacing="0" width="97%">
	 	    	<tr style="height: 35px;">
	 	    		<td width="20%">接收人：<button type=button  class=Browser name="button_ff80808131d709300131d76e0d4a04d5" onclick="javascript:getrefobj('hurmerids','hurmeridsspan','ff80808131d709300131d789034404e2','','','0');"></button></td>
	 	    		<td width="80%">
	 	    			<input type="hidden" name="hurmerids" id="hurmerids" value=""  style='width: 95%'  />
	 	    			<span id="hurmeridsspan" name="hurmeridsspan" ></span>
	 	    		</td>
	 	    	</tr>
	 	    	<tr>
	 	    		<td rowspan="2">自定邮件地址：</td>
	 	    		<td style="padding: 4px;">
	 	    			<textarea rows="6" id="zidingyi" name="zidingyi" cols="78" style="overflow: hidden; border: 1px; border-color: #C83E31;border-style: solid;" ></textarea><br />
	 	    			
	 	    			
	 	    		</td>
	 	    	</tr>
	 	    	<tr style="height: 20px;">
	 	    		<td style="padding: 0px;">需要输入多个自定义邮件地址，请用逗号（,）隔开邮件地址</td>
	 	    	</tr>
	 	    </table>
 	    </div>
 	    <center><button name="sendEmail" class="btnred01" onclick="sendEmail(this)" >发送邮件</button></center>
 	    --%>
 	 </div>
 </div>
</body>

<script>




//初始化
$(document).ready(function (){
document.getElementById("selecttype").value="按时间列表";
var datetime=document.getElementById("date").value;
	selectAgendaBydept(datetime);
	//selectdeptAgendaBydept(datetime)
});


var mailhtml="";
var deptmailhtml='';
function selectAgendainfo(obj){
	var datetime=document.getElementById("date").value;
	if(obj.innerText=="按时间列表"){
		selectAgendaByDate(datetime);
		//selectdeptAgendaByDate(datetime);
		obj.innerHTML="<span>按人员列表</span>";
		document.getElementById("selecttype").value="按人员列表";
	}else{
		selectAgendaBydept(datetime);
		//selectdeptAgendaBydept(datetime);
		obj.innerHTML="<span>按时间列表</span>";
		document.getElementById("selecttype").value="按时间列表";
	}
    //parent.document.getElementById('contentframe').onload();
}

//搜索
function onsearch1(){
	var selecttype=document.getElementById("selecttype").value;
	var datetime=document.getElementById("date").value;
	if(selecttype=="按时间列表"){
		selectAgendaBydept(datetime);
		//selectdeptAgendaBydept(datetime);
		
		//parent.document.getElementById('contentframe').onload();
	}else{ 
		selectAgendaByDate(datetime);
		//selectdeptAgendaByDate(datetime);
		//parent.document.getElementById('contentframe').onload();
	}
}

//按人员日程

function selectAgendaBydept(datetime){ 
    		jQuery.ajax({
		        //提交数据的类型 POST GET    
		        type : 'POST',    
		        //提交的网址    
		        url : '/app/agenda/executivescreatEmail.jsp',    
		        async:false,   
		        //提交的数据    
		        data : {    
		            date : datetime
		        },    
		        //返回数据的格式    
		        datatype : 'html', //xml, html, script, json, jsonp, text.    
		        //在请求之前调用的函数    
		        beforeSend : function() {    
		        },    
		        //成功返回之后调用的函数                 
		        success : function(data) {
		        	mailhtml=jQuery.trim(data);
		            jQuery("#mailhtml").html(mailhtml);    
		        },    
		        //调用出错执行的函数    
		        error : function() {    
		            alert('ajax失败！');    
		        }    
		    });
}
//按时间查日程
function selectAgendaByDate(datetime){
    		jQuery.ajax({
		        //提交数据的类型 POST GET    
		        type : 'POST',    
		        //提交的网址    
		        url : '/app/agenda/execcreatEmailBydate.jsp',    
		        async:false,   
		        //提交的数据    
		        data : {    
		            date : datetime
		        },    
		        //返回数据的格式    
		        datatype : 'html', //xml, html, script, json, jsonp, text.    
		        //在请求之前调用的函数    
		        beforeSend : function() {    
		        },    
		        //成功返回之后调用的函数                 
		        success : function(data) {
		        	mailhtml=jQuery.trim(data);
		            jQuery("#mailhtml").html(mailhtml);    
		        },    
		        //调用出错执行的函数    
		        error : function() {    
		            alert('ajax失败！');    
		        }    
		    });
}

//发送邮件
function sendEmail(obj){
	obj.innerText="正在发送";
	var mailcont=mailhtml+deptmailhtml;
	var sendallid=document.getElementById("hurmerids").value;
	var zdy=document.getElementById("zidingyi").value;
    		var mailTitle="公司高管层行程安排表(<%=startdate %>-<%=enddate %>)";
		    jQuery.ajax({
		        //提交数据的类型 POST GET    
		        type : 'POST',    
		        //提交的网址    
		        url : '/servlet/SendEmailServlet',
		        async:false,
		        //提交的数据    
		        data :{
		            sendMailUserId : sendallid,   
		            mailHTML : mailcont,    
		            mailTitle : mailTitle,
		            zidingyi : zdy
		        },    
		        //返回数据的格式    
		        datatype : 'html', //xml, html, script, json, jsonp, text.    
		        //在请求之前调用的函数    
		        beforeSend : function() {  
		        },    
		        //成功返回之后调用的函数                 
		        success : function(data) {
		           //mailhtml = jQuery.trim(data);
		            //jQuery("#mailhtml").html(mailhtml);   
		           alert("发送邮件成功！"); 
		        },    
		        //调用出错执行的函数    
		        error : function() {
		            alert('ajax失败！');    
		        }    
		    });
		    obj.innerText="已发送";
		    obj.disabled=true;
}


//按人员日程

function selectdeptAgendaBydept(datetime){ 
    		jQuery.ajax({
		        //提交数据的类型 POST GET    
		        type : 'POST',    
		        //提交的网址    
		        url : '/app/schedule/deptscheumenanaByUser.jsp',    
		        async:false,   
		        //提交的数据    
		        data : {    
		            date : datetime
		        },    
		        //返回数据的格式    
		        datatype : 'html', //xml, html, script, json, jsonp, text.    
		        //在请求之前调用的函数    
		        beforeSend : function() {    
		        },    
		        //成功返回之后调用的函数                 
		        success : function(data) {
		        	deptmailhtml=jQuery.trim(data);
		            jQuery("#mailhtml").html(mailhtml+deptmailhtml);    
		        },    
		        //调用出错执行的函数    
		        error : function() {    
		            alert('ajax失败！');    
		        }    
		    });
}
//按时间查日程
function selectdeptAgendaByDate(datetime){
    		jQuery.ajax({
		        //提交数据的类型 POST GET    
		        type : 'POST',    
		        //提交的网址    
		        url : '/app/schedule/deptscheumenanaByDate.jsp',    
		        async:false,   
		        //提交的数据    
		        data : {    
		            date : datetime
		        },    
		        //返回数据的格式    
		        datatype : 'html', //xml, html, script, json, jsonp, text.    
		        //在请求之前调用的函数    
		        beforeSend : function() {    
		        },    
		        //成功返回之后调用的函数                 
		        success : function(data) {
		        	deptmailhtml=jQuery.trim(data);
		            jQuery("#mailhtml").html(mailhtml+deptmailhtml);    
		        },    
		        //调用出错执行的函数    
		        error : function() {    
		            alert('ajax失败！');    
		        }    
		    });
}

function selectdept(){
	var datetime=document.getElementById("date").value;
	 window.location.href="/app/schedule/deptschedulemanalist.jsp?date="+datetime;
}

</script>

</html>
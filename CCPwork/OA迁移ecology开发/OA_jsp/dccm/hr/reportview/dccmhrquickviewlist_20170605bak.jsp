<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<!--%@ page import="com.eweaver.app.trade.servlet.doexecuteSQL" %-->


<head>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" >
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
<!--
body {
	margin-left: 20px;
	margin-right: 20px;
}

.STYLE3 {font-family:'Arial','SimSun','Microsoft YaHei';font-size: 12px/0.75em;}

.STYLE9 {
	font-family: "微软雅黑";
	font-size: 25px;
	font-weight: bold;
}

.STYLE10 {
	font-family: "微软雅黑";
	font-size: 28px;
}

.header tr td {
	height: 23px;
	align: left;
	border-bottom:0px solid black;
	border-left:0px solid black;
}

.detail tr td {
	height: 23px;
	align: left;
	border-bottom:0px solid black;
	border-left:0px solid black;
	//font-family: "微软雅黑";
	//font-size: 12px;
}

.footer  tr td {
	height: 23px;
	align: left;
	border-bottom:0px solid black;
	border-left:0px solid black;
}

textarea 
{ 
width:100%; 
height:100%; 
} 

select option {
	font-size:16px; 
	font-family:"微软雅黑";
}


-->
</style>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<!--script type="text/javascript" src="/js/ext/ext-all.js"></script-->
<script type="text/javascript">


function trim(str){ //删除左右两端的空格
　　return str.replace(/(^\s*)|(\s*$)/g, "");
}

function LeaveView(){
	var leaveviewurl = document.getElementById("leaveviewurl").value;
    window.open(leaveviewurl);          

}

</script>
</head>

<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户

BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and ( (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a8d58b965900158bd3b0060164f' or roleid='402881e50bf0a737010bf0a96ba70004')) or ('"+userid+"' in (select id from v_uf_dmhr_leaderview)) ) "));
// or id='40285a9049ade1710149adea9ef20caf'"));
String leaveviewurl = "/ReportServer?reportlet=/app/dccm/hr/Leave/LeaveView.cpt&id="+userid; 	//LeaveView
//HR考勤人员（审核）：	40285a8d58b965900158bd3b0060164f		系统管理员	402881e50bf0a737010bf0a96ba70004

%>
 
<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<form method="post" id="myForm">
		<input type="hidden" id="userid" name="userid" value="<%=userid %>"/>	
		<input type="hidden" id="leaveviewurl" name="leaveviewurl" value="<%=leaveviewurl %>"/>	
	</form>  

	<div>
		<div align="center"><SPAN class="STYLE10">DCCM Time Quick View</SPAN></div>
	</div>

	<table width="100%%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr><td colspan="2" >Notice: Only authorized persons can view this button.</td></tr>
		<tr>
			
			<td colspan="2" rowspan="2"><SPAN class="STYLE3"><input type=<%=(existflag>0 ?"button":"hidden") %> name="radiobutton2" value="LeaveView" onclick="LeaveView();" /></SPAN></td>
		</tr>
		
	</table>

	</body>
</html>
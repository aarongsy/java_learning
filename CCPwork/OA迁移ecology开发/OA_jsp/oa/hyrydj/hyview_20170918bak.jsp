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
<%@ page import="com.eweaver.app.trade.servlet.doexecuteSQL" %>
<%@ include file="/base/init.jsp"%>

<head>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" >
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
<!--
body {
	margin-left: 20px;
	margin-right: 20px;
}
-->

.STYLE3 {font-family:'Arial','SimSun','Microsoft YaHei';font-size: 12px/0.75em;}
.STYLE4 {font-family:'Arial','SimSun','Microsoft YaHei';font-size: 12px/0.75em;font-weight: bold;}
<!--
.STYLE9 {
	font-family: "微软雅黑";
	font-size: 25px;
	font-weight: bold;
}
-->
.STYLE10 {
	font-family: "微软雅黑";
	font-size: 28px;
}
<!--

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
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<!--script type="text/javascript" src="/js/ext/ext-all.js"></script-->
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>

<script type="text/javascript">


function trim(str){ //删除左右两端的空格
　　return str.replace(/(^\s*)|(\s*$)/g, "");
}

function showInfo() {
	DWREngine.setAsync(false);//设置为同步获取数据
	var carno = trim(document.getElementById("carno").value);	
	var ladingno = trim(document.getElementById("ladingno").value);	
	var loadingno = trim(document.getElementById("loadingno").value);
	var curdate = trim(document.getElementById("dateid").value);
	var isself = trim(document.getElementById("isself").value);
	var printtype = trim(document.getElementById("printtype").value);
	alert("carno="+carno+" ladingno="+ladingno+" loadingno="+loadingno+" curdate="+curdate +" isself="+isself +" printtype="+printtype);
	var flag = true;
	var errmsg = '';
	if((carno=='' && ladingno=='' && loadingno=='')){
		alert('查询条件：车牌号、提入单号、装卸计划号 至少输入一个条件！');
		errmsg = '查询条件：车牌号、提入单号、装卸计划号 至少输入一个条件！';
		flag = false;		
	}	
	if(flag){
		document.getElementById('infoid').innerHTML = "查询中，请稍等......";
		Ext.Ajax.request({                                                                                                 
			 url: '/app/oa/hyrydj/gethypsnview.jsp',                                 
			 params:{carno:carno,ladingno:ladingno,loadingno:loadingno,sdate:curdate,edate:curdate,isself:isself,printtype:printtype},
			 success: function(res) {                                                                                                 
				var str=res.responseText;
                //alert(str);				
				document.getElementById('infoid').innerHTML=str;               
			 }                                                                                                
		}); 
	}else{
		document.getElementById('infoid').innerHTML = errmsg;
	}
	DWREngine.setAsync(true);
}

function exportExcel1(tableid,tableid2){     
    var oXL = new ActiveXObject('Excel.Application');      
    var oWB = oXL.Workbooks.Add(); 
	var laprows = 1;
	if(tableid!='' && tableid!=null && tableid!='null'){
	    var oSheet = oWB.ActiveSheet;  
		var table = document.getElementById(tableid) ;     
		var hang = table.rows.length;     
		var lie = table.rows(0).cells.length;     
		for (i=0;i<hang;i++){     
			for (j=0;j<lie;j++){     
				oSheet.Cells(i+1,j+1).NumberFormatLocal = '@';     
				oSheet.Cells(i+1,j+1).Font.Bold = true;     
				oSheet.Cells(i+1,j+1).Font.Size = 10;     
				oSheet.Cells(i+1,j+1).value = trim(table.rows(i).cells(j).innerText);     
			}     
		}  
	}

	if(tableid2!='' && tableid2!=null && tableid2!='null'){
		oWB.Worksheets(2).Activate(); 
		var oSheet2 = oWB.ActiveSheet;  
		var table2 = document.getElementById(tableid2) ;     
		var hang2 = table2.rows.length;     
		var lie2 = table2.rows(0).cells.length;     
		for (i=0;i<hang2;i++){     
			for (j=0;j<lie2;j++){     
				oSheet2.Cells(i+1,j+1).NumberFormatLocal = '@';     
				oSheet2.Cells(i+1,j+1).Font.Bold = true;     
				oSheet2.Cells(i+1,j+1).Font.Size = 10;     
				oSheet2.Cells(i+1,j+1).value = trim(table2.rows(i).cells(j).innerText);     
			}     
		} 
	}
	
    oXL.Visible = true;     
    oXL.UserControl = true;     
} 

function openfrom(CARNO,LOADINGNO,CREATETIME,REQUESTID)
{
	DWREngine.setAsync(false);//设置同步获取数据
	if(REQUESTID!='')
	{
		/*if(REQUESTID.indexOf(',')!=-1)
		{
			REQUESTID=REQUESTID.split(',')[0];
		}*/
		for(var i=0;i<REQUESTID.split(',').length;i++)
		{
//alert(REQUESTID.split(',')[i]);
			var str='/workflow/request/formbase.jsp?categoryid=40285a8d53ca0f480153d107196b0355&requestid='+REQUESTID.split(',')[i];
			onUrl(str,CARNO,'tab'+LOADINGNO) ;
		}
		
	}
	else
	{
		var str='/workflow/request/formbase.jsp?categoryid=40285a8d53ca0f480153d107196b0355&loadingno='+LOADINGNO+'&createtime='+CREATETIME+'&carno='+CARNO;
		onUrl(str,CARNO,'tab'+LOADINGNO) ;
	}
	DWREngine.setAsync(true);//设置同步获取数据
}

</script>
</head>

<%

BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
String curjobno = ds.getValue("select objno from humres where id='"+userid+"'");
String today =ds.getValue(" select to_char(sysdate,'YYYY-MM-DD') yearmon from dual");
//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a8d58b965900158bd3b0060164f' or roleid='40285a8d587f8d6b01587f9332620005')) "));
//or id='40285a9049ade1710149adea9ef20caf'"));
//System.out.println(userid+" " +curjobno +" "+cursapid + " "+ existflag);
//HR考勤人员（审核）角色：	40285a8d58b965900158bd3b0060164f		HR-OrgSyc(人事组织管理)角色		40285a8d587f8d6b01587f9332620005
//指定人员 徐一峰	40285a9049ade1710149adea9ef20caf
int existflag = 1;

String carno = "";
String ladingno = "";
String loadingno = "";
%>
 
<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<form method="post" id="myForm">
		<input type="hidden" id="url" name="url" value=""/>	
	</form>  

	<div>
		<div align="center"><SPAN class="STYLE10">出入厂货运人员登记报表</SPAN></div>
	</div>

	<table width="100%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td><SPAN class="STYLE4">车牌号码</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=carno %>" id="carno" name="carno" /></SPAN><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=carno %></span></td> 
			<td><SPAN class="STYLE4">提入单号</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=ladingno %>"id="ladingno" name="ladingno" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=ladingno %></span></SPAN></td>
			<td><SPAN class="STYLE4">装卸计划号</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=loadingno %>" id="loadingno" name="loadingno" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=loadingno %></span></SPAN></td>
			<td><SPAN class="STYLE4">当前日期("YYYY-MM-DD")</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value="<%=today %>" id="dateid" name="dateid" /></td>
		</tr>
		<tr>
			<td><SPAN class="STYLE4">自提/非自提</SPAN></td>
			<td><SPAN class="STYLE3"><select type="text" id="isself" name="isself" value=""><option value="" selected >不限</option><option value="40288098276fc2120127704884290210" >自提</option><option value="40288098276fc2120127704884290211">非自提</option></select></span></td>
			<td><SPAN class="STYLE4">物品入厂单/提货单</SPAN></td>
			<td><SPAN class="STYLE3"><select type="text" id="printtype" name="printtype" value=""><option value="" selected >不限</option><option value="402864d14a1d679c014a1d8cf7b50006" >物品入厂单</option><option value="402864d14a1d679c014a1d8cf7b50005">提货单</option></select></span></td>
		</SPAN></td>
		
		</tr>
		<tr>
			<td><input id="buttid" type="button" name="radiobutton2" value="查询" onclick="showInfo();" /></SPAN></td>	
		</tr>
		<tr>
			<td colspan="6"><SPAN class="STYLE4">查询信息:</SPAN></td>
		</tr>
		<tr>
			<td colspan="6"><SPAN class="STYLE3" id="searchinfo"></SPAN></td>
			
		</tr>	
	</table>
	
	<div id="infoid">
	</div>

	</body>
</html>
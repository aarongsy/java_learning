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
	var jobnos = trim(document.getElementById("jobnos").value);	
	var jobnames = trim(document.getElementById("jobnames").value);	
	var sdate = trim(document.getElementById("sdate").value);
	var edate = trim(document.getElementById("edate").value);
	var curdate = trim(document.getElementById("dateid").value);
	var schname = trim(document.getElementById("schname").value);	
	var comtype = trim(document.getElementById("comtype").value);
	//alert("jobnos="+jobnos+" jobnames="+jobnames+" sdate="+sdate+" edate="+edate +" curdate="+curdate +" schname="+schname +" searchtype="+searchtype+" comtype"+comtype);
	var flag = true;
	var errmsg = '';
	if((jobnos=='' && jobnames=='' )){
		alert('查询条件：工号、姓名不可同时为空！');
		errmsg = '查询条件：工号、姓名不可同时为空！';
		flag = false;		
	}	
	if(flag){
		document.getElementById('infoid').innerHTML = "查询中，请稍等......";
		Ext.Ajax.request({                                                                                                 
			 url: '/app/hrmanage/pjdbschedule/getpsnscheview.jsp',                                 
			 params:{jobnos:jobnos,jobnames:jobnames,sdate:sdate,edate:edate,curdate:curdate,schname:schname,comtype:comtype},
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
</script>
</head>

<%

BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
String comtype = ds.getValue("select extrefobjfield5 from humres where id='"+userid+"'");
String comtypename =ds.getValue("select objname from orgunittype where id='"+comtype+"'");
int adminflag = 0;
if ( "402881e70be6d209010be75668750014".equals(userid) ) {
	adminflag =1;
}
String curjobno = ds.getValue("select objno from humres where id='"+userid+"'");
String today =ds.getValue(" select to_char(sysdate,'YYYY-MM-DD') yearmon from dual");
//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a8d58b965900158bd3b0060164f' or roleid='40285a8d587f8d6b01587f9332620005')) "));
//or id='40285a9049ade1710149adea9ef20caf'"));
//System.out.println(userid+" " +curjobno +" "+cursapid + " "+ existflag);
//HR考勤人员（审核）角色：	40285a8d58b965900158bd3b0060164f		HR-OrgSyc(人事组织管理)角色		40285a8d587f8d6b01587f9332620005
//指定人员 徐一峰	40285a9049ade1710149adea9ef20caf
int existflag = 1;

String jobnos = "CP0414/CP0533/CP0096/CP0718/CP0373/CP0376/CP0594/CP0390/CP0308/DP0074/DP0097/DP0108/DP0110/DP0133/DP0134/DP0160/DP0185/DP0207/DP0229/DP0232/DP0123/DP0151/DP0152/DP0191/DP0195/DP0211/DP0224/CP0130/CP0347/CP0423/CP0232/CP0407/CP0481/CP0202/CP0783/CP0671/CP0617/CP0346/CP0068/CP0382/CP0127/CP0795/CP0758";
String jobnames = "";
String sdate = today;
String edate = today;
String schname = "";
%>
 
<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<form method="post" id="myForm">
		<input type="hidden" id="url" name="url" value=""/>	
	</form>  

	<div>
		<div align="center"><SPAN class="STYLE10">盘锦厂驾驶证倒班人员排班表查询报表</SPAN></div>
	</div>

	<table width="100%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td><SPAN class="STYLE4">工号（多个以/隔开）</SPAN></td>
			<td colspan=9><SPAN class="STYLE3"><input style="width:1000px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=jobnos %>" id="jobnos" name="jobnos" /></SPAN><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=jobnos %></span></td>			
		</tr>
		<tr>
			<td><SPAN class="STYLE4">姓名（按姓名查询的话，请清空工号）</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=jobnames %>"id="jobnames" name="jobnames" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=jobnames %></span></SPAN></td>
			<td><SPAN class="STYLE4">班别</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=schname %>" id="schname" name="schname" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=schname %></span></SPAN></td>
			<td><SPAN class="STYLE4">排班日期(起)("YYYY-MM-DD")</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=sdate %>" id="sdate" name="sdate" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=sdate %></span></SPAN></td>
			<td><SPAN class="STYLE4">排班日期(止)("YYYY-MM-DD")</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value="<%=edate %>" id="edate" name="edate" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=edate %></span></SPAN></td>
			<td><SPAN class="STYLE4">当前日期("YYYY-MM-DD")</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value="<%=today %>" id="dateid" name="dateid" /></td>
		</tr>		
		<tr>			
			<td><SPAN class="STYLE4">厂区别</SPAN></td>
			<td><SPAN class="STYLE3">
			<%
			if (adminflag==1) { %>
			<select type="text" id="comtype" name="comtype" value="40285a90488ba9d101488bbd09100007"><option value="40285a90488ba9d101488bbd09100007" selected >盘锦厂</option></select>
			<%
			} else { 
			%>
			<select type="text" id="comtype" name="comtype" value="<%=comtype %>""><option value="<%=comtype %>" selected ><%=comtypename %></option></select>
			<%
			}
			%>
			</span></td>
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
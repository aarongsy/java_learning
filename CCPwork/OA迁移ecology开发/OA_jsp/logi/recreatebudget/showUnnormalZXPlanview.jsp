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
	var planno = trim(document.getElementById("planno").value);	
	//alert("jobnos="+jobnos+" jobnames="+jobnames+" sdate="+sdate+" edate="+edate +" curdate="+curdate +" schname="+schname +" searchtype="+searchtype+" comtype"+comtype);
	var flag = true;
	var errmsg = '';	
	if(flag){
		document.getElementById('infoid').innerHTML = "查询中，请稍等......";
		Ext.Ajax.request({                                                                                                 
			 url: '/app/logi/recreatebudget/getUnnormalZXPlanview.jsp',                                 
			 params:{planno:planno},
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

function singlecrebudget(planno){           
    DWREngine.setAsync(false);//设置为同步获取数据 
	var flag = false;  
    //if(judgePermision()){  
	if(true){   
		var myMask = new Ext.LoadMask(Ext.getBody(), {           
		msg: '创建暂估单执行中, 请稍等...',           
		removeMask: true           
		});           
		myMask.show();           
		jQuery.ajax({           
		async:false,           
		url:'/app/logi/recreatebudget/crebufgetAction.jsp?fresh=' + Math.random(),                
		data:{         
		action:'crebudget',                
		loadplanno:planno
		},           
		dataType:'json',           
		success: function(result) {           
			myMask.hide();           
			if(result.msg && result.msg=='true'){          
				alert('创建暂估单成功!');
				location.reload();          
			}else{           
				alert('创建暂估单成功失败:'+result.info);           
			}           
		},           
		failure:function(result){           
			alert('创建暂估单成功Error:'+result.info);           
		}});                      
    }     
    DWREngine.setAsync(true);//设置为不同步获取数据          
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


String planno = "";
%>
 
<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<form method="post" id="myForm">
		<input type="hidden" id="url" name="url" value=""/>	
	</form>  

	<div>
		<div align="center"><SPAN class="STYLE10">非自提装卸计划（2017/11/17起包车过磅）未生成暂估单的清单查询</SPAN></div>
	</div>

	<table width="100%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td><SPAN class="STYLE4">非自提装卸计划号</SPAN></td>
			<td><SPAN class="STYLE3"><input type=<%=(existflag>0 ?"text":"hidden") %> value="<%=planno %>"id="planno" name="planno" /><span style=<%=(existflag>0 ?"display:none":"display:block") %> ><%=planno %></span></SPAN></td>
			<td><input id="buttid" type="button" name="radiobutton2" value="查询" onclick="showInfo();" /></SPAN></td>
		</tr>		
		<tr>
			<td colspan="3"><SPAN class="STYLE4">查询信息:</SPAN></td>
		</tr>
		<tr>
			<td colspan="3"><SPAN class="STYLE3" id="searchinfo"></SPAN></td>
			
		</tr>	
	</table>
	
	<div id="infoid">
	</div>

	</body>
</html>
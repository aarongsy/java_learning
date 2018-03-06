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

function SelectAll(){
	var flag = document.getElementById("selallid").checked;
	var leavequota = document.getElementsByName("leavequota");
	for (var i=0;i<leavequota.length;i++)
	{
		leavequota[i].checked = flag;
	}	
}

function showSAPQuotainfo() {
	DWREngine.setAsync(false);//设置为同步获取数据
	var empsapid = trim(document.getElementById("empsapid").value);	
	var quotadate = trim(document.getElementById("quotadate").value);	
	var jobno = trim(document.getElementById("jobno").value);
	var leavequota =document.getElementsByName("leavequota"); 
	var quotaids = "";
	//txt=""
	for (var i=0;i<leavequota.length;i++)
	{
		if (leavequota[i].checked)
		{
			if( quotaids=="" ){
				quotaids=quotaids + leavequota[i].value ;
			}else{
				quotaids=quotaids + ","+ leavequota[i].value;
			}			
		}
	}
	//alert("empsapid="+empsapid+" quotadate="+quotadate+" jobno="+jobno+" leavequota="+leavequota+" quotaids="+quotaids);
	var flag = true;
	var errmsg = '';
	if((empsapid=='' && jobno=='')){
		alert('Please input \'Employee No.\' or \'Employee SAPID\' at first!');
		errmsg = 'Please input \'Employee No.\' or \'Employee SAPID\' at first!';
		flag = false;		
	}else if(jobno!='') {
		var sql = 'select exttextfield15 from humres where objno =\''+jobno +'\'';
		DataService.getValues(sql,{callback:function(data){    
			if(data&&data.length>0){ 			
				var newempsapid = data[0].exttextfield15;
				if(newempsapid!=empsapid){
					document.getElementById("empsapid").value = newempsapid;
					empsapid = newempsapid;
				}
			}else{
				document.getElementById("empsapid").value = '';
				empsapid = '';
				alert('There is no \'Employee SAPID\' of \'Employee No.\', please check with HR Admin or OA Admin');
				errmsg = 'There is no \'Employee SAPID\' of \'Employee No.\', please check with HR Admin or OA Admin'
				flag = false;
			}
		}});

		
	}
	if(quotaids==''){
		alert('Please select \'Leave Quota\'  at first!');
		errmsg = 'Please select \'Leave Quota\'  at first!';
		flag = false;		
	}
	
	if(flag){
		document.getElementById('quotainfoid').innerHTML = "searching from SAP, please wait......";
		Ext.Ajax.request({                                                                                                 
			 url: '/app/dccm/hr/selfhelp/leavequota/empLeaveQuotaview.jsp',                                 
			 params:{jobno:jobno,empsapid:empsapid,quotadate:quotadate,quotaids:quotaids},
			 success: function(res) {                                                                                                 
				var str=res.responseText;                                                                            
				document.getElementById('quotainfoid').innerHTML=str;               
			 }                                                                                                
		}); 
	}else{
		document.getElementById('quotainfoid').innerHTML = errmsg;
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
String curjobno = ds.getValue("select objno from humres where id='"+userid+"'");
String cursapid = ds.getValue("select exttextfield15 from humres where id='"+userid+"'");
String today =ds.getValue(" select to_char(sysdate,'YYYYMMDD') yearmon from dual");
int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a8d58b965900158bd3b0060164f' or roleid='40285a8d587f8d6b01587f9332620005')) "));
//or id='40285a9049ade1710149adea9ef20caf'"));
//System.out.println(userid+" " +curjobno +" "+cursapid + " "+ existflag);
//HR考勤人员（审核）角色：	40285a8d58b965900158bd3b0060164f		HR-OrgSyc(人事组织管理)角色		40285a8d587f8d6b01587f9332620005
//指定人员 徐一峰	40285a9049ade1710149adea9ef20caf
//int existflag = 1;


%>
 
<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<form method="post" id="myForm">
		<input type="hidden" id="url" name="url" value=""/>	
	</form>  

	<div>
		<div align="center"><SPAN class="STYLE10">DCCM Employee Leave Quota Search</SPAN></div>
	</div>

	<table width="100%%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td><SPAN class="STYLE4">Employee No.</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value=<%=curjobno %> id="jobno" name="jobno" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=curjobno %></span></SPAN></td>
			<td><SPAN class="STYLE4">Employee SAPID</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type=<%=(existflag>0 ?"text":"hidden") %> value=<%=cursapid %> id="empsapid" name="empsapid" /><span style=<%=(existflag>0 ?"display:none":"display:block") %>><%=cursapid %></span></SPAN></td>
			<td><SPAN class="STYLE4">Quota Deduction to("YYYYMMDD")</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value="<%=today %>" id="quotadate" name="quotadate" />
		</tr>
		<tr>			
			<td><SPAN class="STYLE4">Leave Quota</SPAN></td>
			<td><input type="checkbox" id="selallid" onclick="SelectAll();" value="">Select All</td>
		</tr>
		<tr><td></td>
			<td colspan=6><SPAN class="STYLE3">
<%		

	String sql ="select a.quoid,a.quotext from uf_dmhr_quota a,formbase b where a.requestid=b.id and b.isdelete=0 and a.quoid!='9999' order by a.quoid asc";
	List list = baseJdbcDao.executeSqlForList(sql);
	if ( list.size()>0 ) {	
		for ( int i=0; i<list.size(); i++ ){
			Map map = (Map)list.get(i);			
			String quoid = StringHelper.null2String(map.get("quoid"));
			String quotext = StringHelper.null2String(map.get("quotext"));
			
%>
			<input type="checkbox" name="leavequota" value="<%=quoid %>"><%=quoid %>&nbsp;<%=quotext %>
<%	
			if ( i==4 ) {
			%>
			</SPAN></td>
			</tr>
			<tr><td></td>
			<td colspan=5><SPAN class="STYLE3">
			<%
			}
		}
	}
%>		
		</SPAN></td>
		</tr>
		<tr>
			<td><input id="empbutid" type="button" name="radiobutton2" value="Search" onclick="showSAPQuotainfo();" /></SPAN></td>	
		</tr>
		<tr>
			<td colspan="6"><SPAN class="STYLE4">Search Infomation:</SPAN></td>
		</tr>
		<tr>
			<td colspan="6"><SPAN class="STYLE3" id="searchinfo"></SPAN></td>
			
		</tr>	
	</table>
	
	<div id="quotainfoid">
	</div>

	</body>
</html>
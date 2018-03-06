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
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
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

function checkroot(obj){
	if(obj.value == "1"){
		obj.value = "0";
	}else{
		obj.value = "1";
	}
}

function searchDetails() {
	DWREngine.setAsync(false);//设置为同步获取数据	
	var deptid = trim(document.getElementById("deptid").value);		
	var allorgid = trim(document.getElementById("allorgid").value);
	var isroot =  trim(document.getElementById("isroot").value); //document.getElementById("allorgid").checked;	
	var kqtype = trim(document.getElementById("kqtype").value); //jQuery("#kqtype").val(); //0 不限 1 加班 2请假
	var jobno = trim(document.getElementById("jobno").value); //jQuery("#jobno").val();	
	var jobname = trim(document.getElementById("jobname").value); //jQuery("#jobname").val();
	var startdate = trim(document.getElementById("startdate").value);		//jQuery("#startdate").val();
	var enddate = trim(document.getElementById("enddate").value);	//jQuery("#enddate").val();
	
	//此处trim(jQuery(#id).val()) $.trim(jQuery(#id).val()) jQuery.trim(jQuery(#id).val())会报错，试过多种方式，无法解决
	
	var daterange = trim(document.getElementById("daterange").value);  //0 仅今天 1 前后7天 2 前7天  3 后7天 4 本月  5 上月  6 下月 7 指定期间（查询所有人：不可超过100天，查询单个人：不可超过366天）
	var psntype = trim(document.getElementById("psntype").value); //0 自己 //1 部门所有人  2 全厂主管
	var searchtype = trim(document.getElementById("searchtype").value); //0 模糊查询 //精确查询
	var curruserno = trim(document.getElementById("curruserno").innerText);	
	
	//alert("deptid="+deptid+" allorgid="+allorgid+" isroot="+isroot+" kqtype="+kqtype+" jobno="+jobno+" jobname="+jobname+" startdate="+startdate+" enddate="+enddate+" daterange="+daterange+" psntype="+psntype+" searchtype="+searchtype+" curruserno="+curruserno);
	var flag = true;
	var errmsg = '';
	if(deptid=='' ){
		alert('部门不可为空');
		errmsg = '错误提示：部门不可为空';
		flag = false;		
	}
	if( daterange == '7' &&  (startdate=='' || enddate=='')){
		alert('指定期间, 查询日期起止不可为空');
		errmsg = '错误提示：指定期间, 查询日期起止不可为空';
		flag = false;	
	}
	
	
	if(flag){
		document.getElementById('searchinfo').innerHTML = "查询中，请稍候......";
		
		Ext.Ajax.request({                                                                                                 
			 url: '/app/hrmanage/jspreport/otleave/getOTLeaveDetailsview.jsp',                                 
			 params:{deptid:deptid,allorgid:allorgid,isroot:isroot,kqtype:kqtype,jobno:jobno,jobname:jobname,startdate:startdate,enddate:enddate,daterange:daterange,psntype:psntype,searchtype:searchtype,curruserno:curruserno},
			 success: function(res) {                                                                                                 
				var str=res.responseText;
                //alert(str);				
				document.getElementById('searchinfo').innerHTML=str;               
			 }                                                                                                
		}); 
	}else{
		document.getElementById('searchinfo').innerHTML = errmsg;
	}
	DWREngine.setAsync(true);
}

function openflow(flowno,requestid)
{
	DWREngine.setAsync(false);//设置同步获取数据
	var str='/workflow/request/workflow.jsp?requestid='+requestid;
	//alert(str);
	onUrl(str,flowno,'tab'+flowno) ;
	DWREngine.setAsync(true);//设置同步获取数据
}

function newflow(workflowid,flowname)
{
	DWREngine.setAsync(false);//设置同步获取数据
	onUrl('/workflow/request/workflow.jsp?&workflowid='+workflowid,flowname);
	DWREngine.setAsync(true);//设置同步获取数据
}



function chgpsntype(){
	DWREngine.setAsync(false);//设置同步获取数据
	var psntype = trim(document.getElementById("psntype").value);	//0 自己 //1 部门所有人 2 全厂主管  3 常熟厂 4 长沙厂 5 盘锦厂
	var currusername = trim(document.getElementById("currusername").innerText);	
	var curruserno = trim(document.getElementById("curruserno").innerText);	
	if ( psntype=='0' ) {
		document.getElementById("jobno").value = curruserno; 
		document.getElementById("jobname").value = currusername; 		
	} else if ( psntype=='1' ) {
		document.getElementById("jobno").value = ''; 
		document.getElementById("jobname").value = ''; 
	} else if ( psntype=='2' || psntype=='3' || psntype=='4' ||  psntype=='5' ) {
		document.getElementById("jobno").value = ''; 
		document.getElementById("jobname").value = ''; 
		document.getElementById("deptid").value = 'all';
	}
	DWREngine.setAsync(true);
}

function chgdaterange(){
	DWREngine.setAsync(false);//设置同步获取数据
	var daterange = trim(document.getElementById("daterange").value);	//0 仅今天 1 前后7天 2 前7天  3 后7天 4 本月  5 上月  6 下月 7 指定期间（查询所有人：不可超过100天，查询单个人：不可超过366天）
	var currdate = trim(document.getElementById("currdate").value); 
	if ( daterange=='0' ) {
		document.getElementById("startdate").value = currdate; 
		document.getElementById("enddate").value = currdate; 
	} else if ( daterange=='1' ) {
		document.getElementById("startdate").value = ''; 
		document.getElementById("enddate").value = ''; 
	} else if ( daterange=='2' ) {
		document.getElementById("startdate").value = ''; 
		document.getElementById("enddate").value = currdate; 
	} else if ( daterange=='3' ) {
		document.getElementById("startdate").value = currdate; 
		document.getElementById("enddate").value = ''; 
	} else if ( daterange=='4' ) {
		document.getElementById("startdate").value = ''; 
		document.getElementById("enddate").value = ''; 
	} else if ( daterange=='5' ) {
		document.getElementById("startdate").value = ''; 
		document.getElementById("enddate").value = ''; 
	} else if ( daterange=='6' ) {
		document.getElementById("startdate").value = ''; 
		document.getElementById("enddate").value = ''; 
	} else if ( daterange=='7' ) {
		//document.getElementById("startdate").value = ''; 
		//document.getElementById("enddate").value = ''; 
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
String currusername = "";
String curruserno = "";
String jobno = "";
String jobname = "";
String orgid = "";
String mainstation = "";
String orgids = "";
String station = "";

String comtype = "";
String company = "";
String onedept = "";
String twodept = "";
String seclevel = "";

String isleave = "";
String hrstatus = "";
String leavedate = "";
String today = "";

String strOrgids = "";

String isHRRole = "";
String isPJHRRole = "";

if( "40285a9049ade1710149ade86f060561".equals(userid) ||  "40285a9049ade1710149ade9664a089f".equals(userid) ||  "40285a9049ade1710149ade81adc0449".equals(userid)  ||  "297e55a649c703900149c70949270051".equals(userid) ||  "402881e70be6d209010be75668750014".equals(userid) ||  "40285a9049ade1710149ade95e110883".equals(userid) ||  "40285a9049ade1710149adeaf0880dbf".equals(userid)) {	
	isHRRole = "1";
	//指定人员 				
	//人事 夏烨江	40285a9049ade1710149ade86f060561  邵建	40285a9049ade1710149ade9664a089f	 殷燕	40285a9049ade1710149ade81adc0449	  黄心怡 297e55a649c703900149c70949270051	
	//sysadmin		402881e70be6d209010be75668750014  徐晓亚 40285a9049ade1710149ade95e110883	 吴羽佳	40285a9049ade1710149adeaf0880dbf		全厂均可查询
}

		
if( "40285a904a1d4bfd014a2e7ad9fc002f".equals(userid) ||  "40285a904a1d4bfd014a2e7ad94f002d".equals(userid) ||  "40285a904a1d4bfd014a2e7adb590033".equals(userid)  ||  "40285a904a1d4bfd014a2e7ade71003b".equals(userid) ||  "402881e70be6d209010be75668750014".equals(userid) ||  "40285a9049ade1710149ade95e110883".equals(userid) ||  "40285a9049ade1710149adeaf0880dbf".equals(userid) ) {	
	isPJHRRole = "1";
	//盘锦厂 	周一	40285a904a1d4bfd014a2e7ad9fc002f	范林林	40285a904a1d4bfd014a2e7ad94f002d	张敏	40285a904a1d4bfd014a2e7adb590033		王飞 40285a904a1d4bfd014a2e7ade71003b
	//sysadmin		402881e70be6d209010be75668750014  徐晓亚 40285a9049ade1710149ade95e110883	 吴羽佳	40285a9049ade1710149adeaf0880dbf		全厂均可查询
}

JSONArray jsonArrDept = new JSONArray();

//String curusersql = "select distinct to_char(sysdate,'YYYY-MM-DD') today,a.id,a.objno,a.objname,a.orgid,a.mainstation,a.orgids,b.id deptid,b.objname deptname,a.station,a.extrefobjfield5 comtype,a.extmrefobjfield9 company,a.extmrefobjfield8 onedept,a.extmrefobjfield7 twodept,a.seclevel,a.extselectitemfield14 isleave,a.hrstatus,a.extdatefield4 leavedate from humres a, orgunit b where instr(a.orgids,b.id) >0 and a.id='"+userid+"' and a.hrstatus='4028804c16acfbc00116ccba13802935' and NVL(a.extselectitemfield14,'0')!='40288098276fc2120127704884290210' and NVL(a.extdatefield4,'0')='0'";
String curusersql = "select distinct to_char(sysdate,'YYYY-MM-DD') today,a.id,a.objno,a.objname,a.orgid,a.mainstation,a.orgids,a.station,a.extrefobjfield5 comtype,a.extmrefobjfield9 company,a.extmrefobjfield8 onedept,a.extmrefobjfield7 twodept,a.seclevel,a.extselectitemfield14 isleave,a.hrstatus,a.extdatefield4 leavedate from humres a where a.id='"+userid+"' and a.hrstatus='4028804c16acfbc00116ccba13802935' and NVL(a.extselectitemfield14,'0')!='40288098276fc2120127704884290210' and NVL(a.extdatefield4,'0')='0'";
List list = baseJdbcDao.executeSqlForList(curusersql);
if ( list.size() > 0 ) {		  
  try {
  /*
  	for ( int i=0;i<list.size();i++  ) {	  
		Map map = (Map)list.get(i);
		if (i==0) {
			today = StringHelper.null2String(map.get("today"));
			jobno = StringHelper.null2String(map.get("objno"));
			curruserno = jobno;
			jobname = StringHelper.null2String(map.get("objname"));
			currusername = jobname;
			orgid = StringHelper.null2String(map.get("orgid"));
			mainstation = StringHelper.null2String(map.get("mainstation"));
			orgids = StringHelper.null2String(map.get("orgids"));
			station = StringHelper.null2String(map.get("station"));
			
			comtype = StringHelper.null2String(map.get("comtype"));
			company = StringHelper.null2String(map.get("company"));
			onedept = StringHelper.null2String(map.get("onedept"));
			twodept = StringHelper.null2String(map.get("twodept"));
			seclevel = StringHelper.null2String(map.get("seclevel"));
			
			isleave = StringHelper.null2String(map.get("isleave"));
			hrstatus = StringHelper.null2String(map.get("hrstatus"));
			leavedate = StringHelper.null2String(map.get("leavedate"));
		} 
		Map<String, String> deptmap = new HashMap<String, String>();	
		String deptid = StringHelper.null2String(map.get("deptid"));
		String deptname = StringHelper.null2String(map.get("deptname"));
		deptmap.put("deptid", deptid);//部门id
		deptmap.put("deptname", deptname);//部门名称
		jsonArrDept.add(deptmap);			  
	}
  */
	Map map = (Map)list.get(0);	
	today = StringHelper.null2String(map.get("today"));
	jobno = StringHelper.null2String(map.get("objno"));
	curruserno = jobno;
	jobname = StringHelper.null2String(map.get("objname"));
	currusername = jobname;
	orgid = StringHelper.null2String(map.get("orgid"));
	mainstation = StringHelper.null2String(map.get("mainstation"));
	orgids = StringHelper.null2String(map.get("orgids"));
	station = StringHelper.null2String(map.get("station"));
	
	comtype = StringHelper.null2String(map.get("comtype"));
	company = StringHelper.null2String(map.get("company"));
	onedept = StringHelper.null2String(map.get("onedept"));
	twodept = StringHelper.null2String(map.get("twodept"));
	seclevel = StringHelper.null2String(map.get("seclevel"));
	
	isleave = StringHelper.null2String(map.get("isleave"));
	hrstatus = StringHelper.null2String(map.get("hrstatus"));
	leavedate = StringHelper.null2String(map.get("leavedate"));	
	

	//if ( !mainstation.equals(station) ) { //解决部分兼岗助理 兼岗为多个，但orgids字段只有1个的问题
	String deptsql = "select distinct b.id deptid,b.objname deptname from STATIONINFO a,orgunit b where a.orgid=b.id and b.isdelete=0 and instr('"+station+"',  a.id)>0 ";
	//System.out.println(" deptsql=" +deptsql);
	List deptlist = baseJdbcDao.executeSqlForList(deptsql);
	if ( deptlist.size() > 0 ) {	
		for ( int i=0;i<deptlist.size();i++  ) {	  
			map = (Map)deptlist.get(i);
			Map<String, String> deptmap = new HashMap<String, String>();	
			String deptid = StringHelper.null2String(map.get("deptid"));
			String deptname = StringHelper.null2String(map.get("deptname"));
			deptmap.put("deptid", deptid);//部门id
			deptmap.put("deptname", deptname);//部门名称
			jsonArrDept.add(deptmap);
		}
	}
	//}
  } catch (Exception e) {
	 // TODO Auto-generated catch block
	 e.printStackTrace();
	 System.out.println("OTLeaveReportView.jsp error！");
  }
}	


//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a8d58b965900158bd3b0060164f' or roleid='40285a8d587f8d6b01587f9332620005')) "));
//or id='40285a9049ade1710149adea9ef20caf'"));
//System.out.println(userid+" " +curjobno +" "+cursapid + " "+ existflag);

//指定人员 
//总经理室 李莉	40285a9049ade1710149ade91c5d07a7  丁燕	40285a9057b8cb7e0157bd3618c005ae  陈厚福 	40285a904ee36b81014ee6b0014a2f99 当前部门 402864d249796b880149796d21f600c9
//人事 夏烨江	40285a9049ade1710149ade86f060561  邵建	40285a9049ade1710149ade9664a089f	 殷燕	40285a9049ade1710149ade81adc0449	  黄心怡 297e55a649c703900149c70949270051
//sysadmin		402881e70be6d209010be75668750014  徐晓亚 40285a9049ade1710149ade95e110883	 吴羽佳	40285a9049ade1710149adeaf0880dbf		全厂均可查询
//其他人员，设置了兼岗的部门，可以查看所有兼岗部门的人员考勤；未设兼岗的，只能查看所属部门的人员考勤

//int existflag = 1;


%>
 
<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<form method="post" id="myForm">
		<input type="hidden" id="url" name="url" value=""/>	
	</form>  

	<div>
		<div align="center"><SPAN class="STYLE10">部门加班/请假查询</SPAN></div>
	</div>

	<table width="100%%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td><SPAN class="STYLE4">当前登录人</SPAN></td>
			<td><SPAN class="STYLE3"><input type="hidden" value=<%=userid %> id="curruserid" name="curruserid" /><SPAN id="currusername"><%=currusername %></SPAN> <SPAN id="curruserno"> <%=curruserno %></SPAN><input type="hidden" value=<%=isHRRole %> id="ishrRoleid" name="ishrRoleid" /></SPAN></td>
			<td><SPAN class="STYLE4">部门</SPAN></td>
			<td><SPAN class="STYLE3"><input type="hidden" value=<%=orgids %> id="allorgid" name="allorgid" />
			<select type="text" id="deptid" name="deptid" value="<%=orgid %>">
			<option value="all">不限</option>
			<% 
				if( jsonArrDept.size() >0 ) {
					for( int k=0;k<jsonArrDept.size(); k++ ) {
						Map m = (Map)jsonArrDept.get(k);
						String opdeptid = StringHelper.null2String(m.get("deptid"));
						String opdeptname = StringHelper.null2String(m.get("deptname"));
						
			%>			
			<option value="<%=opdeptid %>" <% if(opdeptid.equals(orgid) ){ %>selected<% } %>  ><%=opdeptname %></option>			
			<%
					}
				}
			%>
			</select><input type="checkbox" id="isroot" name="isroot" value="0"  onclick="checkroot(this)"></SPAN></td>
			<td><SPAN class="STYLE4">考勤类型</SPAN></td>
			<td><SPAN class="STYLE3"><select type="text" id="kqtype" name="kqtype" value="0">
			<option value="0" selected >不限</option>
			<option value="1">加班</option><option value="2">请假</option>
			</select></SPAN></td>
			<td><SPAN class="STYLE4">当前日期</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value="<%=today %>" id="currdate" name="currdate" /></td>
		</tr>	
		<tr>
			<td><SPAN class="STYLE4">人员类型</SPAN></td>
			<td><SPAN class="STYLE3"><select type="text" id="psntype" name="psntype" value="0" onchange="chgpsntype();" >
			<option value="0" selected >仅自己</option><option value="1">部门所有人</option>
			<%
				if( "40285a9049ade1710149ade91c5d07a7".equals(userid) ||  "40285a9057b8cb7e0157bd3618c005ae".equals(userid) ||  "40285a904ee36b81014ee6b0014a2f99".equals(userid) ||  "40285a9049ade1710149ade86f060561".equals(userid) ||  "40285a9049ade1710149ade9664a089f".equals(userid) ||  "40285a9049ade1710149ade81adc0449".equals(userid)  ||  "297e55a649c703900149c70949270051".equals(userid) ||  "402881e70be6d209010be75668750014".equals(userid) ||  "40285a9049ade1710149ade95e110883".equals(userid) ||  "40285a9049ade1710149adeaf0880dbf".equals(userid)) {	
				//指定人员 
				//总经理室 李莉	40285a9049ade1710149ade91c5d07a7  丁燕	40285a9057b8cb7e0157bd3618c005ae  陈厚福 	40285a904ee36b81014ee6b0014a2f99 当前部门 402864d249796b880149796d21f600c9
				//人事 夏烨江	40285a9049ade1710149ade86f060561  邵建	40285a9049ade1710149ade9664a089f	 殷燕	40285a9049ade1710149ade81adc0449	  黄心怡 297e55a649c703900149c70949270051	
				//sysadmin		402881e70be6d209010be75668750014  徐晓亚 40285a9049ade1710149ade95e110883	 吴羽佳	40285a9049ade1710149adeaf0880dbf		全厂均可查询
			%>
				<option value="2">全厂主管</option>
			<%
				}
				if ( "1".equals(isHRRole) ) {
			%>				
				<option value="3">常熟厂全部人员</option>
				<option value="4">长沙厂全部人员</option>
			<%
				}
				if ( "1".equals(isPJHRRole) ) {
			%>				
				<option value="5">盘锦厂全部人员</option>
			<%
				}
				
			%>
			</select></SPAN></td>
			<td><SPAN class="STYLE4">日期范围</SPAN></td>
			<td><SPAN class="STYLE3"><select type="text" id="daterange" name="daterange" value="0" onchange="chgdaterange();" >
			<option value="0" selected >仅今天</option><option value="1" >前后7天</option><option value="2">前7天</option>
			<option value="3">后7天</option><option value="4">本月</option><option value="5">上月</option><option value="6">下月</option><option value="7">指定期间(查询所有人:不可超过100天;查询单个人:不可超过366天)</option>
			</select></SPAN></td>	
			<td><SPAN class="STYLE4">工号姓名模糊/精确查询</SPAN></td>
			<td><SPAN class="STYLE3"><select type="text" id="searchtype" name="searchtype" value="1" >
			<option value="0" >模糊查询</option><option value="1" selected >精确查询</option>
			</select></SPAN></td>
		</tr>
		<tr>
			<td><SPAN class="STYLE4">员工工号</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value=<%=jobno %> id="jobno" name="jobno" /></SPAN></td>
			<td><SPAN class="STYLE4">员工姓名</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value=<%=jobname %> id="jobname" name="jobname" /></SPAN></td>
			<td><SPAN class="STYLE4">查询日期起(YYYY-MM-DD)</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value="<%=today %>" id="startdate" name="startdate" /></td>
			<td><SPAN class="STYLE4">查询日期止(YYYY-MM-DD)</SPAN></td>
			<td><SPAN class="STYLE3"><input style="width:100px" type="text" value="<%=today %>" id="enddate" name="enddate" /></td>
		</tr>		
		<tr>
			<td><SPAN class="STYLE3"><input id="searchbutid" type="button" name="radiobutton2" value="查询" onclick="searchDetails();" /></SPAN></td>
			<td colspan=7><SPAN class="STYLE3"><input type="button" name="radiobutton2" value="新建加班申请" onclick="newflow('40285a8f489c17ce014908333b744907','新建加班申请');" /><input type="button" name="radiobutton2" value="新建请假申请" onclick="newflow('40285a904931f62b014936e72ccb2718','新建请假申请');" /></SPAN></td>	
		</tr>
		<tr>
			<td colspan="8"><SPAN class="STYLE4">查询信息:</SPAN></td>
		</tr>
		<tr>
			<td colspan="8"><SPAN class="STYLE3" id="searchinfo"></SPAN></td>
			
		</tr>	
	</table>
	
	<div id="detailinfoid">
	</div>

	</body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
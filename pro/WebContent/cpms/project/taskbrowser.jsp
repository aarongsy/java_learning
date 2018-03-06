<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.cpms.project.task.*" %>
<%
String objid=StringHelper.null2String(request.getParameter("objid"));
String projectid = request.getParameter("projectid");
String tasktempid = request.getParameter("tasktempid");
String sql = "select * from cpms_task where projectid='"+projectid+"' order by wbs";
if(!StringHelper.isEmpty(tasktempid)){
	sql = "select id as requestid,wbscode as wbs,t.* from cpms_tasktemplate t where tempid='"+tasktempid+"' order by wbscode";
}
DataService dataService = new DataService();
List list = dataService.getValues(sql);
%>
<html>
<head>

<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript">
Ext.onReady(function(){
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'返回','R','arrow_undo',function(){window.close();});
});
function $(id){
	return document.getElementById(id);
}
//选中一个任务后，返回到前置任务创建页面
function clickTask(id,name){
	var array = new Array();
	array.push(id);
	array.push(name);
	window.returnValue=array;
	window.close();
}
</script>
</head>
<body style="margin:0px;padding:0px">
<div id="pagemenubar"></div>
<div id="wbsdiv" style="padding: 5 10 5 10;width:100%">
<table id="treetable" border=1>
	<tr class="header">
		<td width="50px">wbs</td>
		<td width="85%">任务名称</td>
	</tr>
	<%
	for(int i=0;i<list.size();i++){
		Map task =(Map)list.get(i);
		String taskid = (String)task.get("requestid");
	%>
	<tr>
		<td width="50px"><%=StringHelper.null2String(task.get("wbs"))%></td>
		<td width="85%"><a href="javascript:clickTask('<%=task.get("requestid")%>','<%=StringHelper.null2String(task.get("objname"))%>');"><%=StringHelper.null2String(task.get("objname"))%></a></td>
	</tr>
	<%}%>
</table>
</div>
</body>
</html>
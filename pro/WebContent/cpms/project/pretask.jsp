<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.cpms.project.flow.*" %>
<%@ page import="com.eweaver.cpms.project.pretask.*" %>
<%@ page import="com.eweaver.cpms.project.wbstemplate.*" %>
<%
String id = StringHelper.null2String(request.getParameter("id"));
String objid = StringHelper.null2String(request.getParameter("objid"));//任务对象id
String projectid = StringHelper.null2String(request.getParameter("projectid"));
String tasktempid = StringHelper.null2String(request.getParameter("tasktempid"));
DataService dataService = new DataService();
PreTaskService preTaskService = (PreTaskService) BaseContext.getBean("preTaskService"); 
PreTask preTask = preTaskService.getPreTask(id);
String preTaskName = ""; 
if(!StringHelper.isEmpty(preTask.getPretaskid())){
	String sql = "select objname from cpms_task where requestid='"+preTask.getPretaskid()+"'";
	if(!StringHelper.isEmpty(tasktempid)){
		sql = "select objname from cpms_tasktemplate where id='"+preTask.getPretaskid()+"'";
	}
	preTaskName=dataService.getSQLValue(sql);
}
%>
<html>
<head>
<script  type='text/javascript' src='/js/workflow.js'></script>

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var tb1 = new Ext.Toolbar();
	tb1.render('pagemenubar');
	addBtn(tb1,'保存','S','disk',function(){onSave();});
	addBtn(tb1,'关闭','C','delete',function(){top.frames[1].commonDialog.hide();});
});
</script>
</head>
<body style="margin:0px;padding:0px;overflow: hidden">
<div id="pagemenubar"></div>
<form id="EweaverForm" name="EweaverForm" action="/ServiceAction/com.eweaver.cpms.project.pretask.PreTaskAction?action=save" method="post">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="objid" value="<%=objid%>">
<input type="hidden" name="projectid" value="<%=projectid%>">
<input type="hidden" name="tasktempid" value="<%=tasktempid%>">
<table width="90%" id="tab1" border=1>
<tr>
	<td class="fieldName" width="15%" align="right">前置任务</td>
	<td class="fieldValue" width="85%">
		<button type=button class=Browser name="button_pretaskid" onclick="javascript:getPreTask('<%=projectid %>','<%=tasktempid %>');"></button>
		<input type="hidden" name="pretaskid" value="<%=StringHelper.null2String(preTask.getPretaskid())%>"  style="width: 80%"  >
		<span id="pretaskidspan" name="pretaskidspan" ><%=preTaskName%><%if(StringHelper.isEmpty(preTaskName)){%><img src="/images/base/checkinput.gif"><%}%></span>
	</td>
</tr>
<tr>
	<td class="fieldName" align="right">前置类型</td>
	<td class="fieldValue">
		<select id="objtype" name="objtype">
		<option value="F-S" <%if("F-S".equals(preTask.getObjtype())){ %>selected<%} %>>完成-开始(F-S)</option>
		<option value="F-F" <%if("F-F".equals(preTask.getObjtype())){ %>selected<%} %>>完成-完成(F-F)</option>
		<option value="S-F" <%if("S-F".equals(preTask.getObjtype())){ %>selected<%} %>>开始-完成(S-F)</option>
		<option value="S-S" <%if("S-S".equals(preTask.getObjtype())){ %>selected<%} %>>开始-开始(S-S)</option>
		</select>
	</td>
</tr>
<tr>
	<td class="fieldName" align="right">延迟</td>
	<td class="fieldValue"><input type="text" name="lag" id="lag" onblur="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','延迟')"  
		onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','延迟');" value="<%=NumberHelper.string2Double(preTask.getLag(),0d)%>"/>(天)</td>
</tr>
<tr>
	<td class="fieldName" align="right">备注</td>
	<td class="fieldValue">
		<TEXTAREA name="desc" id="desc" style="width: 100%;"><%=StringHelper.null2String(preTask.getDescription()) %></TEXTAREA>
	</td>
</tr>
</table>
</form>
</body>
<script language="javascript">
function onSave(id){
	if(document.getElementById('pretaskid').value){
		document.EweaverForm.submit();
	}else{
		alert('前置任务未选择');
	}
}

//获取前置任务
function getPreTask(projectid,tasktempid){
	var url='/base/popupmain.jsp?url=/cpms/project/taskbrowser.jsp?projectid='+projectid+'&tasktempid='+tasktempid;
	var value = openDialog(url);
	if(value){
		document.all("pretaskid").value=value[0];
		document.all("pretaskidspan").innerHTML=value[1];
	}
}
</script>
</html>
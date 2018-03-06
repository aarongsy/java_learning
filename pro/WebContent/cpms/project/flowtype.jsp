<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.cpms.project.flow.*" %>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.workflow.workflow.model.*" %>
<%

FlowService flowService = (FlowService) BaseContext.getBean("flowService"); 
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService"); 

String id = StringHelper.null2String(request.getParameter("id"));
String taskid = StringHelper.null2String(request.getParameter("taskid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));
String tasktempid = StringHelper.null2String(request.getParameter("tasktempid"));
Flowlink flowlink = flowService.getFlowlinkById(id);
if(null == flowlink)flowlink = new Flowlink();

String workflowinfoname = workflowinfoService.getWorkflowName(StringHelper.null2String(flowlink.getWorkflowid()));
%>
<html>
<head>
<script  type='text/javascript' src='/js/workflow.js'></script>

<script type="text/javascript" src="/js/ext/examples/grid/RowExpander.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="/cpms/scripts/base.js"></script>
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
<form id="EweaverForm" name="EweaverForm" action="/ServiceAction/com.eweaver.cpms.project.flow.FlowAction?action=addFlow" method="post">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="taskid" value="<%=taskid%>">
<input type="hidden" name="projectid" value="<%=projectid%>">
<input type="hidden" name="templateid" value="<%=tasktempid%>">
<table width="90%" id="tab1" border=1>
<tr>
<td class="fieldName" width="15%" align="right">流程类别</td>
<td class="fieldValue"  width="85%"><button type=button class=Browser name="button_workflow" 
	onclick="javascript:getrefobj('workflowid','workflowidspan','402880371d60e90c011d6107be5c0008','','','0');"></button>
	<input type="hidden" name="workflowid" value="<%=StringHelper.null2String(flowlink.getWorkflowid()) %>"  style="width: 80%"  >
	<span id="workflowidspan" name="workflowidspan" ><%=StringHelper.null2String(workflowinfoname) %><%if(StringHelper.isEmpty(workflowinfoname)){%><img src="/images/base/checkinput.gif"><%}%></span>
</td>
</tr>
<tr>
<td class="fieldName"  width="15%" align="right">是否必须</td>
<td class="fieldName"  width="85%">
<input type="checkbox" name="isnecessary" id="isnecessary" value="1" 
<%if("1".equals(StringHelper.null2String(flowlink.getIsnecessary()))){ %>checked<%} %>>
</td>
</tr>
<tr>
<td class="fieldName" align="right">备注</td>
<td class="fieldName">
<TEXTAREA name="desc" id="desc" style="width: 100%;"><%=StringHelper.null2String(flowlink.getDescription()) %></TEXTAREA></td>
</tr>
</table>
</form>
</body>
<script language="javascript">
function onSave(id){
	if(document.getElementById('workflowid').value){
		document.EweaverForm.submit();
	}else{
		alert('未选择流程类别');
	}
}
</script>
</html>
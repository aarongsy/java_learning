<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.cpms.project.doc.*" %>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.base.category.service.*" %>
<%
DocService docService = (DocService) BaseContext.getBean("docService"); 
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService"); 
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
//System.out.println(categoryid);
String id = StringHelper.null2String(request.getParameter("id"));
String taskid = StringHelper.null2String(request.getParameter("taskid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));
String templateid = StringHelper.null2String(request.getParameter("tasktempid"));
DoctypeLink doctypeLink = docService.getDoctypeLink(id);
if(null == doctypeLink)	doctypeLink = new DoctypeLink();
String categoryname = categoryService.getCategoryNameStrByCategory(StringHelper.null2String(doctypeLink.getDoctypeid()));
String workflowinfoname = workflowinfoService.getWorkflowName(StringHelper.null2String(doctypeLink.getWorkflowid()));
%>
<html>
<head>
<script type='text/javascript' src='/js/workflow.js'></script>

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
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
<body style="margin:0px;padding:0px;overflow: hidden;">
<div id="pagemenubar"></div>
<form id="EweaverForm" name="EweaverForm" action="/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=addDoctype" method="post">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="taskid" value="<%=taskid%>">
<input type="hidden" name=templateid value="<%=templateid%>">
<input type="hidden" name="projectid" value="<%=projectid%>">
<table width="90%"  border=1>
<tr>
	<td class="fieldName" width="15%" align="right">文档分类</td>
	<td class="fieldValue" width="85%"><button type=button class=Browser name="button_doctype" 
		onclick="javascript:getrefobj('doctype','doctypespan','4028819b124662b301125662b73603e7','','','0');">
		</button><input type="hidden" name="doctype" value="<%=StringHelper.null2String(doctypeLink.getDoctypeid()) %>"><span id="doctypespan" name="doctypespan" >
		<%=StringHelper.null2String(categoryname)%><%if(StringHelper.isEmpty(categoryname)){%><img src="/images/base/checkinput.gif"><%}%></span>
	</td>
</tr>
<tr>
	<td class="fieldName" align="right">审核流程</td>
	<td class="fieldValue"><button type=button class=Browser name="button_workflow" 
		onclick="javascript:getrefobj('workflowid','workflowidspan','402880371d60e90c011d6107be5c0008','','','0');"></button>
		<input type="hidden" name="workflowid" value="<%=StringHelper.null2String(doctypeLink.getWorkflowid()) %>"  style="width: 80%"  >
		<span id="workflowidspan" name="workflowidspan" ><%=StringHelper.null2String(workflowinfoname) %></span>
	</td>
</tr>
<tr>
	<td class="fieldName" align="right">是否必须</td>
	<td class="fieldValue">
		<input type="checkbox" name="isnecessary" id="isnecessary" value="1" 
		<%if("1".equals(StringHelper.null2String(doctypeLink.getIsnecessary()))){ %>checked<%} %>>
	</td>
</tr>
<tr>
	<td class="fieldName" align="right">备 注</td>
	<td class="fieldValue">
		<TEXTAREA name="desc" id="desc" style="width: 100%;"><%=StringHelper.null2String(doctypeLink.getDescription()) %></TEXTAREA>
	</td>
</tr>
</table>
</form>
</body>
<script language="javascript">
function onSave(){
	if(document.getElementById('doctype').value){
		document.EweaverForm.submit();
	}else{
		alert('未选择文档分类');
	}
}
</script>
</html>
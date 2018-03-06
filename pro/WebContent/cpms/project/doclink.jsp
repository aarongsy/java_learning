<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%@ page import="com.eweaver.cpms.project.doc.*" %>
<%@ page import="com.eweaver.base.category.service.*" %>
<%@ page import="com.eweaver.base.category.model.*" %>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.workflow.workflow.model.*" %>
<%@ page import="com.eweaver.document.base.service.*" %>
<%
String id = StringHelper.null2String(request.getParameter("id"));//doclinkid
String taskid = StringHelper.null2String(request.getParameter("taskid"));
String tasktempid = StringHelper.null2String(request.getParameter("tasktempid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));

DocService docService = (DocService) BaseContext.getBean("docService"); 
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService"); 

Doclink doclink = docService.getDoclink(id);
if(doclink==null)	doclink = new Doclink();
String docname = docbaseService.getSubjectByDoc(StringHelper.null2String(doclink.getDocid()));

%>
<html>
<head>

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/cpms/scripts/base.js"></script>
<script type="text/javascript"> 
Ext.onReady(function() {
    Ext.QuickTips.init();
    var tb = new Ext.Toolbar();
    tb.render('pagemenubar');
	addBtn(tb,'保存','S','disk',function(){javascript:onSave()});
	addBtn(tb,'关闭','C','delete',function(){top.frames[1].commonDialog.hide();});
});
</script>
</head>
<body style="margin:0px;padding:0px;overflow: hidden">
<div id="pagemenubar"></div>
<form id="EweaverForm" name="EweaverForm" action="/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=saveDoc" method="post">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="taskid" value="<%=taskid%>">
<input type="hidden" name="tasktempid" value="<%=tasktempid%>">
<input type="hidden" name="projectid" value="<%=projectid%>">
<table width="90%" id="tab1" border=1>
	<COLGROUP>
		<COL width="15%">
		<COL width="85%">
	</COLGROUP>
	<tr>
		<td class="fieldName" align="right">文档</td>
	<td class="fieldValue"><button type=button class=Browser name="button_doc" onclick="javascript:getrefobj('docid','docspan','402881e70bc70ed1010bc710b74b000d','','','1');"></button>
		<input type="hidden" name="docid" value="<%=StringHelper.null2String(doclink.getDocid()) %>" >
		<span id="docspan" name="docspan" ><%=docname%><%if(StringHelper.isEmpty(docname)){%><img src="/images/base/checkinput.gif"><%}%></span></td>
	</tr>
	<tr>
		<td class="fieldName" align="right">备注</td>
	<td class="fieldValue">
		<TEXTAREA class="InputStyle2" name="desc" id="desc" style="width: 100%;"><%=StringHelper.null2String(doclink.getDescription()) %></TEXTAREA></td>
	</tr>
</table>
</form>
</body>
<script language="javascript">
function onSave(id){
	if(document.getElementById('docid').value){
		document.EweaverForm.submit();
	}else{
		alert('未选择文档');
	}
}
</script>
</html>
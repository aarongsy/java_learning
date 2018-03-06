<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.document.base.model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String docid = StringHelper.null2String(request.getParameter("docid"));
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
Docbase docbase = docbaseService.getDocbase(docid);
String creator = docbase.getCreator();
String docobjno="";
if (!StringHelper.isEmpty(docbase.getObjno())){
	docobjno=docbase.getObjno();
}
SetitemService setitemService =  (SetitemService) BaseContext.getBean("setitemService");
String borrowflowid = setitemService.getBorrowWorkflowId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<div style="margin-left: 5px;margin-top: 5px;">
	<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980028")%>：<br/><br/><!-- 对不起，您无权查看此文档，是否借阅 -->
	<INPUT TYPE="button" NAME="jieyue" value="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980029")%>" onclick = "getworkflow()">&nbsp;<!--借阅  -->
	<INPUT TYPE="button" NAME="nojieyue" value="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98002a")%>" onclick="javascript:closeCurrentTab();"><!-- 不借阅 -->
</div>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
//<!--
function getworkflow(){
	window.location.href="<%=request.getContextPath()%>/workflow/request/workflow.jsp?projectname=&workflowid=<%=borrowflowid%>&docid=<%=docid%>&targeturl=&creator=<%=creator%>";
}

function closeCurrentTab(){
	var tabpanel=top.frames[1].contentPanel;
	tabpanel.remove(tabpanel.getActiveTab());
}
//-->
</SCRIPT>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ include file="/base/init.jsp"%>
<%
WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");

String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
String jsCode = workflowinfoService.getJSCode(workflowid);
%>
<html>
<head>
<style>
#jscode{
	width: 100%;
	height: 400px;
	overflow: auto;
}
</style>
</head>
<body>
<form action="" name="EweaverForm" method="post">
<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid %>"/>
<button type="button" id="btnSubmit" class='btn' accesskey="S" onclick="doSaveJSCode()">
	<u>S</u>--<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")%><!-- 保存 -->
</button>
<textarea name="jsCode" id="jsCode"><%=jsCode %></textarea>
</form>
</body>
</html>
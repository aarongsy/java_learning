<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.subprocess.service.SubprocesssetService" %>
<%@ page import="com.eweaver.workflow.subprocess.model.Subprocessset" %>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%@ page import="com.eweaver.base.msg.EweaverMessage" %>
<%@ page import="com.app.fangtian.ContractSubmit"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<%
	String requestid = request.getParameter("requestid");
	if(!"".equals(requestid)){	
		ContractSubmit cation = new ContractSubmit();
		cation.sycContract(requestid);
	}
	
   	
%>
  <head>
  
  </head>
  <body>
  
  </body>
</html>
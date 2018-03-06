<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%
String sqlwhere = StringHelper.null2String(request.getParameter("sqlwhere"));
String reportwhere = StringHelper.null2String(request.getParameter("reportwhere"));
String idsin=StringHelper.null2String(request.getParameter("idsin"));
String refid=StringHelper.null2String(request.getParameter("refid"));
String keyfield=StringHelper.null2String(request.getParameter("keyfield"));
String showfield=StringHelper.null2String(request.getParameter("showfield"));
String activeTab = StringHelper.null2String(request.getParameter("activeTab"));

if(!"".equals(reportwhere)){
	reportwhere = "&reportwhere="+reportwhere;
}
if(keyfield.equals(""))		keyfield="id";
if(showfield.equals(""))	showfield="objname";
if(!StringHelper.isEmpty(sqlwhere)){
	sqlwhere=java.net.URLEncoder.encode(sqlwhere);
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browserm=1&reportid=4028801111bdd00d0111bdd73e060006&activeTab="+activeTab+"&sqlwhere="+sqlwhere+reportwhere+"&idsin="+idsin+"&refid="+refid+"&showfield="+showfield+"&keyfield="+keyfield);
}else{
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browserm=1&reportid=4028801111bdd00d0111bdd73e060006&activeTab="+activeTab+reportwhere+"&idsin="+idsin+"&refid="+refid+"&showfield="+showfield+"&keyfield="+keyfield);
}

%>

<html>
  <head>
  </head>
  <body>
  </body>
</html>

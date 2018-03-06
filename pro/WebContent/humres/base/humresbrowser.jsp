<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%
String sqlwhere = StringHelper.null2String(request.getParameter("sqlwhere"));
String reportwhere = StringHelper.null2String(request.getParameter("reportwhere"));
String activeTab = StringHelper.null2String(request.getParameter("activeTab"));
String keyfield=StringHelper.null2String(request.getParameter("keyfield"));
String showfield=StringHelper.null2String(request.getParameter("showfield"));

if(!"".equals(reportwhere)){
    reportwhere = "&reportwhere="+reportwhere;
}

if(!StringHelper.isEmpty(sqlwhere)){
	sqlwhere=java.net.URLEncoder.encode(sqlwhere);
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&reportid=4028801111bdd00d0111bdd73e060006&activeTab="+activeTab+"&sqlwhere="+sqlwhere+reportwhere+"&keyfield="+keyfield+"&showfield="+showfield);
}else{
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&reportid=4028801111bdd00d0111bdd73e060006&activeTab="+activeTab+""+reportwhere+"&keyfield="+keyfield+"&showfield="+showfield);
}

%>

<html>
  <head>
  </head>
  <body>
  </body>
</html>

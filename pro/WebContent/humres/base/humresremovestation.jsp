<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%
String stationid = StringHelper.null2String(request.getParameter("stationid"));
String orgid = StringHelper.null2String(request.getParameter("orgid"));
String sqlwhere=" exists (select h.oid from Orgunitlink h "
			//TODO ===========================================================
			//+"where tbalias.orgids like '%'+ h.oid+ '%'  "
			//+"and h.col1 like '%"+orgid+"%' "
			+"where h.col1 like '%"+orgid+"%'  "
			//================================================================
			+"and tbalias.station like '%"+stationid+"%') and tbalias.mainstation <>'"+stationid+"'";
sqlwhere=java.net.URLEncoder.encode(sqlwhere);
String url=BaseContext.getContextpath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&reportid=4028801111bdd00d0111bdd73e060006&sqlwhere="+sqlwhere;
response.sendRedirect(url);
%>
<html> 
  <head>
  </head>
  <body>
  </body>
</html>

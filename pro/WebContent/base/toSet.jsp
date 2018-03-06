<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%
String soureid=StringHelper.null2String(request.getParameter("soureid"));
String souretype=StringHelper.null2String(request.getParameter("souretype"));
String tourl="";
if(souretype.equals("report"))
	tourl="/workflow/report/reportmodify.jsp?id="+soureid;
else if(souretype.equals("category"))
	tourl="/base/category/categorymodify.jsp?id="+soureid;	
else if(souretype.equals("workflow"))
	tourl="/workflow/workflow/workflowinfomodify.jsp?id="+soureid;	
else if(souretype.equals("workflowgraph"))
	tourl="/wfdesigner/editors/grapheditor.jsp?workflowid="+soureid;
response.sendRedirect(tourl);	
%>
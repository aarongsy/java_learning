
<%@page import="com.eweaver.base.util.StringHelper"%>
<%
String width=StringHelper.null2String(request.getParameter("width"));
String height=StringHelper.null2String(request.getParameter("height"));
String workflowid=StringHelper.null2String(request.getParameter("workflowid"));
%>
<iframe src="versionactivepolicylist.jsp?workflowid=<%=workflowid%>" width="<%=width%>" height="<%=height%>" scrolling="no"></iframe>
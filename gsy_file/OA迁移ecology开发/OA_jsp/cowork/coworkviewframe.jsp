<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.util.*" %>
<%
String isall=StringHelper.null2String(request.getParameter("isall"));
String categoryid=StringHelper.null2String(request.getParameter("categoryid"));//"402880311c4f0f04011c4f108ee10002";
%>
<frameset cols="30%,70%" name="frameBottom" id="frameBottom" style="cursor:col-resize" border="0">

<frame src="coworklist.jsp?categoryid=<%=categoryid%>&isall=<%=isall%>" name="frameLeft" id="frameLeft" scrolling="yes">
<frame src="frameRight.jsp" name="frameRight" id="frameRight" scrolling="no" style="border-left:2px solid #ccc">

</frameset>

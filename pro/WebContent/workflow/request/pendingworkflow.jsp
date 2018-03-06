<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String model = StringHelper.trimToNull(request.getParameter("model"));
String tagetUrl = StringHelper.trimToNull(request.getParameter("tagetUrl"));
%>
<html>
  <head>
  </head> 
<frameset cols="280,*" frameborder="no" border="0" framespacing="0">
  <frame src="workflowtypeview.jsp" name="workflowtypeleftframe" scrolling="auto">
  <frame name="workflowtypemainframe">
</frameset>
<noframes><body><%=labelService.getLabelName("402881eb0bd6394d010bd653340c0002")%>
</body></noframes>
</html>


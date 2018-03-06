<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String menutype = StringHelper.trimToNull(request.getParameter("menutype"));
if(menutype==null)menutype = "1";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  </head> 
<frameset cols="280,*" frameborder="no" border="0" framespacing="0">
  <frame src="menumanager.jsp?menutype=<%=menutype%>" name="menuleftframe" scrolling="auto">
  <frame  name="menumainframe">
</frameset>
<noframes><body> <%=labelService.getLabelName("402881eb0bd6394d010bd653340c0002")%>
</body></noframes>
</html>


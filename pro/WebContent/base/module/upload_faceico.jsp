<%@ page import="com.eweaver.base.util.StringHelper" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-12-23
  Time: 16:48:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title>Simple jsp page</title></head>
  <body>
  <%
    String path = StringHelper.null2String(request.getParameter("path"));
  %>
  <input type="text" id="pathtext" value="<%=path%>"/>
  </body>
</html>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2009-1-6
  Time: 14:24:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title>Simple jsp page</title></head>
  <%
      String attachid = StringHelper.null2String(request.getParameter("attachid"));
  %>
  <body>
  <input type="hidden" id="attachid" name="attachid" value="<%=attachid%>"/>
  </body>
</html>
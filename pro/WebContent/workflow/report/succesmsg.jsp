<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-8-21
  Time: 15:37:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003d")%></title><!-- 操作成功! -->
  </head>
  <%
      String msg= (String) request.getAttribute("msg");
  %>
  <body>
    <table align="center">
        <tr>
            <td align="center" style="font-size:14px">&nbsp;</td>
        </tr>
        <tr>
            <td align="center" style="font-size:14px">&nbsp;</td>
        </tr>         
        <tr>
            <td align="center" style="font-size:14px"><%=msg%></td>
        </tr>
    </table>
  </body>
</html>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2009-1-5
  Time: 15:56:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title>Simple jsp page</title>
  <%
        String msg = StringHelper.null2String(request.getParameter("message"));
  		String docTemplateType = StringHelper.null2String(request.getParameter("docTemplateType"));
        String message = "";
        if(msg.equals("0") && "3".equals(docTemplateType)){
        	message = labelService.getLabelNameByKeyId("402883bf3f22e21d013f22e222040241");//html模板已成功创建.
        }else if(msg.equals("0") && "4".equals(docTemplateType)){
            message = labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98002f");//word模板已成功创建.
        }else if(msg.equals("0") && "5".equals(docTemplateType)){
        	message = labelService.getLabelNameByKeyId("402883bf3f22e21d013f22e222040236");//excel模板已成功创建.
        }else if(msg.equals("1") && "3".equals(docTemplateType)){
        	message = labelService.getLabelNameByKeyId("402883bf3f22e21d013f22e222040288");//html模板已成功保存.
        }else if(msg.equals("1") && "4".equals(docTemplateType)){
        	message = labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98002e");//word模板已成功保存.
        }else if(msg.equals("1") && "5".equals(docTemplateType)){
        	message = labelService.getLabelNameByKeyId("402883bf3f22e21d013f22e22204028b");//excel模板已成功保存.
        }
  %>
  </head>
  <body>
  <table align="center">
      <tr>
          <td align="center" style="font-size:13">
              &nbsp;
          </td>
      </tr>      
      <tr>
          <td align="center" style="font-size:12">
              <span id="showmessage"><%=message%></span>.
          </td>
      </tr>
      <tr>
          <td align="center" style="font-size:13">
              &nbsp;
          </td>
      </tr>
  </table>
  </body>
</html>
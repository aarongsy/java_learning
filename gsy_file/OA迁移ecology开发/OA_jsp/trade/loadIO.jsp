<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String param1 = StringHelper.null2String(request.getParameter("param1"));//运入运出
String param2 = StringHelper.null2String(request.getParameter("param2"));//单据类型
String param3 = StringHelper.null2String(request.getParameter("param3"));//制单类型
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>-----------xxx----------</title>
    
  </head>
  
  <body>
    <IFRAME id=zgxx style="HEIGHT: 49.5%; WIDTH: 99%;" frameBorder=0 src="/app/trade/zgxx.jsp?requestid=<%=requestid%>&param1=<%=param1%>&param2=<%=param2%>&param3=<%=param3%>"></IFRAME> 
    <IFRAME id=zxmx style="HEIGHT: 49.5%; WIDTH: 99%;" frameBorder=0 src="/app/trade/zxmx.jsp"></IFRAME>
  </body>
</html>

<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<script>
		function getVal(){
			window.returnValue=document.getElementById("isTb").checked;
			window.close();
		}
	</script>
  </head>
  
  <body  style="padding-top:50px;">
  <center>
    <table>
		<tr>
			<td align="center">是否同步组织菜单：<input type="radio" name="isTb" id="isTb"></td>
		</tr>
		<tr>
			<td align="center"><input type="submit" value="确定" onclick="getVal();"></td>
		</tr>
	</table>
  </center>
  </body>
</html>

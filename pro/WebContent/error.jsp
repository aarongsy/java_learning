<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="java.util.*"%>
<%response.setStatus(200); %>
<% 
//Exception from JSP didn't log yet ,should log it here. 
String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri"); 
LogFactory.getLog(requestUri).error(exception.getMessage(), exception); 
%>
<html>
<head>
<title>出错页面</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
</head>
<body>

<h5><img alt="error" src="/images/base/icon_error.gif" align="absmiddle" /> 对不起！系统发生错误，请与系统管理员联系。</h5>
<a id = "detail" href="#" onclick="showDetail();">查看详细信息</a>
<hr size="1">
<div id="detail_error_msg" style="display:none" align=left>
	<pre><%exception.printStackTrace(new java.io.PrintWriter(out));%></pre>
</div>
<script language="javascript">
function showDetail(){
	if(detail_error_msg.style.display==''){
		detail_error_msg.style.display='none';
		detail.innerHTML="查看详细信息";
	}else{
		detail_error_msg.style.display='';
		detail.innerHTML="隐藏详细信息";
	}
}
</script>
</body>
</html>
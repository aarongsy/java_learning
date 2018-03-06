<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
DataService ds = new DataService();
String requestid = StringHelper.null2String(request.getParameter("requestid"));
CoWorkService cwService = new CoWorkService();
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Reply Page2</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
<style>
body{margin:0px; padding:0px;}
a{  
    cursor:pointer;  
    text-decoration:none;  
    hide-focus: expression(this.hideFocus=true);  
    outline:none;  
}  
a:link,a:visited,a:active{  
    text-decoration:none;  
    color: #000000;
}  
  
a:focus{  
    outline:0;   
}
		</style>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript">
jQuery(function(){
<%if(currentSysModeIsWebsite){%>
setIframeHeight_IsWebsite();
<%}else{%>
setIframeHeight_IsSoftware();
<%}%>
});
</script>
  </head>
  <body>
<TABLE class=layouttable border=1 id="table3">
<COLGROUP>
<COL width="10%">
<COL width="90%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue>参与者</TD>
<TD class=FieldName >
<%
Map<String,String> userids = cwService.getCoworkOperator(requestid,"5");
Set<String> set = userids.keySet();
int size=1;
for(String s:set){
	   %>
	   <a href="javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=s %>','<%=userids.get(s) %>','tab<%=s %>')"> <%=userids.get(s) %></a><%=size!=userids.size()?",":""%>
<% 
size++;
}
%>
</TD>
</TR>
<TR>
<TD class=FieldValue>关注着</TD>
<TD class=FieldName >
<%
userids = cwService.getCoworkOperator(requestid,"4");
set = userids.keySet();
size=1;
for(String s:set){
	   %>
	   <a href="javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=s %>','<%=userids.get(s) %>','tab<%=s %>')"> <%=userids.get(s) %></a><%=size!=userids.size()?",":""%>
<% 
size++;
}
%>
</TD>
</TR>
</TBODY>
</TABLE>
  </body>
</html>

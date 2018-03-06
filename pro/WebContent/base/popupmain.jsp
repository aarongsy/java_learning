<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@page import="com.eweaver.base.refobj.model.Refobj"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%
String url = StringHelper.null2String(request.getParameter("url"));
String popuptitle = StringHelper.getDecodeStr(request.getParameter("popuptitle"));
RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
Refobj refobj = null;
if(url.indexOf("?id=")>0&&url.length()>40){
     String refobjid = url.substring(url.indexOf("id=")+3,url.indexOf("id=")+35);
     refobj = refobjService.getRefobj(refobjid);
}
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
    String pName = e.nextElement().toString();
	if(!pName.equalsIgnoreCase("url")){
		if(url.indexOf("?")!=-1)
			url += "&"+pName+"="+URLEncoder.encode(request.getParameter(pName), "UTF-8");
		else
			url += "?"+pName+"="+URLEncoder.encode(request.getParameter(pName), "UTF-8");
	}
}
%>
<html>
<head>
<%if(refobj!=null){
  %>
  <title><%=StringHelper.null2String(refobj.getCol2()) %></title>
  <%
}else{
    %>
  <title><%=popuptitle %></title>
  <%
} %>
<script language="javascript">
//Esc键的处理
document.onkeydown = EscKeyDown;
function EscKeyDown(e){
	var e=e||event;
	var currKey=e.keyCode||e.which||e.charCode;
  if(currKey==27){
  	window.close();
  }
}
</script>	
</head>
<body style="overflow: hidden;">

<iframe name="main" id="main" frameborder="0" style="border: none;height: 100%;width: 100%;" scrolling="auto" src="<%=url%>">

</iframe>
</body>
<!-- 
<frameset rows="2,98%" framespacing="0" border="0" frameborder="0" >
  <frame name="contents" target="main"  marginwidth="0" marginheight="0" scrolling="auto" noresize SRC='<%= request.getContextPath()%>/blank.htm'>
  <frame name="main" marginwidth="0" marginheight="0" scrolling="auto" src="<%=url%>">
  <noframes>
  <body>
  </body>
  </noframes>
</frameset> -->
</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<%
String url = request.getParameter("url");
  for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
        String pName = e.nextElement().toString();
		if(!pName.equalsIgnoreCase("url"))
			url += "&"+pName+"="+URLEncoder.encode(request.getParameter(pName), "UTF-8");
    }

%>
<html>
<head>
</head>
	   <iframe align='middle' id="iframerequeststatus" name="iframerequeststatus" src='<%=url%>' align='top' width='100%' height='580px' frameborder='0' scrolling='auto'>
		</iframe>

</html>
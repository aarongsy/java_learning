<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.*" %>
<%@ page import="com.eweaver.base.security.model.Sysuser" %>
<%@ page import="com.eweaver.base.security.service.logic.*" %>
<%@ page import="org.acegisecurity.Authentication" %>
<%@ page import="org.acegisecurity.context.SecurityContextHolder" %>
<%@ page import="org.acegisecurity.ui.webapp.AuthenticationProcessingFilter" %>
<%@ page import="org.acegisecurity.userdetails.UserDetails" %>
<%@ page import="org.acegisecurity.userdetails.UserDetailsService" %>
<%@ page import="com.eweaver.base.log.service.LogService" %>
<%
StringBuffer url = request.getRequestURL();  
String queryString = request.getParameter("params");
String client = request.getParameter("client");
if(client != null) {
	client = "client=" + client + "&";
} else {
	client = "";
}
if(!StringHelper.isEmpty(queryString) ) {
	queryString = java.net.URLDecoder.decode(queryString,"UTF-8");
	byte bs[] = EncryptHelper.getFromBASE64(queryString);
	queryString = new String(bs,"UTF-8");
	//queryString = queryString.replace("&emailurl=1","");
	request.getRequestDispatcher("/interfaces/sso/sso.jsp?" + client + queryString).forward(request,response);
} else {
	request.getRequestDispatcher("/main/login.jsp").forward(request,response);
}

%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
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
String  queryString = request.getQueryString()==null?"":request.getQueryString();
String targeturl = "/main/main.jsp";
if(queryString.contains("targeturl")){
	targeturl = queryString.substring(queryString.indexOf("targeturl")+10,queryString.length());
}
String targettitle = request.getParameter("targettitle");
if(StringHelper.isEmpty(targettitle)) {
	targettitle = "提醒中的内容";
}
if(StringHelper.isEmpty(targeturl)){
	targeturl = "/main/main.jsp";
}
targettitle = URLEncoder.encode(targettitle,"utf-8");
EweaverUser eweaverUser=BaseContext.getRemoteUser();
if(eweaverUser==null){
	System.getProperty("org.apache.catalina.SESSION_COOKIE_NAME", "XSESSIONID"); 
	System.setProperty("org.apache.catalina.SESSION_PARAMETER_NAME", "xsessionid"); 
	String userName = request.getParameter("j_username");
	SysuserService sysuserService = (SysuserService)BaseContext.getBean("sysuserService");
	AuthenticationProcessingFilter ssoAuthentication = (AuthenticationProcessingFilter)BaseContext.getBean("ssoAuthentication");

	Sysuser sysuser = sysuserService.findBy("longonname",userName);
	Authentication authResult =ssoAuthentication.attemptAuthentication(request);
	String client = request.getParameter("client");
	if(client == null) {
		client = "OA";
	}
	if(authResult != null&&authResult.getPrincipal()!=null&&UserDetails.class.isInstance(authResult.getPrincipal())){
		EweaverUser vu = (EweaverUser) authResult.getPrincipal();
		vu.setSessionid(request.getSession(true).getId());
		vu.setRemoteIpAddress(request.getRemoteAddr());	
		SecurityContextHolder.getContext().setAuthentication(authResult);
		request.getSession(true).setAttribute("eweaver_user@bean", sysuser);
		request.getSession(true).setAttribute("eweaverusermoniter", new OnLineMonitor("" + sysuser.getObjid()));
		com.eweaver.base.log.model.Log log = new com.eweaver.base.log.model.Log();
		log.setObjid(sysuser.getObjid());
		log.setObjname(sysuser.getLongonname());
		log.setSubmitor(sysuser.getObjid());
		log.setMid(null);
		log.setLogtype("402881e40b6093bf010b60a5847d0003");
		log.setLogdesc("用户从" + client + "单点登录！");
		log.setSubmitip(request.getRemoteAddr());
		log.setSubmitdate(DateHelper.getCurrentDate());
		log.setSubmittime(DateHelper.getCurrentTime());
		LogService logService = (LogService) BaseContext.getBean("logService");
		logService.createLog(log);
	}else{
		response.sendRedirect("/main/login.jsp");
	}
}
if(targeturl.indexOf("/main/main.jsp") > -1) {
    response.sendRedirect(targeturl);
} else {
    response.sendRedirect("/main/main.jsp?targettitle="+targettitle+"&targeturl=" + targeturl);
}
%>
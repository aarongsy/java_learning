<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
  request.setCharacterEncoding("UTF-8");
  String sessionKey=StringHelper.null2String(request.getParameter("sessionkey"));
  MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
  
  if(!pluginService.verify(sessionKey)){
	  out.println("没有权限！");
	  return ;
  }
  //User user=authService.getCurrUser(sessionKey);
  if(sessionKey==null){
	  out.println("没有登陆!");
	  return ;
  }
%>
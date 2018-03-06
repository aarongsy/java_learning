<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.mobile.plugin.common.Constants" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%	
	Map result = new HashMap();
	
	result.put("count", "100");
	result.put("unread", "0");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
%>
<%@ page language="java" contentType="application/json" pageEncoding="GBK"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.mobile.plugin.common.Page" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
	MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	Map result = pluginService.checkServerStatus();
	
	if(result!=null) {
		JSONObject jo = JSONObject.fromObject(result);
		System.out.println(jo);
		out.println(jo.toString());
	}
%>

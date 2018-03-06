<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));
Map result = new HashMap();

if(pluginService.verify(sessionkey)) {
	result.put("verify", "1");
} else {
	result.put("verify", "0");
}

if(result!=null) {
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>
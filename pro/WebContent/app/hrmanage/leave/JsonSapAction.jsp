<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.ConfigSapAction"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("tosap")){
		JSONObject jo = new JSONObject();
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		ConfigSapAction c = new ConfigSapAction();
		try {
			c.syncSap("40285a904999a7ad01499cd4b07219f5", requestid);
			jo.put("msg","true");
		} catch (Exception e) {
			jo.put("msg","false");
			e.printStackTrace();
		}
		
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

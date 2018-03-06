<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.app.configsap.ConfigSapAction" %>
<%@ page import="com.eweaver.app.configsap.SapSync" %>

<%
        JSONObject jo=new JSONObject();
	SapSync s = new SapSync();
	String action=StringHelper.null2String(request.getParameter("action"));
	String requestid = "";
	String sapid = "";
	try {
		if (action.equals("tosap")){
			requestid=StringHelper.null2String(request.getParameter("requestid"));
			sapid=StringHelper.null2String(request.getParameter("sapid"));
		}	
		System.out.println("get sap!");
		s.syncSap(sapid,requestid);
		jo.put("msg","true");
	} catch (Exception e) {
		e.printStackTrace();
		jo.put("msg","false");
	}
		

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();

%>

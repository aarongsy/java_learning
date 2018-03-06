<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String comcode=StringHelper.null2String(request.getParameter("comcode"));
		String soldcode=StringHelper.null2String(request.getParameter("soldcode"));

		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_FI_KNB1";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("BUKRS",comcode);
		function.getImportParameterList().setValue("KUNNR",soldcode);
		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//返回值
		String AKONT = function.getExportParameterList().getValue("AKONT").toString();
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		
		JSONObject jo = new JSONObject();		
		jo.put("AKONT", AKONT);
		jo.put("ERR_MSG", ERR_MSG);
		jo.put("flag", FLAG);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

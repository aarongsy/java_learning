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
		String theDate=StringHelper.null2String(request.getParameter("theDate"));
		String currncy=StringHelper.null2String(request.getParameter("currncy"));
		String currncy1=StringHelper.null2String(request.getParameter("currncy1"));
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_FI_EX_RATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("EXCH_DATE",theDate);
		function.getImportParameterList().setValue("FROM_CURR",currncy);
		function.getImportParameterList().setValue("TO_CURRNCY","RMB");


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
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		String EXCH_RATE = function.getExportParameterList().getValue("EXCH_RATE").toString();
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();

		//创建SAP对象
		sapConnector = new SapConnector();
		functionName = "ZOA_FI_EX_RATE";
		JCoFunction function1 = null;
		try {
			function1 = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function1.getImportParameterList().setValue("EXCH_DATE",theDate);
		function1.getImportParameterList().setValue("FROM_CURR",currncy1);
		function1.getImportParameterList().setValue("TO_CURRNCY","RMB");


		try {
			function1.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//返回值
		String ERR_MSG1 = function1.getExportParameterList().getValue("ERR_MSG").toString();
		String EXCH_RATE1 = function1.getExportParameterList().getValue("EXCH_RATE").toString();
		String FLAG1 = function1.getExportParameterList().getValue("FLAG").toString();
		
		JSONObject jo = new JSONObject();		
		jo.put("msg", ERR_MSG);
		jo.put("rate", EXCH_RATE);
		jo.put("flag", FLAG);
		jo.put("msg1", ERR_MSG1);
		jo.put("rate1", EXCH_RATE1);
		jo.put("flag1", FLAG1);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

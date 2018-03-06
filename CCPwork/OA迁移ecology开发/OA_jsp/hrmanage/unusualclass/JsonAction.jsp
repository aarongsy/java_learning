<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
System.out.println("--1--");
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String beginDate=StringHelper.null2String(request.getParameter("beginDate"));
		String endDate=StringHelper.null2String(request.getParameter("endDate"));
		String hid=StringHelper.null2String(request.getParameter("hid"));
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT2006_GET";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("PERNR",hid);
		function.getImportParameterList().setValue("BEGDA",beginDate);
		function.getImportParameterList().setValue("ENDDA",endDate);
		function.getImportParameterList().setValue("KTART","22");

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
		JCoTable retTable = function.getTableParameterList().getTable("IT2006");
		double nums = 0.00;
		if (retTable != null) {
			for (int i = 0; i < retTable.getNumRows(); i++) {	
				nums = nums + Double.valueOf(StringHelper.null2String(retTable.getString("ANZHL")));
				retTable.nextRow();
			}
		}

		JSONObject jo = new JSONObject();	
		jo.put("old",String.format("%.2f",nums));
		
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

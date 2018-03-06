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
		String saleorder=StringHelper.null2String(request.getParameter("saleorder"));

		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_SD_SO_INFO";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("VBELN",saleorder);


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
		String NAME2 = function.getExportParameterList().getValue("NAME2").toString();
		String STRAS2 = function.getExportParameterList().getValue("STRAS2").toString();
		String SUNNR = function.getExportParameterList().getValue("SUNNR").toString();
		
		JSONObject jo = new JSONObject();		
		jo.put("NAME2", NAME2);
		jo.put("STRAS2", STRAS2);
		jo.put("SUNNR", SUNNR);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

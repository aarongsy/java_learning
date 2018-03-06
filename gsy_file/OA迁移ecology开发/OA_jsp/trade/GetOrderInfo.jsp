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
		String orderno=StringHelper.null2String(request.getParameter("orderno"));

		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_MM_PO_INFO";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("EBELN",orderno);
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
		String WAERS = function.getExportParameterList().getValue("WAERS").toString();//币种
		String WKURS = function.getExportParameterList().getValue("WKURS").toString();//汇率
		String TAXES = function.getExportParameterList().getValue("TAXES").toString();//含税总金额

		String BUKRS = function.getExportParameterList().getValue("BUKRS").toString();//公司代码
		String BUTXT = function.getExportParameterList().getValue("BUTXT").toString();//公司别
		String LIFNR = function.getExportParameterList().getValue("LIFNR").toString();//供应商简码
		String NAME1 = function.getExportParameterList().getValue("NAME1").toString();//供应商名称
		
		JSONObject jo = new JSONObject();		
		jo.put("WAERS", WAERS);
		jo.put("WKURS", WKURS);
		jo.put("TAXES", TAXES);

		jo.put("BUKRS", BUKRS);
		jo.put("BUTXT", BUTXT);
		jo.put("LIFNR", LIFNR);
		jo.put("NAME1", NAME1);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>

<%

	String orderno = StringHelper.null2String(request.getParameter("orderno"));//采购订单号


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
	function.getImportParameterList().setValue("EBELN",orderno);//采购订单号
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
	String EKGRP = function.getExportParameterList().getValue("EKGRP").toString();//采购员
	String BUKRS = function.getExportParameterList().getValue("BUKRS").toString();//公司代码
	String BUTXT = function.getExportParameterList().getValue("BUTXT").toString();//公司别

	JSONObject jo = new JSONObject();	
	jo.put("EKGRP", EKGRP);
	jo.put("BUKRS", BUKRS);
	jo.put("BUTXT", BUTXT);

	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

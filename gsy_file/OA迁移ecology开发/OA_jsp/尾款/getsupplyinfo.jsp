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
 
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	String purchno = StringHelper.null2String(request.getParameter("purchno"));//采购订单号


	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
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

    function.getImportParameterList().setValue("EBELN",purchno);//凭证号

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

	String LIFNR = function.getExportParameterList().getValue("LIFNR").toString();//供应商编码
	String NAME1 = function.getExportParameterList().getValue("NAME1").toString();//供应商名称
	String BSART = function.getExportParameterList().getValue("BSART").toString();//采购凭证类型（采购员）
	String ZTERM = function.getExportParameterList().getValue("ZTERM").toString();//付款条款代码
    System.out.println("LIFNR");
	JSONObject jo = new JSONObject();	
	jo.put("LIFNR", LIFNR);
	jo.put("NAME1", NAME1);
	jo.put("BSART", BSART);
	jo.put("ZTERM", ZTERM);

	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

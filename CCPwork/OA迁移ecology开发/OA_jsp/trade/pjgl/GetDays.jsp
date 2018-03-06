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

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
 
	//String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	String salegroup = StringHelper.null2String(request.getParameter("salegroup"));//销售组织
	String sdf = StringHelper.null2String(request.getParameter("sdf"));//售达方简码
	String salewaycode = StringHelper.null2String(request.getParameter("salewaycode"));//分销渠道
	String goodgroupcode = StringHelper.null2String(request.getParameter("goodgroupcode"));//产品组
	//System.out.println(" requestid="+requestid);
	System.out.println(" salegroup="+salegroup);
	System.out.println(" sdf="+sdf);
	System.out.println(" salewaycode="+salewaycode);
	System.out.println(" goodgroupcode="+goodgroupcode);


	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		//创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_SD_CUSTOMER_LTEXT";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段

	function.getImportParameterList().setValue("KUNNR",sdf);//客户
	function.getImportParameterList().setValue("VKORG",salegroup);//销售组织
	function.getImportParameterList().setValue("VTWEG",salewaycode);//分销渠道
	function.getImportParameterList().setValue("SPART",goodgroupcode);//产品组
	
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
	JCoTable tab = function.getTableParameterList().getTable("SD_CSTM_LIST");
	//System.out.println(" tab.getNumRows()="+tab.getNumRows());
	String paytermcode = "";
	String payterm = "";
	String pjday = "";
	String reason = "";	
	if (tab!=null && tab.getNumRows()>0) {					
		paytermcode = StringHelper.null2String(tab.getValue("ZTERM")); 
		//System.out.println(" paytermcode="+paytermcode);
		payterm = StringHelper.null2String(tab.getValue("VTEXT")); 
		//System.out.println(" payterm="+payterm);
		pjday = StringHelper.null2String(tab.getValue("LTEXT2")); 
		//System.out.println(" pjday="+pjday);			
		reason = StringHelper.null2String(tab.getValue("LTEXT3")); 		
		//System.out.println(" reason="+reason);	
	}

	JSONObject jo = new JSONObject();		
	jo.put("paytermcode", paytermcode);
	jo.put("payterm", payterm);
	jo.put("pjday", pjday);
	jo.put("reason", reason);	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

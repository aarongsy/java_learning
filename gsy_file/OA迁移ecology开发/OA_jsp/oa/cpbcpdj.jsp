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
	String action=StringHelper.null2String(request.getParameter("action"));
	if(action.equals("getData"))
	{
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
		String wlh = StringHelper.null2String(request.getParameter("wlh"));//物料号
		String gs = StringHelper.null2String(request.getParameter("gs"));//公司代码
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_MM_CHG_READ_GS";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		function.getImportParameterList().setValue("MATNR1",wlh);//物料号
		function.getImportParameterList().setValue("WERKS",gs);//公司代码
		try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		//抓取抛SAP的返回值
		if(FLAG.equals("X"))
		{
			JCoTable newretTable = function.getTableParameterList().getTable("MM_PO_ITEMS");
			
			newretTable.firstRow();//获取返回表格数据中的第一行
		
			String PRCTR = newretTable.getString("PRCTR");//利润中心

			String MAKTX = newretTable.getString("MAKTX");//物料号描述

			String MATNR = newretTable.getString("MATNR");//物料号
			
			String WERKS = newretTable.getString("WERKS");//工厂

			String EKGRP = newretTable.getString("EKGRP");//采购组

			String VTWEG = newretTable.getString("VTWEG");//sapfxqd

			String MSTAE = newretTable.getString("MSTAE");//dj

			String upsql = "update uf_oa_cpbcpdj set saperrinfo ='"+ERR_MSG+"',sapreturnflag='"+FLAG+"',saplrzx='"+PRCTR+"',sapwlhms='"+MAKTX+"'";
			upsql = upsql +",newsapwlh= '"+MATNR+"',comid= '"+WERKS+"',sapcgz= '"+EKGRP+"',sapfxqd= '"+VTWEG+"',sapdjjd='"+MSTAE+"'";
			upsql = upsql+" where requestid = '"+requestid+"'";
			baseJdbc.update(upsql);
		}
		
		JSONObject jo = new JSONObject();		
		jo.put("msg", ERR_MSG);
		jo.put("flag", FLAG);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		System.out.println(jo.toString());

		response.getWriter().flush();
		response.getWriter().close();

	}
	

	//}
%>

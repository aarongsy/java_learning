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
		
			String DISLS = newretTable.getString("DISLS");//批量SAP

			String PRCTR = newretTable.getString("PRCTR");//利润中心

			String BRGEW = newretTable.getString("BRGEW");//毛重

			String MAKTX = newretTable.getString("MAKTX");//物料号描述

			String BSTRF = newretTable.getString("BSTRF");//舍入值

			String EKWSL = newretTable.getString("EKWSL");//采购价值代码

			String NTGEW = newretTable.getString("NTGEW");//净重

			String WEBAZ = newretTable.getString("WEBAZ");//以天记得收货处理时间

			String BSTMI = newretTable.getString("BSTMI");//最小批量

			String BSTMA = newretTable.getString("BSTMA");//最大批量大小

			String PLIFZ = newretTable.getString("PLIFZ");//计划的天数内交货

			String BISMT = newretTable.getString("BISMT");//旧物料号

			String MATNR = newretTable.getString("MATNR");//物料号

			String BSTFE = newretTable.getString("BSTFE");//固定批量大小

			String MATKL = newretTable.getString("MATKL");//物料组

			String EKGRP = newretTable.getString("EKGRP");//采购组
	
			String DISGR = newretTable.getString("DISGR");//MRP组
		
			String DISMM = newretTable.getString("DISMM");//MRP类型

			String DISPO = newretTable.getString("DISPO");//MRP控制者
             
			String VKORG = newretTable.getString("VKORG");//销售机构
			
			String WERKS = newretTable.getString("WERKS");//工厂

			String EISBE = newretTable.getString("EISBE");//安全库存
             
			String SPART = newretTable.getString("SPART");//产品大类

			String upsql = "update uf_oa_zpackkgs set saperrinfo ='"+ERR_MSG+"',sapreturnflag='"+FLAG+"',sappl='"+DISLS+"',saplrzx='"+PRCTR+"',sapmz='"+BRGEW+"',sapwlhms='"+MAKTX+"',sapsrz='"+BSTRF+"' ";
			upsql = upsql +",sapcgjzdm='"+EKWSL+"',sapjz='"+NTGEW+"',sapshclsj='"+WEBAZ+"',sapzxl='"+BSTMI+"',sapzdl='"+BSTMA+"',sapcpjhsj='"+PLIFZ+"',sapjwlh='"+BISMT+"'";
			upsql = upsql +",sapgdl='"+BSTFE+"',sapwlz='"+MATKL+"',sapcgz='"+EKGRP+"',newsapwlh= '"+MATNR+"'";
			upsql = upsql +",sapmrpz='"+DISGR+"',sapmrplx='"+DISMM+"',sapmrpkzz='"+DISPO+"',comid= '"+WERKS+"'";
			upsql = upsql +",sapaqkc='"+EISBE+"',sapcpdl= '"+SPART+"'";
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

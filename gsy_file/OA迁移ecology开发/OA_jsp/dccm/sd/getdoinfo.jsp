<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.app.configsap.SapSync"%>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>


<%
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String ordtxt=StringHelper.null2String(request.getParameter("ordtxt"));
	String itemtxt=StringHelper.null2String(request.getParameter("itemtxt"));
	
	String tmpstr1 = "";
	String tmpstr2 = "";
	String tmpstr3 = "";
	System.out.println("ordtxt:"+ordtxt);
	System.out.println("itemtxt:"+itemtxt);
	if(ordtxt.indexOf(",")!=-1)//同一张外销单存在多条出货明细
	{
		System.out.println("1..........");
		String [] array1 = ordtxt.split("\\,");
		String [] array2 = itemtxt.split("\\,");
		for(int j=0;j<array1.length;j++)
		{
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_SD_DO_STATUS_MY";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				e.printStackTrace();
			}

			//输入字段
			function.getImportParameterList().setValue("VBELN",array1[j]);//销售单号
			function.getImportParameterList().setValue("POSNR",array2[j]);//订单项次

			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} 
			catch (JCoException e) {
				e.printStackTrace();
			} 
			catch (Exception e) {
				e.printStackTrace();
			}
			//获取SAP返回值
			String dono = function.getExportParameterList().getValue("DO").toString();//DO NO
			String doitem = function.getExportParameterList().getValue("ITEM").toString();//DO ITEM
			String doqty = function.getExportParameterList().getValue("LFIMG").toString();//DO QTY
			tmpstr1 = tmpstr1 + dono + ",";
			tmpstr2 = tmpstr2 + doitem + ",";
			tmpstr3 = tmpstr3 + doqty + ",";
		}
		if(tmpstr1.indexOf(",")!=-1)
		{
			tmpstr1 = tmpstr1.substring(0,tmpstr1.length()-1);
		}
		if(tmpstr2.indexOf(",")!=-1)
		{
			tmpstr2 = tmpstr2.substring(0,tmpstr2.length()-1);
		}
		if(tmpstr3.indexOf(",")!=-1)
		{
			tmpstr3 = tmpstr3.substring(0,tmpstr3.length()-1);
		}
	}
	else
	{
		System.out.println("2..........");
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_SD_DO_STATUS_MY";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//输入字段
		function.getImportParameterList().setValue("VBELN",ordtxt);//销售单号
		function.getImportParameterList().setValue("POSNR",itemtxt);//订单项次

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} 
		catch (JCoException e) {
			e.printStackTrace();
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
		//获取SAP返回值
		String dono = function.getExportParameterList().getValue("DO").toString();//DO NO
		String doitem = function.getExportParameterList().getValue("ITEM").toString();//DO ITEM
		String doqty = function.getExportParameterList().getValue("LFIMG").toString();//DO QTY
		tmpstr1 = dono;
		tmpstr2 = doitem;
		tmpstr3 = doqty;
	}

	
	System.out.println("tmpstr1:"+tmpstr1);
	System.out.println("tmpstr2:"+tmpstr2);
	System.out.println("tmpstr3:"+tmpstr3);
	
	JSONObject jo = new JSONObject();		
	jo.put("str1", tmpstr1);
	jo.put("str2", tmpstr2);
	jo.put("str3", tmpstr3);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

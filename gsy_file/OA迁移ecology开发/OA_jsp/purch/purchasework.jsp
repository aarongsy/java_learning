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
<%@ page import="com.sap.conn.jco.JCoStructure" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	 //String requestid=StringHelper.null2String(request.getParameter("requestid"));//requestid
	 String sapnum=StringHelper.null2String(request.getParameter("sapnum"));//SAP采购案号
	 BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

	 String mark="0";//标识
	 SapConnector sapConnector = new SapConnector();
	 String functionName = "ZOA_MM_PR_LIST";
	 JCoFunction function = null;
	 try 
	 {
		function = SapConnector.getRfcFunction(functionName);
		//输入
		function.getImportParameterList().setValue("BANFN_IN",sapnum);//SAP请购案号
		try 
		{
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} 
		catch (JCoException e) 
		{
			e.printStackTrace();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		//抓取抛SAP的返回值
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		System.out.println("返回值"+FLAG);
		//更新数据库中对应的行项信息(即SAP将要返回的信息如消息类型,消息文本)
		//String upsql="update uf_oa_yjgsryrc set sapmark='"+FLAG+"' where requestid='"+requestid+"'";
		//baseJdbc.update(upsql);//执行SQL
		if(FLAG.equals("X"))
		{
			mark="1";
		}
		else
		{
			mark="0";
		}
	  } 
	  catch ( JCoException e ) 
	  {
		  e.printStackTrace();
	  } 
	  catch ( Exception e )
	  {
		  e.printStackTrace();
	  }
	  JSONObject jo = new JSONObject();		
	  if(mark.equals("1"))
	  {			
		jo.put("msg","true");
	  }
	  else
	  {
		jo.put("msg","false");
	  }
	  response.setContentType("application/json; charset=utf-8");
	  response.getWriter().write(jo.toString());
	  response.getWriter().flush();
	  response.getWriter().close();
%>

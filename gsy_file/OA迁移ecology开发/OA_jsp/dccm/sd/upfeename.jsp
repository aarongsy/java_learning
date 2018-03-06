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
	//创建SAP对象
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_SD_FEENAME";
	JCoFunction function = null;
	try 
	{
		function = SapConnector.getRfcFunction(functionName);
	} 
	catch (Exception e) 
	{
		e.printStackTrace();
	}

	JCoTable retTable = function.getTableParameterList().getTable("ZSD_FEENAME1");
	String sql = "select fy.feename from uf_dmdb_feename fy left join formbase fb on fy.requestid=fb.id where fy.imextype='40285a8d56d542730156e95e821c3061'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			String feename = StringHelper.null2String(map.get("feename"));//费用名称
			retTable.appendRow();
			retTable.setValue("FEENAME", feename);
		}
	}

	try 
	{
		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
	} 
	catch (JCoException e)
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	} 
	catch (Exception e) 
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	JSONObject jo = new JSONObject();		
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

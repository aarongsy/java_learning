<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){

		String sapobjid=StringHelper.null2String(request.getParameter("sapobjid"));
			System.out.println(sapobjid+"*****************************************************");
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_VACANCY_GET";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("ORGEH",sapobjid);


		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//获取表数据
		JCoTable retTable = function.getTableParameterList().getTable("OBJEC");
		int nums = 0;
		if(retTable != null) nums = retTable.getNumRows();
		//返回值
		String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
		String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
		
		JSONObject jo = new JSONObject();		
		jo.put("input001", nums);
		jo.put("input002", MESSAGE);
		System.out.println("aaaaaaa"+MESSAGE+nums);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

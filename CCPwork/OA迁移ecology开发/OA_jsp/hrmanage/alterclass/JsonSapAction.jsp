<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>


<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if(action.equals("getPBHours")){//获取普班行事历时数
		String sapid=StringHelper.null2String(request.getParameter("sapid"));//SAP员工编号
		String startdate=StringHelper.null2String(request.getParameter("startdate"));//开始日期
		String enddate=StringHelper.null2String(request.getParameter("enddate"));//结束日期
		String thetype=StringHelper.null2String(request.getParameter("thetype"));//厂区别编码
		double total = 0.00;
		
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_WORK_SCHEDULE_GET";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println(startdate+"/"+enddate);
		//插入字段
		function.getImportParameterList().setValue("MOTPR",thetype);
		function.getImportParameterList().setValue("BEGDA",startdate);
		function.getImportParameterList().setValue("ENDDA",enddate);

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		JSONObject jo = new JSONObject();
		//返回值
		JCoTable retTable = function.getTableParameterList().getTable("PTPSP");	
		if (retTable != null) {
			for (int n = 0; n < retTable.getNumRows(); n++) {
				String STDAZ = StringHelper.null2String(retTable.getString("STDAZ"));
				if(!STDAZ.equals("")) total = total + Double.valueOf(STDAZ);
				retTable.nextRow();
			}
		}else total = 0.00;
						
		jo.put("total",String.format("%.2f",total));		
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

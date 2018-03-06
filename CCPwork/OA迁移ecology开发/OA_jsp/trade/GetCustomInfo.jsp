<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String company=StringHelper.null2String(request.getParameter("company"));//公司代码
		String startdate=StringHelper.null2String(request.getParameter("startdate"));//开始日期
		String enddate=StringHelper.null2String(request.getParameter("enddate"));//结束日期
		String customid=StringHelper.null2String(request.getParameter("customid"));//客户编码

		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_SD_CREDIT_INFO";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("BUKRS",company);
		function.getImportParameterList().setValue("DATE_FROM",startdate);
		function.getImportParameterList().setValue("UEDAT",enddate);
		function.getImportParameterList().setValue("KUNNR",customid);

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

		String CTLPC = function.getExportParameterList().getValue("CTLPC").toString();//风险类别

		String KLIMK = function.getExportParameterList().getValue("KLIMK").toString();//信用总额(本币)

		String OBLIG = function.getExportParameterList().getValue("OBLIG").toString();//SAP已占用金额(本币)
		String NXTRV = function.getExportParameterList().getValue("NXTRV").toString();//SAP总额度到期日
		
		JSONObject jo = new JSONObject();		
		jo.put("CTLPC", CTLPC);
		jo.put("KLIMK", KLIMK);
		jo.put("OBLIG", OBLIG);
		jo.put("NXTRV", NXTRV);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

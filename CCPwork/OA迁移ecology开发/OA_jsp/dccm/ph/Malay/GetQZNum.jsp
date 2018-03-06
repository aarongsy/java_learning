<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData"))
	{
		System.out.println("Start-------------------------------------------------------");
		String docnum=StringHelper.null2String(request.getParameter("docnum"));//凭证编号
		String comcode=StringHelper.null2String(request.getParameter("comcode"));//公司代码
		String year=StringHelper.null2String(request.getParameter("year"));//会计年度
		//System.out.println("docnum"+docnum);
		//System.out.println("comcode"+comcode);
		//System.out.println("year"+year);
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_FI_BELNR_READ";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("BELNR",docnum);//凭证编号
		function.getImportParameterList().setValue("BUKRS",comcode);//公司代码
		function.getImportParameterList().setValue("GJAHR",year);//会计年度


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
		String AUGBL = function.getExportParameterList().getValue("AUGBL").toString();//清帐凭证号
		System.out.println("哈哈哈哈AUGBL"+AUGBL);
		//String AUGDT = function.getExportParameterList().getValue("AUGDT").toString();//清帐日期
		//String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();//返回错误信息
		//String FLAG = function.getExportParameterList().getValue("FLAG").toString();//成功标志
		
		JSONObject jo = new JSONObject();		
		jo.put("augbl", AUGBL);
		//jo.put("augtd", AUGDT);
		//jo.put("msg", ERR_MSG);
		//jo.put("flag", FLAG);
		
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

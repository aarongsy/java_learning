<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl;"%>

<%
	BaseBean log = new BaseBean();
	log.writeLog("进入JsonAction.jsp");
	String action = request.getParameter("action");
	JCO.Client sapconnection = null;
	JSONObject jsonResult = new JSONObject();
	JSONArray jsonArr = new JSONArray();
	try {
		if (action.equals("getData")) {

			Date d = new Date();
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			String theDate = format.format(d);
			String currncy = request.getParameter("currncy");
			String TO_CURRNCY = request.getParameter("to_currncy");
			
			log.writeLog("currncy: " + currncy);
			log.writeLog("to_currncy: " + TO_CURRNCY);
			//创建SAP对象
			String sources = "1";
			SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
			sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
			log.writeLog("创建SAP连接");
			String strFunc = "ZOA_FI_EX_RATE_ML";
			JCO.Function function = null;
			JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
			IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
			function = ft.getFunction();

			if (function == null) {
				log.writeLog("链接SAP失败");
				return;
			}

			//插入字段
			function.getImportParameterList().setValue(theDate, "EXCH_DATE");
			function.getImportParameterList().setValue(currncy, "FROM_CURR");
			function.getImportParameterList().setValue(TO_CURRNCY, "TO_CURRNCY");
			sapconnection.execute(function);
			log.writeLog("执行function上传sap数据");

			//返回值
			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
			String EXCH_RATE = function.getExportParameterList().getValue("EXCH_RATE").toString();
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();

			log.writeLog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			log.writeLog("FLAG: " + FLAG);
			log.writeLog("ERR_MSG: " + ERR_MSG);
			log.writeLog("EXCH_RATE: " + EXCH_RATE);
			log.writeLog("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
			JSONObject jo = new JSONObject();
			jo.put("msg", ERR_MSG);
			jo.put("rate", EXCH_RATE);
			jo.put("flag", FLAG);
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
	} catch (Exception e) {
		// TODO: handle exception
		jsonResult.put("flag", "E");
		out.write("fail" + e);
		e.printStackTrace();
	}
%>

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
	RecordSet rs = new RecordSet();
	BaseBean log = new BaseBean();
	log.writeLog("QZ_FI_READ");
	JCO.Client sapconnection = null;
	JSONObject jsonResult = new JSONObject();
	JSONArray jsonArr = new JSONArray();
	try {

		String lists = request.getParameter("list");
		String cysbh = request.getParameter("cysbh");//承运商编号
		String gsdm = request.getParameter("gsdm");//公司代码

		HashSet<String> s1 = new HashSet<String>();
		HashSet<String> s2 = new HashSet<String>();

		String[] HKONTS = request.getParameterValues("HKONTS[]");//总账科目
		String[] BELNRS = request.getParameterValues("BELNRS[]");//凭证编号
		//去重
		for (int i = 0; i < HKONTS.length; i++) {
			s1.add(HKONTS[i]);
		}
		for (int i = 0; i < BELNRS.length; i++) {
			s2.add(BELNRS[i]);
		}
		
		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String currdate = format.format(d);

		String sources = "1";
		SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
		sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
		log.writeLog("创建SAP连接");
		String strFunc = "ZOA_FI_CLEAR_READ";
		JCO.Function function = null;
		JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
		IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
		function = ft.getFunction();

		if (function == null) {
			log.writeLog("链接SAP失败");
			return;
		}
		function.getImportParameterList().setValue(gsdm, "BUKRS");//公司代码
		function.getImportParameterList().setValue(cysbh, "LIFNR");//承运商编码

		JCO.Table inTableParams1 = function.getTableParameterList().getTable("FI_GL_LIST");
		for (String s : s1) {
			log.writeLog("上抛参数1:" + s);
			inTableParams1.appendRow();
			inTableParams1.setValue(s, "HKONT");
		}
		// 		 		inTableParams1.appendRow();
		// 				inTableParams1.setValue("55062600", "HKONT");
		// 				inTableParams1.appendRow();
		// 				inTableParams1.setValue("55060500", "HKONT");

		JCO.Table inTableParams2 = function.getTableParameterList().getTable("FI_OA_LIST");
		// 		for (String s : s2) {
		// 			log.writeLog("上传参数2:" + s);
		// 			inTableParams2.appendRow();
		// 			//inTableParams2.setValue(s, "BELNR");
		// 			inTableParams2.setValue("1500070522", "BELNR");
		// 			inTableParams2.setValue("1010", "BUKRS");
		// 			inTableParams2.setValue("2017", "GJAHR");
		// 			inTableParams2.setValue("S", "DTYPE");
		// 		}

		for (String s : s2) {
			log.writeLog("上传参数2:" + s);
			inTableParams2.appendRow();
			//inTableParams2.setValue(s, "BELNR");
			inTableParams2.setValue(s, "BELNR");
			inTableParams2.setValue(gsdm, "BUKRS");
			inTableParams2.setValue(currdate.substring(0,4), "GJAHR");
			inTableParams2.setValue("S", "DTYPE");
		}

		sapconnection.execute(function);
		log.writeLog("执行function上传sap数据");

		String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		// 获取数据
		log.writeLog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		log.writeLog("FLAG: " + FLAG);
		log.writeLog("ERR_MSG: " + ERR_MSG);
		log.writeLog("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");

		JCO.Table output = function.getTableParameterList().getTable("FI_CLEAR_LIST");
		rs.writeLog("返回表行数：" + output.getNumRows());

		for (int i = 0; i < output.getNumRows(); i++) {
			output.setRow(i);
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("KOART", output.getValue("KOART"));//客户/供应商标识
			jsonObj.put("HKONT", output.getValue("HKONT"));//客户/供应商编码
			jsonObj.put("UMSKZ", output.getValue("UMSKZ"));//特殊总账标识
			jsonObj.put("BELNR", output.getValue("BELNR"));//需清帐凭证编号
			jsonObj.put("GJAHR", output.getValue("GJAHR"));//会计年度
			jsonObj.put("BUZEI", output.getValue("BUZEI"));//需清帐凭证项次
			jsonObj.put("WRBTR", output.getValue("WRBTR"));//清帐剩余金额
			jsonObj.put("DMBTR", output.getValue("DMBTR"));//本位币金额				
			jsonObj.put("SGTXT", output.getValue("SGTXT"));//清帐文本	
			jsonArr.add(jsonObj);
		}
		jsonResult.put("msg", ERR_MSG);
		jsonResult.put("flag", FLAG);
		jsonResult.put("result", jsonArr);
	} catch (Exception e) {
		// TODO: handle exception
		jsonResult.put("flag", "E");
		out.write("fail" + e);
		e.printStackTrace();

	}

	response.getWriter().write(jsonResult.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
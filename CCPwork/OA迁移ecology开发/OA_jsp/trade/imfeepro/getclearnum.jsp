<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>


<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>

<%
 
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	String docnum = StringHelper.null2String(request.getParameter("docnum"));//凭证号
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码

	String year = StringHelper.null2String(request.getParameter("jzdate"));//年度
	System.out.println(docnum);
	System.out.println(comcode);
	System.out.println(year);
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_FI_DOC_REV";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段

	function.getImportParameterList().setValue("BELNR",docnum);//凭证号

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

	String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();//错误消息
	String AC_DOC_NO = function.getExportParameterList().getValue("STBLG").toString();//凭证号
	String FLAG = function.getExportParameterList().getValue("FLAG").toString();//消息类型
	String insql = "update uf_tr_feeclearmain  set cxpzh = '"+AC_DOC_NO+"' where requestid = '"+requestid+"'";
	System.out.println(insql);
	baseJdbc.update(insql);
	JSONObject jo = new JSONObject();	
	
	jo.put("msg", ERR_MSG);
	jo.put("acdocno", AC_DOC_NO);
	jo.put("flag", FLAG);

	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

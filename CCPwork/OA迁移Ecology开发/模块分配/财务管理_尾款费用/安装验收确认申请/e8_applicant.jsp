<%@page import="bsh.util.Util"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.general.Util"%>

<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>

<%@page import="weaver.interfaces.sap.SAPConn"%>
<%@page import="weaver.soa.workflow.request.RequestInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%@page import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>
<%@page import="com.weaver.integration.log.LogInfo"%>

<%
 String data=request.getParameter("data");
 out.write("enter");


 JCO.Client sapconnection = null;
 BaseBean log=new BaseBean();
 
 log.writeLog("writelog:got parameterdata");

 RecordSet rs=new RecordSet();
 
 String sources="1";
 
  SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
  sapconnection=(JCO.Client)sapidsi.getConnection(sources, new LogInfo());
  out.write("创建sap连接");
  String strFunc="ZOA_MM_PO_INFO";
  JCO.Repository myRepository = new JCO.Repository("Repository",sapconnection);
  IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUppercase());
  JCO.Function function = ft.getFunction();
  
  if (function ==null){
	  log.writeLog("安装验收申请：链接sap失败");
		return;
  }
	
	//插入字段
	fuction
  
 
 rs.writeLog("enter lhsq.jsp");
 out.write("end session");

%>  
  
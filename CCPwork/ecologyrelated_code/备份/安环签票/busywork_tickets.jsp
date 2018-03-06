<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.systeminfo.systemright.RightComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.workflow.report.ReportShare"%>
<%@page import="weaver.systeminfo.systemright.CheckUserRight"%>
<%@page import="weaver.systeminfo.SysMaintenanceLog"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.BaseBean"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.util.regex.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String flowno = Util.null2String(request.getParameter("reqflowid")).trim();
	String isvalid = Util.null2String(request.getParameter("ifvalid")).trim();
	String zftime = Util.null2String(request.getParameter("zftime")).trim();
	String zfman = Util.null2String(request.getParameter("zfrid")).trim();
	String reason = Util.null2String(request.getParameter("zfreason")).trim();
    BaseBean basebean=new BaseBean();
	String zfrname="";
	
	String sql1 = "update formtable_main_60 set isvalid = '"+isvalid+"',zftime = '"+zftime+"',zfman='"+zfman+"',reason='"+reason+"' where flowno = '"+flowno+"'";
	rs.executeSql(sql1);
	
	basebean.writeLog("测试测试-------：" + sql1);
	/*
 	JSONObject jo = new JSONObject();		
	jo.put("zfrname", zfrname);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close(); */
%>
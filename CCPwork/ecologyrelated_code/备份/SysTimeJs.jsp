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

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.util.regex.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%
	RecordSet reset=new RecordSet();
	
  	String sql1 = "select to_char(sysdate,'yyyy-MM-dd HH24:mi:ss') as sys from dual";
  	reset.execute(sql1);   		
	reset.next();
	String sysdate = Util.null2String(reset.getString("sys"));
	
	JSONObject jo = new JSONObject();		
	jo.put("sysdate",sysdate);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
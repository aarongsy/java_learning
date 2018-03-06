<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.systeminfo.systemright.RightComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.workflow.report.ReportShare"%>
<%@page import="weaver.systeminfo.systemright.CheckUserRight"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.util.*,java.util.regex.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>


<%
User user = HrmUserVarify.getUser (request , response) ;

    //BaseBean basebean=new BaseBean();
	String name="";
	int userid =user.getUID();//当前用户id
	
	
	//	lastname id
	//	周永
	//	陈厚福
	//
	String sql1 = "select lastname from hrmresource where id = '"+userid+"'";
	RecordSet rs= new RecordSet();
	rs.executeSql(sql1);
	int rscount=rs.getCounts();
	if(rscount>0)
	{
    	if(rs.next())
		{
			name = rs.getString("lastname");
    	}
	}
		
	JSONObject jo = new JSONObject();		
	jo.put("currentusername",name);
	jo.put("currentuserid",userid);
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close(); 
%>
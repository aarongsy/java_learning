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
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="deleteRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%

	out.println("");


		String roleId = Util.null2String(request.getParameter("roleId")).trim();
		

	              String sql1="select * from SysRoleSubcomRight where roleid='"+roleid+"' and subcompanyid='"+subid+"' ";
	              rs.executeSql(sql1);
	              int rscount=rs.getCounts();
	              if(rscount<=0)
    		  if(rs.next()){
    		  	rolesmark=rs.getString("rolesmark");
    		  }

						        String sql4="DELETE SystemRightRoles WHERE rightid = '"+delrightid_tmp+"' and roleid='"+roleid+"' ";

						        deleteRs.executeSql(sql4);
		
		      String insertSQL = "insert into ";  
  			  rs4.executeSql(insertSQL);	
			  
			 
%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="com.eweaver.app.dccm.dmhr.leave.DMHR_LeaveAction"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("toSAP")){	//加班申请抛SAP
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));		
		Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));		
		DMHR_LeaveAction app = new DMHR_LeaveAction();
		String flag = "";
		try {
			flag = app.LeaveAppToSAP(requestid,force);
			if ( "pass".equals(flag) ) {
				jsonObject.put("info",flag);	
				jsonObject.put("msg","true");		
			} else{
				jsonObject.put("info",flag);	
				jsonObject.put("msg","false");	
			}				
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());	
			jsonObject.put("msg","false");				
		}		
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
	if (action.equals("getLeftQuota")){	//取缺勤定额
		JSONObject jsonObject = new JSONObject();		
		String empsapid=StringHelper.null2String(request.getParameter("empsapid"));		
		String quotaid=StringHelper.null2String(request.getParameter("quotaid"));	
		String edate=StringHelper.null2String(request.getParameter("edate"));
		if ( !"".equals(empsapid) && !"".equals(quotaid) && !"".equals(edate) ) {
			DMHR_LeaveAction app = new DMHR_LeaveAction();
			String flag = "";
			try {
				flag = app.GetLeftQuota(empsapid,"",edate,quotaid);
				String[] a = flag.split("@@");
				if( "error".equals(a[0]) ){
					jsonObject.put("info",a[1]);	
					jsonObject.put("msg","false");	
				}else{				
					jsonObject.put("info",flag);	
					jsonObject.put("msg","true");	
				}
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("info",e.getMessage());	
				jsonObject.put("msg","false");				
			}		
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();	
	}
%>
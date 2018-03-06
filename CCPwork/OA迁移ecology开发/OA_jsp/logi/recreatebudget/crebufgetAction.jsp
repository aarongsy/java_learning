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
<%@ page import="com.eweaver.app.weight.service.Uf_lo_budgetModServiceT"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("crebudget")){	//手工生成暂估单
		JSONObject jsonObject = new JSONObject();
		String loadplanno=StringHelper.null2String(request.getParameter("loadplanno"));		
		Uf_lo_budgetModServiceT app = new Uf_lo_budgetModServiceT();	
		try {
			String flag = app.modtotalfee( loadplanno );
			String[] aa = flag.split("@");
			if ( "0".equals(aa[0]) ) {
				jsonObject.put("info",aa[1]);	
				jsonObject.put("msg","true");		
			} else{
				jsonObject.put("info",aa[1]);	
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
%>
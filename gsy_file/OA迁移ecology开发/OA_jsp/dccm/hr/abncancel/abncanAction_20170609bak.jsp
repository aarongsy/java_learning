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
<%@ page import="com.eweaver.app.dccm.dmhr.abncancel.DMHR_AbnCancelAction"%>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("toSAP")){	//异常数据撤销申请抛SAP
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));		
		Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));		
		DMHR_AbnCancelAction app = new DMHR_AbnCancelAction();
		String flag = "";
		String sql = "select abntype from uf_dmhr_cancelapp where requestid='"+requestid+"'";
		String abntype = "";
		List list = baseJdbcDao.executeSqlForList(sql);
		if ( list.size()>0 ) {
			Map map = (Map)list.get(0);
			abntype = StringHelper.null2String(map.get("abntype"));  
		}		
		try {
			if ( "40285a8d58f70ca301590b4832c406e5".equals( abntype) ) {
				flag = app.LeaveCancelToSAP( requestid, force );
			} else {
				flag = app.OTTRCancelToSAP( requestid, force );
			}		
			
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
%>
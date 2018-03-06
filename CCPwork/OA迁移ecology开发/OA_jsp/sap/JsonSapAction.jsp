<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.ConfigSapAction"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("tosap")){
		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		JSONObject jo = new JSONObject();
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String id=StringHelper.null2String(request.getParameter("id"));
		String tablename=StringHelper.null2String(request.getParameter("tablename"));
		String fieldname=StringHelper.null2String(request.getParameter("fieldname"));
		ConfigSapAction c = new ConfigSapAction();
		try {
			c.syncSap(id, requestid);
			jo.put("msg","true");
			Date currentTime = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			String dateString = formatter.format(currentTime);
			baseJdbcDao.update("update uf_lo_budget set zguploadingdae = '"+ dateString +"' where requestid ='"+ requestid +"'");
		} catch (Exception e) {
			jo.put("msg","false");
			e.printStackTrace();
		}
		
		//更新saperror表的msgty
		if(tablename.length()>1){
			BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
			String upsql = "update saperror set msgty=(select "+fieldname+" from "+tablename+" where requestid='"+requestid+"') where reqid='"+requestid+"'";
			baseJdbc.update(upsql);
		}
				
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

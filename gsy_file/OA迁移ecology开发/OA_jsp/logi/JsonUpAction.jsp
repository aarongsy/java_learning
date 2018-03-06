<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%><%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.app.weight.service.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.logi.LogiSendCarAction"%>
<%@ page import="java.util.List"%><%@ page import="java.util.Map"%>
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
<%@ page import="com.eweaver.app.logi.LoadPublicService"%>
<%@ page import="com.eweaver.app.weight.service.DontWeigh_logs"%>
<%@page import="com.sun.xml.internal.ws.message.StringHeader"%>
<%
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
    String lastDay = StringHelper.null2String(request.getParameter("lastDay"));
    String objid = StringHelper.null2String(request.getParameter("objid"));
	response.setContentType("application/json; charset=utf-8");
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	if (!"".equals(requestid)){
		baseJdbcDao.update("update uf_lo_provedoc set printtime = '"+ lastDay +"',printman = '"+ objid +"', printnum = nvl(printnum,0)+1 where requestid = '"+ requestid +"'");
	}
%>

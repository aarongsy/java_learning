<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.ConfigSapAction"%>
<%
	String reqids = StringHelper.null2String(request.getParameter("requestid"));
	BaseJdbcDao daseDB = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	daseDB.update("update uf_lo_budget set invoicestatue = '40285a8d4d5b981f014d64e5ed544f17' where requestid = '"+reqids+"' ");
%>

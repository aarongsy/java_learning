<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.humres.base.model.Humres" %><%
	String toUrl= request.getParameter("toUrl");
	String tabName= request.getParameter("tabName");
	String keyCol= request.getParameter("keyCol");
	String relationCol= request.getParameter("relationCol");
	String id= request.getParameter("mid");
	DataService ds = new DataService();
	toUrl=toUrl+"&mid="+id+"&sqlstr="+tabName+" where requestid&id="+StringHelper.null2String(ds.getValue("SELECT "+keyCol+"  FROM "+tabName+" WHERE "+relationCol+"='"+id+"'"));
	response.sendRedirect(toUrl);
%>
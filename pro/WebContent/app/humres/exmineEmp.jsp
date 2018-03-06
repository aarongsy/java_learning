<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.humres.base.model.Humres" %><%
	String exmman= request.getParameter("exmman");
	String exmyear= request.getParameter("exmyear");
	String exmyearhalf= request.getParameter("exmyearhalf");
	EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
	String userid=eweaveruser1.getId();
	DataService ds = new DataService();
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.base.menu.servlet.ExtFormAction?categoryid=8a80869c21e25a8f0121e2a3f94a006e&sqlstr=uf_hrm_examine where requestid&id="+StringHelper.null2String(ds.getValue("SELECT requestid FROM uf_hrm_examine WHERE exmman='"+exmman+"' and exmyear='"+exmyear+"' and exmyearhalf='"+exmyearhalf+"' and manager='"+userid+"'"))+"&exmman="+StringHelper.null2String(exmman)+"&exmyear="+StringHelper.null2String(exmyear)+"&exmyearhalf="+StringHelper.null2String(exmyearhalf)+"&manager="+StringHelper.null2String(userid));
%>
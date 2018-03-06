<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.ConfigSapAction"%>
<%
	String plates = Util.null2String(request.getParameter("plates"));
	StringBuffer sbf = new StringBuffer();
	String fhz = "0";
	BaseJdbcDao daseDB =(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	if(!"".equals(plates)){
		daseDB.update("update uf_lo_ladingmain set status = '40285a8d4d5b981f014d6a12a9ec0009' where ladingno = '"+plates+"' ");	
		fhz = "1";
	}
	sbf.append(fhz);
	//out.print(sbf.toString());
	response.getWriter().print(buf.toString());
	return;
%>

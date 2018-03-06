<%@ page language="java" contentType="application/xml" pageEncoding="GBK"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
	
	WebServiceData graphxmlData = pluginService.getWorkflowGraphXml(null, requestid,workflowid);
	String graphxml = (String)graphxmlData.getMainData().get("GRAPHXML");
	response.setContentType("application/xml; charset=utf-8");
	response.getWriter().write(graphxml);
	response.getWriter().flush();
	response.getWriter().close();
%>
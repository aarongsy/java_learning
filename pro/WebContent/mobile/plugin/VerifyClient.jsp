<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
    HumresService humresService = (HumresService)BaseContext.getBean("humresService");
    String client = StringHelper.null2String(request.getParameter("client"));
	String loginId = StringHelper.null2String(request.getParameter("loginid"));
	String password = StringHelper.null2String(request.getParameter("password"));
	List auths = new ArrayList();
	ServiceUser user = new ServiceUser();
	user.setLoginName(loginId);
	WebServiceData webData = pluginService.checkLicense(user);
	JSONObject jo = new JSONObject();
	if(webData!=null) {
	    ServiceStatus serviceStatus = webData.getStatus();
	    if(serviceStatus == ServiceStatus.LICENSE_IS_OK) {
	    	//jo = JSONObject.fromObject(result);
	    	jo.put("message","10");			      						
	    } else {
	        jo.put("message","11");
	    }		
	} else {
	    jo.put("message","12");
	}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

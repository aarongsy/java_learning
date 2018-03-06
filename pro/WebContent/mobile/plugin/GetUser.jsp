<%@ page language="java" contentType="application/json" pageEncoding="utf-8"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	String id = StringHelper.null2String(request.getParameter("sessionkey"));
	if(!StringHelper.isEmpty(id)) {	
		Map jresult = new HashMap();	
		WebServiceData webServiceData = pluginService.getMyHumresNameByUserid(id);
		jresult = webServiceData.getMainData();	
		if(jresult!=null) {
			//JSONObject jo = JSONObject.fromObject(result);
			JSONObject result = new JSONObject();
			result.put("id", jresult.get("ID"));
			result.put("name", jresult.get("OBJNAME"));
			result.put("dept", jresult.get("ORGID"));
			//result.put("subcom", subcom);
			result.put("jobtitle", jresult.get("MAINSTATION"));
			result.put("manager", jresult.get("MANAGER"));
			result.put("sex", jresult.get("GENDER"));
			result.put("status", jresult.get("HRSTATUS"));
			result.put("location", jresult.get("OFFICEADDR"));
			result.put("headerpic", jresult.get("IMGFILE"));
			result.put("email", jresult.get("EMAIL"));
			result.put("telephone", jresult.get("TEL2"));
			result.put("mobile", jresult.get("TEL2"));
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(result.toJSONString());
			response.getWriter().flush();
			response.getWriter().close();
			//out.println(result);
		}
	}
%>
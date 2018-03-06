<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%    
    if(StringHelper.isEmpty(BaseContext.getHttpbasepath())) {
    	String basePath2 = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
		BaseContext.setHttpbasepath(basePath2);
    } 
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	MultipartRequest multiRequest = new MultipartRequest(request,".","UTF-8"); 
	String loginId = StringHelper.null2String(multiRequest.getParameter("loginid"));
	String password = StringHelper.null2String(multiRequest.getParameter("password"));
	String ipaddress = StringHelper.null2String(multiRequest.getParameter("ipaddress"));
	
	WebServiceData webData = pluginService.checkLoginUser(loginId,password);
	Map result = webData.getMainData();
	JSONObject jo = null;
	if(result!=null) {
	    ServiceStatus serviceStatus = webData.getStatus();
	    if(serviceStatus == ServiceStatus.LICENSE_IS_OK) {
	    	jo = JSONObject.fromObject(result);
	    	if("sysadmin".equalsIgnoreCase(loginId)) {
	    		jo.put("message","1");
	    		jo.put("sessionkey",jo.get("ID"));	    	
				out.println(jo);
	    	} else {
	    	    jo.clear();
	    	    jo.put("message","10");	    	    
	    	    out.println(jo);
	    	}	    				
	    } else {
	        String message = "";
	        if(serviceStatus == ServiceStatus.USER_PASSWORD_ERROR) {
	        	message ="102";
	        } else if(serviceStatus == ServiceStatus.USER_NOT_EXIST) {
	            message = "104";
	        } else if(serviceStatus == ServiceStatus.LICENSE_IS_MORE_MAX_NUM_OF_USERS) {
	            message = "003";
	        } else if(serviceStatus == ServiceStatus.LICENSE_IS_INVALID) {
	            message = "004";
	        } else {
	            message = "110";
	        }
	        jo = new JSONObject();
	        jo.put("message",message);
	        out.println(jo);
	    }		
	} else {
		jo = new JSONObject();
	    jo.put("message","105");
	    out.println(jo);
	}
%>

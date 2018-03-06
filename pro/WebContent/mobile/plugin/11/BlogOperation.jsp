<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%
MultipartRequest fu = new MultipartRequest(request,".","UTF-8");
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
Map<String,Object> param=new HashMap<String, Object>();
System.out.println("workdate:"+fu.getParameter("workdate")); 
//获取所有请求参数
Enumeration enu=fu.getParameterNames();
while(enu.hasMoreElements()){
	String paraName=(String)enu.nextElement();
	String value=fu.getParameter(paraName);
    
	if(!paraName.equals("request")&&!paraName.equals("response")&&!paraName.equals("sessionkey"))
		param.put(paraName, value);
}
System.out.println(param);
out.print(pluginService.getBlogJson(param));
%>
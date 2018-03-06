<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ include file="/base/init.jsp"%>
<%
String categoryid = request.getParameter("categoryid");
if( categoryid!=null && !"".equals(categoryid) && categoryid.length() >=32){
	//System.out.println("------"+categoryid);
	PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
	boolean isauth = permissiondetailService.checkOpttype(categoryid,2);
	if(isauth){
		response.getWriter().print("1");
	}else{
		response.getWriter().print("0");
	}
}else{
	response.getWriter().print("0");
}
%>
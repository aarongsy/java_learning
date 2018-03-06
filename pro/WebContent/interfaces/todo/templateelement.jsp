<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.treeviewer.service.TemplateEngine"%>
<%@ include file="/base/init.jsp"%>
<%
String viewerid=StringHelper.null2String(request.getParameter("viewerid"));
if(!StringHelper.isEmpty(viewerid)){
	TemplateEngine templateEngine=new TemplateEngine(request,out);
	templateEngine.parseTemplate(viewerid,"");
}else{
	out.println("请联系管理员，设置Portlet.view视图");
}
%>

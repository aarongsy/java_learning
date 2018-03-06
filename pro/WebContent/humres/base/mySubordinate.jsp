<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" type="text/javascript" src="/js/weaverUtil.js"></script>
<title><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a001e")%> </title><!-- 我的下级 -->

</head>

<body>
<%
String viewerId = StringHelper.null2String(request.getParameter("id"));
if(viewerId.equalsIgnoreCase(""))viewerId=StringHelper.null2String(request.getQueryString());
String userId = StringHelper.null2String(request.getParameter("userId"));
String level=StringHelper.null2String(request.getParameter("level"));
if("".equals(level)){
	level="2";
}
if(!viewerId.equals("")){
	if(userId.equalsIgnoreCase("")) userId=currentuser.getId();
	String sUrl=request.getContextPath()+"/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?viewerId="+viewerId+"&rootId="+userId+"&level="+level+"&height=140&width=120";
	response.sendRedirect(sUrl);
}
%>
</body>
</html>

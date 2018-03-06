<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="/base/init.jsp"%>

<%	
	request.getSession(true).removeValue("eweaverusermoniter") ;
	request.getSession(true).removeValue("eweaver_user@bean") ;
	request.getSession(true).invalidate() ;
	BaseContext.killRemoteUser();
%>
<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000b") %> <!-- 关闭窗口，清除登录信息... -->
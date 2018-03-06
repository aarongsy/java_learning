<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.interfaces.ecology.service.EcologySyncService" %>

<%

EcologySyncService ecologySyncService = (EcologySyncService) BaseContext.getBean("ecologySyncService");
ecologySyncService.syncDaily();

%>
hellow wold!
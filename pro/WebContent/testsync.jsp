<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ page import="com.eweaver.interfaces.orgsync.*" %>
<%@ page import="com.eweaver.base.security.service.logic.*" %>
<% 
out.println("执行开始!");
ThirdSysOrgSync thirdSysOrg = new ThirdSysOrgSync();
thirdSysOrg.sync();
out.println("执行完毕!");
%>

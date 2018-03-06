<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ page import="com.eweaver.interfaces.docsync.*" %>
<% 
out.println("执行开始!");
ThirdSysDocSync thirdDocOrg = new ThirdSysDocSync();
thirdDocOrg.sync();
thirdDocOrg.syncdocbase();
out.println("执行完毕!");
%>

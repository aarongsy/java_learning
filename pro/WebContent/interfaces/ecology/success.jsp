<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780004")%><!-- 登陆正常 --></title>
</head>
<body style="padding:0;margin:0">
<a href="/main/main.jsp" target="_blank">
<img src='img1.gif' width='18' height='18' border=0  alt='<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780005")%>' /><!-- EWeaver登陆正常 -->
</a>
</body>
</html>
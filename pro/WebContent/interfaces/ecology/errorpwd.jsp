<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<head>
<title><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780000")%><!-- 密码不正确 --></title>
</head>
<body style="padding:0;margin:0">
<img src='img7.gif' width='18' height='18' border=0  alt='<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780001")%>' /><!-- EWeaver密码不正确 -->
</body>
</html>
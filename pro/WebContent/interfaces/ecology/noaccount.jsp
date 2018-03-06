<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<head>
<title><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780002")%><!-- 无账号 --></title>
</head>
<body style="padding:0;margin:0">
<img src='img4.gif' width='18' height='18' border=0  alt='<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780003")%>' /><!-- EWeaver账号不存在 -->
</body>
</html>
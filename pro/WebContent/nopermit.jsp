<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService"); %>
<%response.setStatus(200); %>
<html><head><title><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001c") %><!-- 没有权限 --></title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
</head>
<body>
<h5><img src="/images/base/icon_nopermit.gif" align="absmiddle" /><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001d") %> <!-- 对不起！您暂时没有权限，请与系统管理员联系。 --></h5>
</body>
</html>

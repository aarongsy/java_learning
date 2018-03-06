<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService"); %>
<%response.setStatus(200); %>
<html><head><title>系统授权许可无效 <!-- 没有权限 --></title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
</head>
<body>
<h5><img src="/images/base/icon_nopermit.gif" align="absmiddle" />对不起！系统授权许可无效或超出许可范围，请联系系统管理员。 <!-- 对不起！您暂时没有权限，请与系统管理员联系。 --></h5>
</body>
</html>

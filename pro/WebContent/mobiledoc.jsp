<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService"); %>
<%response.setStatus(200); %>
<html><head><title>不能新建公文流程</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
</head>
<body>
<h5><img src="/images/base/icon_nopermit.gif" align="absmiddle" />对不起！手机版中不允许新建公文流程！ </h5>
</body>
</html>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*,com.eweaver.base.util.VtlEngineHelper,java.io.*" %>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.service.TemplateEngine"/>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
<title>显示编辑后的页面布局</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';

</script>
<style>
ul li ol{margin-left:10px;}
</style>
</head>

<body>
<c:out value="${info}" escapeXml="false"/>
</body>
</html>

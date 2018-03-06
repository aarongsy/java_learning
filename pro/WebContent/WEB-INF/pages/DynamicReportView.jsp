<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,com.eweaver.base.util.VtlEngineHelper,java.io.*" %>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.service.TemplateEngine"/>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<!--%@ include file="/base/init.jsp"%-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><c:out value="${viewer.title}"/> - 动态报表</title>
<!-- 
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
 -->
<script type="text/javascript">


</script>
<style>
ul li ol{margin-left:10px;}
/*table{width:auto;}*/
button.field{background-color:transparent;font-size:9pt;height:18px;border:1px solid #333333;};
table.report{border-collapse:collapse;border:1px solid #0000FF;}

Table.tbRed,Table.tbRed td{border:1px solid #FF0000;}
Table.tbGreen,Table.tbGreen td{border:1px solid #0000FF;}
Table.tbBlue,Table.tbBlue td{border:1px solid #00EE00;}

Td.tdRed{border:1px solid #FF0000 !important;}
Td.tdGreen{border:1px solid #0000FF !important;}
Td.tdBlue{border:1px solid #00EE00!important;background-color:#999966}

Td.noBorder{border-width:0px !important;}
Td.noTop{border-top:0px solid #FFFFFF !important;}
Td.noRight{border-right-width:0px !important;}
Td.noBottom{border-bottom-width:0px !important;}
Td.noLeft{border-left:1px solid #FFFFFF !important;}
</style>
</head>

<body>
<h2>动态报表解析页面</h2>
<div id="content" style="border:1px solid green;padding:5px;">
<c:out value="${reportHtml}" escapeXml="false"/>
</div>
</body>
</html>

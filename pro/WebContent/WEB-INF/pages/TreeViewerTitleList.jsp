<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eweaver.css" />

<script language="javascript" type="text/javascript">
WeaverUtil.isDebug=false;
</script>
</head>
<body>
<form action="#">
<table width="400" align="center" cellpadding="0" cellspacing="0">
<tr style="background-color:#CCC;"><td width="100">&nbsp;</td><td>标题</td></tr>
<c:forEach var="t" items="${list1}" varStatus="s">
<tr><td width="100">&nbsp;</td><td>
<label for='id<c:out value="${s.index}"/>'>
<input type="radio" id='id<c:out value="${s.index}"/>' name="id" value='<c:out value="${t.id}"/>'/>
<input type="hidden" name='title<c:out value="${t.id}"/>' value='<c:out value="${t.title}"/>'/>
<c:out value="${t.title}"/>
</label>
</td></tr>
</c:forEach>
</table>
</form>
</body>
</html>

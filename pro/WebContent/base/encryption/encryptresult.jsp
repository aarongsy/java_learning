<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%
	String errorMsg = StringHelper.null2String(request.getParameter("errorMsg"));
	String action = StringHelper.null2String(request.getParameter("action"));
	int size = NumberHelper.getIntegerValue(request.getParameter("size"),0).intValue();
%>
<html>
<head>
    <style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
 </style>

 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
</head>
<div id="pagemenubar"> </div>
<body>
	<%if(StringHelper.isEmpty(errorMsg) ){ %>
    	<h2 align="center">已更新<%=size %>条数据</h2>
    <%}else{
    	%>
    	<h2 align="center">操作失败，异常：<%=errorMsg %></h2>
    	<%
    } %>
</body>
</html>
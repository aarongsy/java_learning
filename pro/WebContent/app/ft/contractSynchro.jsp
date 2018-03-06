<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.customaction.ft.ContractSynchro"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<body>
<center>
<body>
<%
ContractSynchro contractSynchro=new ContractSynchro();
String throwstr=contractSynchro.DoExcute();
%>
<form id="EweaverForm" name="EweaverForm" action="/app/ft/contractSynchro.jsp" target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
<div id="searchDiv"  >
<div id="pagemenubar"></div> <br>
<div style="width:60%">
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #ADADAD solid">
<colgroup>
<col width="100%"/>
</colgroup>
	<tr>
	<td class="FieldName">
	<div id="message">
	<%=throwstr%>
	</div>
	</td>
	</tr>
	</table>
	</div>
</div>
</body>
</html>


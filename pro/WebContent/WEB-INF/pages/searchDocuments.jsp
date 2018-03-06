<%@ page language="java" contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=request.getContextPath() %>/css/eweaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath() %>/js/weaverUtil.js"></script>
<script language="javascript" type="text/javascript">
function searchText(){
	var key=document.getElementById("key").value;
	if(key==""){
		window.alert('关键字不能为空!');
	}else document.getElementById('frm1').submit();
}
function _init(){
	document.getElementById("key").focus();
}
WeaverUtil.load(_init);
</script>

</head>
<body>
<form method="get" name="frm1" id="frm1" action="<%=request.getContextPath() %>/ServiceAction/com.eweaver.search.servlet.SearchDocumentAction">
<p>&nbsp;</p>
<p>&nbsp;</p>
<table width="716" border="0" align="center">
<tr>
    <td width="311" align="right"><img src="/images/tu44.gif" width="70" height="80" border="0" alt="weaver"/></td>
    <td width="389" align="left">
<font size="7"><b>全文检索</b></font></td></tr>
<tr><td class=field colSpan=5 align="center">
	<input class="InputStyle" size=70 name="key" id="key"/><input type="button" onclick="searchText()" value="搜索"/>
</td></tr>
</table>
</form> 


</body></html>

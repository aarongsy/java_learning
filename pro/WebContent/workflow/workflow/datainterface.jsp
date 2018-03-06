<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.io.*" %>

<html>
<head>  
</head>
  
<body>


<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSave()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:onDelete()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:onBack()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>


<table width=100%  height=500>
<COLGROUP>
   <COL width="100%">
<tr>
	<td width=100% height=100%>
		<textarea id='content' name="content" style="width:100%;height:100%"></textarea>
	</td>
</tr>
</table>


<script language="javascript">
if(window.dialogArguments)
document.getElementById('content').value= window.dialogArguments;
function onSave()
{
   window.returnValue=document.getElementById('content').value;
   window.close(); 
}
function onDelete()
{
   window.returnValue='';
   window.close();

}
function onBack(){
window.close();
}
</script>
</body>
</html>

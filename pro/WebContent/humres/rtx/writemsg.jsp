<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String id = StringHelper.null2String(request.getParameter("id"));
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
Humres humres = humresService.getHumresById(id);
String user="";
String receiver="";
if(humres!=null){
user=humres.getObjname();
receiver=humres.getRtxNo();
}
%>
<html>
<head>
<title><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0048")%></title><!-- 发送消息 -->

</head>
<body>
<!--页面菜单开始-->
<%pagemenustr += "{S,"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0049")+",javascript:sendMsg()}";%><!-- 发送 -->
<%pagemenustr += "{C,"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")+",javascript:cancel()}";%><!--取消  -->
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.msg.rtx.RTXAction" method="post" name="EweaverForm" >
<input type="hidden" name="sender" value="<%=currentuser.getRtxNo()%>">
<input type="hidden" name="receiver" value="<%=receiver%>">
<table width="100%">
  <tr>
    <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%>：</td><!-- 姓名 -->
    <td class="FieldValue"><%=user%></td>
  </tr>
  <tr>
    <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f004a")%>：</td><!-- RTX账号 -->
    <td class="FieldValue"><%=receiver%></td>
  </tr>
  <tr>
    <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f004b")%>：</td><!--信息内容  -->
    <td class="FieldValue"><textarea name="msg" cols="45" rows="5"></textarea></td>
  </tr>
</table>
</form>
</body>
<script language="javascript">
function sendMsg(){
	document.EweaverForm.submit();
	window.close();
}
function cancel(){
	window.close();
}
</script>
</html>


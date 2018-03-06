<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<style>
<!--
.x-window-footer table,.x-toolbar table{width:auto;}
-->
</style>
<script type="text/javascript">
var topBar=null;
Ext.onReady(function(){
	var div=document.createElement("div");
	div.id="pagemenubar";
	Ext.getBody().insertFirst(div);
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")%>','S','accept',function(){//保存
		if(Ext.isEmpty(Ext.getDom('startDate').value)){
			alert('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379002b")%>');//上班时间不能为空!
			Ext.getDom('startDate').focus();
			return;
		}
		if(Ext.isEmpty(Ext.getDom('endDate').value)){
			alert('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379002c")%>');//下班时间不能为空!
			Ext.getDom('endDate').focus();
			return;
		}
		document.form1.submit();
	});
});

</script>
</head>

<body>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.attendance.servlet.AttendanceAction?action=setting" method="post" name="form1" id="form1">
<table width="500" border="0">
<colgroup>
<col width="150"/>
<col width="*"/>
</colgroup>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379002d")%>:<!-- 工具条是否显示签到按钮 --></td><td class="FieldValue"><input name="viewAttendbtn" type="checkbox" value="1" <c:if test="${viewAttendbtn}">checked</c:if>/></td></tr>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379002e")%>:<!-- 是否自动显示签到确认框 --></td><td class="FieldValue"><input name="autoAttend" type="radio" value="1" <c:if test="${autoAttend}">checked</c:if>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>&nbsp;&nbsp;&nbsp;
<input name="autoAttend" type="radio" value="0" <c:if test="${not autoAttend}">checked</c:if> /><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
</td></tr>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379002f")%>:<!-- 上班时间1 --></td><td class="FieldValue"><input id="startDate" name="startDate" value="<c:out value="${startDate}"/>"/>
&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790030")%>:<!-- 上班时间2 --><input id="startDate2" name="startDate2" value="<c:out value="${startDate2}"/>"/>
</td></tr>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790031")%>:<!-- 下班时间1 --></td><td class="FieldValue"><input id="endDate" name="endDate" value="<c:out value="${endDate}"/>"/>
&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790032")%>:<!-- 下班时间2 --><input id="endDate2" name="endDate2" value="<c:out value="${endDate2}"/>"/>
</td></tr>
</table>
</form>
</body>
</html>
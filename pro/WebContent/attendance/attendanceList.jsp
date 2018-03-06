<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/main.js"></script>

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<style>
<!--
.x-window-footer table,.x-toolbar table{width:auto;}
-->
</style>
<script type="text/javascript">
function query(btn){
	alert('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790028")%>');//查询．．．
	document.form1.submit();
}
Ext.onReady(function(){
	var div=document.createElement("div");
	div.id="pagemenubar";
	Ext.getBody().insertFirst(div);
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000")%>','S','accept',query);
});

function getrefobj(inputname,bid){
	var ret=0;
	var url="/base/refobj/baseobjbrowser.jsp?id="+bid;
	var id = openDialog("/base/popupmain.jsp?url="+encodeURIComponent(url));
	var isCheck=false;
	var inputspan=inputname+'Span';

	if(typeof(id)!='undefined'){
		if(Object.prototype.toString.apply(id) === '[object Array]'&&id[0]!="0"){
			$(inputname).value =id[0];
			$(inputspan).innerHTML =id[1];
		}else{
			$(inputname).value = "";
			$(inputspan).innerHTML =(isCheck)?"<img src=/images/base/checkinput.gif>":"";
		}
	}
}//end fun.
</script>
</head>

<body>
<form action="#" name="form1" id="form1" method="post">
<table width="100%" border="0">
<colgroup>
<col width="200"/><col width="*"/>
</colgroup>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fcf6370000a")%><!-- 开始日期 --></td><td class="FieldValue"><input  id="startDate" name="startDate"  value="<c:out value="${startDate}"/>"/></td></tr>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd00c46000c")%><!-- 结束日期 --></td><td class="FieldValue"><input id="endDate"  name="endDate" value="<c:out value="${endDate}"/>"/></td></tr>
<tr><td class="FieldName"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980020")%><!-- 人员 --></td><td class="FieldValue">
<button  class=Browser type=button onclick="getrefobj('hrmid','402881e70bc70ed1010bc75e0361000f');"></button>
<input type="hidden" id="hrmid" name="hrmid" value="<c:out value="${hrmid}"/>" >
<span id="hrmidSpan" name="hrmidSpan"><c:out value="${hrmname}"/></span>
</td> 
</td></tr>
</table>
</form>
<br/>
<table border="1" style="border-collapse:collapse;" bordercolor="#CCCCCC">
<tr><td colspan="3"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790029")%><!-- 工作日天数 -->:<c:out value="${workdayCount}"/></td>
</tr>
<tr height="20"><td>&nbsp;</td><td>&nbsp;</td><td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379002a")%><!-- 迟到天数 --></td></tr>
<tr><td>&nbsp;</td><td>&nbsp;</td><td><c:out value="${nDays}"/></td></tr>
</body>
</html>
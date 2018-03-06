<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
	<link rel="stylesheet" href="/css/eweaver.css" type="text/css">
</head>
<body>
<table width="100%" height="100%">
	<tr height=100% >
	<td width="2" align=left valign=middle>
    <IMG id=LeftHideShow name=LeftHideShow  style="CURSOR: hand"  src="images/show.gif" width=6 onclick=mnToggleleft()>
    </td>
	<td id=oTd2 name=oTd2 width=98% valign=top>
       <IMG id=LeftHideShow name=LeftHideShow title="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0014") %>" style="CURSOR: hand"  src="images/welcome.gif"  onclick=mnToggleleft()><!-- 欢迎进入协作 -->
    </td>
	</tr>
</table>
</body>
<SCRIPT language=javascript>
function mnToggleleft(){
	with(window.parent.document.getElementById("frameBottom")){
		if(cols == '0,100%'){
			cols = '30%,70%';
			window.document.getElementById("LeftHideShow").src = "images/show.gif";
			window.document.getElementById("LeftHideShow").title = ''
		}else{
			cols = '0,100%';
			window.document.getElementById("LeftHideShow").src = "images/hide.gif";
			window.document.getElementById("LeftHideShow").title = ''
		}
	}
}

</SCRIPT>
</html>
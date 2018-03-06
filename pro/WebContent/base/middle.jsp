<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<title></title>

<SCRIPT language=javascript>
function mnToggleleft(){
	var len = window.parent.document.all("oTd2").length;
	if(typeof len=="undefined"){
				var f = window.parent.document.all("oTd2").style.display;
			if (f != null) {
				if (f=='') 
					{window.parent.document.all("oTd2").style.display='none'; LeftHideShow.src = "<%= request.getContextPath()%>/images/main/show.gif"; LeftHideShow.title = '显示'}
				else 
					{ window.parent.document.all("oTd2").style.display=''; LeftHideShow.src = "<%= request.getContextPath()%>/images/main/hide.gif"; LeftHideShow.title = '隐藏'}
			}
	}else{
	for(i=0;i<len;i++){
		var f = window.parent.document.all("oTd2")[i].style.display;
		if (f != null) {
			if (f=='') 
				{window.parent.document.all("oTd2")[i].style.display='none'; LeftHideShow.src = "<%= request.getContextPath()%>/images/main/show.gif"; LeftHideShow.title = '显示'}
			else 
				{ window.parent.document.all("oTd2")[i].style.display=''; LeftHideShow.src = "<%= request.getContextPath()%>/images/main/hide.gif"; LeftHideShow.title = '隐藏'}
		}
	}
	}
}

</SCRIPT>
</head>

<body bgcolor="white" onclick=mnToggleleft() >

<script>
</script>
<table width="100%" style="border-right:0;border-bottom:0;border-top:0" cellspacing="0" cellpadding="0" height="100%">
 <td width="6" align=left valign=center >
    <IMG id=LeftHideShow name=LeftHideShow title=隐藏 style="CURSOR: hand"  src="<%= request.getContextPath()%>/images/main/show.gif" width=6>
    </td>
</table>
</body>
</html>
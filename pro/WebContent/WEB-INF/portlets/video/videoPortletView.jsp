<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<form name="form_<c:out value="${requestScope.responseId}"/>">
<input type='hidden' name='pvNumber' value='<c:out value="${requestScope.currentNumber}"/>'/>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-center' width='100%'>
<a href="javascript:void(0);" onclick="javascript:previousVideo('<c:out value="${requestScope.responseId}"/>');"><img src='light/images/previous.gif' style='border: 0px' /></a>						
<a href="javascript:void(0);" onclick="javascript:nextVideo('<c:out value="${requestScope.responseId}"/>');"><img src='light/images/next.gif' style='border: 0px' /></a>
</td>
</tr>

<tr>
<td class='portlet-table-td-center' width='100%'>
<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
WIDTH="300" HEIGHT="250" style='text-align: center;' >
<PARAM NAME='movie' VALUE='<c:out value="${requestScope.currentLink}"/>'/>
<PARAM NAME='quality' VALUE='high'/>
<PARAM NAME='bgcolor' VALUE='#FFFFFF'/>
<EMBED src='<c:out value="${requestScope.currentLink}"/>' quality='high' bgcolor='#FFFFFF' WIDTH="300" HEIGHT="250"
 ALIGN="" TYPE="application/x-shockwave-flash"
PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer">
</EMBED>
</OBJECT>
</td>
</tr>
</table>
</form>
</body>
</html>
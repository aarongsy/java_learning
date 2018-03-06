<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
<script language="JavaScript" src="<%= request.getContextPath() %>/light/scripts/notePortlet.js"></script>
</head>
<body>
<form name="form_<c:out value="${requestScope.responseId}"/>">
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>
<textarea name='content'
style='border-width:0px;width:100%;overflow:visible;background:<c:out
value="${requestScope.portlet.contentBgColor}"/>; color:<c:out
value="${requestScope.note.color}"/>;'
 rows='<c:out value="${requestScope.note.height}"/>' cols='<c:out
value="${requestScope.note.width}"/>'
 onChange="javascript:saveNote('<c:out
value="${requestScope.responseId}"/>')"
onkeyup="javascript:changeNoteRow(event,'<c:out
value="${requestScope.responseId}"/>')">
<c:out value="${requestScope.note.displayContent}"/>
</textarea>

</td>
</tr>
</table>
</form>
</body>
</html>
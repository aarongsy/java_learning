<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form action="<portlet:actionURL portletMode='EDIT'/>">
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.url"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='url' class='portlet-form-input-field' size='24' />
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.name"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='urlName' class='portlet-form-input-field' size='24'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-right' colspan ='2'>
<input type='submit' name='action' onClick="document.pressed='add'" value='<fmt:message key="portlet.button.add"/>' class='portlet-form-button' />
</td>
</tr>
</table>
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>
<select name='engineName' size='5' class='portlet-form-select'>
<c:forEach var="engine" items="${requestScope.searchEngine}" >
<option value='<c:out value="${engine.name}"/>'><c:out value="${engine.name}"/></option>
</c:forEach>
</select>
</td>
</tr>
<tr>
<td class='portlet-table-td-right'>
<input type='submit' name='action' onClick="document.pressed='delete'" value='<fmt:message key="portlet.button.delete"/>' class='portlet-form-button' />
</td>
</tr>
</table>
</form>
</fmt:bundle>
</body>
</html>
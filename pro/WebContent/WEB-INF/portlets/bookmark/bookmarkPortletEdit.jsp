<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<c:if test='${requestScope.success != null}'>
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-msg-success' >
<c:out value="${requestScope.success}"/>
</td>
</tr>
</table>
</c:if>
<c:if test='${requestScope.error != null}'>
<br/>
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-msg-error' >
<c:out value="${requestScope.error}"/>
</td>
</tr>
</table>
</c:if>
<form name="<portlet:namespace/>bookmark" action="<portlet:actionURL portletMode='EDIT'/>">
<c:if test='${bookmark == null}'>
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.url"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='url' class='portlet-form-input-field' size='30' />
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.name"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='name' class='portlet-form-input-field' size='30'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.desc"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='desc' class='portlet-form-input-field' size='30'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.tag"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='tag' class='portlet-form-input-field' size='30'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-right' colspan ='2'>
<input type='submit' name='action' onClick="document.pressed='add'" value='<fmt:message key="portlet.button.add"/>' class='portlet-form-button' />
<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
</td>
</tr>
</table>
</c:if>

<c:if test='${bookmark != null}'>
<input type='hidden' name='bookmarkId' value='<c:out
value="${bookmark.id}"/>' />
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.url"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='url' class='portlet-form-input-field' size='30' value='<c:out value="${bookmark.url}"/>' />
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.name"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='name' class='portlet-form-input-field' size='30' value='<c:out value="${bookmark.name}"/>'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.desc"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='desc' class='portlet-form-input-field' size='30' value='<c:out value="${bookmark.desc}"/>'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<fmt:message key="portlet.label.tag"/>:
</td>
<td class='portlet-table-td-left'>
<input type='hidden' name='tagId' value='<c:out value="${bookmark.tagName}"/>'/>
<input type='text' name='tag' class='portlet-form-input-field' size='30' value='<c:out value="${bookmark.tagNameValue}"/>'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-right' colspan ='2'>
<input type='submit' name='action' onClick="document.pressed='modify'" value='<fmt:message key="portlet.button.save"/>' class='portlet-form-button' />
<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
</td>
</tr>
</table>
</c:if>
</form>
</fmt:bundle>
</body>
</html>
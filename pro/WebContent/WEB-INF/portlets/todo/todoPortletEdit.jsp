<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form action="<portlet:actionURL portletMode='EDIT'/>">           
	<table border='0' cellpadding='0' cellspacing='0'>
		<c:if test='${requestScope.missingField != null}'>
			<tr>
			<td class='portlet-table-td-left' colspan='2'>
			Name and description are required fields.
			</td>
			</tr>
		</c:if>
		<tr>
		<td class='portlet-table-td-left'>
		<fmt:message key="portlet.label.todo"/>:
		</td>
		<c:if test="${requestScope.todo.status !=0}">
		<td class='portlet-table-td-left' style="text-decoration: underline line-through;">
		<input type='text' name='name' class='portlet-form-input-field' size='24' value='<c:out value="${requestScope.todo.name}"/>'/>
		</c:if>
		<c:if test="${requestScope.todo.status ==0}">
		<td class='portlet-table-td-left'>
		<input type='text' name='name' class='portlet-form-input-field' size='24' value='<c:out value="${requestScope.todo.name}"/>'/>
		</c:if>
		<INPUT TYPE='hidden' NAME="id" value='<c:out value="${requestScope.todo.id}"/>' />
		</td>
		</tr>
		<tr>
		<td class='portlet-table-td-left'>
		<fmt:message key="portlet.label.priority"/>:
		</td>
		<td class='portlet-table-td-left'>
		<select name='priority' size='1'  class='portlet-form-select'>
		<c:forEach var="i" begin="1" end="10" step="1">
		<c:if test='${requestScope.todo.priority == i}'>
		<option selected='selected' value='<c:out value="${i}" />'><c:out value="${i}" /></option>
		</c:if>
		<c:if test='${requestScope.todo.priority != i}'>
		<option value='<c:out value="${i}" />'><c:out value="${i}" /></option>
		</c:if>
		</c:forEach>
		</select>
		</td>
		</tr>
		<tr>
		<td class='portlet-table-td-left'>
		<fmt:message key="portlet.label.description"/>:
		</td>
		<td class='portlet-table-td-left'>
		<textarea name='description' class='portlet-form-textarea-field' rows='5' cols='25' onfocus="javascript:this.select();"><c:out value="${requestScope.todo.description}"/></textarea>
		</td>
		</tr>						
		<tr>
		<td class='portlet-table-td-right' colspan ='2'>
		<input type='submit' name='action' onClick="document.pressed='save'" value='<fmt:message key="portlet.button.save"/>' class='portlet-form-button' />
		<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
		</td>
		</tr>
	</table>		
</form>
</fmt:bundle>
</body>
</html>
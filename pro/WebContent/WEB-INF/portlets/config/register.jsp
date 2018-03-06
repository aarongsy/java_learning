<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form name="form_<c:out value="${requestScope.responseId}"/>">
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>*<fmt:message key="portlet.label.userId"/>: </td>
<td class='portlet-table-td-left'>
<input type='text' name='plUserId' value='' class='portlet-form-input-field' size='18' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>*<fmt:message key="portlet.label.userPassword"/>: </td>
<td class='portlet-table-td-left'>
<input type='password' name='plPassword' value='' class='portlet-form-input-field' size='18' />	
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>*<fmt:message key="portlet.label.confirmPassword"/>:</td>
<td class='portlet-table-td-left'>
<input type='password' name='plConfirmPassword' value='' class='portlet-form-input-field' size='18' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>*<fmt:message key="portlet.label.firstName"/>: </td>
<td class='portlet-table-td-left'>
<input type='text' name='plFirstName' value='' class='portlet-form-input-field' size='18' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'><fmt:message key="portlet.label.middleName"/>: </td>
<td class='portlet-table-td-left'>
<input type='text' name='plMiddleName' value='' class='portlet-form-input-field' size='18' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>*<fmt:message key="portlet.label.lastName"/>: </td>
<td class='portlet-table-td-left'>
<input type='text' name='plLastName' value='' class='portlet-form-input-field' size='18' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'><fmt:message key="portlet.label.email"/>: </td>
<td class='portlet-table-td-left'>
<input type='text' name='plEmail' value='' class='portlet-form-input-field' size='18' /> 
</td>
</tr>
<tr>
<td/>
<td class='portlet-table-td-left'>
<input TYPE='checkbox' name='plShowLocale'  value='1'>Show Change Locale Box</input>
</td>
</tr>
</table>

<table border='0' cellpadding='0' cellspacing='0' width='95%'>		
<tr>
<td class='portlet-table-td-left' colspan='3'>
<fmt:message key="portlet.label.chooseChannel"/>:
</td>
</tr>			
<c:forEach var="channel" items="${requestScope.channels}" >
<c:if test='${channel.index % 2 == 0}'>
<tr>
</c:if>
<td class='portlet-table-td-left'>
<input TYPE='checkbox' name='plChannels' checked="yes" value='<c:out value="${channel.value}"/>'><c:out value="${channel.name}"/></input>
</td>
<c:if test='${channel.index % 2 == 1}'>
</tr>
</c:if>
</c:forEach>
</table>

<table border='0' cellpadding='0' cellspacing='0' width='80%'>
<tr>
<td class='portlet-table-td-right'>
<input name='signup' type='button' value='<fmt:message key="portlet.button.signUp"/>' class='portlet-form-button'
 	onclick="javascript:signUpPortal('<c:out value="${requestScope.responseId}"/>');" />
</td>
<td class='portlet-table-td-right'>
<input name='cancel' type='button' value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button'
	onclick="javascript:cancelSignUpPortal('<c:out value="${requestScope.responseId}"/>');" />
</td>
</tr>
</table>
</form>
</fmt:bundle>
</body>
</html>
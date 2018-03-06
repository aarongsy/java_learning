<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form name="form_<c:out value="${requestScope.responseId}"/>">
<table border='0' cellpadding='0' cellspacing='0' width='90%'>
<tr>
<td class='portlet-link' colspan='3'>
<a href='javascript:void(0)' onclick="javascript:showSignUp('<c:out value="${requestScope.responseId}"/>');" ><fmt:message key="portlet.label.signUp"/></a>
</td>
</tr>
<tr>
<td class='portlet-table-td-right'><LABEL FOR='plUserId' ACCESSKEY='U'><fmt:message key="portlet.label.userId"/>: </LABEL></td>
<td class='portlet-table-td-left'>
<input type='text' name='userId' value='' class='portlet-form-input-field' size='18' /> 
</td>
<td>
</td>
</tr>
<tr>
<td class='portlet-table-td-right'><fmt:message key="portlet.label.userPassword"/>: </td>
<td class='portlet-table-td-left'>
<input type='password' name='password' value='' class='portlet-form-input-field' size='18' /> 
</td>
<td>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'></td>
<td class='portlet-table-td-left'>
<input TYPE='checkbox' name='rememberMe'  value='1'><fmt:message key="portlet.message.rememberMe"/></input>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'></td>
<td class='portlet-table-td-left'>
<input name='login' type='button' value='<fmt:message key="portlet.button.login"/>' class='portlet-form-button'
  onclick="javascript:loginPortal('<c:out value="${requestScope.responseId}"/>');" />
</td>
</tr>
</table>
</form>
</fmt:bundle>
</body>
</html>
<jsp:directive.page contentType="text/html; charset=UTF-8"/>
<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form name="form_<c:out value="${requestScope.responseId}"/>">
<table border='0' cellpadding='0' cellspacing='0' width="95%">
<tr>
<td class='portlet-table-td-left'>
RSS源:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='prFeed'  value='<c:out value="${requestScope.feed}"/>' class='portlet-form-input-field' size='30' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
标题:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='prTitle' maxlength="100" value='<c:out value="${requestScope.portlet.title}"/>' class='portlet-form-input-field' size='30'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
网址:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='prUrl'  value='<c:out value="${requestScope.portlet.url}"/>' class='portlet-form-input-field' size='30'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
图标:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='prIcon' value='<c:out value="${requestScope.portlet.icon}"/>' class='portlet-form-input-field' size='30'/>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
自动刷新:
</td>
<td class='portlet-table-td-left'>
<select name='prAuto' size='1'  class='portlet-form-select'>
<c:if test='${requestScope.portlet.autoRefreshed == 1}'>
<option selected='selected' value='1'>true</option>
</c:if>
<c:if test='${requestScope.portlet.autoRefreshed != 1}'>
<option value='1'>true</option>
</c:if>
<c:if test='${requestScope.portlet.autoRefreshed == 0}'>
<option selected='selected' value='0'>false</option>
</c:if>
<c:if test='${requestScope.portlet.autoRefreshed != 0}'>
<option value='0'>false</option>
</c:if>
</select>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
刷新间隔(分钟):
</td>
<td class='portlet-table-td-left'>
<select name='prMinute' size='1'  class='portlet-form-select'>
<c:forEach var="i" begin="0" end="60" step="1">
<c:if test='${requestScope.minute == i}'>
<option selected='selected' value='<c:out value="${i}" />'><c:out value="${i}" /></option>
</c:if>
<c:if test='${requestScope.minute != i}'>
<option value='<c:out value="${i}" />'><c:out value="${i}" /></option>
</c:if>
</c:forEach>
</select>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
显示条数:
</td>
<td class='portlet-table-td-left'>
<select name='prItems' size='1'  class='portlet-form-select'>
<c:forEach var="i" begin="1" end="50" step="1">
<c:if test='${requestScope.portlet.showNumber == i}'>
<option selected='selected' value='<c:out value="${i}" />'><c:out value="${i}" /></option>
</c:if>
<c:if test='${requestScope.portlet.showNumber != i}'>
<option value='<c:out value="${i}" />'><c:out value="${i}" /></option>
</c:if>
</c:forEach>
</select>
<input name='Submit' type='button' value='保存' class='portlet-form-button'
	onclick="javascript:editRssPortlet('<c:out value="${requestScope.responseId}"/>');" />
</td>
</tr>						
</table>		
</form>
</fmt:bundle>
</body>
</html>
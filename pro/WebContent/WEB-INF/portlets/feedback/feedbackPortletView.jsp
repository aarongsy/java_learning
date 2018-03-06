<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body> 
<fmt:bundle basename="resourceBundle">
<table border='0' cellpadding='0' cellspacing='0' width='90%'>
<tr>
<td class='portlet-link-left' colspan='3'>
<a href='javascript:void(0)' onclick="<portlet:renderURL  portletMode='EDIT'/>" ><img src='light/images/add.gif' style='border: 0px;' height='16' width='16' align="middle"/><fmt:message key="portlet.label.addFeedback"/></a>
</td>
</tr>
</table>

<c:if test='${requestScope.feebackLists != null}'>
<c:forEach var="item" items="${requestScope.feebackLists}" >
<span class="portlet-rss" 
   onmouseover="javascript:showFeedbackDesc(event,'<c:out value="${item.id}"/>','<c:out value="${requestScope.responseId}"/>');"
   onmouseout="javascript:hideFeedbackDesc();">
<c:out value="${item.subject}"/>
</span>
</c:forEach>
</c:if>
<c:if test='${requestScope.error != null}'>
<span class="portlet">
<c:out value="${requestScope.error}"/>
</span>
</c:if>
</fmt:bundle>
</body>
</html>
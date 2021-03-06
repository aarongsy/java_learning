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

<table border='0' cellpadding='0' cellspacing='0' width='90%'>
<tr>
<td class='portlet-link-left'>
<a href='javascript:void(0)' onclick="<portlet:renderURL portletMode='EDIT'/>" ><img src='<%= request.getContextPath() %>/light/images/add.gif' style='border: 0px;' height='16' width='16' align="middle"/><fmt:message key="portlet.button.addBookmark"/></a>
</td>
</tr>
</table>


<form action="<portlet:actionURL />">
<c:if test='${bookmarkTags != null}'>
 <c:forEach var="tag" items="${bookmarkTags}" >
  <c:if test='${tag.expanded}'>
    <span class='portlet-rss'>
    <input type="image" src="<%= request.getContextPath() %>/light/images/hideMod.gif" style='border: 0px;' height='11' width='11' name="<c:out value='${tag.tagId}'/>" onClick="document.pressed='close';document.parameter=this.name;"/>
    <a href="javascript:void(0);" onclick="javascript:Light.executeAction('<c:out value="${requestScope.responseId}"/>','','close',null,'<c:out value="${tag.tagId}"/>','view',null,null);"><c:out value="${tag.tagName}"/></a>
    <input type="image" title='<fmt:message key="portlet.button.delete"/>' src="<%= request.getContextPath() %>/light/images/deleteLink.gif" name="<c:out value='${tag.tagId}'/>" style='border: 0px;' height='11' width='11' onClick="document.pressed='deleteTag';document.parameter=this.name;"/>

    </span>
    <c:forEach var="bookmark" items="${tag.bookmarks}" >
    <span class='portlet-rss'>
    <img src="<%= request.getContextPath() %>/light/images/spacer.gif" style="border:0px;" height="1" width="20"/> 
    <input type="image" title='<fmt:message key="portlet.label.edit"/>' src="<%= request.getContextPath() %>/light/images/edit.gif" style='border: 0px;' height='11' width='11' name="<c:out value='${bookmark.id}'/>" onClick="document.pressed='edit';document.parameter=this.name;document.mode='EDIT';"/>
    <input type="image" title='<fmt:message key="portlet.button.delete"/>' src="<%= request.getContextPath() %>/light/images/deleteLink.gif" name="<c:out value='${bookmark.id}'/>" style='border: 0px;' height='11' width='11' onClick="document.pressed='delete';document.parameter=this.name;"/>

    <a href='<c:out value="${bookmark.url}"/>' 
    	onmouseover="javascript:showBookmarkDesc(event,'<c:out value="${bookmark.id}"/>','<c:out value="${requestScope.responseId}"/>');"
	    onmouseout="javascript:hideBookmarkDesc();" target='_blank'><c:out value="${bookmark.name}"/></a>
    
    </span>
    </c:forEach>
 </c:if>
 <c:if test='${!tag.expanded}'>
    <span class='portlet-rss'>
    <input type="image" src="<%= request.getContextPath() %>/light/images/showMod.gif" style='border: 0px;' height='11' width='11' name="<c:out value='${tag.tagId}'/>" onClick="document.pressed='expand';document.parameter=this.name;"/>
    <a href="javascript:void(0);" onclick="javascript:Light.executeAction('<c:out value="${requestScope.responseId}"/>','','expand',null,'<c:out value="${tag.tagId}"/>','view',null,null);"><c:out value="${tag.tagName}"/></a>    
    </span>
 </c:if>
 </c:forEach>
</c:if>
<c:if test='${defaultBookmarks != null}'>
<c:forEach var="bookmark" items="${defaultBookmarks}" >
<span class="portlet-rss" >
<img src="<%= request.getContextPath() %>/light/images/spacer.gif" style="border:0px;" height="1" width="10"/>
<a href='<c:out value="${bookmark.url}"/>' 
   onmouseover="javascript:showBookmarkDesc(event,'<c:out value="${bookmark.id}"/>','<c:out value="${requestScope.responseId}"/>');"
   onmouseout="javascript:hideBookmarkDesc();" target='_blank'><c:out
value="${bookmark.name}"/></a>

<input type="image" src="<%= request.getContextPath()
%>/light/images/edit.gif" style='border: 0px;' height='11' width='11'
name="<c:out value='${bookmark.id}'/>"
onClick="document.pressed='edit';document.parameter=this.name;document.mode='EDIT';"/>
<input type="image" src="<%= request.getContextPath()
%>/light/images/deleteLink.gif" name="<c:out value='${bookmark.id}'/>"
style='border: 0px;' height='11' width='11'
onClick="document.pressed='delete';document.parameter=this.name;"/>

</span>
</c:forEach>
</c:if>
</form>
</fmt:bundle>
</body>
</html>
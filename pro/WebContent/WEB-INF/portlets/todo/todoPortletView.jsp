<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form action="<portlet:actionURL portletMode='VIEW'/>">
<table border='0' cellpadding='0' cellspacing='0'  width='90%'>
<c:forEach var="todoList" items="${requestScope.todoLists}" >
<tr>
<c:if test="${todoList.status !=0}">
<td class='portlet-table-td-left' width='80%' style="text-decoration: line-through;">
  
<input TYPE='checkbox' name='<c:out value="${todoList.id}"/>' checked='yes' value='1' onClick="javascript:changeStatus('<c:out value="${requestScope.responseId}"/>',this.name);">
</input>

<span  
   onmouseover="javascript:showTodoDesc(event,'<c:out value="${todoList.id}"/>','<c:out value="${requestScope.responseId}"/>');"
   onmouseout="javascript:hideTodoDesc();">
<c:out value="${todoList.name}"/>
</span>
</c:if>
<c:if test="${todoList.status ==0}">
<td class='portlet-table-td-left' width='80%' style="color: #3169B5;">

<input TYPE='checkbox' name='<c:out value="${todoList.id}"/>' value='1' onClick="javascript:changeStatus('<c:out value="${requestScope.responseId}"/>',this.name);">
</input>

<span  
   onmouseover="javascript:showTodoDesc(event,'<c:out value="${todoList.id}"/>','<c:out value="${requestScope.responseId}"/>');"
   onmouseout="javascript:hideTodoDesc();">
<c:out value="${todoList.name}"/> (priority <c:out value="${todoList.priority}"/>)
</span>
</c:if>
</td>
<td class='portlet-table-td-right'>

<input type="image" src="light/images/edit.gif" style='border: 0px;' height='11' width='11' name="<c:out value='${todoList.id}'/>" onClick="document.pressed='edit';document.parameter=this.name;document.mode='EDIT';"/>
<input type="image" src="light/images/deleteLink.gif" name="<c:out value='${todoList.id}'/>" style='border: 0px;' height='11' width='11' onClick="document.pressed='delete';document.parameter=this.name;"/>

</td>
</tr>
</c:forEach>
</table>
</form>

<table border='0' cellpadding='0' cellspacing='0' width='90%'>
<tr>
<td class='portlet-link-left'>
<a href='javascript:void(0)' onclick="<portlet:renderURL  portletMode='EDIT'/>" ><img src='light/images/add.gif' style='border: 0px;' height='16' width='16' align="middle"/><fmt:message key="portlet.button.addToDo"/></a>
</td>
</tr>
</table>

</fmt:bundle>
</body>
</html>
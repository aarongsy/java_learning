<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>

<script language="JavaScript">
  new Rico.Accordion( $('accordionDiv'), {panelHeight:200, onLoadShowTab:1} );
</script>
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
<br/>
<fmt:bundle basename="resourceBundle">
<form action="<portlet:actionURL portletMode='EDIT'/>">
<div id="accordionDiv">
   <div id="configurePanel">
     <div id="configureHeader" class="panelheader">
       <fmt:message key="portlet.label.config"/>
      </div>
      <div id="configureContent" class="panelContent">    
            <br/>   
			<table border='0' cellpadding='0' cellspacing='0'>
			<c:if test='${requestScope.loginError != null}'>
			<tr>
			<td class='portlet-table-td-left' colspan='2'>
			<fmt:message key="portlet.message.delicious.failLogin"/>
			</td>
			</tr>
			</c:if>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.loginName"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='userName' class='portlet-form-input-field' size='24' value='<c:out value="${requestScope.userName}"/>'/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.password"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='password' name='password' class='portlet-form-input-field' size='24' value='<c:out value="${requestScope.password}"/>'/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-right' colspan ='2'>
			<input type='submit' name='action' onClick="document.pressed='login';document.mode='view';" value='<fmt:message key="portlet.button.ok"/>' class='portlet-form-button' />
			<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
			</td>
			</tr>
			</table>
      </div>
   </div>
   <c:if test='${sessionScope.delicious != null}'>
   <div id="addPanel">
     <div id="addHeader" class="panelheader">
       <fmt:message key="portlet.label.addNewBookmark"/>       
      </div>
      <div id="addContent" class="panelContent">	
        <br/>	           
		<table border='0' cellpadding='0' cellspacing='0'>
			<c:if test='${requestScope.addSuccess != null}'>
			<tr>
			<td class='portlet-table-td-left' colspan='2'>
			<fmt:message key="portlet.message.delicious.add"/>
			</td>
			</tr>
			</c:if>
			<c:if test='${requestScope.missingField != null}'>
			<tr>
			<td class='portlet-table-td-left' colspan='2'>
			<fmt:message key="portlet.message.delicious.fields"/>			
			</td>
			</tr>
			</c:if>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.url"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='url' class='portlet-form-input-field' size='24'  />
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.name"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='name' class='portlet-form-input-field' size='24' />
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.desc"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='desc' class='portlet-form-input-field' size='24' value="<c:out value='${requestScope.name}'/>"/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.tag"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='tag' class='portlet-form-input-field' size='24' />
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-right' colspan ='2'>
			<input type='submit' name='action' onClick="document.pressed='add';document.mode='view';" value='<fmt:message key="portlet.button.add"/>' class='portlet-form-button' />
			<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
			</td>
			</tr>
			</table>		
      </div>
   </div>
   </c:if>
   <c:if test='${requestScope.edit != null}'>
   <div id="editPanel">
     <div id="editHeader" class="panelheader">
       <fmt:message key="portlet.label.addNewBookmark"/>          
      </div>
      <div id="editContent" class="panelContent">		           
		<br/>
		<table border='0' cellpadding='0' cellspacing='0'>
			<c:if test='${requestScope.missingField != null}'>
			<tr>
			<td class='portlet-table-td-left' colspan='2'>
			<fmt:message key="portlet.message.delicious.fields"/>
			</td>
			</tr>
			</c:if>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.url"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='url' class='portlet-form-input-field' size='24' value="<c:out value='${requestScope.url}'/>"/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.name"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='name' class='portlet-form-input-field' size='24' value="<c:out value='${requestScope.name}'/>"/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.desc"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='desc' class='portlet-form-input-field' size='24' value="<c:out value='${requestScope.desc}'/>"/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-left'>
			<fmt:message key="portlet.label.tag"/>:
			</td>
			<td class='portlet-table-td-left'>
			<input type='text' name='tag' class='portlet-form-input-field' size='24' value="<c:out value='${requestScope.tag}'/>"/>
			</td>
			</tr>
			<tr>
			<td class='portlet-table-td-right' colspan ='2'>
			<input type='submit' name='action' onClick="document.pressed='save';document.mode='view';" value='<fmt:message key="portlet.button.save"/>' class='portlet-form-button' />
			<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
			</td>
			</tr>
			</table>		
      </div>
   </div>
   </c:if>
</div>
</form>
</fmt:bundle>
</body>
</html>
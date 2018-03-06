<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<script language="JavaScript">

  keyDownSearch  = function (e, id) {  
	  var KeyID;
	  if (window.event) {	
		keyID = window.event.keyCode;
	  } else {
	    keyID = e.which;
	  } 
	  if ( keyID == 13){   
	    submitSearch(id);    
	  }
	  return !(keyID == 13);
  };
  
  submitSearch = function (id){
 	window.open(document.forms['form_'+id]['psEngine'][document.forms['form_'+id]['psEngine'].selectedIndex].value 
		    +document.forms['form_'+id]['psKeywords'].value); 
  } 

</script>
<fmt:bundle basename="resourceBundle">
<form name="form_<c:out value="${requestScope.responseId}"/>">
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'>
<input type='text' name='psKeywords' class='portlet-form-input-field'
	 onkeypress="return keyDownSearch(event,'<c:out value="${requestScope.responseId}"/>');" /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<select name='psEngine' size='1' class='portlet-form-select'>
<c:forEach var="engine" items="${requestScope.searchEngine}" >
<option value='<c:out value="${engine.value}"/>'><c:out value="${engine.name}"/></option>
</c:forEach>
</select>
<input name='Submit' type='button' class='portlet-form-button' value='<fmt:message key="portlet.button.search"/>' 
	 onclick="javascript:submitSearch('<c:out value="${requestScope.responseId}"/>');" />
</td>
</tr>
</table>
</form>
</fmt:bundle>
</body>
</html>
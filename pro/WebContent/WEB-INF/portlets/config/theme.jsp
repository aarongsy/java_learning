<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form name="form_<c:out value="${requestScope.responseId}"/>">
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left' colspan='3'>
Page Style:
</td>
</tr>
<c:if test='${requestScope.maximized != null}'>
<tr>
<td class='portlet-table-td-left'>
<img src='light/images/theme1.gif' height='200' style='border: 0px' width='150' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master1.css'}"> 
<input type='radio' name='ptTheme' value='theme/master1.css' class='portlet-form-radio'/>
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master1.css'}"> 
<input type='radio' name='ptTheme' value='theme/master1.css' class='portlet-form-radio' checked='true' />
</c:if>
</td>
<td class='portlet-table-td-left'>
<img src='light/images/theme2.gif' height='200' style='border: 0px' width='150' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master2.css'}"> 
<input type='radio' name='ptTheme' value='theme/master2.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master2.css'}"> 
<input type='radio' name='ptTheme' value='theme/master2.css' checked='true' />
</c:if>
</td>
<td class='portlet-table-td-left'>
<img src='light/images/theme3.gif' height='200' style='border: 0px' width='150' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master3.css'}"> 
<input type='radio' name='ptTheme' value='theme/master3.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master3.css'}"> 
<input type='radio' name='ptTheme' value='theme/master3.css' checked='true'/>
</c:if>
</td>
<td class='portlet-table-td-left'>
<img src='light/images/theme4.gif' height='200' style='border: 0px' width='150' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master4.css'}"> 
<input type='radio' name='ptTheme' value='theme/master4.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master4.css'}"> 
<input type='radio' name='ptTheme' value='theme/master4.css' checked='true'/>
</c:if>
</td>		
<td class='portlet-table-td-left'>
<img src='light/images/theme5.gif' height='200' style='border: 0px' width='150' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master5.css'}"> 
<input type='radio' name='ptTheme' value='theme/master5.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master5.css'}"> 
<input type='radio' name='ptTheme' value='theme/master5.css' checked='true' />
</c:if>
</td>		
</tr>
</c:if>

<c:if test='${requestScope.maximized == null}'>
<tr>
<td class='portlet-table-td-left'>
<img src='light/images/theme1.gif' height='100' style='border: 0px' width='97' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master1.css'}"> 
<input type='radio' name='ptTheme' value='theme/master1.css' class='portlet-form-radio'/>
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master1.css'}"> 
<input type='radio' name='ptTheme' value='theme/master1.css' class='portlet-form-radio' checked='true' />
</c:if>
</td>
<td class='portlet-table-td-left'>
<img src='light/images/theme2.gif' height='100' style='border: 0px' width='97' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master2.css'}"> 
<input type='radio' name='ptTheme' value='theme/master2.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master2.css'}"> 
<input type='radio' name='ptTheme' value='theme/master2.css' checked='true' />
</c:if>
</td>
<td class='portlet-table-td-left'>
<img src='light/images/theme3.gif' height='100' style='border: 0px' width='97' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master3.css'}"> 
<input type='radio' name='ptTheme' value='theme/master3.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master3.css'}"> 
<input type='radio' name='ptTheme' value='theme/master3.css' checked='true'/>
</c:if>
</td>
<td class='portlet-table-td-left'>
<img src='light/images/theme4.gif' height='100' style='border: 0px' width='97' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master4.css'}"> 
<input type='radio' name='ptTheme' value='theme/master4.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master4.css'}"> 
<input type='radio' name='ptTheme' value='theme/master4.css' checked='true'/>
</c:if>
</td>		
<td class='portlet-table-td-left'>
<img src='light/images/theme5.gif' height='100' style='border: 0px' width='97' alt='' />
<c:if test="${sessionScope.LightPortal.theme != 'theme/master5.css'}"> 
<input type='radio' name='ptTheme' value='theme/master5.css' />
</c:if>
<c:if test="${sessionScope.LightPortal.theme == 'theme/master5.css'}"> 
<input type='radio' name='ptTheme' value='theme/master5.css' checked='true' />
</c:if>
</td>		
</tr>
</c:if>
</table>

<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left' colspan='3'>
BackGround Image:
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<span height='20' width='100' style='' >Default</span>
<c:if test="${sessionScope.LightPortal.bgImage != ''}"> 
<input type='radio' name='ptBg' value='' />
</c:if>
<c:if test="${sessionScope.LightPortal.bgImage == ''}"> 
<input type='radio' name='ptBg' value='' checked='true' />
</c:if>
</td>	
<td class='portlet-table-td-left'>
<span height='20' width='100' style='' >No Image</span>
<c:if test="${sessionScope.LightPortal.bgImage != 'no'}"> 
<input type='radio' name='ptBg' value='no' />
</c:if>
<c:if test="${sessionScope.LightPortal.bgImage == 'no'}"> 
<input type='radio' name='ptBg' value='no' checked='true' />
</c:if>
</td>
<td class='portlet-table-td-left'>
<span height='20' width='100' style='' >
<a href="javascript:void(0);" onclick="javascript:showMoreBgImage(event,'<c:out value="${requestScope.responseId}"/>');">More Images</a>
<c:if test="${sessionScope.LightPortal.bgImage == 'no' || sessionScope.LightPortal.bgImage == ''}"> 
<input type='radio' name='ptBg' value='more' />
</c:if>
<c:if test="${sessionScope.LightPortal.bgImage != 'no' && sessionScope.LightPortal.bgImage != ''}"> 
<input type='radio' name='ptBg' value='more' checked='true'/>
</c:if>
</span>
</td>		
</tr>
</table>

<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left' colspan='3'>
Header Image:
</td>
</tr>
<tr>
<td class='portlet-table-td-left'>
<span height='20' width='100' style='' >Default</span>
<c:if test="${sessionScope.LightPortal.headerImage != ''}"> 
<input type='radio' name='ptHeader' value='' />
</c:if>
<c:if test="${sessionScope.LightPortal.headerImage == ''}"> 
<input type='radio' name='ptHeader' value='' checked='true' />
</c:if>
</td>	
<td class='portlet-table-td-left'>
<span height='20' width='100' style='' >No Image</span>
<c:if test="${sessionScope.LightPortal.headerImage != 'no'}"> 
<input type='radio' name='ptHeader' value='no' />
</c:if>
<c:if test="${sessionScope.LightPortal.headerImage == 'no'}"> 
<input type='radio' name='ptHeader' value='no' checked='true' />
</c:if>
</td>	
<td class='portlet-table-td-left'>
<span height='20' width='100' style='' >
<a href="javascript:void(0);" onclick="javascript:showMoreHeaderImage(event,'<c:out value="${requestScope.responseId}"/>');">More Images</a>
<c:if test="${sessionScope.LightPortal.headerImage == 'no' || sessionScope.LightPortal.headerImage == ''}"> 
<input type='radio' name='ptHeader' value='more' />
</c:if>
<c:if test="${sessionScope.LightPortal.headerImage != 'no' && sessionScope.LightPortal.headerImage != ''}"> 
<input type='radio' name='ptHeader' value='more' checked='true'/>
</c:if>
</span>
</td>
</tr>
</table>

<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left' >
Header Height:
</td>
<td class='portlet-table-td-left'>
<select name='ptHeaderHeight' size='1' class='portlet-form-select'>
<c:if test='${sessionScope.LightPortal.headerHeight == -40}'> 
<option selected='selected' value='-40' >Default-40</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != -40}'> 
<option value='-40'>Default-40</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == -30}'> 
<option selected='selected' value='-30' >Default-30</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != -30}'> 
<option value='-30'>Default-30</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == -20}'> 
<option selected='selected' value='-20' >Default-20</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != -20}'> 
<option value='-20'>Default-20</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == -10}'> 
<option selected='selected' value='-10' >Default-10</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != -10}'> 
<option value='-10'>Default-10</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == 0}'> 
<option selected='selected' value='0' >Default</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != 0}'> 
<option value='0'>Default</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == 10}'> 
<option selected='selected' value='10' >Default+10</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != 10}'> 
<option value='10'>Default+10</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == 20}'> 
<option selected='selected' value='20' >Default+20</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != 20}'> 
<option value='20'>Default+10</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == 30}'> 
<option selected='selected' value='30' >Default+30</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != 30}'> 
<option value='30'>Default+30</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight == 40}'> 
<option selected='selected' value='40' >Default+40</option>
</c:if>
<c:if test='${sessionScope.LightPortal.headerHeight != 40}'> 
<option value='40'>Default+40</option>
</c:if>
</select>
</td>
</tr>

<tr>
<td class='portlet-table-td-left' >
RSS Font size:
</td>
<td class='portlet-table-td-left'>
<select name='ptFontSize' size='1' class='portlet-form-select'>
<c:if test='${sessionScope.LightPortal.fontSize == -4}'> 
<option selected='selected' value='-4' >Default-4</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize != -4}'> 
<option value='-4'>Default-4</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize == -3}'> 
<option selected='selected' value='-3' >Default-3</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize != -3}'> 
<option value='-3'>Default-3</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize == -2}'> 
<option selected='selected' value='-2' >Default-2</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize != -2}'> 
<option value='-2'>Default-2</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize == -1}'> 
<option selected='selected' value='-1' >Default-1</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize != -1}'> 
<option value='-1'>Default-1</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize == 0}'> 
<option selected='selected' value='0' >Default</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize != 0}'> 
<option value='0'>Default</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize == 1}'> 
<option selected='selected' value='1' >Default+1</option>
</c:if>
<c:if test='${sessionScope.LightPortal.fontSize != 1}'> 
<option value='1'>Default+1</option>
</c:if>
</select>
</td>
</tr>

<tr>
<td class='portlet-table-td-right' colspan='2'>
<input name='Apply' type='button' value='Apply' class='portlet-form-button'
 onclick="javascript:changeTheme('<c:out value="${requestScope.responseId}"/>');" />
</td>
</tr>
</table>
</form>
</fmt:bundle>
</body>
</html>
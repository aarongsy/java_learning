<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.setitem.model.Setitemtype"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemtypeService"%>
<%@ include file="/base/init.jsp"%>

<%
 Setitemtype setitemtype = ((SetitemtypeService) BaseContext.getBean("setitemtypeService")).getSetitemtype(request.getParameter("id"));
%>


<html>
  <head>

  </head>
  
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",location.href='"+request.getContextPath()+"/base/setitem/setitemtypecreate.jsp'}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:onDelete('"+setitemtype.getId()+"')}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

        <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemtypeAction?action=modify"  name="EweaverForm" method="post">
		<table>	
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>	
				
				<tr>
					<td class="FieldName" nowrap>
						ID
					</td>
					<td class="FieldValue">
						<input type="text" style="width=95%" name="id" value="<%=setitemtype.getId()%>" readonly />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e90aac5fd0010aac9ff4cd0002")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width=95%" name="itemtypename" value="<%=setitemtype.getItemtypename()%>" onChange="checkInput('itemtypename','itemtypenamespan')" /><span id=itemtypenamespan></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width=95%" name="itemtypeorder" value="<%=setitemtype.getItemtypeorder()%>"  />
					</td>
				</tr>				
				
				
		</table>   	
		</form>
<script language="javascript">
   function onSubmit(){
   	checkfields="itemtypename";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
   function onDelete(id){
   	confirmmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>"
   	if( confirm(confirmmessage)){
    	document.EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemtypeAction?action=delete";
    	document.EweaverForm.submit();
   	} 
   }   	  
 </script>
  </body>
</html>

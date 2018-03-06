<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<html>
<head> 

</head>
  
<body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
 		
		<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemtypeAction?action=create" name="EweaverForm"  method="post">

	    	<table>
				<colgroup> 
					<col width="20%">
					<!-- col width="20%"-->
				</colgroup>	
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e90aac5fd0010aac9ff4cd0002")%>
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="itemtypename" onChange="checkInput('itemtypename','itemtypenamespan')" /><span id=itemtypenamespan><img src="<%=request.getContextPath()%>/images/base/checkinput.gif"></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width=95%" name="itemtypeorder" value="1"  />
					</td>
				</tr>						
		    </table>			
		</form>	
<script language="javascript">
 <!--
   function onSubmit(){
   	checkfields="itemtypename";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
 -->
 </script>	
</body>
</html>

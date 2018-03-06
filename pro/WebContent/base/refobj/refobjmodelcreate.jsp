<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%

	String modeltype = StringHelper.null2String(request.getParameter("modeltype"));
	if(StringHelper.isEmpty(modeltype)){
		response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
		return;
	}	
 %>
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

	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjmodelAction?action=create" target="_self" name="EweaverForm"  method="post">
	    <input type="hidden" name="modeltype" value="<%=modeltype %>" >
	    	<table>
				<colgroup> 
					<col width="20%">
					<col width="">
					<col width="">
				</colgroup>	
				<tr>
					<td class="FieldName" nowrap>
				协同名称		
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="refname" value="" onChange="checkInput('refname','refnamespan')" />
						<span id=refnamespan><img src="<%=request.getContextPath()%>/images/base/checkinput.gif"></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
				对象类型
					</td>
					<td class="FieldValue">                                      
						<input style="width=95%" type="text" name="objtype" value="" onChange="checkInput('objtype','objtypespan')"/>
						<span id=objtypespan><img src="<%=request.getContextPath()%>/images/base/checkinput.gif"></span>
					</td>
				</tr>					
				<tr>
					<td class="FieldName" nowrap>
				关联字段
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="linktype" value=""/>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					查询语句

					</td>
					<td class="FieldValue">
						<TEXTAREA id="refsql" name="refsql" ROWS="5" COLS="80"></TEXTAREA>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					关联URL
					</td>
					<td class="FieldValue">
						<TEXTAREA id="refurl" name="refurl" ROWS="5" COLS="80"></TEXTAREA>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					关联对象类型	
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="refobjtype" value="" onChange="checkInput('refobjtype','refobjtypespan')"/>
						<span id=refobjtypespan><img src="<%=request.getContextPath()%>/images/base/checkinput.gif"></span>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
						最大显示个数

					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="maxnum" value="0"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						是否显示
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="isview" checked value="1"/>
					</td>
				</tr>		
									
			</table>	
	</form>
<script language="javascript">
   function onSubmit(){
   	checkfields="refname,objtype,refobjtype";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
 </script>	
	      
  </body>
  
</html>
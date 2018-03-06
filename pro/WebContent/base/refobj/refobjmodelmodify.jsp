<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjmodel"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjmodelService"%>

<%@ include file="/base/init.jsp"%>

<%
  Refobjmodel refobjmodel = ((RefobjmodelService)BaseContext.getBean("refobjmodelService")).getRefobjmodel(request.getParameter("id"));
 
%>

<html>
  <head>

  </head>
  
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:onDelete('"+refobjmodel.getId()+"')}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

        <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjmodelAction?action=modify"  name="EweaverForm" method="post">
        		<input type=hidden name=id value="<%=refobjmodel.getId()%>">
        		<input type="hidden" name="modeltype" value="<%=StringHelper.null2String(refobjmodel.getModeltype())%>" >
	    
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
						<input style="width=95%" type="text" name="refname" value="<%=StringHelper.null2String(refobjmodel.getRefname())%>" onChange="checkInput('refname','refnamespan')" />
						<span id=refnamespan></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
				对象类型
					</td>
					<td class="FieldValue">                                      
						<input style="width=95%" type="text" name="objtype" value="<%=StringHelper.null2String(refobjmodel.getObjtype())%>" onChange="checkInput('objtype','objtypespan')" />
						<span id=objtypespan></span>
					</td>
				</tr>					
				<tr>
					<td class="FieldName" nowrap>
				关联字段
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="linktype" value="<%=StringHelper.null2String(refobjmodel.getLinktype())%>"/>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					查询语句

					</td>
					<td class="FieldValue">
						<TEXTAREA id="refsql" name="refsql" ROWS="5" COLS="80"><%=StringHelper.null2String(refobjmodel.getRefsql())%></TEXTAREA>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					关联URL
					</td>
					<td class="FieldValue">
						<TEXTAREA id="refurl" name="refurl" ROWS="5" COLS="80"><%=StringHelper.null2String(refobjmodel.getRefurl())%></TEXTAREA>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					关联对象类型	
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="refobjtype" value="<%=StringHelper.null2String(refobjmodel.getRefobjtype())%>" onChange="checkInput('refobjtype','refobjtypespan')"/>
						<span id=refobjtypespan></span>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
						最大显示个数

					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="maxnum" value="<%=StringHelper.null2String(refobjmodel.getMaxnum())%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						是否显示
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="isview" <%=(StringHelper.null2String(refobjmodel.getIsview()).equals("1"))?"checked":"" %> value="1"/>
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
   function onDelete(id){
   	confirmmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>"
   	if( confirm(confirmmessage)){
    	document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjmodelAction?action=delete";
    	document.EweaverForm.submit();
   	} 
   }    
 </script>		   
		   
  </body>
 </html>
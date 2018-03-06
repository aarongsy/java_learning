<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ include file="/base/init.jsp"%>
<%
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
String pid = StringHelper.null2String(request.getParameter("pid"));
String menutype = StringHelper.null2String(request.getParameter("menutype"));

if(!pid.equals("")){
	menutype = ""+menuService.getMenu(pid).getMenutype();
}

%>
<html>
  <head>
  </head> 
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
 
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=create" name="EweaverForm" method="post">
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						labelid
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="labelid" value=""/>
					</td>
				</tr>
				<tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						menuname
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="menuname" value="" onChange="checkInput('menuname','menunamespan')" onkeypress="checkQuotes_KeyPress()"/>
						<span id="menunamespan"/><img src="/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						pid
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="pid" value="<%=pid%>"/>
					</td>
				</tr>
				<tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						url
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<TEXTAREA id="url" name="url" ROWS="5" COLS="65"></TEXTAREA>
					</td>
				</tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						menutype
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="menutype" value="<%=menutype%>"  onChange="checkInput('menutype','menutypespan')"/>
						<span id="menutypespan"/></span>
						<%=labelService.getLabelName("402881e90bd6c49d010bd6e2536e0002")%>
					</td>
				</tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						nodetype
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="nodetype" value="1"/>
						<%=labelService.getLabelName("402881e90bd6c49d010bd6e3265e0003")%>
					</td>
				</tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						imgfile
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						<input style="width=80%" type="text" name="imagfile" value=""/>
					</td>
				</tr>		
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						dsporder
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="dsporder" value="1"/>
					</td>
				</tr>			
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						isshow
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						  <select name="isshow">
						  		<option value="1" selected><%=labelService.getLabelName("402881eb0bd66c95010bd67f5e310002")%></option>
						  		<option value="0"><%=labelService.getLabelName("402881eb0bd66c95010bd68004400003")%></option>	
    					 </select>
				</tr>	
			</table>
		</form>
<script language="javascript">
 <!--
   function onSubmit(){
   	checkfields="menuname,menutype";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
 -->
 </script>
  </body>
</html>

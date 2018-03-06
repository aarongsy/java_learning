<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.extfield.service.ExtfieldService"%>
<%@ page import="com.eweaver.base.extfield.model.Extfieldset"%>
<%
Extfieldset extfieldset = ((ExtfieldService)BaseContext.getBean("extfieldService")).getExtfieldsetById(request.getParameter("id"));
if(extfieldset==null){
	response.sendRedirect(request.getContextPath()+"/base/blank.jsp?isclose=1");
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

		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.extfield.servlet.ExtfieldAction?action=modify" target="_self" name="EweaverForm"  method="post">
        <input type="hidden" name="id" value="<%=StringHelper.null2String(extfieldset.getId())%>">
        <input type="hidden" name="objtable" value="<%=StringHelper.null2String(extfieldset.getObjtable())%>">
        <table>
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>			
				<tr>
					<td class="FieldName" nowrap>
						labelid
					</td>
					<td  class="FieldValue">
						<input style="width=95%" type="text" name="labelid" value="<%=StringHelper.null2String(extfieldset.getLabelid())%>" title="<%=labelService.getLabelName(extfieldset.getLabelid())%>" />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						showname	
					</td>
					<td  class="FieldValue">
						<input style="width=95%" type="text" name="showname" value="<%=StringHelper.null2String(extfieldset.getShowname())%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						fieldtype
					</td>
					<td  class="FieldValue">
						<select name="fieldtype" style="width=40%">
							<option value="1"<%="1".equals(extfieldset.getFieldtype())?" selected":""%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007a")%><!-- 文本,数字 --></option>
							<option value="2"<%="2".equals(extfieldset.getFieldtype())?" selected":""%>><%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")%><!-- 日期 --></option>
							<option value="3"<%="3".equals(extfieldset.getFieldtype())?" selected":""%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007b")%><!-- Check框 --></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						dsporder	
					</td>
					<td  class="FieldValue">
						<input style="width=95%" type="text" name="dsporder" value="<%=extfieldset.getDsporder()%>" />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						isshow	
					</td>
					<td  class="FieldValue">
						<select name="isshow" style="width=40%">
							<option value="1"<%=extfieldset.getIsshow().intValue()==1?" selected":""%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%><!-- 显示 --></option>
							<option value="0"<%=extfieldset.getIsshow().intValue()==0?" selected":""%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%><!-- 隐藏 --></option>
						</select>
					</td>
				</tr>
				
			</table>

		</form>
<script language="javascript">
 <!--
function onSubmit(){
	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}
 -->
 </script>
</body>
</html>

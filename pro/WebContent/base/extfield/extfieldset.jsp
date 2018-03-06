<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.label.model.Label"%>
<%@ page import="com.eweaver.base.extfield.service.ExtfieldService"%>
<%@ page import="com.eweaver.base.extfield.model.Extfieldset"%>
<%
String objtable = StringHelper.trimToNull(request.getParameter("objtable"));
ExtfieldService extfieldService = (ExtfieldService)BaseContext.getBean("extfieldService");
List extfieldsetList = extfieldService.getExtfieldsetListByObjtable(objtable);
%>
<html>
<head>
</head>
<body>
		
<!--页面菜单开始-->     
<%
pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",javascript:onPopup('/base/extfield/extfieldcreate.jsp?objtable="+objtable+"')}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
		<form action="" name="EweaverForm" method="post">
		<input type="hidden" name="id" value="">
			<table>
				<colgroup>
					<col width="">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr class="Header">
					<td><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0061")%><!-- 字段名 --></td>
					<td><%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b9621d0e1000b")%><!-- 字段类型 --></td>
					<td><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774d4c410009")%><!-- 显示顺序 --></td>
					<td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007c")%><!-- 是否显示 --></td>
					<td></td>
					<td></td>
				</tr>
				<%
			boolean isLight=false;
			String trclassname="";
			if(extfieldsetList!=null){
				Iterator it = 	extfieldsetList.iterator();
				while(it.hasNext()){
					Extfieldset extfieldset = (Extfieldset) it.next();
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname ="DataDark";
					String fieldtype = "";
					switch(NumberHelper.string2Int(extfieldset.getFieldtype())){
						case 1 : fieldtype += labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007a");//文本,数字
								break;
						case 2 : fieldtype += labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000");//日期
								break;
						case 3 : fieldtype += labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007b");//Check框
								break;
						default:break;
								
					}
					if("1".equals(extfieldset.getFieldtype()))
					
%>
				<tr class="<%=trclassname%>">
					<td>
						<%=extfieldset.getLabelid()!=null?labelService.getLabelName(extfieldset.getLabelid()):StringHelper.null2String(extfieldset.getShowname())%>
					</td>
					<td>
						<%=fieldtype%>
					</td>
					<td>
						<%=extfieldset.getDsporder()%>
					</td>
					<td>
						<%=extfieldset.getIsshow().intValue()==1?labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002"):labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%>//显示//隐藏
					</td>
					<td>
						<a href="javascript:onPopup('/base/extfield/extfieldmodify.jsp?id=<%=extfieldset.getId()%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa85f6f3d0002")%></a>
					</td>
					<td>
				     	<a href="javascript:onDelete('<%=extfieldset.getId()%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%></a>
					</td>
				</tr>
				<%}
			}%>
			</table>
			<br>
		</form>

<script language="javascript" type="text/javascript">
function onDelete(id){
    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
	    document.EweaverForm.id.value = id;
	    document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.extfield.servlet.ExtfieldAction?action=delete";
		document.EweaverForm.submit();
   	}
}
 </script>
	</body>
</html>

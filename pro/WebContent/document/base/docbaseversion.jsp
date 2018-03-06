<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ include file="/base/init.jsp"%>
<%
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
String docid = StringHelper.trimToNull(request.getParameter("id"));
String attachid = StringHelper.trimToNull(request.getParameter("attachid"));
%>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
</head>
<body>
  		<!-- 标题 -->
  		<%titlename=labelService.getLabelName("402881eb0bd712c6010bd71463120002");%>
			<table ID=BrowserTable class=BroswerStyle cellspacing=1>	
				<TBODY>
				<tr class="Header">
					<th width="0%" style="display:none">Docid</th>
					<th width="0%" style="display:none">Attachid</th>
					<th><%=labelService.getLabelName("402881eb0bd712c6010bd7248a32000d")%></th>
					<th><%=labelService.getLabelName("402881eb0bd712c6010bd725161f000e")%></th>
					<th>&nbsp;</th>
				</tr>
<%
			Docbase docobj = docbaseService.getDocbase(docid);
			List list = docbaseService.getDoccontentAllVerByDocNo(docobj.getObjno());
			if(attachid!=null){
				list = docbaseService.getAttachListByAttach(docid,attachid);
			}
			boolean isLight=false;
			String trclassname="";	
			boolean onevision = list.size()==1?true:false;
			int j = list.size();
			for (int i = 0; i < list.size(); i++) {
					Docattach docattach = (Docattach) list.get(i);
					Docbase docbase=docbaseService.getDocbase(docattach.getObjid());
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
%>
				<tr class="<%=trclassname%>">
				<!-- 内容行 -->	
					<td style="display:none"><%=docattach.getObjid()%></td>
					<td style="display:none"><%=docattach.getAttachid()%></td>
					<td>
						<a href="#" onclick="getArray('<%=docattach.getObjid()%>','<%=docattach.getAttachid()%>')"><%=j-i%></a>
					</td>
					<td>
						<a href="#" onclick="getArray('<%=docattach.getObjid()%>','<%=docattach.getAttachid()%>')"><%=docattach.getVersion()%></a>
					</td>
					<td>
						<button type="button" <%if(onevision||docattach.getObjid().equals(docid)){%>disabled<%}%> onclick="javascript:selectVersion('<%=docattach.getObjid()%>')">
							<%=labelService.getLabelName("402881eb0bd712c6010bd73588e70011")%>
						</button>
						<button type="button" <%if(onevision||docattach.getObjid().equals(docid)){%>disabled<%}%>  onclick="javascript:deleteVersion('<%=docattach.getObjid()%>')">
							<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>
						</button>
						<button type="button" <%if(onevision||docattach.getObjid().equals(docid)){%>disabled<%}%>  onclick="javascript:showVersion('<%=docattach.getObjid()%>','<%=docbase.getSubject()%>','<%=j-i%>')">
							<%=labelService.getLabelName("402881eb0bcd354e010bcd7a2f730012")%>
						</button>
					</td>
<%			}
%>	
			</tbody>
		</table>
<script language="javascript">
 <!--
 function selectVersion(id){
 	window.location.href = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=selectver&id="+id+"&ver=<%=docid%>";
 }
function deleteVersion(id){
	window.location.href = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=deletever&id=<%=docid%>&ver="+id;
}
function showVersion(id,subject,version){
	var pWindow=window.dialogArguments;
	if(pWindow != null){
		pWindow.onUrl('<%=request.getContextPath()%>/document/base/docbaseview.jsp?id='+id,subject+'('+version+')','tab'+id);
	}
}
  -->
 </script>
<SCRIPT LANGUAGE=VBS>
Sub BrowserTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     getArray e.parentelement.cells(0).innerText, e.parentelement.cells(1).innerText
   End If
End Sub
Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
</body></html>


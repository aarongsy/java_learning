<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>

<%
String titlename="WeaverSoft e-weaver";
String titleimage=request.getContextPath()+"/images/main/titlebar_bg.jpg";
String pagemenustr="";
String pagemenuorder="0";
HashMap paravaluehm = new HashMap();
String theuri = request.getRequestURI();	
LabelService labelService = (LabelService)BaseContext.getBean("labelService"); 
int mode = NumberHelper.string2Int(request.getParameter("mode"), 1);
List attachList = (List) request.getAttribute("attachList");
String key = "";
String text = "";
%>
<html>
	<head>
<link href="<%=request.getContextPath()%>/css/eweaver-default.css" type="text/css" rel="STYLESHEET">
	</head>
	<body>
<!--页面菜单开始-->  
<%
if (attachList == null) {	
	pagemenustr += "{S,"+labelService.getLabelName("402881ec0bdc2afd010bdc5930ee0010")+",javascript:onUpload()}";
	if(mode!=1){
		pagemenustr += "{F,"+labelService.getLabelName("402881eb0bcd354e010bcd9dfe6b0017")+",javascript:addattach()}";
	}
}else{
	pagemenustr += "{H,"+labelService.getLabelName("402881eb0bcbfd19010bcc6e71870022")+",javascript:node_onclick()}";
}
	pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.file.FileUploadAction" enctype="multipart/form-data" name="EweaverForm" method="post">
			<table ID=BrowserTable class=BroswerStyle cellspacing=1>
				<!-- 列宽控制 -->
				<colgroup>
					<col width="15%">
					<col width="35%">
					<col width="15%">
					<col width="35%">
				</colgroup>
				<tbody>
					<%if (attachList == null) {%>
					<tr>
						<td class="FieldValue" colspan="3" id=attachtd>
							<input type=file style="WIDTH: 99%;" name=attach1>
						</td>
					</tr>
					<%} else {
				boolean isLight = false;
				String trclassname = "";
				for (int i = 0; i < attachList.size(); i++) {
					Attach attach = (Attach) attachList.get(i);
					key += "," + attach.getId();
					text += "," + attach.getObjname();
					isLight = !isLight;
					if (isLight)
						trclassname = "DataLight";
					else
						trclassname = "DataDark";
					%>
					<tr class="<%=trclassname%>">
						<td>
							<%=attach.getObjname()%>
						</td>
					</tr>
					<%}
				if (key.length() > 0) {
					key = key.substring(1);
				}
				if (text.length() > 0) {
					text = text.substring(1);
				}
			}
			%>
				</tbody>
			</table>
		</form>
		<script language="javascript">
 <!--
var attachno = 1
function addattach(){
  var attachtd = document.getElementById('attachtd');
  attachno++;
  attachtd.innerHTML+="<br><input type=file style=\"WIDTH: 99%;\" name=attach"+attachno+">";
}

function onUpload(){
  EweaverForm.submit();
}

 -->
 </script>
		<script language=VBS>
Sub Btnclear_onclick()
     getArray "0",""
End Sub
Sub node_onclick()
     getArray "<%=key%>","<%=text%>"
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
</script>
    <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
	</body>
</html>

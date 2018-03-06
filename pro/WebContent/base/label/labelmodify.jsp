<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.label.model.Label"%>
<%@ page import="com.eweaver.base.label.service.LabelService"%>
<%@ include file="/base/init.jsp"%>
<%
Label label = ((LabelService)BaseContext.getBean("labelService")).getLabel(request.getParameter("id"));

if(request.getParameter("issucessed")!=null){
%>
<script language="javascript">
window.close();
</script>
<%}%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onPopup('/base/label/labelcreate.jsp')});";
%>
<html>
<head>

    <style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
 </style>
 
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
   <script type="text/javascript">
     Ext.onReady(function() {

         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
     });
 </script>

</head>
	<body>
<div id="pagemenubar" style="z-index:100;"></div>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=modify"  target="_self"  name="EweaverForm" method="post">
		<table>
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>				
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbdcc70000a")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width:95%" name="id" value="<%=label.getId()%>" readonly />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbe161b000b")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width:95%" name="labelname" value="<%=label.getLabelname()%>" onChange="checkInput('labelname','labelnamespan')" /><span id=labelnamespan></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbe44ad000c")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width:95%" name="labeldesc" value="<%=label.getLabeldesc()%>" />

					</td>
				</tr>


			</table>
		</form>
<script language="javascript">
 <!--
   function onSubmit(){
   	checkfields="labelname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
   function onPopup(url){
   	window.location.href="<%= request.getContextPath()%>"+url;
   }
 -->
 </script>
	</body>
</html>

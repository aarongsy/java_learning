<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";
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
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunittypeAction?action=create" name="EweaverForm" method="post">
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				 <tbody>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b ")%></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="objname" maxlength="128" onchange='checkInput("objname","objnamespan")'>
          				<span id="objnamespan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span></td>
        		</tr>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001 ")%></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" name="dsporder" onkeypress="checkInt_KeyPress()" value="1"></td>
        		</tr>
 				</tbody>
 			</table>
		</form>

<script language="javascript">
 <!--
   function onSubmit(){
   	 checkfields="objname";
   	 checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	 if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
     }
   }
   function onReturn(){
     history.go(-1);
   }
 -->
 </script>
  </body>
</html>
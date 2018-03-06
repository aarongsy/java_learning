<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunittype"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ include file="/base/init.jsp"%>
<%
OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
Orgunittype orgunittype = orgunittypeService.getOrgunittype(request.getParameter("id"));
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
 
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.7.2.min.js"></script>
   <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/plugins/colorPicker/colorPicker.js"></script>
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
     <script type="text/javascript">

     jQuery(function(){
         $.showcolor('col3','col3');//第一参数：点击触发选择器的控件ID，第二参数： 文本框ID
         $("#colorpanel").hover(function(){},function(){
        	 $("#colorpanel").hide();
         });
                 
     })
  		Ext.onReady(function(){
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
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunittypeAction?action=modify" name="EweaverForm" method="post">
			<input type="hidden" name="id" value="<%=orgunittype.getId()%>">
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				 <tbody>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" maxlength="128" name="objname" onchange='checkInput("objname","objnamespan")' value="<%=orgunittype.getObjname()%>">
          				<span id="objnamespan"></span></td>
        		</tr>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" name="dsporder" onkeypress="checkInt_KeyPress()" value="<%=orgunittype.getDsporder()%>"></td>
        		</tr>
  				<tr>
          			<td class="FieldName">是否公司类型</td>
          			<td class="FieldValue"><input type="checkbox" name="col1" value="1" <%if("1".equals(orgunittype.getCol1())){%>checked<%}%>></td>
        		</tr>
  				<tr>
          			<td class="FieldName">类型级别</td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" maxlength="128" name="col2" onkeypress="checkInt_KeyPress()" value="<%=StringHelper.null2String(orgunittype.getCol2())%>"></td>
        		</tr>
        		<tr>
          			<td class="FieldName">颜色</td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="20" id="col3" name="col3" value="<%=StringHelper.null2String(orgunittype.getCol3(),"51B5EE")%>"  ></td>
        		</tr>
 				</tbody>
 			</table>
		</form>
<div style="position:absolute;background-color:#FFFFFF;" id="colorSpan"></div>
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

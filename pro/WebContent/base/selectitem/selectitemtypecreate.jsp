<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
  <%
     titlename=labelService.getLabelName("402881e50acc0d40010acc3586c60001");
      String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
         String gobackURL = "javascript:location.href='"+request.getContextPath()+"/base/selectitem/selectitemtypelist.jsp?moduleid="+moduleid+"'";

     %>
 <%
     pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
%>

<html>
  <head>

      <style type="text/css">
   #pagemenubar table {width:0}
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
	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=create" target="_self" name="EweaverForm"  method="post">
	    	<input type="hidden" value="<%=moduleid%>" name="moduleid" id="moduleid">
        <table>
				<colgroup> 
					<col width="20%">
					<col width="">
					<col width="">
				</colgroup>	
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50acc0d40010acc4452220002")%>
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="objname" onChange="checkInput('objname','objnamespan')" />
						<span id=objnamespan><img src="<%= request.getContextPath()%>/images/base/checkinput.gif"></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad59927580007")%>
					</td>
					<td class="FieldValue">                                      
						<input style="width=95%" type="text" name="pid" value="<%=StringHelper.null2String(request.getParameter("pid"))%>"/>
					</td>
				</tr>					
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%>
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="dsporder" value="1"/>
					</td>
				</tr>			
			</table>	
	</form>
<script language="javascript">
   function onSubmit(){
   	checkfields="objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
 </script>	
	      
  </body>
  
</html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>


<%
  String id = StringHelper.null2String(request.getParameter("id"));
  SyspermsService syspermsService = (SyspermsService) BaseContext.getBean("syspermsService");
  Sysperms sysperms = syspermsService.get(id);
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  Selectitem selectitem = new Selectitem();
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
/*
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){onCreate()});";
*/
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";
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
  <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SyspermsAction?action=modify" name="EweaverForm"  method="post">
    <input type="hidden" name="id" value="<%=id%>"/>
    <table class=noborder>
	  <colgroup> 
		<col width="30%">
		<col width="70%">
	  </colgroup>	
	  <tr class=Title>
		<th colspan=2 nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bcc75b5770026  ")%><!-- 权限信息--></th>		        	  
	  </tr>
	  <tr>
    	<td class="Line" colspan=2 nowrap></td>		        	  
	  </tr>	  
	  <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc7aedcd0027 ")%><!-- 权限标识-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="permname" value="<%=StringHelper.null2String(sysperms.getPermname())%>" readonly/>
			 <img src=<%= request.getContextPath()%>/images/base/checkinput.gif>
		</td>
	  </tr>	
	  <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc7013bf0024")%><!-- 权限名称-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="operation" value="<%=StringHelper.null2String(sysperms.getOperation())%>"/>
			
		</td>
	  </tr>		
	  <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc7215380025")%><!-- 权限描述-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="permdesc" value="<%=StringHelper.null2String(sysperms.getPermdesc())%>"/>
			
		</td>
	  </tr>	  
	 <%
	   String selectitemname = "";
	   if (!StringHelper.isEmpty(sysperms.getObjtype())) {
	     selectitem = selectitemService.getSelectitemById(sysperms.getObjtype());
	     selectitemname = StringHelper.null2String(selectitem.getObjname());
	   }
	 %>  
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc6bb95e0021")%><!-- 权限类型-->
	   </td>
	   <td class="FieldValue">
			<button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=402881e80b9a072f010b9a362b030008','objtype','objtypespan','0');"></button>
			<input type="hidden"  name="objtype" value="<%=StringHelper.null2String(selectitem.getId())%>"/>
			<span id = "objtypespan"><%=selectitemname%></span>					
		</td>
	 </tr>	 
	</table>
  </form>
<script language="javascript"> 
function onSubmit(){
   	checkfields="operation";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    

function onDelete(){
  EweaverForm.action = "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SyspermsAction?action=delete";
  document.EweaverForm.submit();
}
    function onCreate(){
        document.location.href="<%=request.getContextPath()%>/base/security/sysperms/syspermscreate.jsp";
    }
    function getBrowser(viewurl, inputname, inputspan, isneed) {
           var id;
           try {
               id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
           } catch(e) {
           }
           if (id != null) {
               if (id[0] != '0') {
                   document.all(inputname).value = id[0];
                   document.all(inputspan).innerHTML = id[1];
               } else {
                   document.all(inputname).value = '';
                   if (isneed == '0')
                       document.all(inputspan).innerHTML = '';
                   else
                       document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

               }
           }
       }
</script>
  </body>
</html>

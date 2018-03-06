<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%
  String id = StringHelper.null2String(request.getParameter("id"));
  SyspermsService syspermsService = (SyspermsService) BaseContext.getBean("syspermsService");
  Sysperms sysperms = syspermsService.get(id);
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  Selectitem selectitem = new Selectitem();
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e70b774c35010b7750a15b000b")+"','M','application_form_edit',function(){edit()});";
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
    <table class=noborder>
	  <colgroup> 
		<col width="30%">
		<col width="70%">
	  </colgroup>	
	  <tr class=Title>
		<th colspan=2 nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bcc75b5770026 ")%><!-- 权限信息--></th>		        	  
	  </tr>
	  <tr>
    	<td class="Line" colspan=2 nowrap></td>		        	  
	  </tr>	  
	  <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc7aedcd0027")%><!-- 权限标识-->
	   </td>
	   <td class="FieldValue">
			<%=StringHelper.null2String(sysperms.getPermname())%>
		</td>
	  </tr>	
	  <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc7013bf0024")%><!-- 权限名称-->
	   </td>
	   <td class="FieldValue">
			<%=StringHelper.null2String(sysperms.getOperation())%>
			
		</td>
	  </tr>		
	  <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc7215380025")%><!-- 权限描述-->
	   </td>
	   <td class="FieldValue">
			 <%=StringHelper.null2String(sysperms.getPermdesc())%>
			
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
			<%=selectitemname%>				
		</td>
	 </tr>	 
	 
	     
	</table>
  </form>
  </body>
<script type="text/javascript">
    function edit(){
       document.location.href="<%=request.getContextPath()%>/base/security/sysperms/syspermsmodify.jsp?id=<%=id%>";
    }
</script>
</html>

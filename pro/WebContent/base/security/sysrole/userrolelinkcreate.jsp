<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%
String roleId = StringHelper.trimToNull(request.getParameter("roleId"));
String rolename ="";
SysroleService sysroleService = (SysroleService)BaseContext.getBean("sysroleService");
 OrgunittypeService orgunittypeService = (OrgunittypeService) BaseContext.getBean("orgunittypeService");
if(!StringHelper.isEmpty(roleId)){
	Sysrole  sysrole = sysroleService.get(roleId);
	if (sysrole!=null)
	  rolename = StringHelper.null2String(sysrole.getRolename());  
}

%>
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
 <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.UserroleAction?action=create" name="EweaverForm"  method="post">
  <table class=noborder>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	

	  <tr>
    	<td class="Line" colspan=2 nowrap></td>		        	  
	  </tr>		
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bccc8996f003c")%><!-- 用户名称-->
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','userid','useridspan','1');"></button>
			 <input type="hidden"   name="userid"/>
			 <span id = "useridspan"><img src=<%= request.getContextPath()%>/images/base/checkinput.gif></span>
		</td>
	 </tr>	
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcca8f4b90035")%><!-- 角色名称-->
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser('/base/security/sysrole/sysrolebrowser.jsp','roleid','roleidspan','1');"></button>
			 <input type="hidden"   name="roleid" value="<%=StringHelper.null2String(roleId)%>"/>
			 <span id = "roleidspan"><%=rolename%><!-- img src=/images/base/checkinput.gif--></span>	
		</td>
	 </tr>	
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcccb7088003d")%><!-- 角色级别-->
	   </td>
	   <td class="FieldValue">
			<button  type="button" class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','rolelevel','rolelevelspan','1');"></button>
			<input type="hidden"  name="rolelevel" value=""/>
			<span id = "rolelevelspan"></span>	
		</td>
	 </tr>	 	    

	</table>     
 </form> 
<script language="javascript">
    function onReturn(){
     window.close();
    }
function onSubmit(){
   	checkfields="userid,roleid";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
        window.close();
   	}
}
    function getBrowser(viewurl,inputname,inputspan,isneed){
             var id;
             try{
             id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
             }catch(e){}
             if (id!=null) {
             if (id[0] != '0') {
                 document.all(inputname).value = id[0];
                 document.all(inputspan).innerHTML = id[1];
             }else{
                 document.all(inputname).value = '';
                 if (isneed=='0')
                 document.all(inputspan).innerHTML = '';
                 else
                 document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                     }
                  }
          }

</script> 
  </body>
</html>

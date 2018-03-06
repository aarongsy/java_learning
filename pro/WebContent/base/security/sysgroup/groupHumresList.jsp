<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%@ page import="java.util.*"%>


<%
  String groupId = StringHelper.trimToNull(request.getParameter("id"));
  
  SysGroupService sysGroupService = (SysGroupService) BaseContext.getBean("sysGroupService");
  OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");

  SysGroup sysGroup =sysGroupService.get(groupId);
  Set humress=  sysGroup.getHumress() ;
  isSysAdmin = false;
  if(BaseContext.getRemoteUser().getUsername().equals("sysadmin"))
  isSysAdmin=true;
  
 // Set  permsSet = sysrole.getPermissions();
 Iterator iter = humress.iterator();

  
%>
<%
if(sysGroup.getGrouptype().equals("2")||isSysAdmin)
pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+labelService.getLabelName("4028831334d4c04c0134d4c04e980020") + "','H','accept',function(){javascript:onModify('/humres/base/humresbrowserm.jsp')});";
%>

<html>
  <head>
      <style type="text/css">
          .x-toolbar table {
              width: 0
          }

          #pagemenubar table {
              width: 0
          }

          .x-panel-btns-ct {
              padding: 0px;
          }

          .x-panel-btns-ct table {
              width: 0
          }
      </style>
      <script src='<%= request.getContextPath()%>/dwr/interface/SysresourceService.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  </head>
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
  <body>
<!--页面菜单开始-->     

<div id="pagemenubar" style="z-index:100;"></div> 
<!--页面菜单结束--> 
   <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=delhumres" name="EweaverForm"  method="post">
   <TABLE  class="BrowserStyle">
	<tbody>
		 <tr class="Header">
		  <TH width="0%" style="display:none">ids</TH>
		  <TH width="30%">&nbsp;&nbsp;<%=labelService.getLabelName("402881e70b7728ca010b7730905d000b") %></TH>
		  <TH width="50%">&nbsp;&nbsp;<%=labelService.getLabelName("402881e70ad1d990010ad1da10900004") %></TH>
		  <TH width="20%">&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e")%></TH>
		  
		 </tr>  
    <%
	 if (humress!=null && humress.size()!=0) {
		boolean isLight=false;
		String trclassname="";
		while (iter.hasNext()){
			Humres humres = (Humres)iter.next();
			isLight=!isLight;
			if(isLight) trclassname="DataLight";
			else trclassname="DataDark";        
        
        	String actionname = "";
 	        String  humresname =humres.getObjname();
 	        String  rolelevel ="";
 	        String  orgunitname =orgunitService.getOrgunitName(humres.getOrgid());

    %>		 
    	<tr class="<%=trclassname%>">
 	      <td width="0%" style="display:none">					    
			 &nbsp;&nbsp;<%=StringHelper.null2String(humres.getId())%>
		  </td>   	
		  <td nowrap>               
	      	&nbsp;&nbsp;<%=humresname%>		        
		  </td>	 
		  <td nowrap>	   
	      	&nbsp;&nbsp;<%=StringHelper.null2String(orgunitname)%>				
		  </td>	
		  <td nowrap>	   
	      	&nbsp;&nbsp;<a href="javascript:onDelete('<%=humres.getId()%>');" ><%if(sysGroup.getGrouptype().equals("2")||isSysAdmin){%><img src="<%= request.getContextPath()%>/images/base/BacoDelete.gif" border=0 title="<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>"><%}%></a>
		  </td>	
		</tr> 		 
		 
		 
   <%
      }
    }
    %>		 
   </table>
   <input type="hidden" name="action" value="" />
   <input type="hidden" name="id" value="<%=groupId%>" />
   <input type="hidden" id ="humresid" name="humresid" value="" />
   </form>
 <SCRIPT language="javascript"> 
  function onModify(url){
      try{
    var id=openDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url+"&keyfield=iskeyfieldidflag");
    if (id!=null) {
     var xmlHttp = new XMLHttpRequest();  
      var url ="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=addhumres&id=<%=groupId%>&humresid="+id[0];
      xmlHttp.open("GET", url, false); //同步;  
      xmlHttp.send(null); 
   //  window.location="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=addhumres&id=<%=groupId%>&humresid="+id[0];
     //document.execCommand('Refresh');
     window.location.reload(true);  
    }
  }catch(e){}
  } 
  
  function onDelete(id){
   document.getElementById("humresid").value=id;
 //document.EweaverForm.all("humresid").value=id;//不支持chrome
   document.EweaverForm.submit();
}
</SCRIPT>  
   
  </body>
</html>

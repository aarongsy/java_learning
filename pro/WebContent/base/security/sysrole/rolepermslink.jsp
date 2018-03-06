<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.*"%>
<%
  String roleId = StringHelper.null2String(request.getParameter("roleId"));
  String id = StringHelper.trimToNull(request.getParameter("id"));
  String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));

  SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");

  Sysrole sysrole = sysroleService.get(roleId);
  Set  permsSet = sysrole.getPermissions();
  Iterator iter = permsSet.iterator(); 
  
%>

<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){getBrowser('/base/security/sysperms/syspermsbrowserm.jsp')});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){delRow()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){toBack()});";

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
      <script src='<%= request.getContextPath()%>/dwr/interface/SyspermsService.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
  
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
<!--页面菜单结束-->
                  
	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=rolepermslink" name="EweaverForm" method="post">
      <input type="hidden" name="id" value="<%=roleId%>">
      <table cols=5 id="vTable">
      	<COLGROUP>
      		<COL width="4%">
			<COL width="46%">
			<COL width="50%">					
		</COLGROUP>	
		<tbody>
			<tr class=Header> 
				<td></td> <!--表头 字段-->
				<td><%=labelService.getLabelName("402881eb0bcbfd19010bcc7013bf0024")%></td>
				<td><%=labelService.getLabelName("402881eb0bcbfd19010bcc7215380025")%></td>
			</tr>		
		
		</tbody>	
		<%
		  while(iter.hasNext()) {
		  Sysperms sysperms = (Sysperms) iter.next();
		%>
		  <tr>
		     <td>		
		        <%if("402881dc0d7cf641010d7cfb03d10016".equals(sysperms.getId()) && "402881e50bf0a737010bf0a96ba70004".equals(roleId)){%>			    
					<input  type="checkbox" name="check_node" disabled="disabled" value="<%=sysperms.getId()%>">	
				<%}else{%>
					<input  type="checkbox" name="check_node" value="<%=sysperms.getId()%>">	
				<%}%>
				<input type="hidden" name="permsid" value="<%=sysperms.getId()%>" />
			 </td>
			 <td class="FieldValue">
			    <%=StringHelper.null2String(sysperms.getOperation())%>
			 </td>
			 <td class="FieldValue">
			    <%=StringHelper.null2String(sysperms.getPermdesc())%>
			 </td>			 
		  </tr>
		<%
		 } //end while
		%>				
	  </table>

  </form>		

<script language="javascript">
     function getBrowser(url){
           var ids;
           try{
               ids=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
           }catch(e){}
        if (ids!=null) {
           if(ids[0]!='0'){
               doSearch(ids[0]);
           }else{
           }
        }
       }
 
 function doSearch(ids){ 
  var id ="";
  var permsList =  new Array();
  permsList = ids.split(",");
  for (i=0;i<permsList.length;i++){
    id = permsList[i] 
    SyspermsService.get(getSysperms,id); 
  }
}

function getSysperms(Sysperms){
  var operation = "";
  var permsid = "";
  var permsdesc = ""; 
  if (Sysperms==null) return;
  permsid = Sysperms.id;
  operation = Sysperms.operation;
  permsdesc = Sysperms.permdesc;
  if (checkId(permsid))
    addRow(permsid,operation,permsdesc);
}

function checkId(id){
  if (document.all("permsid") == null) 
     return true;
  if (document.all("permsid").length == undefined){ //多行
      if(Trim(id) == Trim(document.all("permsid").value))
         return false;
     }else{//一行

     var idArray = document.all("permsid");
     if (idArray.length>0) {
      for (i=0;i<idArray.length ;i++){
 //     alert(4+"+"+i);
 //     alert(Trim(id));
 //     alert(Trim(idArray[i].value));
  //    alert(Trim(id) == Trim(idArray[i].value));
        if (Trim(id) == Trim(idArray[i].value)){
          return false;
        }
       }
      } 
     }
 
  
  return true;
}

function  addRow(permsid,operation,permsdesc){
	ncol = vTable.cols;
	oRow = vTable.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node' value='0'><input  type='hidden' name='permsid' value='"+permsid+"'> "; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;		
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = operation;
				if (sHtml!= null)
				  oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = permsdesc;
				if (sHtml!=null)
				  oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;				
						
		}
	}	 
  
}

function delRow()
{
  if (confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {

		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
			    vTable.deleteRow(rowsum1-1);					
			}
			rowsum1 -=1;
		}
	}	
 }// end if	
}

function onSubmit(){
 document.EweaverForm.submit();
}	
     function toBack(){
         <%if(id!=null&&!"".equals(id)){%>
            location.href='<%= request.getContextPath()%>/base/security/sysrole/sysrolelist_designatedusers.jsp?id=<%=id%>&selectItemId=<%=selectItemId%>';
         <%}else{%>
            location.href='<%= request.getContextPath()%>/base/security/sysrole/sysrolelist.jsp?selectItemId=<%=selectItemId%>';
         <%}%>
     }
	
</script>	
  </body>
</html>

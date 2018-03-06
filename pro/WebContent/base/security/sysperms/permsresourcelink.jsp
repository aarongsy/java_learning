<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%
  String permsId = StringHelper.trimToNull(request.getParameter("permsId"));
  Selectitem selectitem = new Selectitem();
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
 // permsId = "402881ea0b9f657b010b9f67ac950009";
  SyspermsService syspermsService = (SyspermsService) BaseContext.getBean("syspermsService");
//  Sysperms sysperms = new Sysperms();
  Sysperms sysperms = syspermsService.get(permsId);
  Set  resSet = sysperms.getResources();
  Iterator iter = resSet.iterator(); 
%>


<html>
    <%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){getBrowser('/base/security/sysresource/sysresourcebrowserm.jsp')});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){delRow()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){toBack()});";

%>
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
	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SyspermsAction?action=permsreslink" name="EweaverForm" method="post">
      <input type="hidden" name="id" value="<%=permsId%>">
      <table cols=5 id="vTable">
      	<COLGROUP>
      		<COL width="4%">
			<COL width="26%">
			<COL width="20%">	
			<COL width="50%">			
		</COLGROUP>	
		<tbody>
			<tr class=Header>
				<td></td> <!--表头 字段-->
				<td><%=labelService.getLabelName("402881eb0bcbfd19010bcc694bf8001f")%></td>
				<td>资源分类</td>
				<td>资源串</td>
			</tr>   	  	        
		</tbody>
		<%
		  while(iter.hasNext()) {
		  Sysresource sysresource = (Sysresource) iter.next();
		%>
		  <tr>
		     <td>					     
				<input  type='checkbox' name='check_node' value='<%=sysresource.getId()%>'>	
				<input type="hidden" name="resid" value="<%=sysresource.getId()%>" />
			 </td>
			 <td class="FieldValue">
			    <%=StringHelper.null2String(sysresource.getResname())%>
			 </td>
			 <td class="FieldValue">
			  <%
			    String objtypeName = "";
			    selectitem = selectitemService.getSelectitemById(StringHelper.null2String(sysresource.getObjtype()));
			    if (selectitem!=null) objtypeName = StringHelper.null2String(selectitem.getObjname());
			  %>
			    <%=objtypeName%>
			 </td>		
			 <td class="FieldValue">
			   <%=StringHelper.null2String(sysresource.getResstring())%>
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
  //alert(ids);
  var resourceList =  new Array();
  resourceList = ids.split(",");
  for (i=0;i<resourceList.length;i++){
    id = resourceList[i] 
    SysresourceService.get(getSysresource,id); 
  }
}

function getSysresource(Sysresource){
  var resname = "";
  var resid = "";
  var resdesc = ""; 
  if (Sysresource==null) return;
  resid = Sysresource.id;
  resname = Sysresource.resname;
  resdesc = Sysresource.resdesc;
  if (checkId(resid))
    addRow(resid,resname,resdesc);
}

function checkId(id){
  if (document.all("resid") == null) 
     return true;
  if (document.all("resid").length == undefined){ //多行
      if(Trim(id) == Trim(document.all("resid").value))
         return false;
     }else{//一行

     var idArray = document.all("resid");
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

function  addRow(resid,resname,resdesc){
	ncol = vTable.cols;
	oRow = vTable.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node' value='0'><input  type='hidden' name='resid' value='"+resid+"'> "; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;		
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = resname;
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = resdesc;
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
  }
}

function onSubmit(){
 document.EweaverForm.submit();
}

function toBack(){
      document.location.href='<%=request.getContextPath()%>/base/security/sysperms/syspermslist.jsp';
     }

</script>
  </body>
</html>

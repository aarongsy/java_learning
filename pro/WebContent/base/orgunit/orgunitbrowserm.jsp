<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%
String orgunitid=StringHelper.null2String(request.getParameter("orgunitid"));
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
Selectitem reftypeobj = selectitemService.getSelectitemById(reftype);

String reftypedesc = StringHelper.null2String(reftypeobj.getObjdesc());
if(reftypedesc.equals(""))
	reftypedesc = "1";
if(StringHelper.isEmpty(orgunitid)){
	orgunitid = "402881e70ad1d990010ad1e5ec930008";
}	
String rootid = orgunitid;	
%>

<html>
<head>
<script type="text/javascript" src="/js/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu"); 
</script>
</head>  
<body>    
	  
<!--页面菜单开始-->     
<%
pagemenustr += "{O,"+labelService.getLabelName("402881eb0bcbfd19010bcc6e71870022")+",javascript:btnok_onclick()}";
pagemenustr += "{C,"+labelService.getLabelName("402881eb0bcbfd19010bcc6f1e6e0023")+",javascript:window.close()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
   	<form action="" name="EweaverForm"  method="post">  
<script>
/* setup menu actrions */
dojo.addOnLoad(function() {
 	var treeController = dojo.widget.manager.getWidgetById('treeController');
    var treeNode = dojo.widget.manager.getWidgetById('<%=rootid%>');
    treeController.expand(treeNode);
});
</script>
<TABLE ID=searchTable width="100%" height="100%" class="noborder"> 
<tr>
<td width="20%" valign="top">

<%		

				List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
	if(selectlist.size()>0){%>
			<SELECT  onChange="window.location.href='orgunitbrowserm.jsp?orgunitid=<%=orgunitid%>&reftype='+this.value;">			
<%			 	Iterator it = selectlist.iterator();
				while (it.hasNext()){
					Selectitem selectitem = (Selectitem)it.next();					
					String selected = selectitem.getId().equals(reftype)?"selected":"";
%>
				<OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%></OPTION>
<%			}%>
			</SELECT>
<%		}%>
		<div dojoType="TreeRPCController" RPCUrl="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitTreeAction?reftype=<%=reftype %>&action=getChildren&type=browser" widgetId="treeController" DNDController="create"></div>
		<div dojoType="TreeSelector" widgetId="treeSelector"></div>
		<div dojoType="Tree" DNDMode="between" selector="treeSelector" actionsDisabled="move" widgetId="Tree"  controller="treeController"  toggler="explor">
		  <%
  	Orgunit orgunit = orgunitService.getOrgunit(rootid);
				String objid = orgunit.getId();
				String objname=orgunit.getObjname();
				String isfolder = "true";

					objname = "<a href='#' onclick=doUrl('"+objid+"'); >"+objname+"</a>";
		  %>
		
		<div dojoType="TreeNode" widgetId="<%=objid%>" object="<%=orgunit.getObjname()%>" objectId="Orgunit_<%=objid%>"  title="<%=objname%>" actionsDisabled="remove"  isFolder="<%=isfolder%>">
		</div>
		</div>
</td>
<td width="80%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="0" align="left" width="100%" class=noborder>
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="<%=request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="<%=request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
				<br>
				<br>
			</td>
			<td align="center" valign="top" width="80%">
				<select size="20"  name="srcList" multiple="true" style="width:100%" class="InputStyle">
				</select>
			</td>
		</tr>
	</table>
</td>
</tr>
</table>
</form>
<script language=vbs>
Sub btnok_onclick()	 
	getArray getStr("key"),getStr("text")
End Sub

Sub btnclear_onclick()
     getArray "0",""
End Sub
</script>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
<script language="javascript">  
function changeroot(root) {
	var url = 'categorybrowserm.jsp?root='+root+"&categoryid="+getStr("key");
	window.location.href=url
}
function getStr(mode){
	var str = "" ;
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i < len; i++) {
		if(mode=="key"){
			var key = destList.options[i].value;
			if(key!="null" && key!="")
				str += key + ",";
		}else if(mode=="text"){
			var text = destList.options[i].innerText;
			if(text!="")
				str += text + ",";
		}
	}
	if (str.length!=0)
		str = str.substring(0,str.length-1);
//		alert(str);
	return str;
}

function getNodetitle(objval){
	objNode = dojo.widget.manager.getWidgetById(objval);
	var retval = "/"+objNode.object;
	objNode = objNode.parent;
	while(objNode != null){
		if(getValidStr(objNode.object) != "")
			retval = "/"+objNode.object +retval;
		objNode = objNode.parent;
	}
	return retval;
}
function doUrl(key){
	event.srcElement.checked=true;
	var oOption = document.createElement("OPTION");
	if(!isExistEntry(key,document.all("srcList"))){
		document.all("srcList").options.add(oOption);
		oOption.value = key;
		oOption.innerText = getNodetitle(key);	
	}		
}
 
function addAllToList(){
	var treeController = dojo.widget.manager.getWidgetsByType("TreeNode");
	for( nodeindex=0;nodeindex<treeController.length;nodeindex++){
		doUrl(treeController[nodeindex].objectId);
	}
}

function isExistEntry(entry,destList){
	var arrayObj = destList.options;
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].value){
			return true;
		}
	}
	return false;
} 

function deleteAllFromList(){
	var destList  = document.all("srcList");
	destList.options.length=0;
}

function deleteFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if (destList.options[i].selected == true) {
			destList.options.remove(i);
		}
	}
}

function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }

}

function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
}
function doAlert(){
	alert("对不起，你没有权限!");
}
</script> 
</body>
</html>








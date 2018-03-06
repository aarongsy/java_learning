<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.model.Stationinfo"%>
<%@ page import="com.eweaver.humres.base.service.StationinfoService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ include file="/base/init.jsp"%>
<%

String type=StringHelper.null2String(request.getParameter("type"));
String orgid=StringHelper.null2String(request.getParameter("orgid"));
if(orgid.equals("0"))
	orgid = "";
String stationid=StringHelper.null2String(request.getParameter("stationid"));

OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
String from = (String)request.getAttribute("from");
List results = (List)request.getAttribute("list");
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
	
Selectitem reftypeobj = selectitemService.getSelectitemById(reftype);
String reftypedesc = StringHelper.null2String(reftypeobj.getObjdesc());
if(reftypedesc.equals(""))
	reftypedesc = "1";
%>
<html>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.Button");
	dojo.require("dojo.widget.LayoutContainer");
	dojo.require("dojo.widget.LinkPane");	
	dojo.require("dojo.widget.SplitContainer");
	dojo.require("dojo.widget.ContentPane");	
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu");	
	dojo.require("dojo.widget.Dialog");  
	dojo.require("dojo.widget.FloatingPane");   

</script>
  <style>
    html, body{	
		width: 100%;	/* make the body expand to fill the visible window */
		height: 100%;
		padding: 0 0 0 0;
		margin: 0 0 0 0;
    }
	.dojoSplitPane{
		margin: 5px;
	}
	#rightPane {
		margin: 0;
	}
	.dojoDialog {
	background : white;
	border : 1px solid #999;
	-moz-border-radius : 5px;
	padding : 4px;
	text-align: center;
}
   </style>

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

<TABLE ID=searchTable width="100%"> 
<tr>
<td width="50%" valign="top">

<%
if (from==null)
{
%>
<div dojoType="TreeRPCController" RPCUrl="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.StationTreeAction?reftype=<%=reftype %>&type=<%=type%>&orgid=<%=orgid %>" widgetId="treeController" DNDController="create"></div>
  
<div dojoType="TreeSelector"  eventNames="select:nodeSelected"  widgetId="treeSelector"></div>



<table class="treeTable" cellpadding="0" height="100%">
	<tr height="20px">
		<td valign=top>
		
<%		

	List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
	if(selectlist.size()>0){%>
			<SELECT name="reftype" id="reftype" onChange="window.location.href='stationbrowserm.jsp?orgid=<%=orgid %>&type=<%=type %>&reftype='+this.value;">			
<%			 	Iterator it = selectlist.iterator();
				while (it.hasNext()){
					Selectitem selectitem = (Selectitem)it.next();					
					String selected = selectitem.getId().equals(reftype)?"selected":"";
%>
				<OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%></OPTION>
<%			}%>
			</SELECT>
<%		}%>

		</td>
	</tr>
<tr height=2px bgcolor="#CCCCCC"><td></td></tr>
<tr valign=top>
<td style="border:1px black;" valign=top>
<div style="overflow-y:scroll;width:100%;height:520px">
				 <div dojoType="Tree" DNDMode="between" selector="treeSelector" widgetId="Tree"  controller="treeController"  toggler="explor" listeners="treeController"　 style="width: 200px; height: 100%;overflow:auto">
				
				
				
				 <%
				 
String rootid = "402881eb112f5af201112ff3afe10004";
if(!StringHelper.isEmpty(stationid)){
	rootid = stationid;
}
boolean byOrgid = false;
if(!StringHelper.isEmpty(orgid)&&!"402881e70ad1d990010ad1e5ec930008".equals(orgid)){	
		byOrgid = true;
}
if(!StringHelper.isEmpty(rootid)){
	rootid = "402881eb112f5af201112ff3afe10004";
}
if(byOrgid){
				 	
				 	Orgunit orgunit = orgunitService.getOrgunit(orgid);
				 	String objid = orgunit.getId();
				 	String objname = StringHelper.null2String(orgunit.getObjname());									
				
					rootid = objid;
						String isfolder = "true";
				%>
						<div dojoType="TreeNode" objectId="Orgunit" object="<%=objname %>" widgetId="<%=objid%>"  title="<%=objname%>" isFolder="<%=isfolder%>">
				
						</div>
<%}else{
	Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(rootid);
	
				 	String stationname = StringHelper.null2String(stationinfo.getObjname());
				 	String showname = "<a href='#' onclick=doUrl('"+rootid+"'); >"+stationname+"</a>";
				
						String isfolder = "true";
%>

						<div dojoType="TreeNode" objectId="Station" object="<%=stationname %>" widgetId="<%=rootid%>"  title="<%=showname%>" isFolder="<%=isfolder%>">
				
						</div>
<%} %>						
						
				</div>

<script>

/* setup menu actrions */
dojo.addOnLoad(function() {

 	var treeController = dojo.widget.manager.getWidgetById('treeController');
    var treeNode = dojo.widget.manager.getWidgetById('<%=rootid%>');
    
    	treeController.expand(treeNode);
});


</script>

</td>
</tr>
</table>

<%

}
else 
	{
%>
<table id=BrowserTable class=BrowserStyle>
	<%
		if (results!=null&&results.size()!=0){
				String path = "";
				boolean isLight = false;
				String trclassname = "";
				for (int i=0;i<results.size();i++){
				
					Stationinfo stationinfo = (Stationinfo)results.get(i);
					path = stationinfo.getObjname();
					isLight = !isLight;
					if (isLight)
						trclassname = "DataLight";
					else
						trclassname = "DataDark";
				%>
    			 <TR class="<%=trclassname%>">
						<TD width="0%" style="display:none"><%=stationinfo.getId()%></TD>
						<TD><%=path%></TD>
				 </TR>
				 <%
				 }
				 %>
    <%				
		}else{
	%>
	<span><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0030")%></span><!-- 没有搜索到您需要的岗位 -->
	<%
		}}
	%>
	</dev>
</td>
<td width="50%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%" class=noborder>
		<tr>
			<td align="center" valign="top" width="10%">
				<img src="<%=request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="<%=request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src=<%=request.getContextPath()%>"/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
				<br>
				<br>
			</td>
			<td align="center" valign="top" width="80%">
				<div style="overflow-x:scroll;width:400;">
				<select size="20"  name="srcList" multiple="true" style="width:800" class="InputStyle">
				</select>
				</div>
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
		//alert(treeController[nodeindex].widgetId);
		doUrl(treeController[nodeindex].widgetId);
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
	alert("<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0031")%>");//对不起，你没有权限!
}
</script> 
</body>
</html>
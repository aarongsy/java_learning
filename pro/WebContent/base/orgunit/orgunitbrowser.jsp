<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.*" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%
String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
String suborg = StringHelper.null2String(request.getParameter("suborg"));
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
String from = (String)request.getAttribute("from");
List results = (List)request.getAttribute("list");
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
String hidereftype = StringHelper.null2String(request.getParameter("hidereftype"));
String idsin=StringHelper.null2String(request.getParameter("idsin"));
if(!StringHelper.isEmpty(idsin)){
	Orgunit orgunit=orgunitService.getOrgunit(idsin);
	reftype=orgunit.getReftype();
}

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
List<Orgunit> ous=orgunitService.find("from Orgunit where isRoot=1");
String rootid="";
for(Orgunit ou:ous){
    if(ou.getReftype().equals(reftype)){
        rootid=ou.getId();
    	break;
    }
}
if(StringHelper.isEmpty(rootid)){
	rootid = "402881e70ad1d990010ad1e5ec930008";
}
	
Selectitem reftypeobj = selectitemService.getSelectitemById(reftype);

String reftypedesc = StringHelper.null2String(reftypeobj.getObjdesc());
if(reftypedesc.equals(""))
	reftypedesc = "1";

%>

<html>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/dojo.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu"); 
</script>
<script language="javascript">
var dialogValue;
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
</script>

<script>
	function doUrl(objval){
		var title = getNodetitle(objval);
	     getArray (objval,title);
	}
	
    function getArray(id,value){
    	if(!Ext.isSafari){
		    window.parent.returnValue = [id,value];
	        window.parent.close();
 		}else{
 		   dialogValue=[id,value];
 	       parent.win.close();
 		}
    }
</script>
</head> 
<body >	
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitAction?action=search" name="EweaverForm" method="post">
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:EweaverForm.submit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:onReturn()}";
pagemenustr += "{Q,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<table>	
    <!-- 列宽控制 -->		
    <colgroup>
        <col width="20%">
        <col width="80%">
    </colgroup>
    <tr>
        <td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
        <td class="FieldValue"><input class="inputstyle" type="text" size="30" name="orgname"  id="orgname"/>
            <span id="objnamespan"></span></td>
    </tr>
</table>
<%@ include file="/base/pagemenu.jsp"%>
<%
if (from==null)
{
%>

<script>
/* setup menu actrions */
dojo.addOnLoad(function() {
 	var treeController = dojo.widget.manager.getWidgetById('treeController');
    var treeNode = dojo.widget.manager.getWidgetById('<%=rootid%>');
    treeController.expand(treeNode);
});
</script>

<%if(!hidereftype.equals("1")){

				List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
	if(selectlist.size()>0){%>
			<SELECT  onChange="window.location.href='orgunitbrowser.jsp?reftype='+this.value;">			
<%			 	Iterator it = selectlist.iterator();
				while (it.hasNext()){
					Selectitem selectitem = (Selectitem)it.next();					
					String selected = selectitem.getId().equals(reftype)?"selected":"";
%>
				<OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%></OPTION>
<%			}%>
			</SELECT>
<%		}}%>
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

<div dojoType="TreeNode" widgetId="<%=rootid%>" object="<%=orgunit.getObjname()%>" objectId="Orgunit_<%=objid%>"  title="<%=objname%>" actionsDisabled="remove"  isFolder="<%=isfolder%>">
</div>
</div>
<%

}
else 
	{
%>
<table id=BrowserTable class=BrowserStyle>
	<%
		if (results!=null&&results.size()!=0){
				Orgunit orgunit = new Orgunit();
				String path = "";
				boolean isLight = false;
				String trclassname = "";
				for (int i=0;i<results.size();i++){
				
					orgunit = (Orgunit)results.get(i);					
					if(orgunit.getUnitStatus().equalsIgnoreCase("402880d31a04dfba011a04e4db5f0004"))continue;//如果非活跃则跳过
					path = orgunitService.getOrgunitPath(orgunit.getId());
					isLight = !isLight;
					if (isLight)
						trclassname = "DataLight";
					else
						trclassname = "DataDark";
				%>
    			 <TR class="<%=trclassname%>">
						<TD width="0%" style="display:none"><%=orgunit.getId()%></TD>
						<TD><%=path%></TD>
				 </TR>
				 <%
				 }
				 %>
    <%				
		}else{
	%>
	<span>没有搜索到您需要的组织.</span>
	<%
		}
	%>
</table>
<%
	}
%>
</form>
</body>
<script type="text/javascript">
	function btnclear_onclick(){
		 getArray ("0","");
	}

	function onReturn(){
		 if(!Ext.isSafari){
			window.parent.close();
		 }else{
			 parent.win.close();
		 }
	}
	
	function getEvent(){
		if(document.all){
			return window.event;//如果是ie
		}
		func=getEvent.caller;
		while(func!=null){
			var arg0=func.arguments[0];
			if(arg0){
				if((arg0.constructor==Event || arg0.constructor ==MouseEvent)||(typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)){
					return arg0;
				}
			}
			func=func.caller;
		}
		return null;
	}

		
	jQuery(function($){
			var BrowserTable  = $("#BrowserTable");
			BrowserTable.on("click", function(){
				var evt=getEvent();
				var e=evt.srcElement || evt.target;
				if(e.tagName == "TD"){
					//alert(e+"---"+evt+"==="+e.tagName+"---2"+e.parentElement.tagName+"--3--");
					getArray ((e.parentElement.cells)[0].innerHTML,(e.parentElement.cells)[1].innerHTML);
				}else if(e.tagName == "A"){
					getArray ((e.parentElement.parentElement.cells)[0].innerHTML,(e.parentElement.cells)[1].innerHTML)
				}
			});
			
			BrowserTable.on("mouseover", function(){
				var evt=getEvent();
				var e=evt.srcElement || evt.target;
				if(e.tagName == "TD"){
					$(e.parentElement).attr("class","Selected");
				}else if(e.tagName == "A"){
					$(e.parentElement.parentElement).attr("class","Selected");
				}
			});
			
			BrowserTable.on("mouseout", function(){
				var p;
				var evt=getEvent();
				var e=evt.srcElement || evt.target;
				if(e.tagName == "TD" ){
					p = e.parentElement
				}else if(e.tagName == "A"){
					p = e.parentElement.parentElement;
				}
				if(p.RowIndex%2){
					$(p).attr("class","DataLight");
				}else{
					$(p).attr("class","DataDark");
				}
			});
	});
	
</script>
</html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.model.Stationinfo"%>
<%@ page import="com.eweaver.humres.base.service.StationinfoService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
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
  <head><title></title>
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

<script language="javascript">
function getNodetitle(objval){
	objNode = dojo.widget.manager.getWidgetById(objval);
	var retval = objNode.object;
	return retval;
}
</script>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     getArray "0",""
End Sub
Sub doUrl(objval)
	title = getNodetitle(objval)
     getArray objval,title
End Sub
</script>
      <script>
    function doUrl(objval){
    	var title = getNodetitle(objval);
    	getArray(objval, title);
    }
    function btnclear_onclick(){
    	getArray("0", "");
    }
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
          function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>

  </head> 	
  <body >	
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=search" name="EweaverForm" method="post">
 <table>
        <colgroup>
            <col width="20%">
            <col width="80%">
        </colgroup>
        <tr>
            <td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
            <td class="FieldValue"><input class="inputstyle" type="text" size="30" name="stationinfoname" id="stationinfoname" />
                <span id="objnamespan"></span></td>
        </tr>
</table>

  <%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:EweaverForm.submit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.parent.close()}";
pagemenustr += "{Q,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<%
if (from==null)
{
%>
<%		

	List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
	if(selectlist.size()>0){%>
			<SELECT name="reftype" id="reftype" onChange="window.location.href='/humres/base/stationbrowser.jsp?orgid=<%=orgid %>&type=<%=type %>&reftype='+this.value;">			
<%			 	Iterator it = selectlist.iterator();
				while (it.hasNext()){
					Selectitem selectitem = (Selectitem)it.next();					
					String selected = selectitem.getId().equals(reftype)?"selected":"";
%>
				<OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%></OPTION>
<%			}%>
			</SELECT>
<%		}%>
	<div dojoType="TreeRPCController" RPCUrl="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.StationTreeAction?reftype=<%=reftype %>&type=<%=type%>&orgid=<%=orgid %>" widgetId="treeController" DNDController="create"></div>
	<div dojoType="TreeSelector"  eventNames="select:nodeSelected"  widgetId="treeSelector"></div>
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
					if(!stationinfo.getStationStatus().equalsIgnoreCase("402880d319eb81720119eba4e1e70004"))continue;
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
                        <TD><%=orgunitService.getOrgunitPath(stationinfo.getOrgid())%></TD>
				 </TR>
				 <%
				 }
				 %>
    <%				
		}else{
	%>
	<span><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0030")%></span><!-- 没有搜索到您需要的岗位 -->
	<%
		}
	%>
</table>
<%
	}
%>
</form>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     getArray "0",""
End Sub
Sub BrowserTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     getArray e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText
   ElseIf e.TagName = "A" Then
      getArray e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText
   End If
End Sub
Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>
</body>
</html>

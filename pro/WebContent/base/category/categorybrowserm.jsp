<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%
String model = StringHelper.trimToNull(request.getParameter("model"));
String method = StringHelper.trimToNull(request.getParameter("method"));
String categoryid = StringHelper.trimToNull(request.getParameter("categoryid"));
String root = StringHelper.trimToNull(request.getParameter("root"));
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
List selectlist = new ArrayList();
List categorylist = new ArrayList();
List categoryselectlist ;
List results = (List)request.getAttribute("results");
String from = (String)request.getAttribute("from");
int isSearch=0;
if(categoryid!=null)
	categoryselectlist = categoryService.getCategoryListById(categoryid.split(","));
else categoryselectlist = new ArrayList();

String idsin = StringHelper.null2String(request.getParameter("idsin"));	//已选中id(?,?,?)　调用browser时传入

String idsselected = StringHelper.null2String(request.getAttribute("humresidsselected"));	//已选中id(?,?,?)　搜索后传回

if(!idsin.equals("")){
	idsselected = idsin;
}
/*
String ids ="";
if("Docbase".equalsIgnoreCase(model)){
	//ids= setitemService.getSetitem("402881e90bb3dbc8010bb3f0acd20008").getItemvalue();
	selectlist = categoryService.getCategoryListById(StringHelper.string2Array(ids,","));
}
if(selectlist.size()==0){
	selectlist = categoryService.getSubCategoryList2(null,model,null,null);	
}
if(root==null){
	if("create".equals(method)){
		categorylist = categoryService.getSubCategoryList(((Category)selectlist.get(0)).getId(),model);
	}else{
		categorylist = categoryService.getSubCategoryList2(((Category)selectlist.get(0)).getId(),model,null,null);
	}
	
}else{
	if("create".equals(method)){
		categorylist = categoryService.getSubCategoryList(root,model);
	}else{
	categorylist = categoryService.getSubCategoryList2(root,model,null,null);
	}
}*/
%>
<html>
<head>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu"); 	
</script>
<script language="javascript">
function getNodetitle(objval){
	objNode = dojo.widget.manager.getWidgetById(objval);
	var retval = objNode.title;
	objNode = objNode.parent;
	while(objNode != null){
		if(getValidStr(objNode.title) != "")
			retval = objNode.title +"/"+retval;
		objNode = objNode.parent;
	}
	return retval;
}
</script>
</head>  
<body>
<FORM action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryAction?action=searchm&method=<%=method%>" name="Form" id="Form" method="post">
		<INPUT name=idsin type=hidden value="<%=StringHelper.null2String(idsin)%>">
		<INPUT name=model type=hidden value="<%=StringHelper.null2String(model)%>">
		<INPUT name=categoryname id=categoryname class="InputStyle2" type=text>
</FORM> 
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:Form.submit()}";
pagemenustr += "{O,"+labelService.getLabelName("402881eb0bcbfd19010bcc6e71870022")+",javascript:btnok_onclick()}";
pagemenustr += "{C,"+labelService.getLabelName("402881eb0bcbfd19010bcc6f1e6e0023")+",javascript:window.close()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

<!---------- 如果是初始,在此处显示分类树 ------------>

<%
if (from==null){
isSearch=0;
%>
   	<form action="" name="EweaverForm"  method="post">  
   	<input type="hidden" name="categoryid" value="<%=categoryid%>"/>
   	
<!------------------- selectlist下拉选单 ----------->
	<TABLE ID=searchTable width="100%">   
 	<tr>             
 		<td class="FieldName" width="10%" nowrap><%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%></td>                  
		<td class="FieldValue">
<%		if(selectlist.size()>0){%>
			<SELECT name="root" onChange="changeroot(this.value)">			
<%			 	Iterator it = selectlist.iterator();
				while (it.hasNext()){
					Category category = (Category)it.next();					
					String selected = category.getId().equals(root)?"selected":"";
%>
				<OPTION value="<%=category.getId()%>" <%=selected%>><%=category.getObjname()%></OPTION>
<%			}%>
			</SELECT>
<%		}%>
		</td>
	</tr>
	</TABLE>
<!-- 显示分类树 ----------------------------->
	<TABLE>
	<tr>
		<td width="60%" valign=top>
<%
if("create".equals(method)){
%>
<div dojoType="TreeRPCController" RPCUrl="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenForCreate&model=<%=model%>" widgetId="treeController" DNDController="create"></div>
<%}else{%>  
<div dojoType="TreeRPCController" RPCUrl="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenForSelect&model=<%=model%>" widgetId="treeController" DNDController="create"></div>
<%}%> 
<div dojoType="TreeSelector" widgetId="treeSelector"></div> 
<div dojoType="Tree" DNDMode="between" selector="treeSelector" actionsDisabled="move" widgetId="Tree"  controller="treeController"  toggler="explor" style="overflow-y:scroll;width:100%;height:380px" >
   
  <%
  Iterator it = categorylist.iterator();
while (it.hasNext()){
	Category category = (Category)it.next();	
	String objname=category.getObjname();
	String objid = category.getId();
	int childrennum = category.getChildrennum().intValue();
	String isfolder = "false";
	if(childrennum>0)
		isfolder = "true";
	if("create".equals(method)){
		if("1".equals(category.getCol3())){
			objname = "<a href='#' onclick=doUrl('"+objid+"'); >"+objname+"</a>";
		}		
	}else{
		objname = "<a href='#' onclick=doUrl('"+objid+"'); >"+objname+"</a>";
	}
	
%>

    <div dojoType="TreeNode" widgetId="<%=objid%>" objectId="<%=objid%>"  object="<%=category.getObjname()%>" title="<%=objname%>" actionsDisabled="move" isFolder="<%=isfolder%>">
    </div>
    <%}%>
</div>
	</td>
	<td width="40%" valign="top">
	<!--########Select Table Start########-->
		<table  cellspacing="1" align="left" width="100%" class=noborder>
			<tr>
				<td align="center" valign="top" width="30%">
					<img src="<%= request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%>" onclick="javascript:upFromList();">
					<br><br>
						<img src="<%= request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList(<%=isSearch%>)">
					<br><br>
					<img src="<%= request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
					<br><br>
					<img src="<%= request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>" onclick="javascript:deleteAllFromList();">
					<br><br>
					<img src="<%= request.getContextPath()%>/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
					<br>
					<br>
				</td>
				<td align="center" valign="top" width="70%">
				<div style="overflow-x:scroll;width:400;">
	 				<select size="20"  name="srcList" multiple="true" style="width:800" class="InputStyle">
	          <% for(int i=0;i<categoryselectlist.size();i++){
					Category category = (Category)categoryselectlist.get(i);
	          %>
					<OPTION value="<%=category.getId()%>"><%=categoryService.getCategoryPath(category.getId(),null,null)%></OPTION>
	           <%}
	           
	           		String[] categoryids = idsin.split(",");
	           		for(int j=0; j< categoryids.length; j++){
	           	%>
	           		<OPTION value="<%=categoryids[j]%>"><%=categoryService.getCategoryPath(categoryids[j],null,null)%></OPTION>
	           	<%
	           		}
	          
	           %>

					</select>
					</div>
				</td>
			</tr>
		</table>
	</td>
	</tr>
	</table> 
    </form>
    
<!-- 如果是搜索出来的结果，则在原来显示分类树的地方显示搜索出来的列表 -->

<%

}else{
isSearch=1;
%>
	<TABLE width="100%">   
 	<tr>             
 		<td class="FieldName" width="10%" nowrap><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790063")%><!-- 搜索结果 --></td>               
	</tr>
	</TABLE>
	
	<TABLE>
	<tr>
		<td width="60%" valign="top">
			<TABLE ID=BrowserTable class=BrowserStyle>
				<%
				if(results.size()!=0){
					boolean isLight = false;
					String trclassname = "";
					Category category = new Category();
					for (int i = 0 ;i< results.size();i++){
						category = (Category)results.get(i);
						String path = categoryService.getCategoryPath(category.getId(),null,null);
						isLight = !isLight;
						if (isLight)
							trclassname = "DataLight";
						else
						trclassname = "DataDark";
						%>
						<TR class="<%=trclassname%>">
							<TD width="0%" style="display:none"><%=category.getId()%></TD>
							<TD><%=path%></TD>
						</TR>
				   <%}
				}
				else{
				%>
				 <tr><td width="0%"></td><td width="0%"></td><td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790064")%><!-- 没有搜索到您要的分类 . --><td></tr>
				<%
				}
				%>
		    </TABLE>
		</td>
	    <td width="40%" valign="top">
	   
<!--------Select Table Start---------->

			<table  cellspacing="1" align="left" width="100%" class=noborder>
				<tr>
					<td align="center" valign="top" width="30%">
						<img src="<%= request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%>" onclick="javascript:upFromList();">
						<br><br>
							<img src="<%= request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList()">
						<br><br>
						<img src="<%= request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
						<br><br>
						<img src="<%= request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>" onclick="javascript:deleteAllFromList();">
						<br><br>
						<img src="<%= request.getContextPath()%>/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
						<br>
						<br>
					</td>
					<td align="center" valign="top" width="70%">
		 				<select size="20"  name="srcList" multiple="true" style="width:100%" class="InputStyle">
				          <% for(int i=0;i<categoryselectlist.size();i++){
								Category category = (Category)categoryselectlist.get(i);
				          %>
								<OPTION value="<%=category.getId()%>"><%=categoryService.getCategoryPath(category.getId(),null,null)%></OPTION>
				           <%}
	           		String[] categoryids = idsin.split(",");
	           		for(int j=0; j< categoryids.length; j++){
	           	%>
	           		<OPTION value="<%=categoryids[j]%>"><%=categoryService.getCategoryPath(categoryids[j],null,null)%></OPTION>
	           	<%
	           		}
				           %>
				           
				           		
						</select>
					</td>
				</tr>
			</table>
	 </td>
	</tr>
	</table> 
<%}%>
<script language=vbs>
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

Sub btnok_onclick()	 
	getArray getStr("key"),getStr("text")
End Sub

Sub btnclear_onclick()
     getArray "0",""
End Sub
</script>
<script language="javascript">

function changeroot(root) {
	var url = 'categorybrowserm.jsp?model=<%=StringHelper.null2String(model)%>&method=create&root='+root+"&categoryid="+getStr("key");
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
 
function addAllToList(isSearch){
	if (isSearch==0){
	    var treeController = dojo.widget.manager.getWidgetsByType("TreeNode");
		for( nodeindex=0;nodeindex<treeController.length;nodeindex++){
			doUrl(treeController[nodeindex].objectId);
		}
	}
	else {
	   var table =document.all("BrowserTable");
	   for(var i=0;i<table.rows.length;i++){
		  var str = table.rows(i).cells(0).innerText+"~"+table.rows(i).cells(1).innerText ;
		  if(!isExistEntry(str,document.all("srcList")))
			 addObjectToSelect(document.all("srcList"),str);
	   }
	}
}

function addObjectToSelect(obj,str){
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	oOption.innerText = str.split("~")[1];
}

function isExistEntry(entry,destList){
	var arrayObj = destList.options;
	for(var i=0;i<arrayObj.length;i++){
		if(entry.split("~")[0] == arrayObj[i].value){
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
<script language="javascript" for="BrowserTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var str = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
	    if(!isExistEntry(str,document.all("srcList")))
			 addObjectToSelect(document.all("srcList"),str);
	}
</script>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
</body>
</html>








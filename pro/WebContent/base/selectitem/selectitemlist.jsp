<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ include file="/base/init.jsp"%>

<%
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
String mode=StringHelper.null2String(request.getParameter("mode"));
String pid=StringHelper.trimToNull(request.getParameter("pid"));
String typeid=request.getParameter("typeid");
String searchName=StringHelper.null2String((String)request.getAttribute("searchName"));
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService"); 
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
SelectitemtypeService selectitemtypeService=(SelectitemtypeService)BaseContext.getBean("selectitemtypeService");
Selectitem selectitem = null;
Selectitem selectitem2=null;
String selectitemnameP = "";

if(pid != null){
	selectitem = selectitemService.getSelectitemById(pid);
	selectitem2=selectitemService.getSelectitemById(pid);
	selectitemnameP=selectitem.getObjname();
	typeid=selectitem.getTypeid();
}
Selectitemtype selectitemtype=selectitemtypeService.getSelectitemtypeById(typeid);

String gobackURL = "javascript:onReturn();";
if("browser".equals(mode))
	gobackURL = "javascript:window.close();";
List selectitemlist=(List)request.getAttribute("selectitemlist");
if(selectitemlist==null){
	selectitemlist = selectitemService.getSelectitemList2(typeid,pid);
}
%>

<html>
  <head>
<style>
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #A5ACB2;
	border-right-color: #A5ACB2;
	border-bottom-color: #A5ACB2;
	border-left-color: #A5ACB2;
}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
</head>
  
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",javascript:addRow()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:if(confirm('"+labelService.getLabelName("402881e90aac1cd3010aac1d97730001")+"'))delRow();}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+","+gobackURL+"}";
%>
<table width="100%" class="noborder">
  <tr>
    <td width="50%"><div id="pagemenubar" style="z-index:100;"></div></td>
    <td width="50%" style="text-align:left">&nbsp;&nbsp;<input class="infoinput" type="text" size="10" name="inputTxt" value="<%=searchName%>">
    <input type="button" name="Button" value="Search" onClick="javascript:search();" title="<%=labelService.getLabelName("402881e50acc0d40010acc4452220002")%>">    </td>
  </tr>
</table>

<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemAction?action=crud" name="EweaverForm" method="post">
		 <input type="hidden" name="searchName" value="">
		 <input type="hidden" name="mode" value="<%=mode%>">
		 <input type="hidden" name="typeid" value="<%=typeid%>">
		 <input type="hidden" name="delids">
		 <input type="hidden" name="ids">
        <input type="hidden" name="moduleid" value="<%=StringHelper.null2String(moduleid)%>">
         <input type="hidden" name="pid" value="<%=StringHelper.null2String(pid)%>">
	<table cols=8 id="vTable">
      	<COLGROUP>
      		<COL width="4%">
      		<COL width="18%">
			<COL width="16%">
			<COL width="1%">
			<COL width="15%">
            <COL width="7%">
			<COL width="28%">
            <COL width="5%">
            <COL width="5%">
        </COLGROUP>
		<tbody>
			<tr class=Header>
				<td></td> <!--表头 字段-->
				<td>id</td>
				<td><%=labelService.getLabelName("402881e50acc0d40010acc4452220002")%></td>
				<td></td>
				<td><%=labelService.getLabelName("402881e50ad58ade010ad5901f9f0002")%></td>
				<td><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
                <td><%=labelService.getLabelName("6b713c1d108149deabef298ec524bdc5")%></td>
                <td>无效</td>
				<td></td>				
			</tr>
     <%
       
       if (selectitemlist.size() != 0 ) {
         for (int i=0;i<selectitemlist.size();i++){
           selectitem = (Selectitem) selectitemlist.get(i);
         
     %>		
	           <tr class=DataLight>
	                <td>					    
					    <input  type='checkbox' name='check_node' value='<%=selectitem.getId()%>'>	
					    <input type="hidden" name="id" value="<%=selectitem.getId()%>" />
					</td>
					<td>
						<input style="width:100%" type="text" name="selectid"  value="<%=selectitem.getId()%>" readonly="ture"/>
					</td>
					<td nowrap align="right">
					 	<input style="width:90%" type="text" name="objname"  value="<%=selectitem.getObjname()%>" id="objname<%=selectitem.getId()%>" onChange="checkInput('objname<%=selectitem.getId()%>','objname<%=selectitem.getId()%>span')"/>
						<span id="objname<%=selectitem.getId()%>span" style="width: 5%;display:inline-block;"/></span>
					</td>
					<td nowrap>
					 	<%=labelCustomService.getLabelPicHtml(selectitem.getId(), LabelType.Selectitem) %>
					</td>
					<td>
						<input style="width:95%" type="text" name="objdesc"  value="<%=StringHelper.null2String(selectitem.getObjdesc())%>"/>
					</td>	
					<td>
						<input style="width:95%" type="text" name="dsporder"  value="<%=selectitem.getDsporder()%>"/>
					</td>

                   <td >
                       <%
                           if(!StringHelper.isEmpty(selectitem.getImagefield())) {
                       %>
                        <input style="width:70%" type="text" name="imagfile" value="<%=selectitem.getImagefield()%>"/>
                        <img id="imgFilePre" height='16px' width="16px" src="<%=selectitem.getImagefield()%>" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
                         <%}else{%>
                        <input style="width:70%" type="text" name="imagfile" value=""/>
                        <img id="imgFilePre" height='16px' width="16px" src="" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
                       <%}%>
                    </td>
                    <td>
					    <input  type='checkbox' name='check_node2' <% if((StringHelper.null2String(selectitem.getCol1())).equals("1")) {%> checked <%}%> value='<%=selectitem.getId()%>' />	
					    <input type="hidden" name="istrue" value="<%=selectitem.getId()%>" />
					</td>
					<td nowrap><a href="<%= request.getContextPath()%>/base/selectitem/selectitemlist.jsp?pid=<%=selectitem.getId()%>"><%=labelService.getLabelName("402881e50ad58ade010ad590c1890003")%></a></td>
		  </tr>  			
		<%}
		}
		%>	
	  </tbody>
      </table>
	</form>
  </body>
  
</html>


<script language="JavaScript" src="<%= request.getContextPath()%>/js/addRowBg.js" >
</script>  
<script language="javascript">  
var rowColor="" ;
//var  rowindex = "2";
function addRow()
{
	ncol = vTable.getAttribute("cols");
    rowColor = getRowBg();
	oRow = vTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node' value='0'><input  type='hidden' name='id'> "; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='input' style='width:100%' name='selectid' readonly='true'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var timeFlag = new Date().getTime();
				var oDiv = document.createElement("div"); 
				oDiv.style.marginLeft = "4px";
				var sHtml = "<input class=inputstyle type='input' style='width:92%' name='objname' id='objname"+timeFlag+"' onChange=\"checkInput('objname"+timeFlag+"','objname"+timeFlag+"span')\">";
				sHtml += "<span id='objname"+timeFlag+"span' style='width: 5%;display:inline-block;'/><img align='absMiddle' src='/images/base/checkinput.gif'/></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='objdesc'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;				
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='dsporder' value='1' >";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input style='width:80%' type='text' name='imagfile'   value=''/><img id='imgFilePre' width='16px' height='16px' src='' /><a  onclick='BrowserImages(this);'>浏览..</a>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 7:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node2' value='0'><input  type='hidden' name='istrue'> "; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 8:
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;							
		}
	}
}

function delRow()
{
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
				var did = document.forms[0].elements[i].value;
				document.all("delids").value =document.all("delids").value +",'"+did+"'";
			    vTable.deleteRow(rowsum1-1);					
			}
			rowsum1 -=1;
		}
	}	
	
	isTrue();
	document.EweaverForm.submit();
}
function isTrue()
{
	len = document.forms[0].elements.length;
    var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node2')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {

		if (document.forms[0].elements[i].name=='check_node2'){
			if(document.forms[0].elements[i].checked==true) {
				var did = document.forms[0].elements[i].value;
				document.all("ids").value =document.all("ids").value +",'"+did+"'";					
			}
			rowsum1 -=1;
		}
	}	
}
function validateForm(){
	var objnames = document.getElementsByName("objname");
	if(objnames){
		for(var i = 0; i < objnames.length; i++){
			if(objnames[i].value.trim() == ""){
				alert("选择项名称不能为空");
				objnames[i].focus();
				return false;
			}
		}
	}
	return true;
}
function onSubmit(){
	isTrue();
	if(validateForm()){
		document.EweaverForm.submit();
	}
}
function search(){
	document.all("searchName").value=document.all("inputTxt").value;
	EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemAction?action=search";
	EweaverForm.submit();
}

function openimage(){
 var returnvalue = new String(openDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp?","Width=110,Height=100"));
}
function BrowserImages(obj){
	var ret=openDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp");
	if(typeof ret=="undefined"){
		ret="";
	}
	obj.parentNode.children[0].value=ret;
    if(obj.parentNode.children[1].tagName=='IMG')
    obj.parentNode.children[1].src=contextPath+ret
    if(obj.parentNode.children[2].tagName=='IMG')
    obj.parentNode.children[2].src=contextPath+ret
}
function onReturn()
{
	<%
		String url="";
		String moduleid2=selectitemtype.getModuleid();
		if(selectitem2==null){
			url=request.getContextPath()+"/base/selectitem/selectitemtypelist.jsp?moduleid="+moduleid2;
		}else{
			String pid2=selectitem2.getPid();
			if(pid2==null||"".equals(pid2)){
				url=request.getContextPath()+"/base/selectitem/selectitemlist.jsp?moduleid="+moduleid+"&typeid="+selectitem2.getTypeid();
			}else{
				url=request.getContextPath()+"/base/selectitem/selectitemlist.jsp?pid="+pid2;
			}
		}
	%>
	var url="<%=url%>";
	window.location.href=url;
}
</script>
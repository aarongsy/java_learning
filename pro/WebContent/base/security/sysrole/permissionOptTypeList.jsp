
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%@ include file="/base/init.jsp"%>

<%
String pid="";
String typeid="402880371fb07b8d011fb0889c890002";
String searchName=StringHelper.null2String((String)request.getAttribute("searchName"));
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
Selectitem selectitem = null;
String selectitemnameP = "";
String ispermissionopt = "1";

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
  </head>

  <body>

<!--页面菜单开始-->
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",javascript:addRow()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:if(confirm('"+labelService.getLabelName("402881e90aac1cd3010aac1d97730001")+"'))delRow();}";

%>
<table width="100%" class="noborder">
  <tr>
    <td width="50%"><div id="pagemenubar" style="z-index:100;"></div></td>
    <td width="50%" style="text-align:left"></td>
  </tr>
</table>

<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemAction?action=crud&ispermissionopt=<%=ispermissionopt%>" name="EweaverForm" method="post">
		 <input type="hidden" name="searchName" value="">
		 <input type="hidden" name="typeid" value="<%=typeid%>">
		 <input type="hidden" name="delids">
		 <input type="hidden" name="ids">
         <input type="hidden" name="pid" value="<%=StringHelper.null2String(pid)%>">
	<table cols=7 id="vTable">
      	<COLGROUP>
      		<COL width="2%">
			<COL width="20%">
            <COL width="10%">
            <COL width="15%">
			<COL width="30%">
            <COL width="10%">
            <COL width="10%">
        </COLGROUP>
		<tbody>
			<tr class=Header>
				<td></td> <!--表头 字段-->
				<td>操作名称</td>
                <td>显示顺序</td>
				<td>对应数字</td>
                <td style="display:none"><%=labelService.getLabelName("402880351b90575a011b90e004ed001a")%></td>
                <td style="display:none">无效</td>
				<td style="display:none"></td>
			</tr>
     <%

       if (selectitemlist.size() != 0 ) {
         for (int i=0;i<selectitemlist.size();i++){
           selectitem = (Selectitem) selectitemlist.get(i);

     %>
	           <tr class=DataLight>
	                <td>
                        <%
                            if(selectitem.getCol2()==null||"".equals(selectitem.getCol2())){
                        %>
					    <input  type='checkbox' name='check_node' value='<%=selectitem.getId()%>'>
                        <%
                            }else{
                        %>
                        <input  type='checkbox' name='check_node' style="display:none" value='<%=selectitem.getId()%>'>
                        <%
                            }
                        %>
					    <input type="hidden" name="id" value="<%=selectitem.getId()%>" />
					</td>
					<td nowrap>
					 	<input style="width=95%" type="text" name="objname"  value="<%=selectitem.getObjname()%>"/>
					</td>
					<td>
						<input style="width=95%" type="text" name="dsporder"  value="<%=selectitem.getDsporder()%>"/>
					</td>
					<td>
						<input style="width=95%" type="text" readonly="readonly" name="objdesc"  value="<%=StringHelper.null2String(selectitem.getObjdesc())%>"/>
					</td>
                   <td  style="display:none">
                       <%
                           if(!StringHelper.isEmpty(selectitem.getImagefield())) {
                       %>
                        <input style="width=80%" type="text" name="imagfile" value="<%=selectitem.getImagefield()%>"/>
                        <img id="imgFilePre" height='16px' width="16px" src="<%=selectitem.getImagefield()%>" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
                         <%}else{%>
                        <input style="width=80%" type="text" name="imagfile" value=""/>
                        <img id="imgFilePre" height='16px' width="16px" src="" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
                       <%}%>
                    </td>
                    <td  style="display:none">
					    <input  type='checkbox' name='check_node2' <% if((StringHelper.null2String(selectitem.getCol1())).equals("1")) {%> checked <%}%> value='<%=selectitem.getId()%>' />
					    <input  type="hidden" name="istrue" value="<%=selectitem.getId()%>" />
					</td>
					<td nowrap  style="display:none"></td>
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
	ncol = vTable.cols;
    rowColor = getRowBg();
	oRow = vTable.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
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
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='objname'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='dsporder' value='1000' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='input' style=width:95% readonly='readonly'  name='objdesc' value=''>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
                oCell.style.display='none';
				break;
            case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input style=width=80% type='text' name='imagfile'   value=''/><img id='imgFilePre' width='16px' height='16px' src='' /><a  onclick='BrowserImages(this);'>浏览..</a>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
                oCell.style.display='none';
				break;
            case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node2' value='0'><input  type='hidden' name='istrue'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
                oCell.style.display='none';
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
	onSubmit();
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

function onSubmit(){

 isTrue();
 document.EweaverForm.submit();
}
function search(){
	document.all("searchName").value=document.all("inputTxt").value;
	EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemAction?action=search";
	EweaverForm.submit();
}

function openimage(){
 var returnvalue = openDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp?","Width=110,Height=100");
}
function BrowserImages(obj){
	var ret=openDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=ret
}
</script>
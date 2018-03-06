
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%@ include file="/base/init.jsp"%>

<%
 String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
String mode=StringHelper.null2String(request.getParameter("mode"));
String pid=StringHelper.trimToNull(request.getParameter("pid"));
String typeid=request.getParameter("typeid");
String searchName=StringHelper.null2String((String)request.getAttribute("searchName"));
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService"); 
Selectitem selectitem = null;
String selectitemnameP = "";

if(pid != null){
	selectitem = selectitemService.getSelectitemById(pid);
	selectitemnameP=selectitem.getObjname();
	typeid=selectitem.getTypeid();
}
String gobackURL = "javascript:location.href='"+request.getContextPath()+"/base/selectitem/selectitemtypelist.jsp?moduleid="+moduleid+"'";
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
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
  </head>
	<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

var topBar=null;
WeaverUtil.load(function(){
	var div=document.createElement("div");
	div.id="pagemenubar";
	Ext.getBody().insertFirst(div);
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023") %>','S','accept',function(){onSubmit('save')});//保存
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa85e6aed0001") %>','B','add',function(){addRow()});//新增
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>','D','delete',function(){if(confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>'))delRow();});
	topBar.addSpacer();
	topBar.addSpacer();
	//addBtn(topBar,'返回','B','arrow_redo',function(){goback();});
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addSpacer();
	topBar.addText('<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b") %>:');//名称
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addField(new Ext.form.TextField({id:"inputTxt", width : 100,value:"<%=searchName%>" }));
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000") %>','F','zoom',function(){search()});//查询

		topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addFill();
});
	</script>
  <body>
<%
	titlename=labelService.getLabelName("402881e50acff854010ad05534de0005")+":"+selectitemnameP;
%> 
<%@ include file="/base/toptitle.jsp"%>
<!--页面菜单结束-->

	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemAction?action=crud" name="EweaverForm" method="post">
		 <input type="hidden" name="searchName" value="">
		 <input type="hidden" name="mode" value="<%=mode%>">
		 <input type="hidden" name="typeid" value="<%=typeid%>">
		 <input type="hidden" name="delids">
		 <input type="hidden" name="ids">
     <input type="hidden" name="moduleid" value="<%=StringHelper.null2String(moduleid)%>">
     <input type="hidden" name="pid" value="<%=StringHelper.null2String(pid)%>">
			<table cols=6 id="vTable" cellspacing=0 cellpadding=0 border=1 style="border-bottom:1px #ACA8A6 solid;border-collapse:collapse;">
			<COLGROUP>
			<COL width="7%">
			<COL width="7%">
			<COL width="15%">
			<COL width="20%">
	<!-- 		<COL width="10%"> -->
			<COL width="10%">
			<COL width="30%">
      </COLGROUP>
			<tbody>
			<tr class=Header>
				<td style="text-align:center"><input type="checkbox" value="" onclick="javascript:checkAll(this,'check_node');"></td> <!--表头 字段-->
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402883d934c095220134c09523720000") %></td><!-- 序号 -->
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b") %></td><!-- 名称 -->
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402883d934c175a50134c175a5b60000") %></td><!-- 维护周期 -->
        <td style="text-align:center"><%=labelService.getLabelNameByKeyId("402883d934c164860134c16486f40000") %><!-- 无效 --></td>
<!-- 				<td style="text-align:center">子项</td>	 -->
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402883d934c165d70134c165d8590000") %><!-- 图标 --></td>
        	
			</tr>
     <%
       
       if (selectitemlist.size() != 0 ) {
         for (int i=0;i<selectitemlist.size();i++){
           selectitem = (Selectitem) selectitemlist.get(i);
					 String bgcolor=(i%2==1)?"style=\"background-color:#EBEBEB\"":"";
         
     %>		
	           <tr class=DataLight >
							<td align=center <%=bgcolor%>>					    
							<input  type='checkbox'  name='check_node' value='<%=selectitem.getId()%>'>	
							<input type="hidden" name="id" value="<%=selectitem.getId()%>" />
							</td>
							<td align=center <%=bgcolor%>>
							<input style="width=95%" class=inputstyle type="text" name="dsporder"  value="<%=selectitem.getDsporder()%>"/>
							</td>
							<td nowrap align=center <%=bgcolor%>>
							<input style="width=95%" class=inputstyle type="text" name="objname"  value="<%=selectitem.getObjname()%>"/>
							</td>
							<td align=center <%=bgcolor%>>
							<input style="width=95%" class=inputstyle type="text" name="objdesc"  value="<%=StringHelper.null2String(selectitem.getObjdesc())%>"/>
							</td>
							<td align=center <%=bgcolor%>>
							<input  type='checkbox' name='check_node2' <% if((StringHelper.null2String(selectitem.getCol1())).equals("1")) {%> checked <%}%> value='<%=selectitem.getId()%>' />	
							<input type="hidden" class=inputstyle name="istrue" value="<%=selectitem.getId()%>" /> 
							</td>
<!-- 							<td nowrap align=center <%=bgcolor%>> <a href="<%= request.getContextPath()%>/base/selectitem/selectitemlist.jsp?pid=<%=selectitem.getId()%>"><%=labelService.getLabelName("402881e50ad58ade010ad590c1890003")%></a></td> -->
							<td >
							<%
								 if(!StringHelper.isEmpty(selectitem.getImagefield())) {
							%>
							<input class=inputstyle style="width:65%" type="text" name="imagfile" value="<%=selectitem.getImagefield()%>"/>
							<img id="imgFilePre" height='16px' width="16px" src="<%=selectitem.getImagefield()%>" />
							<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000") %><!-- 浏览.. --></a>
							 <%}else{%>
							<input style="width:65%" class=inputstyle type="text" name="imagfile" value=""/>
							<img id="imgFilePre" height='16px' width="16px" src="" />
							<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000") %><!-- 浏览.. --></a>
							<%}%>
							</td>

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
				oDiv.align="center";
				oCell.appendChild(oDiv);
				break;		
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='objname'>";
				oDiv.align="center";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 2: 
				var oDiv = document.createElement("div"); 
				oDiv.align="center";
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='objdesc'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;				
			case 3: 
				var oDiv = document.createElement("div"); 
				oDiv.align="center";
				var sHtml = "<input class=inputstyle type='input' style=width:95% name='dsporder' value='1' >";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
        case 4:
				var oDiv = document.createElement("div");
				oDiv.align="center"
				var sHtml = "<input  type='checkbox' name='check_node2' value='0'><input  type='hidden' name='istrue'> "; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
        case 6:
				/*var oDiv = document.createElement("div"); 
				var sHtml = "";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);*/ 
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle style='width:65%' type='text' name='imagfile'   value=''/><img id='imgFilePre' width='16px' height='16px' src='' /><a  onclick='BrowserImages(this);'>浏览..</a>";
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
 var returnvalue = new String(window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp?","Width=110,Height=100"));
}
function BrowserImages(obj){
	var ret=window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=ret
}
function checkAll(obj,checkboxname)
{
	var checkboxs = document.getElementsByName(checkboxname);
	if(checkboxs!=null&&checkboxs.length>0)
	{
		var checkflag=obj.checked;
		for(var i=0,len=checkboxs.length;i<len;i++)
		{
			checkboxs[i].checked=checkflag;
		}
	}
}
</script>
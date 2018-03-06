<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ include file="/base/init.jsp"%>
<%
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
String mode=StringHelper.null2String(request.getParameter("mode"));
String level=StringHelper.null2String(request.getParameter("level"));
level=(level==null||level.length()<1)?"1":level;
boolean isav=(StringHelper.null2String(request.getParameter("isav")).equals("1")||StringHelper.null2String(request.getParameter("isav")).equals("true"))?true:false;
boolean ispic=(StringHelper.null2String(request.getParameter("ispic")).equals("1")||StringHelper.null2String(request.getParameter("ispic")).equals("true"))?true:false;
boolean ischild=(StringHelper.null2String(request.getParameter("ischild")).equals("1")||StringHelper.null2String(request.getParameter("ischild")).equals("true"))?true:false;
String objnamel=StringHelper.null2String(request.getParameter("objnamel"));
if(objnamel.length()<1)objnamel=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b");//名称
String objdescl=StringHelper.null2String(request.getParameter("objdescl"));
if(objdescl.length()<1)objdescl=labelService.getLabelNameByKeyId("402883d934c15c570134c15c57f50000");//描述
String col3l=StringHelper.null2String(request.getParameter("col3l"));
String id=StringHelper.trimToNull(request.getParameter("id"));
String searchName=StringHelper.null2String((String)request.getAttribute("searchName"));
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService"); 
Selectitem selectitem = selectitemService.getSelectitemById(id);
String pid = selectitem.getPid();
String typeid = selectitem.getTypeid();
DataService ds = new DataService();
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c15ec70134c15ec8720000") %>','T','accept',function(){onSubmit('saveadd')});//保存并新建
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>','C','accept',function(){document.EweaverForm.reset();});//取消
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addFill();
});
	</script>
  <body>
<%
	String objdesc="";
	String objname="";
	String dsporder ="";
	String col1="";
	String col2="";
	String imagefield=null;
	String col3="";
	if(selectitem!=null&&selectitem.getId()!=null)
	{
		objdesc=StringHelper.null2String(selectitem.getObjdesc());
		objname=StringHelper.null2String(selectitem.getObjname());
		col3=StringHelper.null2String(selectitem.getCol3());
		dsporder =StringHelper.null2String(selectitem.getDsporder());
		col1=StringHelper.null2String(selectitem.getCol1());
		col2=StringHelper.null2String(selectitem.getCol2());
		imagefield=selectitem.getImagefield();
	}
	else
	{
		if(pid!=null&&pid.length()>1)
		{
			dsporder=ds.getValue("select max(dsporder)+1 from selectitem where typeid='"+typeid+"' and pid='"+pid+"'");
		}
		else
		{
			dsporder=ds.getValue("select max(dsporder)+1 from selectitem where typeid='"+typeid+"' and pid is null");
		}
		
		if(dsporder==null||dsporder.length()<1)dsporder="1";
	}
%> 
<%@ include file="/base/toptitle.jsp"%>
<!--页面菜单结束-->
	<form action="" name="EweaverForm" method="post">
		 <input type="hidden" name="searchName" value="">
		 <input type="hidden" name="mode" value="<%=mode%>">
		 <input type="hidden" name="typeid" value="<%=typeid%>">
		 <input type="hidden" name="delids">
		 <input type="hidden" name="ids">
     <input type="hidden" name="moduleid" value="<%=StringHelper.null2String(moduleid)%>">
     <input type="hidden" name="pid" value="<%=StringHelper.null2String(pid)%>">
		 <input  type='hidden' name='id' value="<%=id%>">
		 <input type="hidden" name="level" value="<%=level%>">
		 <input type="hidden" name="isav" value="<%=isav%>">
		 <input type="hidden" name="ispic" value="<%=ispic%>">
		 <input type="hidden" name="ischild" value="<%=ischild%>">
		 <input type="hidden" name="objnamel" value="<%=objnamel%>">
		 <input type="hidden" name="objdescl" value="<%=objdescl%>">
		 <input type="hidden" name="col3l" value="<%=col3l%>">
			<FIELDSET style="WIDTH: 90%">
			<TABLE width="100%">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			</COLGROUP>
			<TBODY>
			<TR>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934c095220134c09523720000") %><!-- 序号 --></TD>
			<TD class=FieldValue><input style="width:95%" class=inputstyle type="text" name="dsporder"  value="<%=dsporder%>"/><span id="dsporderspan" name="dsporderspan" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
			</TR>
			<%
			 if(pid!=null&&pid.length()>1)
			 {
			 List selectlist=selectitemService.getSelectitemList(typeid,null);
			%>
			<TR>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %><!-- 类型 --></TD>
			<TD class=FieldValue>
			<select style="width:95%" class=inputstyle type="text" name="pid"/>
			<%
				for(int i=0,size=selectlist.size();i<size;i++)
				{
					Selectitem selectlist1=(Selectitem) selectlist.get(i);
					out.println("<option value=\""+selectlist1.getId()+"\" "+(selectlist1.getId().equals(pid)?"selected":"")+">"+selectlist1.getObjname()+"</option>");
				}
			%>
			</select><span id="pidspan" name="pidspan" ><img src="/images/base/checkinput.gif" align=absMiddle></span>
		</TD>
			</TR>
			<%}%>
			<TR>
			<TD class=FieldName noWrap><%=objnamel%></TD>
			<TD class=FieldValue><input style="width:95%" class=inputstyle type="text" name="objname"  value="<%=objname%>"/><span id="objnamespan" name="objnamespan" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
			</TR>
			<TR>
			<TD class=FieldName noWrap><%=objdescl%></TD>
			<TD class=FieldValue><input style="width:95%" class=inputstyle type="text" name="objdesc"  value="<%=objdesc%>"/></TD>
			</TR>
			<TR <%=((!isav)?"style='display:none'":"")%>>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934c164860134c16486f40000") %><!-- 无效 --></TD>
			<TD class=FieldValue><input  type='checkbox' name='check_node2' <% if((col1).equals("1")) {%> checked <%}%> value='<%=id%>' />	
										<input type="hidden" class=inputstyle name="istrue" value="<%=id%>" /> </TD>
			</tr>
			<TR <%=((col3l.length()<1)?"style='display:none'":"")%>>
			<TD class=FieldName noWrap><%=col3l%></TD>
			<TD class=FieldValue><input style="width:95%" class=inputstyle type="text" name="col3"  value="<%=col3%>"/> </TD>
			</tr>
			<TR <%=((!ispic)?"style='display:none'":"")%>>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934c165d70134c165d8590000") %><!-- 图标 --></TD>
			<TD class=FieldValue colSpan=1>	<%
				if(!StringHelper.isEmpty(imagefield)) {
				%>
				<input class=inputstyle style="width:65%" type="text" name="imagfile" value="<%=imagefield%>"/>
				<img id="imgFilePre" height='16px' width="16px" src="<%=imagefield%>" />
				<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000") %><!-- 浏览.. --></a>
				<%}else{%>
				<input style="width:65%" class=inputstyle type="text" name="imagfile" value=""/>
				<img id="imgFilePre" height='16px' width="16px" src="" />
				<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000") %><!-- 浏览.. --></a>
				<%}%>
			</td>
			</tr>
			</table>
			</fieldset>
</form>  
</body>
</html>


<script>
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

function onSubmit(type){
 isTrue();
 document.EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.selectitem.SelectItemAction?action="+type;
 document.EweaverForm.submit();
}
function BrowserImages(obj){
	var ret=window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=ret
}
</script>
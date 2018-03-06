<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ include file="/base/init.jsp"%>
<%
Calendar cal = Calendar.getInstance(); 
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH)+1;
String yearcnd = request.getParameter("yearcnd");
if(yearcnd==null) yearcnd=String.valueOf(year);
String monthcnd = request.getParameter("monthcnd");
if(monthcnd==null) monthcnd=month<10?"0"+String.valueOf(month):String.valueOf(month);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15002a")%></title><!-- 考勤对比查看 -->
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','S','accept',function(){onSearch()});//确定
	topBar.render('pagemenubar');
	topBar.addSeparator();
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.formExport.action= document.formExport.action+location.href.substring(idx);
});
function Save2Html(){
	document.getElementById('exportType').value="html";
	document.formExport.target="_blank";
	document.formExport.submit();
}
function Save2Excel(){
	document.getElementById('exportType').value="excel";
	//document.formExport.target="_blank";
	document.formExport.submit();
}
function onSearch(){
	if(checkIsNull())
		document.formExport.submit();
}
function showAll()
{
	document.getElementById('pageNum').value="2000";
	onSearch();
}
function checkIsNull()
{
	return true;
}
</script>
</head>

<body>
<form action="/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?viewerId=4028803b245c96c801245ccf79ae004c&rootId=&level=2" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001")%><!-- 年度 --> </td>
<TD class=FieldValue width="15%"><select style="width:120" name="yearcnd" style="width:80%" class=inputstyle>
<%

for(int i=-8;i<3;i++)
{
	int year1 = year+i;
	if(yearcnd.equals(String.valueOf(year1)))
	{
		out.println("<option value=\""+year1+"\" selected>"+year1+" "+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
	}
	else
	{
		out.println("<option value=\""+year1+"\">"+year1+" "+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
	}
}

%>

</select>   </TD>
<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150016")%><!-- 月份 --> </td>
<TD class=FieldValue width="15%"><select style="width:120" name="monthcnd" style="width:80%" class=inputstyle>
<%

for(int i=1;i<13;i++)
{
	int month1 = i;
	String month2=(month1<10?"0"+String.valueOf(month1):String.valueOf(month1));
	if(monthcnd.equals(month2))
	{
		out.println("<option value=\""+month2+"\" selected>"+month2+" "+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")+"</option>");//月
	}
	else
	{
		out.println("<option value=\""+month2+"\">"+month2+" "+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")+"</option>");//月
	}
}

%>

</select>   </TD>
</TR>
</table>
<br>
</form>
</body>
</html>



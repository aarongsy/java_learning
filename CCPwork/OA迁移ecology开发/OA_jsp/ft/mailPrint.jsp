<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/base/init.jsp"%>
<%
String requestid = request.getParameter("requestid");
if(requestid==null) requestid="";
String[] ids = request.getParameterValues("ids");
String idswhere=" and b.id in ('0'";
if(ids==null||ids.length<1) idswhere="";
else
{
	for(int i=0,len=ids.length;i<len;i++)
	{
		idswhere=idswhere+",'"+ids[i]+"'";
	}
	idswhere+=") ";
}
String action=StringHelper.null2String(request.getParameter("action"));
DataService ds = new DataService();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select a.docno,a.mainbodyattach,a.reqman,a.reqorg,a.mailway,b.rowindex,b.receiver,b.receiversite,b.receiverps,b.mailshare,b.id,b.phone  from uf_doc_ratifymain a,uf_doc_ratifysub b where a.requestid=b.requestid and a.requestid='"+requestid+"' "+idswhere+" order by rowindex";
List ls = baseJdbc.executeSqlForList(sql);
%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0074") %><!-- 邮寄单打印 --></title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script>
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
function printPrv ()
{  
  var src="/app/base/printNoPage.jsp?&opType=print&portrait=true";
	var width=630;
	var height=540;
	var winName='previewRep';
	var winOpt='scrollbars=1';
	 if(width==null || width=='')
    width=400;
  if(height==null || height=='')
    height=200;
  if(winOpt==null)
    winOpt="";
  winOpt="width="+width+",height="+height+(winOpt==""?"":",")+winOpt+", status=1";
  var popWindow=window.open(src,winName,winOpt);
  if(popWindow==null)
  {
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000") %>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
 //  var container=document.getElementById("printContainer");
  //  container.setAttribute("src",src);
  
}
function onsubmit(){
	document.all('formExport').submit();
}
var dlg0=null;
Ext.onReady(function(){

var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>','S','accept',function(){onsubmit()});//确定
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSeparator();
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'seachdiv',
	split:false,
	region:'north',      
		height:55,
		collapseMode:'mini'
	},{
		contentEl:'repContainer',
		autoScroll:true,
		region:'center'
	}]
  });
  });
    function openchild(url)
  {
    this.dlg0.getComponent('dlgpanel').setSrc("<%=request.getContextPath()%>"+url);
    this.dlg0.show();
  } 
</script>
</head>
<%
boolean bool1=true;
int size=ls.size();
/*for(int i=0;i<size;i++)
{
	Map m = (Map) ls.get(i);
	if(rowindex.length()<1&&rowindex==null)
	{
		rowindex= StringHelper.null2String(m.get("rowindex"));
		bool=false;
		break;
	}
	String rowindex1 = StringHelper.null2String(m.get("rowindex"));
	if(rowindex.equals(rowindex1))
	{
		bool=false;
		break;
	}
}
if(bool)
	rowindex=StringHelper.null2String(((Map) ls.get(size-1)).get("rowindex"));*/



%>
<body>

<div id='seachdiv'>
<div id="pagemenubar"></div>
<form action="" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" id="requestid" name="requestid" value="requestid">
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075") %><!-- 收件人 -->：
<%
for(int i=0;i<size;i++)
{
	boolean bool=false;
	Map m = (Map)ls.get(i);
	String id=StringHelper.null2String(m.get("id"));
	String receiver1=StringHelper.null2String(m.get("receiver"));
	if(ids==null||ids.length<1)
		bool=true;
	else{
		
		for(int j=0,len=ids.length;j<len;j++){
			if(ids[j].equals(id)){
				bool=true;
				break;
			}
		}
	}
	if(bool){
		out.println("<input type=checkbox value=\""+id+"\"  checked name=\"ids\">&nbsp;"+receiver1+"&nbsp;&nbsp;");
	}
	else{
		out.println("<input type=checkbox value=\""+id+"\"  name=\"ids\">&nbsp;"+receiver1+"&nbsp;&nbsp;");
	}
}%>
</div>
</form>
</div>
<div style="width:100%" style="text-align:center">
<CENTER>
<div id='repContainer' style="width:90%">
<%
String mainbodyattach="";//文档号
String reqman="";//申请人
String reqorg="";//部门
String mailway="";//邮件方式

String receiver="";//接收人
String receiversite="";//接收地址
String receiverps="";//邮编
String mailshare="";//邮寄份数
String id="";
for(int i=0;i<size;i++)
{
	Map m = (Map) ls.get(0);
	String rowindex1 = StringHelper.null2String(m.get("rowindex"));
	mainbodyattach= StringHelper.null2String(m.get("mainbodyattach"));
	reqman= StringHelper.null2String(m.get("reqman"));
	reqorg= StringHelper.null2String(m.get("reqorg"));
	mailway= StringHelper.null2String(m.get("mailway"));
	receiver= StringHelper.null2String(m.get("receiver"));
	receiversite= StringHelper.null2String(m.get("receiversite"));
	receiverps= StringHelper.null2String(m.get("receiverps"));
	id= StringHelper.null2String(m.get("id"));
	mailshare= StringHelper.null2String(m.get("mailshare"));

%>
<table cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">								
<tbody>
   <tr height="60px">
	<td colspan="1" valign="left" valign=middle><div class="font2"><%=receiverps%></div></td><td colspan="1" align="right" valign=middle><div class="font1"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0076") %><!-- 邮寄方式 -->： <%=getSelectDicValue(mailway)%>&nbsp;&nbsp;</div></td>
	</tr>
	<tr height="80px">
	<td colspan="2"  align="center" valign=middle><div class="font1"><%=receiversite%></div></td>
	</tr>
	<tr height="60px">
	
	<td colspan="2"  align="center" valign=middle><div class="font1"><%=receiver%>(<%=StringHelper.null2String(m.get("phone"))%>)&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0077") %><!-- 收 --></div><br><br><br></td>
		</tr>
	<tr height="80px">
	<td colspan="2"  align="left" valign=middle><div class="font3"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0000") %><!-- 印刷品 -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006f") %><!-- 共 -->&nbsp;<%=mailshare%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0001") %><!-- 份 -->&nbsp;</div></td>
		</tr>
	<tr height="20px">
	<td colspan="2"  align="left" valign=middle><div class="font4"><%=getBrowserDicValue("docbase","id","subject",mainbodyattach)%></div></td>
		</tr>
	<tr height="20px">
	<td colspan="2"  align="left" valign=middle><div class="font4"><%=StringHelper.null2String(m.get("docno"))%></div></td>
		</tr>
	<tr height="80px">
	<td colspan="2" align="right" valign=middle><div class="font1"><%=getBrowserDicValue("humres","id","objname",reqman)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=getBrowserDicValue("orgunit","id","objname",reqorg)%>&nbsp;&nbsp;</div></td>
	</tr>
	<tr height="14px"><td colspan=2></td></tr>
</tbody>
</table>
<%
	if(i%2==0){
		//out.println("<hr size=\"1\" noshade style=\"border:1px dotted #000000;width:100%\"> ");
	}
}
	%>
</tbody>
</table>
<style>
div.font1{
	height:40px;
	line-height:40px;
	display:block;
	font-size:18px;
	font-family:Verdana,Arial,Helvetica,sans-serif,"宋体";
	font-weight:normal;
	color:#000000;
}
div.font2{
	height:40px;
	line-height:40px;
	display:block;
	font-size:14px;
	font-family:Verdana,Arial,Helvetica,sans-serif,"宋体";
	font-weight:normal;
	color:#000000;
}
div.font3{
	height:40px;
	line-height:40px;
	display:block;
	font-size:14px;
	font-family:Verdana,Arial,Helvetica,sans-serif,"宋体";
	font-weight:normal;
	color:#000000;
}
div.font4{
	height:24px;
	line-height:24px;
	display:block;
	font-size:14px;
	font-family:Verdana,Arial,Helvetica,sans-serif,"宋体";
	font-weight:normal;
	color:#000000;
}
</style>
</div>
</center>
</div>
<iframe style="display:none" id="printContainer"></iframe>

<script>
function toPage(type)
{

	if(!isNaN(document.getElementById("pageno").value))
	{
		document.getElementById("toPageType").value=type;
		onSearch();
	}
	else
	{
		document.getElementById("pageno").value="1";
		return false;
	}
}
</script>
</body>
</html>


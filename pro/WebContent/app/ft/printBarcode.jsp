<%@ page contentType="text/html; charset=UTF-8"%>
<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
/*DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select a.reqname,a.assetsnumber,a.equipmenttm,a.standardmodel  from  uf_device_equipment a where a.requestid='"+requestid+"'";
DataService ds = new DataService();
List ls = ds.getValues(sql);*/
String devno="";
String devname="";
String devspec="";
String barcode="";
%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>

<title><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0034")%><!-- 条码打印 --></title>
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
</head>
<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif'
Ext.onReady(function(){
var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028")%>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	var mainPanel2 = new Ext.Panel({
		renderTo:'layout-cardLayout-up',
		title:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0035")%>',//条码信息
		id:'wizard',
		layout:'card',//在此设置为card布局
		activeItem: 0,//让向导页处于第一个位置
		width:400,
		height:250,
		bbar: ['->',{
			id: 'getbarcode',
			text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0036")%>',//刷新打印
			handler: getBarcodeData,
			disabled: false
		}],
		items: [{
				id: 'card-0',
				html: '<div id="repContainerb"><TABLE style="WIDTH: 315;height=180;margin:10" cellSpacing=0 cellPadding=0 border=0><COLGROUP><COL width="20%"><COL width="80%"></COLGROUP><TR height=35><TD class=FieldName noWrap>编号: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="<%=devno%>" name="devno" size=30></TD></tr><TR height=35><TD class=FieldName noWrap>名称: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="<%=devname%>" name="devname" size=30></TD></tr><TR height=35><TD class=FieldName noWrap>型号: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="<%=devspec%>" name="devspec" size=30></TD></TR><TR height=35><TD class=FieldName noWrap>条码: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="<%=barcode%>" name="barcode" size=30></TD></tr></tr></table></div>'
			}],
		//-----------------模块销毁函数---------------------------
		destroy:function(){
			
		}
	});
	var mainPanel = new Ext.Panel({
		renderTo:'layout-cardLayout-main',
		title:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0037")%>',//条码打印区
		id:'wizard',
		layout:'card',//在此设置为card布局
		activeItem: 0,//让向导页处于第一个位置
		width:400,
		height:300,
		bbar: ['->',{
			id: 'move-next',
			text: ' <%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0038")%>',//打印条码
			handler: printPrv,
			disabled: false
		}],
		items: [{
				id: 'card-0',
				html: '<div id="repContainer"><TABLE style="WIDTH: 315;height:255;margin:10" cellSpacing=0 cellPadding=0 border=0><COLGROUP><STRONG><COL width="100%"></COLGROUP><TBODY><TR height=20><TD  noWrap>编号: <span id="devnospan"></span></TD></tr><TR height=20><TD  noWrap>名称: <span id="devnamespan"></span></TD></tr><TR height=20><TD noWrap>型号: <span id="devspecspan"></span></TD></TR><TR ><TD noWrap style="height:80px" valign=top><span id="barcodeimage"></span></tr><tr><td></td></tr></table></div>'
			}],
		//-----------------模块销毁函数---------------------------
		destroy:function(){
			
		}
	});
//'<div id="repContainer"><TABLE style="WIDTH: 100%" cellSpacing=0 cellPadding=0 border=1><COLGROUP><STRONG><COL width="100%"></COLGROUP><TBODY><TR height=20><TD class=FieldName noWrap>编号: <span id="devnospan"></span></TD></tr><TR height=20><TD class=FieldName noWrap>名称: <span id="devnamespan"></span></TD></tr><TR height=20><TD class=FieldName noWrap>型号: <span id="devspecspan"></span></TD></TR><TR height=50><TD class=FieldName noWrap><span id="barcodeimage"></span></tr></table></div>'	
});
function printPrv ()
{  
  var location="/app/base/print.jsp?&opType=preview&portrait=false";
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
  var popWindow=window.open(location,winName,winOpt);
  if(popWindow==null)
  {
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000")%>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}
</script>
</head>
<body>
<body >
<form action="" name="EweaverPrint"  method="post" target="">
<div id="searchDiv" >
<div id="pagemenubar"></div> 
</div>
<input type="hidden" name="opType" value="print">
<TABLE style="WIDTH: 315px" cellSpacing=0 cellPadding=0 border=1>
<TBODY>
<!-- <TR height=25>
<TD class=FieldName noWrap>编号: </TD>
<TD class=FieldValue><INPUT type="text" class=InputStyle2 value="<%=devno%>" name="devno" size=30></TD>
</tr>
<TR height=25>
<TD class=FieldName noWrap>名称: </TD>
<TD class=FieldValue>
<INPUT type="text" class=InputStyle2 value="<%=devname%>" name="devname" size=30>
</TD></tr>
<TR height=25>
<TD class=FieldName noWrap>型号: </TD>
<TD class=FieldValue><INPUT type="text" class=InputStyle2 value="<%=devspec%>" name="devspec" size=30></TD>
</TR>
<TR height=25>
<TD class=FieldName noWrap>条码: </TD>
<TD class=FieldValue>
<INPUT type="text" class=InputStyle2 value="<%=barcode%>" name="barcode" size=30>
</TD>
</tr> -->
<tr>
<td colspan=2>
<div id="layout-cardLayout-up" style="margin:10px"></div>
</td>
</tr>
<tr>
<td colspan=2>
<div id="layout-cardLayout-main" style="margin:10px"></div>
</td>
</tr>
</TBODY></TABLE>
</form>
</body>
</html> 
<SCRIPT> 
function getBarcodeData()
{
	var devnospan = document.getElementById("devnospan");    
	var devnamespan = document.getElementById("devnamespan");    
	var devspecspan = document.getElementById("devspecspan");
	var devno = document.getElementById("devno");  
	var devname = document.getElementById("devname");  
	var devspec = document.getElementById("devspec");  
	var barcode = document.getElementById("barcode"); 
	devnospan.innerHTML=devno.value;
	devnamespan.innerHTML=devname.value;
	devspecspan.innerHTML=devspec.value;
	getBarcode();

}
function getBarcode()
{
   var p = document.getElementById("barcode");          
   if(p&&p.value){           
      var a = p.value;//alert(a.length);           
      h = '<img src=\'/ServiceAction/com.eweaver.customaction.barcode.BarCodeAction?code='+a+'&barType=CODE128&checkCharacter=n&checkCharacterInText=n\'>'; 
      document.getElementById('barcodeimage').innerHTML = h;           
   }           
}    
</SCRIPT>

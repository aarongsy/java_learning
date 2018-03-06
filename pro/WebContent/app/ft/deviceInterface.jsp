<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/base/init.jsp"%>
<%

String action=StringHelper.null2String(request.getParameter("action"));
String requestid=StringHelper.null2String(request.getParameter("requestid"));
if(StringHelper.isEmpty(requestid)){
	requestid="";
}
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
List selectData=null;
String tempstr="";
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select * from uf_device_interface where requestid like '%"+requestid+"%'";
int pageNum=20;
String pagenum=request.getParameter("pageNum");
if(pagenum!=null&&pagenum.length()>0)
	pageNum=Integer.parseInt(pagenum);
Page page2=baseJdbc.pagedQuery(sql, 1, pageNum);
int totalPage=page2.getTotalPageCount();
int totalNum =page2.getTotalSize();
String toPageType=request.getParameter("toPageType");
if(toPageType==null) toPageType="1";
String pageno1=request.getParameter("pageno");
if(pageno1==null||pageno1.trim().equals(""))pageno1="1";
int pageno=Integer.parseInt(pageno1);
if(toPageType.equals("1"))pageno=1;
else if(toPageType.equals("2"))pageno=pageno-1;
else if(toPageType.equals("3"))pageno=pageno+1;
else if(toPageType.equals("4"))pageno=totalPage;
else if(toPageType.equals("5"))pageno=pageno;
pageno = pageno>totalPage?totalPage:pageno;
pageno = pageno<1?1:pageno;
Page page1=baseJdbc.pagedQuery(sql, pageno, pageNum);
//pageNum=2000;
int startNum=page1.getStart();
int realNum=startNum+pageNum-1;
realNum=(realNum>totalNum)?totalNum:realNum;
if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="taskdata.xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}
%>
<c:if test="${!isExcel}">
<%@ include file="/base/init.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0057") %><!-- 合同查询表 --></title>
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

function Save2Html(){
	document.getElementById('exportType').value="html";
	document.forms[0].target="_blank";
	document.forms[0].submit();
}
function Save2Excel(){
	document.getElementById('exportType').value="excel";
	//document.forms[0].target="_blank";
	document.forms[0].submit();
}
function onSearch(){
	if(checkIsNull())
		document.forms[0].submit();
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
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000") %>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}
var dlg0=null;
Ext.onReady(function(){

var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>','S','accept',function(){onSearch()});//确定
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0058") %>','A','accept',function(){showAll()});//显示全部
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025") %>','E','page_excel',Save2Excel);//导出为Excel
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.forms[0].action= document.forms[0].action+location.href.substring(idx);
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'seachdiv',
	split:true,
	region:'north',          
		autoScroll:false,
		height:25,
		collapseMode:'mini'
	},{
		contentEl:'repContainer',
		autoScroll:true,
		region:'center'
	},{
		contentEl:'pagebar',
		autoScroll:true,
		region:'south'
	}]
  });


	  dlg0 = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:viewport.getSize().width*0.8,
                height:viewport.getSize().height*0.8,
                buttons: [{
                    text     : '<%=labelService.getLabelName("关闭")%>',
                    handler  : function(){
                        dlg0.hide();
						dlg0.getComponent('dlgpanel').setSrc("_blank");
                    }

                }],
                items:[{
                id:'dlgpanel',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
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

<body>

<div id='seachdiv'>
<div id="pagemenubar"></div>
<form action="/app/ft/deviceInterface.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" id="toPageType" name="toPageType" value="">
<input type="hidden" id="pageNum" name="pageNum" value="<%=pageNum%>"></form>
</div>
<div id='repContainer'>
</c:if>
<!-- <div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER>合同查询表</CENTER><BR></div> -->
<CENTER>
<!-- <div align=left width="50%"></div>
<div align=right width="50%">单位(元)</div> -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:1200" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="150" />
	<col width="150" />
	<col width="150" />
	<col width="150" />
	<col width="150" />
	<col width="150" />
	<col width="150" />
	<col width="150" />

	
  </colgroup>																														
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:20;">
			<td colspan="1" align="center" rowspan="1"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e") %><!-- 任务编号 --></td>
			<td colspan="1" align="center" rowspan="1"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec710001f") %><!-- 标定结果 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7100020") %><!-- 标定结果描述 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7100021") %><!-- 标定日期 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7100022") %><!-- 使用结果描述 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7100023") %><!-- 使用结束日期 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7100024") %><!-- 登录者 --></td>
		    <td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7100025") %><!-- 更新者 --></td>				
  </tr>
<tbody>
<%
StringBuffer buf1 = new StringBuffer();
if(totalNum>0)
{
List listData=(List) page1.getResult();
for(int i=0,size=realNum-pageNum*(pageno-1);i<size;i++)
{
	Map m = (Map)listData.get(i);
	String taskid=StringHelper.null2String(m.get("TASKID"));
	String chkresult=StringHelper.null2String(m.get("CHKRESULT"));
	String chkmtemo=StringHelper.null2String(m.get("CHKMEMO"));
	String chkdate=StringHelper.null2String(m.get("CHKDATE"));
	String usermemo=StringHelper.null2String(m.get("USERMEMO"));
	String usedate=StringHelper.null2String(m.get("USEDATE"));
	String reguser=StringHelper.null2String(m.get("REGUSER"));
	String upduser=StringHelper.null2String(m.get("UPDUSER"));
	
	String bgcolor="#FEF7FF";
	
	buf1.append("<tr style=\"height:20;\" bgcolor=\""+bgcolor+"\" >");
	buf1.append("<td align=\"center\">"+taskid+"</td>");
	buf1.append("<td align=\"center\">"+chkresult+"</td>");
	buf1.append("<td align=\"center\">"+chkmtemo+"</td>");
	buf1.append("<td align=\"center\">"+chkdate+"</td>");	
	buf1.append("<td align=\"center\">"+usermemo+"</td>");
	buf1.append("<td align=\"center\">"+usedate+"</td>");
	buf1.append("<td align=\"center\">"+reguser+"</td>");
    buf1.append("<td align=\"center\">"+upduser+"</td>");
	
	buf1.append("</tr>");
}
}
out.println(buf1.toString());

%>
</tbody>
</table>
</div>
<c:if test="${!isExcel}">
<div align="left"  id="pagebar" style="border:1px solid #c3daf9;height:30;width:100%">
<table border="0" style="border-collapse:collapse;" bordercolor="#c3daf9" width="100%">
<tr>
<td width="15%" align=right>
&nbsp;&nbsp;<a <%=pageno<=1?"":"href=\"javascript:toPage(1);\""%> ><img src="/app/images/resultset_first.gif"  style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800069") %>"></a>&nbsp;&nbsp;&nbsp;<!-- 首页 -->
<a <%=pageno<=1?"":"href=\"javascript:toPage(2);\""%>><img src="/app/images/resultset_previous.gif" style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006a") %>"><!-- 前页 --></a>&nbsp;&nbsp;&nbsp;</td>
<td width="15%" align=center>
<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %><!-- 第 --> &nbsp;<input type="text" id="pageno" name="pageno" value="<%=pageno%>" size="1" style="height:18;font-size:11;text-align:center;padding-bottom:2px" onchange="javascript:toPage(5);" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %><!-- 页 -->&nbsp;/&nbsp;<%=totalPage%>
</td><td width="15%" align=left>
&nbsp;&nbsp;&nbsp;<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(3);\""%>><img src="/app/images/resultset_next.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006b") %>"><!-- 后页 --></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(4);\""%>><img src="/app/images/resultset_last.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006c") %>"><!-- 属页尾 --> </a>&nbsp;&nbsp;&nbsp;
</td>
<td width="40%">&nbsp;</td>
<td width="40%" align=right><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006d") %><!-- 记录 -->:&nbsp;<%=startNum%>&nbsp;~&nbsp;<%=realNum%>&nbsp;/&nbsp;<%=totalNum%>&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>

</div>

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
</c:if>


<script type="text/javascript">
function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
		strend = inputname.substring(38);
		
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				pvalue = getValidStr(document.all(pname).value);
				
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
				
			}
			spos = _fieldcheck.indexOf("$",epos+1);
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
			
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				
				var etag = _fieldcheck.substring(epos);
				
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}
    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
					 if(document.getElementById('input_'+inputname)!=null)
					 document.getElementById('input_'+inputname).value="";
					var param = parserRefParam(inputname,param);
				var idsin = document.all(inputname).value;
				var id;
					try{
					id=window.showModalDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin);
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
					document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
</script>

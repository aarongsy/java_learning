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
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String czbm1=eweaveruser1.getOrgid();
Calendar cal = Calendar.getInstance(); 
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH);

if(month<1)
{
	month=12;
	year=year-1;
}
String nf = request.getParameter("nf");
String yf = request.getParameter("yf");
if(yf==null)yf=String.valueOf(month);
month=Integer.valueOf(yf);
if(yf.length()<2)yf="0"+yf;
if(nf==null)nf=String.valueOf(year);
String startdate=nf+"-"+yf+"-01";
String where="";
if(startdate.length()>0)
{
	where = where +" and yearmonth='"+nf+'-'+yf+"'";
}
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select a.requestid,a.yearmonth,b.contractno,c.no contractnoa,c.name,c.money,c.predictdate,c.implementdate,c.finishdate,b.mtno,b.mtstate,b.sendsum,b.process,b.finishplan,b.finishreal,b.finishrate,b.finishmonth,b.finishnextmonth,b.remark from  uf_income_monreportmain a,uf_income_monreportsub b,uf_contract c where a.requestid=b.requestid and b.contractno=c.requestid "+where+" order by b.contractno";
int pageNum=2000;
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
		String fname="data"+DateHelper.getCurrentDate()+".xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}
%>
<c:if test="${!isExcel}">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300015") %><!-- 调试产值月度报表 --></title>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script>
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
Ext.onReady(function(){

var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>','S','accept',function(){onSearch()});//确定
	topBar.render('pagemenubar');
	topBar.addSeparator();
	//addBtn(topBar,'显示全部','A','accept',function(){showAll()});
	//topBar.addSpacer();
	//topBar.addSpacer();
	//topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025") %>','E','page_excel',Save2Excel);//导出为Excel
	/* topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'导出全部','M','page_excel',exportAll);
	var idx=location.href.indexOf('?'); */
    if(idx>0)
    document.forms[0].action= document.forms[0].action+location.href.substring(idx);
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'seachdiv',
	split:true,
	region:'north',         
		autoScroll:true,
		height:60,
		collapseMode:'mini'
	},{
		contentEl:'repContainer',
		autoScroll:true,
		region:'center'
	}]
  });
  });
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
	document.getElementById('exportType').value="";
	if(checkIsNull())
		document.forms[0].submit();
}
function showAll()
{
	document.getElementById('exportType').value="";
	document.getElementById('pageNum').value="2000";
	onSearch();
}
function exportAll()
{
	document.getElementById('pageNum').value="2000";
	Save2Excel();
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
</script>
</head>

<body>

<div id='seachdiv'>
<div id="pagemenubar"></div>
<form action="/app/ft/pcsumReport.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
		<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0002") %><!-- 年月 --> </td>
		<td class="FieldValue" nowrap="true">
		<span><select name="nf" id="nf" style="width:80">
		<%
		for(int i=year-2;i<year+1;i++)
		{
			if(i==year)
				out.println("<option value='"+i+"' selected>"+i+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
			else 
				out.println("<option value='"+i+"'>"+i+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
		}

		%>
		</select>
		<select name="yf" id="yf" style="width:80">
		<option value="01" <%=yf.equals("01")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0028") %><!-- 一月 --></option>
				<option value="02" <%=yf.equals("02")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0029") %><!-- 二月 --></option>
				<option value="03" <%=yf.equals("03")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002a") %><!-- 三月 --></option>
				<option value="04" <%=yf.equals("04")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002b") %><!-- 四月 --></option>
				<option value="05" <%=yf.equals("05")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002c") %><!-- 五月 --></option>
				<option value="06" <%=yf.equals("06")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002d") %><!-- 六月 --></option>
				<option value="07" <%=yf.equals("07")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e002e") %><!-- 七月 --></option>
				<option value="08" <%=yf.equals("08")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e002f") %><!-- 八月 --></option>
				<option value="09" <%=yf.equals("09")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0030") %><!-- 九月 --></option>
				<option value="10" <%=yf.equals("10")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0031") %><!-- 十月 --></option>
				<option value="11" <%=yf.equals("11")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0032") %><!-- 十一月 --></option>
				<option value="12" <%=yf.equals("12")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0033") %><!-- 十二月 --></option>
		</select>
		</span>
		</td>
</tr>
</table>
</div>
<div id='repContainer'>
</c:if><BR>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --><%=yf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300015") %><!-- 调试产值月度报表 --></CENTER></div> 
<div align=left width="50%"></div><div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001e") %><!-- 单位(元) --></div> 
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="120" />
	<col width="150" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="150" />
  </colgroup>			

   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150051") %><!-- 合同金额 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0009") %><!-- 机组编号 --></td>
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39310019") %><!-- 下达产值 --></td>
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001a") %><!-- 进度阶段 --></td>
			<td colspan="2" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001b") %><!-- 合同结项 --></td>	
			<td colspan="3" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec718006a") %><!-- 完成百分比 --></td>	
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e") %><!-- 说明 --></td>		
  </tr>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec718006b") %><!-- 预计 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006c") %><!-- 实际 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001c") %><!-- 已完成 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006d") %><!-- 本月完成 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006e") %><!-- 预计下月完成 --></td>		
  </tr>
<tbody>
<%
	String color1="#D5F9F9";
	String color2="#F8D3FC";
	String color3="#FBF5B0";
StringBuffer buf1 = new StringBuffer();
if(totalNum>0)
{
	double sum1=0.0;
	double sum2=0.0;
	double sum3=0.0;
	double sum4=0.0;
	double sum5=0.0;
	String contractno2="";

	List listData=(List) page1.getResult();
	int size=realNum-pageNum*(pageno-1);
	for(int i=0;i<size;i++)
	{
		Map m = (Map)listData.get(i);
		String contractno=StringHelper.null2String(m.get("contractno"));
		String contractnoa=StringHelper.null2String(m.get("contractnoa"));
		
		String name=StringHelper.null2String(m.get("name"));
		String mtno=StringHelper.null2String(m.get("mtno"));
		String mtstate=StringHelper.null2String(m.get("mtstate"));
		String sendsum =StringHelper.null2String(m.get("sendsum"));
		String process=StringHelper.null2String(m.get("process"));
		String finishplan=StringHelper.null2String(m.get("finishplan"));
		String finishmonth=StringHelper.null2String(m.get("finishmonth"));
		String finishnextmonth=StringHelper.null2String(m.get("finishnextmonth"));
		String finishrate=StringHelper.null2String(m.get("finishrate"));
		String remark=StringHelper.null2String(m.get("remark"));
		String money=StringHelper.null2String(m.get("money"));
		String finishdate=StringHelper.null2String(m.get("finishdate"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String bgcolor=" bgcolor=\"#FEF7FF\"";
		String bgcolor1=" bgcolor=\"#FEF7FF\"";
		if(mtstate.equals("2c91a0302aa6def0012aad567a4c084e"))
		{
			bgcolor1=" bgcolor=\""+color1+"\"";
		}
		else if(mtstate.equals("2c91a0302aa6def0012aad567a4c084f"))
		{
			bgcolor1=" bgcolor=\""+color2+"\"";
		}
		else if(mtstate.equals("2c91a0302aa6def0012aad567a4c0850"))
		{
			bgcolor1=" bgcolor=\""+color3+"\"";
		}
		buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		if(!contractno2.equals(contractno))
		{
			contractno2=contractno;
			int rownum = 1;
			int addrownum=0;
			for(int k=i+1;k<size;k++)
			{
				Map m2 = (Map)listData.get(k);
				String contractno3=StringHelper.null2String(m2.get("contractno"));
				if(contractno3.equals(contractno2))
				{
					rownum=rownum+1;
				}
				else
					break;
			}
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+contractnoa+"</td>");
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+name+"</td>");
			buf1.append("<td align=\"right\" rowspan="+(rownum+addrownum)+">"+NumberHelper.moneyAddComma(money)+"</td>");
			sum1=sum1+Double.valueOf(money);
		}
		buf1.append("<td align=\"center\" "+bgcolor1+">"+getBrowserDicValue("edo_task","requestid","objname",mtno)+"</td>");
		buf1.append("<td align=\"right\">"+sendsum+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(process)+"</td>");
		buf1.append("<td align=\"center\">"+predictdate+"</td>");
		buf1.append("<td align=\"center\">"+implementdate+"</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(finishrate)+"%</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(finishmonth)+"%</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(finishnextmonth)+"%</td>");
		buf1.append("<td align=\"left\">"+remark+"</td>");
		buf1.append("</tr>");
		sum2=Double.valueOf(sendsum)*Double.valueOf(finishrate)/100.0;
		sum3+=Double.valueOf(sendsum)*Double.valueOf(finishmonth)/100.0;
		sum4+=Double.valueOf(sendsum)*Double.valueOf(finishnextmonth)/100.0;
		sum5+=Double.valueOf(sendsum);
		
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"1\"   align=\"center\"><b>合计</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum1)+"</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum5)+"</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001d")+"</b></td>");//完成
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum2)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum3)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum4)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"center\"><b>&nbsp;</b></td>");
	buf1.append("</tr>");
}
out.println(buf1.toString());

%>
</tbody>
</table>
<ul>说明：
<li>&nbsp;&nbsp;&nbsp;&nbsp;<span style="background:<%=color1%>;width:40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>	<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001e") %><!-- 表示机组调试工作处于停顿状态或停机保养状态 --></li><br>
<li>&nbsp;&nbsp;&nbsp;&nbsp;<span style="background:<%=color2%>;width:40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>	<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001f") %><!-- 表示机组调试工作还未开展 --></li><br>			
<li>&nbsp;&nbsp;&nbsp;&nbsp;<span style="background:<%=color3%>;width:40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>	<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320020") %><!-- 表示机组完成了调试工作 --> </li>
</ul>
</form>
</div>
<c:if test="${!isExcel}">
<!-- <div align="left"  style="border:1px solid #c3daf9;">
<table border="0" style="border-collapse:collapse;" bordercolor="#c3daf9" width="100%">
<tr>
<td width="15%" align=right>
&nbsp;&nbsp;<a <%=pageno<=1?"":"href=\"javascript:toPage(1);\""%> ><img src="/app/images/resultset_first.gif"  style="<%=pageno<=1?"filter:Gray":""%>" alt="首页"></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno<=1?"":"href=\"javascript:toPage(2);\""%>><img src="/app/images/resultset_previous.gif" style="<%=pageno<=1?"filter:Gray":""%>" alt="前页"></a>&nbsp;&nbsp;&nbsp;</td>
<td width="10%" align=center>
第 &nbsp;<input type="text" id="pageno" name="pageno" value="<%=pageno%>" size="1" style="height:16;font-size:11;text-align:center;padding-bottom:2px" onchange="javascript:toPage(5);" >&nbsp;页&nbsp;/&nbsp;<%=totalPage%>
</td><td width="15%" align=left>
&nbsp;&nbsp;&nbsp;<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(3);\""%>><img src="/app/images/resultset_next.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="后页"></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(4);\""%>><img src="/app/images/resultset_last.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="属页"> </a>&nbsp;&nbsp;&nbsp;
</td>
<td width="40%">&nbsp;</td>
<td width="20%" align=center>记录:&nbsp;<%=startNum%>&nbsp;~&nbsp;<%=realNum%>&nbsp;/&nbsp;<%=totalNum%>&nbsp;&nbsp;&nbsp;每页显示&nbsp;<input type="text" id="pageNum" size=1 name="pageNum" style="text-align:center;height:18" value="<%=pageNum%>">&nbsp;条</td>
</tr>
</table>
<input type="hidden" id="toPageType" name="toPageType" value=""> 

</div>-->
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

<%!
	/**
	 * 取select字段字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getSelectDicValue(String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select OBJNAME from selectitem where id='"+dicID+"'");
	}
	/**
	 * 取brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValue(String tab,String idCol,String valueCol,String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicID+"'");
	}
	
	/**
	 * 取批量brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValues(String tab,String idCol,String valueCol,String dicID)
	{
		String dicValue="";
		if(dicID==null||dicID.length()<1)return "";
		String[] dicIDs = dicID.split(",");
		DataService ds = new DataService();
		for(int i=0,size=dicIDs.length;i<size;i++)
		{
			dicValue=dicValue+","+ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicIDs[i]+"'");
		}
		if(dicValue.length()<1)dicValue="";
		else dicValue=dicValue.substring(1,dicValue.length());
		return dicValue;
	}
			/**
	 * 取select字段字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String progress(String fieldvalue)
	{
			fieldvalue = "<div id=\"p2\" >\n" +
                                                " <div style=\"width: auto; height: 15px;\" id=\"pbar2\" class=\"x-progress-wrap left-align\">\n" +
                                                "          <div class=\"x-progress-inner\">\n" +
                                                "              <div style=\"width: " +fieldvalue+ "%; height: 15px;\" id=\"ext-gen9\" class=\"x-progress-bar\">\n" +
                                                "              <div style=\"z-index: 99; width: 100px;\" id=\"ext-gen10\" class=\"x-progress-text x-progress-text-back\">" +
                                                "           <div style=\"width: 100px; height: 15px;\" id=\"ext-gen12\">" + fieldvalue + "%" + "</div>" +
                                                "             </div>\n" +
                                                "           </div>\n" +
                                                "          </div>\n" +
                                                "      </div>\n" +
                                                "  </div>";
		return fieldvalue;
	}
%>

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/app/base/init.jsp"%>
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
String orgunitcnd = request.getParameter("orgunitcnd");
if(orgunitcnd==null) orgunitcnd="";
String hosttypepcnd = request.getParameter("hosttypepcnd");
if(hosttypepcnd==null) hosttypepcnd="";
String namecnd = request.getParameter("namecnd");
if(namecnd==null) namecnd="";
String nocnd = request.getParameter("nocnd");
if(nocnd==null) nocnd="";
String divideclassescnd = request.getParameter("divideclassescnd");
if(divideclassescnd==null) divideclassescnd="";
String where="";
String where1="";
String where2="";
String where3="";
int finishnum=0;
int yfinishnum=0;
/*if(monthcnd.length()>0)
{
	where = where +" and to_char(to_date(nvl((select max(finidate) finidate from uf_pc_prjev where prjid=b.requestid),b.yjfrq),'yyyy-mm-dd'),'yyyy-mm')<='"+yearcnd+"-"+monthcnd+"'";
}*/
if(startdate.length()>0)
{
	//where1 = where1 +" and ((a.predictdate>='"+startdate+"' and a.predictdate<=to_char(last_day(to_date('"+startdate+"','yyyy-mm-dd')),'yyyy-mm-dd') and state<>'2c91a0302a8cef72012a8eabe0e803f3') or ( state='2c91a0302a8cef72012a8eabe0e803f3' and to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm')='"+nf+'-'+yf+"'))";
	where1 = where1 +" and (( to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+nf+'-'+yf+"'))";
	String yf2="";
	if(month>11)
	{
		yf2=(year+1)+"-01";
	}
	else
	{
		String temp=String.valueOf(month+1);
		if(temp.length()<2)temp="0"+temp;
		yf2=year+"-"+temp;
	}
	/*String yf3="";
	if(month<3)
	{
		yf3=(year-1)+"-12";
	}
	else
	{
		String temp=String.valueOf(month-1);
		if(temp.length()<2)temp="0"+temp;
		yf3=year+"-"+temp;
	}*/
	//下月预计完成
	where2 = where2 +" and (to_char(to_date(a.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+yf2+"' and implementdate is null)";
	//上月预计完成：预计完成时间是本月，完成时间是非上个月
	where3 = where3 +" and to_char(to_date(a.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+year+"-"+yf+"' ";
	// and (to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')>='"+year+"-"+yf+"')
	//and (to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm')='"+year+"-"+yf+"' and state='2c91a0302a8cef72012a8eabe0e803f3' and to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm')>='"+year+"-"+yf+"') ) 
	//or  state<>'2c91a0302a8cef72012a8eabe0e803f3')and (to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm')<'"+year+"-"+yf+"' and to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm')>='"+year+"-"+yf+"'
}
if(orgunitcnd.length()>0)
{
	where = where +" and a.orgunit like '%"+orgunitcnd+"%'";
}
if(hosttypepcnd.length()>0)
{
	where = where +" and a.hosttypep = '"+hosttypepcnd+"'";
}

if(nocnd.length()>0)
{
	where = where +" and a.no like '%"+StringHelper.filterSqlChar(nocnd)+"%'";
}
if(namecnd.length()>0)
{
	where = where +" and a.name like '%"+StringHelper.filterSqlChar(namecnd)+"%'";
}

if(divideclassescnd.length()>0)
{
	where = where +" and a.divideclasses='"+divideclassescnd+"'";
}
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select a.requestid,a.no,a.name,a.totalno,a.classes,a.hosttypep,a.divideclasses,a.orgunit,a.customercoding,a.money,a.csdate,a.csman,a.predictbgdate,a.predictdate,a.state,a.remark3,a.implementdate,a.finishdate,to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm') finishmonth,to_char(to_date(a.predictdate,'yyyy-mm-dd'),'yyyy-mm') prefinishmonth from  uf_contract a where 1=1 "+where1+" "+where+" and a.classes='2c91a0302a8cef72012a8ea9390903c6' order by a.no";
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
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0001") %><!-- 合同汇总查询表 --></title>
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
	/*topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'导出全部','M','page_excel',exportAll);
	var idx=location.href.indexOf('?');*/
    if(idx>0)
    document.forms[0].action= document.forms[0].action+location.href.substring(idx);
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'seachdiv',
	split:true,
	region:'north',         
		autoScroll:true,
		height:80,
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
<form action="/app/ft/contractReportPre.jsp" name="formExport" method="post">
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
		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
		<td  class="FieldValue" width=15% nowrap>
		<input type=text class=inputstyle size=20 name="nocnd" value="<%=nocnd%>"/>
		</td>
		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
		<td  class="FieldValue" width=15% nowrap>
		<input type=text class=inputstyle size=20 name="namecnd" value="<%=namecnd%>"/>
		</td>
		</tr>
		<TR class=title>
		

		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0003") %><!-- 合同主类别 --></td>
		<td width=15% class='FieldValue'>
			<select style="width:120" class="inputstyle2" id="hosttypepcnd"  name="hosttypepcnd">
			<option value=""   ></option>
			<%
			selectData=ds.getValues("select id,objname from selectitem where typeid='2c91a0302a8cef72012a8ea97e5f03c9' and pid is null  and nvl(col1,'0')='0' order by dsporder");
			tempstr=hosttypepcnd;
			for(int i=0,size=selectData.size();i<size;i++)
			{
				Map m = (Map)selectData.get(i);
				String id=m.get("id").toString();
				if(id.equals(tempstr))
				{
					out.println("<option value=\""+id+"\"  selected>"+m.get("objname").toString()+"</option>");
				}
				else
				{
					out.println("<option value=\""+id+"\">"+m.get("objname").toString()+"</option>");
				}
				
			}
			%>
		</td>
		<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005f") %><!-- 事业部门 -->:</td> 
		<TD class=FieldValue noWrap>
			<span> <BUTTON type="button" class=Browser onclick="javascript:getrefobj('orgunitcnd','orgunitcndspan','402881e60bfee880010bff17101a000c','','','0');"></BUTTON> <INPUT type=hidden value="<%=orgunitcnd%>" name=orgunitcnd> <SPAN id=orgunitcndspan name="orgunitcndspan"><%=getBrowserDicValue("orgunit","id","objname",orgunitcnd)%></SPAN>
		</TD>

</tr>
</table>
</div>
<div id='repContainer'>
</c:if><BR>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --><%=yf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0004") %><!-- 月实际完成合同清单 --></CENTER></div> 
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
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881ea0c1a5676010c1a62adf7001d") %><!-- 客户名称 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800061") %><!-- 签订人 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800062") %><!-- 签署日期 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800063") %><!-- 事业部 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0005") %><!-- 金额 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %><!-- 类型 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800066") %><!-- 分类型 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019") %><!-- 状态 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800067") %><!-- 计划完成 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800068") %><!-- 实施完成 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b24e600012") %><!-- 结束时间 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %><!-- 备注 --></td>	
  </tr>
<tbody>
<%
StringBuffer buf1 = new StringBuffer();
if(totalNum>0)
{
	double sum1=0.0;
	List listData=(List) page1.getResult();
	int size=realNum-pageNum*(pageno-1);
	finishnum=size;
	for(int i=0;i<size;i++)
	{
		Map m = (Map)listData.get(i);
		String no=StringHelper.null2String(m.get("no"));
		String name=StringHelper.null2String(m.get("name"));
		String totalno=StringHelper.null2String(m.get("totalno"));
		String classes=StringHelper.null2String(m.get("classes"));
		String orgunit =StringHelper.null2String(m.get("orgunit "));
		String hosttypep=StringHelper.null2String(m.get("hosttypep"));
		String divideclasses=StringHelper.null2String(m.get("divideclasses"));
		String customercoding=StringHelper.null2String(m.get("customercoding"));
		String money=StringHelper.null2String(m.get("money"));
		String csdate=StringHelper.null2String(m.get("csdate"));
		String csman=StringHelper.null2String(m.get("csman"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String predictbgdate=StringHelper.null2String(m.get("predictbgdate"));
		String finishdate=StringHelper.null2String(m.get("finishdate"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String state=StringHelper.null2String(m.get("state"));
		String finishmonth=StringHelper.null2String(m.get("finishmonth"));
		String prefinishmonth=StringHelper.null2String(m.get("prefinishmonth"));
		String remark3=StringHelper.null2String(m.get("remark3"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String bgcolor=" bgcolor=\"#FEF7FF\"";
		if(!state.equals("2c91a0302a8cef72012a8eabe0e803f3"))
		{
			bgcolor=" bgcolor=\"#FCA292\"";
		}
		else if(finishmonth.compareToIgnoreCase(prefinishmonth)<0)
		{
			
			bgcolor=" bgcolor=\"#9B9BFF\"";
		}
		//if(state.equals("2c91a0302a8cef72012a8eabe0e803f3")){finishnum=finishnum+1;};
		buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		buf1.append("<td align=\"center\">"+no+"</td>");
		buf1.append("<td align=\"center\">"+name+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("uf_customer","requestid","unitname",customercoding)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",csman)+"</td>");
		buf1.append("<td align=\"center\">"+csdate+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValues("orgunit","id","objname",orgunit)+"</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(money)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(hosttypep)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(divideclasses)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(state)+"</td>");
		buf1.append("<td align=\"center\">"+predictdate+"</td>");
		buf1.append("<td align=\"center\">"+implementdate+"</td>");
		buf1.append("<td align=\"center\">"+finishdate+"</td>");
		buf1.append("<td align=\"left\">"+remark3+"</td>");
		buf1.append("</tr>");
		sum1=sum1+Double.valueOf(money);
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"5\"   align=\"center\"><b>合计</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum1)+"</b></td>");
	buf1.append("<td colspan=\"7\"  align=\"center\"><b>共&nbsp;"+size+"&nbsp;份</b> </td>");
	buf1.append("</tr>");
}
out.println(buf1.toString());
%>
</tbody>
</table>
<br>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0006") %><!-- 本月应完成合同清单 --></CENTER></div> 
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
	<col width="150" />
  </colgroup>																														
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881ea0c1a5676010c1a62adf7001d") %><!-- 客户名称 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800061") %><!-- 签订人 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800062") %><!-- 签署日期 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800063") %><!-- 事业部 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0005") %><!-- 金额 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %><!-- 类型 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800066") %><!-- 分类型 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800067") %><!-- 计划完成 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %><!-- 备注 --></td>
  </tr>
<tbody>
<%

sql ="select a.requestid,a.no,a.name,a.totalno,a.classes,a.hosttypep,a.divideclasses,a.orgunit,a.customercoding,a.money,a.csdate,a.csman,a.predictbgdate,a.predictdate,a.state,a.remark3,a.implementdate,a.finishdate,to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm') finishmonth,to_char(to_date(a.predictdate,'yyyy-mm-dd'),'yyyy-mm') prefinishmonth from  uf_contract a where 1=1 "+where3+" "+where+" and a.classes='2c91a0302a8cef72012a8ea9390903c6' order by a.no";

page1=baseJdbc.pagedQuery(sql, 1, pageNum);
buf1 = new StringBuffer();
yfinishnum=page1.getTotalSize();
if(yfinishnum>0)
{
	
	double sum1=0.0;
	List listData=(List) page1.getResult();

	int size=yfinishnum;

	for(int i=0;i<size;i++)
	{
		Map m = (Map)listData.get(i);
		String no=StringHelper.null2String(m.get("no"));
		String name=StringHelper.null2String(m.get("name"));
		String totalno=StringHelper.null2String(m.get("totalno"));
		String classes=StringHelper.null2String(m.get("classes"));
		String orgunit =StringHelper.null2String(m.get("orgunit "));
		String hosttypep=StringHelper.null2String(m.get("hosttypep"));
		String divideclasses=StringHelper.null2String(m.get("divideclasses"));
		String customercoding=StringHelper.null2String(m.get("customercoding"));
		String money=StringHelper.null2String(m.get("money"));
		String csdate=StringHelper.null2String(m.get("csdate"));
		String csman=StringHelper.null2String(m.get("csman"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String predictbgdate=StringHelper.null2String(m.get("predictbgdate"));
		String finishdate=StringHelper.null2String(m.get("finishdate"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String state=StringHelper.null2String(m.get("state"));
		String finishmonth=StringHelper.null2String(m.get("finishmonth"));
		String prefinishmonth=StringHelper.null2String(m.get("prefinishmonth"));
		String remark3=StringHelper.null2String(m.get("remark3"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String bgcolor=" bgcolor=\"#FEF7FF\"";
		buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		buf1.append("<td align=\"center\">"+no+"</td>");
		buf1.append("<td align=\"center\">"+name+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("uf_customer","requestid","unitname",customercoding)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",csman)+"</td>");
		buf1.append("<td align=\"center\">"+csdate+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValues("orgunit","id","objname",orgunit)+"</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(money)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(hosttypep)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(divideclasses)+"</td>");
		buf1.append("<td align=\"center\">"+predictdate+"</td>");
		buf1.append("<td align=\"left\">"+remark3+"</td>");
		buf1.append("</tr>");
		sum1=sum1+Double.valueOf(money);
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"5\"   align=\"center\"><b>合计</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum1)+"</b></td>");
	buf1.append("<td colspan=\"4\"  align=\"center\"><b>共&nbsp;"+size+"&nbsp;份</b> </td>");
	buf1.append("</tr>");
}
out.println(buf1.toString());
%>
</tbody>
</table>
<br>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c0007") %><!-- 下月预计完成合同清单 --></CENTER></div> 
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
	<col width="150" />
  </colgroup>																														
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881ea0c1a5676010c1a62adf7001d") %><!-- 客户名称 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800061") %><!-- 签订人 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800062") %><!-- 签署日期 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800063") %><!-- 事业部 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0005") %><!-- 金额 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %><!-- 类型 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800066") %><!-- 分类型 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019") %><!-- 状态 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800067") %><!-- 计划完成 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %><!-- 备注 --></td>
  </tr>
<tbody>
<%

sql ="select a.requestid,a.no,a.name,a.totalno,a.classes,a.hosttypep,a.divideclasses,a.orgunit,a.customercoding,a.money,a.csdate,a.csman,a.predictbgdate,a.predictdate,a.state,a.remark3,a.implementdate,a.finishdate,to_char(to_date(a.finishdate,'yyyy-mm-dd'),'yyyy-mm') finishmonth,to_char(to_date(a.predictdate,'yyyy-mm-dd'),'yyyy-mm') prefinishmonth from  uf_contract a where 1=1 "+where2+" "+where+" and a.classes='2c91a0302a8cef72012a8ea9390903c6' order by a.no";

page1=baseJdbc.pagedQuery(sql, 1, pageNum);
buf1 = new StringBuffer();
if(page1.getTotalSize()>0)
{
	
	double sum1=0.0;
	List listData=(List) page1.getResult();

	int size=listData.size();

	for(int i=0;i<size;i++)
	{
		Map m = (Map)listData.get(i);
		String no=StringHelper.null2String(m.get("no"));
		String name=StringHelper.null2String(m.get("name"));
		String totalno=StringHelper.null2String(m.get("totalno"));
		String classes=StringHelper.null2String(m.get("classes"));
		String orgunit =StringHelper.null2String(m.get("orgunit "));
		String hosttypep=StringHelper.null2String(m.get("hosttypep"));
		String divideclasses=StringHelper.null2String(m.get("divideclasses"));
		String customercoding=StringHelper.null2String(m.get("customercoding"));
		String money=StringHelper.null2String(m.get("money"));
		String csdate=StringHelper.null2String(m.get("csdate"));
		String csman=StringHelper.null2String(m.get("csman"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String predictbgdate=StringHelper.null2String(m.get("predictbgdate"));
		String finishdate=StringHelper.null2String(m.get("finishdate"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String state=StringHelper.null2String(m.get("state"));
		String finishmonth=StringHelper.null2String(m.get("finishmonth"));
		String prefinishmonth=StringHelper.null2String(m.get("prefinishmonth"));
		String remark3=StringHelper.null2String(m.get("remark3"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String bgcolor=" bgcolor=\"#FEF7FF\"";
		buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		buf1.append("<td align=\"center\">"+no+"</td>");
		buf1.append("<td align=\"center\">"+name+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("uf_customer","requestid","unitname",customercoding)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",csman)+"</td>");
		buf1.append("<td align=\"center\">"+csdate+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValues("orgunit","id","objname",orgunit)+"</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(money)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(hosttypep)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(divideclasses)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(state)+"</td>");
		buf1.append("<td align=\"center\">"+predictdate+"</td>");
		buf1.append("<td align=\"left\">"+remark3+"</td>");
		buf1.append("</tr>");
		sum1=sum1+Double.valueOf(money);
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"5\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")+"</b></td>");//合计
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum1)+"</b></td>");
	buf1.append("<td colspan=\"5\"  align=\"center\"><b>共&nbsp;"+size+"&nbsp;份</b> </td>");
	buf1.append("</tr>");
}
out.println(buf1.toString());

%>
</tbody>
</table>
<br>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:50%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="120" />
	<col width="150" />
	<col width="80" />
  </colgroup>																														
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c0008") %><!-- 应完成项目数 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c0009") %><!-- 实际完成 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000a") %><!-- 合同任务完成率 -->%</td>
  </tr>
<tbody>
<tr style="height:25;" bgcolor="#FEF7F\" >
<td align="center"><%=yfinishnum%></td>
<td align="center"><%=finishnum%></td>
<td align="center"><%=(yfinishnum==0)?0:Math.round(finishnum/(yfinishnum*1.0)*10000)/100.0%></td>
</tr>
</tbody>
</table>
</form>
<c:if test="${!isExcel}">
</div>

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
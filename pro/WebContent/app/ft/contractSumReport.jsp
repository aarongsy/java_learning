<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>

<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String czbm1=eweaveruser1.getOrgid();
Calendar cal = Calendar.getInstance(); 
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH)+1;
month=month-1;
if(month<1)
{
	month=12;
	year=year-1;
}
String nextmonth="";
if(month+1>12)
{
	nextmonth=(year+1)+"-01";
}
else
{	
	int nmonth = month+1;
	if(nmonth<10){
		nextmonth=(year)+"-0"+nmonth;
	}else{
		nextmonth=(year)+"-"+nmonth;
	}
}
int lastyear=year-1;
String nf = request.getParameter("nf");
String yf = request.getParameter("yf");
if(yf==null)yf=String.valueOf(month);
month=Integer.valueOf(yf);
if(yf.length()<2)yf="0"+yf;
if(nf==null)nf=String.valueOf(year);
year=Integer.parseInt(nf);
String startdate=nf+"-"+yf+"-01";
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

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
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000b") %><!-- 合同签订完成表 --></title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script><style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
</head>

<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

var topBar=null;
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
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.formExport.action= document.formExport.action+location.href.substring(idx);
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
	document.formExport.target="_blank";
	document.formExport.submit();
}
function Save2Excel(){
	document.getElementById('exportType').value="excel";
	//document.formExport.target="_blank";
	document.formExport.submit();
}
function onSearch(){
	document.getElementById('exportType').value="";
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
<form action="/app/ft/contractSumReport.jsp" name="formExport" method="post">
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
				out.println("<option value='"+i+"' selected>"+i+"年</option>");
			else 
				out.println("<option value='"+i+"'>"+i+"年</option>");
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
</form>
</div>

<div id='repContainer'>
</c:if><BR>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --><%=yf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000c") %><!-- 月实际合同完成清单 --></CENTER></div> 
<div align=left width="50%"></div><div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000d") %><!-- 单位(万元) --></div> 
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:970" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="130" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
	<col width="100" />
  </colgroup>																														
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="2" align="center" nowrap><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000e") %><!-- 业务部名称 --></td>
			<td colspan="2" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000f") %><!-- 本年签订合同 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c0010") %><!-- 新签占全年指标的比例 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70e0011") %><!-- 去年转接合同额 --></td>
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70e0012") %><!-- 总执行合同额 --></td>
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70e0013") %><!-- 本月完成合同产值 --></td>	
			<td colspan="2" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70e0014") %><!-- 本年已完成的合同产值 --></td>	
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f0015") %><!-- 占全年指标的比例 --></td>	
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f0016") %><!-- 预计下月完成产值 --></td>
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f0017") %><!-- 目前正在执行未完成合同额 --></td>	
  </tr>
 <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f0018") %><!-- 本月合计 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f0019") %><!-- 本年合计 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001a") %><!-- 去年结转 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001b") %><!-- 本年新签 --></td>

  </tr>
<tbody>
<%
String yearmonth=nf+"-"+yf;
String dept1="2c91a0302a87f19c012a8978af71000e";
String dept2="2c91a0302a87f19c012a897912620010";
String dept3="2c91a0302a87f19c012a8979573b0012";
String dept4="2c91a0302a87f19c012a897996e30014";
StringBuffer buf1 = new StringBuffer();
double finishincome=0.0;
List orglist = baseJdbc.executeSqlForList("select id,objname,nvl((select b.income from uf_income_yearnormmain a,uf_income_yearnormsub b where a.requestid=b.requestid and a.theyear="+nf+" and b.orgid=c.id),0.0) income,nvl((select b.finishincome from uf_income_yearnormmain a,uf_income_yearnormsub b where a.requestid=b.requestid and a.theyear="+nf+" and b.orgid=c.id),0.0) finishincome   from orgunit c where typeid='4028804d2083a7ed012083ebb988005b' and isdelete=0 order by  dsporder ");


//List list1 = baseJdbc.executeSqlForList("select c.orgunit,nvl(sum(c.money),0.0) as money,to_char(to_date(c.registerdate,'yyyy-mm-dd'),'yyyy-mm') month  from uf_contract c ,formbase f where  (c.classes='2c91a0302a8cef72012a8ea9390903c6' or c.classes='2c91a0302a8cef72012a8ea9390903c8') and c.ifaffirm='2c91a0302d510d0c012d5e2d7e4a1d3c' and c.isback='2c91a0302b278cea012b28d82e7f001d' and c.state not in ('2c91a0302ab11213012ab12bf0f00021') and  to_char(to_date(c.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"'  and f.id=c.requestid and f.isdelete<>1 and c.no not like '%LX%' group by orgunit,to_char(to_date(registerdate,'yyyy-mm-dd'),'yyyy-mm') ");
//本年各月新签订合同额
List list1 = baseJdbc.executeSqlForList("select d.orgid orgunit,nvl(sum(d.distsum),0.0) money,to_char(to_date(c.registerdate,'yyyy-mm-dd'),'yyyy-mm') month  from uf_contract c,uf_contract_dist d where  c.requestid=d.requestid and (c.classes='2c91a0302a8cef72012a8ea9390903c6' or c.classes='2c91a0302a8cef72012a8ea9390903c8') and c.ifaffirm='2c91a0302d510d0c012d5e2d7e4a1d3c' and c.isback='2c91a0302b278cea012b28d82e7f001d' and c.state not in ('2c91a0302ab11213012ab12bf0f00021') and  to_char(to_date(c.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and exists (select id from formbase f where f.id=c.requestid and f.isdelete=0) and c.no not like '%LX%' group by d.orgid,to_char(to_date(registerdate,'yyyy-mm-dd'),'yyyy-mm') ");


//去年转接合同额
List list14=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where a.no not like '%LX%' and exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept1+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) group by d.orgunit");

List list24=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept2+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) group by d.orgunit");

List list34=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept3+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) group by d.orgunit");

List list44=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept4+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) group by d.orgunit");


//总执行合同额=本年新签+去年转接合同


//去年转接合同额今年完成的
/*String tempwhere =" and exists(select id from uf_contract_dist t where requestid=a.requestid and d.orgunit=t.orgunit and to_char(to_date(t.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"')";
List list14=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where a.no not like '%LX%' and exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept1+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

List list24=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept2+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

List list34=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept3+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

List list44=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and c.contractno=a.requestid  and c.requestid=d.requestid   and d.orgunit='"+dept4+"' and c.toyear='"+year+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid   and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

*/


//本月完成合同产值

String tempwhere =" and exists(select id from uf_contract_dist t where requestid=a.requestid and d.orgunit=t.orgunit and to_char(to_date(t.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"')";
//-------------------------------
//本月完成合同产值--电力工程部
//本年新签普通合同,去调子类型的电源调试  a.hosttypep<>'2c91a0302ac122a2012ac223c0610418' 调试类
List list16a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0) and a.divideclasses<>'2c91a0302b13190a012b146426aa029c' and b.orgid='"+dept1+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");

//and exists (select id from formbase f where f.id=c.requestid and f.isdelete=0)
	//去年签普通合同结转本月完成,去调子类型的电源调试
	List list16b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.divideclasses<>'2c91a0302b13190a012b146426aa029c'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"'");


//List list16b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where a.no not like '%LX%' and exists(select id from formbase where id=a.requestid and isdelete=0) and a.divideclasses<>'2c91a0302b13190a012b146426aa029c'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'   and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	
//计算调试类项目
List list16e=baseJdbc.executeSqlForList("select '"+dept1+"' orgunit,nvl(sum(money),0.0) as money from (select nvl(max(f.process*f.je/100.0),0.0) as money,contractno  from  (select nvl((select d.produceqty from edo_task d where d.id=t.jztaskid),0.0) je,t.process,t.jztaskid contractno,c.status,c.finish1  from uf_income_pcprocess t, edo_task c,uf_contract a where t.taskid=c.requestid(+) and  t.CONTRACTNO=a.requestid and to_char(to_date(t.FINISHDATE,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and a.orgunit like '%"+dept1+"%' and a.divideclasses='2c91a0302b13190a012b146426aa029c' and  a.no not like '%LX%'  and exists(select id from formbase where id=a.requestid and isdelete=0)  ) f  group by contractno)");

//计算调试类项目-上月完成
List list16f=baseJdbc.executeSqlForList("select '"+dept1+"' orgunit,nvl(sum(money),0.0) as money from (select nvl(max(f.process*f.je/100.0),0.0) as money,contractno  from  (select nvl((select d.produceqty from edo_task d where d.id=t.jztaskid),0.0) je,t.process,t.jztaskid contractno,c.status,c.finish1  from uf_income_pcprocess t, edo_task c,uf_contract a where t.taskid=c.requestid(+) and  t.CONTRACTNO=a.requestid and to_char(to_date(t.FINISHDATE,'yyyy-mm-dd'),'yyyy-mm')<'"+yearmonth+"' and a.orgunit like '%"+dept1+"%' and a.divideclasses='2c91a0302b13190a012b146426aa029c' and  a.no not like '%LX%'  and exists(select id from formbase where id=a.requestid and isdelete=0) ) f group by contractno)");




//本月完成合同产值--技术监督部

	//本年新签普通合同 - 不包括技术监督类合同
List list26a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0) and a.hosttypep<>'2c91a0302b13190a012b146002250295' and b.orgid='"+dept2+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");



	//去年结转普通合同

	List list26b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept2+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"'");


	//List list26b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<>'"+year+"'  and  to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"'  and d.orgunit='"+dept2+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	List list26e=baseJdbc.executeSqlForList("select '"+dept2+"' as orgunit,nvl(yearnorm/12,0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and orgunit='"+dept2+"'");

//本月完成合同产值--高新产品部
	String baseline="1000000";
	List<Map<String,Object>> value = baseJdbc.executeSqlForList("select objdesc from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+year+"'");
	String baselinen="1000000";
	List<Map<String,Object>> value1 = baseJdbc.executeSqlForList("select objdesc from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+year+"'");
	if(value!=null && !value.isEmpty())
		baseline = value.get(0).get("objdesc").toString();
	if(value1!=null && !value1.isEmpty())
	baselinen = value1.get(0).get("objdesc").toString();
	//取今年的部门拆分金额已结项的,并且不在项目进度控制的
	List list36a=baseJdbc.executeSqlForList(
		"select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  "
		+"from uf_contract a,uf_contract_dist b "
		+"where a.requestid=b.requestid "
		+"and a.state<>'2c91a0302ab11213012ab12bf0f00021' "
		+"	and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0) "
		+"	and not exists (select 1 from uf_income_projectgx where contractno=a.requestid) "
		+"	and b.orgid='"+dept3+"' "
		+"	and substr(a.registerdate,1,4)='"+year+"' " 
		+"	and	to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"' " 
		+"	and	b.distsum<"+baseline+" " 
		+"	and a.no not like '%LX%' "
		+"group by b.orgid, a.classes	"
	);

	//取部门拆分金额年度结转后的,并且不再项目进度控制内的
	List list36b=baseJdbc.executeSqlForList(
		"select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit "
		+"from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e " 
		+"where c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid "
		+"	and a.no not like '%LX%' "
		+"and a.state<>'2c91a0302ab11213012ab12bf0f00021' "
		+"	and exists(select id from formbase where id=a.requestid and isdelete=0) " 
		+"	and not exists (select 1 from uf_income_projectgx where contractno=a.requestid) "
		+"	and substr(a.registerdate,1,4)<'"+year+"' "
		+"	and d.orgunit='"+dept3+"' "
		+"	and c.bookdate=(select max(bookdate) " 
		+"					from uf_income_accountyear x,uf_income_acc_sub y " 
		+"					where x.requestid=y.requestid and x.contractno=a.requestid "  
		+"						and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "
		+"	and	e.distsum<"+baseline+" "
		+"	and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"' "
	);

	//取进度信息表里面的数据一已完成的项目金额
	/*List list36e=baseJdbc.executeSqlForList(
			"select '"+dept3+"' as orgunit, nvl(sum(nvl(b.projectsum,0.0)*nvl(a.theworks/a.allworks,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_income_projectgx b where a.projectrequestid=b.requestid and a.allworks<>0 and a.yearmonth='"+yearmonth+"' and exists(select requestid from uf_contract t where requestid=b.contractno and t.state<>'2c91a0302ab11213012ab12bf0f00021' and (substr(t.registerdate,1,4)<='"+year+"' or t.registerdate is null))"
	);*/
	List list36e=baseJdbc.executeSqlForList(
			"select '"+dept3+"' as orgunit, nvl(sum(nvl(b.distsum,0.0)*nvl(a.theworks/100.0,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_contract_dist b,uf_contract t where a.contractno=b.requestid and	b.distsum>="+baseline+"  and a.yearmonth='"+yearmonth+"' and t.requestid=b.requestid and t.state not in('2c91a0302ab11213012ab12bf0f00021') and (t.state not in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') or ( t.state in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')>='"+yearmonth+"'))  and (substr(t.registerdate,1,4)<='"+year+"' or t.registerdate is null)"
	);
	// and t.requestid=b.requestid and t.state not in('2c91a0302ab11213012ab12bf0f00021') and (t.state not in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') or ( t.state in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"')) 

//本月完成合同产值--监控试验中心
  //本年新签本月的普通合同完成 去掉监督的
	List list46a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295' and b.orgid='"+dept4+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");

		//去年结转常规合同
	List list46b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept4+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"'");
	//List list17b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"');

		//去年结转本月完成 去掉监督的
	//List list46b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0) and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<>'"+year+"'  and  to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"'  and d.orgunit='"+dept4+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	//少了12个月的
	List list46e=baseJdbc.executeSqlForList("select  orgunit,nvl(yearnorm/12,0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and  orgunit='"+dept4+"'");



//-------------------------------
//本年完成合同产值--电力工程部

	tempwhere =" and exists(select id from uf_contract_dist t where requestid=a.requestid and d.orgunit=t.orgunit and to_char(to_date(t.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"')";

   //新签常规合同
	List list17a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and  a.divideclasses<>'2c91a0302b13190a012b146426aa029c'  and b.orgid='"+dept1+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");
   



	//去年结转常规合同
	List list17b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.divideclasses<>'2c91a0302b13190a012b146426aa029c'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"'  and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"' ");

	//List list17b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"');


	//去年结转常规合同
	//List list17b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0) and a.divideclasses<>'2c91a0302b13190a012b146426aa029c' and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	//计算调试类项目
	List list17e=baseJdbc.executeSqlForList("select '"+dept1+"' orgunit,nvl(sum(money),0.0) as money from (select nvl(max(f.process*f.je/100.0),0.0) as money,contractno  from  (select nvl((select d.produceqty from edo_task d where d.id=t.jztaskid),0.0) je,t.process, t.jztaskid contractno,c.status,c.finish1  from uf_income_pcprocess t, edo_task c,uf_contract a where a.requestid=c.projectid(+)  and  t.taskid=a.requestid and to_char(to_date(t.FINISHDATE,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and a.orgunit like '%"+dept1+"%' and a.divideclasses='2c91a0302b13190a012b146426aa029c' and  a.no not like '%LX%'  and exists(select id from formbase where id=a.requestid and isdelete=0) ) f group by contractno)");


	List list17f=baseJdbc.executeSqlForList("select '"+dept1+"' orgunit,nvl(sum(money),0.0) as money from (select nvl(max(f.process*f.je/100.0),0.0) as money,contractno  from  (select nvl((select d.produceqty from edo_task d where d.id=t.jztaskid),0.0) je,t.process,t.jztaskid contractno,c.status,c.finish1  from uf_income_pcprocess t, edo_task c,uf_contract a where a.requestid=c.projectid(+) and  t.CONTRACTNO=a.requestid   and to_char(to_date(t.FINISHDATE,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"' and a.orgunit like '%"+dept1+"%' and a.divideclasses='2c91a0302b13190a012b146426aa029c' and  a.no not like '%LX%'  and exists(select id from formbase where id=a.requestid and isdelete=0) ) f group by contractno)");

	List list17g=baseJdbc.executeSqlForList("select '"+dept1+"' orgunit,nvl(sum(money),0.0) as money from (select nvl(max(f.process*f.je/100.0),0.0) as money,contractno  from  (select nvl((select d.produceqty from edo_task d where d.id=t.jztaskid),0.0) je,t.process,t.jztaskid contractno,c.status,c.finish1  from uf_income_pcprocess t, edo_task c,uf_contract a where a.requestid=c.projectid(+) and  t.CONTRACTNO=a.requestid   and to_char(to_date(t.FINISHDATE,'yyyy-mm-dd'),'yyyy')<'"+year+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"' and a.orgunit like '%"+dept1+"%' and a.divideclasses='2c91a0302b13190a012b146426aa029c' and  a.no not like '%LX%'  and exists(select id from formbase where id=a.requestid and isdelete=0) ) f group by contractno)");

//本年完成合同产值--技术监督部

	//本年新签常规合同
	List list27a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295' and b.orgid='"+dept2+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");
	
	
	//去年结转常规合同

	List list27b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept2+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"'  and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"' ");

	//List list27b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept2+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"');


	List list27e=baseJdbc.executeSqlForList("select  orgunit,nvl(yearnorm/12*"+month+",0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and orgunit='"+dept2+"'");

	//List list27e=baseJdbc.executeSqlForList("select '"+dept2+"' as orgunit,nvl(yearnorm/12,0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and ctrtype='2c91a0302b13190a012b146002250295'");

//本年完成合同产值--高新产品部
	//本年新签，来自非项目进度控制中的合同
	List list37a=baseJdbc.executeSqlForList(
		"select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes "  
		+"from uf_contract a,uf_contract_dist b " 
		+"where a.requestid=b.requestid "
		+"and a.state<>'2c91a0302ab11213012ab12bf0f00021' "
		+"	and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0) " 
		+"	and b.orgid='"+dept3+"' "
		+"	and substr(a.registerdate,1,4)='"+year+"' " 
		+"	and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' " 
		+"	and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"'" 
		+"	and a.no not like '%LX%' "
		+"	and b.distsum<"+baseline+" "
		+"group by b.orgid, a.classes"
	);
	//去年结转，来自非项目进度控制中的合同
	List list37b=baseJdbc.executeSqlForList(
		"select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit " 
		+"from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e "
		+"where  a.no not like '%LX%' "
		+"and a.state<>'2c91a0302ab11213012ab12bf0f00021' "
		+"	and  exists(select id from formbase where id=a.requestid and isdelete=0) "
		+"	and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid " 
		+"	and substr(a.registerdate,1,4)<'"+year+"' "
		+"	and d.orgunit='"+dept3+"' "
		+"	and c.bookdate=(select max(bookdate) " 
		+"					from uf_income_accountyear x,uf_income_acc_sub y " 
		+"					where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"' and y.orgunit=d.orgunit) " 
		+"	and substr(e.implementdate,1,7)<='"+yearmonth+"' "  
		+"	and e.distsum<"+baseline+" "
		+"	and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"' " 
	);
	System.out.println("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit " 
		+"from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e "
		+"where  a.no not like '%LX%' "
		+"and a.state<>'2c91a0302ab11213012ab12bf0f00021' "
		+"	and  exists(select id from formbase where id=a.requestid and isdelete=0) "
		+"	and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid " 
		+"	and substr(a.registerdate,1,4)<'"+year+"' "
		+"	and d.orgunit='"+dept3+"' "
		+"	and c.bookdate=(select max(bookdate) " 
		+"					from uf_income_accountyear x,uf_income_acc_sub y " 
		+"					where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"' and y.orgunit=d.orgunit) " 
		+"	and substr(e.implementdate,1,7)<='"+yearmonth+"' "  
		+"	and e.distsum<"+baseline+" "
		+"	and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"' " );

	//List list36b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where a.no not like '%LX%' and exists(select id from formbase where id=a.requestid and isdelete=0) and a.divideclasses<>'2c91a0302e76867f012eb8bb19f45fbf'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'   and d.orgunit='"+dept3+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	/*//本年新签，来自项目进度控制中的完成额
	List list37e=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.projectsum,0.0)*nvl(a.theworks/a.allworks,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_income_projectgx b where a.projectrequestid=b.requestid and a.allworks<>0 and a.yearmonth<='"+yearmonth+"' and exists(select requestid from uf_contract t where requestid=b.contractno and t.state<>'2c91a0302ab11213012ab12bf0f00021' and to_char(to_date(t.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"')");
	//去年结转，来自项目进度控制中的完成额
	List list37f=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.projectsum,0.0)*nvl(a.theworks/a.allworks,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_income_projectgx b where a.projectrequestid=b.requestid and a.allworks<>0 and  a.yearmonth<='"+yearmonth+"' and exists(select requestid from uf_contract t where requestid=b.contractno and t.state<>'2c91a0302ab11213012ab12bf0f00021' and to_char(to_date(t.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"')");
	//合同没有等级日期的全部算到本年新签当中
	List list37g=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.projectsum,0.0)*nvl(a.theworks/a.allworks,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_income_projectgx b where a.projectrequestid=b.requestid and a.allworks<>0 and a.yearmonth<='"+yearmonth+"' and exists(select requestid from uf_contract t where requestid=b.contractno and t.state<>'2c91a0302ab11213012ab12bf0f00021' and t.registerdate is null)");*/




	//本年新签，来自项目进度控制中的完成额
	List list37e=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.distsum,0.0)*nvl(a.theworks/100.0,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_contract_dist b, uf_contract t where a.contractno=b.requestid  and b.distsum>="+baseline+" and a.yearmonth<='"+yearmonth+"' and  a.yearmonth>='"+year+"' and t.requestid=b.requestid and t.state not in('2c91a0302ab11213012ab12bf0f00021')  and to_char(to_date(t.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"'");
	//去年结转，来自项目进度控制中的完成额
	List list37f=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.distsum,0.0)*nvl(a.theworks/100.0,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_contract_dist b, uf_contract t where a.contractno=b.requestid  and b.distsum>="+baseline+" and  a.yearmonth<='"+yearmonth+"' and  a.yearmonth>='"+year+"' and t.requestid=b.requestid and t.state not in('2c91a0302ab11213012ab12bf0f00021') and to_char(to_date(t.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'");
	//合同没有等级日期的全部算到本年新签当中
	List list37g=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.distsum,0.0)*nvl(a.theworks/100.0,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_contract_dist b, uf_contract t where a.contractno=b.requestid  and b.distsum>="+baseline+" and a.yearmonth<='"+yearmonth+"' and  a.yearmonth>='"+year+"' and t.requestid=b.requestid and t.state not in('2c91a0302ab11213012ab12bf0f00021') and  t.registerdate is null");
	
//本年完成合同产值--监控试验中心
   //新签常规合同
	List list47a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and  a.hosttypep<>'2c91a0302b13190a012b146002250295'  and b.orgid='"+dept4+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(a.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");

	//去年结转常规合同
	List list47b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept4+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy-mm')<='"+yearmonth+"' and to_char(to_date(e.implementdate,'yyyy-mm-dd'),'yyyy')='"+year+"' ");

	//List list47b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0) and a.hosttypep<>'2c91a0302b13190a012b146002250295' and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept4+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");
	//监督合同
	List list47e=baseJdbc.executeSqlForList("select  orgunit,nvl(yearnorm/12*"+month+",0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and orgunit='"+dept4+"'");


//-------------------------------
//下月完成合同产值--电力工程部
	
	tempwhere =" and exists(select id from uf_contract_dist t where requestid=a.requestid and d.orgunit=t.orgunit and to_char(to_date(t.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"')";
	//本年新签的常规合同
	List list110a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and a.divideclasses<>'2c91a0302b13190a012b146426aa029c'   and b.orgid='"+dept1+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(b.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");
	//去年结转的常规合同
	
	List list110b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.divideclasses<>'2c91a0302b13190a012b146426aa029c'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"'");

	//List list110b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0) and a.divideclasses<>'2c91a0302b13190a012b146426aa029c'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"' and d.orgunit='"+dept1+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	List list110e=baseJdbc.executeSqlForList("select '"+dept1+"' orgunit,nvl(sum(money),0.0) as money from (select nvl(max(f.process*f.je/100.0),0.0) as money,contractno  from  (select nvl((select d.produceqty from edo_task d where d.id=t.jztaskid),0.0) je,t.process,t.jztaskid  contractno,c.status,c.finish1 from uf_income_pcprocess t, edo_task c,uf_contract a where a.requestid=c.projectid(+)  and  t.taskid=a.requestid and to_char(to_date(c.FINISH1,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"' and a.orgunit like '%"+dept1+"%' and a.divideclasses='2c91a0302b13190a012b146426aa029c' and  a.no not like '%LX%' and exists (select id from formbase t where t.id=a.requestid and t.isdelete=0) ) f group by contractno)");

//下月完成合同产值--技术监督部


	//本年新签的常规合同
	List list210a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and a.hosttypep<>'2c91a0302ac122a2012ac223c0610418'  and b.orgid='"+dept2+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(b.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");
	//去年结转的常规合同
	List list210b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302ac122a2012ac223c0610418'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept2+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"'");
	//List list210b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0) and a.hosttypep<>'2c91a0302ac122a2012ac223c0610418'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"' and d.orgunit='"+dept2+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	List list210e=baseJdbc.executeSqlForList("select  orgunit,nvl(yearnorm/12,0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and orgunit='"+dept2+"'");




//下月完成合同产值--高新产品部

	//本年新签的合同分产值,不在项目进度控制里面的
	List list310a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0) and not exists (select 1 from uf_income_projectgx where contractno=a.requestid) and b.orgid='"+dept3+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(b.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"' and a.no not like '%LX%' and b.distsum<"+baseline+" group by b.orgid, a.classes");
	//本年结转的合同分产值,不在项目进度控制里面的
	List list310b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)	and not exists (select 1 from uf_income_projectgx where contractno=a.requestid)  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and e.distsum<"+baseline+" and d.orgunit='"+dept3+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"'");
	//List list310b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where a.no not like '%LX%' and exists(select id from formbase where id=a.requestid and isdelete=0) and a.divideclasses<>'2c91a0302e76867f012eb8bb19f45fbf'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'   and d.orgunit='"+dept3+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");
	//


	List list310e=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.distsum,0.0)*nvl(a.nextworks/100,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_contract_dist b, uf_contract t where a.contractno=b.requestid and b.distsum>="+baseline+"  and t.requestid=b.requestid and t.state not in('2c91a0302ab11213012ab12bf0f00021') and (t.state not in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2'))  and a.yearmonth='"+yearmonth+"'");

	//List list310e=baseJdbc.executeSqlForList("select '"+dept3+"' as orgunit, nvl(sum(nvl(b.projectsum,0.0)*nvl(a.nextworks/a.allworks,0.0)),0.0) as money from uf_income_prjgxprocess a , uf_income_projectgx b where a.projectrequestid=b.requestid and a.allworks<>0 and a.yearmonth='"+yearmonth+"'");

//下月完成合同产值--监控试验中心

	//本年新签的常规合同
	List list410a=baseJdbc.executeSqlForList("select nvl(sum(b.distsum),0.0) as money,b.orgid as orgunit,a.classes as classes  from uf_contract a,uf_contract_dist b where a.requestid=b.requestid and exists (select id from formbase f where f.id=a.requestid and f.isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and b.orgid='"+dept4+"' and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')='"+year+"' and to_char(to_date(b.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"' and a.no not like '%LX%' group by b.orgid, a.classes");
	//去年结转的常规合同
	List list410b=baseJdbc.executeSqlForList("select nvl(d.accountmoney,0.0) as money,nvl(d.finishmoney,0.0) as finishmoney,nvl(e.distsum,0.0) as distsum,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d,uf_contract_dist e where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0)  and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and a.requestid=e.requestid and e.orgid=d.orgunit and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"'  and d.orgunit='"+dept3+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) and to_char(to_date(e.predictdate,'yyyy-mm-dd'),'yyyy-mm')='"+nextmonth+"'");
	//List list410b=baseJdbc.executeSqlForList("select nvl(sum(d.accountmoney),0.0) as money,d.orgunit as orgunit  from uf_contract a,uf_income_accountyear c,uf_income_acc_sub d where  a.no not like '%LX%' and  exists(select id from formbase where id=a.requestid and isdelete=0) and a.hosttypep<>'2c91a0302b13190a012b146002250295'  and c.contractno=a.requestid and c.requestid=d.requestid and to_char(to_date(a.registerdate,'yyyy-mm-dd'),'yyyy')<'"+year+"' and d.orgunit='"+dept4+"' and c.bookdate=(select max(bookdate) from uf_income_accountyear x,uf_income_acc_sub y where x.requestid=y.requestid and x.contractno=a.requestid  and x.toyear='"+year+"'  and y.orgunit=d.orgunit) "+tempwhere+" group by d.orgunit");

	List list410e=baseJdbc.executeSqlForList("select  orgunit,nvl(yearnorm/12,0.0) as money from  uf_ctr_yearreg  where year='"+year+"' and orgunit='"+dept4+"'");




//--------------------------------

if(orglist.size()>0)
{
		double sumall1=0.0;
		double sumall2=0.0;
		//去年转接合同额总计
		double sumall3=0.0;
		double sumall4=0.0;
		double sumall5=0.0;
		//本月完成合同产值合计
		double sumall6=0.0;
		double sumall7=0.0;
		double sumall8=0.0;
		double sumall9=0.0;
		double sumall10=0.0;

		double rateall1=0.0;
		double rateall2=0.0;
		double incomeall1=0.0;
		double finishincomeall1=0.0;
	for(int i=0,size=orglist.size();i<size;i++)
	{
		double sum1=0.0;
		double sum2=0.0;
		//去年转接合同额
		double sum3=0.0;
		double sum4=0.0;

		double sum5=0.0;
		//本月完成合同产值
		double sum6=0.0;
		double sum7=0.0;
		double sum8=0.0;
		double sum9=0.0;
		double sum10=0.0;

		double rate1=0.0;
		double rate2=0.0;
		String bgcolor=" bgcolor=\"#FEF7FF\"";
		Map m = (Map)orglist.get(i);
		String id=StringHelper.null2String(m.get("id"));
		String objname=StringHelper.null2String(m.get("objname"));
		double incomeall=Double.valueOf(StringHelper.null2String(m.get("income")));
		double finishincomeall=Double.valueOf(StringHelper.null2String(m.get("finishincome")));;
		buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		buf1.append("<td align=\"center\">"+objname+"</td>");
		
		//本年新签
		for(int x=0,sizex=list1.size();x<sizex;x++)
		{
			Map m1 = (Map)list1.get(x);
			String orgunit=StringHelper.null2String(m1.get("orgunit"));
			String money=StringHelper.null2String(m1.get("money"));
			String month1=StringHelper.null2String(m1.get("month"));
			if(orgunit.equals(id))
			{
				sum2=sum2+Double.valueOf(money);
				if(month1.equals(yearmonth))
				{
					sum1=sum1+Double.valueOf(money);
				}
			}
		}
		
		//去年转接合同额
		for(int x=0,size14=list14.size();x<size14;x++)
		{
			Map m14 = (Map)list14.get(x);
			String orgunit=StringHelper.null2String(m14.get("orgunit"));
			String money=StringHelper.null2String(m14.get("money"));
			if(orgunit.equals(id))
			{
				sum3=sum3+Double.valueOf(money);
			}
		}
		for(int x=0,size24=list24.size();x<size24;x++)
		{
			Map m24 = (Map)list24.get(x);
			String orgunit=StringHelper.null2String(m24.get("orgunit"));
			String money=StringHelper.null2String(m24.get("money"));
			if(orgunit.equals(id))
			{
				sum3=sum3+Double.valueOf(money);
			}
		}
		for(int x=0,size34=list34.size();x<size34;x++)
		{
			Map m34 = (Map)list34.get(x);
			String orgunit=StringHelper.null2String(m34.get("orgunit"));
			String money=StringHelper.null2String(m34.get("money"));
			if(orgunit.equals(id))
			{
				sum3=sum3+Double.valueOf(money);
			}
		}
		for(int x=0,size44=list44.size();x<size44;x++)
		{
			Map m44 = (Map)list44.get(x);
			String orgunit=StringHelper.null2String(m44.get("orgunit"));
			String money=StringHelper.null2String(m44.get("money"));
			if(orgunit.equals(id))
			{
				sum3=sum3+Double.valueOf(money);
			}
		}
		//本月完成
		//----------------------2011-3-23smz----------------------
		for(int x=0,size16a=list16a.size();x<size16a;x++)
		{
			Map m16a = (Map)list16a.get(x);
			String orgunit=StringHelper.null2String(m16a.get("orgunit"));
			String money=StringHelper.null2String(m16a.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		for(int x=0,size16b=list16b.size();x<size16b;x++)
		{
			Map m16b = (Map)list16b.get(x);
			String orgunit=StringHelper.null2String(m16b.get("orgunit"));
						String money=StringHelper.null2String(m16b.get("money"));
			String finishmoney=StringHelper.null2String(m16b.get("finishmoney"));
			String distsum=StringHelper.null2String(m16b.get("distsum"));
			if(orgunit.equals(id))
			{
				//sum6=sum6+Double.valueOf(money);
				sum6=sum6+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size16e=list16e.size();x<size16e;x++)
		{
			Map m16e = (Map)list16e.get(x);
			String orgunit=StringHelper.null2String(m16e.get("orgunit"));
			String money=StringHelper.null2String(m16e.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		for(int x=0,size16f=list16f.size();x<size16f;x++)
		{
			Map m16f = (Map)list16f.get(x);
			String orgunit=StringHelper.null2String(m16f.get("orgunit"));
			String money=StringHelper.null2String(m16f.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6-Double.valueOf(money);
			}
		}
		
		//本月完成合同产值---技术监督部
		for(int x=0,size26a=list26a.size();x<size26a;x++)
		{
			Map m26a = (Map)list26a.get(x);
			String orgunit=StringHelper.null2String(m26a.get("orgunit"));
			String money=StringHelper.null2String(m26a.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		for(int x=0,size26b=list26b.size();x<size26b;x++)
		{
			Map m26b = (Map)list26b.get(x);
			String orgunit=StringHelper.null2String(m26b.get("orgunit"));
						String money=StringHelper.null2String(m26b.get("money"));
			String finishmoney=StringHelper.null2String(m26b.get("finishmoney"));
			String distsum=StringHelper.null2String(m26b.get("distsum"));
			if(orgunit.equals(id))
			{
					//sum6=sum6+Double.valueOf(money);
				sum6=sum6+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size26e=list26e.size();x<size26e;x++)
		{
			Map m26e = (Map)list26e.get(x);
			String orgunit=StringHelper.null2String(m26e.get("orgunit"));
			String money=StringHelper.null2String(m26e.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		
		//本月完成合同产值---高新产品部
		for(int x=0,size36a=list36a.size();x<size36a;x++)
		{
			Map m36a = (Map)list36a.get(x);
			String orgunit=StringHelper.null2String(m36a.get("orgunit"));
			String money=StringHelper.null2String(m36a.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		for(int x=0,size36b=list36b.size();x<size36b;x++)
		{
			Map m36b = (Map)list36b.get(x);
			String orgunit=StringHelper.null2String(m36b.get("orgunit"));
						String money=StringHelper.null2String(m36b.get("money"));
			String finishmoney=StringHelper.null2String(m36b.get("finishmoney"));
			String distsum=StringHelper.null2String(m36b.get("distsum"));
			if(orgunit.equals(id))
			{
					//sum6=sum6+Double.valueOf(money);
				sum6=sum6+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		
		for(int x=0,size36e=list36e.size();x<size36e;x++)
		{
			Map m36e = (Map)list36e.get(x);
			String orgunit=StringHelper.null2String(m36e.get("orgunit"));
			String money=StringHelper.null2String(m36e.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		//本月完成合同产值---监控试验中心
		for(int x=0,size46a=list46a.size();x<size46a;x++)
		{
			Map m46a = (Map)list46a.get(x);
			String orgunit=StringHelper.null2String(m46a.get("orgunit"));
			String money=StringHelper.null2String(m46a.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		for(int x=0,size46b=list46b.size();x<size46b;x++)
		{
			Map m46b = (Map)list46b.get(x);
			String orgunit=StringHelper.null2String(m46b.get("orgunit"));
						String money=StringHelper.null2String(m46b.get("money"));
			String finishmoney=StringHelper.null2String(m46b.get("finishmoney"));
			String distsum=StringHelper.null2String(m46b.get("distsum"));
			if(orgunit.equals(id))
			{
					//sum6=sum6+Double.valueOf(money);
				sum6=sum6+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size46e=list46e.size();x<size46e;x++)
		{
			Map m46e= (Map)list46e.get(x);
			String orgunit=StringHelper.null2String(m46e.get("orgunit"));
			String money=StringHelper.null2String(m46e.get("money"));
			if(orgunit.equals(id))
			{
				sum6=sum6+Double.valueOf(money);
			}
		}
		//本年完成
		//------------------------2011-3-24------------------------------------
		//电力工程部
		for(int x=0,size17a=list17a.size();x<size17a;x++)
		{
			Map m17a = (Map)list17a.get(x);
			String orgunit=StringHelper.null2String(m17a.get("orgunit"));
			
			String money=StringHelper.null2String(m17a.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		for(int x=0,size17b=list17b.size();x<size17b;x++)
		{
			Map m17b = (Map)list17b.get(x);
			String orgunit=StringHelper.null2String(m17b.get("orgunit"));
			String money=StringHelper.null2String(m17b.get("money"));
			String finishmoney=StringHelper.null2String(m17b.get("finishmoney"));
			String distsum=StringHelper.null2String(m17b.get("distsum"));
			if(orgunit.equals(id))
			{
				//sum7=sum7+Double.valueOf(money);
				sum7=sum7+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size17e=list17e.size();x<size17e;x++)
		{
			Map m17e = (Map)list17e.get(x);
			String orgunit=StringHelper.null2String(m17e.get("orgunit"));
			String money=StringHelper.null2String(m17e.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		for(int x=0,size17f=list17f.size();x<size17f;x++)
		{
			Map m17f = (Map)list17f.get(x);
			String orgunit=StringHelper.null2String(m17f.get("orgunit"));
			String money=StringHelper.null2String(m17f.get("money"));
			if(orgunit.equals(id))
			{
				sum7=sum7+Double.valueOf(money);
			}
		}

		for(int x=0,size17g=list17g.size();x<size17g;x++)
		{
			Map m17g = (Map)list17g.get(x);
			String orgunit=StringHelper.null2String(m17g.get("orgunit"));
			String money=StringHelper.null2String(m17g.get("money"));
			if(orgunit.equals(id))
			{
				sum7=sum7-Double.valueOf(money);
			}
		}
		
		//技术监督部

		for(int x=0,size27a=list27a.size();x<size27a;x++)
		{
			Map m27a = (Map)list27a.get(x);
			String orgunit=StringHelper.null2String(m27a.get("orgunit"));
			String money=StringHelper.null2String(m27a.get("money"));

			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		for(int x=0,sizem27b=list27b.size();x<sizem27b;x++)
		{
			Map m27b = (Map)list27b.get(x);
			String orgunit=StringHelper.null2String(m27b.get("orgunit"));
			String money=StringHelper.null2String(m27b.get("money"));
			String finishmoney=StringHelper.null2String(m27b.get("finishmoney"));
			String distsum=StringHelper.null2String(m27b.get("distsum"));
			if(orgunit.equals(id))
			{
				//sum7=sum7+Double.valueOf(money);
				sum7=sum7+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}

		for(int x=0,size27e=list27e.size();x<size27e;x++)
		{
			Map m27e = (Map)list27e.get(x);
			String orgunit=StringHelper.null2String(m27e.get("orgunit"));
			String money=StringHelper.null2String(m27e.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}

		
		//本年已完成的合同产值---高新产品部
	
		for(int x=0,size37a=list37a.size();x<size37a;x++)
		{
			Map m37a = (Map)list37a.get(x);
			String orgunit=StringHelper.null2String(m37a.get("orgunit"));
			String money=StringHelper.null2String(m37a.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		for(int x=0,sizem37b=list37b.size();x<sizem37b;x++)
		{
			Map m37b = (Map)list37b.get(x);
			String orgunit=StringHelper.null2String(m37b.get("orgunit"));
			String money=StringHelper.null2String(m37b.get("money"));
			String finishmoney=StringHelper.null2String(m37b.get("finishmoney"));
			String distsum=StringHelper.null2String(m37b.get("distsum"));
			if(orgunit.equals(id))
			{
				//sum7=sum7+Double.valueOf(money);
				sum7=sum7+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}


		for(int x=0,size37e=list37e.size();x<size37e;x++)
		{
			Map m37e = (Map)list37e.get(x);
			String orgunit=StringHelper.null2String(m37e.get("orgunit"));
			String money=StringHelper.null2String(m37e.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		for(int x=0,size37f=list37f.size();x<size37f;x++)
		{
			Map m37f = (Map)list37f.get(x);
			String orgunit=StringHelper.null2String(m37f.get("orgunit"));
			String money=StringHelper.null2String(m37f.get("money"));
			if(orgunit.equals(id))
			{
				sum7=sum7+Double.valueOf(money);
			}
		}
		for(int x=0,size37g=list37g.size();x<size37g;x++){
			Map m37g = (Map)list37g.get(x);
			String orgunit=StringHelper.null2String(m37g.get("orgunit"));
			String money=StringHelper.null2String(m37g.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		//本月完成合同产值---监控试验中心
		for(int x=0,size47a=list47a.size();x<size47a;x++)
		{
			Map m47a = (Map)list47a.get(x);
			String orgunit=StringHelper.null2String(m47a.get("orgunit"));
			String money=StringHelper.null2String(m47a.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		for(int x=0,sizem47b=list47b.size();x<sizem47b;x++)
		{
			Map m47b = (Map)list47b.get(x);
			String orgunit=StringHelper.null2String(m47b.get("orgunit"));
			String money=StringHelper.null2String(m47b.get("money"));
			String finishmoney=StringHelper.null2String(m47b.get("finishmoney"));
			String distsum=StringHelper.null2String(m47b.get("distsum"));
			if(orgunit.equals(id))
			{
				//sum7=sum7+Double.valueOf(money);
				sum7=sum7+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size47e=list47e.size();x<size47e;x++)
		{
			Map m47e = (Map)list47e.get(x);
			String orgunit=StringHelper.null2String(m47e.get("orgunit"));
			String money=StringHelper.null2String(m47e.get("money"));
			if(orgunit.equals(id))
			{
				sum8=sum8+Double.valueOf(money);
			}
		}
		
		//---------------------------------------------------------------
		//预计下月完成
		//----------------------------------------------------------
		for(int x=0,size110a=list110a.size();x<size110a;x++)
		{
			Map m110a = (Map)list110a.get(x);
			String orgunit=StringHelper.null2String(m110a.get("orgunit"));
			String money=StringHelper.null2String(m110a.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		for(int x=0,sizem110b=list110b.size();x<sizem110b;x++)
		{
			Map m110b = (Map)list110b.get(x);
			String orgunit=StringHelper.null2String(m110b.get("orgunit"));
			String money=StringHelper.null2String(m110b.get("money"));
			String finishmoney=StringHelper.null2String(m110b.get("finishmoney"));
			String distsum=StringHelper.null2String(m110b.get("distsum"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}

		for(int x=0,size110e=list110e.size();x<size110e;x++)
		{
			Map m110e = (Map)list110e.get(x);
			String orgunit=StringHelper.null2String(m110e.get("orgunit"));
			String money=StringHelper.null2String(m110e.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		
		//本月完成合同产值---技术监督部
		for(int x=0,size210a=list210a.size();x<size210a;x++)
		{
			Map m210a = (Map)list210a.get(x);
			String orgunit=StringHelper.null2String(m210a.get("orgunit"));
			String money=StringHelper.null2String(m210a.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		for(int x=0,sizem210b=list210b.size();x<sizem210b;x++)
		{
			Map m210b = (Map)list210b.get(x);
			String orgunit=StringHelper.null2String(m210b.get("orgunit"));
			String money=StringHelper.null2String(m210b.get("money"));
			String finishmoney=StringHelper.null2String(m210b.get("finishmoney"));
			String distsum=StringHelper.null2String(m210b.get("distsum"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		
		for(int x=0,size210e=list210e.size();x<size210e;x++)
		{
			Map m210e = (Map)list210e.get(x);
			String orgunit=StringHelper.null2String(m210e.get("orgunit"));
			String money=StringHelper.null2String(m210e.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		
		//--高新产品部
		for(int x=0,size310a=list310a.size();x<size310a;x++)
		{
			Map m310a = (Map)list310a.get(x);
			String orgunit=StringHelper.null2String(m310a.get("orgunit"));
			String money=StringHelper.null2String(m310a.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		for(int x=0,sizem310b=list310b.size();x<sizem310b;x++)
		{
			Map m310b = (Map)list310b.get(x);
			String orgunit=StringHelper.null2String(m310b.get("orgunit"));
			String money=StringHelper.null2String(m310b.get("money"));
			String finishmoney=StringHelper.null2String(m310b.get("finishmoney"));
			String distsum=StringHelper.null2String(m310b.get("distsum"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size310e=list310e.size();x<size310e;x++)
		{
			Map m310e = (Map)list310e.get(x);
			String orgunit=StringHelper.null2String(m310e.get("orgunit"));
			String money=StringHelper.null2String(m310e.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		//本月完成合同产值---监控试验中心
		for(int x=0,size410a=list410a.size();x<size410a;x++)
		{
			Map m410a = (Map)list410a.get(x);
			String orgunit=StringHelper.null2String(m410a.get("orgunit"));
			String money=StringHelper.null2String(m410a.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		for(int x=0,sizem410b=list410b.size();x<sizem410b;x++)
		{
			Map m410b = (Map)list410b.get(x);
			String orgunit=StringHelper.null2String(m410b.get("orgunit"));
			String money=StringHelper.null2String(m410b.get("money"));
			String finishmoney=StringHelper.null2String(m410b.get("finishmoney"));
			String distsum=StringHelper.null2String(m410b.get("distsum"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(distsum)-Double.valueOf(finishmoney);
			}
		}
		for(int x=0,size410e=list410e.size();x<size410e;x++)
		{
			Map m410e = (Map)list410e.get(x);
			String orgunit=StringHelper.null2String(m410e.get("orgunit"));
			String money=StringHelper.null2String(m410e.get("money"));
			if(orgunit.equals(id))
			{
				sum9=sum9+Double.valueOf(money);
			}
		}
		//--------------------------------------------------------
		
		
		sum4=sum2+sum3;
		sum10=sum4-sum7-sum8;
		
		sum1=sum1/10000.0;
		sum2=sum2/10000.0;
		sum3=sum3/10000.0;
		sum4=sum4/10000.0;
		sum5=sum5/10000.0;
		sum6=sum6/10000.0;
		sum7=sum7/10000.0;
		sum8=sum8/10000.0;
		sum9=sum9/10000.0;
		sum10=sum10/10000.0;

		rate1=(incomeall>0.0)?Math.round(sum2*10000/incomeall)/100.0:0.0;

		rate2=(finishincomeall>0.0)?Math.round((sum7+sum8)*10000/(finishincomeall*1.0))/100.0:0.0;
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum1)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum2)+"</td>");
		buf1.append("<td align=\"middle\">"+NumberHelper.moneyAddComma(rate1)+"%</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum3)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum4)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum6)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum7)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum8)+"</td>");
		buf1.append("<td align=\"middle\">"+NumberHelper.moneyAddComma(rate2)+"%</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum9)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sum10)+"</td>");

	
		buf1.append("</tr>");
		sumall1+=sum1;
		sumall2+=sum2;
		sumall3+=sum3;
		sumall4+=sum4;
		sumall5+=sum5;
		sumall6+=sum6;
		sumall7+=sum7;
		sumall8+=sum8;
		sumall9+=sum9;
		sumall10+=sum10;
		rateall1=0.0;
		rateall2=0.0;
		incomeall1+=incomeall;
		finishincomeall1+=finishincomeall;
	}
	rateall1=(incomeall1>0.0)?Math.round(sumall2*10000/(incomeall1*1.0))/100.0:0.0;
	rateall2=(finishincomeall1>0.0)?Math.round((sumall7+sumall8)*10000/(finishincomeall1*1.0))/100.0:0.0;
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"1\"   align=\"center\"><b>合计</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall1)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall2)+"</b></td>");
	buf1.append("<td align=\"center\"><b>"+rateall1+"%</b></td>");
	buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sumall3)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall4)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall6)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall7)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall8)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(rateall2)+"%</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall9)+"</b></td>");
	buf1.append("<td align=\"right\"><b>"+NumberHelper.moneyAddComma(sumall10)+"</b></td>");
	
	buf1.append("</tr>");
}
out.println(buf1.toString());

%>
</tbody>
</table>
</div>
<c:if test="${!isExcel}">


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
<!-- 
update uf_contract_dist t set predictdate=(select predictdate from uf_contract where requestid=t.requestid);
update uf_contract_dist t set implementdate=(select implementdate from uf_contract where requestid=t.requestid);
update uf_income_acc_sub t set finishmoney=(select distsum from uf_contract a,uf_contract_dist b,uf_income_accountyear c where a.requestid=b.requestid and a.requestid=c.contractno and c.requestid=t.requestid)

update uf_income_acc_sub t set finishmoney=finishmoney-accountmoney

http://localhost:8081/app/ft/taskDeal.jsp?action=contractdist
-->
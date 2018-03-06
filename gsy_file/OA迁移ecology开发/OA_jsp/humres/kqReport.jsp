<%@ page contentType="text/html; charset=UTF-8"%>
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
String deptcnd = request.getParameter("deptcnd");
if(deptcnd==null) deptcnd="";
String empcnd = request.getParameter("empcnd");
if(empcnd==null) empcnd="";

String where="";
if(monthcnd.length()>0)
{
	where = where +" and to_char(to_date(nvl((select max(finidate) finidate from uf_pc_prjev where prjid=b.requestid),b.yjfrq),'yyyy-mm-dd'),'yyyy-mm')<='"+yearcnd+"-"+monthcnd+"'";
}
if(deptcnd.length()>0)
{
	where = where +" and b.czbm='"+deptcnd+"'";
}
if(empcnd.length()>0)
{
	where = where +" and b.xmxz='"+empcnd+"'";
}
String action=StringHelper.null2String(request.getParameter("action"));
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
String sql1 ="select rownum rn,a.id,a.obname FROM humres a WHERE  c.ISDELETE=0 and  "+where+" ORDER BY a.objno desc";
String sql ="select rownum rn,a.id,a.obname FROM humres a WHERE  c.ISDELETE=0 and  "+where+" ORDER BY a.objno desc";
StringBuffer sqlData = new StringBuffer();
StringBuffer sqlAll = new StringBuffer();
sqlAll.append("SELECT count(*) NUM FROM (").append(sql1).append(")");
List listAll=ds.getValues(sqlAll.toString());
String pagenum=request.getParameter("pageNum");
int pageNum=15;
if(pagenum!=null&&pagenum.trim().length()>0)
	pageNum=Integer.parseInt(pagenum);

int totalNum = (listAll!=null && listAll.size()>0)?Integer.parseInt(((Map)listAll.get(0)).get("NUM").toString()):0;
String toPageType=request.getParameter("toPageType");
if(toPageType==null) toPageType="1";
String pageno1=request.getParameter("pageno");
if(pageno1==null||pageno1.trim().equals(""))pageno1="1";
int pageno=Integer.parseInt(pageno1);
int totalPage = (totalNum-1)/pageNum+1;
if(toPageType.equals("1"))pageno=1;
else if(toPageType.equals("2"))pageno=pageno-1;
else if(toPageType.equals("3"))pageno=pageno+1;
else if(toPageType.equals("4"))pageno=totalPage;
else if(toPageType.equals("5"))pageno=pageno;
pageno = pageno>totalPage?totalPage:pageno;
pageno = pageno<1?1:pageno;
int startNum=pageNum*(pageno-1)+1;
startNum = (startNum>totalNum)?(totalNum-pageNum):startNum;
startNum =(startNum<0)?0:startNum;
sqlData.append("SELECT * FROM (").append(sql).append(") WHERE rn>="+startNum+" and rn<"+(startNum+pageNum)+" order by rn");
List listData=ds.getValues(sqlData.toString());
int realNum=listData.size();
int endNum = startNum+realNum-1;
endNum=endNum<0?0:endNum;

%>
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
<%

if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="考勤统计表.xls";
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
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15002c")%><!-- 考勤统计表 --></title>
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
<script type="text/vbscript">
sub getrefobj(inputname,inputspan,refid,viewurl,isneed)
	ids = window.showModalDialog("/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id="+refid)
	if (Not IsEmpty(ids)) then
	if ids(0) <> "0" then
		document.all(inputname).value = ids(0)
		document.all(inputspan).innerHtml = ids(1)
	else 
		document.all(inputname).value = ""
		if isneed="0" then
		document.all(inputspan).innerHtml = ""
		else
		document.all(inputspan).innerHtml = "<img src=/images/checkinput.gif>"
		end if
	end if
	end if
end sub
</script>
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0058")%>','A','accept',function(){showAll()});//显示全部
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028")%>','P','print',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025")%>','E','page_excel',Save2Excel);//导出为Excel
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
<form action="/app/project/projectReport.jsp" name="formExport" method="post">
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
<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%><!-- 部门 -->:</td> 
<TD class=FieldValue width="15%"><span> <BUTTON type="button" class=Browser onclick="javascript:getrefobj('deptcnd','deptcndspan','402881e60bfee880010bff17101a000c','','0');"></BUTTON> <INPUT type=hidden value="<%=deptcnd%>" name=deptcnd> <SPAN id=deptcndspan name="deptcndspan"><%=getBrowserDicValue("orgunit","id","objname",deptcnd)%></SPAN></SPAN> </TD>
</TR>
</table>
<br>
<div id='repContainer'>
</c:if>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15002c")%></CENTER><BR></div>
<CENTER>
<div align=left width="50%"><%=yearcnd+" "+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+" "+monthcnd+" "+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150016")+" "%><!-- 年 --><!-- 月份 --></div>
<div align=right width="50%"></div>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:2000" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="40" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	 <col width="200" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150062")%></td><!-- 员工号 -->
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%></td><!-- 姓名 -->
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%></td><!-- 部门 -->
	 <td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150063")%></td><!-- 异常(次) -->		
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150064")%></td><!-- 病假(次) -->
	 <td colspan="1" rowspan="1" align="center"> <%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150065")%></td><!-- 事假(次) -->
	 <td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150066")%></td><!-- 其他请假(次) -->	
	 <td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150067")%></td><!-- 出差(次) -->	
	  <td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150068")%></td><!-- 旷工(次) -->		
	 <td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150069")%></td><!-- 其他异常(次) -->	
  </tr>
<tbody>
<%
StringBuffer buf1 = new StringBuffer();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("kq");//实例化数据库连接对象
List list =baseJdbc.executeSqlForList("select recid from employee where empno in ("+empnos+")");//取最大采购单号

BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("kq");//实例化数据库连接对象
List list =baseJdbc.executeSqlForList("select datetime from cardrecord"+yearcnd+String.valueOf(Interger.parseInt(monthcnd))+" where empid in ("+empids+")");//取所有异常数据


int  billid=1;
if(list.size()>0)
{
	Map m = (Map) list.get(0);
	billid=Integer.parseInt(StringHelper.null2String(m.get("SYEDOC")));
}
String finishmonth=yearcnd+"-"+monthcnd;
double sum1=0.0;
double sum2=0.0;
double sum3=0.0;
int sumnum1=0;
int sumnum2=0;
int sumnum3=0;
int sumnum4=0;
for(int i=0;i<realNum;i++)
{
	
	double rate = 0.00;
	Map m = (Map)listData.get(i);
	String xh=StringHelper.null2String(m.get("xh"));
	String flowno=StringHelper.null2String(m.get("flowno"));
	String prjname=StringHelper.null2String(m.get("prjname"));
	String xhxh=StringHelper.null2String(m.get("xhxh"));
	String mainprj=StringHelper.null2String(m.get("mainprj"));
	String ddlh=StringHelper.null2String(m.get("ddlh"));
	String czbm=StringHelper.null2String(m.get("czbm"));
	String xmfzr=StringHelper.null2String(m.get("xmfzr"));
	String yhdw=StringHelper.null2String(m.get("yhdw"));
	String yhdm=StringHelper.null2String(m.get("yhdm"));
	String sl=StringHelper.null2String(m.get("sl"));
	if(xhzt.equals("4029e46723e96cc30123ea49e6ca0264"))
	{
		finishdate="";
		jd="0";
		sl="0";
		zj="0.00";
	}
	else
	{
		sumnum1+=Integer.parseInt(sl);
		sumnum2+=Integer.parseInt(innum);
		sumnum3+=Integer.parseInt(outnum);
		sumnum4+=Integer.parseInt(fatenum);
		sum1+=Double.valueOf(zj);
		sum2+=Double.valueOf(invosum);
		sum3+=Double.valueOf(zj)*Integer.parseInt(innum);
	}
	String execon="";
	//List execonList = ds.getValues("select nvl(execquti||'-'||bookdate,'') execquti from uf_pc_taskbrief where taskid='"+requestidc+"' order by bookdate");
	List execonList = ds.getValues("select nvl(execquti||'-'||to_char(to_date(bookdate,'yyyy-mm-dd'),'mm/dd'),'') execquti from uf_pc_taskbrief where taskid='"+requestidc+"'  order by bookdate");
	for(int k=0,size=execonList.size();k<size;k++)
	{
		Map m2 = (Map)execonList.get(k);
		String execquti=StringHelper.null2String(m2.get("execquti"));
		
		if(execquti.length()>6)
		{
			if(k<size-1)
				execon=execon+execquti+"<br>";
			else
				execon=execon+execquti;
		}
	}
//
	buf1.append("<tr style=\"height:25;\" "+(xhzt.equals("4029e46723e96cc30123ea49e6ca0264")?"bgcolor=\"#F8A3FE\"":"")+" >");
	buf1.append("<td align=\"center\">"+xh+"</td>");
	buf1.append("<td align=\"center\">"+flowno+"</td>");
	buf1.append("<td align=\"center\">"+prjname+"</td>");
	buf1.append("<td align=\"center\">"+xhxh+"</td>");
	buf1.append("<td align=\"center\">"+getSelectDicValue(xmxz)+"</td>");
	buf1.append("<td align=\"center\">"+getSelectDicValue(mainprj)+"</td>");
	buf1.append("<td align=\"center\">"+getBrowserDicValue("orgunit","id","objname",czbm)+"</td>");
	buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",xmfzr)+"</td>");
	buf1.append("<td align=\"center\">"+yhdw+"</td>");
	buf1.append("<td align=\"center\">"+yhdm+"</td>");
	
	buf1.append("<td align=\"center\">"+qdqdrq+"</td>");
	buf1.append("<td align=\"center\">"+yjfrq+"</td>");
	buf1.append("<td align=\"center\">"+finishdate+"</td>");
	buf1.append("<td align=\"center\">"+ddlh+"</td>");
	buf1.append("<td align=\"right\">"+sl+"</td>");
	buf1.append("<td align=\"right\">"+innum+"</td>");
	buf1.append("<td align=\"right\">"+outnum+"</td>");
	buf1.append("<td align=\"right\">"+fatenum+"</td>");
	buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(zj)+"</td>");
	buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(invosum)+"</td>");
	buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(Double.valueOf(zj)*Integer.parseInt(innum))+"</td>");
	double jd1 = Double.valueOf(jd);
	buf1.append("<td align=\"center\" "+(jd1>=99?"style='color:red'":"")+">"+(jd1>=99?labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001d"):getSelectDicValue(xhzt))+"</td>");//完成
	buf1.append("<td align=\"center\" >"+progress(jd)+"</td>");
	
	buf1.append("<td align=\"left\">"+execon+"</td>");
	buf1.append("</tr>");
}
buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
buf1.append("<td height=\"25\" colspan=\"14\"   align=\"center\"><b>总计</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+sumnum1+"</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+sumnum2+"</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+sumnum3+"</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+sumnum4+"</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum1)+"</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum2)+"</b></td>");
buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum3)+"</b></td>");

buf1.append("<td colspan=\"3\"  align=\"right\">&nbsp;</td>");
buf1.append("</tr>");
out.println(buf1.toString());

%>
</tbody>
</table>
</div>
<div align="left"  style="border:1px solid #c3daf9;">
<table border="0" style="border-collapse:collapse;" bordercolor="#c3daf9" width="100%">
<tr>
<td width="15%" align=right>
&nbsp;&nbsp;<a <%=pageno<=1?"":"href=\"javascript:toPage(1);\""%> ><img src="/app/images/resultset_first.gif"  style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800069")%>"><!-- 首页 --></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno<=1?"":"href=\"javascript:toPage(2);\""%>><img src="/app/images/resultset_previous.gif" style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006a")%>"><!-- 前页 --></a>&nbsp;&nbsp;&nbsp;</td>
<td width="10%" align=center>
<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%><!-- 第 --> &nbsp;<input type="text" id="pageno" name="pageno" value="<%=pageno%>" size="1" style="height:16;font-size:11;text-align:center;padding-bottom:2px" onchange="javascript:toPage(5);" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%><!-- 页 -->&nbsp;/&nbsp;<%=totalPage%>
</td><td width="15%" align=left>
&nbsp;&nbsp;&nbsp;<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(3);\""%>><img src="/app/images/resultset_next.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006b")%>"><!-- 后页 --></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(4);\""%>><img src="/app/images/resultset_last.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150027")%>"><!-- 属页 --> </a>&nbsp;&nbsp;&nbsp;
</td>
<td width="40%">&nbsp;</td>
<td width="20%" align=center><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006d")%><!-- 记录 -->:&nbsp;<%=startNum%>&nbsp;~&nbsp;<%=endNum%>&nbsp;/&nbsp;<%=totalNum%>&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>
<input type="hidden" id="toPageType" name="toPageType" value="">
<input type="hidden" id="pageNum" name="pageNum" value="<%=pageNum%>">

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
</form>
<c:if test="${!isExcel}">
</body>
</html>
</c:if>


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
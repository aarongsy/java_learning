<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
Calendar cal = Calendar.getInstance(); 
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH)+1;
month=month-1;
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
String thismonth=nf+"-"+yf;
String lastmonth=nf+"-"+yf;
String nextmonth=nf+"-"+yf;
if(month<2)
{
	lastmonth=(year-1)+"-12";
}
else
{
	lastmonth=year+"-"+((month-1<10)?"0"+(month-1):(month-1));
}
if(month>11)
{
	nextmonth=(year+1)+"-01";
}
else
{
	nextmonth=year+"-"+((month+1)<10?"0"+(month+1):(month+1));
}

String where="";
where = where +" and ((to_char(to_date(c.implementdate,'yyyy-mm-dd'),'yyyy-mm')='"+thismonth+"' and c.state in ('2c91a0302a8cef72012a8eabe0e803f2','2c91a0302a8cef72012a8eabe0e803f3')) or c.state in ('2c91a0302a8cef72012a8eabe0e803f1','2c91a0302ab11213012ab12bf0f00022','2c91a0302a8cef72012a8eabe0e803f0') )";
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
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
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300015")%><!-- 调试产值月度报表 --></title>
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','S','accept',function(){onSearch()});//确定
	topBar.render('pagemenubar');
	topBar.addSeparator();
	//addBtn(topBar,'显示全部','A','accept',function(){showAll()});
	//topBar.addSpacer();
	//topBar.addSpacer();
	//topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028")%>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025")%>','E','page_excel',Save2Excel);//导出为Excel
	/*topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'导出全部','M','page_excel',exportAll);*/
	var idx=location.href.indexOf('?');
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

<div id='seachdiv'>
<div id="pagemenubar"></div>
<form action="/app/ft/pcsumReports.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
		<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0002")%> </td><!-- 年月 -->
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
		<option value="01" <%=yf.equals("01")?"selected":""%>>01<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="02" <%=yf.equals("02")?"selected":""%>>02<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="03" <%=yf.equals("03")?"selected":""%>>03<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="04" <%=yf.equals("04")?"selected":""%>>04<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="05" <%=yf.equals("05")?"selected":""%>>05<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="06" <%=yf.equals("06")?"selected":""%>>06<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="07" <%=yf.equals("07")?"selected":""%>>07<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="08" <%=yf.equals("08")?"selected":""%>>08<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="09" <%=yf.equals("09")?"selected":""%>>09<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="10" <%=yf.equals("10")?"selected":""%>>10<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="11" <%=yf.equals("11")?"selected":""%>>11<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		<option value="12" <%=yf.equals("12")?"selected":""%>>12<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
		</select>
		</span>
		</td>
</tr>
</table>
</div>
<div id='repContainer'>
</c:if><BR>

<%
String sql="select c.requestid,c.no,c.name,c.money,c.predictdate,c.implementdate,a.finish1,c.finishdate,A.id,A.REQUESTID REQUESTIDa,A.OBJNAME,A.PRODUCEQTY from edo_task a,uf_contract c where a.model='2c91a84e2aa7236b012aa737d8930005' and a.MASTERTYPE='2c91a0302acabc4e012acac827220002' and a.projectid=c.requestid  "+where+" order by c.no,a.outlinelevel,a.outlinenumber";
List jzlist= baseJdbc.executeSqlForList(sql);


%>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")%><%=yf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300015")%></CENTER></div><!-- 年 --><!-- 调试产值月度报表 --> 
<div align=left width="50%"></div><div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001e")%></div><!-- 单位(元) --> 
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
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b")%></td><!-- 合同编号 -->
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c")%></td><!-- 合同名称 -->
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150051")%></td><!-- 合同金额 -->
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0009")%></td><!-- 机组编号 -->
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39310019")%></td><!-- 下达产值 -->
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001a")%></td><!-- 进度阶段 -->
			<td colspan="2" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001b")%></td>	<!-- 合同结项 -->
			<td colspan="3" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec718006a")%></td>	<!-- 完成百分比 -->
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%></td>		<!-- 说明 -->
  </tr>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec718006b")%></td>	<!-- 预计 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006c")%></td><!-- 实际 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001c")%></td>	<!-- 已完成 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006d")%></td><!-- 本月完成 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006e")%></td>	<!-- 预计下月完成 -->	
  </tr>
<tbody>
<%
	String color1="#D5F9F9";
	String color2="#F8D3FC";
	String color3="#FBF5B0";
StringBuffer buf1 = new StringBuffer();
	double sum1=0.0;
	double sum2=0.0;
	double sum3=0.0;
	double sum4=0.0;
	double sum5=0.0;
	String contractno2="";
	int size=jzlist.size();
	for(int i=0;i<size;i++)
	{
		Map m = (Map)jzlist.get(i);
		String id=StringHelper.null2String(m.get("id"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String contractno=StringHelper.null2String(m.get("no"));		
		String name=StringHelper.null2String(m.get("name"));
		String produceqty =StringHelper.null2String(m.get("produceqty"));
		String finish1=StringHelper.null2String(m.get("finish1"));
		String remark=StringHelper.null2String(m.get("remark"));
		String money=StringHelper.null2String(m.get("money"));
		String finishdate=StringHelper.null2String(m.get("finishdate"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String mtstate=StringHelper.null2String(m.get("status"));
		String requestida=StringHelper.null2String(m.get("REQUESTIDa"));
				//识别任务
		List jdlist= baseJdbc.executeSqlForList("select a.id,a.objname,nvl(b.process,a.objdesc) process,b.taskid,b.requestid,nvl(b.dsporder,a.dsporder) dsporder,b.jztaskid,b.remark,b.FINISH1,b.FINISHDATE INDENTFINISHDATE,b.STATUS,to_char(to_date(b.FINISH1,'yyyy-mm-dd'),'yyyy-mm') planmonth,to_char(to_date(b.FINISHDATE,'yyyy-mm-dd'),'yyyy-mm') finishmonth from selectitem a,(select e.requestid,e.dsporder,e.contractno,e.jztaskid,e.taskid,e.process,e.remark,e.processid,f.FINISH1,e.FINISHDATE,e.STATUS from uf_income_pcprocess e,edo_task f  where e.taskid=f.requestid(+)  and e.jztaskid='"+id+"'  and f.parenttaskuid(+)='"+id+"'  and f.model(+)='2c91a84e2aa7236b012aa737d8930006' ) b where  nvl(a.col1,0)=0 and a.id=b.processid(+) and typeid='2c91a0302aa6def0012aad4792cf0838' order by dsporder");
		//and (to_char(to_date(e.FINISHDATE,'yyyy-mm-dd'),'yyyy-mm')<='"+thismonth+"'
		double lastfinish=0;
		double thisfinish=0;
		double nextfinish=0;
		double allfinish=0;
		String realfinish="";
		String thisjd="";
		for(int j=0,sizej=jdlist.size();j<sizej;j++)
		{
			Map prm = (Map)jdlist.get(j);
			String ida=StringHelper.null2String(prm.get("id"));
			String objnamea=StringHelper.null2String(prm.get("objname"));
			String dspordera=StringHelper.null2String(prm.get("dsporder"));
			String taskida=StringHelper.null2String(prm.get("taskid"));
			String jztaskida=StringHelper.null2String(prm.get("jztaskid"));
			String finisha=StringHelper.null2String(prm.get("FINISH1"));
			String INDENTFINISHDATE=StringHelper.null2String(prm.get("INDENTFINISHDATE"));
			String statusa=StringHelper.null2String(prm.get("STATUS"));
			String planmontha=StringHelper.null2String(prm.get("planmonth"));
			String finishmontha=StringHelper.null2String(prm.get("finishmonth"));
			String process=StringHelper.null2String(prm.get("process"));
			if(finishmontha.length()>0&&finishmontha.compareToIgnoreCase(thismonth)<0)
			{
				lastfinish=Double.valueOf(process);
				thisjd=ida;
				if(lastfinish>=99)realfinish=INDENTFINISHDATE;
				allfinish=lastfinish;
				//nextfinish=Double.valueOf(process);
			}
			if(finishmontha.length()>0&&finishmontha.compareToIgnoreCase(thismonth)==0)
			{
				thisfinish=Double.valueOf(process);
				thisjd=ida;
				if(lastfinish>=99)realfinish=INDENTFINISHDATE;
				//nextfinish=Double.valueOf(process);
			}
			if(planmontha.length()>0&&nextmonth.compareToIgnoreCase(planmontha)==0)
			{
				nextfinish=Double.valueOf(process);
			}
		}
		if(thisfinish>0)
		{
			allfinish=thisfinish;
			thisfinish=thisfinish-lastfinish;
		}

		if(nextfinish>0)
			nextfinish=nextfinish-allfinish;
		String bgcolor=" bgcolor=\"#FEF7FF\"";
		String bgcolor1=" bgcolor=\"#FEF7FF\"";
		if(allfinish==0)
		{
			bgcolor1=" bgcolor=\""+color2+"\"";
		}
		/*if(mtstate.equals("2c91a0302aa6def0012aad567a4c084e"))
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
		}*/
		buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		if(!contractno2.equals(requestid))
		{
			contractno2=requestid;
			int rownum = 0;
			int addrownum=1;
			for(int k=i+1;k<size;k++)
			{
				Map m2 = (Map)jzlist.get(k);
				String contractno3=StringHelper.null2String(m2.get("requestid"));
				if(contractno3.equals(contractno2))
				{
					rownum=rownum+1;
				}
				else
					break;
			}
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+contractno+"</td>");
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+name+"</td>");
			buf1.append("<td align=\"right\" rowspan="+(rownum+addrownum)+">"+NumberHelper.moneyAddComma(money)+"</td>");
			sum1=sum1+Double.valueOf(money);
		}
		buf1.append("<td align=\"center\" "+bgcolor1+">"+getBrowserDicValue("edo_task","requestid","objname",requestida)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(produceqty)+"</td>");

		buf1.append("<td align=\"center\">"+getSelectDicValue(thisjd)+"</td>");
		buf1.append("<td align=\"center\">"+finish1+"</td>");
		buf1.append("<td align=\"center\">"+realfinish+"</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(allfinish)+"%</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(thisfinish)+"%</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(nextfinish)+"%</td>");
		buf1.append("<td align=\"left\">"+remark+"</td>");
		buf1.append("</tr>");
		sum2=sum2+Double.valueOf(produceqty)*Double.valueOf(allfinish)/100.0;
		sum3+=Double.valueOf(produceqty)*Double.valueOf(thisfinish)/100.0;
		sum4+=Double.valueOf(produceqty)*Double.valueOf(nextfinish)/100.0;
		sum5+=Double.valueOf(produceqty);
		
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"1\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")+"</b></td>");//合计
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum1)+"</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum5)+"</b></td>");
	buf1.append("<td colspan=\"2\"  align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001d")+"</b></td>");//完成
	buf1.append("<td colspan=\"2\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum2)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum3)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum4)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"center\"><b>&nbsp;</b></td>");
	buf1.append("</tr>");
out.println(buf1.toString());

%>
</tbody>
</table>
<!-- <ul>说明：
<li>&nbsp;&nbsp;&nbsp;&nbsp;<span style="background:<%=color1%>;width:40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>	表示机组调试工作处于停顿状态或停机保养状态</li><br>
<li>&nbsp;&nbsp;&nbsp;&nbsp;<span style="background:<%=color2%>;width:40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>	表示机组调试工作还未开展</li><br>			
<li>&nbsp;&nbsp;&nbsp;&nbsp;<span style="background:<%=color3%>;width:40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>	表示机组完成了调试工作 </li>
</ul> -->
</form>
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
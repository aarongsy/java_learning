<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%
	EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
	String userid=eweaveruser1.getId();
	Calendar cal = Calendar.getInstance(); 
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH)+1;
	month=month-1;
	if(month<1){
		month=12;
		year=year-1;
	}
	String nf = request.getParameter("nf");
	String yf = request.getParameter("yf");
	String action = StringHelper.null2String(request.getParameter("action"));

	if(yf==null)yf=String.valueOf(month);
	month=Integer.valueOf(yf);

	if(yf.length()<2)yf="0"+yf;
	if(nf==null)nf=String.valueOf(year);
	String startdate=nf+"-"+yf+"-01";
	String yearmonth = nf+'-'+yf;

	DataService ds = new DataService();
	List selectData=null;
	String tempstr="";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	double baseline=0.0d;
	String baselineSql = "select objdesc from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+nf+"'";
	List baselineData = baseJdbc.executeSqlForList(baselineSql);
	if(baselineData!=null && !baselineData.isEmpty()){
		baseline = Double.valueOf(((Map<String,Object>)baselineData.get(0)).get("objdesc").toString());
	}
	//String where1 = " and c.state not in('2c91a0302a8cef72012a8eabe0e803f2','2c91a0302ab11213012ab12bf0f00021') and "
	//			+"((c.state<>'2c91a0302a8cef72012a8eabe0e803f3') or ( c.state='2c91a0302a8cef72012a8eabe0e803f3' and to_char(to_date(c.finishdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"')) ";
	//String where1 = " and c.state not in('2c91a0302ab11213012ab12bf0f00021') and "
	//			+"((c.state<>'2c91a0302a8cef72012a8eabe0e803f3') or ( c.state='2c91a0302a8cef72012a8eabe0e803f3' and to_char(to_date(c.finishdate,'yyyy-mm-dd'),'yyyy-mm')='"+yearmonth+"')) ";
	/*String sql = " select c.requestid as contractid,a.requestid,a.projectno,a.projectname,nvl(a.projectsum,0) projectsum,"
				+"  	a.state mtstate,a.process,a.remark,a.planend,a.realend,a.manager,c.no,c.name,c.money,c.predictdate,c.implementdate,c.finishdate"
				+" from  uf_contract c"
				+"		left join uf_income_projectgx a on a.contractno=c.requestid"
				+" 		inner join uf_contract_dist d on d.requestid=c.requestid and d.orgid='2c91a0302a87f19c012a8979573b0012' and d.distsum>="+baseline
				//+" 		inner join selectitem b on substr(c.registerdate,1,4)=b.objname and b.typeid='402882a92f493155012f497b10a0003d' and d.distsum>=b.objdesc"
				+" where c.classes='2c91a0302a8cef72012a8ea9390903c6'"+where1
				+" order by c.no";
	String sql = " select c.requestid as contractid,a.requestid,a.projectno,a.projectname,nvl(a.projectsum,0) projectsum,"
				+"  	a.state mtstate,a.process,a.remark,a.planend,a.realend,a.manager,c.no,c.name,c.money,c.predictdate,c.implementdate,c.finishdate"
				+" from  uf_contract c,uf_income_projectgx a,uf_contract_dist d where  a.contractno=c.requestid  and d.requestid=c.requestid and d.orgid='2c91a0302a87f19c012a8979573b0012'  and  c.classes='2c91a0302a8cef72012a8ea9390903c6'   and d.distsum>="+baseline +" "+where1+" order by c.no,a.projectname";*/
	String where1 = " and c.state not in('2c91a0302ab11213012ab12bf0f00021') and (c.state not in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') or ( c.state in ('2c91a0302a8cef72012a8eabe0e803f2'))) ";
	String sql = " select c.requestid as contractid,c.money projectsum,"
				+"  	c.state mtstate,c.predictdate planend,d.remark,c.implementdate realend,c.no,c.name,c.money,c.predictdate,c.implementdate,c.finishdate"
				+" from  uf_contract c,uf_contract_dist d where d.requestid=c.requestid and d.orgid='2c91a0302a87f19c012a8979573b0012'  and  c.classes='2c91a0302a8cef72012a8ea9390903c6' "+where1+"  and d.distsum>="+baseline+"  order by c.no";
	List proData= baseJdbc.executeSqlForList(sql);
	int size=proData.size();


	boolean isExcel;
	if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
		String excel=StringHelper.null2String(request.getParameter("exportType"));
		isExcel=excel.equalsIgnoreCase("excel");
		pageContext.setAttribute("isExcel",isExcel);
		if(isExcel){//导出EXCEL
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
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7180067") %><!-- 高新项目进度报表 --></title>
	<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
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
var dlg0=null;
Ext.onReady(function(){
	var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>','S','accept',function(){onSearch()});//确定
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7180068") %>','V','accept',setContractBaseLine);//设置合同金额基准线
	topBar.render('pagemenubar');
	topBar.addSeparator();
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
			autoScroll:true,
			height:60,
			collapseMode:'mini'
		},{
			contentEl:'repContainer',
			autoScroll:true,
			region:'center'
		}]
	});
	dlg0 = new Ext.Window({
		layout:'border',
		closeAction:'hide',
		plain: true,
		modal :true,
		width:viewport.getSize().width*0.8,
		height:viewport.getSize().height*0.8,
		/*buttons: [{
		    text     : '提交',
		    handler  : function(){
			dlg0.getComponent('dlgpanel').iframe.getDocument().BaselineForm.submit();
		    }},{
		    text     : '关闭',
		    handler  : function(){
		        dlg0.hide();
		    }
		}],*/
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
	dlg0.on('hide', function(){
		this.getComponent('dlgpanel').setSrc('about:blank');
	});
	
});
function setContractBaseLine(){
	openchild('/app/ft/ContractBaseLine.jsp');
}
function openchild(url){
  dlg0.getComponent('dlgpanel').setSrc(""+url);
  dlg0.show();
}
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
<form action="/app/ft/gxsumReport.jsp" name="formExport" method="post">
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
			if(i==Integer.valueOf(nf))
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
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --><%=yf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7180067") %><!-- 高新项目进度报表 --></CENTER></div> 
<div align=left width="50%"></div><div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001e") %><!-- 单位(元) --></div> 
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="120" />
	<col width="180" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="100" />
	<col width="80" />
	<col width="80" />
	<col width="150" />
  </colgroup>			

   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150051") %><!-- 合同金额 --></td>
			<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec716005b") %><!-- 项目金额 --></td>
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402881e80c7765f6010c78225e400052") %><!-- 项目状态 --></td>
			<td colspan="2" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7180069") %><!-- 项目完成 --></td>	
			<td colspan="3" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec718006a") %><!-- 完成百分比 --></td>	
			<td colspan="1" rowspan="2" align="center"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e") %><!-- 说明 --></td>		
  </tr>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec718006b") %><!-- 预计 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006c") %><!-- 实际 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170061") %><!-- 项目总进度 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006d") %><!-- 本月完成 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006e") %><!-- 预计下月完成 --></td>			
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
	double sum6=0.0;
	String contractno2="";
	for(int i=0;i<size;i++)
	{
		Map m = (Map)proData.get(i);
		String contractno=StringHelper.null2String(m.get("no"));
		String name=StringHelper.null2String(m.get("name"));
		String projectno=StringHelper.null2String(m.get("no"));
		String projectname=StringHelper.null2String(m.get("name"));
		String taskno=StringHelper.null2String(m.get("projectno"));
		String mtstate=StringHelper.null2String(m.get("mtstate"));
		String projectsum =StringHelper.null2String(m.get("projectsum"));
		String process=StringHelper.null2String(m.get("process"));
		process = StringHelper.isEmpty(process)?"0":process;
		String planend=StringHelper.null2String(m.get("planend"));
		String realend=StringHelper.null2String(m.get("realend"));
		String manager=StringHelper.null2String(m.get("manager"));

		String remark=StringHelper.null2String(m.get("remark"));
		String money=StringHelper.null2String(m.get("money"));
		String finishdate=StringHelper.null2String(m.get("finishdate"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String contractid=StringHelper.null2String(m.get("contractid"));


		double theworks=0.0;
		double thisworks=0.0;
		double allworks=0;
		double yearworks=0;
		double nextworks=0.0;
		String subrequestid="";
		sql="select requestid,yearmonth,projectRequestId,contractno,nvl(theworks,0) theworks,nvl(yearworks,0) yearworks,nvl(thisworks,0) thisworks,nvl(allworks,1) allworks,nvl(nextworks,0) nextworks from uf_income_prjgxprocess where contractno='"+contractid+"' and yearmonth='"+yearmonth+"'";
		List processdata= baseJdbc.executeSqlForList(sql);
		for(int j=0,size1=processdata.size();j<size1;j++)
		{
				Map m2 = (Map)processdata.get(j);
				String contractid1=StringHelper.null2String(m2.get("contractno"));
				if(contractid.equals(contractid1))
				{
					theworks=Double.valueOf(StringHelper.null2String(m2.get("theworks")));
					allworks=Double.valueOf(StringHelper.null2String(m2.get("allworks")));
					yearworks=Double.valueOf(StringHelper.null2String(m2.get("yearworks")));
					thisworks=Double.valueOf(StringHelper.null2String(m2.get("thisworks")));
					nextworks=Double.valueOf(StringHelper.null2String(m2.get("nextworks")));
					subrequestid = StringHelper.null2String(m2.get("requestid"));
					break;
				}
		}
		//取本年总进度和项目进度
		String sql1="select  nvl(sum(theworks),0) yearworks from uf_income_prjgxprocess where contractno ='"+contractid+"' and yearmonth<='"+yearmonth+"'  and yearmonth>='"+year+"'";
		List lastprocessdata= baseJdbc.executeSqlForList(sql1);
		if(lastprocessdata.size()>0)
		{
		  Map m3 = (Map)lastprocessdata.get(0);
			yearworks=Double.valueOf(StringHelper.null2String(m3.get("yearworks")));
		
		}
		sql1="select  nvl(sum(theworks),0) allworks from uf_income_prjgxprocess where contractno ='"+contractid+"' and yearmonth<='"+yearmonth+"'";
		lastprocessdata= baseJdbc.executeSqlForList(sql1);
		if(lastprocessdata.size()>0)
		{
		  Map m3 = (Map)lastprocessdata.get(0);
			allworks=Double.valueOf(StringHelper.null2String(m3.get("allworks")));
		}
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
			int rownum = 0;
			int addrownum=0;
			for(int k=i+1;k<size;k++)
			{
				Map m2 = (Map)proData.get(k);
				String contractno3=StringHelper.null2String(m2.get("no"));
				if(contractno3.equals(contractno2))
				{
					rownum=rownum+1;
				}
				else
					break;
			}
			String url="";
			url="/workflow/request/formbase.jsp?requestid="+StringHelper.null2String(m.get("contractid"));
			/*if(StringHelper.isEmpty(requestid)){
				url="/workflow/request/formbase.jsp?categoryid=2c91a0302ac122a2012ac1dd47ea02f7&projectRequestId="+StringHelper.null2String(m.get("contractid"));
			}else{
				url="/workflow/request/formbase.jsp?requestid="+subrequestid
					+"&yearmonth="+nf+"-"+yf+"&contractno="+StringHelper.null2String(m.get("contractid"))+"&projectid="+
					taskno+"&projectRequestId="+requestid+"&categoryid=2c91a0302ac122a2012ac1dd85be02f8&process="+process;
			}*/
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+"><a href=javascript:openchild('"+url+"')>"+contractno+"</a></td>");
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+"><a href=javascript:openchild('"+url+"')>"+name+"</a></td>");
			buf1.append("<td align=\"right\" rowspan="+(rownum+addrownum)+">"+NumberHelper.moneyAddComma(money)+"</td>");
			sum1=sum1+Double.valueOf(money);
		}
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(projectsum)+"</td>");
		buf1.append("<td align=\"right\">"+getSelectDicValue(mtstate)+"</td>");
		buf1.append("<td align=\"center\">"+planend+"</td>");
		buf1.append("<td align=\"center\">"+realend+"</td>");
		
		//buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(Double.valueOf(thisworks)/Double.valueOf(allworks)*100.0)+"</td>");
		buf1.append("<td align=\"center\">"+progress(String.valueOf(Double.valueOf(allworks)))+"</td>");
		buf1.append("<td align=\"center\">"+theworks+"%</td>");
		buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(Double.valueOf(nextworks))+"%</td>");
		buf1.append("<td align=\"left\">"+remark+"</td>");
		buf1.append("</tr>");
		sum3+=Double.valueOf(nextworks)*Double.valueOf(projectsum)/100;
		sum4+=Double.valueOf(theworks)*Double.valueOf(projectsum)/100;
		sum5+=Double.valueOf(allworks)*Double.valueOf(projectsum)/100;
		sum6+=Double.valueOf(yearworks)*Double.valueOf(projectsum)/100;
		
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"7\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")+"("+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec719006f")+" "+size+" "+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003e")+")</b></td>");//合计   共    项
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum5)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum4)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+NumberHelper.moneyAddComma(sum3)+"</b></td>");
	buf1.append("<td colspan=\"1\"  align=\"center\"><b>"+NumberHelper.moneyAddComma(sum6)+"</b></td>");
	buf1.append("</tr>");
out.println(buf1.toString());

%>
</tbody>
</table>
</form>
</div>
<c:if test="${!isExcel}">
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
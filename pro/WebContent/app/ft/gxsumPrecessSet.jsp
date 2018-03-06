<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>

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
	String submitaction = StringHelper.null2String(request.getParameter("submitaction"));

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


	if(submitaction!=null&&submitaction.equals("submit"))
	{
		
			//从表
			String[] contractnos=request.getParameterValues("contractno");//合同id
			String[] projectids=request.getParameterValues("projectid");//项目id
			String[] theworks=request.getParameterValues("theworks");//本月完成
			String[] nextworks=request.getParameterValues("nextworks");//预计下月完成
			String[] thisworks=request.getParameterValues("thisworks");//截止本月工作量
			String[] yearworks=request.getParameterValues("yearworks");//本年完成
			String[] allworks=request.getParameterValues("allworks");//项目总进度
			String[] remarks=request.getParameterValues("remark");//预计下月完成
			if(projectids!=null){
				List<String> sqlList =new ArrayList<String>();
				for(int i=0;i<projectids.length;i++)
				{
					if(projectids[i].length()<1)projectids[i]="null";
					List templist=baseJdbc.executeSqlForList("select requestid from uf_income_prjgxprocess  where contractno='"+contractnos[i]+"' and yearmonth='"+yearmonth+"'");
					if(thisworks[i].trim().length()<1)thisworks[i]="0.0";
					if(theworks[i].trim().length()<1)theworks[i]="0.0";
					if(nextworks[i].trim().length()<1)nextworks[i]="0.0";
					if(yearworks[i].trim().length()<1)yearworks[i]="0.0";
					if(allworks[i].trim().length()<1)allworks[i]="0.0";
					if(templist.size()>0)
					{
						sqlList.add("update uf_income_prjgxprocess set theworks="+theworks[i]+",nextworks="+nextworks[i]+",thisworks="+thisworks[i]+",yearworks="+yearworks[i]+",allworks="+allworks[i]+",remark='"+StringHelper.filterSqlChar(remarks[i])+"' where yearmonth='"+yearmonth+"' and contractno='"+contractnos[i]+"'");
					}
					else
					{	
						//yearmonth,contractno,projectRequestId,theworks,yearworks,nextworks,remark,allworks
						sqlList.add("insert into uf_income_prjgxprocess(id,requestid,yearmonth,contractno,theworks,nextworks,allworks,yearworks,thisworks,remark) values " +
						"('"+IDGernerator.getUnquieID()+"','"+IDGernerator.getUnquieID()+"','"+yearmonth+"','"+contractnos[i]+"','"+theworks[i]+"','"+nextworks[i]+"','"+allworks[i]+"','"+yearworks[i]+"','"+thisworks[i]+"','"+StringHelper.filterSqlChar(remarks[i])+"')");
					}	
				}
				if(sqlList.size()>0)
				{
					JdbcTemplate jdbcTemp=baseJdbc.getJdbcTemplate();
					PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
					DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
					TransactionStatus status=tm.getTransaction(def); 
					try{ 
						jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
						tm.commit(status);
					}catch(DataAccessException ex){
						tm.rollback(status);
						throw ex;
					}
				}
			}
			//String url=request.getContextPath()+"/app/ft/pcSetPorgress.jsp?projectid="+projectid;
			//response.sendRedirect(url);
			//return;
	}
	double baseline=0.0d;
	String baselineSql = "select objdesc from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+nf+"'";
	List baselineData = baseJdbc.executeSqlForList(baselineSql);
	if(baselineData!=null && !baselineData.isEmpty()){
		baseline = Double.valueOf(((Map<String,Object>)baselineData.get(0)).get("objdesc").toString());
	}

	String where1 = " and c.state not in('2c91a0302ab11213012ab12bf0f00021') and "
				+"(c.state not in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') or ( c.state in ('2c91a0302a8cef72012a8eabe0e803f3','2c91a0302a8cef72012a8eabe0e803f2') and to_char(to_date(d.implementdate,'yyyy-mm-dd'),'yyyy-mm')>='"+yearmonth+"')) ";
	String sql = " select c.requestid as contractid,nvl(d.distsum,0) projectsum,"
				+"  	c.state mtstate,c.predictdate planend,d.remark,c.implementdate realend,c.no,c.name,c.money,c.predictdate,c.implementdate,c.finishdate"
				+" from  uf_contract c,uf_contract_dist d where d.requestid=c.requestid and d.orgid='2c91a0302a87f19c012a8979573b0012'  and  c.classes='2c91a0302a8cef72012a8ea9390903c6' "+where1+" and (select  nvl(sum(theworks),0) allworks from uf_income_prjgxprocess where contractno =c.requestid and yearmonth<'"+yearmonth+"')<=100 and d.distsum>="+baseline+" order by c.no";
	List proData= baseJdbc.executeSqlForList(sql);
	int size=proData.size();



%>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160059") %><!-- 高新项目进度设置 --></title>
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023") %>','S','accept',function(){onSubmit()});//保存
	topBar.addSeparator();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec716005a") %>','S','accept',function(){onNew()});//新建项目
	topBar.addSeparator();
	topBar.addSpacer();
	topBar.addSeparator();
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.forms[0].action= document.forms[0].action+location.href.substring(idx);
	var viewport = new Ext.Viewport({
		layout: 'border',
		items: [{
		contentEl:'repContainer',
		split:true,
		region:'center',         
			autoScroll:true,
			collapseMode:'mini'
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
function onNew()
{
	openchild('/workflow/request/formbase.jsp?categoryid=2c91a0302ac122a2012ac1dd47ea02f7');
	
}
function setContractBaseLine(){
	openchild('/app/ft/ContractBaseLine.jsp');
}
function openchild(url){
  dlg0.getComponent('dlgpanel').setSrc(""+url);
  dlg0.show();
}
function onSearch(){
	document.getElementById('exportType').value="";
	document.getElementById('submitaction').value="search";
	if(checkIsNull())
		document.forms[0].submit();
}
function onSubmit(){
	document.getElementById('exportType').value="";
	document.getElementById('submitaction').value="submit";
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
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000") %>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}

</script>
</head>

<body>

<div id='repContainer'>
<div id="pagemenubar"></div>
<form action="" name="formExport" method="post">
<input type="hidden" name="submitaction" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
		<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0002") %><!-- 年月 --> </td>
		<td class="FieldValue" nowrap="true">
		<span><select name="nf" id="nf" style="width:80" onchange="javascript:onSearch();">
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
		<select name="yf" id="yf" style="width:80" onchange="javascript:onSearch();">
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
<BR>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --><%=yf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160059") %><!-- 高新项目进度设置 --></CENTER></div> 
<div align=left width="50%"></div><div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001e") %><!-- 单位(元) --></div> 
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="100" />
	<col width="150" />
	<col width="160" />
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
		<!--<td colspan="1" align="center" rowspan="1" >合同名称</td>-->
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e80c770b5e010c7737d4e00015") %><!-- 项目名称 --></td>
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec716005b") %><!-- 项目金额 -->/<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150051") %><!-- 合同金额 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e80c7765f6010c78225e400052") %><!-- 项目状态 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800067") %><!-- 计划完成 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec716005c") %><!-- 实际完成 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec716005d") %><!-- 截止本月完成 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec717005e") %><!-- 其中本年完成 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec717005f") %><!-- 本月完成 --></td>	
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170060") %><!-- 下月预计完 --></td>
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170061") %><!-- 项目总进度 --></td>	
			
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e") %><!-- 说明 --></td>		
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
	for(int i=0;i<size;i++)
	{
		Map m = (Map)proData.get(i);
		String contractno=StringHelper.null2String(m.get("no"));
		String projectname=StringHelper.null2String(m.get("name"));
		String projectno=StringHelper.null2String(m.get("no"));
		String contractid=StringHelper.null2String(m.get("contractid"));
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
		String requestid=StringHelper.null2String(m.get("requestid"));
		double theworks=0.0;//本月完成进度
		double thisworks=0.0;//上月完成进度
		double allworks=0;//总进度  process期初进度
		double nextworks=0.0;//下月完成进度
		double yearworks=0.0;//本年完成进度 
		String subrequestid="";
		String sql1="select requestid,yearmonth,projectRequestId,contractno,nvl(theworks,0) theworks,nvl(thisworks,0) thisworks,nvl(allworks,1) allworks,nvl(yearworks,0) yearworks,nvl(nextworks,0) nextworks from uf_income_prjgxprocess where contractno='"+contractid+"' and yearmonth='"+yearmonth+"'";
		List processdata= baseJdbc.executeSqlForList(sql1);
		for(int j=0,size1=processdata.size();j<size1;j++)
		{
				Map m2 = (Map)processdata.get(j);
				String contractid1=StringHelper.null2String(m2.get("contractno"));
				
				if(contractid.equals(contractid1))
				{
					theworks=Double.valueOf(StringHelper.null2String(m2.get("theworks")));
					allworks=Double.valueOf(StringHelper.null2String(m2.get("allworks")));
					thisworks=Double.valueOf(StringHelper.null2String(m2.get("thisworks")));
					nextworks=Double.valueOf(StringHelper.null2String(m2.get("nextworks")));
					yearworks=Double.valueOf(StringHelper.null2String(m2.get("yearworks")));
					subrequestid = StringHelper.null2String(m2.get("requestid"));
					break;
				}
			
		}
		//取本年总进度和项目进度
		sql1="select  nvl(sum(theworks),0) yearworks from uf_income_prjgxprocess where contractno ='"+contractid+"' and yearmonth<'"+yearmonth+"'  and yearmonth>='"+year+"'";
		List lastprocessdata= baseJdbc.executeSqlForList(sql1);
		if(lastprocessdata.size()>0)
		{
		  Map m3 = (Map)lastprocessdata.get(0);
			yearworks=Double.valueOf(StringHelper.null2String(m3.get("yearworks")));
		
		}
		sql1="select  nvl(sum(theworks),0) allworks from uf_income_prjgxprocess where contractno ='"+contractid+"' and yearmonth<'"+yearmonth+"'";
		lastprocessdata= baseJdbc.executeSqlForList(sql1);
		if(lastprocessdata.size()>0)
		{
		  Map m3 = (Map)lastprocessdata.get(0);
			thisworks=Double.valueOf(StringHelper.null2String(m3.get("allworks")));
		
		}
		allworks=thisworks+theworks;
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
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+"><a href=javascript:openchild('/workflow/request/formbase.jsp?requestid="+contractid+"')>"+contractno+"</a></td>");
			//buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+name+"</td>");
		}
		buf1.append("<td align=\"center\" "+bgcolor1+"><a href=javascript:openchild('/workflow/request/formbase.jsp?requestid="+contractid+"')>"+projectname+"</a> <input type=hidden value=\""+requestid+"\" name=\"projectid\"> <input type=hidden value=\""+contractid+"\" name=\"contractno\"></td>");
		buf1.append("<td align=\"right\" nowrap>"+ NumberHelper.moneyAddComma(projectsum) +" / "+NumberHelper.moneyAddComma(money)+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(mtstate)+"</td>");
		buf1.append("<td align=\"center\">"+planend+"</td>");
		buf1.append("<td align=\"center\">"+realend+"</td>");
		buf1.append("<td align=\"center\"><input type=\"hidden\" class=\"InputStyle2\" name=\"thisworks\"  id=\"thisworks\" value=\""+thisworks+"\"  style='width: 80%'   onblur=\"fieldcheck(this,'^(-?\\\\d+)(\\\\.\\\\d+)?$','"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170062")+"')\" readonly>"+thisworks+"%</td>");//截止上月完成
		buf1.append("<td align=\"center\"><input type=\"hidden\" class=\"InputStyle2\" name=\"yearworks\"  id=\"yearworks\" value=\""+yearworks+"\"  style='width: 80%'   onblur=\"fieldcheck(this,'^(-?\\\\d+)(\\\\.\\\\d+)?$','"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec717005e")+"')\" readonly>"+yearworks+"%</td>");//其中本年完成
		buf1.append("<td align=\"center\"><input type=\"text\" class=\"InputStyle2\" name=\"theworks\"  id=\"theworks\" value=\""+theworks+"\"  style='width: 80%'   onblur=\"fieldcheck(this,'^(-?\\\\d+)(\\\\.\\\\d+)?$','"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170063")+"');sumall(this);\" >%</td>");//本月完成
		buf1.append("<td align=\"center\"><input type=\"text\" class=\"InputStyle2\" name=\"nextworks\"  id=\"nextworks\" value=\""+nextworks+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?\\\\d+)(\\\\.\\\\d+)?$','"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170064")+"')\">%</td>");//下月预计完成

		buf1.append("<td align=\"center\"><input type=\"text\" class=\"InputStyle2\" name=\"allworks\"  id=\"allworks\" value=\""+allworks+"\"  style='width: 80%'   onblur=\"fieldcheck(this,'^(-?\\\\d+)(\\\\.\\\\d+)?$','"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7170065")+"')\" readonly>%</td>");//项目总完成
		
		buf1.append("<td align=\"center\"><input type=\"text\" class=\"InputStyle2\" name=\"remark\"  id=\"remark\" value=\""+remark+"\"  style='width: 80%' ></td>");

		buf1.append("</tr>");
	}
	out.println(buf1.toString());

%>
</tbody>
</table>
</form>
</div>
</body>
</html>

<script type="text/javascript">
function sumall(obj)
{
	var theworks= document.getElementsByName("theworks");
	var thisworks= document.getElementsByName("thisworks");
	var allworks= document.getElementsByName("allworks");
	var idx=0;
	for(var i=0,len=theworks.length;i<len;i++)
	{
		if(theworks[i]==obj)
		{
		   idx=i;
		}
	}
	var allworksnum=0.0;
	if(theworks[idx].value.length>0)
		allworksnum=parseFloat(theworks[idx].value)+parseFloat(thisworks[idx].value);
	if(allworksnum>100)
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7180066") %>");//完成进度不能超过范围！[已完成 + 本月完成]最大值为100!
		theworks[idx].focus();
		return;
	}
	allworks[idx].value=allworksnum;


}
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

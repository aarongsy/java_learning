<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp" %>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String czbm1=eweaveruser1.getOrgid();
Calendar cal = Calendar.getInstance(); 
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH);
String startdate="";
if(month<1)
	startdate= (year-1)+"-12-01";
else
{
	if(month<10)
		startdate= year+"-0"+(month)+"-01";
	else
		startdate= year+"-"+(month)+"-01";
}
String csdatebeg = request.getParameter("csdatebeg");
if(csdatebeg==null) csdatebeg=startdate;
String csdateend = request.getParameter("csdateend");
if(csdateend==null) csdateend="";
String namecnd = request.getParameter("namecnd");
if(namecnd==null) namecnd="";
String orgunitcnd = request.getParameter("orgunitcnd");
if(orgunitcnd==null) orgunitcnd="";
String hosttypepcnd = request.getParameter("hosttypepcnd");
if(hosttypepcnd==null) hosttypepcnd="";
String dodeptcnd = request.getParameter("dodeptcnd");
if(dodeptcnd==null) dodeptcnd="";
String nocnd = request.getParameter("nocnd");
if(nocnd==null) nocnd="";
String statecnd = request.getParameter("statecnd");
if(statecnd==null) statecnd="";
 
String where="";
/*if(monthcnd.length()>0)
{
	where = where +" and to_char(to_date(nvl((select max(finidate) finidate from uf_pc_prjev where prjid=b.requestid),b.yjfrq),'yyyy-mm-dd'),'yyyy-mm')<='"+yearcnd+"-"+monthcnd+"'";
}*/
if(csdatebeg.length()>0)
{
	where = where +" and a.csdate>='"+csdatebeg+"'";
}
if(csdateend.length()>0)
{
	where = where +" and a.csdate<='"+csdateend+"'";
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
if(statecnd.length()>0)
{
	where = where +" and a.state='"+statecnd+"'";
}
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select b.* from (select a.requestid,a.no,a.name,a.totalno,a.classes,a.hosttypep,a.divideclasses,a.orgunit,a.pjprincipal,a.customercoding,a.money,a.csdate,a.csman,a.implementdate,a.predictbgdate,a.predictdate,a.state,a.remark3,nvl((select count(id) from edo_task t where model='2c91a84e2aa7236b012aa737d8930006' and projectid=a.requestid),0) tasknum,nvl((select count(id) from edo_task t where (status= '2c91a0302aa21947012aa232f1860011' or status= '2c91a0302aa21947012aa232f1860013' or status='2c91a0302aa21947012aa232f1860012')  and model='2c91a84e2aa7236b012aa737d8930006' and projectid=a.requestid),0) finishnum,nvl((select count(id) from edo_task t where status= '2c91a0302aa21947012aa232f1860012' and model='2c91a84e2aa7236b012aa737d8930006' and projectid=a.requestid),0) qzfinishnum,nvl((select count(*) from docbase where extrefobjfield7=a.requestid and isdelete=0),0) docnums from  uf_contract a where 1=1 "+where+" and a.classes='2c91a0302a8cef72012a8ea9390903c6') b  order by b.no";
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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006e") %><!-- 项目统计表 --></title>
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
			topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0059") %>','M','page_excel',exportAll);//导出全部
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.forms[0].action= document.forms[0].action+location.href.substring(idx);
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'seachdiv',
	split:true,
	region:'north',
/*	tbar:[{id:'search',text:'搜索(S)',key:'S',alt:true,
	iconCls:Ext.ux.iconMgr.getIcon('accept'),handler:btnAction},
	{id:'reset',text:'清空条件',key:'C',alt:true,
	iconCls:Ext.ux.iconMgr.getIcon('erase'),handler:btnAction}
 ],  */             
		autoScroll:true,
		height:80,
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
<form action="/app/ft/contractReport.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
		<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000") %><!-- 日期 --> </td>
		<TD class=FieldValue noWrap>
			<input type=text class=inputstyle readonly size=10 name="csdatebeg"  value="<%=csdatebeg%>" onclick="WdatePicker()">-<input type=text class=inputstyle size=10 readonly name="csdateend"  value="<%=csdateend%>" onclick="WdatePicker()">
		</TD>   
		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
		<td  class="FieldValue" width=15% nowrap>
			<input type=text class=inputstyle size=20 name="nocnd" value="<%=nocnd%>"/>
		</td>

		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
		<td  class="FieldValue" width=15% nowrap>
			<input type=text class=inputstyle size=20 name="namecnd" value="<%=namecnd%>"/>
		</td>
				</tr>
		<tr>
		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005d") %><!-- 合同类别 --></td>
		<td width=15% class='FieldValue'>
			<select style="width:120" class="inputstyle2" id="hosttypepcnd"  name="hosttypepcnd">
			<option value=""   ></option>
			<%
			selectData=ds.getValues("select id,objname from selectitem where typeid='2c91a0302a8cef72012a8ea97e5f03c9' and nvl(col1,0)=0 and isdelete=0 and pid is null order by dsporder");
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

     <td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019") %><!-- 状态 --></td>
     <td width=15% class='FieldValue'>
		<select style="width:120" class="inputstyle2" id="statecnd"  name="statecnd">
		<option value=""   ></option>
		<%
		 selectData=ds.getValues("select id,objname from selectitem where typeid='2c91a0302a8cef72012a8eab512b03d5' and nvl(col1,0)=0 and isdelete=0 and pid is null order by dsporder");
		tempstr=statecnd;
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
		<span> <BUTTON  type="button" class=Browser onclick="javascript:getrefobj('orgunitcnd','orgunitcndspan','402881e60bfee880010bff17101a000c','','','0');"></BUTTON> <INPUT type=hidden value="<%=orgunitcnd%>" name=orgunitcnd> <SPAN id=orgunitcndspan name="orgunitcndspan"><%=getBrowserDicValue("orgunit","id","objname",orgunitcnd)%></SPAN>
	</TD>
</tr>
</table>
<input type="hidden" id="toPageType" name="toPageType" value="">
<input type="hidden" id="pageNum" name="pageNum" value="<%=pageNum%>"></form>
</div>
<div id='repContainer'>
</c:if>
<!-- <div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER>项目统计表</CENTER><BR></div> -->
<CENTER>
<!-- <div align=left width="50%"></div>
<div align=right width="50%">单位(元)</div> -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:1200" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="100" />
	<col width="400" />
	<col width="250" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
	<col width="120" />
  </colgroup>																														
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:20;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800070") %><!-- 任务统计 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800071") %><!-- 文档统计 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004c") %><!-- 业务部门 --></td>
			<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881eb0ca0bb62010ca0ea40960008") %><!-- 负责人 --></td>
			<!-- <td colspan="1" align="center" rowspan="1" >实施部门</td> -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005e") %><!-- 合同状态 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800064") %><!-- 总金额 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800065") %><!-- 主类型 --></td>	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800066") %><!-- 分类型 --></td>
		
				
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
	String no=StringHelper.null2String(m.get("no"));
	String name=StringHelper.null2String(m.get("name"));
	String totalno=StringHelper.null2String(m.get("totalno"));
	String classes=StringHelper.null2String(m.get("classes"));
	String orgunit =StringHelper.null2String(m.get("orgunit"));
	String hosttypep=StringHelper.null2String(m.get("hosttypep"));
	String divideclasses=StringHelper.null2String(m.get("divideclasses"));
	String money=StringHelper.null2String(m.get("money"));
	String csdate=StringHelper.null2String(m.get("csdate"));
	String csman=StringHelper.null2String(m.get("csman"));
	String predictdate=StringHelper.null2String(m.get("predictdate"));
	String predictbgdate=StringHelper.null2String(m.get("predictbgdate"));
	String requestid=StringHelper.null2String(m.get("requestid"));
	String implementdate=StringHelper.null2String(m.get("implementdate"));
	int tasknum=Integer.parseInt(StringHelper.null2String(m.get("tasknum")));
	int finishnum=Integer.parseInt(StringHelper.null2String(m.get("finishnum")));
	int qzfinishnum=Integer.parseInt(StringHelper.null2String(m.get("qzfinishnum")));
	String pjprincipal=StringHelper.null2String(m.get("pjprincipal"));
	String dodept=StringHelper.null2String(m.get("dodept"));
	String state=StringHelper.null2String(m.get("state"));
	String docnums="<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isformbase=1&reportid=2c91a0302aeefaeb012aefff20da0166&con4028818411b2334e0111b233527701aa_value="+requestid+"','"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800072")+"');\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0037")+"<u>"+StringHelper.null2String(m.get("docnums"))+"</u>"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800073")+"</a>";//项目文档   共有    篇
	String notes=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800074")+":&nbsp;<a href=\"javascript:openchild('taskView.jsp?projectid="+requestid+"&sqlwhere=1=1');\"><u>"+tasknum+"</u></a>&nbsp;"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800075")+":&nbsp;<a href=\"javascript:openchild('taskView.jsp?projectid="+requestid+"&sqlwhere=status in  (\\'2c91a0302aa21947012aa232f1860011\\',\\'2c91a0302aa21947012aa232f1860013\\' ,\\'2c91a0302aa21947012aa232f1860012\\')');\"><u>"+(finishnum+qzfinishnum)+"</u></a>&nbsp; "+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800076")+":&nbsp;<a href=\"javascript:openchild('taskView.jsp?projectid="+requestid+"&sqlwhere=status=\\'2c91a0302aa21947012aa232f1860012\\'');\"><u>"+qzfinishnum+"</u></a>&nbsp;&nbsp;<a href=\"javascript:onUrl('/project/wbscheck.jsp?projectid=402881182b2ff4b1012b2ff4dc920001','"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800077")+"','tabcl402881182b2ff4b1012b2ff4dc920001'\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003b")+"</a>";
	String bgcolor="#FEF7FF";
	if(qzfinishnum>0)
	{
		bgcolor="#C6CAEC";
	}
	buf1.append("<tr style=\"height:20;\" bgcolor=\""+bgcolor+"\" >");
	buf1.append("<td align=\"left\">"+no+"</td>");
	buf1.append("<td align=\"left\"><a href=\"javascript:onUrl('/workflow/request/formbase.jsp?requestid="+requestid+"','"+name+"')\">"+name+"</td>");
	buf1.append("<td align=\"left\">"+notes+"</td>");
	//buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",csman)+"</td>");
	//buf1.append("<td align=\"center\">"+csdate+"</td>");
	buf1.append("<td align=\"center\">"+docnums+"</td>");
	buf1.append("<td align=\"center\">"+getBrowserDicValues("orgunit","id","objname",orgunit)+"</td>");
	buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",pjprincipal)+"</td>");
	//buf1.append("<td align=\"center\">"+getBrowserDicValues("orgunit","id","objname",dodept)+"</td>");
	buf1.append("<td align=\"center\">"+getSelectDicValue(state)+"</td>");
	buf1.append("<td align=\"center\">"+NumberHelper.moneyAddComma(money)+"</td>");
	buf1.append("<td align=\"center\">"+getSelectDicValue(hosttypep)+"</td>");
	buf1.append("<td align=\"center\">"+getSelectDicValue(divideclasses)+"</td>");
	
	//buf1.append("<td align=\"center\">"+predictdate+"</td>");
	//buf1.append("<td align=\"center\">"+implementdate+"</td>");
	
	
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
<a <%=pageno<=1?"":"href=\"javascript:toPage(2);\""%>><img src="/app/images/resultset_previous.gif" style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006a") %>"></a>&nbsp;&nbsp;&nbsp;</td><!-- 前页 -->
<td width="15%" align=center>
<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %><!-- 第 --> &nbsp;<input type="text" id="pageno" name="pageno" value="<%=pageno%>" size="1" style="height:16;font-size:11;text-align:center;padding-bottom:2px" onchange="javascript:toPage(5);" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %><!-- 页 -->&nbsp;/&nbsp;<%=totalPage%>
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

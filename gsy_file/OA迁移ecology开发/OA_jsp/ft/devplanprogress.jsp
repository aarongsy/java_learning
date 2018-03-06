<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String czbm1=eweaveruser1.getOrgid();
Calendar cal = Calendar.getInstance();
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
Humres humres = humresService.getHumresById(eweaveruser1.getId());
String yearcnd = StringHelper.null2String(request.getParameter("yearcnd"));
String statuscnd = StringHelper.null2String(request.getParameter("statuscnd"));
String where="1=1 ";
 	if(statuscnd.equals("2c91a0302bbcd476012c10d9f6043ed6"))
			where+=" and k.htsum>0";
	else if(statuscnd.equals("2c91a0302bbcd476012c10d9f6043ed7"))
			where+=" and k.isht is not null";
	else if(statuscnd.equals("ff8080812ee681d8012ee78fb4ab0001"))
			where+=" and k.ysh is not null";
/*if(statuscnd.length()>0)
{
	String[] statuscnds = statuscnd.split(",");
	String tempwhere="";
	for(int i=0,len=statuscnds.length;i<len;i++)
		tempwhere = tempwhere +" or a.statuscnd like '%"+statuscnd[i]+"%'";
	where=where +"(1=2 "tempwhere+")";
}*/
String action=StringHelper.null2String(request.getParameter("action"));
DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select k.requestid,k.theyear,k.planno,k.orgid,k.projectname,k.devicename,k.spec,k.nums,k.price,k.sums,k.reason,k.reqman,k.state,k.unit,k.htsum,k.fksum,k.isht,k.ysh from (select a.requestid,a.theyear,a.planno,a.orgid,a.projectname,a.devicename,a.spec,a.nums,a.price,a.sums,a.reason,a.reqman,a.state,a.unit,nvl((select pay from uf_ctr_bug_sub b where exists(select id from requestbase where isdelete=0 and id=b.requestid and  b.planno=a.requestid)),0.0) htsum,(select id from uf_ctr_bug_sub b where exists(select id from requestbase where isfinished=1 and id=b.requestid and  b.planno=a.requestid)) isht,nvl((select nvl((select sum(e.paysum) from uf_fn_payment e where  e.contractname=h.requestid),0.0)/10000*f.pay/g.ctrmoney from uf_ctr_bug_sub f,uf_ctr_income g,uf_contract h where  f.requestid=g.requestid and g.requestid=h.ctrflow and f.planno=a.requestid),0.0) fksum,(select  e.requestid from uf_device_putin_sub e,uf_device_equipment f  where e.devicename=f.requestid and f.planno=a.requestid and exists(select id from requestbase where isfinished=1 and id=e.requestid)) ysh  from  uf_fn_pcplan a where a.theyear = '"+yearcnd+"' and exists(select id from formbase where isdelete=0 and id=a.requestid) ) k where "+where+" order by k.planno";


//contractname,paysum   
//typeid=2c91a0302bbcd476012c10d9abcc3ed5
int pageNum=2000;
String pagenum=request.getParameter("pageNum");
if(pagenum!=null&&pagenum.length()>0)
	pageNum=Integer.parseInt(pagenum);
Page page1=baseJdbc.pagedQuery(sql, 1, pageNum);
int totalPage=page1.getTotalPageCount();
int totalNum =page1.getTotalSize();
if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="data.xls";
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
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004a") %><!-- 年度生产计划执行情况表 --></title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/app/js/report.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
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
var dlg0=null;
Ext.onReady(function(){

var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000") %>','S','accept',function(){onSearch()});//查询
	topBar.render('pagemenubar');
	topBar.addSpacer();
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
	split:false,
	region:'north',            
		autoScroll:false,
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
                height:viewport.getSize().height*0.6,
                buttons: [{
                    text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
                    handler  : function(){
                        dlg0.hide();
                        //onSearch();
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
<form action="" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" name="refresh" id="refresh" onclick="onSearch();"/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
	<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001") %><!-- 年度 --></td>
		<td width=15% class='FieldValue'>
		<select style="width:120" class="inputstyle2" id="yearcnd"  name="yearcnd">
		<option value=""   ></option>
		<%
		selectData=ds.getValues("select id,objname from selectitem where typeid='2c91a0302bbcd476012c0c330b2336e9'  and pid is null and nvl(col1,0)=0 and isdelete=0 order by dsporder");
		tempstr=yearcnd;
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
	<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800060") %><!-- 执行情况 --></td>
		<td width=15% class='FieldValue'>
		<select style="width:120" class="inputstyle2" id="statuscnd"  name="statuscnd">
		<option value=""   ></option>
		<%
		selectData=ds.getValues("select id,objname from selectitem where typeid='2c91a0302bbcd476012c10d9abcc3ed5'  and pid is null and nvl(col1,0)=0 and isdelete=0 order by dsporder");
		tempstr=statuscnd;
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
</tr>
</table>
</form>
</div>
<div id='repContainer'>
</c:if>
<CENTER><br>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=getSelectDicValue(yearcnd)%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004b") %><!-- 年度生产设备计划完成情况表 --></CENTER></div> 
<div align=left width="50%"></div><div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c000d") %><!-- 单位(万元) --></div> 
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:1300" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="120" />
	<col width="150" />
	<col width="120" />
	<col width="60" />
	<col width="60" />
	<col width="50" />
	<col width="80" />
	<col width="80" />
	<col width="80" />
		<col width="80" />
	<col width="80" />
	<col width="280" />
	<col width="80" />
	<col width="80" />
	</colgroup>																								
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:20;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881e80c770b5e010c7737d4e00015") %><!-- 项目名称 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004c") %><!-- 设备名称 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004d") %><!-- 规格型号 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004e") %><!-- 数量 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004f") %><!-- 单位 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150050") %><!-- 单价 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70b0005") %><!-- 金额 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150051") %><!-- 合同金额 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7150052") %><!-- 付款金额 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160053") %><!-- 付款比例 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160054") %><!-- 进度状况 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160055") %><!-- 申购原因及用途 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160056") %><!-- 项目负责人 --></td>
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004c") %><!-- 业务部门 --></td>
			

  </tr>
<tbody>
<%
StringBuffer buf1 = new StringBuffer();
if(totalNum>0)
{
	List listData=(List) page1.getResult();
	for(int i=0,size=listData.size();i<size;i++)
	{
		Map m = (Map)listData.get(i);
		String planno=StringHelper.null2String(m.get("planno"));
		String orgid=StringHelper.null2String(m.get("orgid"));
		String projectname=StringHelper.null2String(m.get("projectname"));
		String devicename=StringHelper.null2String(m.get("devicename"));
		String spec=StringHelper.null2String(m.get("spec"));
		String nums=StringHelper.null2String(m.get("nums"));
		String price=StringHelper.null2String(m.get("price"));
		String sums=StringHelper.null2String(m.get("sums"));
		String reason=StringHelper.null2String(m.get("reason"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String reqman=StringHelper.null2String(m.get("reqman"));
		String state=StringHelper.null2String(m.get("state"));
		String unit=StringHelper.null2String(m.get("unit"));
		String fksum=StringHelper.null2String(m.get("fksum"));
		String ysh=StringHelper.null2String(m.get("ysh"));
		String isht=StringHelper.null2String(m.get("isht"));
		String htsum=StringHelper.null2String(m.get("htsum"));
		
		if(htsum.length()>0&&Double.valueOf(htsum)>0)
			state="2c91a0302bbcd476012c10d9f6043ed6";
		if(isht.length()>0)
			state="2c91a0302bbcd476012c10d9f6043ed7";
		if(ysh.length()>0)
			state="ff8080812ee681d8012ee78fb4ab0001";
		buf1.append("<tr style=\"height:25;\" bgcolor=\""+getBrowserDicValue("selectitem","id","objdesc",state)+"\">");
		buf1.append("<td align=\"center\">"+projectname+"</td>");
		buf1.append("<td align=\"center\">"+devicename+"</td>");
		buf1.append("<td align=\"center\">"+spec+"</td>");
		buf1.append("<td align=\"center\">"+nums+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(unit)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(price)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(sums)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(htsum)+"</td>");
		buf1.append("<td align=\"right\">"+NumberHelper.moneyAddComma(fksum)+"</td>");
		buf1.append("<td align=\"left\">"+progress(String.valueOf(Math.round(Double.valueOf(fksum)/Double.valueOf(htsum)*10000)/100.0))+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(state)+"</td>");
		buf1.append("<td align=\"left\">"+reason+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",reqman)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("orgunit","id","objname",orgid)+"</td>");
		
		buf1.append("</tr>");
	}
	
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


<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String czbm1=eweaveruser1.getOrgid();
Calendar cal = Calendar.getInstance();
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
Humres currentuser1 = eweaveruser1.getHumres();
Humres humres = humresService.getHumresById(currentuser1.getId());
String finish1beg = StringHelper.null2String(request.getParameter("finish1beg"));
String finish1end = StringHelper.null2String(request.getParameter("finish1end"));
String tasknocnd = StringHelper.null2String(request.getParameter("tasknocnd"));
String objnamecnd = StringHelper.null2String(request.getParameter("objnamecnd"));
String officecnd = StringHelper.null2String(request.getParameter("officecnd"));
String statuscnd = StringHelper.null2String(request.getParameter("statuscnd"));
String principalcnd = StringHelper.null2String(request.getParameter("principalcnd"));
String subjectcnd = StringHelper.null2String(request.getParameter("subjectcnd"));
String tasknobcnd = StringHelper.null2String(request.getParameter("tasknobcnd"));
String where="and b.department = '"+humres.getExtrefobjfield10()+"'";
if(finish1beg.length()>0)
{
	where = where +" and b.finish1>='"+finish1beg+"'";
}
if(finish1end.length()>0)
{
	where = where +" and b.finish1<='"+finish1end+"'";
}
if(principalcnd.length()>0)
{
	where = where +" and b.principal = '"+principalcnd+"'";
}
if(tasknocnd .length()>0)
{
	where = where +" and b.taskno like '%"+StringHelper.filterSqlChar(tasknocnd)+"%'";
}
if(objnamecnd.length()>0)
{
	where = where +" and b.objname like '%"+StringHelper.filterSqlChar(objnamecnd)+"%'";
}
if(statuscnd.length()>0)
{
	where = where +" and a.status='"+statuscnd+"'";
}
if(officecnd.length()>0)
{
	where = where +" and b.office='"+officecnd+"'";
}
if(subjectcnd.length()>0)
{
	where = where +" and b.subject='"+subjectcnd+"'";
}
if(tasknobcnd.length()>0)
{
	where = where +" and a.taskno='"+StringHelper.filterSqlChar(tasknobcnd)+"'";
}

String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
DataService ds = new DataService();
List selectData=null;
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select a.id,a.requestid,a.taskno tasknob,b.objname,b.taskno,b.office,b.principal,b.start1,a.status,b.finish1,a.indentstartdate,a.indentfinishdate from  edo_task a,edo_task b where a.parenttaskuid=b.id  and a.model='2c91a84e2aa7236b012aa737d8930007' and a.mastertype='2c91a0302acabc4e012acac9706b000c' "+where+" order by b.taskno";
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
<title><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0045")%><!-- 现场服务报告结项处理 --></title>
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000")%>','S','accept',function(){onSearch()});//查询
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0058")%>','A','accept',function(){showAll()});//显示全部
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028")%>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025")%>','E','page_excel',Save2Excel);//导出为Excel
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0059")%>','M','page_excel',exportAll);//导出全部
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
		height:90,
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
                height:viewport.getSize().height*0.6,
                buttons: [{
                    text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
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
<form action="" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" name="refresh" id="refresh" onclick="onSearch();"/>

<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>

	<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e")%><!-- 任务编号 --></td>
	<td  class="FieldValue" width=15% nowrap>
		<input type=text class=inputstyle size=20 name="tasknocnd" value="<%=tasknocnd%>"/>
	</td>
	<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006")%><!-- 任务名称 --></td>
	<td  class="FieldValue" width=15% nowrap>
		<input type=text class=inputstyle size=20 name="objnamecnd" value="<%=objnamecnd%>"/>
	</td>
	<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0046")%><!-- 预计完成 --> </td>
	<TD class=FieldValue noWrap>
		<input type=text class=inputstyle readonly size=10 name="finish1beg"  value="<%=finish1beg%>" onclick="WdatePicker()">-<input type=text class=inputstyle size=10 readonly name="finish1end"  value="<%=finish1end%>" onclick="WdatePicker()">
	</TD>  
		<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7120038")%><!-- 所属专业 --></td>
    <td width=15% class='FieldValue'>
		<select style="width:120" class="inputstyle2" id="subjectcnd"  name="subjectcnd" >
		<option value=""   ></option>
		<%
		selectData=ds.getValues("select id,objname from selectitem where  typeid='2c91a0302aa6def0012aa8a11052074d' and pid is null  and nvl(col1,'0')='0' order by dsporder ");
		tempstr=subjectcnd;
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
	<tr>
	<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0047")%><!-- 报告编号 --></td>
	<td  class="FieldValue" width=15% nowrap>
		<input type=text class=inputstyle size=20 name="tasknobcnd" value="<%=tasknobcnd%>"/>
	</td>
	<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0048")%><!-- 实施部门 -->:</td> 
	<TD class=FieldValue noWrap>
		<span> <BUTTON type="button" class=Browser onclick="javascript:getrefobj('officecnd','officecndspan','402881e60bfee880010bff17101a000c','','','0');"></BUTTON> <INPUT type=hidden value="<%=officecnd%>" name=officecnd> <SPAN id=officecndspan name="officecndspan"><%=getBrowserDicValue("department","id","objname",officecnd)%></SPAN></SPAN>
	</TD>  
	<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0049")%><!-- 工作人员 -->:</td> 
	<TD class=FieldValue noWrap>
		<span> <BUTTON type="button" class=Browser onclick="javascript:getrefobj('principalcnd','principalcndspan','402881e60bfee880010bff17101a000c','','','0');"></BUTTON> <INPUT type=hidden value="<%=principalcnd%>" name=principalcnd> <SPAN id=principalcnd name="principalcndspan"><%=getBrowserDicValue("humres","id","objname",principalcnd)%></SPAN></SPAN>
	</TD>
	<td  class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402881ea0cc094ad010cc09ec149000b")%><!-- 任务状态 --></td>
		<td width=15% class='FieldValue'>
		<select style="width:120" class="inputstyle2" id="statuscnd"  name="statuscnd">
		<option value=""   ></option>
		<%
		selectData=ds.getValues("select id,objname from selectitem where typeid='2c91a0302aa21947012aa2325769000e'  and pid is null and nvl(col1,0)=0 and isdelete=0 order by dsporder");
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
<input type="hidden" id="toPageType" name="toPageType" value="">
<input type="hidden" id="pageNum" name="pageNum" value="<%=pageNum%>">
</form>
</div>
<div id='repContainer'>
</c:if>
<CENTER>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="120" />
	<col width="350" />
	<col width="120" />
	<col width="80" />
	<col width="80" />
	<col width="50" />
	<col width="80" />
	<col width="80" />
	</colgroup>																								
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:20;">
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e")%></td><!-- 任务编号 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006")%></td><!-- 任务名称 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004a")%></td><!-- 报告号 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fcf6370000a")%></td>	<!-- 开始日期 -->	
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005a")%></td><!-- 完成日期 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")%></td><!-- 状态 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0049")%></td><!-- 工作人员 -->
			<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004b")%></td><!-- 服务部门 -->
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
		String taskno=StringHelper.null2String(m.get("taskno"));
		String objname=StringHelper.null2String(m.get("objname"));
		String office=StringHelper.null2String(m.get("office"));
		String principal=StringHelper.null2String(m.get("principal"));
		String start1=StringHelper.null2String(m.get("start1"));
		String finish1=StringHelper.null2String(m.get("finish1"));
		String status=StringHelper.null2String(m.get("status"));
		String tasknob=StringHelper.null2String(m.get("tasknob"));
		String id=StringHelper.null2String(m.get("id"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String indentfinishdate=StringHelper.null2String(m.get("indentfinishdate"));
		String indentstartdate=StringHelper.null2String(m.get("indentstartdate"));
		buf1.append("<tr style=\"height:25;\" bgcolor=\""+getBrowserDicValue("selectitem","id","objdesc",status)+"\"		ondblclick=\"javascript:    dlg0.getComponent('dlgpanel').setSrc('/app/ft/taskFinishQDeal.jsp?requestid="+requestid+"');dlg0.show();\">");
		buf1.append("<td align=\"center\">"+taskno+"</td>");
		buf1.append("<td align=\"center\">"+objname+"</td>");
		buf1.append("<td align=\"center\">"+tasknob+"</td>");
		buf1.append("<td align=\"left\">"+indentstartdate+"</td>");
		buf1.append("<td align=\"left\">"+indentfinishdate+"</td>");
		
		buf1.append("<td align=\"center\">"+getSelectDicValue(status)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",principal)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("orgunit","id","objname",office)+"</td>");
		buf1.append("</tr>");
	}
	
}
out.println(buf1.toString());
%>
</tbody>
</table>
</div>
<c:if test="${!isExcel}">
<div align="left"  style="border:1px solid #c3daf9;height:30" id="pagebar">
<table border="0" style="border-collapse:collapse;" bordercolor="#c3daf9" width="100%">
<tr>
<td width="15%" align=right>
&nbsp;&nbsp;<a <%=pageno<=1?"":"href=\"javascript:toPage(1);\""%> ><img src="/app/images/resultset_first.gif"  style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800069")%>"><!-- 首页 --></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno<=1?"":"href=\"javascript:toPage(2);\""%>><img src="/app/images/resultset_previous.gif" style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006a")%>"><!-- 前页 --></a>&nbsp;&nbsp;&nbsp;</td>
<td width="15%" align=center>
<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%><!-- 第 --> &nbsp;<input type="text" id="pageno" name="pageno" value="<%=pageno%>" size="1" style="height:18;font-size:11;text-align:center;padding-bottom:2px" onchange="javascript:toPage(5);" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%><!-- 页 -->&nbsp;/&nbsp;<%=totalPage%>
</td><td width="15%" align=left>
&nbsp;&nbsp;&nbsp;<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(3);\""%>><img src="/app/images/resultset_next.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006b")%>"><!-- 后页 --></a>&nbsp;&nbsp;&nbsp;
<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(4);\""%>><img src="/app/images/resultset_last.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150061")%>"><!-- 尾页 --> </a>&nbsp;&nbsp;&nbsp;
</td>
<td width="40%">&nbsp;</td>
<td width="20%" align=center><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006d")%><!-- 记录 -->:&nbsp;<%=startNum%>&nbsp;~&nbsp;<%=realNum%>&nbsp;/&nbsp;<%=totalNum%>&nbsp;&nbsp;&nbsp;</td>
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


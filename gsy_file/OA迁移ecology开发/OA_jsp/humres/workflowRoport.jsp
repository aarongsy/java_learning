<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
<%
String senddatebeg = StringHelper.null2String(request.getParameter("senddatebeg"));
Date date=new Date();
String shijian="";
SimpleDateFormat formater=new SimpleDateFormat();
formater.applyPattern("yyyy-MM-dd");
shijian=formater.format(date);
if(senddatebeg==null) senddatebeg="";
if(senddatebeg.length()<1) senddatebeg=shijian; 
String senddateend = StringHelper.null2String(request.getParameter("senddateend"));
if(senddateend==null) senddateend="";
if(senddateend.length()<1) senddateend= shijian;
senddateend = senddateend;
String action=StringHelper.null2String(request.getParameter("action"));
String 	where="";
where = " and f.submitdate||' '||f.submittime>= '"+senddatebeg+"' and f.submitdate||' '||f.submittime<='"+senddateend+" 23:59:59"+"'";
DataService ds = new DataService();
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

%>
<%@ include file="/base/init.jsp"%>
<%

if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150031");//工作处理响应总表.xls
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
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150032")%><!-- 工作处理响应总表 --></title>
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

<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
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

sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=/images/checkinput.gif>"
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
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','S','accept',function(){onSearch()});//确定
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
function checkIsNull()
{
	var senddatebeg=document.getElementsByName('senddatebeg');
	if(senddatebeg[0].value==null||senddatebeg[0].value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150033")%>");//必须设置工作到达时间段!
		return false;
	}
	return true;
}
</script>
</head>

<body>
<form action="/app/humres/workflowRoport.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#BDEBF7">
<TBODY>
<TR class=title>
<TD  noWrap width="5%"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150034")%><!-- 工作到达时间 --></td> 
<TD class=FieldValue width="25%"><input type=text class=inputstyle readonly size=20 name="senddatebeg"  value="<%=senddatebeg%>" onclick="WdatePicker()">
                    -
                <input type=text class=inputstyle size=20 readonly name="senddateend"  value="<%=senddateend%>" onclick="WdatePicker()"> <span style="color:red"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150035")%><!-- 不填写默认当天 --><span/>  </TD>
</tr></tbody></table>
<br>
</c:if>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150032")%></CENTER></div>
<CENTER>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:900" bordercolor="#333333" width="100%">
	<colgroup>
	<col width="100" />
  <col width="120" />
  <col width="100" />
  <col width="80" />
	<col width="80" />
  <col width="80" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:30;">
		<td rowspan="2"  align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150036")%><!-- 工号 --></td>
	 <td rowspan="2"  align="center"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%><!-- 姓名 --></td>
	 <td rowspan="2"  align="center"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980054")%><!-- 职务 --></td>
	 <td colspan="2"  align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150037")%><!-- 统计 --></td>
	 <td rowspan="2"  align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003b")%><!-- 详情 --></td>
  </tr>
	<tr height="39">
	<td colspan="1" height="30"  align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150038")%><!-- 工作处理数 --></td>
	<td colspan="1" align="center" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150039")%><!-- 平均耗时(小时) --></td>
	</tr>
<%

		String sql = "select A.ID,A.OBJNAME,a.extselectitemfield3,a.objno from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935'  and a.id<>'4028803b21381b8d0121385df3070066' and a.isdelete=0 order by a.objno";
		List mnglist = ds.getValues(sql);
		//sql = "select count(*) nums,a.operator, round(sum((to_date(b.submitdate||' '||b.submittime,'yyyy-mm-dd hh24:mi:ss')-to_date(f.submitdate||' '||f.submittime,'yyyy-mm-dd hh24:mi:ss'))*24)/count(*),1) timeout  from requestlog a,requeststep b,requestbase c ,requeststatus e,requeststep f where A.STEPID=B.ID and C.ID=A.REQUESTID and b.id=e.curstepid and f.id=nvl((select h.laststepid from requeststep g,requeststatus h where g.id=h.curstepid and g.nodeid=b.nodeid start with g.id=e.laststepid   connect by prior  h.laststepid=g.id and rownum=1),e.laststepid) and  a.stepid=b.id and logtype<>'402881e50c5b4646010c5b5afd170008' and b.submitdate is not null and f.submitdate is not null and to_date(b.submitdate||' '||b.submittime,'yyyy-mm-dd hh24:mi:ss')-to_date(f.submitdate||' '||f.submittime,'yyyy-mm-dd hh24:mi:ss')>0 "+where+" and c.workflowid in (select workflowid from uf_work_flowmonitor where nvl(ifmonitor,'4028803b213cb1c001213cfd84fc00b4')='4028803b213cb1c001213cfd84fc00b3') group by a.operator";
		sql = "select count(*) nums,a.operator, round(sum((to_date(b.submitdate||' '||b.submittime,'yyyy-mm-dd hh24:mi:ss')-to_date(f.submitdate||' '||f.submittime,'yyyy-mm-dd hh24:mi:ss'))*24)/count(*),1) timeout  from requestlog a,requeststep b,requestbase c ,requeststatus e,requeststep f where A.STEPID=B.ID and C.ID=A.REQUESTID and b.id=e.curstepid  and f.id=nvl((select laststepid from (select h.laststepid,g.id from requeststep g,requeststatus h where g.id=h.curstepid and g.requestid=a.requestid and h.requestid=a.requestid  and g.requestid=h.requestid and g.nodeid=b.nodeid) start with id=e.laststepid   connect by prior  laststepid=id and rownum=1 ),e.laststepid) and  a.stepid=b.id and logtype<>'402881e50c5b4646010c5b5afd170008' and b.submitdate is not null and f.submitdate is not null and to_date(b.submitdate||' '||b.submittime,'yyyy-mm-dd hh24:mi:ss')-to_date(f.submitdate||' '||f.submittime,'yyyy-mm-dd hh24:mi:ss')>0 "+where+" and c.workflowid in (select workflowid from uf_work_flowmonitor where nvl(ifmonitor,'4028803b213cb1c001213cfd84fc00b4')='4028803b213cb1c001213cfd84fc00b3') group by a.operator";
		List timelist = ds.getValues(sql);
		StringBuffer cont = new StringBuffer();
		for(int i=0,size=mnglist.size();i<size;i++)
		{
			Map m = (Map)mnglist.get(i);
			String userid = m.get("ID").toString();
			String name = m.get("OBJNAME").toString();
			String post = StringHelper.null2String(m.get("extselectitemfield3"));
			String objno = StringHelper.null2String(m.get("objno"));
			double timeout = 0.0;
			int nums = 0;
			for(int j=0,size1=timelist.size();j<size1;j++)
			{
				Map m1 = (Map)timelist.get(j);
				String userid1 = m1.get("operator").toString();
				if(userid.equals(userid1))
				{
						timeout=Double.valueOf(m1.get("timeout").toString());
						nums=Integer.parseInt(m1.get("nums").toString());
						break;
				}
				else
					continue;
			}
			cont.append("<tr height=\"39\">");
			cont.append("<td height=\"39\"  align=\"center\">"+objno+"</td>");
			cont.append("<td height=\"39\"  align=\"center\">"+name+"</td>");
			cont.append("<td colspan=\"1\"  align=\"center\" style=\"color:#C92BDB\">"+getSelectDicValue(post)+"</td>");
			cont.append("<td colspan=\"1\"  align=\"center\">"+nums+"</td>");
			cont.append("<td colspan=\"1\"  align=\"center\">"+timeout+"</td>");
			cont.append("<td colspan=\"1\"  align=\"center\"><a href=\"javascript:top.frames[1].onUrl('/app/humres/workflowRoportDetail.jsp?operator="+userid+"&senddatebeg="+senddatebeg+"&senddateend="+senddateend+"','"+name+"工作处理详情');\">查看</a></td>");
			cont.append("</tr>");
		}
		out.println(cont.toString());
%>
</table>
</div>
<c:if test="${!isExcel}">
</body>
</html>
</c:if>
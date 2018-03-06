<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager" %>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%
String requestid = request.getParameter("requestid");
if(requestid==null) requestid=String.valueOf(requestid);
DataService ds = new DataService();
String action=StringHelper.null2String(request.getParameter("action"));
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
		String fname=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15002d");//区考考勤记录.xls
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
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15002e")%><!-- 区考考勤记录 --></title>
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

<body>
<form action="/app/project/projectReport.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" name="requestid" id="requestid" value="<%=requestid%>"/>
<br>
<div id='repContainer'>
</c:if>
<%
/*List yclist=ds.getValues("select WEEKBEG,WEEKEND,EMPID,(select objno from humres where id=uf_kq_kqyc.EMPID) objno,nyear,nmonth from uf_kq_kqyc where requestid='"+requestid+"'");
Map mm = (Map) yclist.get(0);
String weekbeg=StringHelper.null2String(mm.get("WEEKBEG"));
String weekend=StringHelper.null2String(mm.get("WEEKEND"));
String objno=StringHelper.null2String(mm.get("objno"));
String nyear=StringHelper.null2String(mm.get("nyear"));
String nmonth=StringHelper.null2String(mm.get("nmonth"));*/
String weekbeg="2009-09-25";
String weekend="2009-09-30";
String objno="5500618";
String nyear="2009";
String nmonth="09";
%>
<div valign='middle'>
<div align=left width="50%"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15002f")%><!-- 日期区间 -->：<%=weekbeg+" &nbsp;&nbsp;"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000e")+"&nbsp;&nbsp; "+weekend+" "+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150016")+" "%></div><!-- 至 --><!-- 月份 -->
<div align=right width="50%"></div>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:400" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="100" />
	<col width="80" />
	 <col width="100" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")%><!-- 日期 --></td>
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c095220134c09523720000")%><!-- 序号 --></td>
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150030")%><!-- 打卡时间 --></td>
  </tr>
<tbody>
<%

StringBuffer buf1 = new StringBuffer();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("testDao");//实例化数据库连接对象
List kqlist = baseJdbc.executeSqlForList("select  CONVERT(varchar(100),datetime,23) ndate,CONVERT(varchar(100),datetime,24) ntime from cardrecord"+nyear+String.valueOf(Integer.parseInt(nmonth))+" where datetime>=cast('"+weekbeg+"' as datetime) and datetime<=dateadd(dd,1,cast('"+weekend+"' as datetime)) and empid=(select recid from employee where empno='"+objno+"') order by  ndate asc,ntime asc");//取所有异常数据

String ndate1="";
int rows=0;
for(int i=0,realNum=kqlist.size();i<realNum;i++)
{

	Map m = (Map)kqlist.get(i);
	String ndate=StringHelper.null2String(m.get("ndate"));
	String ntime=StringHelper.null2String(m.get("ntime"));
	buf1.append("<tr style=\"height:25;\" >");
	boolean boola=false;
	if(!ndate.equals(ndate1))
	{
		rows=0;
		ndate1=ndate;
		int rownum = 1;
		for(int k=i+1;k<realNum;k++)
		{
			Map m2 = (Map)kqlist.get(k);
			String ndate2=StringHelper.null2String(m2.get("ndate"));
			if(ndate2.equals(ndate1))
			{
				rownum=rownum+1;
			}
			else
				break;
		}
		buf1.append("<td align=\"center\" rowspan="+(rownum)+">"+ndate1+"</td>");
	}
	rows++;
	buf1.append("<td align=\"center\">"+rows+"</td>");
	buf1.append("<td align=\"center\">"+ntime+"</td>");
	buf1.append("</tr>");
	
}
out.println(buf1.toString());
%>
</tbody>
</table>
</form>
<c:if test="${!isExcel}">
</body>
</html>
</c:if>



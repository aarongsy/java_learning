<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
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
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql ="select * from uf_salaryss where emname='"+userid+"' order by years desc,months desc";
int pageNum=20;

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
/*
*/
%>
<%@ include file="/base/init.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150015")%></title><!-- 工资福利 -->
<%@ include file="/app/base/include.jsp"%>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script>
</head>
<body>
<script>
function onSearch(){
		document.formExport.submit();
}
</script>
<form action="/app/humres/humresSalary.jsp" name="formExport" method="post">
<br>
<div id='repContainer'>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150015")%></CENTER><BR></div><!-- 工资福利 -->
<CENTER>
<div align=left width="50%"></div>
<div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001e")%></div><!-- 单位(元) -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:2000" bordercolor="#333333" id="mainTable">
	<colgroup>
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
		<col width="80" />
		<col width="80" />
		<col width="80" />
		<col width="80" />
		<col width="80" />
		<col width="80" />
		<col width="80" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001")%></td> <!-- 年度 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150016")%></td><!-- 月份 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150017")%></td><!-- 岗薪工资 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150018")%></td><!-- 午餐补贴 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150019")%></td><!-- 通讯费 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15001a")%></td><!-- 其它补贴 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15001b")%></td><!-- 加班工资 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15001c")%></td><!-- 月度奖 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15001d")%></td><!-- 其它奖金 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15001e")%></td><!-- 应发数 -->
		<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15001f")%></td><!-- 基本养老金 -->
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150020")%></td><!-- 医疗保险 -->	
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150021")%></td><!-- 失业保险 -->
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150022")%></td><!-- 住房公积金 -->	
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150023")%></td><!-- 年金 -->		
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150024")%></td><!-- 所得税 -->
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150025")%></td><!-- 其它代扣 -->
		<td colspan="1" rowspan="1" align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150026")%></td><!-- 实发金额 -->	
  </tr>
<tbody>
<%
StringBuffer buf1 = new StringBuffer();

//String finishmonth=yearcnd+"-"+monthcnd;
String requestid1="";
if(totalNum>0)
{
List listData=(List) page1.getResult();
for(int i=0,size=realNum-pageNum*(pageno-1);i<size;i++)
{
	Map m = (Map)listData.get(i);
	String id=StringHelper.null2String(m.get("id"));
	String requestid=StringHelper.null2String(m.get("requestid"));
	String Years=StringHelper.null2String(m.get("Years"));
	String Months=StringHelper.null2String(m.get("Months"));
	String RoleSalary=StringHelper.null2String(m.get("RoleSalary"));
	String Lunchallow=StringHelper.null2String(m.get("Lunchallow"));
	String TelephFee=StringHelper.null2String(m.get("TelephFee"));
	String OtherAllow=StringHelper.null2String(m.get("OtherAllow"));
	String DutySalary=StringHelper.null2String(m.get("DutySalary"));
	String Monthbonus=StringHelper.null2String(m.get("Monthbonus"));
	String Otherbounds=StringHelper.null2String(m.get("Otherbounds"));
	String RecognizedAm=StringHelper.null2String(m.get("RecognizedAm"));
	String BasicFounds=StringHelper.null2String(m.get("BasicFounds"));
	String MedicalInsur=StringHelper.null2String(m.get("MedicalInsur"));
	String UnempInsur=StringHelper.null2String(m.get("UnempInsur"));
	String HouseFounds=StringHelper.null2String(m.get("HouseFounds"));
	String YearBounds=StringHelper.null2String(m.get("YearBounds"));
	String PersonalTax=StringHelper.null2String(m.get("PersonalTax"));
	String OtherDeduct=StringHelper.null2String(m.get("OtherDeduct"));
	String ActualAmount=StringHelper.null2String(m.get("ActualAmount"));
	buf1.append("<tr style=\"height:25;\">");
	buf1.append("<td align=\"center\">"+Years+"</td>");
	buf1.append("<td align=\"center\">"+Months+"</td>");
	buf1.append("<td align=\"right\">"+RoleSalary+"</td>");

	buf1.append("<td align=\"right\">"+Lunchallow+"</td>");
	buf1.append("<td align=\"right\">"+TelephFee+"</td>");
	buf1.append("<td align=\"right\">"+OtherAllow+"</td>");
	buf1.append("<td align=\"right\">"+DutySalary+"</td>");
	buf1.append("<td align=\"right\">"+Monthbonus+"</td>");
	buf1.append("<td align=\"right\">"+Otherbounds+"</td>");
	buf1.append("<td align=\"right\">"+RecognizedAm+"</td>");
	buf1.append("<td align=\"right\">"+BasicFounds+"</td>");
	buf1.append("<td align=\"right\">"+MedicalInsur+"</td>");
	buf1.append("<td align=\"right\">"+UnempInsur+"</td>");
	buf1.append("<td align=\"right\">"+HouseFounds+"</td>");
	buf1.append("<td align=\"right\">"+YearBounds+"</td>");
	buf1.append("<td align=\"right\">"+PersonalTax+"</td>");
	buf1.append("<td align=\"right\">"+OtherDeduct+"</td>");
	buf1.append("<td align=\"right\">"+ActualAmount+"</td>");
	buf1.append("</tr>");
}
out.println(buf1.toString());
}
%>
</tbody>
</table>
</div>
<div align="left"  style="border:1px solid #c3daf9;">
<table border="0" style="border-collapse:collapse;" bordercolor="#c3daf9" width="100%">
<tr>
<td width="15%" align=right>
&nbsp;&nbsp;<a <%=pageno<=1?"":"href=\"javascript:toPage(1);\""%> ><img src="/app/images/resultset_first.gif"  style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800069")%>"></a>&nbsp;&nbsp;&nbsp;<!-- 首页 -->
<a <%=pageno<=1?"":"href=\"javascript:toPage(2);\""%>><img src="/app/images/resultset_previous.gif" style="<%=pageno<=1?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006a")%>"></a>&nbsp;&nbsp;&nbsp;</td><!-- 前页 -->
<td width="10%" align=center>
<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%> &nbsp;<input type="text" id="pageno" name="pageno" value="<%=pageno%>" size="1" style="height:16;font-size:11;text-align:center;padding-bottom:2px" onchange="javascript:toPage(5);" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>&nbsp;/&nbsp;<%=totalPage%><!-- 第 --><!-- 页 -->
</td><td width="15%" align=left>
&nbsp;&nbsp;&nbsp;<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(3);\""%>><img src="/app/images/resultset_next.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006b")%>"></a>&nbsp;&nbsp;&nbsp;<!-- 后页 -->
<a <%=pageno>=totalPage?"":"href=\"javascript:toPage(4);\""%>><img src="/app/images/resultset_last.gif" style="<%=pageno>=totalPage?"filter:Gray":""%>" alt="<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150027")%>"> </a>&nbsp;&nbsp;&nbsp;<!-- 属页 -->
</td>
<td width="40%">&nbsp;</td>
<td width="20%" align=center><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c80006d")%>:&nbsp;<%=startNum%>&nbsp;~&nbsp;<%=realNum%>&nbsp;/&nbsp;<%=totalNum%>&nbsp;&nbsp;&nbsp;</td><!-- 记录 -->
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
</body>
</html>



<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
//String requestid = this.requestid;
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
<script type="text/javascript" language="javascript" src='/js/main.js'></script>


<!--div id="warpp" style="height:600px;overflow-y:auto"-->
<DIV  id="warpp" style="BORDER-BOTTOM: #000000 0px solid; BORDER-LEFT: #000000 0px solid; WIDTH: 100%; HEIGHT: 600px; OVERFLOW: auto; BORDER-TOP: #000000 0px solid; BORDER-RIGHT: #000000 0px solid">
<!--<div id="warpp" >-->

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border="1" cellSpacing=0 cellPadding=0 style="width:100%;font-size:12" bordercolor="#adae9d">
<CAPTION>外训报销明细</CAPTION>
<COLGROUP>
<COL width=70>
<COL width=100>
<COL width=60>
<COL width=80>

<COL width=80>
<COL width=80>
<COL width=80>

<COL width=80>

<COL width=80>

<COL width=80>

<COL width=80>

<COL width=80>

<COL width=80>
<COL width=200></COLGROUP>
<TR height="25"  class="title">
<TD style="TEXT-ALIGN: center" rowSpan=2 noWrap>日期</TD>
<TD style="TEXT-ALIGN: center" rowSpan=2 noWrap>地点</TD>
<TD style="TEXT-ALIGN: center" rowSpan=2 noWrap>姓名</TD>
<TD style="TEXT-ALIGN: center"  noWrap>住宿费</TD>
<TD style="TEXT-ALIGN: center" colSpan=3 noWrap>伙食费</TD>
<TD style="TEXT-ALIGN: center"  noWrap>出租费</TD>
<TD style="TEXT-ALIGN: center"  noWrap>交通费</TD>
<TD style="TEXT-ALIGN: center"  noWrap>培训费</TD>
<TD style="TEXT-ALIGN: center"  noWrap>杂费</TD>
<TD style="TEXT-ALIGN: center"  noWrap>人事薪资费</TD>
<TD style="TEXT-ALIGN: center"  noWrap>机票费</TD>
<TD style="TEXT-ALIGN: center" rowSpan=2 noWrap>备注</TD></TR>
<TR class=Header>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD>

<TD style="TEXT-ALIGN: center" noWrap>早餐</TD>
<TD style="TEXT-ALIGN: center" noWrap>中餐</TD>
<TD style="TEXT-ALIGN: center" noWrap>晚餐</TD>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD>

<TD style="TEXT-ALIGN: center" noWrap>金额</TD></TR>
<%
String sql = "";
	sql = "select a.startdate,a.address,s.objname as getclassname,t.currencycode as zscurrency,a.zspay,b.currencycode as hscurrency,a.lunchpay,a.breakfastpay,a.dinnerpay,c.currencycode as taxicurrency,a.taxipay,d.currencycode as buscurrency,a.buspay,e.currencycode as traincurrency,a.trainpay,g.currencycode as othercurrency,a.otherpay,h.currencycode as salarycurrency,a.salarypau,j.currencycode as airtiktcurrency,a.airtiktpay,a.remark from uf_hr_outtarinexpdetail a left join uf_oa_currencymaintain t on a.zscurrency=t.requestid left join uf_oa_currencymaintain b on a.hscurrency=b.requestid left join uf_oa_currencymaintain c on a.taxicurrency=c.requestid left join uf_oa_currencymaintain d on a.buscurrency=d.requestid left join uf_oa_currencymaintain e on a.traincurrency=e.requestid left join uf_oa_currencymaintain g on a.othercurrency=g.requestid left join uf_oa_currencymaintain h on a.salarycurrency=h.requestid left join uf_oa_currencymaintain j on a.airtiktcurrency=j.requestid left join humres s on a.getclassname=s.id where a.requestid='"+requestid+"'";

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String startdate=StringHelper.null2String(mk.get("startdate"));
		String address=StringHelper.null2String(mk.get("address"));
		String getclassname=StringHelper.null2String(mk.get("getclassname"));
		String zscurrency=StringHelper.null2String(mk.get("zscurrency"));
		String zspay=StringHelper.null2String(mk.get("zspay"));
		String hscurrency=StringHelper.null2String(mk.get("hscurrency"));
		String lunchpay=StringHelper.null2String(mk.get("lunchpay"));
		String breakfastpay=StringHelper.null2String(mk.get("breakfastpay"));
		String dinnerpay=StringHelper.null2String(mk.get("dinnerpay"));
		String taxicurrency=StringHelper.null2String(mk.get("taxicurrency"));
		String taxipay=StringHelper.null2String(mk.get("taxipay"));
		String buscurrency=StringHelper.null2String(mk.get("buscurrency"));
		String buspay=StringHelper.null2String(mk.get("buspay"));
		String traincurrency=StringHelper.null2String(mk.get("traincurrency"));
		String trainpay=StringHelper.null2String(mk.get("trainpay"));
		String othercurrency=StringHelper.null2String(mk.get("othercurrency"));
		String otherpay=StringHelper.null2String(mk.get("otherpay"));
		String salarycurrency=StringHelper.null2String(mk.get("salarycurrency"));
		String salarypau=StringHelper.null2String(mk.get("salarypau"));
		String airtiktcurrency=StringHelper.null2String(mk.get("airtiktcurrency"));
		String airtiktpay=StringHelper.null2String(mk.get("airtiktpay"));
		String remark=StringHelper.null2String(mk.get("remark"));

	%>

		<TR  >
		<TD style="TEXT-ALIGN: center" noWrap><%=startdate%></TD>
		<TD style="TEXT-ALIGN: center" noWrap><%=address%></TD>
		<TD style="TEXT-ALIGN: center" noWrap><%=getclassname%></TD>
		<%
			if(zscurrency.equals("RMB")||zscurrency.equals("")||zscurrency.equals("null")||zscurrency==null)
		{
			%><TD style="TEXT-ALIGN: center" noWrap><%=zspay%></TD><%
		}
		else
		{
			%><TD style="TEXT-ALIGN: center" noWrap><%=zscurrency%><%=zspay%></TD><%
		}
			if(hscurrency.equals("RMB")||hscurrency.equals("")||hscurrency.equals("null")||hscurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=breakfastpay%></TD>
			<TD style="TEXT-ALIGN: center" noWrap><%=lunchpay%></TD>
			<TD style="TEXT-ALIGN: center" noWrap><%=dinnerpay%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=hscurrency%><%=breakfastpay%></TD>
			<TD style="TEXT-ALIGN: center" noWrap><%=hscurrency%><%=lunchpay%></TD>
			<TD style="TEXT-ALIGN: center" noWrap><%=hscurrency%><%=dinnerpay%></TD>
			<%
		}
	    if(taxicurrency.equals("RMB")||taxicurrency.equals("")||taxicurrency.equals("null")||taxicurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=taxipay%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=taxicurrency%><%=taxipay%></TD>
			<%
		}
		if(buscurrency.equals("RMB")||buscurrency.equals("")||buscurrency.equals("null")||buscurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=buspay%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=buscurrency%><%=buspay%></TD>
			<%
		}
		if(traincurrency.equals("RMB")||traincurrency.equals("")||traincurrency.equals("null")||traincurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=trainpay%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=traincurrency%><%=trainpay%></TD>
			<%
		}
		if(othercurrency.equals("RMB")||othercurrency.equals("")||othercurrency.equals("null")||othercurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=otherpay%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=othercurrency%><%=otherpay%></TD>
			<%
		}
		if(salarycurrency.equals("RMB")||salarycurrency.equals("")||salarycurrency.equals("null")||salarycurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=salarypau%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=salarycurrency%><%=salarypau%></TD>
			<%
		}
		if(airtiktcurrency.equals("RMB")||airtiktcurrency.equals("")||airtiktcurrency.equals("null")||airtiktcurrency==null)
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=airtiktpay%></TD>
			<%
		}
		else
		{
			%>
			<TD style="TEXT-ALIGN: center" noWrap><%=airtiktcurrency%><%=airtiktpay%></TD>
			<%
		}
			%>
		
		<TD style="TEXT-ALIGN: center" noWrap><%=remark%></TD>
		</TR>
	<%
		}
	}
	else
		{
	%> 
	<TR><TD class="td2" colspan="14">&nbsp;</TD></TR>
	<%
		} 
	%>

</table>
</div>

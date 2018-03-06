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

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
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
    height: 30px; 
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
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">

<TD   noWrap class="td2"  align=center>费用类型</TD>
<TD  noWrap class="td2"  align=center>记账码</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>预计结关日期</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>
<TD  noWrap class="td2"  align=center>暂估汇率</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  align=center>暂估本位币金额</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>销售凭证号</TD>
<TD  noWrap class="td2"  align=center>销售凭证项次</TD>
</tr>

<%

String sql ="";
	sql= "select (select costname from uf_tr_fymcwhd  where requestid=a.feetype) as feetype,a.ledaccount,a.closedate,a.currency,a.rate,a.amount,a.rmbamount,a.materialid,a.custcenter,a.salesitem, a.salesid from uf_tr_exfeedtdivvy a where  a.requestid='"+requestid+"' order by a.feetype asc";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称
		String ledaccount=StringHelper.null2String(mk.get("ledaccount"));//费用总账科目
		String closedate =StringHelper.null2String(mk.get("closedate"));//预计结关日期
		String currency=StringHelper.null2String(mk.get("currency"));//币种
		String rate = StringHelper.null2String(mk.get("rate"));//汇率
		String amount=StringHelper.null2String(mk.get("amount"));//暂估金额
		String rmbamount=StringHelper.null2String(mk.get("rmbamount"));//暂估本位币金额
		
		String materialid=StringHelper.null2String(mk.get("materialid"));//物料号
		String taxcode = StringHelper.null2String(mk.get("taxcode"));//税码
		String salesid = StringHelper.null2String(mk.get("salesid"));//销售凭证号
		String salesitem = StringHelper.null2String(mk.get("salesitem"));//凭证项次
		String custcenter = StringHelper.null2String(mk.get("custcenter"));

	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center ><%=feetype %></TD>
		<TD noWrap  class="td2"  align=center>40</TD>
		<TD noWrap  class="td2"  align=center><%=ledaccount %></TD>
		<TD noWrap  class="td2"  align=center><%=closedate %></TD>
		<TD noWrap  class="td2"  align=center><%=currency %></TD>
		<TD noWrap  class="td2"  align=center><%=rate %></TD>
		<TD noWrap  class="td2"  align=center><%=amount %></TD>
		<TD noWrap  class="td2"  align=center><%=rmbamount %></TD>
	
		<TD  noWrap  class="td2"  align=center><%=materialid %></TD>
		<TD  noWrap  class="td2"  align=center><%=custcenter %></TD>
		<TD  noWrap  class="td2"  align=center><%=salesid %></TD>
		<TD  noWrap  class="td2"  align=center><%=salesitem %></TD>
	
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="12">没有信息</TD></TR>
<%} %>
</table>
</div>

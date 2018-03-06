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
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

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
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="60">
<COL width="120">
<COL width="60">
<COL width="80">
<COL width="120">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="160">
<COL width="120">
<COL width="120">
<COL width="80">
<COL width="120">
<COL width="60">
<COL width="120">
<COL width="60">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>进口到货编号</TD>
<TD  noWrap class="td2"  align=center>进口到货项次</TD>
<TD  noWrap class="td2"  align=center>费用名称</TD>
<TD  noWrap class="td2"  align=center>支付对象</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  align=center>暂估汇率</TD>
<TD  noWrap class="td2"  align=center>暂估本位币金额</TD>
<TD  noWrap class="td2"  align=center>清帐金额</TD>
<TD  noWrap class="td2"  align=center>清帐本位币金额</TD>
<TD  noWrap class="td2"  align=center>业务货币差额</TD>
<TD  noWrap class="td2"  align=center>本位币差额</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>资产号</TD>
<TD  noWrap class="td2"  align=center>内部订单号</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>

</tr>

<%

String sql = "select sno,imgoodsid,imgoodsitem,feetype,payobject,estcurrency,estmoney,estrate,estamount,clearmoney,clearamount,buscurrencydiff,currencydiff,materialid,costcenter,assetid,innerorderid,ledgersubject,purorderid,purorderitem,(select costname from uf_tr_fymcwhd where requestid = feetype) as feename from uf_tr_feeclearsub where requestid = '"+requestid+"' order by sno asc";
//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String no=StringHelper.null2String(mk.get("sno"));//序号
		String imgoodsid=StringHelper.null2String(mk.get("imgoodsid"));//进口货物申请书
		String imgoodsitem=StringHelper.null2String(mk.get("imgoodsitem"));//申请书序号
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称(id)
		String feename=StringHelper.null2String(mk.get("feename"));//费用名称(中文)
		String payobject=StringHelper.null2String(mk.get("payobject"));//支付对象
		String estcurrency=StringHelper.null2String(mk.get("estcurrency"));//币种
		String estmoney=StringHelper.null2String(mk.get("estmoney"));//暂估金额
		String estrate = StringHelper.null2String(mk.get("estrate"));//汇率
		String estamount=StringHelper.null2String(mk.get("estamount"));//暂估本位币金额

		String qzmon = StringHelper.null2String(mk.get("clearmoney"));//清帐金额
		String qzrmbmon = StringHelper.null2String(mk.get("clearamount"));//清帐本位币金额
		
		String buscurrencydiff = StringHelper.null2String(mk.get("buscurrencydiff"));//业务货币差额
		String currencydiff = StringHelper.null2String(mk.get("currencydiff"));//本位币差额
		
		String materialid=StringHelper.null2String(mk.get("materialid"));//物料号
		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心
		String assetid=StringHelper.null2String(mk.get("assetid"));//资产号
		String innerorderid=StringHelper.null2String(mk.get("innerorderid"));//内部订单号
		String ledgersubject=StringHelper.null2String(mk.get("ledgersubject"));//费用总账科目
		String purorderid=StringHelper.null2String(mk.get("purorderid"));//采购订单号
		String purorderitem=StringHelper.null2String(mk.get("purorderitem"));//采购订单项次

	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>

		<TD  class="td2"   align=center ><%=imgoodsid %></TD>
		<TD  class="td2"   align=center ><%=imgoodsitem %></TD>

		<TD   class="td2"  align=center><%=feename %></TD>

		<TD   class="td2"  align=center><%=payobject %></TD>
		<TD   class="td2"  align=center><%=estcurrency %></TD>
		<TD   class="td2"  align=center><%=estmoney %></TD>
		
		<TD   class="td2"  align=center><%=estrate %></TD>
		<TD   class="td2"  align=center><%=estamount %></TD>

		<TD   class="td2"  align=center><%=qzmon %></TD>

		<TD   class="td2"  align=center><%=qzrmbmon %></TD>
	
		<TD   class="td2"  align=center><%=buscurrencydiff %></TD>
		<TD   class="td2"  align=center><%=currencydiff %></TD>
		
		<TD   class="td2"  align=center><%=materialid %></TD>
		<TD   class="td2"  align=center><%=costcenter %></TD>
		<TD   class="td2"  align=center><%=assetid %></TD>
		<TD   class="td2"  align=center><%=innerorderid %></TD>
		<TD   class="td2"  align=center><%=ledgersubject %></TD>
		<TD   class="td2"  align=center><%=purorderid %></TD>
		<TD   class="td2"  align=center><%=purorderitem %></TD>

		</TR>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>
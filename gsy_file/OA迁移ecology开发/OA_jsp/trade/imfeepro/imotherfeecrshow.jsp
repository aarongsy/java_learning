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
<table id="dataTables3" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="60">
<COL width="120">
<COL width="60">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="80">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>费用类型</TD>
<TD  noWrap class="td2"  align=center>清帐币种</TD>
<TD  noWrap class="td2"  align=center>清帐汇率</TD>
<TD  noWrap class="td2"  align=center>业务货币差额</TD>
<TD  noWrap class="td2"  align=center>本位币差额</TD>
<TD  noWrap class="td2"  align=center>异常费用金额</TD>
<TD  noWrap class="td2"  align=center>异常费用本位币金额</TD>
<TD  noWrap class="td2"  align=center>增额费用小计</TD>
<TD  noWrap class="td2"  align=center>增额费用本位币小计</TD>

<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>资产号</TD>
<TD  noWrap class="td2"  align=center>内部订单</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>采购订单行项次</TD>
<TD  noWrap class="td2"  align=center>进口到货编号</TD>
<TD  noWrap class="td2"  align=center>进口到货项次</TD>
</tr>

<%

String sql = "select a.*,(select costname from uf_tr_fymcwhd where requestid = a.feetype) as feena from uf_tr_feeotherclearsub a where requestid='"+requestid+"' order by sno ";
//System.out.println(sql);
DecimalFormat df=new DecimalFormat(".##");
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String sno=StringHelper.null2String(mk.get("sno"));
		String subject=StringHelper.null2String(mk.get("ledgersubject"));
		String feename=StringHelper.null2String(mk.get("feena"));
		String currency=StringHelper.null2String(mk.get("currency"));
		String rate=StringHelper.null2String(mk.get("rate"));
		String buscurrencydiff=StringHelper.null2String(mk.get("buscurrencydiff"));
		String currencydiff=StringHelper.null2String(mk.get("currencydiff"));
		String abnfeemoney=StringHelper.null2String(mk.get("abnfeemoney"));
		String abncurrmoney=StringHelper.null2String(mk.get("abncurrmoney"));
		String addfeetotal=StringHelper.null2String(mk.get("addfeetotal"));
		String addfeecurrtotal=StringHelper.null2String(mk.get("addfeecurrtotal"));
		String materialid=StringHelper.null2String(mk.get("materialid"));
		String costcenter=StringHelper.null2String(mk.get("costcenter"));
		String assetid=StringHelper.null2String(mk.get("assetid"));
		String innerorderid=StringHelper.null2String(mk.get("innerorderid"));
		String purorderid=StringHelper.null2String(mk.get("purorderid"));
		String purorderitem=StringHelper.null2String(mk.get("purorderitem"));
		String imgoodsid=StringHelper.null2String(mk.get("imgoodsid"));
		String imgoodsitem=StringHelper.null2String(mk.get("imgoodsitem"));

		//String insql = "insert into uf_tr_feeotherclearsub (id,requestid,sno,ledgersubject,feetype,currency,rate,buscurrencydiff,currencydiff,abnfeemoney,abncurrmoney,addfeetotal,addfeecurrtotal,materialid,costcenter,assetid,innerorderid,purorderid,purorderitem,imgoodsid,imgoodsitem)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+count+"','55063800','"+feetype+"','"+currency+"','"+rate+"','','','"+leftmon+"','"+leftrmbmon+"','"+leftmon+"','"+leftrmbmon+"','"+materialid+"','"+costcenter+"','"+assetsid+"','"+innerorderid+"','"+orderid+"','"+item+"','"+imgoodsid+"','"+ladingid+"')";
%>
		<TR id="<%="dataDetail_"+sno %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+sno %>" name="no"><%=sno %></TD>

		<TD  class="td2"   align=center ><%=subject %></TD>
		<TD  class="td2"   align=center ><%=feename %></TD>

		<TD   class="td2"  align=center><%=currency %></TD>

		<TD   class="td2"  align=center><%=rate %></TD>
		<TD   class="td2"  align=center><%=buscurrencydiff%></TD>
		<TD   class="td2"  align=center><%=currencydiff%></TD>
		
		<TD   class="td2"  align=center><%=abnfeemoney %></TD>
		<TD   class="td2"  align=center><%=abncurrmoney %></TD>

		<TD   class="td2"  align=center><%=addfeetotal %></TD>

		<TD  class="td2"   align=center ><%=addfeecurrtotal %></TD>
		<TD  class="td2"   align=center ><%=materialid %></TD>

		<TD   class="td2"  align=center><%=costcenter %></TD>

		<TD   class="td2"  align=center><%=assetid %></TD>

		<TD   class="td2"  align=center><%=innerorderid %></TD>

		<TD   class="td2"  align=center><%=purorderid %></TD>
		
		<TD   class="td2"  align=center><%=purorderitem %></TD>
		<TD   class="td2"  align=center><%=imgoodsid %></TD>

		<TD   class="td2"  align=center><%=imgoodsitem %></TD>
		</TR>
	<%
	}
}

%>
</table>
</div>

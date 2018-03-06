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



<div id="warpp"  >
<table id="dataTables4" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<CAPTION>凭证行项目信息表</CAPTION>
<COLGROUP>
<COL width=80>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
</COLGROUP>

<TR height="20"  class="title">
<TD noWrap align="center">序号</TD>
<TD noWrap align="center">记账码</TD>
<TD noWrap align="center">科目</TD>
<TD noWrap align="center">金额</TD>
<TD noWrap align="center">文本</TD>
<TD noWrap align="center">税码</TD>
<TD noWrap align="center">成本中心</TD>
<TD noWrap align="center">内部订单</TD>
<TD noWrap align="center">销售订单</TD>
<TD noWrap align="center">销售订单项次</TD>
<TD noWrap align="center">采购订单</TD>
<TD noWrap align="center">采购订单项次</TD>
<TD noWrap align="center">付款条件</TD>
<TD noWrap align="center">付款基准日期</TD>
<TD noWrap align="center">冻结付款</TD>
<TD noWrap align="center">付款方式</TD>
<TD noWrap align="center">支付货币</TD>
<TD noWrap align="center">支付货币金额</TD>
<TD noWrap align="center">合作银行类型</TD>
<TD noWrap align="center">SGL</TD>
</TR>



<%
	//查询数据并显示
	String selsql = "select ordernumber,chargecode,subject,amount,text,taxcode,costcenter,internalorder,salesorder,salesorderitem,purchaseorder,purchaseorderitem,payterms,paydate,freezpay,paytype,paycurrency,paycurrencyamount,cooperativebanktype,sgl from uf_fn_certificateitems    where requestid = '"+requestid+"' order by to_number(ordernumber) asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String ordernumber = StringHelper.null2String(m4.get("ordernumber"));
			String chargecode = StringHelper.null2String(m4.get("chargecode"));
			String subject = StringHelper.null2String(m4.get("subject"));
			String amount = StringHelper.null2String(m4.get("amount"));
			String text = StringHelper.null2String(m4.get("text"));
			String taxcode = StringHelper.null2String(m4.get("taxcode"));
			String costcenter = StringHelper.null2String(m4.get("costcenter"));
			String internalorder = StringHelper.null2String(m4.get("internalorder"));
			String salesorder = StringHelper.null2String(m4.get("salesorder"));
			String salesorderitem = StringHelper.null2String(m4.get("salesorderitem"));
			String purchaseorder = StringHelper.null2String(m4.get("purchaseorder"));
			String purchaseorderitem = StringHelper.null2String(m4.get("purchaseorderitem"));
			String payterms = StringHelper.null2String(m4.get("payterms"));
			String paydate = StringHelper.null2String(m4.get("paydate"));
			String freezpay = StringHelper.null2String(m4.get("freezpay"));
			String paytype = StringHelper.null2String(m4.get("paytype"));
			String paycurrency = StringHelper.null2String(m4.get("paycurrency"));
			String paycurrencyamount = StringHelper.null2String(m4.get("paycurrencyamount"));
			String cooperativebanktype = StringHelper.null2String(m4.get("cooperativebanktype"));
			String sgl = StringHelper.null2String(m4.get("sgl"));

%>
		<TR id="dataDetail" height="30">
		<TD  class="td2"  align=center><%=ordernumber%></TD>
		<TD  class="td2"  align=center><%=chargecode%></TD>
		<TD  class="td2"  align=center><%=subject%></TD>
		<TD  class="td2"  align=center><%=amount%></TD>
		<TD  class="td2"  align=center><%=text%></TD>
		<TD  class="td2"  align=center><%=taxcode%></TD>
		<TD  class="td2"  align=center><%=costcenter%></TD>
		<TD  class="td2"  align=center><%=internalorder%></TD>
		<TD  class="td2"  align=center><%=salesorder%></TD>
		<TD  class="td2"  align=center><%=salesorderitem%></TD>
		<TD  class="td2"  align=center><%=purchaseorder%></TD>
		<TD  class="td2"  align=center><%=purchaseorderitem%></TD>
		<TD  class="td2"  align=center><%=payterms%></TD>
		<TD  class="td2"  align=center><%=paydate%></TD>
		<TD  class="td2"  align=center><%=freezpay%></TD>
		<TD  class="td2"  align=center><%=paytype%></TD>
		<TD  class="td2"  align=center><%=paycurrency%></TD>
		<TD  class="td2"  align=center><%=paycurrencyamount%></TD>
		<TD  class="td2"  align=center><%=cooperativebanktype%></TD>
		<TD  class="td2"  align=center><%=sgl%></TD>
		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>

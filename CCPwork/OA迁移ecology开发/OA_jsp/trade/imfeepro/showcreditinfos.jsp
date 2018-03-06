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
//String supply = StringHelper.null2String(request.getParameter("supply"));//
//String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//噎榨讗謩薷酄氄杰狄犤?
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//到货类型

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
<table id="dataTables4" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
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
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>记帐码</TD>
<TD  noWrap class="td2"  align=center>科目</TD>
<TD  noWrap class="td2"  align=center>金额</TD>
<TD  noWrap class="td2"  align=center>付款条件</TD>
<TD  noWrap class="td2"  align=center>付款基准日期</TD>
<TD  noWrap class="td2"  align=center>付款冻结</TD>
<TD  noWrap class="td2"  align=center>付款方式</TD>
<TD  noWrap class="td2"  align=center>支付货币</TD>
<TD  noWrap class="td2"  align=center>支付货币金额</TD>
<TD  noWrap class="td2"  align=center>税码</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>

<TD  noWrap class="td2"  align=center>采购订单</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>
<TD  noWrap class="td2"  align=center>合作银行类型</TD>
<TD  noWrap class="td2"  align=center>文本</TD>

</tr>

<%
	//查询数据并显示
	String selsql = "select sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1 from uf_tr_feereceiptinfo where requestid = '"+requestid+"' order by sno asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String sno = StringHelper.null2String(m4.get("sno"));
			String accountcode = StringHelper.null2String(m4.get("accountcode"));
			String subject = StringHelper.null2String(m4.get("subject"));
			String money = StringHelper.null2String(m4.get("money"));
			String payitem = StringHelper.null2String(m4.get("payitem"));
			String paydate = StringHelper.null2String(m4.get("paydate"));
			String payfreeze = StringHelper.null2String(m4.get("payfreeze"));
			String paytype = StringHelper.null2String(m4.get("paytype"));
			String currency = StringHelper.null2String(m4.get("currency"));
			String paymoney = StringHelper.null2String(m4.get("paymoney"));
			String taxcaode = StringHelper.null2String(m4.get("taxcaode"));
			String costcenter = StringHelper.null2String(m4.get("costcenter"));
			String purorderid = StringHelper.null2String(m4.get("purorderid"));
			String purorderitem = StringHelper.null2String(m4.get("purorderitem"));
			String banktype = StringHelper.null2String(m4.get("banktype"));
			String text1 = StringHelper.null2String(m4.get("text1"));

%>
		<TR id="<%="dataDetail_"+sno %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+sno %>" name="sno"><%=sno %></TD>

		<TD  class="td2"   align=center ><%=accountcode %></TD>
		<TD  class="td2"   align=center ><%=subject %></TD>

		<TD   class="td2"  align=center><%=money %></TD>

		<TD   class="td2"  align=center><%=payitem %></TD>
		
		<TD   class="td2"  align=center><%=paydate %></TD>
		<TD   class="td2"  align=center><%=payfreeze %></TD>

		<TD   class="td2"  align=center><%=paytype %></TD>

		<TD  class="td2"   align=center ><%=currency %></TD>
		<TD  class="td2"   align=center ><%=paymoney %></TD>

		<TD   class="td2"  align=center><%=taxcaode %></TD>

		<TD   class="td2"  align=center><%=costcenter %></TD>

		<TD   class="td2"  align=center><%=purorderid %></TD>

		<TD   class="td2"  align=center><%=purorderitem %></TD>
		
		<TD   class="td2"  align=center><%=banktype %></TD>
		<TD   class="td2"  align=center><%=text1 %></TD>

		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>

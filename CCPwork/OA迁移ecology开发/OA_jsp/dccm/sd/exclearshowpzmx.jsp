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
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->


<TABLE id=oTable40285a8d4aff85d1014b004ed3e10e21 class=detailtable border=1>
<COLGROUP>
<COL width="6%">
<COL width="6%" style="display:none">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%"></COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a8d4aff85d1014b004ed3e10e21')" value=-1 type=checkbox name=check_node_all>序号</TD>
<TD noWrap>记账码</TD>
<TD noWrap>总账科目</TD>
<TD noWrap>金额</TD>
<TD noWrap>付款条件</TD>
<TD noWrap>付款基准日期</TD>
<TD noWrap>付款冻结</TD>
<TD noWrap>付款方式</TD>
<TD noWrap>支付货币</TD>
<TD noWrap>支付货币金额</TD>
<TD noWrap>税码</TD>
<TD noWrap>税金基数</TD>
<TD noWrap>成本中心</TD>
<TD noWrap>销售凭证编号</TD>
<TD noWrap>项次</TD>
<TD noWrap>合作银行类型</TD>
<TD noWrap>文本</TD></TR>


<%

	//查询数据并显示
	String selsql = "select sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,sjjs,costcenter,receiptid,receiptitem,banktype,text1 from uf_dmsd_exfeeqzpz where requestid = '"+requestid+"' order by sno asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m5 = (Map)sublist4.get(j);
			String sno = StringHelper.null2String(m5.get("sno"));
			String accountcode = StringHelper.null2String(m5.get("accountcode"));
			String subject = StringHelper.null2String(m5.get("subject"));
			String money = StringHelper.null2String(m5.get("money"));
			String payitem = StringHelper.null2String(m5.get("payitem"));
			String paydate = StringHelper.null2String(m5.get("paydate"));
			String payfreeze = StringHelper.null2String(m5.get("payfreeze"));
			String paytype = StringHelper.null2String(m5.get("paytype"));
			String currency = StringHelper.null2String(m5.get("currency"));
			String paymoney = StringHelper.null2String(m5.get("paymoney"));
			String taxcaode = StringHelper.null2String(m5.get("taxcaode"));
			String sjjs = StringHelper.null2String(m5.get("sjjs"));//税金基数
			String costcenter = StringHelper.null2String(m5.get("costcenter"));
			String receiptid = StringHelper.null2String(m5.get("receiptid"));
			String receiptitem = StringHelper.null2String(m5.get("receiptitem"));
			String banktype = StringHelper.null2String(m5.get("banktype"));
			String text1 = StringHelper.null2String(m5.get("text1"));

%>

		<TR id="<%="dataDetail_"+sno %>" class=DataLight>
		<TD noWrap><input type="checkbox" id="<%="checkbox_"+sno %>" name="sno"><%=sno %></TD>

		<TD noWrap><%=accountcode %></TD>
		
		<TD noWrap><%=subject %></TD>

		<TD noWrap><%=money %></TD>

		<TD noWrap><%=payitem %></TD>
		
		<TD noWrap><%=paydate %></TD>
		
		<TD noWrap><%=payfreeze %></TD>

		<TD noWrap><%=paytype %></TD>

		<TD noWrap><%=currency %></TD>
		
		<TD noWrap><%=paymoney %></TD>

		<TD noWrap><%=taxcaode %></TD>
		
		<TD noWrap><%=sjjs %></TD>

		<TD noWrap><%=costcenter %></TD>

		<TD noWrap><%=receiptid %></TD>

		<TD noWrap><%=receiptitem %></TD>
		
		<TD noWrap><%=banktype %></TD>
		
		<TD noWrap><%=text1 %></TD>

		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</tbody></table>


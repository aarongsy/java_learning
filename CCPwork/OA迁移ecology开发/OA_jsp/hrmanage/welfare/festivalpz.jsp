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
<DIV  id="warpp" style="BORDER-BOTTOM: #000000 0px solid; BORDER-LEFT: #000000 0px solid; WIDTH: 100%; HEIGHT: 400px; OVERFLOW: auto; BORDER-TOP: #000000 0px solid; BORDER-RIGHT: #000000 0px solid">
<!--<div id="warpp" >-->

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border="1" cellSpacing=0 cellPadding=0 style="width:100%;font-size:12" bordercolor="#adae9d">
<CAPTION>节日礼金财务凭证明细</CAPTION>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>记帐码</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>金额</TD>
<TD  noWrap class="td2"  align=center>税码</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>内部订单号</TD>
<TD  noWrap class="td2"  align=center>付款条件</TD>
<TD  noWrap class="td2"  align=center>付款日期</TD>
<TD  noWrap class="td2"  align=center>付款方式</TD>
<TD  noWrap class="td2"  align=center>合作银行</TD>
<TD  noWrap class="td2"  align=center>文本</TD>
</TR>

<%
String sql = "";
int no=0;
	sql = "select t.no,t.jzcode,t.genledger,t.num,t.rate,t.costcenter,t.innerorder,t.payterm,t.paydate,t.paymanner,t.bank,t.paytext from uf_hr_jrcreditdetails t where t.requestid='"+requestid+"' order by no asc" ;

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map map = (Map)sublist.get(k);
		 no=k;
		String no1= StringHelper.null2String(map.get("no"));
		String jzcode = StringHelper.null2String(map.get("jzcode"));
		String pzledgerobj = StringHelper.null2String(map.get("genledger"));
		String pzamount = StringHelper.null2String(map.get("num"));
		String pztax = StringHelper.null2String(map.get("rate")); //税码
		String pzcostcenter = StringHelper.null2String(map.get("costcenter"));
		String pzinnerorder = StringHelper.null2String(map.get("innerorder"));
		String pzpaycondition = StringHelper.null2String(map.get("payterm"));
		String pzpaydate = StringHelper.null2String(map.get("paydate"));
		String pzpayway = StringHelper.null2String(map.get("paymanner"));//付款方式
		String bank = StringHelper.null2String(map.get("bank"));
		String paytext = StringHelper.null2String(map.get("paytext"));//付款方式
		String aa="";
		String bb="";
		String cc="";
	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><%=no1%></TD>
		<TD   class="td2"  align=center><%=jzcode%></TD>
		<TD noWrap><input type="text" id="<%="field_40285a904931f62b014950dd0217317a_"+no%>"  name="<%="field_40285a904931f62b014950dd0217317a_"+no%>"   value="<%=pzledgerobj%>"  ></TD>


		<TD   class="td2"  align=center><%=pzamount%></TD>
		<TD   class="td2"  align=center><%=pztax%></TD>
		<TD   class="td2"  align=center><%=pzcostcenter%></TD>
		<TD   class="td2"  align=center><%=pzinnerorder%></TD>
		<TD   class="td2"  align=center><%=pzpaycondition%></TD>
		<%
		if(pzpayway.equals("40285a904931f62b0149413ed08e024a"))
		{
			aa="selected";
			cc="";
			bb="";
		}
		if(pzpayway.equals("40285a904931f62b0149413ed08e0249"))
		{
			aa="";
			cc="";
			bb="selected";
		}
		if(pzpayway.equals("40285a904a2e9985014a3c9258525291"))
		{
			aa="";
			cc="selected";
			bb="";
		}
		
		%>
		<TD   class="td2"  align=center><%=pzpaydate%></TD>
		<TD   class="td2"  align=center><%=pzpayway%></TD>
		<TD   class="td2"  align=center><%=bank%></TD>
		
		
		
		
		<TD   class="td2"  align=center><%=paytext%></TD>
</TR>
	<%
		}
	}
	else
		{
	%> 
	<TR><TD class="td2" colspan="12">无数据导入</TD></TR>
	<%
		} 
	%>
</table>
</div>

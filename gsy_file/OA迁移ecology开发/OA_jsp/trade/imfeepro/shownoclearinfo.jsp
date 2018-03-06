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

<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
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
<table id="dataTable1" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="60">
<COL width="80">
<COL width="60">
<COL width="80">
<COL width="120">
<COL width="60">
<COL width="80">
<COL width="80">
<COL width="80">
<COL width="120">

</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>客户/供应商标识</TD>
<TD  noWrap class="td2"  align=center>客户/供应商编码</TD>
<TD  noWrap class="td2"  align=center>特殊总账标识</TD>
<TD  noWrap class="td2"  align=center>需清帐凭证编号</TD>
<TD  noWrap class="td2"  align=center>会计年度</TD>
<TD  noWrap class="td2"  align=center>需清帐凭证项次</TD>
<TD  noWrap class="td2"  align=center>清帐剩余金额</TD>
<TD  noWrap class="td2"  align=center>本位币金额</TD>
<TD  noWrap class="td2"  align=center>清帐文本</TD>
</tr>

<%
//String delsql = "delete uf_tr_feenocleatsub where requestid = '"+requestid+"'";
//baseJdbc.update(delsql);
String sql = "select id,requestid,sno,custsuppflag,custsuppcode,ledgerflag,clearreceiptid,fiscalyear,clearreceiptitem,surplusmoney,cleartext,rmbamount from uf_tr_feenocleatsub where requestid = '"+requestid+"' order by sno asc";
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int i = 0;i<sublist.size();i++)
	{
		Map m = (Map)sublist.get(i);
		String no = StringHelper.null2String(m.get("sno"));//序号
		String custsuppflag = StringHelper.null2String(m.get("custsuppflag"));//客户/供应商标识
		String custsuppcode = StringHelper.null2String(m.get("custsuppcode"));//客户/供应商编码
		String ledgerflag = StringHelper.null2String(m.get("ledgerflag"));//特殊总账标识
		String clearreceiptid = StringHelper.null2String(m.get("clearreceiptid"));//需清帐凭证编号
		String fiscalyear = StringHelper.null2String(m.get("fiscalyear"));//会计年度
		String clearreceiptitem = StringHelper.null2String(m.get("clearreceiptitem"));//需清帐凭证项次
		String surplusmoney = StringHelper.null2String(m.get("surplusmoney"));//清帐剩余金额
		String cleartext = StringHelper.null2String(m.get("cleartext"));//清帐文本
		String rmbamount = StringHelper.null2String(m.get("rmbamount"));
	%>
			<TR id="<%="dataDetail_"+no %>">
			<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>
			<TD  class="td2"   align=center ><%=custsuppflag %></TD>
			<TD  class="td2"   align=center ><%=custsuppcode %></TD>
			<TD  class="td2"   align=center ><%=ledgerflag %></TD>

			<TD   class="td2"  align=center><%=clearreceiptid %></TD>

			<TD   class="td2"  align=center><%=fiscalyear %></TD>
			<TD   class="td2"  align=center><%=clearreceiptitem %></TD>
			<TD   class="td2"  align=center><%=surplusmoney %></TD>
			<TD   class="td2"  align=center><%=rmbamount %></TD>
			<TD   class="td2"  align=center><%=cleartext %></TD>
			</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有清帐信息</TD></TR>
<%} %>
</table>
</div>

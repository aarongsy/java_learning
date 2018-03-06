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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
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
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>记账码</TD>
<TD  noWrap class="td2"  align=center>科目</TD>
<TD  noWrap class="td2"  align=center>税码</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>采购订单</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>
<TD  noWrap class="td2"  align=center>文本</TD>
</tr>

<%
String sql2 = " select sno,accountcode,subject,taxcode,estamount,estcurrency,costcenter,purorder,purorderitem,text1,flag from uf_tr_imfeedtitem where requestid = '"+requestid+"' order by sno asc";
List sublist2 = baseJdbc.executeSqlForList(sql2);
if(sublist2.size()>0){
	for(int k=0,sizek=sublist2.size();k<sizek;k++){
		Map mk = (Map)sublist2.get(k);
		int m = k;
		int no=m+1;
		String accountcode = StringHelper.null2String(mk.get("accountcode"));//记账码
		String subject=StringHelper.null2String(mk.get("subject"));//总账科目
		String taxcode=StringHelper.null2String(mk.get("taxcode"));//税码
		String estamount=StringHelper.null2String(mk.get("estamount"));//暂估金额
		String estcurrency=StringHelper.null2String(mk.get("estcurrency"));//暂估币种

		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心

		String purorder=StringHelper.null2String(mk.get("purorder"));//采购订单号
		String purorderitem=StringHelper.null2String(mk.get("purorderitem"));//采购订单项次


		String text1=StringHelper.null2String(mk.get("text1"));//文本
		String flag=StringHelper.null2String(mk.get("flag"));//标识

	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>

		<TD  class="td2"   align=center ><%=accountcode %></TD>
		<TD  class="td2"   align=center ><%=subject %></TD>

		<TD   class="td2"  align=center><%=taxcode %></TD>

		<TD   class="td2"  align=center><%=estamount %></TD>
		<TD   class="td2"  align=center><%=estcurrency %></TD>
		<TD   class="td2"  align=center><%=costcenter %></TD>
		
		<TD   class="td2"  align=center><%=purorder %></TD>
		<TD   class="td2"  align=center><%=purorderitem %></TD>

		<TD   class="td2"  align=center><%=text1 %></TD>
		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>

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
<!--%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %-->
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<!--%@ page import="com.eweaver.app.configsap.SapSync"%-->
<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String expno = StringHelper.null2String(request.getParameter("expno"));
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
<COL width="25%">
<COL width="25%">
<COL width="25%">
<COL width="25%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>Serial NO</TD><!--序号-->
<TD  noWrap class="td2"  align=center>Container Type</TD><!--柜型-->
<TD  noWrap class="td2"  align=center>Container Quantity</TD><!--柜数-->
</TR>

<%
String sql= "select a.sno,a.cabtype,a.cabno from uf_dmsd_exfeekjpag a where a.requestid='"+requestid+"' order by a.sno asc";



//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		String sno=StringHelper.null2String(mk.get("sno"));//序号
		String cabtype=StringHelper.null2String(mk.get("cabtype"));//柜型
		String cabno=StringHelper.null2String(mk.get("cabno"));//柜数
%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center ><%=sno%></TD>
		<TD noWrap  class="td2"  align=center><%=cabtype%></TD>
		<TD noWrap  class="td2"  align=center><%=cabno %></TD>
		</TR>
<%
	}
}
else
{
%> 
		<TR><TD class="td2" colspan="12">NO Message!</TD></TR>
<%
} 
%>
</table>
</div>

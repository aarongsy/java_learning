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
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="10%">
<COL width="7%">
</COLGROUP>
<TR height="25"  class="title">

<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>线路编号</TD>
<TD  noWrap class="td2"  align=center>线路名称</TD>
<TD  noWrap class="td2"  align=center>运输类型</TD>


<TD  noWrap class="td2"  align=center>启运港</TD>
<TD  noWrap class="td2"  align=center>启运港(城市)</TD>
<TD  noWrap class="td2"  align=center>目的港</TD>
<TD  noWrap class="td2"  align=center>目的港(城市)</TD>

<TD  noWrap class="td2"  align=center>柜型</TD>
<TD  noWrap class="td2"  align=center>危普区分</TD>
<TD  noWrap class="td2"  align=center>危化等级</TD>

<TD  noWrap class="td2"  align=center>要求</TD>
<TD  noWrap class="td2"  align=center>预计柜量</TD>

</tr>

<%

String sql ="";

	sql= "select sno,lineno,linename,linetype,trantype,hxarea,qygang,qycity,mdgang,mdcity,tranvech,gx,danger,dangerlv,pricetype,stone,etone,require,pro,gl from uf_lo_xunjiasub   a where a.requestid='"+requestid+"' order by a.sno asc";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);

		String sno=StringHelper.null2String(mk.get("sno"));
		String lineno=StringHelper.null2String(mk.get("lineno"));
		String linename=StringHelper.null2String(mk.get("linename"));
		String trantype=StringHelper.null2String(mk.get("trantype"));
		String qycity=StringHelper.null2String(mk.get("qycity"));
		String qygang=StringHelper.null2String(mk.get("qygang"));
		String mdgang=StringHelper.null2String(mk.get("mdgang"));
		String mdcity=StringHelper.null2String(mk.get("mdcity"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String danger=StringHelper.null2String(mk.get("danger"));


		String dangerlv=StringHelper.null2String(mk.get("dangerlv"));
		String require=StringHelper.null2String(mk.get("require"));

		String gl=StringHelper.null2String(mk.get("gl"));

	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center ><%=sno %></TD>
		<TD noWrap  class="td2"  align=center ><%=lineno %></TD>
		<TD noWrap  class="td2"  align=center ><%=linename %></TD>
		<TD noWrap  class="td2"  align=center ><%=trantype %></TD>
		<TD noWrap  class="td2"  align=center><%=qygang %></TD>
		<TD noWrap  class="td2"  align=center ><%=qycity %></TD>
		<TD noWrap  class="td2"  align=center><%=mdgang %></TD>
		<TD noWrap  class="td2"  align=center><%=mdcity %></TD>
		<TD noWrap  class="td2"  align=center><%=gx %></TD>
		<TD noWrap  class="td2"  align=center><%=danger %></TD>

		<TD noWrap  class="td2"  align=center><%=dangerlv %></TD>
		<TD noWrap  class="td2"  align=center><%=require %></TD>
		<TD noWrap  class="td2"  align=center><%=gl %></TD>
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="13">没有信息</TD></TR>
<%} %>
</table>
</div>

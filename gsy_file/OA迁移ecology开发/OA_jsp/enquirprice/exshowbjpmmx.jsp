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
<table id="pmdataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="9%">
<COL width="13%">
<COL width="13%">
<COL width="13%">
<COL width="13%">
<COL width="13%">
<COL width="13%">
<COL width="13%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;序号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;航线区域&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;柜型&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;供应商简码&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;供应商名称&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;供应商OA账号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;排名&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center >&nbsp;&nbsp;议价单&nbsp;&nbsp;</TD>
</TR>
<%

String sql ="";

	sql= "select id,sno,(select objno from humres where id=supcode)as supcode,supname,supacc,pm,hxarea,gxty from uf_tr_bijiahx a where a.requestid='"+requestid+"' order by a.sno asc";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);

		String id=StringHelper.null2String(mk.get("id"));
		String sno=StringHelper.null2String(mk.get("sno"));
		String supcode=StringHelper.null2String(mk.get("supcode"));
		String supname=StringHelper.null2String(mk.get("supname"));
		String supacc=StringHelper.null2String(mk.get("supacc"));
		String pm=StringHelper.null2String(mk.get("pm"));
		String hxarea=StringHelper.null2String(mk.get("hxarea"));
		String gxty=StringHelper.null2String(mk.get("gxty"));

	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=sno %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hxarea %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gxty %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=supcode %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=supname %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=supcode %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=pm %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center><A href="javascript:newyj('<%=id%>','<%=hxarea %>','<%=gxty %>');"><FONT color=#ff0000>创建议价单</FONT></A></TD>


		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="7">没有信息</TD></TR>
<%} 


%>
</table>
</div>

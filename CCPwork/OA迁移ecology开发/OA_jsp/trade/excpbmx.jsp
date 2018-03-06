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
<COL width="7%">
<COL width="7%">
<COL width="7%">
</COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap>序号</TD>
<TD noWrap>船期</TD>
<TD noWrap>托书编号</TD>
<TD noWrap>柜型</TD>
<TD noWrap>产品</TD>
<TD noWrap>目的港</TD>
<TD noWrap>货运代理</TD>
<TD noWrap>柜量</TD>
<TD noWrap>清账日期</TD>
<TD noWrap>USD海运费</TD>
<TD noWrap>USD灌箱费</TD>
<TD noWrap>USD包干费</TD>
<TD noWrap>RMB货运费及其他</TD>
<TD noWrap>RMB拖车费</TD></TR>
<%

String sql ="";

	sql= "select sno,bdate,expno,gx,cp,mdg,hycode,gl,cdate,hyfee,fjfee,bgfee,tcfee,(select describe from uf_tr_gkwhd where requestid=a.mdg) as mdgang,huoyfee from uf_tr_cpbglsub a where a.requestid='40285a905bcd9dcd015bd7495aa44256' order by a.expno";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);

		String sno=StringHelper.null2String(mk.get("sno"));
		String bdate=StringHelper.null2String(mk.get("bdate"));
		String expno=StringHelper.null2String(mk.get("expno"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String cp=StringHelper.null2String(mk.get("cp"));
		String mdg=StringHelper.null2String(mk.get("mdgang"));
		String hycode=StringHelper.null2String(mk.get("hycode"));
		String gl=StringHelper.null2String(mk.get("gl"));
		String cdate=StringHelper.null2String(mk.get("cdate"));

		String hyfee=StringHelper.null2String(mk.get("hyfee"));
		String fjfee=StringHelper.null2String(mk.get("fjfee"));
		String gbfee=StringHelper.null2String(mk.get("bgfee"));
		String tcfee=StringHelper.null2String(mk.get("tcfee"));
		String huoyfee=StringHelper.null2String(mk.get("huoyfee"));



	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=k+1 %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=bdate %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=expno %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gx %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=cp %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdg %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hycode %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gl %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=cdate %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hyfee %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=fjfee%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gbfee%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=huoyfee%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=tcfee%>&nbsp;&nbsp;</TD>
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="14">没有信息</TD></TR>
<%} %>
</TBODY>

</table>
</div>

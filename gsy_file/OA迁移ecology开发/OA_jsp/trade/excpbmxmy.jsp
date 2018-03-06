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
String hl=StringHelper.null2String(request.getParameter("hl"));
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
<COL width="10%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
</COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap>序号</TD>
<TD noWrap>船期</TD>
<TD noWrap>目的港</TD>
<TD noWrap>柜型</TD>
<TD noWrap>产品</TD>
<TD noWrap>柜量</TD>
<TD noWrap>运费（USD）</TD>
<%

String sql ="";

	sql= "select bdate,gx,cp,mdg,sum(gl) gl,sum(nvl(hyfee,0)+nvl(fjfee,0)+nvl(bgfee,0)) hyfee,sum(nvl(huoyfee,0)+nvl(tcfee,0)) rmbfee,b.describe as mdgang from uf_tr_cpbglsub a left join uf_tr_gkwhd b on a.mdg=b.requestid where a.requestid is null group by bdate,gx,cp,mdg,b.describe order by bdate,b.describe,gx,cp asc";

System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);

		String bdate=StringHelper.null2String(mk.get("bdate"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String cp=StringHelper.null2String(mk.get("cp"));
		String mdg=StringHelper.null2String(mk.get("mdgang"));
		String gl=StringHelper.null2String(mk.get("gl"));

		String hyfee=StringHelper.null2String(mk.get("hyfee"));
		String rmbfee=StringHelper.null2String(mk.get("rmbfee"));

		Double total=Double.valueOf(hyfee)+Double.valueOf(rmbfee)/Double.valueOf(hl);
		DecimalFormat df = new DecimalFormat("#0.00");   
		String usdtotal = df.format(total); 

	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=k+1 %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=bdate %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdg %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gx %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=cp %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gl %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=usdtotal %>&nbsp;&nbsp;</TD>
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="7">没有信息</TD></TR>
<%} %>
</TBODY>

</table>
</div>

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
<table id="bjdataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
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
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;序号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;线路编号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;线路名称&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;运输类型&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;启运港&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;启运港(城市点)&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;目的港&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;目的港(城市点)&nbsp;&nbsp;</TD>

<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;柜型&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;危普区分&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;危险品等级&nbsp;&nbsp;</TD>

<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;承运商简码&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;承运商名称&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;海运费报价&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;海运费抵扣税率&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;TANK箱加热费&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;加热费抵扣税率&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;合计未税金额&nbsp;&nbsp;</TD>

<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Rank&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;要求&nbsp;&nbsp;</TD>

<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;预计柜量&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;REMARK&nbsp;&nbsp;</TD>
</TR>

<%

String sql ="";

	sql= "select a.sno,a.lineno,a.linename,a.linetype,a.trantype,a.hxarea,a.qygang,a.gycity,a.mdgang,a.mdcity,a.vehicle,a.gx,a.danger,a.dangerlv,a.pritype,a.stone,a.etone,a.requir,a.gxfee,a.gl,a.sl,a.timee,a.price,a.baojia,a.hyfee,a.jrfe,a.total,a.curr,a.boat,a.remark,(select objno from humres where id=a.supcode) supcode,(select objname from humres where id=a.supcode) supname,dense_rank() over(partition by a.linename,a.mdgang,gx,danger,requir order by total) dense_rank from uf_lo_bijiadetail a where a.requestid='"+requestid+"' order by a.sno asc";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);

		String sno=StringHelper.null2String(mk.get("sno"));
		String lineno=StringHelper.null2String(mk.get("lineno"));
		String linename=StringHelper.null2String(mk.get("linename"));
		String linetype=StringHelper.null2String(mk.get("linetype"));
		String trantype=StringHelper.null2String(mk.get("trantype"));
		String hxarea=StringHelper.null2String(mk.get("hxarea"));
		String qygang=StringHelper.null2String(mk.get("qygang"));
		String gycity=StringHelper.null2String(mk.get("gycity"));
		String mdgang=StringHelper.null2String(mk.get("mdgang"));
		String mdcity=StringHelper.null2String(mk.get("mdcity"));
		String vehicle=StringHelper.null2String(mk.get("vehicle"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String danger=StringHelper.null2String(mk.get("danger"));
		String dangerlv=StringHelper.null2String(mk.get("dangerlv"));
		String pritype=StringHelper.null2String(mk.get("pritype"));
		String stone=StringHelper.null2String(mk.get("stone"));
		String etone=StringHelper.null2String(mk.get("etone"));
		String requir=StringHelper.null2String(mk.get("requir"));
		String gxfee=StringHelper.null2String(mk.get("gxfee"));
		String gl=StringHelper.null2String(mk.get("gl"));
		String sl=StringHelper.null2String(mk.get("sl"));
		String timee=StringHelper.null2String(mk.get("timee"));
		String price=StringHelper.null2String(mk.get("price"));
		String baojia=StringHelper.null2String(mk.get("baojia"));
		String curr=StringHelper.null2String(mk.get("curr"));
		String boat=StringHelper.null2String(mk.get("boat"));
		String dense_rank=StringHelper.null2String(mk.get("dense_rank"));
		String remark=StringHelper.null2String(mk.get("remark"));
		String supcode=StringHelper.null2String(mk.get("supcode"));
		String supname=StringHelper.null2String(mk.get("supname"));
		String hyfee=StringHelper.null2String(mk.get("hyfee"));
		String jrfee=StringHelper.null2String(mk.get("jrfe"));
		String total=StringHelper.null2String(mk.get("total"));



	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=sno %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=lineno %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=linename %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=trantype %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=qygang %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gycity %>&nbsp;&nbsp;</TD>

		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdgang %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdcity %>&nbsp;&nbsp;</TD>

		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gx%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=danger%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=dangerlv%>&nbsp;&nbsp;</TD>


		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=supcode%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=supname%>&nbsp;&nbsp;</TD>


		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=price%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hyfee%>%&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=baojia%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=jrfee%>%&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=total%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=dense_rank%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=requir%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gl%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=remark%>&nbsp;&nbsp;</TD>
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="18">没有信息</TD></TR>
<%} %>
</table>
</div>

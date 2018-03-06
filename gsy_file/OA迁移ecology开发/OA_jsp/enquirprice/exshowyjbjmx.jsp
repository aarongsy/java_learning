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
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">

</COLGROUP>
<TR height="25"  class="title">

<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;序号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;柜型&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;危普区分&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;危化等级&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;航线区域&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;航线&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;启运港&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;目的港&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;要求&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;产品&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;预估柜量&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center colspan=12>USD费用(A)</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;船公司&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;船期&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center rowspan=2>&nbsp;&nbsp;报价合计金额&nbsp;&nbsp;</TD>
</TR>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;海运费&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;罐箱费&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;BAF&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;YAS&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;GBF&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;CAF&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;EBS&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;CIC&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;ENS&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;AMS&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;RCS&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;PSS&nbsp;&nbsp;</TD>


</TR>

<%

String sql ="";

	sql= "select sno,gx,isdanger,dengerllv,hxarea,hx,qygang,mdgang,equair,pro,hyfee,gxfee,baf,yas,gbf,caf,ebs,cic,ens,ams,rcs,pss,days21,days30,days45,days60,shipcom,shipdate,bjsum,gl,yujiprice from uf_tr_yjbjsub a where a.requestid='"+requestid+"' order by a.sno asc";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String sno=StringHelper.null2String(mk.get("sno"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String isdanger=StringHelper.null2String(mk.get("isdanger"));
		String dengerllv=StringHelper.null2String(mk.get("dengerllv"));
		String hxarea=StringHelper.null2String(mk.get("hxarea"));
		String hx=StringHelper.null2String(mk.get("hx"));
		String qygang=StringHelper.null2String(mk.get("qygang"));
		String mdgang=StringHelper.null2String(mk.get("mdgang"));
		String equair=StringHelper.null2String(mk.get("equair"));
		String pro=StringHelper.null2String(mk.get("pro"));
		String hyfee=StringHelper.null2String(mk.get("hyfee"));
		String gxfee=StringHelper.null2String(mk.get("gxfee"));
		String baf=StringHelper.null2String(mk.get("baf"));
		String yas=StringHelper.null2String(mk.get("yas"));
		String gbf=StringHelper.null2String(mk.get("gbf"));
		String caf=StringHelper.null2String(mk.get("caf"));
		String ebs=StringHelper.null2String(mk.get("ebs"));
		String cic=StringHelper.null2String(mk.get("cic"));
		String ens=StringHelper.null2String(mk.get("ens"));
		String ams=StringHelper.null2String(mk.get("ams"));
		String rcs=StringHelper.null2String(mk.get("rcs"));
		String pss=StringHelper.null2String(mk.get("pss"));
		String days21=StringHelper.null2String(mk.get("days21"));
		String days30=StringHelper.null2String(mk.get("days30"));
		String days45=StringHelper.null2String(mk.get("days45"));
		String days60=StringHelper.null2String(mk.get("days60"));
		String shipcom=StringHelper.null2String(mk.get("shipcom"));
		String shipdate=StringHelper.null2String(mk.get("shipdate"));
		String bjsum=StringHelper.null2String(mk.get("bjsum"));
		String gl=StringHelper.null2String(mk.get("gl"));
		String yujiprice=StringHelper.null2String(mk.get("yujiprice"));


	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=sno %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gx %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=isdanger %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=dengerllv %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hxarea %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hx %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=qygang %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdgang %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=equair %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=pro %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gl%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hyfee%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gxfee%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=baf%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=yas%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gbf%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=caf%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=ebs%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=cic%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=ens%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=ams%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=rcs%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=pss%>&nbsp;&nbsp;</TD>

		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=shipcom%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=shipdate%>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=bjsum%>&nbsp;&nbsp;</TD>
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="31">没有信息</TD></TR>
<%} %>
</table>
</div>

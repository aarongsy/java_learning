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
<COL width="3%" style="display:none">
<COL width="3%" style="display:none">
</COLGROUP>
<thead> 
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center><INPUT id=check_node_all onclick="selectAll1()"  type=checkbox name=check_node_all>序号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;线路编号&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;线路名称&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;运输类型&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;启运港&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;启运港(城市点)&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;目的港&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;目的港(城市点)&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;柜型&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;危普区分&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;危化等级&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;海运费报价&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;TANK箱加热费&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;要求&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;预计柜量&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;remark&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>询价requestid</TD>
<TD  noWrap class="td2"  align=center>是否复制</TD>
</TR>
</thead> 
<tbody>
<%

String sql ="";

	sql= "select sno,lineno,linename,trantype,qygang,gycity,mdgang,mdcity,vehicle,gx,danger,dangerlv,requir,gxfee,gl,xjrequstid,yl,sl,timee,price,baojia,curr,boat,remark from uf_lo_baojiachild a where a.requestid='"+requestid+"' order by a.sno asc";

//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);

		String sno=StringHelper.null2String(mk.get("sno"));

		String lineno=StringHelper.null2String(mk.get("lineno"));
		String linename=StringHelper.null2String(mk.get("linename"));
		String trantype=StringHelper.null2String(mk.get("trantype"));
		String qygang=StringHelper.null2String(mk.get("qygang"));
		String gycity=StringHelper.null2String(mk.get("gycity"));
		String mdgang=StringHelper.null2String(mk.get("mdgang"));
		String mdcity=StringHelper.null2String(mk.get("mdcity"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String danger=StringHelper.null2String(mk.get("danger"));
		String dangerlv=StringHelper.null2String(mk.get("dangerlv"));
		String requir=StringHelper.null2String(mk.get("requir"));
		String gxfee=StringHelper.null2String(mk.get("gxfee"));
		String gl=StringHelper.null2String(mk.get("gl"));

		String price=StringHelper.null2String(mk.get("price"));
		String baojia=StringHelper.null2String(mk.get("baojia"));
		String boat=StringHelper.null2String(mk.get("boat"));
		String remark=StringHelper.null2String(mk.get("remark"));

		String xjrequstid=StringHelper.null2String(mk.get("xjrequstid"));
		String yl=StringHelper.null2String(mk.get("yl"));
		String sl=StringHelper.null2String(mk.get("sl"));
		String timee=StringHelper.null2String(mk.get("timee"));
		String curr=StringHelper.null2String(mk.get("curr"));

	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center ><input type="checkbox" name="check_node" value="<%=sno%>"><%=sno %>&nbsp;&nbsp;</TD>

		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=lineno %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=linename %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=trantype %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=qygang %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gycity %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdgang %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=mdcity %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gx %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=danger %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=dangerlv %>&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<input type="text" id="<%="price_"+k%>" value="<%=price%>" onblur="changeprice('<%=sno%>','<%=k%>')">&nbsp;&nbsp;</TD>


		<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<input type="text" id="<%="baojia_"+k%>" value="<%=baojia%>" onblur="changebaojia('<%=sno%>','<%=k%>')">&nbsp;&nbsp;</TD>
		<!--TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<input type="text" id="<%="boat_"+k%>" value="<%=boat%>" onblur="changeboat('<%=sno%>','<%=k%>')">&nbsp;&nbsp;</TD-->
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=requir %>&nbsp;&nbsp;</TD>
		
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=gl %>&nbsp;&nbsp;</TD>

		<!--TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<input type="text" id="<%="sl_"+k%>" value="<%=sl%>" onblur="changesl('<%=sno%>','<%=k%>')">&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp; <input type="text" id="<%="timee_"+k%>" value="<%=timee%>" onblur="changetimee('<%=sno%>','<%=k%>')">&nbsp;&nbsp;<img src="/images/base/checkinput.gif" align=absMiddle></TD>

		<TD noWrap  class="td2"  align=center><button type=button  class=Browser id="<%="button_"+k%>" name="button" onclick="javascript:getrefobj('<%="curr_"+k%>','<%="curr_"+k+"span"%>','40285a8d4b7b329a014b901561675ec5','','','1');changecurr('<%=sno%>','<%=k%>');"></button><input type="hidden" id="<%="curr_"+k%>" value="<%=curr%>"><span id="<%="curr_"+k+"span"%>" name="<%="curr_"+k+"span"%>" ><%=curr%></span></TD-->
		
		<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<input type="text" id="<%="remark_"+k%>" value="<%=remark%>" onblur="changeremark('<%=sno%>','<%=k%>')">&nbsp;&nbsp;</TD>
		<TD noWrap  class="td2"  align=center><%=xjrequstid %></TD>
		<TD noWrap  class="td2"  align=center><%=yl %></TD>
		</TR>
	<%
		}

}else{%> 
	<TR><TD class="td2" colspan="16">没有信息</TD></TR>
<%} %>
</tbody>
</table>
</div>

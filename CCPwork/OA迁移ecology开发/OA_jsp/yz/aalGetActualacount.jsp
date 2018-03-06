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

<%
String date1 = StringHelper.null2String(request.getParameter("date1"));
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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">


	    <TR height="25"  class="title">
		<TD class="td2"  align=center>日期</TD>
		<TD class="td2"  align=center>ITEM</TD>
		<TD class="td2"  align=center>AAL产量(日报表)</TD>
		<TD class="td2"  align=center>AAL产量(实际)</TD>
		<TD class="td2"  align=center>TK-601回收量</TD>
		<TD class="td2"  align=center>TK-601 AAL浓度</TD>
		<TD class="td2"  align=center>AAL累积量(1)</TD>
		<TD class="td2"  align=center>TK-603回收量</TD>
		<TD class="td2"  align=center>TK-603 AAL浓度</TD>
		<TD class="td2"  align=center>AAL累积量(3)</TD>
		<TD class="td2"  align=center>TK-605回收量</TD>
		<TD class="td2"  align=center>TK-605 AAL浓度</TD>
		<TD class="td2"  align=center>AAL累积量(4)</TD>

		</TR>
		<TR>
		<TD class="td2"  align=center>&nbsp;</TD>
		<TD class="td2"  align=center>&nbsp;</TD>
		<TD class="td2"  align=center>Ton</TD>
		<TD class="td2"  align=center>Ton</TD>
		<TD class="td2"  align=center>Ton/Day</TD>
		<TD class="td2"  align=center>%</TD>
		<TD class="td2"  align=center>Ton</TD>
		<TD class="td2"  align=center>Ton/Day</TD>
		<TD class="td2"  align=center>%</TD>
		<TD class="td2"  align=center>Ton</TD>
		<TD class="td2"  align=center>Ton/Day</TD>
		<TD class="td2"  align=center>%</TD>
		<TD class="td2"  align=center>Ton</TD>
		</TR>
<%
String sql = "";

	sql = "select a.item ,a.F1301,a.F1309,a.F1308,a.F1371,a.P1208,a.A1508,a.PD1207,a.F1322,a.A1503,a.F1501,a.A1570,a.F2327,a.T1107,a.T1110,a.T1111,a.T1104,a.F4310,a.PC1248,a.A4570,a.A3571,a.F1314,a.F1313,a.F2313,a.V105,a.P1205 from uf_yzaalaverage a where a.nowdate='"+date1+"'  and item <> '0:00:00' order by nowdate";

List sublist = baseJdbc.executeSqlForList(sql);
int no=sublist.size();
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String item =StringHelper.null2String(mk.get("item"));
		String col1=StringHelper.null2String(mk.get("F1301"));
		String col2=StringHelper.null2String(mk.get("F1309"));
		String col3=StringHelper.null2String(mk.get("F1308"));
		String col4=StringHelper.null2String(mk.get("F1371"));
		String col5=StringHelper.null2String(mk.get("P1208"));
		String col6=StringHelper.null2String(mk.get("A1508"));
		String col7=StringHelper.null2String(mk.get("PD1207"));
		String col8=StringHelper.null2String(mk.get("F1322"));
		String col9=StringHelper.null2String(mk.get("A1503"));
		String col10=StringHelper.null2String(mk.get("F1501"));
		String col11=StringHelper.null2String(mk.get("A1570"));
		String col12=StringHelper.null2String(mk.get("F2327"));
		String col13=StringHelper.null2String(mk.get("T1107"));
		String col14=StringHelper.null2String(mk.get("T1110"));
		String col15=StringHelper.null2String(mk.get("T1111"));
		String col16=StringHelper.null2String(mk.get("T1104"));
		String col17=StringHelper.null2String(mk.get("F4310"));
		String col18=StringHelper.null2String(mk.get("PC1248"));
		String col19=StringHelper.null2String(mk.get("A4570"));
		String col20=StringHelper.null2String(mk.get("A3571"));
		String col21=StringHelper.null2String(mk.get("F1314"));
		String col22=StringHelper.null2String(mk.get("F1313"));
		String col23=StringHelper.null2String(mk.get("F2313"));
		String col24=StringHelper.null2String(mk.get("V105"));
		String col25=StringHelper.null2String(mk.get("P1205"));

	%>

		<TR>
		<TD   class="td2"  align=center><%=item %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col1_"+k%>" style="width:80%" value="<%=col1%>"><span id="<%="col1_"+k+"span"%>"><%=col1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col2_"+k%>" style="width:80%" value="<%=col2%>"><span id="<%="col2_"+k+"span"%>"><%=col2%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col3_"+k%>" style="width:80%" value="<%=col3%>"><span id="<%="col3_"+k+"span"%>"><%=col3%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col4_"+k%>" style="width:80%" value="<%=col4%>"><span id="<%="col4_"+k+"span"%>"><%=col4%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col5_"+k%>" style="width:80%" value="<%=col5%>"><span id="<%="col5_"+k+"span"%>"><%=col5%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col6_"+k%>" style="width:80%" value="<%=col6%>"><span id="<%="col6_"+k+"span"%>"><%=col6%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col7_"+k%>" style="width:80%" value="<%=col7%>"><span id="<%="col7_"+k+"span"%>"><%=col7%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col8_"+k%>" style="width:80%" value="<%=col8%>"><span id="<%="col8_"+k+"span"%>"><%=col8%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col9_"+k%>" style="width:80%" value="<%=col9%>"><span id="<%="col9_"+k+"span"%>"><%=col9%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col10_"+k%>" style="width:80%" value="<%=col10%>"><span id="<%="col10_"+k+"span"%>"><%=col10%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col11_"+k%>" style="width:80%" value="<%=col11%>"><span id="<%="col11_"+k+"span"%>"><%=col11%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col12_"+k%>" style="width:80%" value="<%=col12%>"><span id="<%="col12_"+k+"span"%>"><%=col12%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col13_"+k%>" style="width:80%" value="<%=col13%>"><span id="<%="col13_"+k+"span"%>"><%=col13%></span></TD>

		</TR>

		

	
<%
	}
}else{%> 
	<TR><TD class="td2" colspan="13">无数据!</TD></TR>
<%} %>
</table>
</div>

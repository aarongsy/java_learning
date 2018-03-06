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
    width:600px;
} 


</style>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width:2000px;font-size:12" bordercolor="#adae9d">


	    <TR height="25"  class="title">
		<TD class="td2"  align=center>记录点</TD>
		<TD class="td2"  align=center>F-1301</TD>
		<TD class="td2"  align=center>F-1309</TD>
		<TD class="td2"  align=center>F-1308</TD>
		<TD class="td2"  align=center>F-1371</TD>
		<TD class="td2"  align=center>P-1208</TD>
		<TD class="td2"  align=center>A-1508</TD>
		<TD class="td2"  align=center>Pd-1207</TD>
		<TD class="td2"  align=center>F-1322</TD>
		<TD class="td2"  align=center>A-1503</TD>
		<TD class="td2"  align=center>F-1501</TD>
		<TD class="td2"  align=center>A-1570</TD>
		<TD class="td2"  align=center>F-2327</TD>
		<TD class="td2"  align=center>T-1107</TD>
		<TD class="td2"  align=center>T-1110</TD>
		<TD class="td2"  align=center>T-1111</TD>
		<TD class="td2"  align=center>T-1114</TD>
		<TD class="td2"  align=center>F-4310</TD>
		<TD class="td2"  align=center>PC-1248</TD>
		<TD class="td2"  align=center>A-4570</TD>
		<TD class="td2"  align=center>A-3571</TD>
		<TD class="td2"  align=center>F-1314</TD>
		<TD class="td2"  align=center>F-1313</TD>
		<TD class="td2"  align=center>F-2313</TD>
		<TD class="td2"  align=center>V-105</TD>
		<TD class="td2"  align=center>P-1205</TD>

		</TR>
		<TR>
		<TD class="td2"  align=center>&nbsp;</TD>
		<TD class="td2"  align=center>02进料量</TD>
		<TD class="td2"  align=center>AA</TD>
		<TD class="td2"  align=center>AA</TD>
		<TD class="td2"  align=center>AA</TD>
		<TD class="td2"  align=center>反应器壳侧压力</TD>
		<TD class="td2"  align=center>02浓度-入口</TD>
		<TD class="td2"  align=center>反应器压差</TD>
		<TD class="td2"  align=center>循环气流量</TD>
		<TD class="td2"  align=center>02浓度-出口</TD>
		<TD class="td2"  align=center>C02浓度</TD>
		<TD class="td2"  align=center>C3H6浓度</TD>
		<TD class="td2"  align=center>C02排放量</TD>
		<TD class="td2"  align=center>醋酸蒸发器浓度</TD>
		<TD class="td2"  align=center>反应器壳侧温度</TD>
		<TD class="td2"  align=center>反应器出口温度</TD>
		<TD class="td2"  align=center>反应器入口温度</TD>
		<TD class="td2"  align=center>Light-End</TD>
		<TD class="td2"  align=center>醋酸钾注入喷嘴压力</TD>
		<TD class="td2"  align=center>AAL含水量</TD>
		<TD class="td2"  align=center>T305循环醋酸含水量</TD>
		<TD class="td2"  align=center>V-124 0 Flow</TD>
		<TD class="td2"  align=center>V-123 W Flow</TD>
		<TD class="td2"  align=center>循环气排放量</TD>
		<TD class="td2"  align=center>醋酸钾液位消耗</TD>
		<TD class="td2"  align=center>反应器入口压力</TD>
		</TR>
<%
String sql = "";

	sql = "select a.item ,a.F1301,a.F1309,a.F1308,a.F1371,a.P1208,a.A1508,a.PD1207,a.F1322,a.A1503,a.F1501,a.A1570,a.F2327,a.T1107,a.T1110,a.T1111,a.T1104,a.F4310,a.PC1248,a.A4570,a.A3571,a.F1314,a.F1313,a.F2313,a.V105,a.P1205 from uf_yzaalaverage a where a.nowdate='"+date1+"'  and item <> '0:00:00' order by nowdate";

List sublist = baseJdbc.executeSqlForList(sql);
int no=sublist.size();
int no1=0;
float sum1=0,sum2=0,sum3=0,sum4=0,sum5=0,sum6=0,sum7=0,sum8=0,sum9=0,sum10=0,sum11=0,sum12=0,sum13=0,sum14=0,sum15=0,sum16=0,sum17=0,sum18=0,sum19=0,sum20=0,sum21=0,sum22=0,sum23=0,sum24=0,sum25=0;

if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String item =StringHelper.null2String(mk.get("item"));
		String col1=StringHelper.null2String(mk.get("F1301"));
		sum1 +=Float.parseFloat(StringHelper.null2String(mk.get("F1301")));
		String col2=StringHelper.null2String(mk.get("F1309"));
		sum2 +=Float.parseFloat(StringHelper.null2String(mk.get("F1309")));
		String col3=StringHelper.null2String(mk.get("F1308"));
		sum3 +=Float.parseFloat(StringHelper.null2String(mk.get("F1308")));
		String col4=StringHelper.null2String(mk.get("F1371"));
		sum4 +=Float.parseFloat(StringHelper.null2String(mk.get("F1371")));
		String col5=StringHelper.null2String(mk.get("P1208"));
		sum5 +=Float.parseFloat(StringHelper.null2String(mk.get("P1208")));
		String col6=StringHelper.null2String(mk.get("A1508"));
		sum6 +=Float.parseFloat(StringHelper.null2String(mk.get("A1508")));
		String col7=StringHelper.null2String(mk.get("PD1207"));
		sum7 +=Float.parseFloat(StringHelper.null2String(mk.get("PD1207")));
		String col8=StringHelper.null2String(mk.get("F1322"));
		sum8 +=Float.parseFloat(StringHelper.null2String(mk.get("F1322")));
		String col9=StringHelper.null2String(mk.get("A1503"));
		sum9 +=Float.parseFloat(StringHelper.null2String(mk.get("A1503")));
		String col10=StringHelper.null2String(mk.get("F1501"));
		sum10 +=Float.parseFloat(StringHelper.null2String(mk.get("F1501")));
		String col11=StringHelper.null2String(mk.get("A1570"));
		sum11 +=Float.parseFloat(StringHelper.null2String(mk.get("A1570")));
		String col12=StringHelper.null2String(mk.get("F2327"));
		sum12 +=Float.parseFloat(StringHelper.null2String(mk.get("F2327")));
		String col13=StringHelper.null2String(mk.get("T1107"));
		sum13 +=Float.parseFloat(StringHelper.null2String(mk.get("T1107")));
		String col14=StringHelper.null2String(mk.get("T1110"));
		sum14 +=Float.parseFloat(StringHelper.null2String(mk.get("T1110")));
		String col15=StringHelper.null2String(mk.get("T1111"));
		sum15 +=Float.parseFloat(StringHelper.null2String(mk.get("T1111")));
		String col16=StringHelper.null2String(mk.get("T1104"));
		sum16 +=Float.parseFloat(StringHelper.null2String(mk.get("T1104")));
		String col17=StringHelper.null2String(mk.get("F4310"));
		sum17 +=Float.parseFloat(StringHelper.null2String(mk.get("F4310")));
		String col18=StringHelper.null2String(mk.get("PC1248"));
		sum18 +=Float.parseFloat(StringHelper.null2String(mk.get("PC1248")));
		String col19=StringHelper.null2String(mk.get("A4570"));
		sum19 +=Float.parseFloat(StringHelper.null2String(mk.get("A4570")));
		String col20=StringHelper.null2String(mk.get("A3571"));
		sum20 +=Float.parseFloat(StringHelper.null2String(mk.get("A3571")));
		String col21=StringHelper.null2String(mk.get("F1314"));
		sum21 +=Float.parseFloat(StringHelper.null2String(mk.get("F1314")));
		String col22=StringHelper.null2String(mk.get("F1313"));
		sum22 +=Float.parseFloat(StringHelper.null2String(mk.get("F1313")));
		String col23=StringHelper.null2String(mk.get("F2313"));
		sum23 +=Float.parseFloat(StringHelper.null2String(mk.get("F2313")));
		String col24=StringHelper.null2String(mk.get("V105"));
		sum24 +=Float.parseFloat(StringHelper.null2String(mk.get("V105")));
		String col25=StringHelper.null2String(mk.get("P1205"));
		sum25 +=Float.parseFloat(StringHelper.null2String(mk.get("P1205")));

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
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col14_"+k%>" style="width:80%" value="<%=col14%>"><span id="<%="col14_"+k+"span"%>"><%=col14%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col15_"+k%>" style="width:80%" value="<%=col15%>"><span id="<%="col15_"+k+"span"%>"><%=col15%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col16_"+k%>" style="width:80%" value="<%=col16%>"><span id="<%="col16_"+k+"span"%>"><%=col16%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col17_"+k%>" style="width:80%" value="<%=col17%>"><span id="<%="col17_"+k+"span"%>"><%=col17%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col18_"+k%>" style="width:80%" value="<%=col18%>"><span id="<%="col18_"+k+"span"%>"><%=col18%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col19_"+k%>" style="width:80%" value="<%=col19%>"><span id="<%="col19_"+k+"span"%>"><%=col19%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col20_"+k%>" style="width:80%" value="<%=col20%>"><span id="<%="col20_"+k+"span"%>"><%=col20%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col21_"+k%>" style="width:80%" value="<%=col21%>"><span id="<%="col21_"+k+"span"%>"><%=col21%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col22_"+k%>" style="width:80%" value="<%=col22%>"><span id="<%="col22_"+k+"span"%>"><%=col22%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col23_"+k%>" style="width:80%" value="<%=col23%>"><span id="<%="col23_"+k+"span"%>"><%=col23%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col24_"+k%>" style="width:80%" value="<%=col24%>"><span id="<%="col24_"+k+"span"%>"><%=col24%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col25_"+k%>" style="width:80%" value="<%=col25%>"><span id="<%="col25_"+k+"span"%>"><%=col25%></span></TD>

		</TR>

		

	<%
		}
	 sql= "select a.item ,a.F1301,a.F1309,a.F1308,a.F1371,a.P1208,a.A1508,a.PD1207,a.F1322,a.A1503,a.F1501,a.A1570,a.F2327,a.T1107,a.T1110,a.T1111,a.T1104,a.F4310,a.PC1248,a.A4570,a.A3571,a.F1314,a.F1313,a.F2313,a.V105,a.P1205 from uf_yzaalaverage a where to_date(a.nowdate,'yyyy-mm-dd')-1=to_date('"+date1+"','yyyy-mm-dd')  and item = '0:00:00' ";
	  sublist = baseJdbc.executeSqlForList(sql);
	   no1=sublist.size();
      if(sublist.size()>0){
	   for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String item =StringHelper.null2String(mk.get("item"));
		String col1=StringHelper.null2String(mk.get("F1301"));
		sum1 +=Float.parseFloat(StringHelper.null2String(mk.get("F1301")));
		String col2=StringHelper.null2String(mk.get("F1309"));
		sum2 +=Float.parseFloat(StringHelper.null2String(mk.get("F1309")));
		String col3=StringHelper.null2String(mk.get("F1308"));
		sum3 +=Float.parseFloat(StringHelper.null2String(mk.get("F1308")));
		String col4=StringHelper.null2String(mk.get("F1371"));
		sum4 +=Float.parseFloat(StringHelper.null2String(mk.get("F1371")));
		String col5=StringHelper.null2String(mk.get("P1208"));
		sum5 +=Float.parseFloat(StringHelper.null2String(mk.get("P1208")));
		String col6=StringHelper.null2String(mk.get("A1508"));
		sum6 +=Float.parseFloat(StringHelper.null2String(mk.get("A1508")));
		String col7=StringHelper.null2String(mk.get("PD1207"));
		sum7 +=Float.parseFloat(StringHelper.null2String(mk.get("PD1207")));
		String col8=StringHelper.null2String(mk.get("F1322"));
		sum8 +=Float.parseFloat(StringHelper.null2String(mk.get("F1322")));
		String col9=StringHelper.null2String(mk.get("A1503"));
		sum9 +=Float.parseFloat(StringHelper.null2String(mk.get("A1503")));
		String col10=StringHelper.null2String(mk.get("F1501"));
		sum10 +=Float.parseFloat(StringHelper.null2String(mk.get("F1501")));
		String col11=StringHelper.null2String(mk.get("A1570"));
		sum11 +=Float.parseFloat(StringHelper.null2String(mk.get("A1570")));
		String col12=StringHelper.null2String(mk.get("F2327"));
		sum12 +=Float.parseFloat(StringHelper.null2String(mk.get("F2327")));
		String col13=StringHelper.null2String(mk.get("T1107"));
		sum13 +=Float.parseFloat(StringHelper.null2String(mk.get("T1107")));
		String col14=StringHelper.null2String(mk.get("T1110"));
		sum14 +=Float.parseFloat(StringHelper.null2String(mk.get("T1110")));
		String col15=StringHelper.null2String(mk.get("T1111"));
		sum15 +=Float.parseFloat(StringHelper.null2String(mk.get("T1111")));
		String col16=StringHelper.null2String(mk.get("T1104"));
		sum16 +=Float.parseFloat(StringHelper.null2String(mk.get("T1104")));
		String col17=StringHelper.null2String(mk.get("F4310"));
		sum17 +=Float.parseFloat(StringHelper.null2String(mk.get("F4310")));
		String col18=StringHelper.null2String(mk.get("PC1248"));
		sum18 +=Float.parseFloat(StringHelper.null2String(mk.get("PC1248")));
		String col19=StringHelper.null2String(mk.get("A4570"));
		sum19 +=Float.parseFloat(StringHelper.null2String(mk.get("A4570")));
		String col20=StringHelper.null2String(mk.get("A3571"));
		sum20 +=Float.parseFloat(StringHelper.null2String(mk.get("A3571")));
		String col21=StringHelper.null2String(mk.get("F1314"));
		sum21 +=Float.parseFloat(StringHelper.null2String(mk.get("F1314")));
		String col22=StringHelper.null2String(mk.get("F1313"));
		sum22 +=Float.parseFloat(StringHelper.null2String(mk.get("F1313")));
		String col23=StringHelper.null2String(mk.get("F2313"));
		sum23 +=Float.parseFloat(StringHelper.null2String(mk.get("F2313")));
		String col24=StringHelper.null2String(mk.get("V105"));
		sum24 +=Float.parseFloat(StringHelper.null2String(mk.get("V105")));
		String col25=StringHelper.null2String(mk.get("P1205"));
		sum25 +=Float.parseFloat(StringHelper.null2String(mk.get("P1205")));

	%>
<TR>
		<TD   class="td2"  align=center><%=item %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col1_"+no%>" style="width:80%" value="<%=col1%>"><span id="<%="col1_"+no+"span"%>"><%=col1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col2_"+no%>" style="width:80%" value="<%=col2%>"><span id="<%="col2_"+no+"span"%>"><%=col2%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col3_"+no%>" style="width:80%" value="<%=col3%>"><span id="<%="col3_"+no+"span"%>"><%=col3%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col4_"+no%>" style="width:80%" value="<%=col4%>"><span id="<%="col4_"+no+"span"%>"><%=col4%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col5_"+no%>" style="width:80%" value="<%=col5%>"><span id="<%="col5_"+no+"span"%>"><%=col5%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col6_"+no%>" style="width:80%" value="<%=col6%>"><span id="<%="col6_"+no+"span"%>"><%=col6%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col7_"+no%>" style="width:80%" value="<%=col7%>"><span id="<%="col7_"+no+"span"%>"><%=col7%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col8_"+no%>" style="width:80%" value="<%=col8%>"><span id="<%="col8_"+no+"span"%>"><%=col8%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col9_"+no%>" style="width:80%" value="<%=col9%>"><span id="<%="col9_"+no+"span"%>"><%=col9%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col10_"+no%>" style="width:80%" value="<%=col10%>"><span id="<%="col10_"+no+"span"%>"><%=col10%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col11_"+no%>" style="width:80%" value="<%=col11%>"><span id="<%="col11_"+no+"span"%>"><%=col11%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col12_"+no%>" style="width:80%" value="<%=col12%>"><span id="<%="col12_"+no+"span"%>"><%=col12%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col13_"+no%>" style="width:80%" value="<%=col13%>"><span id="<%="col13_"+no+"span"%>"><%=col13%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col14_"+no%>" style="width:80%" value="<%=col14%>"><span id="<%="col14_"+no+"span"%>"><%=col14%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col15_"+no%>" style="width:80%" value="<%=col15%>"><span id="<%="col15_"+no+"span"%>"><%=col15%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col16_"+no%>" style="width:80%" value="<%=col16%>"><span id="<%="col16_"+no+"span"%>"><%=col16%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col17_"+no%>" style="width:80%" value="<%=col17%>"><span id="<%="col17_"+no+"span"%>"><%=col17%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col18_"+no%>" style="width:80%" value="<%=col18%>"><span id="<%="col18_"+no+"span"%>"><%=col18%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col19_"+no%>" style="width:80%" value="<%=col19%>"><span id="<%="col19_"+no+"span"%>"><%=col19%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col20_"+no%>" style="width:80%" value="<%=col20%>"><span id="<%="col20_"+no+"span"%>"><%=col20%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col21_"+no%>" style="width:80%" value="<%=col21%>"><span id="<%="col21_"+no+"span"%>"><%=col21%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col22_"+no%>" style="width:80%" value="<%=col22%>"><span id="<%="col22_"+no+"span"%>"><%=col22%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col23_"+no%>" style="width:80%" value="<%=col23%>"><span id="<%="col23_"+no+"span"%>"><%=col23%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col24_"+no%>" style="width:80%" value="<%=col24%>"><span id="<%="col24_"+no+"span"%>"><%=col24%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="col25_"+no%>" style="width:80%" value="<%=col25%>"><span id="<%="col25_"+no+"span"%>"><%=col25%></span></TD>

		</TR>
<%
	   }
	  }

}else{%> 
	<TR><TD class="td2" colspan="26">无数据导入</TD></TR>
<%} %>
<TR>
		<TD class="td2"  align=center>平均值</TD>
		<TD class="td2"  align=center>&nbsp;<%=sum1/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum2/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum3/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum4/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum5/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum6/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum7/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum8/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum9/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum10/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum11/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum12/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum13/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum14/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum15/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum16/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum17/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum18/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum19/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum10/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum21/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum22/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum23/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum24/(no+no1)%></TD>
		<TD class="td2"  align=center>&nbsp;<%=sum25/(no+no1)%></TD>
		</TR>
</table>
</div>

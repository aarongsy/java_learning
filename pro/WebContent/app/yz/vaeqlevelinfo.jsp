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
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>

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
<TD  noWrap class="td2"  align=center>储槽</TD>
<TD  noWrap class="td2"  align=center>液位</TD>
<TD  noWrap class="td2"  align=center>数量(Ton)</TD>
<TD  noWrap class="td2"  align=center>备注</TD>
</TR>

<%
String sql = "";
String sql1="";
List list1=new ArrayList();
String remark="";
float oneweight=0f;
float lowweight=0f;
float amount=0f;
double B21= 0d ;
double A6=0d;
double B6=0d;
double F6=0d;
double C21=0d;
double result=0d;
String quantity="";

	sql = "select a.col1,a.col2,a.col3,a.col4,a.col5,a.col6,a.col7,a.col8,a.col9,a.col10,a.col11,a.col12,a.col13,a.col14,a.col15,a.col16,a.col17,a.col18,a.col19,a.col20,a.col21,a.col22,a.col23,a.col24,a.col25,a.col26,a.col27,a.col28,a.col29,a.col30,a.col31,a.col32,a.col33,a.col34,a.col35,a.col36,a.col37,a.col38,a.col39,a.col40,a.col41 from uf_yz_vaeqlevel  a where a.nowdate='"+date1+"'";

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		float col1=Float.parseFloat(StringHelper.null2String(mk.get("col1")));
		float col2=Float.parseFloat(StringHelper.null2String(mk.get("col2")));
		float col3=Float.parseFloat(StringHelper.null2String(mk.get("col3")));
		float col4=Float.parseFloat(StringHelper.null2String(mk.get("col4")));
		float col5=Float.parseFloat(StringHelper.null2String(mk.get("col5")));
		float col6=Float.parseFloat(StringHelper.null2String(mk.get("col6")));
		float col7=Float.parseFloat(StringHelper.null2String(mk.get("col7")));
		float col8=Float.parseFloat(StringHelper.null2String(mk.get("col8")));
		float col9=Float.parseFloat(StringHelper.null2String(mk.get("col9")));
		float col10=Float.parseFloat(StringHelper.null2String(mk.get("col10")));
		float col11=Float.parseFloat(StringHelper.null2String(mk.get("col11")));
		float col12=Float.parseFloat(StringHelper.null2String(mk.get("col12")));
		float col13=Float.parseFloat(StringHelper.null2String(mk.get("col13")));
		float col14=Float.parseFloat(StringHelper.null2String(mk.get("col14")));
		float col15=Float.parseFloat(StringHelper.null2String(mk.get("col15")));
		float col16=Float.parseFloat(StringHelper.null2String(mk.get("col16")));
		float col17=Float.parseFloat(StringHelper.null2String(mk.get("col17")));
		float col18=Float.parseFloat(StringHelper.null2String(mk.get("col18")));
		float col19=Float.parseFloat(StringHelper.null2String(mk.get("col19")));
		float col20=Float.parseFloat(StringHelper.null2String(mk.get("col20")));
		float col21=Float.parseFloat(StringHelper.null2String(mk.get("col21")));
		float col22=Float.parseFloat(StringHelper.null2String(mk.get("col22")));
		float col23=Float.parseFloat(StringHelper.null2String(mk.get("col23")));
		float col24=Float.parseFloat(StringHelper.null2String(mk.get("col24")));
		float col25=Float.parseFloat(StringHelper.null2String(mk.get("col25")));
		float col26=Float.parseFloat(StringHelper.null2String(mk.get("col26")));
		float col27=Float.parseFloat(StringHelper.null2String(mk.get("col27")));
		float col28=Float.parseFloat(StringHelper.null2String(mk.get("col28")));
		float col29=Float.parseFloat(StringHelper.null2String(mk.get("col29")));
		float col30=Float.parseFloat(StringHelper.null2String(mk.get("col30")));
		float col31=Float.parseFloat(StringHelper.null2String(mk.get("col31")));
		float col32=Float.parseFloat(StringHelper.null2String(mk.get("col32")));
		float col33=Float.parseFloat(StringHelper.null2String(mk.get("col33")));
		float col34=Float.parseFloat(StringHelper.null2String(mk.get("col34")));
		float col35=Float.parseFloat(StringHelper.null2String(mk.get("col35")));
		float col36=Float.parseFloat(StringHelper.null2String(mk.get("col36")));
		float col37=Float.parseFloat(StringHelper.null2String(mk.get("col37")));
		double col38=Double.parseDouble(StringHelper.null2String(mk.get("col38")));
		double col39=Double.parseDouble(StringHelper.null2String(mk.get("col39")));
		double col40=Double.parseDouble(StringHelper.null2String(mk.get("col40")));
		double col41=Double.parseDouble(StringHelper.null2String(mk.get("col41")));
	%>
		<TR>
		<TD   class="td2"  align=center>TK-401A</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col1" style="width:80%" value="<%=col1%>"><span id="<%="col1span"%>"><%=col1%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-401A' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col1*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col1"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col1span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col1"%>" style="width:80%" value="0"><span id="<%="acount_col1span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-401B</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col2" style="width:80%" value="<%=col2%>"><span id="<%="col2span"%>"><%=col2%></span></TD>
		
		<%
		sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-401B' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col2*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col2"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col2span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col2"%>" style="width:80%" value="0"><span id="<%="acount_col2span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-401C</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col3" style="width:80%" value="<%=col3%>"><span id="<%="col3span"%>"><%=col3%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-401C' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col3*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col3"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col3span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col3"%>" style="width:80%" value="0"><span id="<%="acount_col3span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-401D</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col4" style="width:80%" value="<%=col4%>"><span id="<%="col4span"%>"><%=col4%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-401D' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col4*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col4"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col4span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col4"%>" style="width:80%" value="0"><span id="<%="acount_col4span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-401E</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col5" style="width:80%" value="<%=col5%>"><span id="<%="col5span"%>"><%=col5%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-401E' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col5*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col5"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col5span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col5"%>" style="width:80%" value="0"><span id="<%="acount_col5span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-401F</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col6" style="width:80%" value="<%=col6%>"><span id="<%="col6span"%>"><%=col6%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-401F' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col6*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col6"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col6span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col6"%>" style="width:80%" value="0"><span id="<%="acount_col6span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-501</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col7" style="width:80%" value="<%=col7%>"><span id="<%="col7span"%>"><%=col7%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-501' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col7*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col7"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col7span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col7"%>" style="width:80%" value="0"><span id="<%="acount_col7span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>

<TR>
		<TD   class="td2"  align=center>TK-503</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col8" style="width:80%" value="<%=col8%>"><span id="<%="col8span"%>"><%=col8%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-503' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col8*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col8"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col8span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col8"%>" style="width:80%" value="0"><span id="<%="acount_col8span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR><TR>
		<TD   class="td2"  align=center>TK-505</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col9" style="width:80%" value="<%=col9%>"><span id="<%="col9span"%>"><%=col9%></span></TD>
		
		<%
		sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-505' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col9*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col9"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col9span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col9"%>" style="width:80%" value="0"><span id="<%="acount_col9span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-507</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col10" style="width:80%" value="<%=col10%>"><span id="<%="col10span"%>"><%=col10%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-507' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col10*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col10"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col10span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col10"%>" style="width:80%" value="0"><span id="<%="acount_col10span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-511</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col11" style="width:80%" value="<%=col11%>"><span id="<%="col11span"%>"><%=col11%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-511' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col11*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col11"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col11span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col11"%>" style="width:80%" value="0"><span id="<%="acount_col11span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-513</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col12" style="width:80%" value="<%=col12%>"><span id="<%="col12span"%>"><%=col12%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-513' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col12*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col12"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col12span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col12"%>" style="width:80%" value="0"><span id="<%="acount_col12span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-515</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col13" style="width:80%" value="<%=col13%>"><span id="<%="col13span"%>"><%=col13%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-515' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col13*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col13"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col13span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col13"%>" style="width:80%" value="0"><span id="<%="acount_col13span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-517</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col14" style="width:80%" value="<%=col14%>"><span id="<%="col14span"%>"><%=col14%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-517' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col14*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col14"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col14span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col14"%>" style="width:80%" value="0"><span id="<%="acount_col14span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-519</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col15" style="width:80%" value="<%=col15%>"><span id="<%="col15span"%>"><%=col15%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-519' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col15*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col15"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col15span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col15"%>" style="width:80%" value="0"><span id="<%="acount_col15span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-521</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col16" style="width:80%" value="<%=col16%>"><span id="<%="col16span"%>"><%=col16%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-521' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col16*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col16"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col16span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col16"%>" style="width:80%" value="0"><span id="<%="acount_col16span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-527</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col17" style="width:80%" value="<%=col17%>"><span id="<%="col17span"%>"><%=col17%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-527' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col17*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col17"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col17span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col17"%>" style="width:80%" value="0"><span id="<%="acount_col17span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-529</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col18" style="width:80%" value="<%=col18%>"><span id="<%="col18span"%>"><%=col18%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-529' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col18*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col18"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col18span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col18"%>" style="width:80%" value="0"><span id="<%="acount_col18span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-531</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col19" style="width:80%" value="<%=col19%>"><span id="<%="col19span"%>"><%=col19%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-531' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col19*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col19"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col19span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col19"%>" style="width:80%" value="0"><span id="<%="acount_col19span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-523A</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col20" style="width:80%" value="<%=col20%>"><span id="<%="col20span"%>"><%=col20%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-523A' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col20*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col20"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col20span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col20"%>" style="width:80%" value="0"><span id="<%="acount_col20span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-523B</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col21" style="width:80%" value="<%=col21%>"><span id="<%="col21span"%>"><%=col21%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-523B' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col21*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col21"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col21span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col21"%>" style="width:80%" value="0"><span id="<%="acount_col21span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-523C</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col22" style="width:80%" value="<%=col22%>"><span id="<%="col22span"%>"><%=col22%></span></TD>
		
		<%
		sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-523C' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col22*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col22"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col22span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col22"%>" style="width:80%" value="0"><span id="<%="acount_col22span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-525A</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col23" style="width:80%" value="<%=col23%>"><span id="<%="col23span"%>"><%=col23%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-525A' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col23*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col23"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col23span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col23"%>" style="width:80%" value="0"><span id="<%="acount_col23span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-525B</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col24" style="width:80%" value="<%=col24%>"><span id="<%="col24span"%>"><%=col24%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-525B' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col24*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col24"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col24span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%><TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col24"%>" style="width:80%" value="0"><span id="<%="acount_col24span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-525C</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col25" style="width:80%" value="<%=col25%>"><span id="<%="col25span"%>"><%=col25%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-525C' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col25*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col25"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col25span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col25"%>" style="width:80%" value="0"><span id="<%="acount_col25span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-533</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col26" style="width:80%" value="<%=col26%>"><span id="<%="col26span"%>"><%=col26%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-533' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col26*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col26"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col26span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col26"%>" style="width:80%" value="0"><span id="<%="acount_col26span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-535</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col27" style="width:80%" value="<%=col27%>"><span id="<%="col27span"%>"><%=col27%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-535' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col27*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col27"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col27span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col27"%>" style="width:80%" value="0"><span id="<%="acount_col27span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-537</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col28" style="width:80%" value="<%=col28%>"><span id="<%="col28span"%>"><%=col28%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-537' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col28*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col28"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col28span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col28"%>" style="width:80%" value="0"><span id="<%="acount_col28span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-539</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col29" style="width:80%" value="<%=col29%>"><span id="<%="col29span"%>"><%=col29%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-539' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col29*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col29"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col29span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col29"%>" style="width:80%" value="0"><span id="<%="acount_col29span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-541</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col30" style="width:80%" value="<%=col30%>"><span id="<%="col30span"%>"><%=col30%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-541' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col30*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col30"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col30span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col30"%>" style="width:80%" value="0"><span id="<%="acount_col30span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-543</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col31" style="width:80%" value="<%=col31%>"><span id="<%="col31span"%>"><%=col31%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-543' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col31*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col31"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col31span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col31"%>" style="width:80%" value="0"><span id="<%="acount_col31span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-545</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col32" style="width:80%" value="<%=col32%>"><span id="<%="col32span"%>"><%=col32%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-545' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col32*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col32"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col32span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col32"%>" style="width:80%" value="0"><span id="<%="acount_col32span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
	


		<TR>
		<TD   class="td2"  align=center>TK-547</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col33" style="width:80%" value="<%=col33%>"><span id="<%="col33span"%>"><%=col33%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-547' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col33*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col33"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col33span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col33"%>" style="width:80%" value="0"><span id="<%="acount_col33span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-549</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col34" style="width:80%" value="<%=col34%>"><span id="<%="col34span"%>"><%=col34%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-549' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col34*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col34"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col34span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col34"%>" style="width:80%" value="0"><span id="<%="acount_col34span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-551</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col35" style="width:80%" value="<%=col35%>"><span id="<%="col35span"%>"><%=col35%></span></TD>
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-551' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col35*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col35"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col35span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col35"%>" style="width:80%" value="0"><span id="<%="acount_col35span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-115</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col36" style="width:80%" value="<%=col36%>"><span id="<%="col36span"%>"><%=col36%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-115' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col36*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col36"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col36span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col36"%>" style="width:80%" value="0"><span id="<%="acount_col36span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-813</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col37" style="width:80%" value="<%=col37%>"><span id="<%="col37span"%>"><%=col37%></span></TD>
		
		<%
		 sql1="select t.onepencentw,t.lowweight,t.description from uf_yz_vaetanrate t where t.tankname='TK-813' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			oneweight=Float.parseFloat(StringHelper.null2String(map.get("onepencentw")));
			lowweight=Float.parseFloat(StringHelper.null2String(map.get("lowweight")));
			amount=(col37*oneweight+lowweight)/1000;
			DecimalFormat df=new DecimalFormat("#.0000");
			quantity=df.format(amount);
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col37"%>" style="width:80%" value="<%=quantity%>"><span id="<%="acount_col37span"%>"><%=quantity%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col37"%>" style="width:80%" value="0"><span id="<%="acount_col37span"%>">0</span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>V-901A</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col38" style="width:80%" value="<%=col38%>" ><span id="<%="col38span"%>"><%=col38%></span></TD>
		
		<%
		 sql1="select description from uf_yz_vaetanrate where tankname='V-901A' ";
		 list1 = baseJdbc.executeSqlForList(sql1);			
			 A6=2500.0d;
			 B6=10000.0d;
			 F6=460.9d;
			 if(col38==(int) col38)
		{
			B21= (2715d-85d)*col38/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double f=C21*F6  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		else
		{
			B21= (2715d-85d)*(int)col38/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double a=C21*F6;
		     B21= (2715d-85d)*((int)col38+1)/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double b=C21*F6;
			 double f=(b-a)*(col38-(int) col38)+a  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
			 
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col38"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col38span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col38"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col38span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>V-901B</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col39" style="width:80%" value="<%=col39%>" ><span id="<%="col39span"%>"><%=col39%></span></TD>
		<%
		 sql1="select description from uf_yz_vaetanrate where tankname='V-901B' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		// B21= (2715d-85d)*col39/100d+85d  ;
			 A6=2500.0d;
			 B6=10000.0d;
			 F6=460.9d;
			 if(col39==(int) col39)
		{
			B21= (2715d-85d)*col39/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double f=C21*F6  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		else
		{
			B21= (2715d-85d)*(int)col39/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double a=C21*F6;
		     B21= (2715d-85d)*((int)col39+1)/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double b=C21*F6;
			 double f=(b-a)*(col39-(int) col39)+a  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col39"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col39span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col39"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col39span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>V-901C</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col40" style="width:80%" value="<%=col40%>" ><span id="<%="col40span"%>"><%=col40%></span></TD>
		<%
		 sql1="select description from uf_yz_vaetanrate where tankname='V-901C' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		// B21= (2715d-85d)*col40/100d+85d  ;
			 A6=2500.0d;
			 B6=10000.0d;
			 F6=460.9d;
			 if(col40==(int) col40)
		{
			B21= (2715d-85d)*col40/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double f=C21*F6  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		else
		{
			B21= (2715d-85d)*(int)col40/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double a=C21*F6;
		     B21= (2715d-85d)*((int)col40+1)/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double b=C21*F6;
			 double f=(b-a)*(col40-(int) col40)+a  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col40"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col40span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col40"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col40span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>V-901D</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col41" style="width:80%" value="<%=col41%>" ><span id="<%="col41span"%>"><%=col41%></span></TD>
		
		<%
		 sql1="select description from uf_yz_vaetanrate where tankname='V-901D' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		 //B21= (2715.0d-85.0d)*col41/100d+85d  ;
			 A6=2500.0d;
			 B6=10000.0d;
			 F6=460.9d;
			 if(col41==(int) col41)
		{
			B21= (2715d-85d)*col41/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			double f=C21*F6  ;
			BigDecimal bg = new BigDecimal(f);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

			 //System.out.println(result);
		}
		else
		{
			B21= (2715d-85d)*(int)col41/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double a=C21*F6;
		     B21= (2715d-85d)*((int)col41+1)/100d+85d  ;
			C21=Double.parseDouble(StringHelper.null2String(2*3/4*(Math.PI)*Math.pow(A6,3)/24*Math.pow((2*B21/A6),2)*(1-2*B21/3/A6)*Math.pow(10,-9)+B6*((Math.pow(A6,2)/4*Math.acos((A6-2*B21)/A6)-Math.pow(((A6-B21)*B21),0.5)*(A6/2-B21)))*Math.pow(10,-9  )));
			 double b=C21*F6;
			 double f=(b-a)*(col41-(int) col41)+a  ;
			 BigDecimal bg = new BigDecimal(f);
             result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
			// System.out.println(result);
		}
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("description"));
			
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col41"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col41span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col41"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col41span"%>"><%=result%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		

	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="4">无数据导入</TD></TR>
<%} %>
</table>
</div>



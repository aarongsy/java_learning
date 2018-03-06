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
<TD  noWrap class="td2"  align=center>温度</TD>
<TD  noWrap class="td2"  align=center>压力</TD>
<TD  noWrap class="td2"  align=center>数量(Ton)</TD>
<TD  noWrap class="td2"  align=center>备注</TD>
</TR>

<%
String sql = "";
String sql1="";
List list1=new ArrayList();
String remark="";
double a=0d;
double b=0d;
double c=0d;
double d=0d;
double amount=0d;
double result=0d;
BigDecimal bg;
	sql = "select a.col1,a.col2,a.col3,a.col4,a.col5,a.col6,a.col7,a.col8,a.col9,a.col10,a.col11,a.col12,a.col13,a.col14,a.col15,a.col16,a.col17,a.col18,a.col19,a.col20 from uf_yz_aalliquidlevel a where a.nowdate='"+date1+"'";

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		double col1=Double.parseDouble(StringHelper.null2String(mk.get("col1")));
		double col2=Double.parseDouble(StringHelper.null2String(mk.get("col2")));
		double col3=Double.parseDouble(StringHelper.null2String(mk.get("col3")));
		double col4=Double.parseDouble(StringHelper.null2String(mk.get("col4")));
		double col5=Double.parseDouble(StringHelper.null2String(mk.get("col5")));
		double col6=Double.parseDouble(StringHelper.null2String(mk.get("col6")));
		double col7=Double.parseDouble(StringHelper.null2String(mk.get("col7")));
		double col8=Double.parseDouble(StringHelper.null2String(mk.get("col8")));
		double col9=Double.parseDouble(StringHelper.null2String(mk.get("col9")));
		double col10=Double.parseDouble(StringHelper.null2String(mk.get("col10")));
		double col11=Double.parseDouble(StringHelper.null2String(mk.get("col11")));
		double col12=Double.parseDouble(StringHelper.null2String(mk.get("col12")));
		double col13=Double.parseDouble(StringHelper.null2String(mk.get("col13")));
		double col14=Double.parseDouble(StringHelper.null2String(mk.get("col14")));
		double col15=Double.parseDouble(StringHelper.null2String(mk.get("col15")));
		double col16=Double.parseDouble(StringHelper.null2String(mk.get("col16")));
		double col17=Double.parseDouble(StringHelper.null2String(mk.get("col17")));
		double col18=Double.parseDouble(StringHelper.null2String(mk.get("col18")));
		double col19=Double.parseDouble(StringHelper.null2String(mk.get("col19")));
		double col20=Double.parseDouble(StringHelper.null2String(mk.get("col20")));
	%>
		<TR>
		<TD   class="td2"  align=center>TK-601</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col1" style="width:80%" value="<%=col1%>"><span id="<%="col1span"%>"><%=col1%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-601' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col1"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col1span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col1"%>" style="width:80%" value="0"><span id="<%="acount_col1span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK601' OR storetankname='TK-601' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-602</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col2" style="width:80%" value="<%=col2%>"><span id="<%="col2span"%>"><%=col2%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-602' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col2"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col2span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col2"%>" style="width:80%" value="0"><span id="<%="acount_col2span"%>">0</span></TD>
		<%
		}
		sql1="select remark from uf_yz_aalstoretank where storetankname='TK602' OR storetankname='TK-602' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		  Map map = (Map)list1.get(i);
		  remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-603</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col3" style="width:80%" value="<%=col3%>"><span id="<%="col3span"%>"><%=col3%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-603' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col3"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col3span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col3"%>" style="width:80%" value="0"><span id="<%="acount_col3span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK603' OR storetankname='TK-603' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-604</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col4" style="width:80%" value="<%=col4%>"><span id="<%="col4span"%>"><%=col4%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-604' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col4"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col4span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col4"%>" style="width:80%" value="0"><span id="<%="acount_col4span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK604' OR storetankname='TK-604' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-605</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col5" style="width:80%" value="<%=col5%>"><span id="<%="col5span"%>"><%=col5%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-605' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col5"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col5span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col5"%>" style="width:80%" value="0"><span id="<%="acount_col5span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK605' OR storetankname='TK-605' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-711</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col6" style="width:80%" value="<%=col6%>"><span id="<%="col6span"%>"><%=col6%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-711' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col6"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col6span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col6"%>" style="width:80%" value="0"><span id="<%="acount_col6span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK711' OR storetankname='TK-711' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		     Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-817</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col7" style="width:80%" value="<%=col7%>"><span id="<%="col7span"%>"><%=col7%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-817' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col7"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col7span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col7"%>" style="width:80%" value="0"><span id="<%="acount_col7span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK817' OR storetankname='TK-817' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>

<TR>
		<TD   class="td2"  align=center>TK-818</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col8" style="width:80%" value="<%=col8%>"><span id="<%="col8span"%>"><%=col8%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-818' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col8"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col8span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col8"%>" style="width:80%" value="0"><span id="<%="acount_col8span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK818' OR storetankname='TK-818' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR><TR>
		<TD   class="td2"  align=center>TK-721A</TD>
		<%
		    a = -0.0003*Math.pow(col10,3)+0.018*Math.pow(col10,2)-1.9035*col10+546.62;
			
			d =Math.PI*Math.pow(((15500-64)*col9/100+64),2)/3*(3*15500/2-((15500-64)*col9/100+64))*Math.pow(10,-9);
			b = 2026.27123649643-d;
			c=-2.1843*Math.pow(10,-5)*Math.pow(col11,4)+1.4861*Math.pow(10,-3)*Math.pow(col11,3)-4.3345*Math.pow(10,-2)*Math.pow(col11,2)+1.9797*col11+0.29351;
			amount=(d*a+b*c)/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col9" style="width:80%" value="<%=col9%>"><span id="<%="col9span"%>"><%=col9%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col10" style="width:80%" value="<%=col10%>"><span id="<%="col10span"%>"><%=col10%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col11" style="width:80%" value="<%=col11%>"><span id="<%="col11span"%>"><%=col11%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col9"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col9span"%>"><%=result%></span></TD>
		<%
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK721' OR storetankname='TK-721A' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
			
			

		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-721B</TD>
		<%
		    a = -0.0003*Math.pow(col13,3)+0.018*Math.pow(col13,2)-1.9035*col13+546.62;
			
			d =Math.PI*Math.pow(((15500-64)*col12/100+64),2)/3*(3*15500/2-((15500-64)*col12/100+64))*Math.pow(10,-9);
			b = 2026.27123649643-d;
			c=-2.1843*Math.pow(10,-5)*Math.pow(col14,4)+1.4861*Math.pow(10,-3)*Math.pow(col14,3)-4.3345*Math.pow(10,-2)*Math.pow(col14,2)+1.9797*col14+0.29351;
			amount=(d*a+b*c)/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col12" style="width:80%" value="<%=col12%>"><span id="<%="col12span"%>"><%=col12%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col13" style="width:80%" value="<%=col13%>"><span id="<%="col13span"%>"><%=col13%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col14" style="width:80%" value="<%=col14%>"><span id="<%="col14span"%>"><%=col14%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col10"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col10span"%>"><%=result%></span></TD>
		<%
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK721B' OR storetankname='TK-721B' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-721C</TD>
		<%
		    a = -0.0003*Math.pow(col16,3)+0.018*Math.pow(col16,2)-1.9035*col16+546.62;
			
			d =Math.PI*Math.pow(((15500-64)*col15/100+64),2)/3*(3*15500/2-((15500-64)*col15/100+64))*Math.pow(10,-9);
			b = 2026.27123649643-d;
			c=-2.1843*Math.pow(10,-5)*Math.pow(col17,4)+1.4861*Math.pow(10,-3)*Math.pow(col17,3)-4.3345*Math.pow(10,-2)*Math.pow(col17,2)+1.9797*col17+0.29351;
			amount=(d*a+b*c)/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col15" style="width:80%" value="<%=col15%>"><span id="<%="col15span"%>"><%=col15%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col16" style="width:80%" value="<%=col16%>"><span id="<%="col16span"%>"><%=col16%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col17" style="width:80%" value="<%=col17%>"><span id="<%="col17span"%>"><%=col17%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col11"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col11span"%>"><%=result%></span></TD>
		<%
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK721C' OR storetankname='TK-721C' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>TK-801</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col18" style="width:80%" value="<%=col18%>"><span id="<%="col18span"%>"><%=col18%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='TK-801' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col12"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col12span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col12"%>" style="width:80%" value="0"><span id="<%="acount_col12span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='TK801' OR storetankname='TK-801' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>V-802</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col19" style="width:80%" value="<%=col19%>"><span id="<%="col19span"%>"><%=col19%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='V-802' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col13"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col13span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col13"%>" style="width:80%" value="0"><span id="<%="acount_col13span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='V801' OR storetankname='V-801' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		<TR>
		<TD   class="td2"  align=center>V-511</TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="col20" style="width:80%" value="<%=col20%>"><span id="<%="col20span"%>"><%=col20%></span></TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%
		sql1="select shellid,density,length,length1 from uf_yz_basedate   where storetank='V-511' ";
		list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		   Map map = (Map)list1.get(i);
		    double shellid=Double.parseDouble(StringHelper.null2String(map.get("shellid")));
			double density=Double.parseDouble(StringHelper.null2String(map.get("density")));
			double length2=Double.parseDouble(StringHelper.null2String(map.get("length")));
			double length1=Double.parseDouble(StringHelper.null2String(map.get("length1")));
			double N = shellid * shellid/4/1000/1000*Math.PI*length1/1000;
			double L = shellid* shellid/4/1000/1000*Math.PI*length2/100;
			double Q=col1*L+N;
			double R=Q*density;
			amount=R/1000;
			 bg = new BigDecimal(amount);
            result = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();

		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col14"%>" style="width:80%" value="<%=result%>"><span id="<%="acount_col14span"%>"><%=result%></span></TD>
		<%
			}
		}
		else
		{
		%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_col14"%>" style="width:80%" value="0"><span id="<%="acount_col14span"%>">0</span></TD>
		<%
		}
		 sql1="select remark from uf_yz_aalstoretank where storetankname='V511' OR storetankname='V-511' ";
		 list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0){
		for(int i=0,sizei=list1.size();i<sizei;i++){
		    Map map = (Map)list1.get(i);
		    remark=StringHelper.null2String(map.get("remark"));
		%>
		<TD   class="td2"  align=center><%=remark %></TD>
        <% }
		}
		else
		{
		%>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<%}%>
		</TR>
		

	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="6">无数据导入</TD></TR>
<%} %>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
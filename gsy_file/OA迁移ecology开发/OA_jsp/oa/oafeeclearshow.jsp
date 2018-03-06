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

String requestid = StringHelper.null2String(request.getParameter("requestid"));
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

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width:100%;font-size:12" bordercolor="#adae9d">
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
<COL  id=innerno width="7%"></COLGROUP>

<TR height="25"  class="title">
<TD noWrap>序号</A></TD>
<TD noWrap>记账码</A></TD>
<TD noWrap>总账科目</A></TD>
<TD noWrap>金额</A></TD>
<TD noWrap>文本</A></TD>
<TD noWrap>税码</A></TD>
<TD noWrap>成本中心</A></TD>
<TD noWrap>付款条件</A></TD>
<TD noWrap>付款基准日期</A></TD>
<TD noWrap>结冻付款</A></TD>
<TD noWrap>付款方式</A></TD>
<TD noWrap>合作银行</A></TD>
<TD id=ordername noWrap>内部订单</A></TD>
<TD noWrap>销售订单</A></TD>
<TD noWrap>项次</A></TD></TR>
		
<%
String sql = "";
Map mk;
List sublist;
String sqlquery="";
Map map;
List list;
String upsql="";

     sql = "select no,jznumber,subject,num,text,taxcode,costcenter,payterm,paydate,jdpay,payway,blank,inneroeder,saleorder,innerno from uf_oa_feeclearpzdetail a  where a.requestid='"+requestid+"'  order by to_number(a.no) asc ";
	System.out.println(sql);
	sublist = baseJdbc.executeSqlForList(sql);
	int no=sublist.size();
	if(sublist.size()>0){
		for(int k=0,sizek=sublist.size();k<sizek;k++){
			mk = (Map)sublist.get(k);
			String number=StringHelper.null2String(mk.get("no"));
			String jznumber =StringHelper.null2String(mk.get("jznumber"));
			String subject =StringHelper.null2String(mk.get("subject"));
			String num =StringHelper.null2String(mk.get("num"));
			String text =StringHelper.null2String(mk.get("text"));
			String taxcode =StringHelper.null2String(mk.get("taxcode"));
			String costcenter =StringHelper.null2String(mk.get("costcenter"));
			String payterm =StringHelper.null2String(mk.get("payterm"));
			String paydate =StringHelper.null2String(mk.get("paydate"));
			String jdpay=StringHelper.null2String(mk.get("jdpay"));
			String payway=StringHelper.null2String(mk.get("payway"));
			String blank=StringHelper.null2String(mk.get("blank"));
			String inneroeder=StringHelper.null2String(mk.get("inneroeder"));
			String saleorder=StringHelper.null2String(mk.get("saleorder"));
			String innerno=StringHelper.null2String(mk.get("innerno"));
	%>
	<TR>
		<TD   class="td2"  align=center><%=number %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="jznumber_"+k%>" style="width:80%" value="<%=jznumber%>"><span id="<%="jznumber_"+k+"span"%>"><%= jznumber%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="subject_"+k%>" style="width:80%" value="<%=subject%>">
		<span id="<%="subject_"+k+"span"%>"><%= subject%></span></TD>
		<TD   class="td2"  align=center><%=num %></TD>
		<TD   class="td2"  align=center><%=text %></TD>
		<TD   class="td2"  align=center><%=taxcode%></TD>
		<TD   class="td2"  align=center><%=costcenter%></TD>
		<TD   class="td2"  align=center><%=payterm %></TD>
		<TD   class="td2"  align=center><%=paydate %></TD>
		<TD   class="td2"  align=center><%=jdpay %></TD>
		<TD   class="td2"  align=center><%=payway %></TD>
		<TD   class="td2"  align=center><%=blank %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="saleoeder_"+k%>" style="width:80%" value="<%=inneroeder%>">
		<span id="<%="saleoeder_"+k+"span"%>"><%=inneroeder%></span></TD>
		<TD   class="td2"  align=center><%=saleorder %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="orderno_"+k%>" style="width:80%" value="<%=innerno%>">
		<span id="<%="orderno_"+k+"span"%>"><%=innerno%></span></TD>

		</TR>
		<%
		}
	}
		%>
</table>
</div>
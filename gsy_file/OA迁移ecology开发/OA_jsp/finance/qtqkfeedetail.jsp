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

<script type='text/javascript' language="javascript" src='/js/main.js'>
</script>

<div id="warpp">
<table id="dataTables4" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<CAPTION>费用明细表(一般费用)</CAPTION>
<COLGROUP>
<COL width=80><!--序号-->
<COL width=120><!--会计科目-->
<COL width=120><!--成本中心-->
<COL width=120><!--内部订单-->
<COL width=120><!--销售订单-->
<COL width=120><!--订单行项-->
<COL width=120 style="display:none"><!--含税金额-->
<COL width=120 style="display:none"><!--发票税率-->
<COL width=120><!--未税金额-->
<COL width=120><!--本币金额-->
<COL width=120><!--转出金额-->
</COLGROUP>
<TR  height="20"  class="title">
<TD noWrap align="center">序号</TD>
<TD noWrap align="center">会计科目</TD>
<TD noWrap align="center">成本中心</TD>
<TD noWrap align="center">内部订单</TD>
<TD noWrap align="center">销售订单</TD>
<TD noWrap align="center">订单行项</TD>
<TD noWrap align="center">含税金额</TD>
<TD noWrap align="center">发票税率</TD>
<TD noWrap align="center">未税金额</TD>
<TD noWrap align="center">本币金额</TD>
<TD noWrap align="center">转出金额</TD>
</TR>


<%
	//查询数据并显示
	String selsql = "select ordernumber,accountsubject,costcenter,internalorder,outsum,salesorder,salesorderitem,taxamount,invoicerate,notaxamount,localamount from uf_fn_feedetail  where requestid = '"+requestid+"' order by to_number(ordernumber) asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String ordernumber = StringHelper.null2String(m4.get("ordernumber"));
			String accountsubject = StringHelper.null2String(m4.get("accountsubject"));
			String costcenter = StringHelper.null2String(m4.get("costcenter"));
			String internalorder = StringHelper.null2String(m4.get("internalorder"));
			String salesorder=StringHelper.null2String(m4.get("salesorder"));
			String salesorderitem=StringHelper.null2String(m4.get("salesorderitem"));
			String taxamount = StringHelper.null2String(m4.get("taxamount"));
			String invoicerate = StringHelper.null2String(m4.get("invoicerate"));
			String notaxamount = StringHelper.null2String(m4.get("notaxamount"));
			String localamount = StringHelper.null2String(m4.get("localamount"));
			String outsum = StringHelper.null2String(m4.get("outsum"));
%>
		<TR  id="dataDetail" height="30">
		<TD  class="td2"	 align=center ><%=ordernumber%></TD>
		<TD  class="td2"     align=center ><%=accountsubject%></TD>
		<TD  class="td2"     align=center><%=costcenter%></TD>
		<TD  class="td2"     align=center><%=internalorder%></TD>
		<TD  class="td2" align=center><%=salesorder%></TD>
		<TD  class="td2" align=center><%=salesorderitem%></TD>
		<TD  class="td2"     align=center><%=taxamount%></TD>
		<TD  class="td2"     align=center><%=invoicerate%></TD>
		<TD  class="td2"     align=center><%=notaxamount%></TD>
		<TD  class="td2"     align=center ><%=localamount%></TD>
		<TD  class="td2" align=center ><%=outsum%></TD>
		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>

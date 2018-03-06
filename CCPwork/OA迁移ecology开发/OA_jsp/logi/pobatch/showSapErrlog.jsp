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
<%@ page import="com.eweaver.base.DataService"%>


<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	//String ladno=StringHelper.null2String(request.getParameter("ladno"));//提入单号
	//String loadplanno=StringHelper.null2String(request.getParameter("loadplanno")); //装卸计划号
	//String ispond = StringHelper.null2String(request.getParameter("ispond")); //是否过磅
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	String action = StringHelper.null2String(request.getParameter("action")); 
	//System.out.println("ladno="+ladno+" loadplanno="+loadplanno+" ispond="+ispond+" requestid="+requestid);
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
<div id="warpp" >

<%
	try {
		String logsql = "select * from uf_lo_pobatchlog where requestid='"+requestid+"' order by zmessdate desc, zno asc,znoitem asc";
		List loglist = baseJdbc.executeSqlForList(logsql);
		if ( loglist.size() > 0 ) {
	
%>

<table id="errlogdataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>批次确认单号</TD>
<TD  noWrap class="td2"  align=center>批次确认单号项次</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>订单项次</TD>
<TD  noWrap class="td2"  align=center>SAP返回标识</TD>
<TD  noWrap class="td2"  align=center>SAP返回消息</TD>
<TD  noWrap class="td2"  align=center>SAP返回消息日期</TD>
</TR>
<%	
		int k = 0;
		for ( int i=0 ;i <loglist.size();i++ ) {
			Map logmap = (Map)loglist.get(i);
			String pono = StringHelper.null2String(logmap.get("pono"));
			String poitem = StringHelper.null2String(logmap.get("poitem"));
			String zmark = StringHelper.null2String(logmap.get("zmark"));
			String zmess = StringHelper.null2String(logmap.get("zmess"));
			String zno = StringHelper.null2String(logmap.get("zno"));
			String znoitem = StringHelper.null2String(logmap.get("znoitem"));
			String zmessdate = StringHelper.null2String(logmap.get("zmessdate"));
			k++;
			
%>
<TR>
<TD><%=k %></TD>
<TD><%=zno %></TD>
<TD><%=znoitem %></TD>
<TD><%=pono %></TD>
<TD><%=poitem %></TD>
<TD><%=zmark %></TD>
<TD><%=zmess %></TD>
<TD><%=zmessdate %></TD>
</TR>
<%		
		}
%>	
</table>

<%		
	}
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
%>
</div>
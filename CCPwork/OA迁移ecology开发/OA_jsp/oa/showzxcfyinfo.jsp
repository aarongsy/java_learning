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
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
.float_header{ 
	position: relative;
	top: expression(eval(this.parentElement.parentElement.parentElement.scrollTop-2)); 
}
td.td3{ 
 position: relative ; 
 LEFT: expression(this.parentElement.offsetParent.parentElement.scrollLeft);
	white-space: nowrap; left:0;
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

<div id="warpp" style="BORDER-BOTTOM: #000000 0px solid; BORDER-LEFT: #000000 0px solid; WIDTH: 100%; OVERFLOW: scroll; BORDER-TOP: #000000 0px solid; BORDER-RIGHT: #000000 0px solid">

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<TR height="25"  class="title">
	<TD  noWrap class="td3"  align=center>序号</TD>
	<TD  noWrap class="td2"  align=center>公司别</TD>
	<TD  noWrap class="td2"  align=center>公司代码</TD>
	<TD  noWrap class="td2"  align=center>制程简码</TD>
	<TD  noWrap class="td2"  align=center>公司自有总数量</TD>
	<TD  noWrap class="td2"  align=center>维修数量</TD>
	<TD  noWrap class="td2"  align=center>维修金额（元）</TD>
	<TD  noWrap class="td2"  align=center>部门维修率（%）</TD>

<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");


	String sql="select a.*,(select objname from orgunit where id=a.company) as company from uf_oa_zxcfydetail a where exists(select 1 from formbase where id=a.requestid and isdelete=0) order by a.no asc";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		for(int k=0;k<list.size();k++)
		{

			Map map = (Map)list.get(k);
			String no = StringHelper.null2String(map.get("no"));//序号
			String company =StringHelper.null2String(map.get("company"));//公司别
			String cocode =StringHelper.null2String(map.get("cocode"));//公司代码
			String zccode =StringHelper.null2String(map.get("zccode"));//制程简码
			String zysum =StringHelper.null2String(map.get("zysum"));//公司自有数量
			String wxsum =StringHelper.null2String(map.get("wxsum"));//维修数量
			String wxmon =StringHelper.null2String(map.get("wxmon"));//维修金额
			String gailv =StringHelper.null2String(map.get("gailv"));//维修概率

			%>
			<TR >
				<TD  noWrap class="td3"  align=center><%=no%></TD>
				<TD  noWrap class="td2"  align=center><%=company%></TD>
				<TD  noWrap class="td2"  align=center><%=cocode%></TD>
				<TD  noWrap class="td2"  align=center><%=zccode%></TD>
				<TD  noWrap class="td2"  align=center><%=zysum%></TD>
				<TD  noWrap class="td2"  align=center><%=wxsum%></TD>
				<TD  noWrap class="td2"  align=center><%=wxmon%></TD>
				<TD  noWrap class="td2"  align=center><%=gailv%></TD>
			</TR>
			<%
		}
	}
%>
</table>
</div>
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

 <DIV id="warpp">


<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="4%">
<COL width="7%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="8%">
<COL width="5%">
<COL width="8%">
<COL width="5%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%"></COLGROUP>

<TR height="25"  class="title">
<TD noWrap class="td2"  align=center>序号</TD>
<TD noWrap class="td2"  align=center>品名</TD>
<TD noWrap class="td2"  align=center>内部订单号</TD>
<TD noWrap class="td2"  align=center>规格</TD>
<TD noWrap class="td2"  align=center>单价</TD>
<TD noWrap class="td2"  align=center>单位</TD>
<TD noWrap class="td2"  align=center>使用人</TD>
<TD noWrap class="td2"  align=center>需求日期</TD>
<TD noWrap class="td2"  align=center>申请数量</TD>
<TD noWrap class="td2"  align=center>送货地点</TD>
<TD noWrap class="td2"  align=center>金额</TD>
<TD noWrap class="td2"  align=center>物品类型</TD>
<TD noWrap class="td2"  align=center>总务类别</TD>
<TD noWrap class="td2"  align=center>次类别</TD>


</tr>
<%

       String sql = "select a.no,a.goodsname,a.innerorder,a.specify,a.price,a.unit,a.psn,(select objname from humres where id=a.psn) as objname,a.needdate,a.num,a.address,a.sumprice,(select objname from selectitem where id=a.goodstyle)as goodstyle,(select columnname from uf_oa_gensplcategory  where requestid=a.cate) as cate,( select columnname from uf_oa_gensplcategory  where requestid=a.subcate) as subcate from uf_oa_goodsdetailapp a where a.requestid='"+requestid+"' order by a.no asc";

       List sublist = baseJdbc.executeSqlForList(sql);
       if(sublist.size()>0){
	          for(int k=0,sizek=sublist.size();k<sizek;k++){
		      Map mk = (Map)sublist.get(k);
			  String no=StringHelper.null2String(mk.get("no"));
			  String goodsname=StringHelper.null2String(mk.get("goodsname"));
			  String innerorder=StringHelper.null2String(mk.get("innerorder"));
			  String specify=StringHelper.null2String(mk.get("specify"));
			  String price=StringHelper.null2String(mk.get("price"));
			  String unit=StringHelper.null2String(mk.get("unit"));
			  String objname=StringHelper.null2String(mk.get("objname"));
			  String needdate=StringHelper.null2String(mk.get("needdate"));
			  String num=StringHelper.null2String(mk.get("num"));
			  String address=StringHelper.null2String(mk.get("address"));
			  String sumprice=StringHelper.null2String(mk.get("sumprice"));
			  String goodstyle=StringHelper.null2String(mk.get("goodstyle"));
			  String cate=StringHelper.null2String(mk.get("cate"));
			  String subcate=StringHelper.null2String(mk.get("subcate"));
		%>
			<TR id="dataDetail">
			<TD noWrap  class="td2"  align=center><%=no %></TD>
		    <TD noWrap  class="td2"  align=center><%=goodsname %></TD>
			<TD  noWrap class="td2"  align=center><%=innerorder %></TD>
			<TD  noWrap class="td2"  align=center><%=specify %></TD>
			<TD noWrap  class="td2"  align=center><%=price %></TD>
			<TD noWrap  class="td2"  align=center><%=unit %></TD>
			<TD noWrap  class="td2"  align=center><%=objname %></TD>
			<TD noWrap  class="td2"  align=center><%=needdate %></TD>
			<TD noWrap  class="td2"  align=center><%=num %></TD>
			<TD noWrap  class="td2"  align=center><%=address %></TD>
			<TD noWrap  class="td2"  align=center><%=sumprice %></TD>
			<TD noWrap  class="td2"  align=center><%=goodstyle %></TD>
			<TD noWrap  class="td2"  align=center><%=cate %></TD>
			<TD noWrap  class="td2"  align=center><%=subcate %></TD>
			</tr>
		<%		
	}
}else{%> 
	<TR><TD class="td2" colspan="14">无申请明细！</TD></TR>
<%} %>
</table>
</div>

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


 <DIV id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="6%">
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
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="6%">
<COL width="10%">

<COL style="DISPLAY: none" id=dept width="6%">
<COL style="DISPLAY: none" id=costcenter width="6%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%"></COLGROUP>



<TR height="25"  class="title">
<TD noWrap>序号</TD>
<TD noWrap>物品编码</TD>
<TD noWrap>品名</TD>
<TD noWrap>内部订单号</TD>
<TD noWrap>规格</TD>
<TD noWrap>单价</TD>
<TD noWrap>单位</TD>
<TD noWrap>使用人</TD>
<TD noWrap>需求日期</TD>
<TD noWrap>申请数量</TD>
<TD noWrap>送货地点</TD>
<TD noWrap>金额</TD>
<TD noWrap>物品类型</TD>
<TD noWrap>已采购数</TD>
<TD noWrap>已发送数量</TD>
<TD noWrap>已接收数量</TD>
<TD noWrap>未发送数量</TD>
<TD noWrap>供应商名称</TD>
<TD noWrap>供应商简码</TD>

<TD noWrap>总务类别</TD>
<TD noWrap>次类别</TD>
<TD noWrap>所属部门</TD>
<TD noWrap>使用人成本中心</TD>
<TD noWrap>发送记录&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;</TD>
<TD noWrap>验收记录&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;</TD>
<TD noWrap>申请状态</TD>
<TD noWrap>是否结案</TD>
</TR>

<%

       String sql = "select a.no,(select goodsid from uf_oa_goodsmaintain  where requestid=a.goodsno) as goodsno ,a.goodsname,a.innerorder,a.specify,a.price,a.unit,a.psn,(select objname from humres where id=a.psn) as objname,a.needdate,a.num,a.address,a.sumprice,(select objname from selectitem where id=a.goodstyle)as goodstyle,a.ordernum,a.sendnum,a.receivenum,(select supplyname from uf_oa_supplyinfo  where requestid=a.spna) as spna,a.scode,(select objname from selectitem where id=a.fstatus) as fstatus,(select columnname from uf_oa_gensplcategory  where requestid=a.cate) as cate,( select columnname from uf_oa_gensplcategory  where requestid=a.subcate) as subcate,(select objname from orgunit where id=a.psndept) as psndept,a.ucstcen,a.fsrecord,a.ysrecord,(select objname from selectitem where id=a.isfinish) as isfinish,a.sendnore,a.expnum from uf_oa_goodsdetailapp a where a.requestid='"+requestid+"' order by a.no";

       List sublist = baseJdbc.executeSqlForList(sql);
       if(sublist.size()>0){
	          for(int k=0,sizek=sublist.size();k<sizek;k++){
		      Map mk = (Map)sublist.get(k);
			  String no=StringHelper.null2String(mk.get("no"));
			  String goodsno=StringHelper.null2String(mk.get("goodsno"));
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
			  String ordernum=StringHelper.null2String(mk.get("ordernum"));
			  String sendnum=StringHelper.null2String(mk.get("sendnum"));
			  String receivenum=StringHelper.null2String(mk.get("receivenum"));
			  String spna=StringHelper.null2String(mk.get("spna"));
			  String scode=StringHelper.null2String(mk.get("scode"));
			  String cate=StringHelper.null2String(mk.get("cate"));
			  String subcate=StringHelper.null2String(mk.get("subcate"));
			  String psndept=StringHelper.null2String(mk.get("psndept"));
			  String ucstcen=StringHelper.null2String(mk.get("ucstcen"));
			  String fsrecord=StringHelper.null2String(mk.get("fsrecord"));
			  String ysrecord=StringHelper.null2String(mk.get("ysrecord"));
			  String fstatus=StringHelper.null2String(mk.get("fstatus"));
			  String isfinish=StringHelper.null2String(mk.get("isfinish"));
			  String sendnore=StringHelper.null2String(mk.get("sendnore"));
			  String expnum=StringHelper.null2String(mk.get("expnum"));
			   int nosent=0;
			  if(num.equals("")||receivenum.equals("")||sendnore.equals("")||expnum.equals(""))
				  {
				  }
				  else
				  {
					  nosent =Integer.parseInt(num)-Integer.parseInt(receivenum)-Integer.parseInt(sendnore)+Integer.parseInt(expnum);
				  }
			 
		%>
			<TR id="dataDetail" class=DataLight>
			<TD noWrap class="td2"  align=center><%=no %></TD>
			<TD noWrap class="td2"  align=center><%=goodsno %></TD>
		    <TD noWrap class="td2"  align=center><%=goodsname %></TD>
			<TD noWrap class="td2"  align=center><%=innerorder %></TD>
			<TD noWrap class="td2"  align=center><%=specify %></TD>
			<TD noWrap class="td2"  align=center><%=price %></TD>
			<TD noWrap class="td2"  align=center><%=unit %></TD>
			<TD noWrap class="td2"  align=center><%=objname %></TD>
			<TD noWrap class="td2"  align=center><%=needdate %></TD>
			<TD noWrap class="td2"  align=center ><%=num %></TD>
			<TD noWrap class="td2"  align=center ><%=address %></TD>
			<TD noWrap class="td2"  align=center ><%=sumprice %></TD>
			<TD noWrap class="td2"  align=center><%=goodstyle %></TD>
			<TD noWrap class="td2"  align=center ><%=ordernum %></TD>
			<TD noWrap class="td2"  align=center   ><%=sendnum %></TD>
			<TD noWrap class="td2"  align=center ><%=receivenum %></TD>
			<TD noWrap class="td2"  align=center><%=nosent %></TD>
			<TD noWrap class="td2"  align=center ><%=spna %></TD>
			<TD noWrap class="td2"  align=center ><%=scode %></TD>
			<TD class="td2"  align=center><%=cate %></TD>
			<TD class="td2"  align=center><%=subcate %></TD>
			<TD noWrap class="td2"  align=center><%=psndept %></TD>
			<TD noWrap class="td2"  align=center><%=ucstcen %></TD>
			<TD class="td2"  align=center><%=fsrecord %></TD>
			<TD class="td2"  align=center><%=ysrecord %></TD>
			<TD noWrap class="td2"  align=center><%=fstatus %></TD>
			<TD noWrap class="td2"  align=center><%=isfinish %></TD>
			</tr>
		<%		
	}
}else{%> 
	<TR><TD class="td2" colspan="27">无申请明细！</TD></TR>
<%} %>
</table>
</div>

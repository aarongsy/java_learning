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
<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String accepttype="";

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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="8%">
<COL width="8%">
<COL width="15%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL style = "display:none" width="8%">
<COL style = "display:none" width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>订单项次</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>订单短文本</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>

<TD  noWrap class="td2"  align=center>请购数量</TD>
<TD  noWrap class="td2"  align=center>请购单位</TD>

<TD  noWrap class="td2"  align=center>采购数量</TD>
<TD  noWrap class="td2"  align=center>采购单位</TD>
<TD  noWrap class="td2"  style = "display:none" align=center>采购单价</TD>
<TD  noWrap class="td2"  style = "display:none" align=center>金额</TD>
<TD  noWrap class="td2"  style = "display:none" align=center>工厂</TD>
<TD  noWrap class="td2"  style = "display:none" align=center>预定交货日</TD>
<TD  noWrap class="td2"  align=center>本次验收数量</TD>
<TD  noWrap class="td2"  align=center>采购申请凭证类型</TD>
<TD  noWrap class="td2"  align=center>已付金额</TD>
<TD  noWrap class="td2"  align=center>本期请付金额</TD>
<TD  noWrap class="td2"  align=center>原工程金额</TD>
</tr>

<%


String sql = "";
sql = "select orderrow,orderno,factory,ordertxt,materno,needdept,purchdept,neednum,purchnum,purchprice,mon,plandeliv,acceptnum,credittype,id,paid,acceptmon,total from uf_yz_engindetail where requestid = '"+requestid+"'";

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		//String theid=StringHelper.null2String(mk.get("id"));
		int no=k+1;
		String orderrow=StringHelper.null2String(mk.get("orderrow"));
		String factory=StringHelper.null2String(mk.get("factory"));
		String orderno=StringHelper.null2String(mk.get("orderno"));
		String ordertxt=StringHelper.null2String(mk.get("ordertxt"));
		String materno=StringHelper.null2String(mk.get("materno"));
		String needdept=StringHelper.null2String(mk.get("needdept"));
		String neednum=StringHelper.null2String(mk.get("neednum"));
		String purchdept=StringHelper.null2String(mk.get("purchdept"));
		String purchnum=StringHelper.null2String(mk.get("purchnum"));
		String purchprice=StringHelper.null2String(mk.get("purchprice"));
		String mon=StringHelper.null2String(mk.get("mon"));
		String plandeliv=StringHelper.null2String(mk.get("plandeliv"));
		String acceptnum=StringHelper.null2String(mk.get("acceptnum"));
		String credittype=StringHelper.null2String(mk.get("credittype"));
		String id=StringHelper.null2String(mk.get("id"));
		String paid=StringHelper.null2String(mk.get("paid"));
		String acceptmon=StringHelper.null2String(mk.get("acceptmon"));//本期请付金额
		String total=StringHelper.null2String(mk.get("total"));//原工程金额
		String upsql = "update uf_yz_engindetail set psns = (select helper from uf_yz_acceptflow where credittype = '"+credittype+"'),accepttype = (select accepttype from uf_yz_acceptflow where credittype = '"+credittype+"') where id = '"+id+"' ";
		baseJdbc.update(upsql);
		String sql1 = "select accepttype from uf_yz_engindetail where id = '"+id+"'";
		List sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size() >0)
		{
			Map mk1 = (Map)sublist1.get(0);
			accepttype = StringHelper.null2String(mk1.get("accepttype"));
		}
		//System.out.println(credittype);
		//String acceptmon=StringHelper.null2String(mk.get("acceptmon"));
	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>

		<TD  class="td2"   align=center ><%=orderrow %></TD>
		<TD  class="td2"   align=center ><%=orderno %></TD>

		<TD   class="td2"  align=center><%=ordertxt %></TD>

		<TD   class="td2"  align=center><%=materno %></TD>
		<TD   class="td2"  align=center><%=neednum %></TD>
		<TD   class="td2"  align=center><%=needdept %></TD>
		
		<TD   class="td2"  align=center><%=purchnum %></TD>
		<TD   class="td2"  align=center><%=purchdept %></TD>

		<TD   class="td2"  align=center><%=acceptnum %></TD>
		<TD   class="td2"  align=center><%=credittype %></TD>
		<%if(accepttype.equals("40285a8d4c699b19014c77df8e232b3f")){ %>
			<TD   class="td2"  align=center><%=paid %></TD>
			<TD   class="td2"  align=center><input type = "text" class="InputStyle" name="acceptmon" id="<%="acceptnum_"+no%>" style="width:80%;text-align:center" value="<%=acceptmon%>" onchange="fieldcheck(this,'^(-?[\\d+]{0,22})(\\.[\\d+]{0,2})?$','本期请付金额');getvalue('<%=no %>',this.value);"><span id="<%="acceptmon"+no+"span"%>"></span></TD>
		
			<TD   class="td2"  align=center><%=total %></TD>
			<%}else{ %>
			<TD  ></TD>
			<TD  ></TD>
			<TD  ></TD>
			<%} %>
		

		</TR>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="11">该订单没有相应的信息!</TD></TR>
<%} %>
</table>
</div>

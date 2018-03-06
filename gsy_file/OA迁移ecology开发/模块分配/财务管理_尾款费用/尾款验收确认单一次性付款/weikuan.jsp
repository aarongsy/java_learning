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

<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String purchno = StringHelper.null2String(request.getParameter("purchno"));//采购订单号


BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

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

<div id="warpp"  >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="60">
<COL width="120">
<COL width="60">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="80">
<COL width="80">


</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>项次</TD>
<TD  noWrap class="td2"  align=center>短文本</TD>
<TD  noWrap class="td2"  align=center>订购单位</TD>
<TD  noWrap class="td2"  align=center>采购订单数量</TD>
<TD  noWrap class="td2"  align=center>完税金额</TD>
<TD  noWrap class="td2"  align=center>币种</TD>
<TD  noWrap class="td2"  align=center>付款金额</TD>
</tr>

<%
String delsql = "delete uf_fn_wkpodetail  where requestid = '"+requestid+"'";
baseJdbc.update(delsql);



//创建SAP对象		
SapConnector sapConnector = new SapConnector();
String functionName = "ZOA_MM_PO_INFO";
JCoFunction function = null;
try {
	function = SapConnector.getRfcFunction(functionName);
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
function.getImportParameterList().setValue("EBELN",purchno);//采购订单号


try {
	function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
} catch (JCoException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}

String BSART=function.getExportParameterList().getValue("BSART").toString();
String insql1 = "update uf_fn_wkoneoffpay set ddtype='"+BSART+"' where requestid='"+requestid+"'";
		baseJdbc.update(insql1);
		System.out.println(insql1);


//抓取抛SAP的返回值
JCoTable newretTable = function.getTableParameterList().getTable("MM_PO_ITEMS");

if(newretTable.getNumRows() >0)
{
	for(int j = 0;j<newretTable.getNumRows();j++)
	{
		if(j == 0)
		{
			newretTable.firstRow();//获取返回表格数据中的第一行
		}
		else
		{
			newretTable.nextRow();//获取下一行数据
		}
		String EBELN = newretTable.getString("EBELN");//采购订单号

		String EBELP = newretTable.getString("EBELP");//项次

		String TXZ01 = newretTable.getString("TXZ01");//短文本

		String MEINS = newretTable.getString("MEINS");//订购单位

		String MENGE = newretTable.getString("MENGE");//采购数量

		String WAERS = newretTable.getString("WAERS");//币种

		String NETWR = newretTable.getString("NETWR");//付款金额

		String ZWERT1 = newretTable.getString("ZWERT1");//完税金额



       
		int no = j+1;
		String insql = "insert into uf_fn_wkpodetail (id,requestid,pono,poitem,shorttext,ordunit,ordnum,amount,currency,payamt)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+EBELN+"','"+EBELP+"','"+TXZ01+"','"+MEINS+"','"+MENGE+"','"+ZWERT1+"','"+WAERS+"','"+ZWERT1+"')";
		baseJdbc.update(insql);


	%>
		<TR id="<%="dataDetail_"+no %>">
		
		<TD  class="td2"   align=center ><%=EBELN %></TD>
		<TD  class="td2"   align=center ><%=EBELP %></TD>
		<TD  class="td2"   align=center ><%=TXZ01 %></TD>

		<TD   class="td2"  align=center><%=MEINS %></TD>

		<TD   class="td2"  align=center><%=MENGE %></TD>
		<TD   class="td2"  align=center><%=ZWERT1 %></TD>
		<TD   class="td2"  align=center><%=WAERS %></TD>
		<TD   class="td2"  align=center><%=ZWERT1 %></TD>
		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有采购订单信息</TD></TR>
<%} %>
</table>
</div>

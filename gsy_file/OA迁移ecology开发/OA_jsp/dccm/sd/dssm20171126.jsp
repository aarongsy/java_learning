<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*,java.text.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<head>
<style type="text/css">
.STYLE1 {
	font-family: "微软雅黑";
	font-size: 32px;
	font-weight: bold;
}
.STYLE2 {font-family: "微软雅黑";font-size: 22px;font-weight: bold;}
.STYLE3 {font-family: "微软雅黑";font-size: 15px;font-weight: bold;}
.STYLE6 {font-family: "微软雅黑"; font-size: 20px; }
.STYLE8 {
	font-family: "微软雅黑";
	font-size: 12px;
}
.STYLE11 {font-family: "微软雅黑"; font-weight: bold; font-size: 18px;}
body {
	margin-left: 30px;
	margin-right: 30px;
}
.STYLE13 {
	font-family: "微软雅黑";
	font-size: 22px;
	font-weight: bold;
}
.STYLE14 {
	font-size: 18px;
	font-weight: bold;
}
#footer { 
	position: absolute; 
	bottom: 0; 
	width: 100%; 
	height: 60px;/*脚部的高度*/ 
	clear:both; 
 } 

</style>
</head>
<body>
<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object> 
<%
	System.out.println("-----------------------------------------------");
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	DecimalFormat df = new DecimalFormat("#0.00"); 
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String excsql="begin p_dcminv_colcname('"+requestid+"'); end;";
	baseJdbc.update(excsql);
	excsql=" begin p_dcminv_col('a.exlistid,a.taxcode,b.invoicedate,b.invoiceno,b.invoicemoney,nvl(b.paymoney,0) paymoney ,b.beftaxmoney,b.taxrate,c.shipcomtxt,c.aimport','"+requestid+"'); end;";
	baseJdbc.update(excsql);

	String sql="select column_name from user_tab_cols where table_name ='V_DMSD_EXFEEQZMX' and lower(column_name) not in ('exlistid','taxcode','invoicedate','invoiceno','invoicemoney','paymoney','beftaxmoney','taxrate','shipcomtxt','aimport')";
	List list = baseJdbc.executeSqlForList(sql);
	Map map=null;
	List<String> listn=new ArrayList<String>();
	List<String> fee=new ArrayList<String>();
	List<String> taxlist=new ArrayList<String>();
	if(list.size()>0)
	{
		System.out.println(list.size());
		for(int j=0;j<list.size();j++)
		{
			map = (Map)list.get(j);
			String column_name1=StringHelper.null2String(map.get("column_name"));
			System.out.println("column_name1"+column_name1);
			listn.add(column_name1);
			fee.add("0");
			taxlist.add("0");

		}
	}
	Double taxtotal = 0.00; 
	Double amount = 0.00; 
	Double amountrm = 0.00; 
	Double nogst = 0.00; 


%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="3">&nbsp;<input id="print" type="button" value="打印" onclick="print();" />&nbsp;<input id="printforview" type="button" value="打印预览" onclick="printforview();" /></td>
  </tr>
  <tr>
    <td colspan="3" align="center"><span class="STYLE1">DAIREN CHEMICAL(M)SDN.BHD</span></td>
  </tr>
  <tr>
    <td colspan="3" align="center"><span class="STYLE2">Freight Invoice List</span></td>
  </tr>
   <tr >
    <td colspan="3" align="center" ><span>&nbsp;</span></td>
  </tr>
  <tr>
    <td width="25%" align="left"><span class="STYLE6">Page:1</span></td>
	<td width="50%" align="center"><span class="STYLE6">Ship Corporaion:RTW</span></td>
    <td width="25%" align="right"><span class="STYLE6">Pr.date:2017/09/10</span></td>

  </tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left" noWrap><span class="STYLE3">Inv.date</span></td>
	<td align="left" noWrap><span class="STYLE3">Inv No</span></td>
	<td align="right" width="90px" noWrap><span class="STYLE3">Inv.Amount</span></td>
	<td align="right" width="135px" noWrap><span class="STYLE3">Inv.Amount(RM)</span></td>
	<td align="left" noWrap><span class="STYLE3">&nbsp;Product</span></td>
	<td align="left" noWrap><span class="STYLE3">O/D NO</span></td>
	<td align="left" noWrap><span class="STYLE3">Freight Rate</span></td>
	<td align="left" noWrap><span class="STYLE3">C.No</span></td>
	<td align="left" noWrap><span class="STYLE3">Liner</span></td>
	<%
		for(int i=0;i<listn.size();i++)
		{
			String col=listn.get(i);
			%>
				<td align="right" noWrap><span class="STYLE3"><%=col+" Fee"%></span></td>
			<%

		}
	%>
	<td align="left" noWrap><span class="STYLE3">To Port</span></td>
  </tr>
  <tr >
    <td align="left" noWrap style="border-bottom:1px solid;"><span class="STYLE3">Tax Code</span></td>
	<td align="left" noWrap style="border-bottom:1px solid;"><span class="STYLE3">Tax Total</span></td>
	<td align="right" noWrap colspan="2" style="border-bottom:1px solid;"><span class="STYLE3">No GST Amount(RM)</span></td>
	<td align="right" noWrap colspan="5" style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>
	<%
		for(int i=0;i<listn.size();i++)
		{
			String col=listn.get(i);
			%>
				<td align="right" noWrap style="border-bottom:1px solid;"><span class="STYLE3"><%=col+" Tax"%></span></td>
			<%

		}
	%>
	<td align="left" noWrap style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>
  </tr>
	<%
	sql="select a.* from v_dmsd_exfeeqzmx a order by invoicedate"; 
	//a.exlistid,a.taxcode,b.invoicedate,b.invoiceno,b.invoicemoney,b.paymoney,b.beftaxmoney,b.taxrate,c.shipcomtxt,c.aimport
	list = baseJdbc.executeSqlForList(sql);
	map=null;
	System.out.println(list.size());
	if(list.size()>0){
		for(int k=0;k<list.size();k++)
		{

			map = (Map)list.get(k);
			String invoicedate=StringHelper.null2String(map.get("invoicedate"));
			String invoiceno=StringHelper.null2String(map.get("invoiceno"));
			String beftaxmoney=StringHelper.null2String(map.get("beftaxmoney"));
			String invoicemoney=StringHelper.null2String(map.get("invoicemoney"));
			String exlistid=StringHelper.null2String(map.get("exlistid"));
			String taxcode=StringHelper.null2String(map.get("taxcode"));
			String paymoney=StringHelper.null2String(map.get("paymoney"));
			String taxrate=StringHelper.null2String(map.get("taxrate"));
			String shipcomtxt=StringHelper.null2String(map.get("shipcomtxt"));
			String aimport=StringHelper.null2String(map.get("aimport"));
			amount=amount+Double.valueOf(paymoney);
			amountrm=amountrm+Double.valueOf(invoicemoney);
			String tax=df.format(Double.valueOf(invoicemoney)*Double.valueOf(taxrate)/100);
			taxtotal=taxtotal+Double.valueOf(tax);
			String gsttotal=df.format(Double.valueOf(invoicemoney)*(100-Double.valueOf(taxrate))/100);
			nogst=nogst+Double.valueOf(gsttotal);
			%>
			<tr >
			<td align="left" noWrap><span class="STYLE8"><%=invoicedate%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%=invoiceno%></span></td>
			<td align="right" width="90px" noWrap><span class="STYLE8"><%=paymoney%></span></td>
			<td align="right" width="135px" noWrap><span class="STYLE8"><%=invoicemoney%></span></td>
			<td align="left" noWrap><span class="STYLE8">&nbsp;<%="EVA"%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%=exlistid%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%="180.00(110)"%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%="1"%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%=shipcomtxt%></span></td>
			<%
				for(int k1=0;k1<listn.size();k1++)
				
			{
				String name=listn.get(k1);
				String lvalue2=StringHelper.null2String(map.get(listn.get(k1)));
				String feesum=df.format(Double.valueOf(fee.get(k1))+Double.valueOf(lvalue2));
				fee.set(k1,feesum);
				%>
				<td align="right" noWrap><span class="STYLE8"><%=lvalue2%></span></td>
				<%
			}
			%>
			<td align="left" noWrap><span class="STYLE8">&nbsp;<%="port"%></span></td>
			</tr>
			<tr >
			<td align="left" noWrap><span class="STYLE8"><%=taxcode%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%=tax%></span></td>
			<td align="right" width="90px" noWrap><span class="STYLE8">&nbsp;</span></td>
			<td align="right" width="135px" noWrap><span class="STYLE8"><%=gsttotal%></span></td>
			<td align="left" noWrap colspan="5"><span class="STYLE8">&nbsp;</span></td>

			<%
				for(int k1=0;k1<listn.size();k1++)
				
			{
				String name=listn.get(k1);
				String lvalue2=StringHelper.null2String(map.get(listn.get(k1)));
				String sum=df.format(Double.valueOf(lvalue2)*Double.valueOf(taxrate)/100);
				String feesum=df.format(Double.valueOf(taxlist.get(k1))+Double.valueOf(sum));
				taxlist.set(k1,feesum);
				%>
				<td align="right" noWrap><span class="STYLE8"><%=sum%></span></td>
				<%
			}
			%>
			<td align="left" noWrap><span class="STYLE8">&nbsp;</span></td>
			</tr>
			<%
		}
	}
	%>
	<tr>
		<td align="left" noWrap style="border-top:1px solid;"><span class="STYLE8">Total</span></td>
		<td align="left" noWrap style="border-top:1px solid;"><span class="STYLE8">&nbsp;</span></td>
		<td align="right" width="90px" noWrap style="border-top:1px solid;"><span class="STYLE8"><%=amount%></span></td>
		<td align="right" width="135px" noWrap style="border-top:1px solid;"><span class="STYLE8"><%=amountrm%></span></td>
		<td align="left" noWrap colspan="5" style="border-top:1px solid;"><span class="STYLE8">&nbsp;</span></td>
		<%
			for(int k2=0;k2<fee.size();k2++)
				
			{
				String lvalue3=fee.get(k2);
				%>
				<td align="right" noWrap style="border-top:1px solid;"><span class="STYLE8"><%=lvalue3%></span></td>
				<%
			}
		%>
		<td align="left" noWrap style="border-top:1px solid;"><span class="STYLE8">&nbsp;</span></td>
	</tr>
	<tr>
		<td align="left" noWrap><span class="STYLE8">&nbsp;</span></td>
		<td align="left" noWrap><span class="STYLE8"><%=taxtotal%></span></td>
		<td align="right" width="90px" noWrap><span class="STYLE8">&nbsp;</span></td>
		<td align="right" width="135px" noWrap><span class="STYLE8"><%=nogst%></span></td>
		<td align="left" noWrap colspan="5"><span class="STYLE8">&nbsp;</span></td>
		<%
			for(int k3=0;k3<taxlist.size();k3++)
				
			{
				String lvalue=taxlist.get(k3);
				%>
				<td align="right" noWrap><span class="STYLE8"><%=lvalue%></span></td>
				<%
			}
		%>
		<td align="left" noWrap><span class="STYLE8">&nbsp;</span></td>
	</tr>
</table>
<div id="footer">
<table width="100%" border="0" cellpadding="0" cellspacing="0"  >
  <tr>
    <td width="40%" align="left" noWrap style="border-top:1px solid;"><span class="STYLE3">Approveed by:</span></td>
	<td width="40%" align="left" noWrap style="border-top:1px solid;"><span class="STYLE3">Checked by:</span></td>
    <td width="20%" align="left" noWrap style="border-top:1px solid;"><span class="STYLE3">Prepared by:</span></td>
  </tr>
    <tr>
    <td width="40%" align="left" noWrap><span class="STYLE3">Date:</span></td>
	<td width="40%" align="left" noWrap><span class="STYLE3">Date:</span></td>
    <td width="20%" align="left" noWrap><span class="STYLE3">Date:</span></td>
  </tr>
</table>
</div>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<script type="text/javascript">
var HKEY_Root,HKEY_Path,HKEY_Key; 
HKEY_Root="HKEY_CURRENT_USER"; 
HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\"; 
//设置网页打印的页眉页脚为空 
function PageSetup_Null() { 
	try { 
		var Wsh=new ActiveXObject("WScript.Shell"); 
		HKEY_Key="header"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="footer"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="margin_left";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_right";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_top";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	    HKEY_Key="margin_bottom";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	} catch(e) {} 
} 
//打印
function print(){
	PageSetup_Null();
	//打印
	//隐藏打印按钮和打印预览按钮
	jQuery("#print").css("display","none");
	jQuery("#printforview").css("display","none");
	WebBrowser.ExecWB(6,1);

}
//打印预览
function printforview(){
	PageSetup_Null();
	//打印
	//隐藏打印按钮和打印预览按钮
	jQuery("#print").css("display","none");
	jQuery("#printforview").css("display","none");
	WebBrowser.ExecWB(7,1);
}
</script>
</body>
</html>
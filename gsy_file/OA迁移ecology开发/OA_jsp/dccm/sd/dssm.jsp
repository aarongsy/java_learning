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
.STYLE1 {font-family: "微软雅黑";font-size: 32px;font-weight: bold;}
.STYLE2 {font-family: "微软雅黑";font-size: 22px;font-weight: bold;}
.STYLE3 {font-family: "微软雅黑";font-size: 15px;font-weight: bold;}
.STYLE6 {font-family: "微软雅黑";font-size: 20px;}
.STYLE8 {font-family: "微软雅黑";font-size: 12px;}
.STYLE11 {font-family: "微软雅黑";font-weight: bold; font-size: 18px;}
body {margin-left: 30px;margin-right: 30px;}
.STYLE13 {font-family: "微软雅黑";font-size: 22px;font-weight: bold;}
.STYLE14 {font-size: 18px;font-weight: bold;}
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
	//System.out.println("-----------------------------------------------");
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	DecimalFormat df = new DecimalFormat("#0.00"); 
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String excsql = "begin p_dcminv_colcname('"+requestid+"'); end;";
	baseJdbc.update(excsql);
	excsql = " begin p_dcminv_col('a.exlistid,c.shipcomtxt,c.aimport','"+requestid+"'); end;";
	baseJdbc.update(excsql);

	String sql="select column_name from user_tab_cols where table_name ='V_DMSD_EXFEEQZMX' and lower(column_name) not in ('exlistid','taxcode','invoicedate','invoiceno','invoicemoney','paymoney','beftaxmoney','taxrate','shipcomtxt','aimport')";
	List list = baseJdbc.executeSqlForList(sql);
	Map map=null;
	List<String> listn = new ArrayList<String>();//费用名称
	List<String> listnr = new ArrayList<String>();//费用名称对应税码
	List<String> listnl = new ArrayList<String>();//费用名称对应税率
	List<String> fee = new ArrayList<String>();
	List<String> taxlist = new ArrayList<String>();
	boolean flag = true;
	String taxcode = "ZP";
	int docfee=0;//存在docfee
	int otfee=0;//存在otherfee
	if(list.size()>0)
	{
		//System.out.println(list.size());
		for(int j=0;j<list.size();j++)
		{
			map = (Map)list.get(j);
			String column_name1=StringHelper.null2String(map.get("column_name"));
			System.out.println("column_name1"+column_name1);
			if(column_name1.equals("EDI"))
			{
				docfee++;
			}
			if(column_name1.equals("BL"))
			{
				docfee=docfee+2;
			}
			if(column_name1.equals("SEAL"))
			{
				otfee++;
			}
			if(column_name1.equals("ENS"))
			{
				otfee=otfee+2;
			}

		}
		if(docfee>0)
		{
			listn.add("DOC");
			String ratesql="select taxcode,(select rate from uf_dmsd_taxwh where tax =taxcode) rate from uf_dmsd_exfeeqzmx where requestid='"+requestid+"' and feetype in(select feename from uf_dmdb_feename  t  where imextype='40285a8d56d542730156e95e821c3061' and (upper(des)='EDI' OR upper(des)='BL'))";
			//System.out.println("ratesql:"+ratesql);
			List ratelist = baseJdbc.executeSqlForList(ratesql);
			if(ratelist.size()>0)
			{
				Map ratemap = (Map)ratelist.get(0);
				String tcode=StringHelper.null2String(ratemap.get("taxcode"));
				listnr.add(tcode);
				listnl.add(StringHelper.null2String(ratemap.get("rate")));
				fee.add("0");
				taxlist.add("0");
			}
		}
		for(int j=0;j<list.size();j++)
		{
			map = (Map)list.get(j);
			String column_name1=StringHelper.null2String(map.get("column_name"));
			//System.out.println("column_name1"+column_name1);
			listn.add(column_name1);
			String ratesql="select taxcode,(select rate from uf_dmsd_taxwh where tax =taxcode) rate from uf_dmsd_exfeeqzmx where requestid='"+requestid+"' and feetype =(select feename from uf_dmdb_feename  t  where imextype='40285a8d56d542730156e95e821c3061' and upper(des)='"+column_name1+"')";
			//System.out.println("ratesql:"+ratesql);
			List ratelist = baseJdbc.executeSqlForList(ratesql);
			if(ratelist.size()>0)
			{
				Map ratemap = (Map)ratelist.get(0);
				String tcode=StringHelper.null2String(ratemap.get("taxcode"));
				listnr.add(tcode);
				if(!tcode.equals("ZP"))
				{
					flag=false;
				}
				listnl.add(StringHelper.null2String(ratemap.get("rate")));
				fee.add("0");
				taxlist.add("0");
			}
		}
		if(otfee>0)
		{
			listn.add("OTHER");
			String ratesql="select taxcode,(select rate from uf_dmsd_taxwh where tax =taxcode) rate from uf_dmsd_exfeeqzmx where requestid='"+requestid+"' and feetype in(select feename from uf_dmdb_feename  t  where imextype='40285a8d56d542730156e95e821c3061' and (upper(des)='SEAL' OR upper(des)='ENS'))";
			//System.out.println("ratesql:"+ratesql);
			List ratelist = baseJdbc.executeSqlForList(ratesql);
			if(ratelist.size()>0)
			{
				Map ratemap = (Map)ratelist.get(0);
				String tcode=StringHelper.null2String(ratemap.get("taxcode"));
				listnr.add(tcode);
				listnl.add(StringHelper.null2String(ratemap.get("rate")));
				fee.add("0");
				taxlist.add("0");
			}
		}
	}
	if(!flag)
	{
		taxcode="";
	}
	Double taxtotal = 0.00; 
	Double amount = 0.00; 
	Double amountrm = 0.00; 
	Double nogst = 0.00; 
	sql="select to_char(sysdate,'yyyy/mm/dd') as nowdate from dual";
	list = baseJdbc.executeSqlForList(sql);
	map = (Map)list.get(0);
	String nowdate=StringHelper.null2String(map.get("nowdate"));


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
    <td width="25%" align="right"><span class="STYLE6">Pr.date:<%=nowdate%></span></td>

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
    <td align="left" noWrap><span class="STYLE3">Tax Code</span></td>
	<td align="left" noWrap><span class="STYLE3">Tax Total</span></td>
	<td align="right" noWrap colspan="2"><span class="STYLE3">No GST Amount(RM)</span></td>
	<td align="right" noWrap colspan="5" ><span class="STYLE3">&nbsp;</span></td>

	<%
		for(int i=0;i<listn.size();i++)
		{
			String col=listn.get(i);
			%>
				<td align="right" noWrap><span class="STYLE3"><%=col+" Tax"%></span></td>
			<%

		}
	%>

	<td align="left" noWrap><span class="STYLE3">&nbsp;</span></td>
  </tr>

    <tr >
    <td align="left" noWrap style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>
	<td align="left" noWrap style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>
	<td align="right" noWrap colspan="2" style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>
	<td align="right" noWrap colspan="5" style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>

	<%
		for(int i=0;i<listnr.size();i++)
		{
			String taxc=listnr.get(i);
			%>
				<td align="right" noWrap style="border-bottom:1px solid;"><span class="STYLE3"><%=taxc%></span></td>
			<%

		}
	%>

	<td align="left" noWrap style="border-bottom:1px solid;"><span class="STYLE3">&nbsp;</span></td>
  </tr>

	<%
	sql="select "; 
	if(docfee==1)
	{
		sql=sql+" (a.EDI)as DOC, ";
	}
	if(docfee==2)
	{
		sql=sql+" (a.BL)as DOC, ";
	}
	if(docfee==3)
	{
		sql=sql+" (a.EDI+a.BL)as DOC, ";
	}
	sql=sql+" a.* ";	
	if(otfee==1)
	{
		sql=sql+" ,(a.SEAL)as OTHER ";
	}
	if(otfee==2)
	{
		sql=sql+" ,(a.ENS)as OTHER ";
	}
	if(otfee==3)
	{
		sql=sql+" ,(a.SEAL+a.ENS)as OTHER ";
	}
	sql=sql+" from v_dmsd_exfeeqzmx a order by exlistid";
	//a.exlistid,a.taxcode,b.invoicedate,b.invoiceno,b.invoicemoney,b.paymoney,b.beftaxmoney,b.taxrate,c.shipcomtxt,c.aimport
	list = baseJdbc.executeSqlForList(sql);
	map=null;
	System.out.println(sql);
	if(list.size()>0)
	{
		for(int k=0;k<list.size();k++)
		{
			map = (Map)list.get(k);
			String inc="select b.invoicedate,b.invoiceno from uf_dmsd_exfeeqzfp b where requestid='"+requestid+"'";
			List inclist = baseJdbc.executeSqlForList(inc);
			Map incmap= (Map)inclist.get(0);
			String invoicedate=StringHelper.null2String(incmap.get("invoicedate"));
			String invoiceno=StringHelper.null2String(incmap.get("invoiceno"));
			String exlistid=StringHelper.null2String(map.get("exlistid"));

			String shipcomtxt=StringHelper.null2String(map.get("shipcomtxt"));
			String aimport=StringHelper.null2String(map.get("aimport"));

			//String tax=df.format(Double.valueOf(invoicemoney)*Double.valueOf(taxrate)/100);
			//taxtotal=taxtotal+Double.valueOf(tax);
			//String gsttotal=df.format(Double.valueOf(invoicemoney)*(100-Double.valueOf(taxrate))/100);
			//nogst=nogst+Double.valueOf(gsttotal);
			%>
			<tr >
			<td align="left" noWrap><span class="STYLE8"><%=invoicedate%></span></td>
			<td align="left" noWrap><span class="STYLE8"><%=invoiceno%></span></td>
			<%
			String invoicemoney="0";
			
			for(int k1=0;k1<listn.size();k1++)
			{
				System.out.println(listn.get(k1));
				String lvalue2=StringHelper.null2String(map.get(listn.get(k1)));
				invoicemoney=df.format(Double.valueOf(invoicemoney)+Double.valueOf(lvalue2));
			}
			String paymoney="0";//invoicemoney/usd 的汇率
			amount=amount+Double.valueOf(paymoney);
			amountrm=amountrm+Double.valueOf(invoicemoney);
			%>
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
				System.out.println("name"+name);
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
			<%
			String tax="0";
			String gsttotal="0";
			
			for(int k1=0;k1<listn.size();k1++)
				
			{
				String name=listn.get(k1);
				String lvalue2=StringHelper.null2String(map.get(listn.get(k1)));
				String taxrate1=listnl.get(k1);

				String sum=df.format(Double.valueOf(lvalue2)*Double.valueOf(taxrate1)/100);
				String sum1=df.format(Double.valueOf(lvalue2)*(100-Double.valueOf(taxrate1))/100);
				tax=df.format(Double.valueOf(tax)+Double.valueOf(sum));
				gsttotal=df.format(Double.valueOf(gsttotal)+Double.valueOf(sum1));

			}
			taxtotal=taxtotal+Double.valueOf(tax);
			nogst=nogst+Double.valueOf(gsttotal);
			%>

			<td align="left" noWrap><span class="STYLE8"><%=tax%></span></td>
			<td align="right" width="90px" noWrap><span class="STYLE8">&nbsp;</span></td>
			<td align="right" width="135px" noWrap><span class="STYLE8"><%=gsttotal%></span></td>
			<td align="left" noWrap colspan="5"><span class="STYLE8">&nbsp;</span></td>

			<%
				for(int k1=0;k1<listn.size();k1++)
				
			{
				String name=listn.get(k1);
				String lvalue2=StringHelper.null2String(map.get(listn.get(k1)));
				String taxrate1=listnl.get(k1);
				String sum=df.format(Double.valueOf(lvalue2)*Double.valueOf(taxrate1)/100);
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
		<td align="right" width="90px" noWrap style="border-top:1px solid;"><span class="STYLE8"><%=df.format(amount)%></span></td>
		<td align="right" width="135px" noWrap style="border-top:1px solid;"><span class="STYLE8"><%=df.format(amountrm)%></span></td>
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
		<td align="left" noWrap><span class="STYLE8"><%=df.format(taxtotal)%></span></td>
		<td align="right" width="90px" noWrap><span class="STYLE8">&nbsp;</span></td>
		<td align="right" width="135px" noWrap><span class="STYLE8"><%=df.format(nogst)%></span></td>
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
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
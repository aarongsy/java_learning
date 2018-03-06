<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.*"%>
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
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="java.text.DecimalFormat;"%>

<%
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
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
    height: 30px; 
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


<script type="text/javascript">
function trim(str){ //删除左右两端的空格
　　return str.replace(/(^\s*)|(\s*$)/g, "");
}


function exportExcel(tableid){     
    var oXL = new ActiveXObject('Excel.Application');      
    var oWB = oXL.Workbooks.Add(); 
	var laprows = 1;
	if(tableid!='' && tableid!=null && tableid!='null'){
	    var oSheet = oWB.ActiveSheet;  
		var table = document.getElementById(tableid) ;     
		var hang = table.rows.length;     
		var lie = table.rows(0).cells.length;     
		for (i=0;i<hang;i++){     
			for (j=0;j<lie;j++){     
				oSheet.Cells(i+1,j+1).NumberFormatLocal = '@';     
				oSheet.Cells(i+1,j+1).Font.Bold = true;     
				oSheet.Cells(i+1,j+1).Font.Size = 10;     
				oSheet.Cells(i+1,j+1).value = trim(table.rows(i).cells(j).innerText);     
			}     
		}  
	}
    oXL.Visible = true;     
    oXL.UserControl = true;     
} 
</script>


<div id="warpp"  >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<caption align=left><STRONG>Ocean Freight Fee Detail</STRONG>&nbsp;&nbsp;<span><A href="javascript:exportExcel('dataTable')"><FONT color=#ff0000>ExportToExcel</FONT></A></span></caption>
<COLGROUP>
<COL width=100>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
</COLGROUP>

<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>NO.</TD>
<TD  noWrap class="td2"  align=center>Current Node</TD>
<TD  noWrap class="td2"  align=center>O/D NO.</TD>
<TD  noWrap class="td2"  align=center>S/O</TD>
<TD  noWrap class="td2"  align=center>Order Number</TD>
<TD  noWrap class="td2"  align=center>Closing Date</TD>
<TD  noWrap class="td2"  align=center>ETD</TD>
<TD  noWrap class="td2"  align=center>ETA</TD>
<TD  noWrap class="td2"  align=center>Cont. NO</TD>
<TD  noWrap class="td2"  align=center>Freight(F.C.)</TD>
<TD  noWrap class="td2"  align=center>Curr.</TD>
<TD  noWrap class="td2"  align=center>Ex.Rate</TD>
<TD  noWrap class="td2"  align=center>O/F(F.C.)</TD>
<TD  noWrap class="td2"  align=center>O/F</TD>
<TD  noWrap class="td2"  align=center>THC</TD>
<TD  noWrap class="td2"  align=center>DOC</TD>
<TD  noWrap class="td2"  align=center>TLX PLS</TD>
<TD  noWrap class="td2"  align=center>Other</TD>
<TD  noWrap class="td2"  align=center>O/F(TAX)</TD>
<TD  noWrap class="td2"  align=center>THC(TAX)</TD>
<TD  noWrap class="td2"  align=center>DOC(TAX)</TD>
<TD  noWrap class="td2"  align=center>Other(TAX)</TD>
<TD  noWrap class="td2"  align=center>TLX(TAX)</TD>
<TD  noWrap class="td2"  align=center>TOTAL</TD>
<TD  noWrap class="td2"  align=center>Port To</TD>
<TD  noWrap class="td2"  align=center>Product</TD>
<TD  noWrap class="td2"  align=center>Ship Corp.</TD>
<TD  noWrap class="td2"  align=center>Shipping Line/Tranship</TD>
<TD  noWrap class="td2"  align=center>Trans.Flag</TD>
<TD  noWrap class="td2"  align=center>Remark</TD>
<TD  noWrap class="td2"  align=center>Inv.NO</TD>
</tr>

<%
DecimalFormat df = new DecimalFormat("#.00");
String sql= "select * from v_dmsd_oceanfee";
List list = baseJdbc.executeSqlForList(sql);
double calvalue1=0.0;//O/F(F.C.)
double calvalue2=0.0;//O/F
double calvalue3=0.0;//THC
double calvalue4=0.0;//DOC
double calvalue5=0.0;//Other

double taxvalue1=0.0;//O/F(TAX)
double taxvalue2=0.0;//THC(TAX)
double taxvalue3=0.0;//DOC(TAX)
double taxvalue4=0.0;//Other(TAX)
double taxvalue5=0.0;//TLX(TAX)
double totalvalue=0.0;//TOTAL
String str1="";
String str2="";
String str3="";
String str4="";
String str5="";
String str6="";
String str7="";
String str8="";
String str9="";
String str10="";
String str11="";
if(list.size()>0)
{
	for(int i=0;i<list.size();i++)
	{
		Map map = (Map)list.get(i);
		String curnode = StringHelper.null2String(map.get("currentnode"));//出口费用请款的当前环节
		String expno = StringHelper.null2String(map.get("expno"));//外销联络单编号
		String shipno = StringHelper.null2String(map.get("shipno"));//订船编号
		String ordnotxt = StringHelper.null2String(map.get("purorderno"));//销售凭证号
		String jgdate = StringHelper.null2String(map.get("cleardate"));//结关日
		String khdate = StringHelper.null2String(map.get("saildate"));//开航日
		String dgdate = StringHelper.null2String(map.get("toportdate"));//到港日
		String gs=StringHelper.null2String(map.get("gs"));//货柜数量
		if(gs.equals(""))
		{
			gs="0";
		}
		String freight=StringHelper.null2String(map.get("freight"));//海运费
		if(freight.equals(""))
		{
			freight="0";
		}
		freight=String.format("%.2f", Double.valueOf(freight));

		String freightcurr=StringHelper.null2String(map.get("freightcurr"));//海运费币种
		String exrate=StringHelper.null2String(map.get("rate"));//汇率(清帐发票输入)
		if(exrate.equals(""))
		{
			exrate="0";
		}
		calvalue1=Double.valueOf(gs)*Double.valueOf(freight);//海运费*柜数(O/F(F.C.))
		calvalue2=calvalue1*Double.valueOf(exrate);//海运费*柜数*汇率(O/F)
		String thc = StringHelper.null2String(map.get("thc"));//THC
		if(thc.equals(""))
		{
			thc="0";
		}
		calvalue3=Double.valueOf(thc)*Double.valueOf(gs);//THC*柜数
		String bl=StringHelper.null2String(map.get("bl"));//BL
		if(bl.equals(""))
		{
			bl="0";
		}
		String edi=StringHelper.null2String(map.get("edi"));//EDI
		if(edi.equals(""))
		{
			edi="0";
		}
		calvalue4=Double.valueOf(bl)+Double.valueOf(edi);//DOC(BL+EDI)
		String tlxpls=StringHelper.null2String(map.get("tlxpls"));//TLX PLS
		if(tlxpls.equals(""))
		{
			tlxpls="0";
		}
		String sealcurr=StringHelper.null2String(map.get("sealcurr"));//SEALcurr
		String seal=StringHelper.null2String(map.get("seal"));//SEAL
		if(seal.equals(""))
		{
			seal="0";
		}
		String ens=StringHelper.null2String(map.get("ens"));//ENS
		if(ens.equals(""))
		{
			ens="0";
		}

		if(sealcurr.equals("MYR"))//马币
		{
				calvalue5=Double.valueOf(seal)*Double.valueOf(gs)+Double.valueOf(ens);//Other
		}
		else//美元
		{
				calvalue5=Double.valueOf(seal)*Double.valueOf(gs)*Double.valueOf(exrate)+Double.valueOf(ens);//Other
		}
		String taxrate=StringHelper.null2String(map.get("taxrate"));//税率
		if(taxrate.equals(""))
		{
			taxrate="0";
		}

		taxvalue1=calvalue2*Double.valueOf(taxrate)/100;//O/F(TAX)
		taxvalue2=calvalue3*Double.valueOf(taxrate)/100;//THC(TAX)
		taxvalue3=calvalue4*Double.valueOf(taxrate)/100;//DOC(TAX)
		taxvalue4=calvalue5*Double.valueOf(taxrate)/100;//Other(TAX)
		taxvalue5=Double.valueOf(tlxpls)*Double.valueOf(taxrate)/100;//TLX(TAX)
		totalvalue=calvalue2+calvalue3+calvalue4+calvalue5+taxvalue1+taxvalue2+taxvalue3+taxvalue4+taxvalue5;//TOTAL

		String toport=StringHelper.null2String(map.get("mdg"));//目的港
		String product=StringHelper.null2String(map.get("procategory"));//产品大类
		String shipcorp=StringHelper.null2String(map.get("sagentname"));//海运代理商
		String liner=StringHelper.null2String(map.get("shipcomtxt"));//船公司
		String transflag="";
		String remark="";
		String invno=StringHelper.null2String(map.get("invoiceno"));//发票号码

		str1=String.valueOf(calvalue1);
		str1=String.format("%.2f", Double.valueOf(str1));

		str2=String.valueOf(calvalue2);
		str2=String.format("%.2f", Double.valueOf(str2));

		str3=String.valueOf(calvalue3);
		str3=String.format("%.2f", Double.valueOf(str3));

		str4=String.valueOf(calvalue4);
		str4=String.format("%.2f", Double.valueOf(str4));

		str5=String.valueOf(calvalue5);
		str5=String.format("%.2f", Double.valueOf(str5));

		str6=String.valueOf(taxvalue1);
		str6=String.format("%.2f", Double.valueOf(str6));

		str7=String.valueOf(taxvalue2);
		str7=String.format("%.2f", Double.valueOf(str7));

		str8=String.valueOf(taxvalue3);
		str8=String.format("%.2f", Double.valueOf(str8));

		str9=String.valueOf(taxvalue4);
		str9=String.format("%.2f", Double.valueOf(str9));

		str10=String.valueOf(taxvalue5);
		str10=String.format("%.2f", Double.valueOf(str10));

		str11=String.valueOf(totalvalue);
		str11=String.format("%.2f", Double.valueOf(str11));
%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center><%=i+1 %></TD>
		<TD noWrap  class="td2"  align=center><%= curnode%></TD>
		<TD noWrap  class="td2"  align=center><%= expno%></TD>
		<TD noWrap  class="td2"  align=center><%= shipno%></TD>
		<TD noWrap  class="td2"  align=center><%= ordnotxt%></TD>
		<TD noWrap  class="td2"  align=center><%= jgdate%></TD>
		<TD noWrap  class="td2"  align=center><%= khdate%></TD>
		<TD noWrap  class="td2"  align=center><%= dgdate%></TD>
		<TD noWrap  class="td2"  align=center><%= gs%></TD>
		<TD noWrap  class="td2"  align=center><%= freight%></TD>
		<TD noWrap  class="td2"  align=center><%= freightcurr%></TD>
		<TD noWrap  class="td2"  align=center><%= exrate%></TD>

		<TD noWrap  class="td2"  align=center><%= str1%></TD>
		<TD noWrap  class="td2"  align=center><%= str2%></TD>
		<TD noWrap  class="td2"  align=center><%= str3%></TD>
		<TD noWrap  class="td2"  align=center><%= str4%></TD>
		<TD noWrap  class="td2"  align=center><%= tlxpls%></TD>
		<TD noWrap  class="td2"  align=center><%= str5%></TD>

		<TD noWrap  class="td2"  align=center><%= str6%></TD>
		<TD noWrap  class="td2"  align=center><%= str7%></TD>
		<TD noWrap  class="td2"  align=center><%= str8%></TD>
		<TD noWrap  class="td2"  align=center><%= str9%></TD>
		<TD noWrap  class="td2"  align=center><%= str10%></TD>
		<TD noWrap  class="td2"  align=center><%= str11%></TD>

		<TD noWrap  class="td2"  align=center><%= toport%></TD>
		<TD noWrap  class="td2"  align=center><%= product%></TD>
		<TD noWrap  class="td2"  align=center><%= shipcorp%></TD>
		<TD noWrap  class="td2"  align=center><%= liner%></TD>
		<TD noWrap  class="td2"  align=center><%= transflag%></TD>
		<TD noWrap  class="td2"  align=center><%= remark%></TD>
		<TD noWrap  class="td2"  align=center><%= invno%></TD>
		</TR>
<%
	}
}
else
{
%> 
		<TR><TD class="td2" colspan="12">NO Message!</TD></TR>
<%
} 
%>
</table>
</div>

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
String supply = StringHelper.null2String(request.getParameter("supply"));//供应商简码
String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
String str = StringHelper.null2String(request.getParameter("str"));//凭证号@总账科目@会计年度
System.out.println("supply:"+supply);
System.out.println("comcode:"+comcode);
System.out.println("str:::::"+str);
String type = "S";

BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
//String nodeshow = StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

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
<table id="dataTable1" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="8%">
<COL width="10%">
<COL width="8%">
<COL width="10%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>Serial Number</TD><!--序号-->
<TD  noWrap class="td2"  align=center>Customer/Supplier Logo</TD><!--客户/供应商标识-->
<TD  noWrap class="td2"  align=center>Subject</TD><!--科目-->
<TD  noWrap class="td2"  align=center>Special Ledger Logo</TD><!--特别总账标识-->
<TD  noWrap class="td2"  align=center>Clear Voucher Number</TD><!--需清帐凭证编号-->
<TD  noWrap class="td2"  align=center>Fiscal Year</TD><!--会计年度-->
<TD  noWrap class="td2"  align=center>Clear Voucher Line</TD><!--需清帐凭证项次-->
<TD  noWrap class="td2"  align=center>Clear Lave Amount</TD><!--清帐剩余金额-->
<TD  noWrap class="td2"  align=center>Local Amount</TD><!--本位币金额-->
<TD  noWrap class="td2"  align=center>Order NO</TD><!--采购订单号-->
<TD  noWrap class="td2"  align=center>Order Item</TD><!--采购订单项次-->
<TD  noWrap class="td2"  align=center>Clear Text</TD><!--清帐文本-->
</TR>

<%
//清空未清项明细
String delsql = "delete uf_dmph_uncleariinfo  where requestid = '"+requestid+"'";
baseJdbc.update(delsql);
String [] aa = str.split("@");
//int count=aa.length/3;
//System.out.println("count:"+count);
//创建SAP对象		
SapConnector sapConnector = new SapConnector();
String functionName = "ZOA_FI_CLEAR_READ";
JCoFunction function = null;
try {
	function = SapConnector.getRfcFunction(functionName);
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
function.getImportParameterList().setValue("BUKRS",comcode);//公司代码
function.getImportParameterList().setValue("LIFNR",supply);//供应商简码

//System.out.println(comcode);
//System.out.println(supply);
//function.getImportParameterList().setValue("AFLAG","X");//是否显示所有未清项信息(X表示”是“ ,""表示”否“)

//建表
JCoTable retTable1 = function.getTableParameterList().getTable("FI_GL_LIST");


//建表
JCoTable retTable = function.getTableParameterList().getTable("FI_OA_LIST");
//System.out.println("数组的长度为:"+aa.length);
//System.out.println("数组中的数据为:"+aa);
for(int i = 0;i<aa.length;i++)
{
	String pzh = aa[i];//凭证号
	//System.out.println("pzh:"+pzh);
	String year = aa[i+2];//会计年度
	//System.out.println("year:"+year);
	String subject = aa[i+1];//总账科目
	//System.out.println("subject:"+subject);
	
	
	//插入FI_GL_LIST
	retTable1.appendRow();
	//retTable1.setValue("HKONT", "55060500"); //总账科目
	retTable1.setValue("HKONT",subject); //总账科目
	
	//插入FI_OA_LIST
	retTable.appendRow();
	//retTable.setValue("BELNR","1500000043");//凭证编号
	retTable.setValue("BELNR",pzh);//凭证编号
	retTable.setValue("BUKRS", comcode);//公司代码
	retTable.setValue("GJAHR", year);//会计年度
	retTable.setValue("DTYPE", "S");//凭证类型
	i = i+2;
}

try {
	function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
} catch (JCoException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}

String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
String FLAG = function.getExportParameterList().getValue("FLAG").toString();
System.out.println(ERR_MSG);
System.out.println(FLAG);
			
//抓取抛SAP的返回值
JCoTable newretTable = function.getTableParameterList().getTable("FI_CLEAR_LIST");
//System.out.println("123123123:"+newretTable.getNumRows());
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

			String BUDAT = newretTable.getString("BUDAT");//过账日期
			String BUKRS = newretTable.getString("BUKRS");//公司代码
			String GJAHR = newretTable.getString("GJAHR");//会计年度
			String BELNR = newretTable.getString("BELNR");//凭证编号
			String BUZEI = newretTable.getString("BUZEI");//行项目号
			String WRBTR = newretTable.getString("WRBTR");//金额
			String DMBTR = newretTable.getString("DMBTR");//本位币金额
			String FDTAG = newretTable.getString("FDTAG");//到期日
			String ZUONR = newretTable.getString("ZUONR");//分配
			String SGTXT = newretTable.getString("SGTXT");//文本(默认费用名称)
			String HKONT = newretTable.getString("HKONT");//供应商/总账科目(此处写错了注释)
			String KOART = newretTable.getString("KOART");//供应商/总账科目
			//String KOART = newretTable.getString("KOART");//科目类型
			String UMSKZ = newretTable.getString("UMSKZ");//特殊总账标识
			String EBELN = newretTable.getString("EBELN");//采购订单号
			String EBELP = newretTable.getString("EBELP");//采购订单项次


			System.out.println("过账日期:"+BUDAT);
			System.out.println("金额:"+WRBTR);
			System.out.println("科目类型:"+KOART);

			int no = j+1;
			String insql = "insert into uf_dmph_uncleariinfo (id,requestid,sno,custsuppflag,custsuppcode,ledgerflag,clearreceiptid,fiscalyear,clearreceiptitem,surplusmoney,cleartext,rmbamount,pono,poitem)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+KOART+"','"+HKONT+"','"+UMSKZ+"','"+BELNR+"','"+GJAHR+"','"+BUZEI+"','"+WRBTR+"','"+SGTXT+"','"+DMBTR+"','"+EBELN+"','"+EBELP+"')";
			System.out.println(insql);
			baseJdbc.update(insql);
	%>
			<TR id="<%="dataDetail_"+no %>">
			<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>
			<TD  class="td2"   align=center ><%=KOART %></TD>
			<TD  class="td2"   align=center ><%=HKONT %></TD>
			<TD  class="td2"   align=center ><%=UMSKZ %></TD>
			<TD   class="td2"  align=center><%=BELNR %></TD>
			<TD   class="td2"  align=center><%=GJAHR %></TD>
			<TD   class="td2"  align=center><%=BUZEI %></TD>
			<TD   class="td2"  align=center><%=WRBTR %></TD>
			<TD   class="td2"  align=center><%=DMBTR %></TD>
			<TD   class="td2"  align=center><%=EBELN %></TD>
			<TD   class="td2"  align=center><%=EBELP %></TD>
			<TD   class="td2"  align=center><%=SGTXT %></TD>
			</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="12">NO Message!</TD></TR>
<%} %>
</table>
</div>

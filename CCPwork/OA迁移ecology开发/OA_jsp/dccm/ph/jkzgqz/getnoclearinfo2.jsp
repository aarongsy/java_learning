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
System.out.println("str:::::"+str);
String type = "S";

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
<table id="dataTable1" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="60">
<COL width="80">
<COL width="60">
<COL width="80">
<COL width="120">
<COL width="60">
<COL width="80">
<COL width="80">
<COL width="80">
<COL width="120">

</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>NO</TD>
<TD  noWrap class="td2"  align=center>supplier mark</TD>
<TD  noWrap class="td2"  align=center>supplier code</TD>
<TD  noWrap class="td2"  align=center>Special mark</TD>
<TD  noWrap class="td2"  align=center>document number</TD>
<TD  noWrap class="td2"  align=center>Fiscal year</TD>
<TD  noWrap class="td2"  align=center>items</TD>
<TD  noWrap class="td2"  align=center>amount</TD>
<TD  noWrap class="td2"  align=center>Money</TD>
<TD  noWrap class="td2"  align=center>Text</TD>
</tr>

<%
String delsql = "delete uf_dmph_uncleariinfo  where requestid = '"+requestid+"'";
baseJdbc.update(delsql);
String [] aa = str.split("@");
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

//建表
JCoTable retTable1 = function.getTableParameterList().getTable("FI_GL_LIST");


//建表
JCoTable retTable = function.getTableParameterList().getTable("FI_OA_LIST");
System.out.println("数组的长度为:"+aa.length);
System.out.println("数组中的数据为:"+aa);
for(int i = 0;i<aa.length;i++)
{
	String pzh = aa[i];//凭证号
	System.out.println("pzh"+pzh);

	String year = aa[i+2];//会计年度
	System.out.println("year"+year);
	String subject = aa[i+1];//总账科目
	System.out.println("subject"+subject);
	
	retTable1.appendRow();
	retTable1.setValue("HKONT", subject); //总账科目

	retTable.appendRow();
	retTable.setValue("BELNR", pzh);//凭证编号

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
//抓取抛SAP的返回值
JCoTable newretTable = function.getTableParameterList().getTable("FI_CLEAR_LIST");
System.out.println("123123123"+newretTable.getNumRows());
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
		//if(!newretTable.isLastRow())
		//{

			String BUDAT = newretTable.getString("BUDAT");//过账日期

			String BUKRS = newretTable.getString("BUKRS");//公司代码

			String GJAHR = newretTable.getString("GJAHR");//会计年度

			String BELNR = newretTable.getString("BELNR");//凭证编号

			String BUZEI = newretTable.getString("BUZEI");//行项目号

			String WRBTR = newretTable.getString("WRBTR");//金额

			String DMBTR = newretTable.getString("DMBTR");//本位币金额

			String FDTAG = newretTable.getString("FDTAG");//到期日

			String ZUONR = newretTable.getString("ZUONR");//分配
			String SGTXT = newretTable.getString("SGTXT");//文本
			String HKONT = newretTable.getString("HKONT");//供应商/总账科目
			
			String KOART = newretTable.getString("KOART");//科目类型

			String UMSKZ = newretTable.getString("UMSKZ");//特殊总账标识
			int no = j+1;
			String insql = "insert into uf_dmph_uncleariinfo (id,requestid,sno,custsuppflag,custsuppcode,ledgerflag,clearreceiptid,fiscalyear,clearreceiptitem,surplusmoney,cleartext,rmbamount)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','S','"+HKONT+"','"+UMSKZ+"','"+BELNR+"','"+GJAHR+"','"+BUZEI+"','"+WRBTR+"','"+SGTXT+"','"+DMBTR+"')";
			System.out.println(insql);
			baseJdbc.update(insql);
	%>
			<TR id="<%="dataDetail_"+no %>">
			<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>
			<TD  class="td2"   align=center ><%=type %></TD>
			<TD  class="td2"   align=center ><%=HKONT %></TD>
			<TD  class="td2"   align=center ><%=UMSKZ %></TD>

			<TD   class="td2"  align=center><%=BELNR %></TD>

			<TD   class="td2"  align=center><%=GJAHR %></TD>
			<TD   class="td2"  align=center><%=BUZEI %></TD>
			<TD   class="td2"  align=center><%=WRBTR %></TD>
			<TD   class="td2"  align=center><%=DMBTR %></TD>
			<TD   class="td2"  align=center><%=SGTXT %></TD>
			</TR>
	<%
		//}
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有清帐信息</TD></TR>
<%} %>
</table>
</div>

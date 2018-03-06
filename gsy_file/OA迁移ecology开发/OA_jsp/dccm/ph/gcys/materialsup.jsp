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

<%@ page import="com.eweaver.workflow.form.model.FormBase"%>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService"%>
<%@ page import="com.eweaver.base.security.util.PermissionTool"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>

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
//String requestid = StringHelper.null2String(request.getParameter("requestid"));
String year = StringHelper.null2String(request.getParameter("year"));//年


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



</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>年份</TD>
<TD  noWrap class="td2"  align=center>物料编号</TD>
<TD  noWrap class="td2"  align=center>物料描述</TD>
<TD  noWrap class="td2"  align=center>供应商账号</TD>
<TD  noWrap class="td2"  align=center>供应商名称</TD>
</tr>

<%
String delsql = "delete from uf_dmph_matersup ";
baseJdbc.update(delsql);

System.out.println("--------delete------"+delsql);

//创建SAP对象		
SapConnector sapConnector = new SapConnector();
String functionName = "ZOA_VENDOR_VALUATION_MY";
JCoFunction function = null;
try {
	function = SapConnector.getRfcFunction(functionName);
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
function.getImportParameterList().setValue("P_YEAR",year);//年


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
JCoTable newretTable = function.getTableParameterList().getTable("TAB_VENDOR");
System.out.println("--------2331------"+newretTable.getNumRows());
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
		String MATNR = newretTable.getString("MATNR");//物料编号

		String MAKTX = newretTable.getString("MAKTX");//物料描述

		String LIFNR = newretTable.getString("LIFNR");//供应商账号

		String ZNAME = newretTable.getString("ZNAME");//供应商名称

		//String CURYEAR = newretTable.getString("ZNAME");//当前年

		
		int no = j+1;
	//创建主表(同时 解决权限重构问题)

		StringBuffer buffer = new StringBuffer(512);
		buffer.append("insert into uf_dmph_matersup").append("(id,requestid,material,suppliername,supplierid,years,materialid) values").append("('").append(IDGernerator.getUnquieID()).
		append("',").append("'").append("$ewrequestid$").append("',");
		buffer.append("'").append(MAKTX).append("',");
		buffer.append("'").append(ZNAME).append("',");
		buffer.append("'").append(LIFNR).append("',");
		buffer.append("'").append(year).append("',");
		buffer.append("'").append(MATNR).append("')");
		FormBase formBase = new FormBase();
		//分类属性中的id
		String categoryid = "40285a8c5e550dba015e9361f1034a7c";
		//创建formbase
		formBase.setCreatedate(DateHelper.getCurrentDate());
		formBase.setCreatetime(DateHelper.getCurrentTime());
		formBase.setCreator("402881e70be6d209010be75668750014");
		formBase.setCategoryid(categoryid);
		formBase.setIsdelete(0);
		FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
		formBaseService.createFormBase(formBase);
		String insertSql = buffer.toString();
		insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
		baseJdbc.update(insertSql);
		PermissionTool permissionTool = new PermissionTool();
		permissionTool.addPermission(categoryid,formBase.getId(), "uf_dmph_matersup");
		
		
		
		
	
		//String insql = "insert into uf_dmph_matersup (id,requestid,years,materialid,material,supplierid,suppliername)values('"+IDGernerator.getUnquieID()+"','"+IDGernerator.getUnquieID()+"','"+year+"','"+MATNR+"','"+MAKTX+"','"+ZNAME+"','"+LIFNR+"')";
		//baseJdbc.update(insql);
		//System.out.println("--------2331------"+insql);
	%>
		<TR id="<%="dataDetail_"+no %>">

		<TD   class="td2"  align=center><%=year %></TD>		
		<TD  class="td2"   align=center ><%=MATNR %></TD>
		<TD  class="td2"   align=center ><%=MAKTX %></TD>
		<TD  class="td2"   align=center ><%=LIFNR %></TD>

		<TD   class="td2"  align=center><%=ZNAME %></TD>


		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>

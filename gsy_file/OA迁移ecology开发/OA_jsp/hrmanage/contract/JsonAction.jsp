<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<%@ page import="com.eweaver.app.configsap.SapConnector"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>

<%
String hid = StringHelper.null2String(request.getParameter("objname"));
String day = StringHelper.null2String(request.getParameter("sday"));

String oldyear = day.split("-")[0];
String mon = day.split("-")[1];
String days = day.split("-")[2];
int year = NumberHelper.string2Int(oldyear);
year = year - 1;
String sday = year+""+mon+""+days;
String eday = oldyear+""+mon+""+days;
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
Map map = null;
List list = null;
String sapid = "";//sap编号
String hours1 = "0";//事假时数
String hours2 = "0";//病假时数
String hours3 = "0";//延时加班时数
String hours4 = "0";//双休加班时数
String hours5 = "0";//法定加班时数
String hours6 = "0";//迟到次数
String hours7 = "0";//早退次数
String hours8 = "0";//旷工次数
//事假时数 
String sql = "select sum(NVL(a.hours,0)) hours from uf_hr_vacation a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and a.objname='"+hid+"' and a.reqtype='40285a904931f62b0149368f73df1e5a'";
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map = (Map)list.get(0);
	hours1 = StringHelper.null2String(map.get("hours"));
	if(hours1.equals("")) hours1 ="0";
}
//病假时数
sql = "select sum(NVL(a.hours,0)) hours from uf_hr_vacation a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and a.objname='"+hid+"' and (a.reqtype='40285a904931f62b0149368f74561e7a' or a.reqtype='40285a904931f62b0149368f743b1e72')";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours2 = StringHelper.null2String(map.get("hours"));
	if(hours2.equals("")) hours2 ="0";
}
//延时加班时数
sql = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+hid+"' and a.objtype='40285a8f489c17ce0149082fab7548cd'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours3 = StringHelper.null2String(map.get("hours"));
	if(hours3.equals("")) hours3 ="0";
}
//双休加班时数
sql = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+hid+"' and a.objtype='40285a8f489c17ce0149082fab7548ce'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours4 = StringHelper.null2String(map.get("hours"));
	if(hours4.equals("")) hours4 ="0";
}
//法定加班时数
sql = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+hid+"' and a.objtype='40285a8f489c17ce0149082fab7548cf'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours5 = StringHelper.null2String(map.get("hours"));
	if(hours5.equals("")) hours5 ="0";
}
//获取SAP编号
sql = "select exttextfield7 from humres where id='"+hid+"'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	sapid = StringHelper.null2String(map.get("exttextfield7"));
}		
//迟到、早退、 旷工等次数从SAP中获取
SapConnector sapConnector = new SapConnector();
String functionName = "ZHR_YEARLY_ATT_GET";//函数名称
JCoFunction function = SapConnector.getRfcFunction(functionName);
function.getImportParameterList().setValue("PERNR",sapid);//SAP编号
function.getImportParameterList().setValue("BEGDA",sday);//开始日期
function.getImportParameterList().setValue("ENDDA",eday);//结束日期
function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
JCoTable retTable = function.getTableParameterList().getTable("ABATT");
if (retTable != null) {
	for (int i = 0; i < retTable.getNumRows(); i++) {
		String ZTART = retTable.getString("ZTART");
		String ANZHL = retTable.getString("ANZHL");
		if(ZTART.equals("8013")){
			hours6 = ANZHL;
		}
		if(ZTART.equals("8023")){
			hours7 = ANZHL;
		}
		if(ZTART.equals("8031")){
			hours8 = ANZHL;
		}
		retTable.nextRow();
	}

}
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

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="12%">
<COL width="12%">
<COL width="12%">
<COL width="12%">
<COL width="12%">
<COL width="12%">
<COL width="12%">
<COL width="12%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>事假时数</TD>
<TD  noWrap class="td2"  align=center>病假时数</TD>
<TD  noWrap class="td2"  align=center>迟到次数</TD>
<TD  noWrap class="td2"  align=center>早退次数</TD>
<TD  noWrap class="td2"  align=center>旷工时数</TD>
<TD  noWrap class="td2"  align=center>延时加班时数</TD>
<TD  noWrap class="td2"  align=center>双休加班时数</TD>
<TD  noWrap class="td2"  align=center>法定加班时数</TD>
</TR>

<TR>
<TD   class="td2"  align=center><%=hours1 %></TD>
<TD   class="td2"  align=center><%=hours2 %></TD>
<TD   class="td2"  align=center><%=hours6 %></TD>
<TD   class="td2"  align=center><%=hours7 %></TD>
<TD   class="td2"  align=center><%=hours8 %></TD>
<TD   class="td2"  align=center><%=hours3 %></TD>
<TD   class="td2"  align=center><%=hours4 %></TD>
<TD   class="td2"  align=center><%=hours5 %></TD>
</tr>
</table>
</div>

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
String EmployName = StringHelper.null2String(request.getParameter("employname"));//员工姓名
String Remaindays = StringHelper.null2String(request.getParameter("remaindays"));//剩余年假天数
String Sdate=StringHelper.null2String(request.getParameter("sdate"));//开始日期(去年的11月)
String Edate=StringHelper.null2String(request.getParameter("edate"));//结束日期(今年的10月)
String newsdate=StringHelper.null2String(request.getParameter("newsdate"));//开始日期(去年的11月1号)
String newedate=StringHelper.null2String(request.getParameter("newedate"));//结束日期(今年的10月31号)
String jobno=StringHelper.null2String(request.getParameter("employno"));//员工工号
String assessyear=StringHelper.null2String(request.getParameter("assessyear"));//当前考核年度

String y1=newsdate.split("-")[0];
String m1=newsdate.split("-")[1];
String d1=newsdate.split("-")[2];
String sd=y1+""+m1+""+d1;//开始日期(用于计算 迟到、早退、 旷工)
String y2=newedate.split("-")[0];
String m2=newedate.split("-")[1];
String d2=newedate.split("-")[2];
String ed=y2+""+m2+""+d2;//结束日期(用于计算 迟到、早退、 旷工)

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


//事假时数 ——事假(不包括回校答辩)
String sql = "select sum(NVL(a.hours,0)) hours from v_uf_hr_newvacation a where a.objname='"+EmployName+"' and a.reqtype='40285a904931f62b0149368f73df1e5a' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map = (Map)list.get(0);
	hours1 = StringHelper.null2String(map.get("hours"));
	if(hours1.equals("")) hours1 ="0";
}
//病假时数——病假,伤病假(住院),医疗期(5年以下),医疗期(5年以上)
sql = "select sum(NVL(a.hours,0)) hours from v_uf_hr_newvacation a where a.objname='"+EmployName+"' and (a.reqtype='40285a904931f62b0149368f74561e7a' or a.reqtype='40285a904931f62b0149368f743b1e72' or a.reqtype='40285a904931f62b0149368f74721e82' or a.reqtype='40285a904931f62b0149368f748c1e8a') and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours2 = StringHelper.null2String(map.get("hours"));
	if(hours2.equals("")) hours2 ="0";
}
//延时加班时数
sql = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+EmployName+"' and a.objtype='40285a8f489c17ce0149082fab7548cd' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours3 = StringHelper.null2String(map.get("hours"));
	if(hours3.equals("")) hours3 ="0";
}
//双休加班时数
sql = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+EmployName+"' and a.objtype='40285a8f489c17ce0149082fab7548ce' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
list.clear();
//System.out.println(sql);
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours4 = StringHelper.null2String(map.get("hours"));
	if(hours4.equals("")) hours4 ="0";
}
//法定加班时数
sql = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+EmployName+"' and a.objtype='40285a8f489c17ce0149082fab7548cf' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	hours5 = StringHelper.null2String(map.get("hours"));
	if(hours5.equals("")) hours5 ="0";
}
//获取SAP编号
sql = "select exttextfield15 from humres where id='"+EmployName+"'";
list.clear();
list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	map.clear();
	map = (Map)list.get(0);
	sapid = StringHelper.null2String(map.get("exttextfield15"));
}		

//计算去年11、12月份员工旷工的时数
String absenthours="0";//旷工时数(去年11、12月份的)
String newsql="select sum(nvl(a.leavehours,0)) as hours from uf_hr_workrecord a,formbase b where a.requestid=b.id and b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and a.employno='"+EmployName+"' and a.leavetype='旷工' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
List newlist=baseJdbc.executeSqlForList(newsql);
if(newlist.size()>0)
{
	Map newmap=(Map)newlist.get(0);
	absenthours=StringHelper.null2String(newmap.get("hours"));
	if(absenthours.equals(""))
	{
		absenthours="0";
	}
}

float  absenttimes;//旷工次数(去年11、12月份的)
//将旷工时数换算成次数(满8小时为一次,不足八小时为半次)
	absenttimes=Float.parseFloat(absenthours);



//迟到、早退、 旷工等次数从SAP中获取
SapConnector sapConnector = new SapConnector();
String functionName = "ZHR_YEARLY_ATT_GET";//函数名称
JCoFunction function = SapConnector.getRfcFunction(functionName);
function.getImportParameterList().setValue("PERNR",sapid);//SAP编号
function.getImportParameterList().setValue("BEGDA",sd);//开始日期
function.getImportParameterList().setValue("ENDDA",ed);//结束日期
function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
String msgty=function.getExportParameterList().getValue("MSGTY").toString();
String msg=function.getExportParameterList().getValue("MESSAGE").toString();
JCoTable retTable = function.getTableParameterList().getTable("ABATT");
if (retTable != null) {
	for (int i = 0; i < retTable.getNumRows(); i++) {
		String ZTART = retTable.getString("ZTART");
		String ANZHL = retTable.getString("ANZHL");
		System.out.println("ZTART:"+ZTART);
		System.out.println("ANZHL:"+ANZHL);
		if(ZTART.equals("8031")){
			hours8 = ANZHL;//旷工时数
		}
		retTable.nextRow();
	}
}

System.out.println("旷工时数："+hours8);
//计算一整年中总的旷工次数
float sumhours = absenttimes+NumberHelper.string2Float(hours8);



//将考勤信息更新至数据库
String attendsql="update uf_hr_checkperformance set thinghours="+hours1+",sickhours="+hours2+",latetimes="+hours6+",learlytimes="+hours7+",absenthours="+sumhours+",tdelayhours="+hours3+",weekhours="+hours4+",legalhours="+hours5+",rannualdays="+Remaindays+" where employno='"+jobno+"' and checkyear='"+assessyear+"'";
baseJdbc.update(attendsql);//执行SQL语句


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

<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="11%">
<COL width="11%">
<COL width="11%" style="display:none">
<COL width="11%" style="display:none">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
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
<TD  noWrap class="td2"  align=center>剩余年假天数</TD>
</TR>

<TR>
<TD   class="td2"  align=center><%=hours1 %></TD>
<TD   class="td2"  align=center><%=hours2 %></TD>
<TD   class="td2"  align=center><%=hours6 %></TD>
<TD   class="td2"  align=center><%=hours7 %></TD>
<TD   class="td2"  align=center><%=sumhours%></TD>

<TD   class="td2"  align=center><%=hours3 %></TD>
<TD   class="td2"  align=center><%=hours4 %></TD>
<TD   class="td2"  align=center><%=hours5 %></TD>
<TD   class="td2"  align=center><%=Remaindays%></TD>
</tr>
</table>
</div>

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
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.app.configsap.SapConnector"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>



<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String str = StringHelper.null2String(request.getParameter("str"));//考核计划的名称(多选)
String Sdate=StringHelper.null2String(request.getParameter("sdate"));//开始日期(去年的11月)
String Edate=StringHelper.null2String(request.getParameter("edate"));//结束日期(今年的10月)
String newsdate=StringHelper.null2String(request.getParameter("newsdate"));//开始日期(去年的11月1号)
String newedate=StringHelper.null2String(request.getParameter("newedate"));//结束日期(今年的10月31号)
String checkyear=StringHelper.null2String(request.getParameter("checkyear"));//当前考核年度

String y1=newsdate.split("-")[0];
String m1=newsdate.split("-")[1];
String d1=newsdate.split("-")[2];
String sd=y1+""+m1+""+d1;//开始日期(用于计算旷工)
String y2=newedate.split("-")[0];
String m2=newedate.split("-")[1];
String d2=newedate.split("-")[2];
String ed=y2+""+m2+""+d2;//结束日期(用于计算旷工)
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
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


<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>计划名称</TD>
<TD  noWrap class="td2"  align=center>员工工号</TD>
<TD  noWrap class="td2"  align=center>员工姓名</TD>
<TD  noWrap class="td2"  align=center>员工部门</TD>
<TD  noWrap class="td2"  align=center>考勤分数</TD>
<TD  noWrap class="td2"  align=center>授课分数</TD>
<TD  noWrap class="td2"  align=center>培训分数</TD>
<TD  noWrap class="td2"  align=center>计划名称</TD>
</tr>

<%
   //System.out.println("----start------");
   //清空历史数据 （考核实施明细表对应于计划名称）uf_hr_checkimplechild
   String status="";//考核状态
   String sql="delete  from  uf_hr_checkimplechild where requestid='"+requestid+"' or instr('"+str+"',planname)>0 or instr(planname,'"+str+"')>0";
   baseJdbc.update(sql);
   String sapid = "";//sap编号
   String hours1 = "0";//事假时数
   String hours2 = "0";//病假时数
   String hours8 = "0";//旷工时数
   String absentscore="3";//初始化矿工后强制给的分数
   String leavescore="3";//初始化请假后强制给的分数
   Map newmap = null;
   List newlist = null;
   String sql1 = "select a.* from uf_hr_checkplansub a  where a.requestid in(select b.requestid from uf_hr_checkplan b where instr('"+str+"',b.requestid)>0 )";
   //查询考核计划子表里的信息
   List sublist1 = baseJdbc.executeSqlForList(sql1);
   if(sublist1.size()>0){
	  for(int k=0,sizek=sublist1.size();k<sizek;k++){
		  absentscore="3";//初始化矿工后强制给的分数
		  leavescore="3";//初始化请假后强制给的分数
		  hours1 = "0";//事假时数
		  hours2 = "0";//病假时数
		  hours8 = "0";//旷工时数
   		  Map mk1 = (Map)sublist1.get(k);
		  String jobno=StringHelper.null2String(mk1.get("jobno"));
		  String objname=StringHelper.null2String(mk1.get("objname"));
		  String objdept=StringHelper.null2String(mk1.get("objdept"));
		  String objscore="";//初始化最小的考勤分数
		  if(objscore.equals("")||objscore.equals("null")||objscore.equals(" "))
		  {
			  objscore="3";
		  }
		  //根据请假流程、系统评核规则计算出考勤分数，不同请假类型取最小的考勤分数
		  //String ssql="select min(b.score) as objscore from uf_hr_scrcheck b where b.leavetype in(select a.reqtype from v_uf_hr_vacationsick a where a.objname='"+objname+"' group by a.reqtype) and b.little <=(select sum(hours) from v_uf_hr_vacationsick a where  a.reqtype=b.leavetype and a.objname ='"+objname+"' ) and b.themax >(select sum(hours) from v_uf_hr_vacationsick a where  a.reqtype=b.leavetype and a.objname ='"+objname+"')";
		  //List sublist2 = baseJdbc.executeSqlForList(ssql);
		  //if(sublist2.size()>0)
		  //{
		      //Map mk2 = (Map)sublist2.get(0);
			  //objscore=StringHelper.null2String(mk2.get("objscore"));
		  //}
		  String fillfactype="";
		  String assessyear="";
		  String ssql="select a.checkyear as assessyear,a.fillfactype from uf_hr_checkplan a where instr((select checkplanname from uf_hr_checkimplemain where requestid='"+requestid+"'),a.requestid)>0";
		  List sublist2 = baseJdbc.executeSqlForList(ssql);
		  if(sublist2.size()>0)
		  {
		      Map mk2 = (Map)sublist2.get(0);
			  assessyear=StringHelper.null2String(mk2.get("assessyear"));//当前考核年度(如:2015年度)
			  fillfactype=StringHelper.null2String(mk2.get("fillfactype"));//厂区别(32位)
		  }


		  //事假时数 ——事假(不包括回校答辩)
		  String newsql = "select sum(NVL(a.hours,0)) hours from v_uf_hr_newvacation a where a.objname='"+objname+"' and a.reqtype='40285a904931f62b0149368f73df1e5a' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
		  newlist = baseJdbc.executeSqlForList(newsql);
		  if(newlist.size()>0){
			newmap = (Map)newlist.get(0);
			hours1 = StringHelper.null2String(newmap.get("hours"));
			if(hours1.equals("")) hours1 ="0";
		  }
		  //病假时数——病假,伤病假(住院),医疗期(5年以下),医疗期(5年以上)
		  newsql = "select sum(NVL(a.hours,0)) hours from v_uf_hr_newvacation a where a.objname='"+objname+"' and (a.reqtype='40285a904931f62b0149368f74561e7a' or a.reqtype='40285a904931f62b0149368f743b1e72' or a.reqtype='40285a904931f62b0149368f74721e82' or a.reqtype='40285a904931f62b0149368f748c1e8a') and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
		  newlist.clear();
		  newlist = baseJdbc.executeSqlForList(newsql);
		  if(newlist.size()>0){
			newmap.clear();
			newmap = (Map)newlist.get(0);
			hours2 = StringHelper.null2String(newmap.get("hours"));
			if(hours2.equals("")) hours2 ="0";
		  }

		  //计算去年11、12月份员工旷工的时数
		  String absenthours="0";//旷工时数(去年11、12月份的)
		  newsql="select sum(nvl(a.leavehours,0)) as hours from uf_hr_workrecord a,formbase b where a.requestid=b.id and b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and a.employno='"+objname+"' and a.leavetype='旷工' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
		  newlist.clear();
		  newlist=baseJdbc.executeSqlForList(newsql);
		  if(newlist.size()>0)
		  {
			newmap.clear();
			newmap=(Map)newlist.get(0);
			absenthours=StringHelper.null2String(newmap.get("hours"));
			if(absenthours.equals(""))
			{
				absenthours="0";
			}
		  }

		  //获取SAP编号
		  newsql = "select exttextfield15 from humres where id='"+objname+"'";
		  newlist.clear();
		  newlist = baseJdbc.executeSqlForList(newsql);
		  if(newlist.size()>0){
			newmap.clear();
			newmap = (Map)newlist.get(0);
			sapid = StringHelper.null2String(newmap.get("exttextfield15"));
		  }		


		  //旷工等次数从SAP中获取(从今年1月份开始)
		  SapConnector sapConnector = new SapConnector();
		  String functionName = "ZHR_YEARLY_ATT_GET";//函数名称
		  JCoFunction function = SapConnector.getRfcFunction(functionName);
		  function.getImportParameterList().setValue("PERNR",sapid);//SAP编号
		  function.getImportParameterList().setValue("BEGDA",sd);//开始日期
		  function.getImportParameterList().setValue("ENDDA",ed);//结束日期
		  function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		  JCoTable retTable = function.getTableParameterList().getTable("ABATT");
		  if (retTable != null) {
			for (int i = 0; i < retTable.getNumRows(); i++) {
				String ZTART = retTable.getString("ZTART");
				String ANZHL = retTable.getString("ANZHL");
				if(ZTART.equals("8031")){
					hours8 = ANZHL;//旷工时数
				}
				retTable.nextRow();
			 }
		  }
		  //计算一整年中总的旷工时数
		  System.out.println(jobno+":去年11、12月份"+absenthours+"今年"+hours8+"病假："+hours2+"事假："+hours1);

		  float sumhours = Float.parseFloat(absenthours)+NumberHelper.string2Float(hours8);
			System.out.println(jobno+":去年11、12月份"+sumhours);
		  //旷工1天以内：2.5分
		  if(sumhours>0&&sumhours<8)
		  {
			  absentscore="2.5";
		  }
		  //旷工1（含）-2天：2分
		  if(sumhours>=8&&sumhours<16)
		  {
			  absentscore="2";
		  }
		  //旷工2（含）-3天：1分
		  if(sumhours>=16&&sumhours<24)
		  {
			  absentscore="1";
		  }
		  //旷工3（含）天以上：0分
		  if(sumhours>=24)
		  {
			  absentscore="0";
		  }


		  //病假（含医疗期）10-15（含）天或事假3-6（含）天：2.5分
		  if((Float.parseFloat(hours2)>80&&Float.parseFloat(hours2)<=120)||(Float.parseFloat(hours1)>24&&Float.parseFloat(hours1)<=48))
		  {
			  leavescore="2.5";//计算员工请假后的分数
		  }
		  //病假（含医疗期）15-30（含）天或事假6-10（含）天：2分
          if((Float.parseFloat(hours2)>120&&Float.parseFloat(hours2)<=240)||(Float.parseFloat(hours1)>48&&Float.parseFloat(hours1)<=80))
		  {
			  leavescore="2";//计算员工请假后的分数
		  }
		  //病假（含医疗期）30-60（含）天或事假10-14（含）天：1分
		  if((Float.parseFloat(hours2)>240&&Float.parseFloat(hours2)<=480)||(Float.parseFloat(hours1)>80&&Float.parseFloat(hours1)<=120))
		  {
			  leavescore="1";//计算员工请假后的分数
		  }
		  //病假（含医疗期）60天以上或事假15天以上：0分
		  if(Float.parseFloat(hours2)>480||Float.parseFloat(hours1)>=120)
		  {
			  leavescore="0";//计算员工请假后的分数
		  }

		  //比较请假、矿工后所得的分数，取其较低分作为考勤分数 
          if(Float.parseFloat(absentscore)<=Float.parseFloat(leavescore))
		  {
			  objscore=absentscore;
		  }
		  else
		  {
			  objscore=leavescore;
		  }

		  newsql="select  v.jobno,sum(usedquo) as SumUsedquo from (select c.jobno,-b.usedquo as usedquo from v_hr_monthreward c left join uf_hr_punrewquocor b on c.rewtype= b.rewtype left join formbase d on d.id=b.requestid where c.jobno=(select id from humres where objno='"+jobno+"') and d.isdelete=0 and b.comtype=(select extrefobjfield5 from humres where objno='"+jobno+"')and c.tomonth>='"+Sdate+"' and c.tomonth<='"+Edate+"') v group by v.jobno";
		  newlist.clear();
		  newlist = baseJdbc.executeSqlForList(newsql);
		  String rewardbalance="0";//奖惩相抵分数
		  if(newlist.size()>0)
		  {
			newmap.clear();
			newmap=(Map)newlist.get(0);
			rewardbalance=StringHelper.null2String(newmap.get("SumUsedquo"));
		  }
		  String rpScore="3";//初始化根据奖惩规则强制后的分数
		  //记小过1次：2.5分
		  if(Float.parseFloat(rewardbalance)>=-5 && Float.parseFloat(rewardbalance)<=-3)
		  {
			rpScore="2.5";
		  }
		  //记小过2次：2分
		  else if(Float.parseFloat(rewardbalance)>=-8 && Float.parseFloat(rewardbalance)<=-6)
		  {
			rpScore="2";
		  }
		  //记大过1次：1分
		  else if(Float.parseFloat(rewardbalance)>=-17 && Float.parseFloat(rewardbalance)<=-9)
		  {
			rpScore="1";
		  }
		  //记大过2次：0分
		  else if(Float.parseFloat(rewardbalance)>=-9999 && Float.parseFloat(rewardbalance)<=-18)
		  {
			rpScore="0";
		  }
			//查询考核状态
			//未考核：未存在有效的绩效考核
			//考核中：存在有效的未结束的绩效考核
			//以考核：存在有效的结束的绩效考核
			String statussql="select a.id,b.isfinished from uf_hr_checkperformance a left join requestbase b on a.requestid=b.id where a.Employname='"+objname+"' and a.Checkplan='"+str+"' and 0=b.isdelete";
			List list = baseJdbc.executeSqlForList(statussql);
			if(list.size()<=0)
		  {
				status="未考核";
		  }
		  else
		  {
			  Map map=(Map)list.get(0);
			  String  isfinished=StringHelper.null2String(newmap.get("isfinished"));
			  if(isfinished.equals("1"))
			  {
				 status="已考核";
			  }
			  else
			  {
				  status="考核中";
			  }
		  }
			  
		  //将查询所得的信息插入考核实施子表中
	      String insql="insert into uf_hr_checkimplechild(id,requestid,ordernum,employnum,employname,belongdepartment,checkscore,teachscore,trainscore,planname,checkstatus,rpscore,factorytype,checkyear) values((select sys_guid() from dual),'"+requestid+"',"+(k+1)+",'"+jobno+"','"+objname+"','"+objdept+"',"+objscore+",0,0,'"+str+"','"+status+"',"+rpScore+",'"+fillfactype+"','"+checkyear+"')"; 
		  baseJdbc.update(insql);
	}
}
 %>
</table>
</div>

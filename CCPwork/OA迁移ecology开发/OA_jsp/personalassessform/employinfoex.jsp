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
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.sap.conn.jco.JCoException" %>


<%
//String requestid = StringHelper.null2String(request.getParameter("requestid"));
System.out.println("--------------------------");
//String requestid = StringHelper.null2String(request.getParameter("requestid"));
String action=StringHelper.null2String(request.getParameter("action"));
String comtype=StringHelper.null2String(request.getParameter("comtype"));//厂区别
//System.out.println(comtype);
String curyear=StringHelper.null2String(request.getParameter("curyear"));//今年年度
String lastyear=StringHelper.null2String(request.getParameter("lastyear"));//去年年度
String sdate=StringHelper.null2String(request.getParameter("sdate"));//开始日期(今年的1月)
String edate=StringHelper.null2String(request.getParameter("edate"));//结束日期(今年的12月)
String newsdate=StringHelper.null2String(request.getParameter("newsdate"));//开始日期(去年的11月1号)
String newedate=StringHelper.null2String(request.getParameter("newedate"));//结束日期(今年的10月31号)
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>

<script type='text/javascript' language="javascript" src='/js/main.js'></script>

<%
String objname="";//姓名
String objno="";//工号
String employsex="";//性别
String exttimefield9="";//出生日期
String extdatefield0="";//入职日期
String education="";//学历
String position="";//职称
String currectdate="";//现职日期
String checktype="";//考核类型
String score="";//前年考分
String score1="";//去年考分
int  age=0;//年龄
float  workyear=0.0f;//年资
String orgid="";//部门
String sql="";
String extrefobjfield5="";
List list;
Map map;
if(action.equals("base"))
{
	String delsql="delete from uf_hr_employinfoex where instr('"+comtype+"',factype)>0 and checkyear='"+curyear+"'";
	baseJdbc.update(delsql);//执行SQL语句

	sql="select a.id as ssmxid,(select max(u.jcdedept)  from uf_hr_pundept u where u.dept =h.orgid and 0=(select isdelete from formbase where id=u.requestid) ) as orgid,h.id,h.objname,h.objno,h.gender as employsex,exttimefield9,extdatefield0,h.extselectitemfield4 as education,h.extrefobjfield4 as position,(select max(currectdate) from uf_hr_curemploydate t where  t.employno=h.id) as currectdate,(select to_char(sysdate,'yyyy-mm-dd') from dual) as today,h.extrefobjfield5,(select x.retype from uf_hr_checkplan x where requestid=b.checkplanname) as checktype from uf_hr_checkimplechild  a left join uf_hr_checkimplemain  b on a.requestid=b.requestid left join humres h   on a.employname=h.id where 0=(select isdelete from formbase where id=a.requestid) and instr('"+comtype+"',h.extrefobjfield5)>0 and a.checkyear='"+curyear+"年度'";

	System.out.println(sql);
	List sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size()>0){
	  for(int i=0;i<sublist.size();i++)
	  {
		objname="";//姓名
		objno="";//工号
		employsex="";//性别
		exttimefield9="";//出生日期
		extdatefield0="";//入职日期
		education="";//学历
		position="";//职称
		currectdate="";//现职日期
		checktype="";//考核类型
		score="";//前年考分
		score1="";//去年考分
		age=0;//年龄
		workyear=0.0f;//年资
		orgid="";//部门
		extrefobjfield5="";
		Map mk = (Map)sublist.get(i);
		String humresid=StringHelper.null2String(mk.get("id"));//id
		String ssmxid=StringHelper.null2String(mk.get("ssmxid"));//id
		objname=StringHelper.null2String(mk.get("objname"));//姓名
		objno=StringHelper.null2String(mk.get("objno"));//工号
		employsex=StringHelper.null2String(mk.get("employsex"));//性别
		exttimefield9=StringHelper.null2String(mk.get("exttimefield9"));//出生日期
		extdatefield0=StringHelper.null2String(mk.get("extdatefield0"));//入职日期
		education=StringHelper.null2String(mk.get("education"));//学历
		position=StringHelper.null2String(mk.get("position"));//职称
		currectdate=StringHelper.null2String(mk.get("currectdate"));//现职日期
		checktype=StringHelper.null2String(mk.get("checktype"));//考核类型
		orgid=StringHelper.null2String(mk.get("orgid"));
		extrefobjfield5=StringHelper.null2String(mk.get("extrefobjfield5"));
		String today=StringHelper.null2String(mk.get("today"));//今天日期
		if(currectdate.equals("")||currectdate.equals("null"))
		{
				currectdate=extdatefield0;
		}

		//年龄
		int cyear=Integer.parseInt(curyear);
		int byear=Integer.parseInt(exttimefield9.split("-")[0]);
		age=cyear-byear+1;
		//年资
		float yeatc=(Float.parseFloat(today.split("-")[0])-Float.parseFloat(extdatefield0.split("-")[0]))*12;//年度差 
		float  monthc=Float.parseFloat(today.split("-")[1])-Float.parseFloat(extdatefield0.split("-")[1]);//月度差
        workyear=(yeatc+monthc)/12;
		String scoresql="select year7,year8 from uf_hr_scoremaintain where objnum='"+humresid+"'";
		list= baseJdbc.executeSqlForList(scoresql);
		if(list.size()>0)
		{
		  map=(Map)list.get(0);
		  score=StringHelper.null2String(map.get("year7"));//前年考分
		  score1=StringHelper.null2String(map.get("year8"));//去年考分
		}
		String insql="insert into uf_hr_employinfoex (id,requestid,employname,employno,sex,birthday,age,entrydate,workyear,education,title,currentdate,depart,frontscore,lastscore,comtype,factype,checkyear,ssmxid,checktype) values((select sys_guid() from dual),(select sys_guid() from dual ),'"+humresid+"','"+objno+"','"+employsex+"','"+exttimefield9+"','"+age+"','"+extdatefield0+"','"+String.format("%.1f",workyear)+"','"+education+"','"+position+"','"+currectdate+"','"+orgid+"','"+score+"','"+score1+"','"+extrefobjfield5+"','"+extrefobjfield5+"','"+curyear+"','"+ssmxid+"','"+checktype+"')";
		System.out.println(insql);
		baseJdbc.update(insql);//执行SQL语句
	    System.out.println(insql);
	  }

  }	
}
//考勤信息
if(action.equals("attend"))
	{
		String sapid = "";//sap编号
		String hours1 = "0";//事假时数
		String hours2 = "0";//病假时数
		String hours3 = "0";//延时加班时数
		String hours4 = "0";//双休加班时数
		String hours5 = "0";//法定加班时数
		String hours6 = "0";//迟到次数
		String hours7 = "0";//早退次数
		String hours8 = "0";//旷工次数
		String Remaindays = "0";//剩余年假天数
		String totaldays="0";//年假定额
		String leavedays="0";//已用年假
		sql="select employname as objname,(select exttextfield15 from humres where id=employname) as sapid from uf_hr_employinfoex where instr('"+comtype+"',factype)>0 and checkyear='"+curyear+"'";
		list= baseJdbc.executeSqlForList(sql);
		if(list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				sapid = "";//sap编号
				hours1 = "0";//事假时数
				hours2 = "0";//病假时数
				hours3 = "0";//延时加班时数
				hours4 = "0";//双休加班时数
				hours5 = "0";//法定加班时数
				hours6 = "0";//迟到次数
				hours7 = "0";//早退次数
				hours8 = "0";//旷工次数
				Remaindays = "0";//剩余年假天数
				totaldays="0";//年假定额
				leavedays="0";//已用年假
				map=(Map)list.get(i);
				sapid=StringHelper.null2String(map.get("sapid"));//员工sap编号
				objname=StringHelper.null2String(map.get("objname"));//员工id
				double total = 0.00;
				String quoid = "10";		
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT2006_GET";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//sday = sday.replace("-", "");
				//插入字段
				function.getImportParameterList().setValue("PERNR",sapid);//sap员工编号
				function.getImportParameterList().setValue("KTART",quoid);//请假定额SAP编码
				function.getImportParameterList().setValue("BEGDA",lastyear+"1101");//请假开始日期(上一年度的11月1号)
				function.getImportParameterList().setValue("ENDDA",curyear+"1031");//请假结束日期(当前年度的10月31号)
				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//System.out.println();
				//返回值
				String ANZHL="0";
				JCoTable retTable = function.getTableParameterList().getTable("IT2006");
				Map<String,String> retMap = new HashMap<String,String>();
				//System.out.println(retTable.getNumRows());
				if (retTable != null) {
					for (int n = 0; n < retTable.getNumRows(); n++) {
						 ANZHL = StringHelper.null2String(retTable.getString("ANZHL"));
						retTable.nextRow();
					}
				}
				if(ANZHL.equals(""))
				{
					ANZHL="0";
				}
				totaldays=ANZHL;//String.format("%.2f",total)
				String  sql1 = "select sum(NVL(a.hours,0)) hours from uf_hr_vacation a,requestbase b where a.requestid=b.id and b.isdelete=0 and NVL(a.isvalided,'0')<>'40288098276fc2120127704884290211' and substr(a.startdate,1,4)='"+curyear+"'  and a.objname='"+objname+"' and a.reqtype='40285a904931f62b0149368f74061e62'";    
				List list1= baseJdbc.executeSqlForList(sql1);
				Map map1;
				if(list1.size()>0)
				{
					map1=(Map)list1.get(0);
					leavedays=StringHelper.null2String(map.get("hours"));//已用时数

				}
				Remaindays=String.format("%.1f",Float.parseFloat(totaldays)/8);
				//事假时数 ——事假(不包括回校答辩)
				sql1 = "select sum(NVL(a.hours,0)) hours from v_uf_hr_newvacation a where a.objname='"+objname+"' and a.reqtype='40285a904931f62b0149368f73df1e5a' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
				list1.clear();
				list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					hours1 = StringHelper.null2String(map1.get("hours"));
					if(hours1.equals("")) hours1 ="0";
				}
				//病假时数——病假,伤病假(住院),医疗期(5年以下),医疗期(5年以上)
				sql1 = "select sum(NVL(a.hours,0)) hours from v_uf_hr_newvacation a where a.objname='"+objname+"' and (a.reqtype='40285a904931f62b0149368f74561e7a' or a.reqtype='40285a904931f62b0149368f743b1e72' or a.reqtype='40285a904931f62b0149368f74721e82' or a.reqtype='40285a904931f62b0149368f748c1e8a') and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
				list1.clear();
				list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					hours2 = StringHelper.null2String(map1.get("hours"));
					if(hours2.equals("")) hours2 ="0";
				}
				//延时加班时数
				sql1 = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+objname+"' and a.objtype='40285a8f489c17ce0149082fab7548cd' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
				list1.clear();
				list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					hours3 = StringHelper.null2String(map1.get("hours"));
					if(hours3.equals("")) hours3 ="0";
				}
				//双休加班时数
				sql1 = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+objname+"' and a.objtype='40285a8f489c17ce0149082fab7548ce' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
				list1.clear();
				//System.out.println(sql);
				list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					hours4 = StringHelper.null2String(map1.get("hours"));
					if(hours4.equals("")) hours4 ="0";
				}
				//法定加班时数
				sql1 = "select sum(NVL(a.acthours,0)) hours from uf_hr_overtime a,requestbase b where a.requestid=b.id and b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and a.objname='"+objname+"' and a.objtype='40285a8f489c17ce0149082fab7548cf' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
				list1.clear();
				list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					hours5 = StringHelper.null2String(map1.get("hours"));
					if(hours5.equals("")) hours5 ="0";
				}		

				//计算去年11、12月份员工旷工的时数
				String absenthours="0";//旷工时数(去年11、12月份的)
				String newsql="select sum(nvl(a.leavehours,0)) as hours from uf_hr_workrecord a,formbase b where a.requestid=b.id and b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and a.employno='"+objname+"' and a.leavetype='旷工' and a.startdate>='"+newsdate+"' and a.enddate<='"+newedate+"'";
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
				String y1=newsdate.split("-")[0];
				String m1=newsdate.split("-")[1];
				String d1=newsdate.split("-")[2];
				String sd=y1+""+m1+""+d1;//开始日期(用于计算 迟到、早退、 旷工)
				String y2=newedate.split("-")[0];
				String m2=newedate.split("-")[1];
				String d2=newedate.split("-")[2];
				String ed=y2+""+m2+""+d2;//结束日期(用于计算 迟到、早退、 旷工)
				float  absenttimes;//旷工次数(去年11、12月份的)
				//将旷工时数换算成次数(满8小时为一次,不足八小时为半次)
					absenttimes=Float.parseFloat(absenthours);



				//迟到、早退、 旷工等次数从SAP中获取
				sapConnector = new SapConnector();
				functionName = "ZHR_YEARLY_ATT_GET";//函数名称
				function = SapConnector.getRfcFunction(functionName);
				function.getImportParameterList().setValue("PERNR",sapid);//SAP编号
				function.getImportParameterList().setValue("BEGDA",sd);//开始日期
				function.getImportParameterList().setValue("ENDDA",ed);//结束日期
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				String msgty=function.getExportParameterList().getValue("MSGTY").toString();
				String msg=function.getExportParameterList().getValue("MESSAGE").toString();
				retTable = function.getTableParameterList().getTable("ABATT");
				if (retTable != null) {
					for (int j = 0; j < retTable.getNumRows(); j++) {
						String ZTART = retTable.getString("ZTART");
						String ANZHL1 = retTable.getString("ANZHL");
						if(ZTART.equals("8031")){
							hours8 = ANZHL1;//旷工时数
						}
						retTable.nextRow();
					}
				}
				System.out.println(objname+":去年11、12月份"+absenthours+";;;"+absenttimes+"今年"+hours8+"病假："+hours2+"事假："+hours1);
				System.out.println("员工："+objname);
				System.out.println("旷工时数1："+absenttimes);
				System.out.println("旷工时数："+hours8);
				//计算一整年中总的旷工次数
				float sumhours = absenttimes+NumberHelper.string2Float(hours8);
				String upsql="update uf_hr_employinfoex set Thinghours="+hours1+",Sickhours="+hours2+",Latetimes="+hours6+",Learlytimes="+hours7+",Absenthours="+sumhours+",Tdelayhours="+hours3+",Weekhours="+hours4+",Legalhours="+hours5+",Rannualdays="+Remaindays+" where  employname='"+objname+"' and checkyear='"+curyear+"'";
				baseJdbc.update(upsql);//执行SQL语句
				System.out.println(upsql);

			}
		}
	}
	if(action.equals("reward"))
	{
		//奖惩信息
		int nums1=0;//大功次数
		int nums2=0;//小功次数
		int nums3=0;//嘉奖次数
		int nums4=0;//大过次数
		int nums5=0;//小过次数
		int nums6=0;//申诫次数
		sql="select employname as objname,(select exttextfield15 from humres where id=employname) as sapid from uf_hr_employinfoex where instr('"+comtype+"',factype)>0 and checkyear='"+curyear+"'";
		list= baseJdbc.executeSqlForList(sql);
		if(list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				nums1=0;//大功次数
				nums2=0;//小功次数
				nums3=0;//嘉奖次数
				nums4=0;//大过次数
				nums5=0;//小过次数
				nums6=0;//申诫次数
				map = (Map)list.get(i);
				objname=StringHelper.null2String(map.get("objname"));//员工姓名

				String sql2="select (select objname from selectitem where id=pubtype) objname,sum(nums) nums from v_hr_ydjc b where  b.jobname='"+objname+"' and tomonth<='"+curyear+"-12' and tomonth>='"+curyear+"-01' group by pubtype ";
				List list2= baseJdbc.executeSqlForList(sql2);
				if(list2.size()>0)
				{
					for(int k=0;k<list2.size();k++)
					{
						Map map2 = (Map)list2.get(k);
						String objname1=StringHelper.null2String(map2.get("objname"));//奖惩类型
						String objnum=StringHelper.null2String(map2.get("nums"));//次数
						if(objname1.indexOf("大功")!=-1)
						{
							if(objnum!=""&&objnum!=" "&&objnum!=null)
							{
								nums1=nums1+Integer.parseInt(objnum);
							}
							else
							{
								nums1=0;
							}
						}
						if(objname1.indexOf("小功")!=-1)
						{
							if(objnum!=""&&objnum!=" "&&objnum!=null)
							{
								nums2=nums2+Integer.parseInt(objnum);
							}
							else
							{
								nums2=0;
							}
						}
						if(objname1.indexOf("嘉奖")!=-1)
						{
							if(objnum!=""&&objnum!=" "&&objnum!=null)
							{
								nums3=nums3+Integer.parseInt(objnum);
							}
							else
							{
								nums3=0;
							}
						}
						if(objname1.indexOf("大过")!=-1)
						{
							if(objnum!=""&&objnum!=" "&&objnum!=null)
							{
								nums4=nums4+Integer.parseInt(objnum);
							}
							else
							{
								nums4=0;
							}
						}
						if(objname1.indexOf("小过")!=-1)
						{
							if(objnum!=""&&objnum!=" "&&objnum!=null)
							{
								nums5=nums5+Integer.parseInt(objnum);
							}
							else
							{
								nums5=0;
							}
						}
						if(objname1.indexOf("申诫")!=-1)
						{
							if(objnum!=""&&objnum!=" "&&objnum!=null)
							{
								nums6=nums6+Integer.parseInt(objnum);
							}
							else
							{
								nums6=0;
							}
						}
					}
				}

				String sql1="select  v.jobno,sum(usedquo) as SumUsedquo from (select c.jobno,-b.usedquo as usedquo from v_hr_monthreward c left join uf_hr_punrewquocor b on c.rewtype= b.rewtype left join formbase d on d.id=b.requestid where c.jobno='"+objname+"' and d.isdelete=0 and b.comtype=(select extrefobjfield5 from humres where id='"+objname+"')and c.tomonth>='"+sdate+"' and c.tomonth<='"+edate+"') v group by v.jobno";

				String RewPunScore="0";//初始化奖惩相抵分数
				List sublist1 = baseJdbc.executeSqlForList(sql1);
				if(sublist1.size()>0)
				{
				   Map mk1 = (Map)sublist1.get(0);
				   RewPunScore=StringHelper.null2String(mk1.get("SumUsedquo"));
				}
				String upsq2="update uf_hr_employinfoex set largepower="+nums1+",smallpower="+nums2+",awardtimes="+nums3+",largefault="+nums4+",smallfault="+nums5+",admontimes="+nums6+",rewardbalance="+RewPunScore+" where  employname='"+objname+"' and checkyear='"+curyear+"'";
				baseJdbc.update(upsq2);//执行SQL语句
				System.out.println(upsq2);
			}
		}
	}
	if(action.equals("syscore"))
	{
		String checkscore="3";//考勤分数
		String SumScore="3";//系统评分
		String rpScore="3";//初始化根据奖惩规则强制后的分数
		sql="select ssmxid,employname as objname,rewardbalance from uf_hr_employinfoex where instr('"+comtype+"',factype)>0 and checkyear='"+curyear+"'";
		list= baseJdbc.executeSqlForList(sql);
		if(list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				checkscore="3";//考勤分数
				SumScore="3";//系统评分
				rpScore="3";//初始化根据奖惩规则强制后的分数
				map = (Map)list.get(i);
				objname=StringHelper.null2String(map.get("objname"));//员工姓名
				String ssmxid1=StringHelper.null2String(map.get("ssmxid"));
				String rewardbalance=StringHelper.null2String(map.get("rewardbalance"));;//奖惩相抵分数
				String sql3="select checkscore from uf_hr_checkimplechild where id='"+ssmxid1+"'";
				List sublist = baseJdbc.executeSqlForList(sql3);
				if(sublist.size()>0)
				{
					Map mk = (Map)sublist.get(0);
					checkscore=StringHelper.null2String(mk.get("checkscore"));
				}
				
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
				//"考勤分"和"奖惩分"综合判断的依据(取其较小值作为系统评分)
				
				if(Float.parseFloat(checkscore)<=Float.parseFloat(rpScore))
				{
					SumScore=checkscore;
				}
				else
				{
					SumScore=rpScore;
				}
				String upsq3="update uf_hr_employinfoex set attendscore="+checkscore+",repunscore="+rpScore+",systemscore="+SumScore+" where  employname='"+objname+"' and checkyear='"+curyear+"'";
				baseJdbc.update(upsq3);//执行SQL语句
				System.out.println(upsq3);
			}
		}
	}
%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
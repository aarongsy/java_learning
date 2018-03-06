<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@ page import="jxl.biff.IntegerHelper"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
		System.out.println("异常人员用餐查询开始！");
		//sdate:sdate,edate:edate,objname:objname,objno:objno,sapno:sapno,area:area,ctype:ctype,btype:btype
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		String sdate=StringHelper.null2String(request.getParameter("sdate"));//开始日期
		String edate=StringHelper.null2String(request.getParameter("edate"));//结束日期
		String objname1=StringHelper.null2String(request.getParameter("objname"));//姓名
		String objno=StringHelper.null2String(request.getParameter("objno"));//工号
		String area=StringHelper.null2String(request.getParameter("area"));//厂区别
		String sapno=StringHelper.null2String(request.getParameter("sapno"));//sap编号
		String ctype=StringHelper.null2String(request.getParameter("ctype"));//餐别
		String btype=StringHelper.null2String(request.getParameter("btype"));//班别

		String delsql="delete from uf_oa_ycmealf";
		baseJdbc.update(delsql);
		DataService otherdataservices = new DataService();
		String where="";
		if(area.equals("4028804d2083a7ed012083ebb988005b") || area.equals("40285a90488ba9d101488bbdeeb30008")){//常熟厂	或长沙厂
		otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfooddata"));	
		where="(a.classname='晚班' or a.classname='早班' or a.classname='大早班' or a.classname='大中班' or a.classname='中班' or a.classname='小中班') and (a.comtype='4028804d2083a7ed012083ebb988005b' or a.comtype='40285a90488ba9d101488bbdeeb30008') and a.thedate>='"+sdate+"' and a.thedate<='"+edate+"'";
		}
	/*	if(area.equals("40285a90488ba9d101488bbd09100007")){ //盘锦厂
		otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("pjfooddata"));
		where="(a.classname='晚班') and a.comtype='40285a90488ba9d101488bbd09100007' and a.thedate>='"+sdate+"' and a.thedate<='"+edate+"'";
		}*/
		if(!objname1.equals(""))
		{
			where=where+" and a.objname='"+objname1+"'";
		}
		if(!objno.equals(""))
		{
			where=where+" and a.jobno='"+objno+"'";
		}
		if(!sapno.equals(""))
		{
			where=where+" and a.sapjobno='"+sapno+"'";
		}
		if(!btype.equals(""))
		{
			where=where+" and a.classno='"+btype+"'";
		}
		String zbtime = "6:30:00";
		String zetime = "9:00:00";
		String wubtime = "11:00:00";
		String wuetime = "13:30:00";
		String wbtime = "16:30:00";
		String wetime = "19:00:00";
		String sql="";
		String fsql="";
		String fsql1="";//午餐sql;
		String fsql2="";
		String csktime="";//早餐刷卡时间
		String wusktime="";//午餐刷卡时间
		String wsktime="";//晚餐刷卡时间
		String zyc="";//早餐异常
		String wuyc="";//午餐异常
		String wyc="";//晚餐异常
		String flag="";
		int no=0;
		sql="select a.objname,a.jobno,a.sapjobno,a.objdept,a.thedate,a.classno,a.classname,b.pstime,b.petime from uf_hr_classplan a left join  uf_hr_classinfo b on a.classno=b.requestid where ";
		sql=sql+where+" order by a.thedate asc";
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				csktime="";//早餐刷卡时间
				wusktime="";//午餐刷卡时间
				wsktime="";//晚餐刷卡时间
				zyc="";//早餐异常
				wuyc="";//午餐异常
				wyc="";//晚餐异常
				flag="";
				map = (Map)list.get(k);
				String objname=StringHelper.null2String(map.get("objname"));//姓名
				String jobno=StringHelper.null2String(map.get("jobno"));//工号
				String sapjobno=StringHelper.null2String(map.get("sapjobno"));//sap编号
				String objdept=StringHelper.null2String(map.get("objdept"));//部门
				String thedate=StringHelper.null2String(map.get("thedate"));//日期
				String classno=StringHelper.null2String(map.get("classno"));//班别编号
				String classname=StringHelper.null2String(map.get("classname"));//班别名称
				String pstime=StringHelper.null2String(map.get("pstime"));//班别开始
				String petime=StringHelper.null2String(map.get("petime"));//班别结束

				if(area.equals("4028804d2083a7ed012083ebb988005b") || area.equals("40285a90488ba9d101488bbdeeb30008")){
					fsql = "select convert(varchar(100),a.[time],8) as time,a.[time] as times1 from acc_monitor_log a,userinfo b where a.pin=b. badgenumber and rtrim(ltrim(b.political))='"+jobno+"' and convert(varchar(100),a.[time],8)>=convert(varchar(100),'"+zbtime+"',8) and convert(varchar(100),a.[time],8)<=convert(varchar(100),'"+zetime+"',8)  and convert(varchar(100),a.[time],23)=convert(varchar(100),'"+thedate+"',23)";	
					fsql1 = "select convert(varchar(100),a.[time],8) as time,a.[time] as times1 from acc_monitor_log a,userinfo b where a.pin=b. badgenumber and rtrim(ltrim(b.political))='"+jobno+"' and convert(varchar(100),a.[time],8)>=convert(varchar(100),'"+wubtime+"',8) and convert(varchar(100),a.[time],8)<=convert(varchar(100),'"+wuetime+"',8)  and convert(varchar(100),a.[time],23)=convert(varchar(100),'"+thedate+"',23)";	
					fsql2 = "select convert(varchar(100),a.[time],8) as time,a.[time] as times1 from acc_monitor_log a,userinfo b where a.pin=b. badgenumber and rtrim(ltrim(b.political))='"+jobno+"' and convert(varchar(100),a.[time],8)>=convert(varchar(100),'"+wbtime+"',8) and convert(varchar(100),a.[time],8)<=convert(varchar(100),'"+wetime+"',8)  and convert(varchar(100),a.[time],23)=convert(varchar(100),'"+thedate+"',23)";	
				}
				//
				if(area.equals("40285a90488ba9d101488bbd09100007")){ //盘锦厂
					fsql = "select a.userid from checkinout a,userinfo b where a.userid=b.userid and rtrim(ltrim(b.ssn))='"+jobno+"' and convert(varchar(100),a.[checktime],8)>=convert(varchar(100),'"+zbtime+"',8) and convert(varchar(100),a.[checktime],8)<=convert(varchar(100),'"+zetime+"',8)  and convert(varchar(100),a.[checktime],23)=convert(varchar(100),'"+thedate+"',23)";	
				}
				//System.out.println(fsql);
				List flist = otherdataservices.getValues(fsql);
				Map map1=null;
				if(flist.size()>0){//早餐有刷卡
					map1 = (Map)flist.get(0);
					csktime=StringHelper.null2String(map1.get("time"));
				}
				//System.out.println(fsql1);
				flist = otherdataservices.getValues(fsql1);
				if(flist.size()>0){//午餐有刷卡
					map1 = (Map)flist.get(0);
					wusktime=StringHelper.null2String(map1.get("time"));
				}
				//System.out.println(fsql2);
				flist = otherdataservices.getValues(fsql2);
				if(flist.size()>0){//晚餐有刷卡
					
					map1 = (Map)flist.get(0);
					wsktime=StringHelper.null2String(map1.get("time"));
				}
				
				if(classname.equals("晚班")&&!csktime.equals(""))//早餐异常
				{
					zyc="异常";
					flag="true";
				}
				if(!wusktime.equals("")&&(classname.equals("早班")||classname.equals("大早班")||classname.equals("大中班")))//午餐异常 早 大早 大中 
				{
					wuyc="异常";
					flag="true";
				}
				if(!wsktime.equals("")&&(classname.equals("大早班")||classname.equals("中班")||classname.equals("小中班")||classname.equals("大中班")))//晚餐异常 大早 中 小中 大中 
				{
					wyc="异常";
					flag="true";
				}
				if(flag.equals("true"))
				{
					no++;
					String insql="insert into uf_oa_ycmealf   (id,requestid,objname,jobno,sapno,dept,ycdate,btype,sttime,endtime,btime,ltime,dtime,bstatus,lstatus,dstatus,btypeno)values((select sys_guid() from dual),'40285a8f513d49db01521b2268333001','"+objname+"','"+objname+"','"+sapjobno+"','"+objdept+"','"+thedate+"','"+classname+"','"+pstime+"','"+petime+"','"+csktime+"','"+wusktime+"','"+wsktime+"','"+zyc+"','"+wuyc+"','"+wyc+"','"+classno+"')";
					//System.out.println(insql);
					baseJdbc.update(insql);
				}
			}
			System.out.println("异常人员用餐查询结束！");
		}
%>

<%@page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@page import="jxl.biff.IntegerHelper"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
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
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>
<%

EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户	
	
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String comtype=StringHelper.null2String(request.getParameter("comtype"));
	comtype = "4028804d2083a7ed012083ebb988005b";

	DataService csfkkqdataservices = new DataService();
	DataService csygkqdataservices = new DataService();
	DataService csygkqdataservices2 = new DataService();
	DataService ds = new DataService();
	String where="";
	String deptnameall="";
	String psnnumsall = "";
	
	String err = "";
	if(comtype.equals("4028804d2083a7ed012083ebb988005b") || comtype.equals("40285a90488ba9d101488bbdeeb30008")){//常熟厂	或长沙厂
		//员工
		csfkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfkkq"));		//psntype=访客
		csygkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csygkq"));		//psntype=员工
/*
		String ygjccstarttime = "02:00:00.000";
		String ygzcstarttime = "19:00:00.000";
		String ygzcendtime = "02:00:00.000";
		String fkjccstarttime = "02:00:00.000";
		String fkzcstarttime = "22:00:00.000";
		String fkzcendtime = "02:00:00.000";	
	*/	
		String ygjccstarttime = "";
		String ygzcstarttime = "";
		String ygzcendtime = "";
		String fkjccstarttime = "";
		String fkzcstarttime = "";
		String fkzcendtime = "";	
		
		String timesetsql = "select a.zcstime ygzcstarttime,a.zcetime ygzcendtime,a.jcstime ygjccstarttime from uf_oa_jcctimeset a  where a.psntype='员工' ";
		List timesetlist = null;
		timesetlist = baseJdbc.executeSqlForList(timesetsql);
		if ( timesetlist.size()>0 ) {
			Map timesetmap = (Map)timesetlist.get(0);
			ygjccstarttime =  StringHelper.null2String(timesetmap.get("ygjccstarttime"));
			ygzcstarttime =  StringHelper.null2String(timesetmap.get("ygzcstarttime"));
			ygzcendtime =  StringHelper.null2String(timesetmap.get("ygzcendtime"));
		}
		timesetsql = "select a.zcstime fkzcstarttime,a.zcetime fkzcendtime,a.jcstime fkjccstarttime from uf_oa_jcctimeset a  where a.psntype='访客劳务工外包商' ";
		timesetlist = null;
		timesetlist = baseJdbc.executeSqlForList(timesetsql);
		if ( timesetlist.size()>0 ) {
			Map timesetmap = (Map)timesetlist.get(0);
			fkjccstarttime =  StringHelper.null2String(timesetmap.get("fkjccstarttime"));
			fkzcstarttime =  StringHelper.null2String(timesetmap.get("fkzcstarttime"));
			fkzcendtime =  StringHelper.null2String(timesetmap.get("fkzcendtime"));
		}		
		
		String strcurtime = ds.getValue("select to_char(sysdate,'yyyy-MM-dd HH24:mi:ss') from dual"); 		
		String curdate =  strcurtime.split(" ")[0]; 
		String strcurtime2 = strcurtime.split(" ")[1];
		String curtime = strcurtime.split(" ")[1] +".000";
		String yestoday = ds.getValue("select to_char(sysdate - interval '1' day,'yyyy-MM-dd') from dual"); 
		
		String ygzcsql = "select e1.DEPTNAME AS 部门名称,e1.DEPTNAME as deptname,  convert(varchar(10),count( case when e2.psnnum= '1' then 1 else null end)) oldstaynum from DEPARTMENTS as e1 left join ( select d1.ssn AS jobno,  d1.name as jobname,  d3.DEPTNAME AS deptname, d3.DEPTID  as deptid, convert(varchar(10),count(case when d2.inflag = '1' and d2.cf is null then 1 else null end) - count(case when d2.inflag = '0' and d2.cf is null then 1 else null end) ) psnnum from userinfo as d1 left join DEPARTMENTS AS d3 ON d3.DEPTID = d1.DEFAULTDEPTID left join ( select b2.ssn as jobno,        b1.userid as psnid,       b2.name as jobname,       b3.DEPTNAME AS deptname,       b3.DEPTID  as deptid,       b1.CHECKtime as sktime,       b4.MachineAlias as machine,       b4.MachineNumber as machineno,       b4.CheckIn as inflag,       (select max(a1.CHECKtime) from checkinout as a1  left join userinfo as a2 on a2.userid = a1.userid left join DEPARTMENTS AS a3 ON a3.DEPTID = a2.DEFAULTDEPTID left join Machines as a4 on a4.machinenumber = a1.sensorid where a1.userid = b1.userid and a1.CHECKtime < b1.CHECKtime and a1.CHECKtime  >= ('"+yestoday +" "+ ygzcstarttime+"') and a1.CHECKtime <= ('"+curdate+" "+ygzcendtime+"') and a2.DEFAULTDEPTID = b2.DEFAULTDEPTID ) as cf from checkinout as b1  left join userinfo as b2 on b2.userid = b1.userid  left join DEPARTMENTS AS b3 ON b3.DEPTID = b2.DEFAULTDEPTID  left join Machines as b4 on b4.machinenumber = b1.sensorid  where b1.CHECKtime >= ('"+yestoday +" "+ ygzcstarttime+"') and b1.CHECKtime <=('"+curdate+" "+ygzcendtime+"') ) as d2 on d2.psnid= d1.userid  group by d1.ssn,d1.name,d3.DEPTNAME,d3.DEPTID) as e2 on e2.deptid = e1.DEPTID group by e1.DEPTNAME ";
		List oldlist = null;
		oldlist = csygkqdataservices.getValues(ygzcsql);
		//System.out.println("oldlist.size()："+oldlist.size());
		
		Map<String,String> ygmap = new HashMap<String,String>();
		if ( oldlist.size()>0 ) {
			for ( int i=0; i<oldlist.size(); i++ ){			
				Map<String,String> oldm=new HashMap<String,String>();
				oldm = (Map)oldlist.get(i);
				String dept = StringHelper.null2String(oldm.get("deptname"));	
				String oldstaynum = StringHelper.null2String(oldm.get("oldstaynum"));	
				//System.out.println("dept:"+dept +"   oldstaynum:"+oldstaynum );
				if( "".equals(oldstaynum) ) {
					oldstaynum = "0";
				}
				ygmap.put(dept,oldstaynum);				
			}
		}
		//System.out.println("ygmap集合的大小为："+ygmap.size());
		

		String fsql = "";
		fsql = "select d1.DEPTNAME AS 部门名称,d1.deptname as deptname,  convert(varchar(10),count(case when d2.inflag = '1' and d2.cf is null then 1 else null end)) as inpsns,convert(varchar(10),count(case when d2.inflag = '0' and d2.cf is null then 1 else null end))  as outpsns, convert(varchar(10),count(case when d2.inflag = '1' and d2.cf is null then 1 else null end) - count(case when d2.inflag = '0' and d2.cf is null then 1 else null end) ) as staypsns from DEPARTMENTS as d1      left join (select b2.ssn as jobno,	b2.name as jobname,  b3.DEPTNAME AS deptname, b3.DEPTID  as deptid, b1.CHECKtime as sktime, b4.MachineAlias as skmachine,       b4.MachineNumber as machineno,  b4.CheckIn as inflag,  (select max(a1.CHECKtime) from checkinout as a1  left join userinfo as a2 on a2.userid = a1.userid left join DEPARTMENTS AS a3 ON a3.DEPTID = a2.DEFAULTDEPTID left join Machines as a4 on a4.machinenumber = a1.sensorid where a1.userid = b1.userid and a1.CHECKtime < b1.CHECKtime and a1.CHECKtime  >= ('"+curdate+" "+ ygjccstarttime+"') and a1.CHECKtime <= '"+curtime+"' and a2.DEFAULTDEPTID = b2.DEFAULTDEPTID ) as cf   from checkinout as b1 left join userinfo as b2 on b2.userid = b1.userid   left join DEPARTMENTS AS b3 ON b3.DEPTID = b2.DEFAULTDEPTID   left join Machines as b4 on b4.machinenumber = b1.sensorid   where b1.CHECKtime >= ('"+curdate+" "+ ygjccstarttime+"')  and b1.CHECKtime <='"+curdate+" "+curtime+"' )   as d2 on d2.deptid = d1.DEPTID group by d1.DEPTNAME ";
		System.out.println(fsql);
		List flist = null;
		flist = csygkqdataservices.getValues(fsql);
		System.out.println("flist.size()="+flist.size());
		if(flist.size()>0){
			String jccmainreqid = "";
			int existflag = Integer.parseInt(ds.getValue("select count(*) n from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='员工' and a.comtype='4028804d2083a7ed012083ebb988005b'"));
			if ( existflag==0 ) {
				//String orgid = ds.getValue("select orgid from humres where ID ='"+lastname+"'");
				System.out.println(" start create uf_oa_jccmain");
				StringBuffer buffer = new StringBuffer(1024);
				//String newrequestid = IDGernerator.getUnquieID();
				buffer.append("insert into uf_oa_jccmain").append("(id,requestid,sdate,stime,edate,etime,psntype,oldstay,innum,outnum,staynum,comtype) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

				buffer.append("'").append(curdate).append("',");//开始日期
				buffer.append("'").append(ygjccstarttime).append("',");//开始时间
				buffer.append("'").append(curdate).append("',");//结束日期
				buffer.append("'").append(strcurtime2).append("',");//结束时间
				buffer.append("'员工',");//人员类型
				buffer.append("'',");//原在厂人数
				buffer.append("'',");//进厂人数
				buffer.append("'',");//出厂人数
				buffer.append("'',");//在厂人数
				buffer.append("'4028804d2083a7ed012083ebb988005b')");//厂区别

				FormBase formBase = new FormBase();
				String categoryid = "40285a8d53c4e8b20153c61b4bec118f";
				//创建formbase
				formBase.setCreatedate(DateHelper.getCurrentDate());
				formBase.setCreatetime(DateHelper.getCurrentTime());
				formBase.setCreator(StringHelper.null2String(userid));
				formBase.setCategoryid(categoryid);
				formBase.setIsdelete(0);
				FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
				formBaseService.createFormBase(formBase);
				String insertSql = buffer.toString();
				jccmainreqid = formBase.getId();
				insertSql = insertSql.replace("$ewrequestid$",jccmainreqid);
				baseJdbc.update(insertSql);
				PermissionTool permissionTool = new PermissionTool();
				permissionTool.addPermission(categoryid,formBase.getId(), "uf_oa_jccmain");				
				System.out.println(" end create uf_oa_jccmain");
			} else {
				System.out.println(" start update uf_oa_jccmain");
				jccmainreqid = ds.getValue("select a.requestid from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='员工' and a.comtype='4028804d2083a7ed012083ebb988005b' and rownum=1");
				String updateSql = "update uf_oa_jccmain set sdate='"+curdate+"',stime='"+ygjccstarttime+"',edate='"+curdate+"',etime='"+strcurtime2+"' where requestid='"+jccmainreqid+"'";
				baseJdbc.update(updateSql);
				System.out.println(" updateSql:"+updateSql);
				String delSql = "delete uf_oa_jccsub where requestid='"+jccmainreqid+"'";
				baseJdbc.update(delSql);
				System.out.println(" delSql:"+delSql);
				System.out.println(" end update uf_oa_jccmain");
			}	
		
			System.out.println(" start create uf_oa_jccsub");
			int oldstayall = 0;
			int innumall = 0;
			int outnumall = 0;
			int staynumall = 0;
			for ( int i=0; i<flist.size(); i++){
				Map<String,String> m=new HashMap<String,String>();
				m = (Map)flist.get(i);
				
				String deptname = StringHelper.null2String(m.get("deptname"));	
				if ( !"长沙厂".equals(deptname) ) {	
					deptnameall =""+ deptnameall + ","+deptname;
					//System.out.println("deptname="+deptname);	
					String inpsns = StringHelper.null2String(m.get("inpsns"));	
					//System.out.println("inpsns="+inpsns);	
					String outpsns = StringHelper.null2String(m.get("outpsns"));
								
					int intmp = Integer.parseInt(inpsns);
					innumall = innumall + intmp;
					int outtmp = Integer.parseInt(outpsns);
					outnumall = outnumall + outtmp;

					String oldstay = StringHelper.null2String(ygmap.get(deptname));	
					int oldstaytmp= Integer.parseInt(oldstay);
					oldstayall = oldstayall +oldstaytmp;
					
					String staypsns = StringHelper.null2String(m.get("staypsns"));	
					int staytmp = Integer.parseInt(staypsns)+oldstaytmp;
					staynumall = staynumall + staytmp;
					
					psnnumsall = ""+psnnumsall+","+staypsns;
					//System.out.println("staypsns="+staypsns);
					
					StringBuffer buffer2 = new StringBuffer(1024);
					buffer2.append("insert into uf_oa_jccsub").append("(id,requestid,rowindex,deptname,oldstay,inpsns,outpsns,staypsns) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append(jccmainreqid).append("',").append("'").append(StringHelper.specifiedLengthForInt(i, 3)).append("',");
					buffer2.append("'").append(deptname).append("',");//部门名称
					buffer2.append("'").append(oldstay).append("',");//原在厂人数
					buffer2.append("'").append(inpsns).append("',");//进厂人数
					buffer2.append("'").append(outpsns).append("',");//出厂人数
					buffer2.append("'").append(staytmp).append("')");//在厂人数
					String insdetailSql = buffer2.toString();
					baseJdbc.update(insdetailSql);				
					System.out.println("insdetailSql:"+insdetailSql);
				}
			}
			//staynumall = staynumall + oldstayall;
			String updatemainSql = "update uf_oa_jccmain set oldstay='"+oldstayall+"',innum='"+innumall+"',outnum='"+outnumall+"',staynum='"+staynumall+"' where requestid='"+jccmainreqid+"'";
			baseJdbc.update(updatemainSql);
			System.out.println(" updatemainSql:"+updatemainSql);
			System.out.println(" end create uf_oa_jccsub");
		}else{
			err="1";
		}
		
		String fkzcsql ="select convert(varchar(10),count(case when e1.code = '500' and e2.renyuan> '0' then 1 else null end)) fknum,  convert(varchar(10),count(case when e1.code in ( '201','202','203','204') and e2.renyuan > '0' then 1 else null end)) lwgnum,  convert(varchar(10),count(case when e1.code between '205' and '499' and e2.renyuan > '0' then 1 else null end))  wbsnum   from DEPARTMENTS as e1  left join (select d1.badgenumber AS jobno,  d1.name as jobname,  d3.DEPTNAME AS deptname,  d3.DEPTID  as deptid,  convert(varchar(10),count( case when d2.mjid in ('1','5','7','9','10','11','13','14','18','17') and d2.cf is null then 1 else null end) - count( case when d2.mjid in ('2','3','4','6','8','12','15','16','19') and d2.cf is null then 1 else null end)) renyuan  from userinfo as d1 left join DEPARTMENTS AS d3 ON d3.DEPTID = d1.DEFAULTDEPTID left join ( select acc_monitor_log.id,acc_monitor_log.card_no as cardno,        userinfo.name as jobname,       userinfo.badgenumber as jobno,       userinfo.userid as psnid,       DEPARTMENTS.code as deptcode,       DEPARTMENTS.deptname as deptname,       acc_monitor_log.time as sktime,       acc_monitor_log.device_id as deviceid ,       acc_monitor_log.device_name as devicename ,       acc_monitor_log.event_type as isnormal,       acc_monitor_log.event_point_id as mjid2,       acc_monitor_log.device_id as mjid1,       acc_door.id as mjid,       acc_monitor_log.event_point_name as mjname,(select max(b.id) from acc_monitor_log as b  left join userinfo as d on d.badgenumber = b.pin left join DEPARTMENTS as c on c.deptid = d.DEFAULTDEPTID where b.id < acc_monitor_log.id  and b.event_point_id = acc_monitor_log.event_point_id  and b.device_id = acc_monitor_log.device_id and b.time >= ('"+yestoday+" "+ fkzcstarttime+"') and b.time <= ('"+curdate+" "+fkzcendtime+"') and d.name = userinfo.name and b.card_no = acc_monitor_log.card_no and (b.id = acc_monitor_log.id-1 or b.id = acc_monitor_log.id-2 or b.id = acc_monitor_log.id-3 or b.id = acc_monitor_log.id-4 or b.id = acc_monitor_log.id-5) and b.event_type in ( '0','14') group by b.event_point_id) as cf  from acc_monitor_log as acc_monitor_log  left join userinfo on  userinfo.badgenumber = acc_monitor_log.pin left join DEPARTMENTS on DEPARTMENTS.deptid = userinfo.DEFAULTDEPTID  left join acc_door on acc_door.door_no = acc_monitor_log.event_point_id and acc_door.device_id = acc_monitor_log.device_id left join machines on machines.id = acc_monitor_log.device_id where acc_monitor_log.time >= ('"+yestoday+" "+ fkzcstarttime+"') and acc_monitor_log.time <=('"+curdate+" "+fkzcendtime+"') and acc_monitor_log.event_type in ( '0','14') ) as d2 on  d2.psnid= d1.userid  group by d1.badgenumber,d1.name,d3.DEPTNAME,d3.DEPTID ) as e2 on e2.deptid = e1.DEPTID";
		oldlist = null;
		oldlist = csfkkqdataservices.getValues(fkzcsql);
		System.out.println("oldlist.size()："+oldlist.size());
		
		String fkzcnum;
		String lwgzcnum;
		String wbszcnum;		
		if ( oldlist.size()>0 ) {			
			Map<String,String> fkoldm=new HashMap<String,String>();
			fkoldm = (Map)oldlist.get(0);		
			fkzcnum= StringHelper.null2String(fkoldm.get("fknum"));	
			lwgzcnum = StringHelper.null2String(fkoldm.get("lwgnum"));	
			wbszcnum = StringHelper.null2String(fkoldm.get("wbsnum"));				
		} else {
			fkzcnum = "0";
			lwgzcnum = "0";
			wbszcnum = "0";
		}		
		
		//访客和外包商
		int fknumsall = 0;	
		int lwgnumsall = 0;		
		int wbsnumsall = 0;			
		fsql = "";
		fsql = "select convert(varchar(10),count(case when c2.code = '500' and cc.mjid in ('1','5','7','9','10','11','13','14','18','17')  and cc.cf is null then 1 else null end) - count(case when c2.code = '500' and cc.mjid in ('2','3','4','6','8','12','15','16','19') and cc.cf is null then 1 else null end)) as fkstaynum,        convert(varchar(10),count(case when c2.code = '500' and cc.mjid in ('1','5','7','9','10','11','13','14','18','17')  and cc.cf is null then 1 else null end)) as fkinnum ,    convert(varchar(10),count(case when c2.code = '500' and cc.mjid in ('2','3','4','6','8','12','15','16','19') and cc.cf is null then 1 else null end)) as fkoutnum,    convert(varchar(10),count(case when c2.code in ( '201','202','203','204') and cc.mjid in ('1','5','7','9','10','11','13','14','18','17') and cc.cf is null then 1 else null end) - count(case when c2.code in ( '201','202','203','204') and cc.mjid in ('2','3','4','6','8','12','15','16','19') and cc.cf is null then 1 else null end)) as lwgstaynum,   convert(varchar(10),count(case when c2.code in ( '201','202','203','204') and cc.mjid in ('1','5','7','9','10','11','13','14','18','17') and cc.cf is null then 1 else null end)) as lwginnum , convert(varchar(10),count(case when c2.code in ( '201','202','203','204') and cc.mjid in ('2','3','4','6','8','12','15','16','19') and cc.cf is null then 1 else null end)) as lwgoutnum,  convert(varchar(10),count(case when c2.code between '205' and '499' and cc.mjid in ('1','5','7','9','10','11','13','14','18','17') and cc.cf is null then 1 else null end) - count(case when c2.code > '204' and c2.code <> '500' and cc.mjid in ('2','3','4','6','8','12','15','16','19') and cc.cf is null then 1 else null end)) as wbsstaynum    from acc_monitor_log as acc   left join ( select acc_monitor_log.id,acc_monitor_log.card_no as cardno,        userinfo.name as jobname,       userinfo.badgenumber as jobno,       DEPARTMENTS.code as deptno,       DEPARTMENTS.deptname as deptname,       acc_monitor_log.time as sktime,       acc_monitor_log.device_id as deviceid ,       acc_monitor_log.device_name as devicename ,       acc_monitor_log.event_type as chkskflag,       acc_monitor_log.event_point_id as mjid2,       acc_monitor_log.device_id as mjid1,       acc_door.id as mjid,       acc_monitor_log.event_point_name as mjname,(select max(b.id) from acc_monitor_log as b  left join userinfo as d on d.badgenumber = b.pin left join DEPARTMENTS as c on c.deptid = d.DEFAULTDEPTID where b.id < acc_monitor_log.id  and b.event_point_id = acc_monitor_log.event_point_id  and b.device_id = acc_monitor_log.device_id and b.time >= ('"+curdate+ " "+ fkjccstarttime+"') and b.time <= ('"+curdate+" "+ curtime+"') and d.name = userinfo.name and b.card_no = acc_monitor_log.card_no and (b.id = acc_monitor_log.id-1 or b.id = acc_monitor_log.id-2 or b.id = acc_monitor_log.id-3 or b.id = acc_monitor_log.id-4 or b.id = acc_monitor_log.id-5) and b.event_type in ( '0','14') group by b.event_point_id) as cf from acc_monitor_log as acc_monitor_log left join userinfo on userinfo.badgenumber = acc_monitor_log.pin left join DEPARTMENTS on DEPARTMENTS.deptid = userinfo.DEFAULTDEPTID left join acc_door on acc_door.door_no = acc_monitor_log.event_point_id and acc_door.device_id = acc_monitor_log.device_id left join machines on machines.id = acc_monitor_log.device_id where acc_monitor_log.time >= ('"+curdate+ " "+ fkjccstarttime+"') and acc_monitor_log.time <= ('"+curdate+" "+ curtime+"') and acc_monitor_log.event_type in ( '0','14') ) as cc on cc.id = acc.id  left join userinfo as c1 on c1.badgenumber = acc.pin  left join DEPARTMENTS as c2 on c2.deptid = c1.DEFAULTDEPTID  left join acc_door as c3 on c3.door_no = acc.event_point_id and c3.device_id = acc.device_id  left join machines as c4 on c4.id = acc.device_id where  acc.time >= ('"+curdate+ " "+ fkjccstarttime+"') and acc.time <=('"+curdate+" "+ curtime+"') and acc.event_type in ( '0','14')";
		flist = null;
		flist = csfkkqdataservices.getValues(fsql);
		System.out.println("flist.size()="+flist.size());
		if(flist.size()>0){
			Map<String,String> m2=new HashMap<String,String>();
			m2 = (Map)flist.get(0);				
			String fkstaynum = StringHelper.null2String(m2.get("fkstaynum"));	
			String fkinnum = StringHelper.null2String(m2.get("fkinnum"));	
			String fkoutnum = StringHelper.null2String(m2.get("fkoutnum"));	
			
			String lwgstaynum = StringHelper.null2String(m2.get("lwgstaynum"));	
			String lwginnum = StringHelper.null2String(m2.get("lwginnum"));	
			String lwgoutnum = StringHelper.null2String(m2.get("lwgoutnum"));	
			
			String wbsstaynum = StringHelper.null2String(m2.get("wbsstaynum"));	
			
			fknumsall = Integer.parseInt(fkstaynum) + Integer.parseInt(fkzcnum);	
			lwgnumsall = Integer.parseInt(lwgstaynum) + Integer.parseInt(lwgzcnum);		
			wbsnumsall = Integer.parseInt(wbsstaynum) + Integer.parseInt(wbszcnum);				
		
			String jccreqid = "";
			int existflag2 = Integer.parseInt(ds.getValue("select count(*) n from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='访客' and a.comtype='4028804d2083a7ed012083ebb988005b'"));
			if ( existflag2==0 ) {				
				System.out.println(" start create uf_oa_jccmain fk");
				StringBuffer buffer3 = new StringBuffer(1024);				
				buffer3.append("insert into uf_oa_jccmain").append("(id,requestid,sdate,stime,edate,etime,psntype,oldstay,innum,outnum,staynum,comtype) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

				buffer3.append("'").append(curdate).append("',");//开始日期
				buffer3.append("'").append(fkjccstarttime).append("',");//开始时间
				buffer3.append("'").append(curdate).append("',");//结束日期
				buffer3.append("'").append(strcurtime2).append("',");//结束时间
				buffer3.append("'访客',");//人员类型
				buffer3.append("'").append(fkzcnum).append("',");//原在厂人数
				buffer3.append("'").append(fkinnum).append("',");//进厂人数
				buffer3.append("'").append(fkoutnum).append("',");//出厂人数
				buffer3.append("'").append(fknumsall).append("',");//在厂人数
				buffer3.append("'4028804d2083a7ed012083ebb988005b')");//厂区别				

				FormBase formBase2 = new FormBase();
				String categoryid = "40285a8d53c4e8b20153c61b4bec118f";
				//创建formbase
				formBase2.setCreatedate(DateHelper.getCurrentDate());
				formBase2.setCreatetime(DateHelper.getCurrentTime());
				formBase2.setCreator(StringHelper.null2String(userid));
				formBase2.setCategoryid(categoryid);
				formBase2.setIsdelete(0);
				FormBaseService formBaseService2 = (FormBaseService)BaseContext.getBean("formbaseService");
				formBaseService2.createFormBase(formBase2);
				String insertSql2 = buffer3.toString();
				jccreqid = formBase2.getId();
				insertSql2 = insertSql2.replace("$ewrequestid$",jccreqid);
				baseJdbc.update(insertSql2);
				PermissionTool permissionTool2 = new PermissionTool();
				permissionTool2.addPermission(categoryid,formBase2.getId(), "uf_oa_jccmain");				
				System.out.println(" end create uf_oa_jccmain fk");
			} else {
				System.out.println(" start update uf_oa_jccmain fk");
				jccreqid = ds.getValue("select a.requestid from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='访客' and a.comtype='4028804d2083a7ed012083ebb988005b' and rownum=1");
				String updateSql2 = "update uf_oa_jccmain set sdate='"+curdate+"',stime='"+fkjccstarttime+"',edate='"+curdate+"',etime='"+strcurtime2+"',oldstay='"+fkzcnum+"',innum='"+fkinnum+"',outnum='"+fkoutnum+"',staynum='"+fknumsall+"' where requestid='"+jccreqid+"'";
				baseJdbc.update(updateSql2);
				System.out.println(" updateSql2:"+updateSql2);
				String delSql2 = "delete uf_oa_jccsub where requestid='"+jccreqid+"'";
				baseJdbc.update(delSql2);
				System.out.println(" delSql2:"+delSql2);
				System.out.println(" end update uf_oa_jccmain fk");
			}	

			jccreqid = "";
			int existflag3 = Integer.parseInt(ds.getValue("select count(*) n from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='劳务工' and a.comtype='4028804d2083a7ed012083ebb988005b'"));
			if ( existflag3==0 ) {				
				System.out.println(" start create uf_oa_jccmain lwg");
				StringBuffer buffer4 = new StringBuffer(1024);				
				buffer4.append("insert into uf_oa_jccmain").append("(id,requestid,sdate,stime,edate,etime,psntype,oldstay,innum,outnum,staynum,comtype) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

				buffer4.append("'").append(curdate).append("',");//开始日期
				buffer4.append("'").append(fkjccstarttime).append("',");//开始时间
				buffer4.append("'").append(curdate).append("',");//结束日期
				buffer4.append("'").append(strcurtime2).append("',");//结束时间
				buffer4.append("'劳务工',");//人员类型
				buffer4.append("'").append(lwgzcnum).append("',");//原在厂人数
				buffer4.append("'").append(lwginnum).append("',");//进厂人数
				buffer4.append("'").append(lwgoutnum).append("',");//出厂人数
				buffer4.append("'").append(lwgnumsall).append("',");//在厂人数
				buffer4.append("'4028804d2083a7ed012083ebb988005b')");//厂区别				

				FormBase formBase3 = new FormBase();
				String categoryid = "40285a8d53c4e8b20153c61b4bec118f";
				//创建formbase
				formBase3.setCreatedate(DateHelper.getCurrentDate());
				formBase3.setCreatetime(DateHelper.getCurrentTime());
				formBase3.setCreator(StringHelper.null2String(userid));
				formBase3.setCategoryid(categoryid);
				formBase3.setIsdelete(0);
				FormBaseService formBaseService3 = (FormBaseService)BaseContext.getBean("formbaseService");
				formBaseService3.createFormBase(formBase3);
				String insertSql3 = buffer4.toString();
				jccreqid = formBase3.getId();
				insertSql3 = insertSql3.replace("$ewrequestid$",jccreqid);
				baseJdbc.update(insertSql3);
				PermissionTool permissionTool3 = new PermissionTool();
				permissionTool3.addPermission(categoryid,formBase3.getId(), "uf_oa_jccmain");				
				System.out.println(" end create uf_oa_jccmain lwg");
			} else {
				System.out.println(" start update uf_oa_jccmain lwg");
				jccreqid = ds.getValue("select a.requestid from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='劳务工' and a.comtype='4028804d2083a7ed012083ebb988005b' and rownum=1");
				String updateSql3 = "update uf_oa_jccmain set sdate='"+curdate+"',stime='"+fkjccstarttime+"',edate='"+curdate+"',etime='"+strcurtime2+"',oldstay='"+lwgzcnum+"',innum='"+lwginnum+"',outnum='"+lwgoutnum+"',staynum='"+lwgnumsall+"' where requestid='"+jccreqid+"'";
				baseJdbc.update(updateSql3);
				System.out.println(" updateSql3:"+updateSql3);
				String delSql3 = "delete uf_oa_jccsub where requestid='"+jccreqid+"'";
				baseJdbc.update(delSql3);
				System.out.println(" delSql3:"+delSql3);
				System.out.println(" end update uf_oa_jccmain lwg");
			}	
			

			jccreqid = "";
			int existflag4 = Integer.parseInt(ds.getValue("select count(*) n from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='外包商' and a.comtype='4028804d2083a7ed012083ebb988005b'"));
			if ( existflag4==0 ) {				
				System.out.println(" start create uf_oa_jccmain wbs");
				StringBuffer buffer5 = new StringBuffer(1024);				
				buffer5.append("insert into uf_oa_jccmain").append("(id,requestid,sdate,stime,edate,etime,psntype,oldstay,innum,outnum,staynum,comtype) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

				buffer5.append("'").append(curdate).append("',");//开始日期
				buffer5.append("'").append(fkjccstarttime).append("',");//开始时间
				buffer5.append("'").append(curdate).append("',");//结束日期
				buffer5.append("'").append(strcurtime2).append("',");//结束时间
				buffer5.append("'外包商',");//人员类型
				buffer5.append("'").append(wbszcnum).append("',");//原在厂人数
				buffer5.append("'',");//进厂人数
				buffer5.append("'',");//出厂人数
				buffer5.append("'").append(wbsnumsall).append("',");//在厂人数
				buffer5.append("'4028804d2083a7ed012083ebb988005b')");//厂区别				

				FormBase formBase4 = new FormBase();
				String categoryid = "40285a8d53c4e8b20153c61b4bec118f";
				//创建formbase
				formBase4.setCreatedate(DateHelper.getCurrentDate());
				formBase4.setCreatetime(DateHelper.getCurrentTime());
				formBase4.setCreator(StringHelper.null2String(userid));
				formBase4.setCategoryid(categoryid);
				formBase4.setIsdelete(0);
				FormBaseService formBaseService4 = (FormBaseService)BaseContext.getBean("formbaseService");
				formBaseService4.createFormBase(formBase4);
				String insertSql4 = buffer5.toString();
				jccreqid = formBase4.getId();
				insertSql4 = insertSql4.replace("$ewrequestid$",jccreqid);
				baseJdbc.update(insertSql4);
				PermissionTool permissionTool4 = new PermissionTool();
				permissionTool4.addPermission(categoryid,formBase4.getId(), "uf_oa_jccmain");				
				System.out.println(" end create uf_oa_jccmain wbs");
			} else {
				System.out.println(" start update uf_oa_jccmain wbs");
				jccreqid = ds.getValue("select a.requestid from uf_oa_jccmain a,formbase b where a.requestid=b.id and b.isdelete=0 and a.psntype='外包商' and a.comtype='4028804d2083a7ed012083ebb988005b' and rownum=1");
				String updateSql4= "update uf_oa_jccmain set sdate='"+curdate+"',stime='"+fkjccstarttime+"',edate='"+curdate+"',etime='"+strcurtime2+"',oldstay='"+wbszcnum+"',staynum='"+wbsnumsall+"' where requestid='"+jccreqid+"'";
				baseJdbc.update(updateSql4);
				System.out.println(" updateSql4:"+updateSql4);
				String delSql4 = "delete uf_oa_jccsub where requestid='"+jccreqid+"'";
				baseJdbc.update(delSql4);
				System.out.println(" delSql4:"+delSql4);
				System.out.println(" end update uf_oa_jccmain wbs");
			}			
		}
	}
	//return;
	JSONObject jo = new JSONObject();
	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("deptnameall",deptnameall);
		jo.put("psnnumsall",psnnumsall);
		//jo.put("fknumsall",String.valueOf(fknumsall));
		//jo.put("lwgnumsall",String.valueOf(lwgnumsall));
		//jo.put("wbsnumsall",String.valueOf(wbsnumsall));
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("deptnameall",deptnameall);
		jo.put("psnnumsall",psnnumsall);
		//jo.put("fknumsall",String.valueOf(fknumsall));
		//jo.put("lwgnumsall",String.valueOf(lwgnumsall));
		//jo.put("wbsnumsall",String.valueOf(wbsnumsall));		
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	

%>                                                                                                                   
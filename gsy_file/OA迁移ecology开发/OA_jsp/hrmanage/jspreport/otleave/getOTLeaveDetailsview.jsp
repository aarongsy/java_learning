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
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector_EN" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<!--%@ page import="com.eweaver.app.configsap.SapSync"%-->
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/base/init.jsp"%>

<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
//deptid:deptid,allorgid:allorgid,isroot:isroot,kqtype:kqtype,jobno:jobno,jobname:jobname,startdate:startdate,enddate:enddate,daterange:daterange,psntype:psntype,searchtype:searchtype
String deptid = StringHelper.null2String(request.getParameter("deptid"));
String allorgid = StringHelper.null2String(request.getParameter("allorgid"));
String isroot = StringHelper.null2String(request.getParameter("isroot"));
String kqtype = StringHelper.null2String(request.getParameter("kqtype"));	//0 不限 1 加班 2请假
String jobno = StringHelper.null2String(request.getParameter("jobno"));
String jobname = StringHelper.null2String(request.getParameter("jobname"));
String startdate = StringHelper.null2String(request.getParameter("startdate"));
String enddate = StringHelper.null2String(request.getParameter("enddate"));
String daterange = StringHelper.null2String(request.getParameter("daterange"));
String psntype = StringHelper.null2String(request.getParameter("psntype"));
String searchtype = StringHelper.null2String(request.getParameter("searchtype"));
String curruserno = StringHelper.null2String(request.getParameter("curruserno"));


System.out.println("开始执行 加班请假jsp报表查询：getOTLeaveDetailsview.jsp start");
System.out.println("getOTLeaveDetailsview.jsp 参数：deptid="+deptid+" allorgid="+allorgid+" isroot="+isroot+" kqtype="+kqtype+" jobno="+jobno+" jobname="+jobname+" startdate="+startdate+" enddate="+enddate+" daterange="+daterange+" psntype="+psntype+" searchtype="+searchtype+" curruserno="+curruserno);
String errmsg = "";

DataService ds = new DataService();
	/* 	SELECT TO_CHAR(TO_DATE('2014-10-01', 'yyyy-MM-dd') + ROWNUM - 1, 'yyyyMMdd') as daylist   FROM DUAL  CONNECT BY ROWNUM <= trunc(to_date('2017-07-03', 'yyyy-MM-dd') -to_date('2017-10-01', 'yyyy-MM-dd')) + 1  
	*/
	String sql = "";
	String nodesql = "select id,objname from nodeinfo where workflowid='40285a8f489c17ce014908333b744907' or workflowid='40285a904931f62b014936e72ccb2718' or workflowid='40285a90492d5248014931a8f8781e0a' or workflowid='40285a8f489c17ce0148ba6f9012697b'";
	List nodelist = baseJdbc.executeSqlForList(nodesql);
	Map<String, String> nodesmap = new HashMap<String, String>();
	if ( nodelist.size() > 0 ) {
		for ( int i=0;i<nodelist.size();i++  ) {	  
			Map map = (Map)nodelist.get(i);		
			String nodeid = StringHelper.null2String(map.get("id"));
			String nodename = StringHelper.null2String(map.get("objname"));
			nodesmap.put(nodeid, nodename);//节点id			
		}
	}
	
	String ottypesql = "select id,objname from selectitem where typeid='40285a8f489c17ce0149082f51d348cc'";
	List ottypelist = baseJdbc.executeSqlForList(ottypesql);
	Map<String, String> ottypemap = new HashMap<String, String>();
	if ( ottypelist.size() > 0 ) {
		for ( int i=0;i<ottypelist.size();i++  ) {	  
			Map map = (Map)ottypelist.get(i);		
			String ottypeid = StringHelper.null2String(map.get("id"));
			String ottypename = StringHelper.null2String(map.get("objname"));
			ottypemap.put(ottypeid, ottypename);//加班类型id			
		}
	}
	
	String letypesql = "select requestid,vtype from uf_hr_vaclimit a,formbase b where a.requestid=b.id and b.isdelete=0";
	List letypelist = baseJdbc.executeSqlForList(letypesql);
	Map<String, String> letypemap = new HashMap<String, String>();
	if ( letypelist.size() > 0 ) {
		for ( int i=0;i<letypelist.size();i++  ) {	  
			Map map = (Map)letypelist.get(i);		
			String letypeid = StringHelper.null2String(map.get("requestid"));
			String letypename = StringHelper.null2String(map.get("vtype"));
			letypemap.put(letypeid, letypename);//请假类型id			
		}
	}	
	
	String daylistsql = "";
	
	//daterange	0 仅今天 1 前后7天 2 前7天  3 后7天 4 本月  5 上月  6 下月 7 指定期间（查询所有人：不可超过100天，查询单个人：不可超过366天）
	if( "0".equals(daterange) ) {
		daylistsql = "select to_char(sysdate, 'yyyy-MM-dd') as day from dual";
	} else if (  "1".equals(daterange) ) { //假设当前2018-02-12  获取前7天后7天  2018-02-05~2018-02-19期间
		daylistsql = "select to_char(sysdate + rownum -8, 'yyyy-MM-dd') as day from dual connect by rownum <= 15";
	} else if (  "2".equals(daterange) ) { //假设结束日期 2018-02-19 获取前7天  2018-02-12~2018-02-19期间
		daylistsql = "select to_char( sysdate - rownum + 1, 'yyyy-MM-dd') as day from dual connect by rownum <= 8";
	} else if (  "3".equals(daterange) ) { //假设开始日期 2018-02-01 获取后7天  2018-02-01~2018-02-08期间
		daylistsql = "select to_char( sysdate + rownum - 1, 'yyyy-MM-dd') as day from dual connect by rownum <= 8";
	} else if (  "4".equals(daterange) ) { //假设开始日期 2018-02-22 获取本月  2018-02-01~2018-02-28期间
		int monthdays = Integer.parseInt(ds.getValue("select to_char(last_day(sysdate),'dd') from dual"));
		String firstday = ds.getValue("select to_char(sysdate,'yyyy-MM') || '-01' from dual");
		daylistsql = "select to_char( to_date('"+firstday+"', 'yyyy-MM-dd') + rownum - 1, 'yyyy-MM-dd') as day from dual connect by rownum <= "+monthdays;
	} else if (  "5".equals(daterange) ) { //假设开始日期 2018-02-22 获取上月  2018-01-01~2018-01-31期间
		int monthdays = Integer.parseInt(ds.getValue("select to_char(last_day(add_months(sysdate, -1)),'dd') from dual"));
		String firstday = ds.getValue("select to_char(last_day(add_months(sysdate, -2)) + 1,'yyyy-MM-dd')  from dual");
		daylistsql = "select to_char( to_date('"+firstday+"', 'yyyy-MM-dd') + rownum - 1, 'yyyy-MM-dd') as day from dual connect by rownum <= "+monthdays;
	} else if (  "6".equals(daterange) ) { //假设开始日期 2018-02-22 获取下月  2018-03-01~2018-03-31期间
		int monthdays = Integer.parseInt(ds.getValue("select to_char(last_day(add_months(sysdate, 1)),'dd') from dual"));
		String firstday = ds.getValue("select to_char(last_day(sysdate) + 1,'yyyy-MM-dd')  from dual");
		daylistsql = "select to_char( to_date('"+firstday+"', 'yyyy-MM-dd') + rownum - 1, 'yyyy-MM-dd') as day from dual connect by rownum <= "+monthdays;
	}  else if (  "7".equals(daterange) ) {
		if (  !"".equals(startdate) && !"".equals(enddate) ) {	//假设指定开始日期~结束日期，如未指定人员，不可超过100天；指定人员的，可以查询1年的366天
			if( "".equals(jobname) && "".equals(jobno) ) {
				daylistsql = "select to_char(to_date('"+startdate+"', 'yyyy-MM-dd') + rownum - 1, 'yyyy-MM-dd') as day from dual connect by rownum <= trunc(to_date('"+enddate+"', 'yyyy-MM-dd') -to_date('"+startdate+"', 'yyyy-MM-dd')) + 1  and rownum < =100";
			} else {
				daylistsql = "select to_char(to_date('"+startdate+"', 'yyyy-MM-dd') + rownum - 1, 'yyyy-MM-dd') as day from dual connect by rownum <= trunc(to_date('"+enddate+"', 'yyyy-MM-dd') -to_date('"+startdate+"', 'yyyy-MM-dd')) + 1  and rownum < =366";
			}		
		} else {
			daylistsql = "select to_char(sysdate, 'yyyy-MM-dd') as day from dual";
			errmsg = " 指定日期范围，查询起止日期不可为空";
		}
	}
	List daylist = baseJdbc.executeSqlForList(daylistsql);
	Map<Integer, String> daysmap = new HashMap<Integer, String>();	
	if ( daylist.size() > 0 ) {
		for ( int i=0;i<daylist.size();i++  ) {	  
			Map map = (Map)daylist.get(i);				
			String day = StringHelper.null2String(map.get("day"));
			daysmap.put(i, day );//日期列表		
			if (i==0 ) {
				startdate = day;
			}
			if (i==daylist.size()-1 ) {
				enddate = day;
			}
		}
	}	
	
	
	if ( "0".equals(kqtype) ||  "1".equals(kqtype) ) {
		sql = "select a.*,b.objname jobnametxt,c.objname deptname from uf_hr_overtime a left join humres b on a.objname=b.id left join orgunit c on b.orgid=c.id where b.isdelete=0 and a.valid='40288098276fc2120127704884290210' and exists(select 1 from requestbase where id=a.requestid and isdelete=0) ";
		if ( !"".equals(jobno) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql = sql +" and '"+jobno+"'=a.jobno";
			} else {	//模糊查询
				sql = sql +" and ( instr( a.jobno,'"+jobno+"')>0 or instr( '"+jobno+"',a.jobno)>0)";
			}
		} 
		if ( !"".equals(jobname) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql = sql +" and '"+jobname+"'=b.objname ";
			} else {	//模糊查询
				sql = sql +" and ( instr( b.objname,'"+jobname+"')>0 or instr( '"+jobname+"',b.objname)>0 )";
			}			
		} 
		if ( !"".equals(startdate) ) {
			sql = sql +" and (a.realstartdate>='"+startdate+"' or a.startdate>='"+startdate+"' )";
		} 
		if ( !"".equals(enddate) ) {
			sql = sql +" and (a.realstartdate<= '"+enddate+"' or a.startdate<='"+enddate+"')";
		}	
		
		if( "3".equals(psntype) ) {	//常熟厂全厂查询
			sql = sql +" and a.comtype='4028804d2083a7ed012083ebb988005b' ";
		}
		if( "4".equals(psntype) ) {	//长沙厂全厂查询
			sql = sql +" and a.comtype='40285a90488ba9d101488bbdeeb30008' ";
		}
		if( "5".equals(psntype) ) {	//盘锦厂全厂查询
			sql = sql +" and a.comtype='40285a90488ba9d101488bbd09100007' ";
		}
		
	} 
	
	String humresidsql = " select id from humres where isdelete = 0 and hrstatus = '4028804c16acfbc00116ccba13802935' and objname <> 'sysadmin' ";
	if ( !"".equals(jobname) ) {
		if( "1".equals(searchtype) ) { //精确查询
			humresidsql = humresidsql +" and '"+jobname+"'=objname";
		} else {	//模糊查询
			humresidsql = humresidsql +" and ( instr(objname, '"+jobname+"')>0 or instr( '"+jobname+"',objname)>0)";
		}
	} 
	if( "2".equals(psntype) ) {	//常熟厂全厂主管查询
		humresidsql = humresidsql +" and extrefobjfield5='4028804d2083a7ed012083ebb988005b' ";
		humresidsql = humresidsql +" and ( ((extselectitemfield11='40285a8f489c17ce0148f371f98a6740' or extselectitemfield11='40285a8f489c17ce0148f371f98a6741') and ((select nameid from uf_profe where requestid =extrefobjfield4) in ('A9','C7','AA','AB','B1','BJ','CA','B31','C0','C1A','CB','AC','A7')) ) or ( (extselectitemfield11='40285a8f489c17ce0148f371f989673d' or extselectitemfield11='40285a8f489c17ce0148f371f98a673e') and (select NVL(zjlevel,0) from uf_profe where requestid =extrefobjfield4)>=67   ) ) "; //员工组外籍
		
	}
	if( "3".equals(psntype) ) {	//常熟厂全厂查询
		humresidsql = humresidsql +" and extrefobjfield5='4028804d2083a7ed012083ebb988005b' ";
	}
	if( "4".equals(psntype) ) {	//长沙厂全厂查询
		humresidsql = humresidsql +" and extrefobjfield5='40285a90488ba9d101488bbdeeb30008' ";
	}
	if( "5".equals(psntype) ) {	//盘锦厂全厂查询
		humresidsql = humresidsql +" and extrefobjfield5='40285a90488ba9d101488bbd09100007' ";
	}
	if ( "all".equals(deptid) ) {	
		if( !"2".equals(psntype)  && !"3".equals(psntype) && !"4".equals(psntype) && !"5".equals(psntype) ) {  	//常熟厂全厂主管查询, 不按部门去查询
			allorgid = allorgid.replace(",", "','");
			//humresidsql = humresidsql + " and instr("+allorgid+",orgid) >0 ";
			humresidsql = humresidsql + " and orgid in ('"+allorgid+"')";
		}
		
	} else if (  !"".equals(deptid) ) {
		if ( "1".equals(isroot) ){
			humresidsql = humresidsql +  " and instr(get_all_orgid(orgid),'" + deptid + "') >0 ";
		} else {
			humresidsql = humresidsql + " and '"+deptid+"'= orgid ";
		}
	}
	if ( !"".equals(sql) ) {
		sql = sql + " and a.objname in ("+humresidsql+")";
		sql = sql + " order by c.id asc,a.jobno asc,a.flowno asc";
		System.out.println("getOTLeaveDetailsview.jsp 加班查询sql="+sql);
	}
	

	
	String sql2 = "";	//请假sql
	if ( "0".equals(kqtype) || "2".equals(kqtype) ) {
		sql2 = "select a.*,b.objname jobnametxt,c.objname deptname from uf_hr_vacation a left join humres b on a.objname=b.id left join orgunit c on b.orgid=c.id where b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and exists(select 1 from requestbase where id=a.requestid and isdelete=0) "; 
		if ( !"".equals(jobno) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql2 = sql2 +" and '"+jobno+"'=a.jobno ";
			} else {	//模糊查询
				sql2 = sql2 +" and ( instr(a.jobno, '"+jobno+"')>0 or instr( '"+jobno+"',a.jobno)>0 )";
			}				
		} 
		if ( !"".equals(jobname) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql2 = sql2 +" and '"+jobname+"'=b.objname ";
			} else {	//模糊查询
				sql2 = sql2 +" and ( instr( b.objname,'"+jobname+"')>0 or instr( '"+jobname+"',b.objname)>0)";
			}				
		} 
		if( daylist.size()>0 ) {
			sql2 = sql2 +" and ( ";
			for ( int i=0;i<daylist.size();i++  ) {	
				if ( i==0 ) {
					sql2 = sql2 + "( to_date('"+daysmap.get(i)+"','yyyy-MM-dd') between to_date(a.startdate,'yyyy-MM-dd') and to_date(a.enddate,'yyyy-MM-dd') )";
				} else {
					sql2 = sql2 + "or ( to_date('"+daysmap.get(i)+"','yyyy-MM-dd') between to_date(a.startdate,'yyyy-MM-dd') and to_date(a.enddate,'yyyy-MM-dd') )";
				}
			}
			sql2 = sql2 +" ) ";
		}
		
		if( "3".equals(psntype) ) {	//常熟厂全厂查询
			sql2 = sql2+" and a.comtype='4028804d2083a7ed012083ebb988005b' ";
		}
		if( "4".equals(psntype) ) {	//长沙厂全厂查询
			sql2 = sql2 +" and a.comtype='40285a90488ba9d101488bbdeeb30008' ";
		}
		if( "5".equals(psntype) ) {	//盘锦厂全厂查询
			sql2 = sql2 +" and a.comtype='40285a90488ba9d101488bbd09100007' ";
		}		
	}
	if ( !"".equals(sql2) ) {
		sql2 = sql2 + " and a.objname in ("+humresidsql+")";
		sql2 = sql2 + " order by c.id asc,a.jobno asc,a.flowno asc";
		System.out.println("getOTLeaveDetailsview.jsp 请假查询sql2="+sql2);
	}

		
  	String tripareasql = "select id,objname from selectitem where typeid='40285a904a6fdaa1014a7b8a0eca4d50'";
	List triparealist = baseJdbc.executeSqlForList(tripareasql);
	Map<String, String> tripareamap = new HashMap<String, String>();
	if ( triparealist.size() > 0 ) {
		for ( int i=0;i<triparealist.size();i++  ) {	  
			Map map = (Map)triparealist.get(i);		
			String tripareaid = StringHelper.null2String(map.get("id"));
			String tripareaname = StringHelper.null2String(map.get("objname"));
			tripareamap.put(tripareaid, tripareaname);//出差区域id			
		}
	}	
	
  	String traintypesql = "select id,objname from selectitem where typeid='40285a8d5adb5a06015b135d4ae52c92'";
	List traintypelist = baseJdbc.executeSqlForList(traintypesql);
	Map<String, String> traintypemap = new HashMap<String, String>();
	if ( traintypelist.size() > 0 ) {
		for ( int i=0;i<traintypelist.size();i++  ) {	  
			Map map = (Map)traintypelist.get(i);		
			String traintypeid = StringHelper.null2String(map.get("id"));
			String traintypename = StringHelper.null2String(map.get("objname"));
			traintypemap.put(traintypeid, traintypename);//外训培训类型id			
		}
	}	
  
  
	String sql3 = ""; //出差记录
	if ( "0".equals(kqtype) || "3".equals(kqtype) ) {
		sql3 = "select a.*,b.objname jobnametxt,b.objno jobnotxt,c.objname deptname from uf_hr_businesstrip a left join humres b on a.psnname=b.id left join orgunit c on b.orgid=c.id where b.isdelete=0 and a.isvalided='40288098276fc2120127704884290210' and exists(select 1 from requestbase where id=a.requestid and isdelete=0)";
		if ( !"".equals(jobno) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql3 = sql3 +" and '"+jobno+"'=b.objno ";
			} else {	//模糊查询
				sql3 = sql3 +" and ( instr(b.objno, '"+jobno+"')>0 or instr( '"+jobno+"',b.objno)>0 )";
			}				
		} 
		if ( !"".equals(jobname) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql3 = sql3 +" and '"+jobname+"'=b.objname ";
			} else {	//模糊查询
				sql3 = sql3 +" and ( instr( b.objname,'"+jobname+"')>0 or instr( '"+jobname+"',b.objname)>0)";
			}				
		} 
		if( daylist.size()>0 ) {
			sql3 = sql3 +" and ( ";
			for ( int i=0;i<daylist.size();i++  ) {	
				if ( i==0 ) {
					sql3 = sql3 + "( to_date('"+daysmap.get(i)+"','yyyy-MM-dd') between to_date(a.sdate,'yyyy-MM-dd') and to_date(a.edate,'yyyy-MM-dd') )";
				} else {
					sql3 = sql3 + "or ( to_date('"+daysmap.get(i)+"','yyyy-MM-dd') between to_date(a.sdate,'yyyy-MM-dd') and to_date(a.edate,'yyyy-MM-dd') )";
				}
			}
			sql3 = sql3 +" ) ";
		}		
		if( "3".equals(psntype) ) {	//常熟厂全厂查询
			sql3 = sql3+" and a.comtype='4028804d2083a7ed012083ebb988005b' ";
		}
		if( "4".equals(psntype) ) {	//长沙厂全厂查询
			sql3 = sql3 +" and a.comtype='40285a90488ba9d101488bbdeeb30008' ";
		}
		if( "5".equals(psntype) ) {	//盘锦厂全厂查询
			sql3 = sql3 +" and a.comtype='40285a90488ba9d101488bbd09100007' ";
		}			
	}
	if ( !"".equals(sql3) ) {
		sql3 = sql3 + " and a.psnname in ("+humresidsql+")";
		sql3 = sql3 + " order by c.id asc,b.objno asc,a.flowno asc";
		System.out.println("getOTLeaveDetailsview.jsp 出差查询sql3="+sql3);
	}	
	
	String sql4 = ""; //外训记录
	if ( "0".equals(kqtype) || "4".equals(kqtype) ) {
		sql4 = "select a.*,d.*,b.objname jobnametxt,b.objno jobnotxt,c.objname deptname from uf_hr_outlessonsub a left join uf_hr_outlesson d on a.requestid=d.requestid left join humres b on a.objname=b.id left join orgunit c on b.orgid=c.id where b.isdelete=0 and d.isvalided='40288098276fc2120127704884290210' and exists(select 1 from requestbase where id=a.requestid and isdelete=0)";
		if ( !"".equals(jobno) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql4 = sql4 +" and '"+jobno+"'=b.objno ";
			} else {	//模糊查询
				sql4 = sql4 +" and ( instr(b.objno, '"+jobno+"')>0 or instr( '"+jobno+"',b.objno)>0 )";
			}				
		} 
		if ( !"".equals(jobname) ) {
			if( "1".equals(searchtype) ) { //精确查询
				sql4 = sql4 +" and '"+jobname+"'=b.objname ";
			} else {	//模糊查询
				sql4 = sql4 +" and ( instr( b.objname,'"+jobname+"')>0 or instr( '"+jobname+"',b.objname)>0)";
			}				
		} 
		if( daylist.size()>0 ) {
			sql4 = sql4 +" and ( ";
			for ( int i=0;i<daylist.size();i++  ) {	
				if ( i==0 ) {
					sql4 = sql4 + "( to_date('"+daysmap.get(i)+"','yyyy-MM-dd') between to_date(d.sdate,'yyyy-MM-dd') and to_date(d.edate,'yyyy-MM-dd') )";
				} else {
					sql4 = sql4 + "or ( to_date('"+daysmap.get(i)+"','yyyy-MM-dd') between to_date(d.sdate,'yyyy-MM-dd') and to_date(d.edate,'yyyy-MM-dd') )";
				}
			}
			sql4 = sql4 +" ) ";
		}		
		if( "3".equals(psntype) ) {	//常熟厂全厂查询
			sql4 = sql4+" and d.comtype='4028804d2083a7ed012083ebb988005b' ";
		}
		if( "4".equals(psntype) ) {	//长沙厂全厂查询
			sql4 = sql4 +" and d.comtype='40285a90488ba9d101488bbdeeb30008' ";
		}
		if( "5".equals(psntype) ) {	//盘锦厂全厂查询
			sql4 = sql4 +" and d.comtype='40285a90488ba9d101488bbd09100007' ";
		}			
	}
	if ( !"".equals(sql4) ) {
		sql4 = sql4 + " and a.objname in ("+humresidsql+")";
		sql4 = sql4 + " order by c.id asc,b.objno asc,d.flowno asc";
		System.out.println("getOTLeaveDetailsview.jsp 外训查询sql4="+sql4);
	}		
	
	
//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a9049f5c9900149f91201c0002a' or roleid='40285a904abeeb0e014ac37afe343d02')) or id='40285a9049ade1710149adea9ef20caf'"));


//Integer rowlen = 0;
Integer k = 0;
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
<DIV id="warpp">
<TABLE border=1 id="otinfoid">
<CAPTION><STRONG>加班/请假信息</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('otinfoid','')"><FONT color=#ff0000>导出Excel</FONT></A></SPAN></</CAPTION>
<COLGROUP>
<COL width="3%">
<COL width="5%">
<COL width="6%">
<COL width="8%">
<COL width="5%">
<!--COL width="0%"-->
<COL width="8%">
<COL width="8%">
<!--COL width="0%"-->
<COL width="10%">
<!--COL width="0%"-->
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="3%">
<COL width="8%">
</COLGROUP>
<TBODY>
<TR>
<TD>序号</TD>
<TD>员工工号</TD>
<TD>姓名</TD>
<TD>部门</TD>
<TD>考勤类型</TD>
<TD style="display:none">填单日期</TD>
<TD>单号</TD>
<TD>审批节点</TD>
<TD style="display:none">当前审批人</TD>
<TD>加班类型/请假假别</TD>
<!--TD style="display:none">假别</TD-->
<TD>开始日期</TD>
<TD>开始时间</TD>
<TD>结束日期</TD>
<TD>结束时间</TD>
<TD>时数</TD>
<TD>天数</TD>
<TD>事由</TD>
</TR>
<%

		if ( !"".equals(sql) ) {
			List list = baseJdbc.executeSqlForList(sql);
			if ( list.size() > 0 ) {		  
			 try {	
				for ( int i=0;i<list.size();i++  ) {	  
					Map map = (Map)list.get(i);
					k++;
					String otjobno = StringHelper.null2String(map.get("jobno"));
					String otjobname = StringHelper.null2String(map.get("jobnametxt"));
					String otdeptname = StringHelper.null2String(map.get("deptname"));
					String otkqtype = "加班";
					String otreqdate = StringHelper.null2String(map.get("reqdate"));
					String otflowno = StringHelper.null2String(map.get("flowno"));
					String otrequestid = StringHelper.null2String(map.get("requestid"));
					String otcurrentnode = StringHelper.null2String(map.get("currentnode"));
					String otcurrnodename = StringHelper.null2String(nodesmap.get(otcurrentnode));
					String otapprover = "";
					if( !"40285a8f489c17ce0149083f05de4a6e".equals(otcurrentnode) ){ //还没有结束
						otapprover = ds.getValue("select (select objname from humres where id=userid) approver from REQUESTOPERATORS where requestid='"+otrequestid+"' and ISSUBMIT=0");
					}
					String ottype = StringHelper.null2String(map.get("objtype"));
					String ottypename = StringHelper.null2String(ottypemap.get(ottype));
					
					String otstart = "";
					String otstarttime = "";
					String otend = "";
					String otendtime = "";	
					String othour = "";					
					
					String otappstart = StringHelper.null2String(map.get("startdate"));
					String otappstarttime = StringHelper.null2String(map.get("starttime"));
					String otappend = StringHelper.null2String(map.get("enddate"));
					String otappendtime = StringHelper.null2String(map.get("endtime"));
					String otapphour = StringHelper.null2String(map.get("overtime"));
					
					String otactstart = StringHelper.null2String(map.get("realstartdate"));
					String otactstarttime = StringHelper.null2String(map.get("realstarttime"));
					String otactend = StringHelper.null2String(map.get("realenddate"));
					String otactendtime = StringHelper.null2String(map.get("realendtime"));
					String otacthour = StringHelper.null2String(map.get("acthours"));
					
					if( "40285a8f489c17ce0149083f05234a4e".equals(otcurrentnode) || "40285a8f489c17ce0149083f05624a58".equals(otcurrentnode)  || "40285a8f489c17ce0149083f054a4a54".equals(otcurrentnode)  || "40285a8f489c17ce0149083f05564a56".equals(otcurrentnode)  || "40285a8f489c17ce0149083f05314a50".equals(otcurrentnode)  || "40285a8f489c17ce0149083f053e4a52".equals(otcurrentnode)  || "40285a8f489c17ce0149083f056e4a5a".equals(otcurrentnode)  || "40285a8f489c17ce0149083f057a4a5c".equals(otcurrentnode)) { //申请人确认之前的环节（含申请人确认）
						otstart = otappstart;
						otstarttime = otappstarttime;
						otend = otappend;
						otendtime = otappendtime;
						othour = otapphour;
					} else {
						otstart = otactstart;
						otstarttime = otactstarttime;
						otend = otactend;
						otendtime = otactendtime;
						othour = otacthour;
					}
					
					
					String otreason = StringHelper.null2String(map.get("reason"));
%>
<TR>
<TD><%=k %></TD>
<TD><%=otjobno %></TD>
<TD><%=otjobname %></TD>
<TD><%=otdeptname %></TD>
<TD><%=otkqtype %></TD>
<TD  style="display:none"><%=otreqdate %></TD>
<TD><%=otflowno %><input id="showotid" type=<% if("2".equals(psntype) ) {%>"hidden" <%} else {%>"button" <%}%> name="showotidbutton" value="查看" onclick="openflow('<%=otflowno %>','<%=otrequestid %>');" /></TD>
<TD><%=otcurrnodename %></TD>
<TD style="display:none"><%=otapprover %></TD>
<TD><%=ottypename %></TD>
<!--TD style="display:none"></TD-->
<TD><%=otstart %></TD>
<TD><%=otstarttime %></TD>
<TD><%=otend %></TD>
<TD><%=otendtime %></TD>
<TD><%=othour %></TD>
<TD></TD>
<TD><%=otreason %></TD></TR>
<%						
					
					
				}
			 } catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("getOTLeaveDetailsview.jsp--OT error！");
			 }
			}else {
				errmsg = errmsg+ "\n\r 没有查询到加班相关信息，请更改查询条件后再试";
			}
		}

		if ( !"".equals(sql2) ) {
			List list2 = baseJdbc.executeSqlForList(sql2);
			if ( list2.size() > 0 ) {		  
			 try {	
				for ( int i=0;i<list2.size();i++  ) {	  
					Map map2 = (Map)list2.get(i);
					k++;
					String lejobno = StringHelper.null2String(map2.get("jobno"));
					String lejobname = StringHelper.null2String(map2.get("jobnametxt"));
					String ledeptname = StringHelper.null2String(map2.get("deptname"));
					String lekqtype = "请假";
					String lereqdate = StringHelper.null2String(map2.get("credate"));
					String leflowno = StringHelper.null2String(map2.get("flowno"));
					String lerequestid = StringHelper.null2String(map2.get("requestid"));
					
					String lecurrentnode = ds.getValue("select b.id as currentnode from REQUESTINFO a,nodeinfo b where a.CURRENTNODEID=b.id and a.requestid='"+lerequestid+"'");
					String lecurrnodename = StringHelper.null2String(nodesmap.get(lecurrentnode));
					String leapprover = "";
					if( !"40285a904931f62b014936eae90e273e".equals(lecurrentnode) ){ //还没有结束
						leapprover = ds.getValue("select (select objname from humres where id=userid) approver from REQUESTOPERATORS where requestid='"+lerequestid+"' and ISSUBMIT=0");
					}
					String letype = StringHelper.null2String(map2.get("reqtype"));
					String letypename = StringHelper.null2String(letypemap.get(letype));
									
					String lestart = StringHelper.null2String(map2.get("startdate"));
					String lestarttime = StringHelper.null2String(map2.get("starttime"));
					String leend = StringHelper.null2String(map2.get("enddate"));
					String leendtime = StringHelper.null2String(map2.get("endtime"));
					String lehour = StringHelper.null2String(map2.get("hours"));
					String ledays = StringHelper.null2String(map2.get("days"));
					
					String lereason = StringHelper.null2String(map2.get("reason"));					
					
%>
<TR>
<TD><%=k %></TD>
<TD><%=lejobno %></TD>
<TD><%=lejobname %></TD>
<TD><%=ledeptname %></TD>
<TD><%=lekqtype %></TD>
<TD style="display:none"><%=lereqdate %></TD>
<TD><%=leflowno %><input id="showotid" type=<% if("2".equals(psntype) ) {%>"hidden" <%} else {%>"button" <%}%> name="showotidbutton" value="查看" onclick="openflow('<%=leflowno %>','<%=lerequestid %>');" /></TD>
<TD><%=lecurrnodename %></TD>
<TD style="display:none"><%=leapprover %></TD>
<TD><%=letypename %></TD>
<!--TD style="display:none"></TD-->
<TD><%=lestart %></TD>
<TD><%=lestarttime %></TD>
<TD><%=leend %></TD>
<TD><%=leendtime %></TD>
<TD><%=lehour %></TD>
<TD><%=ledays %></TD>
<TD><%=lereason %></TD></TR>
<%						
					
					
				}
			 } catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("getOTLeaveDetailsview.jsp-Leave error！");
			 }
			}else {
				errmsg =errmsg+ "\n\r 没有查询到请假相关信息，请更改查询条件后再试";
			}
		}		
 // if( "2".equals(psntype) ) {	//常熟厂全厂主管查询  要查询出差外训信息
	
	
		if ( !"".equals(sql3) ) {
			List list3 = baseJdbc.executeSqlForList(sql3);
			if ( list3.size() > 0 ) {		  
			 try {	
				for ( int i=0;i<list3.size();i++  ) {	  
					Map map3 = (Map)list3.get(i);
					k++;
					String trjobno = StringHelper.null2String(map3.get("jobnotxt"));
					String trjobname = StringHelper.null2String(map3.get("jobnametxt"));
					String trdeptname = StringHelper.null2String(map3.get("deptname"));
					String trkqtype = "出差";
					String trreqdate = StringHelper.null2String(map3.get("reqdate"));
					String trflowno = StringHelper.null2String(map3.get("flowno"));
					String trrequestid = StringHelper.null2String(map3.get("requestid"));
					
					String trcurrentnode = StringHelper.null2String(map3.get("currentnode"));
					String trcurrnodename = StringHelper.null2String(nodesmap.get(trcurrentnode));
					String trapprover = "";
					if( !"40285a90492d5248014931b08f571e41".equals(trcurrentnode) ){ //还没有结束
						trapprover = ds.getValue("select (select objname from humres where id=userid) approver from REQUESTOPERATORS where requestid='"+trrequestid+"' and ISSUBMIT=0");
					}
					String trtype = StringHelper.null2String(map3.get("triparea"));
					String trtypename = StringHelper.null2String(tripareamap.get(trtype));
									
					String trstart = StringHelper.null2String(map3.get("sdate"));
					String trstarttime = StringHelper.null2String(map3.get("stime"));
					String trend = StringHelper.null2String(map3.get("edate"));
					String trendtime = StringHelper.null2String(map3.get("etime"));
					String trhour = StringHelper.null2String(map3.get("tripallhours"));
					String trdays = StringHelper.null2String(map3.get("nums"));
					
					String unit = ds.getValue("select wm_concat(distinct unit) unit from uf_hr_businesstripsub where requestid='"+trrequestid+"'");
					String trreason = StringHelper.null2String(map3.get("reason")) + "："+ unit;					
					
%>
<TR>
<TD><%=k %></TD>
<TD><%=trjobno %></TD>
<TD><%=trjobname %></TD>
<TD><%=trdeptname %></TD>
<TD><%=trkqtype %></TD>
<TD style="display:none"><%=trreqdate %></TD>
<TD><%=trflowno %><input id="showotid" type=<% if("2".equals(psntype) ) {%>"hidden" <%} else {%>"button" <%}%> name="showotidbutton" value="查看" onclick="openflow('<%=trflowno %>','<%=trrequestid %>');" /></TD>
<TD><%=trcurrnodename %></TD>
<TD style="display:none"><%=trapprover %></TD>
<TD><%=trtypename %></TD>
<!--TD style="display:none"></TD-->
<TD><%=trstart %></TD>
<TD><%=trstarttime %></TD>
<TD><%=trend %></TD>
<TD><%=trendtime %></TD>
<TD><%=trhour %></TD>
<TD><%=trdays %></TD>
<TD><%=trreason %></TD></TR>
<%						
					
					
				}
			 } catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("getOTLeaveDetailsview.jsp-Travel error！");
			 }
			}else {
				errmsg =errmsg+ "\n\r 没有查询到出差相关信息，请更改查询条件后再试";
			}
		}	
		
		//外训
		if ( !"".equals(sql4) ) {
			List list4 = baseJdbc.executeSqlForList(sql4);
			if ( list4.size() > 0 ) {		  
			 try {	
				for ( int i=0;i<list4.size();i++  ) {	  
					Map map4 = (Map)list4.get(i);
					k++;
					String wxjobno = StringHelper.null2String(map4.get("jobno"));
					String wxjobname = StringHelper.null2String(map4.get("jobnametxt"));
					String wxdeptname = StringHelper.null2String(map4.get("deptname"));
					String wxkqtype = "外训";
					String wxreqdate = StringHelper.null2String(map4.get("reqdate"));
					String wxflowno = StringHelper.null2String(map4.get("flowno"));
					String wxrequestid = StringHelper.null2String(map4.get("requestid"));
					
					String wxcurrentnode =  ds.getValue("select b.id as currentnode from REQUESTINFO a,nodeinfo b where a.CURRENTNODEID=b.id and a.requestid='"+wxrequestid+"'");;
					String wxcurrnodename = StringHelper.null2String(nodesmap.get(wxcurrentnode));
					String wxapprover = "";
					if( !"40285a8f489c17ce0148baa711286a22".equals(wxcurrentnode) ){ //还没有结束
						wxapprover = ds.getValue("select (select objname from humres where id=userid) approver from REQUESTOPERATORS where requestid='"+wxrequestid+"' and ISSUBMIT=0");
					}
					String wxtype = StringHelper.null2String(map4.get("pxleixing"));
					String wxtypename = StringHelper.null2String(traintypemap.get(wxtype));
									
					String wxstart = StringHelper.null2String(map4.get("sdate"));
					String wxstarttime = StringHelper.null2String(map4.get("stime"));
					String wxend = StringHelper.null2String(map4.get("edate"));
					String wxendtime = StringHelper.null2String(map4.get("etime"));
					String wxhour = "";
					String wxdays =  StringHelper.null2String(map4.get("days"));
					
					String wxreason = StringHelper.null2String(map4.get("lesson"));					
					
%>
<TR>
<TD><%=k %></TD>
<TD><%=wxjobno %></TD>
<TD><%=wxjobname %></TD>
<TD><%=wxdeptname %></TD>
<TD><%=wxkqtype %></TD>
<TD style="display:none"><%=wxreqdate %></TD>
<TD><%=wxflowno %><input id="showotid" type=<% if("2".equals(psntype) ) {%>"hidden" <%} else {%>"button" <%}%> name="showotidbutton" value="查看" onclick="openflow('<%=wxflowno %>','<%=wxrequestid %>');" /></TD>
<TD><%=wxcurrnodename %></TD>
<TD style="display:none"><%=wxapprover %></TD>
<TD><%=wxtypename %></TD>
<!--TD style="display:none"></TD-->
<TD><%=wxstart %></TD>
<TD><%=wxstarttime %></TD>
<TD><%=wxend %></TD>
<TD><%=wxendtime %></TD>
<TD><%=wxhour %></TD>
<TD><%=wxdays %></TD>
<TD><%=wxreason %></TD></TR>
<%						
					
					
				}
			 } catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("getOTLeaveDetailsview.jsp-OutTrainning error！");
			 }
			}else {
				errmsg =errmsg+ "\n\r 没有查询到外训相关信息，请更改查询条件后再试";
			}
		}		

 //}
		
		

%>

</TBODY></TABLE>
<%	

		
		if ( !"".equals(errmsg) ) {
			
%>	
		
<TABLE border=1 id="errorinfoid">
<TBODY>
<TR>
<TD>查询提示信息:<%=errmsg %></TD>
</TR>
</TBODY></TABLE>
<%	
		}
%>
</DIV>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
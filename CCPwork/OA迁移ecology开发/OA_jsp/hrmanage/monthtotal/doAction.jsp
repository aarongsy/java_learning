<%@page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@page import="jxl.biff.IntegerHelper"%>
<%@ page contentType="text/html; charset=UTF-8"%>
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
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String begindate=StringHelper.null2String(request.getParameter("begindate"));
	String enddate=StringHelper.null2String(request.getParameter("enddate"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String comtype=StringHelper.null2String(request.getParameter("comtype"));
	String reqdept=StringHelper.null2String(request.getParameter("reqdept"));
	//清空历史数据
	String sql = "delete from uf_hr_monthtotalsub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	//更新主表
	sql = "update uf_hr_monthtotal set imtype='2' where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	DataService otherdataservices = new DataService();
	String where="";
	if(comtype.equals("4028804d2083a7ed012083ebb988005b") || comtype.equals("40285a90488ba9d101488bbdeeb30008")){//常熟厂	或长沙厂
		otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfooddata"));	
	}
	if(comtype.equals("40285a90488ba9d101488bbd09100007")){ //盘锦厂
		otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("pjfooddata"));	
		where =" and a.extselectitemfield11!='40285a8f489c17ce0148f371f98a6740' and a.extselectitemfield11!='40285a8f489c17ce0148f371f98a6741' ";
	}
	if(comtype.equals("4028804d2083a7ed012083ebb988005b") || comtype.equals("40285a90488ba9d101488bbdeeb30008") || comtype.equals("40285a90488ba9d101488bbd09100007")){//常熟厂	或长沙厂 盘锦厂
		//DataService otherdataservices = new DataService();
		//otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfooddata"));	
		/**
		**开始逻辑计算扣款
		**循环开始日期到结束日期，计算每天的扣款的集合 
		**/
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date bd = ft.parse(begindate);
		Date ed = ft.parse(enddate);
		int dnums = (int)((ed.getTime() - bd.getTime()) / 1000 / 60 / 60 / 24)+1;		
		Calendar cd= Calendar.getInstance();	
		//根据厂区别循环员工 
		sql = "select a.objno,a.exttextfield15 sapid,a.id hid,a.objname hname,a.orgid oid,b.objname oname,a.extmrefobjfield9 comid,c.objname comname from humres a left join orgunit b on a.orgid=b.id left join orgunit c on a.extmrefobjfield9=c.id where a.isdelete=0 and a.hrstatus='4028804c16acfbc00116ccba13802935' and instr('"+reqdept+"',extmrefobjfield8)>0 and a.extrefobjfield5='"+comtype+"' and NVL(exttextfield15,'0')<>'0' "+where+" order by a.objno asc";
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			System.out.println("员工每月就餐扣款计算开始.....总人数："+list.size()+" requestid:"+requestid);
			for(int n=0;n<list.size();n++){				
				double total = 0.0;//合计
				Map map = (Map)list.get(n);
				String objno = StringHelper.null2String(map.get("objno"));
				objno = objno.trim();
				String sapid = StringHelper.null2String(map.get("sapid"));
				String hid = StringHelper.null2String(map.get("hid"));
				String hname = StringHelper.null2String(map.get("hname"));
				String oid = StringHelper.null2String(map.get("oid"));
				String oname = StringHelper.null2String(map.get("oname"));
				String comid = StringHelper.null2String(map.get("comid"));
				String comname = StringHelper.null2String(map.get("comname"));
				
				String chksql = "select jobno from uf_hr_monthtotalsub where requestid='"+requestid+"' and jobno='"+objno+"'";
				List clist = baseJdbc.executeSqlForList(chksql);
				int cnum = clist.size();
				//System.out.println("cnum="+cnum);
				if(cnum==0){		
					//System.out.println("员工每月就餐扣款计算:"+hname);
					for(int i=0;i<dnums;i++){//循环天数 					
						double bm = 0.0; //早餐扣款
						double lm = 0.0; //午餐扣款
						double dm = 0.0; //晚餐 扣款
						String begintime = "";
						String endtime = "";
						Map<String,String> m=new HashMap<String,String>();
						String fsql = "";
						List flist = null;
						cd.setTime(ft.parse(begindate));
						cd.add(Calendar.DATE,i);
						String nday = ft.format(cd.getTime());
						//先判断是否有书面登记，再结合订餐、刷卡数据计算 
						fsql = "select a.breakfast,a.lunch,a.dinner from uf_hr_markfoodsub a,uf_hr_markfood b where a.requestid=b.requestid and a.objname='"+hid+"' and b.markdate='"+nday+"' and exists(select c.id from requestbase c where b.requestid=c.id and c.isdelete=0 and c.isfinished=1)";
						//System.out.println(fsql);
						flist = baseJdbc.executeSqlForList(fsql);
						String b = "";
						String l = "";
						String d = "";
						if(flist.size()>0){
							Map fm = (Map)flist.get(0);
							b = StringHelper.null2String(fm.get("breakfast"));//早餐是否登记 
							l = StringHelper.null2String(fm.get("lunch"));//午餐是否登记 
							d = StringHelper.null2String(fm.get("dinner"));//晚餐是否登记 
						}
						
						//早餐计算 
						if(b.equals("1")){//早餐有登记 
							fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb0' and a.rules='40285a90495b4eb0014975338fba5bba' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							flist = baseJdbc.executeSqlForList(fsql);
							if(flist.size()>0){
								m = (Map)flist.get(0);
								String mon2 = StringHelper.null2String(m.get("money"));
								bm = Double.valueOf(mon2).doubleValue();
							}
						}else{//早餐无登记					
							//1 判断是否有订餐  加盘锦厂早餐送餐
							boolean bredc= false;
							boolean bresc = false;
							boolean bresk = false;
							fsql = "select a.breakfast from uf_hr_unitfootsub a where (a.breakfast='40285a90495b4eb001496408814f5995' or a.breakfast='40285a90495b4eb001496408814f5996') and a.objname='"+hid+"' and a.thedate='"+nday+"' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							flist = baseJdbc.executeSqlForList(fsql);
							if(flist.size()>0){//有订餐
								//bredc = true;
								m = (Map)flist.get(0);
								String str2 = StringHelper.null2String(m.get("breakfast")); 
								if(str2.equals("40285a90495b4eb001496408814f5996")){//送餐
									bresc = true;
								}
								bredc = true; 
							}
							if(!bresc){ //非送餐
								//2 获取早餐刷卡有效时间段						
								fsql = "select a.begintime,a.endtime from uf_hr_foodrule a where exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) and a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb0' and rownum=1";
								flist = baseJdbc.executeSqlForList(fsql);
								if(flist.size()>0){
									m = (Map)flist.get(0);
									begintime = StringHelper.null2String(m.get("begintime"));
									endtime = StringHelper.null2String(m.get("endtime"));
								}else{//如果数据库中没有维护则默认一个值 
									begintime = "7:00:00";
									endtime = "9:00:00";
								}						
								//boolean bresk = false;
								//3 判断是否有刷卡
								if(comtype.equals("4028804d2083a7ed012083ebb988005b") || comtype.equals("40285a90488ba9d101488bbdeeb30008")){//常熟厂	或长沙厂
									fsql = "select a.id from acc_monitor_log a,userinfo b where a.pin=b. badgenumber and rtrim(ltrim(b.political))='"+objno+"' and convert(varchar(100),a.[time],8)>=convert(varchar(100),'"+begintime+"',8) and convert(varchar(100),a.[time],8)<=convert(varchar(100),'"+endtime+"',8)  and convert(varchar(100),a.[time],23)=convert(varchar(100),'"+nday+"',23)";	
								}
								if(comtype.equals("40285a90488ba9d101488bbd09100007")){ //盘锦厂
									fsql = "select a.userid from checkinout a,userinfo b where a.userid=b.userid and rtrim(ltrim(b.ssn))='"+objno+"' and convert(varchar(100),a.[checktime],8)>=convert(varchar(100),'"+begintime+"',8) and convert(varchar(100),a.[checktime],8)<=convert(varchar(100),'"+endtime+"',8)  and convert(varchar(100),a.[checktime],23)=convert(varchar(100),'"+nday+"',23)";	
								}
								flist = otherdataservices.getValues(fsql);
								if(flist.size()>0){//有刷卡
									bresk = true;
								}
							}
							fsql = "";
							if(bresc){//送餐
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb0' and a.rules='40285a90495b4eb0014975338fba5bbb' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!bresc && bredc && bresk){//有订餐有刷卡-->正常用餐 
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb0' and a.rules='40285a90495b4eb0014975338fba5bb7' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!bresc && !bredc && bresk){//无订餐有刷卡-->未订有用
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb0' and a.rules='40285a90495b4eb0014975338fba5bb8' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!bresc&& bredc && !bresk){//有订餐无刷卡-->订而未用
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb0' and a.rules='40285a90495b4eb0014975338fba5bb9' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else{
								fsql = "";
							}
							if(fsql.equals("")){//没订餐没刷卡
								bm = 0.0;
							}else{
								flist = baseJdbc.executeSqlForList(fsql);
								if(flist.size()>0){
									m = (Map)flist.get(0);
									String mon2 = StringHelper.null2String(m.get("money"));
									bm = Double.valueOf(mon2).doubleValue();
								}else bm = 0.0;
							}
						}//早餐 bm 计算结束 
						//午餐计算
						if(l.equals("1")){//午餐有登记 
							fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb1' and a.rules='40285a90495b4eb0014975338fba5bba' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							flist = baseJdbc.executeSqlForList(fsql);
							if(flist.size()>0){
								m = (Map)flist.get(0);
								String mon1 = StringHelper.null2String(m.get("money"));
								lm = Double.valueOf(mon1).doubleValue();
							}
						}else{//午餐无登记					
							//1 判断是否有订餐 
							boolean lunchdc = false;
							boolean lunchsc = false;
							boolean lunchsk = false;
							fsql = "select a.lunch from uf_hr_unitfootsub a where (a.lunch='40285a90495b4eb001496408814f5995' or a.lunch='40285a90495b4eb001496408814f5996') and a.objname='"+hid+"' and a.thedate='"+nday+"' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							flist = baseJdbc.executeSqlForList(fsql);
							if(flist.size()>0){//有订餐
								m = (Map)flist.get(0);
								String str2 = StringHelper.null2String(m.get("lunch")); 
								if(str2.equals("40285a90495b4eb001496408814f5996")){//送餐
									lunchsc = true;
								}
								lunchdc = true;
							}
							if(!lunchsc){ //非送餐
								//2 获取午餐刷卡有效时间段
								fsql = "select a.begintime,a.endtime from uf_hr_foodrule a where exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) and a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb1' and rownum=1";
								flist = baseJdbc.executeSqlForList(fsql);
								if(flist.size()>0){
									m = (Map)flist.get(0);
									begintime = StringHelper.null2String(m.get("begintime"));
									endtime = StringHelper.null2String(m.get("endtime"));
								}else{//如果数据库中没有维护则默认一个值 
									begintime = "11:00:00";
									endtime = "13:30:00";
								}
								//boolean lunchsk = false;
								//3 判断是否有刷卡
								if(comtype.equals("4028804d2083a7ed012083ebb988005b") || comtype.equals("40285a90488ba9d101488bbdeeb30008")){//常熟厂	或长沙厂
									fsql = "select a.id from acc_monitor_log a,userinfo b where a.pin=b. badgenumber and rtrim(ltrim(b.political))='"+objno+"' and convert(varchar(100),a.[time],8)>=convert(varchar(100),'"+begintime+"',8) and convert(varchar(100),a.[time],8)<=convert(varchar(100),'"+endtime+"',8)  and convert(varchar(100),a.[time],23)=convert(varchar(100),'"+nday+"',23)";	
								}
								if(comtype.equals("40285a90488ba9d101488bbd09100007")){ //盘锦厂
									fsql = "select a.userid from checkinout a,userinfo b where a.userid=b.userid and rtrim(ltrim(b.ssn))='"+objno+"' and convert(varchar(100),a.[checktime],8)>=convert(varchar(100),'"+begintime+"',8) and convert(varchar(100),a.[checktime],8)<=convert(varchar(100),'"+endtime+"',8)  and convert(varchar(100),a.[checktime],23)=convert(varchar(100),'"+nday+"',23)";
								}
												
								flist = otherdataservices.getValues(fsql);
								if(flist.size()>0){//有刷卡
									lunchsk = true;
								}
							}
							fsql = "";
							if(lunchsc){//送餐
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb1' and a.rules='40285a90495b4eb0014975338fba5bbb' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!lunchsc && lunchdc && lunchsk){//有订有刷卡
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb1' and a.rules='40285a90495b4eb0014975338fba5bb7' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!lunchsc && !lunchdc && lunchsk){//无订有刷卡
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb1' and a.rules='40285a90495b4eb0014975338fba5bb8' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!lunchsc && lunchdc && !lunchsk){//有订无刷卡
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb1' and a.rules='40285a90495b4eb0014975338fba5bb9' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else{
								fsql = "";
							}
							if(fsql.equals("")){//没订餐没刷卡
								lm = 0.0;
							}else{
								flist = baseJdbc.executeSqlForList(fsql);
								if(flist.size()>0){
									m = (Map)flist.get(0);
									String mon1 = StringHelper.null2String(m.get("money"));
									lm = Double.valueOf(mon1).doubleValue();
								}else lm = 0.0;
							}
						}//午餐 lm 计算结束
						//晚餐计算
						if(d.equals("1")){//晚餐有登记 
							fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb2' and a.rules='40285a90495b4eb0014975338fba5bba' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							flist = baseJdbc.executeSqlForList(fsql);
							if(flist.size()>0){
								m = (Map)flist.get(0);
								String mon = StringHelper.null2String(m.get("money"));
								dm = Double.valueOf(mon).doubleValue();
							}
						}else{//晚餐无登记					
							//1 判断是否有订餐 
							boolean dinnerdc = false;
							boolean dinnersc = false;
							boolean dinnersk = false;
							fsql = "select a.dinner from uf_hr_unitfootsub a where (a.dinner='40285a90495b4eb001496408814f5995' or a.dinner='40285a90495b4eb001496408814f5996') and a.objname='"+hid+"' and a.thedate='"+nday+"' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							flist = baseJdbc.executeSqlForList(fsql);
							if(flist.size()>0){//有订餐
								m = (Map)flist.get(0);
								String str1 = StringHelper.null2String(m.get("dinner"));
								if(str1.equals("40285a90495b4eb001496408814f5996")){//送餐
									dinnersc = true;
								}
								dinnerdc = true;
							}
							if(!dinnersc){ //非送餐
								//2 获取晚餐刷卡有效时间段
								fsql = "select a.begintime,a.endtime from uf_hr_foodrule a where exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) and a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb2' and rownum=1";
								flist = baseJdbc.executeSqlForList(fsql);
								if(flist.size()>0){
									m = (Map)flist.get(0);
									begintime = StringHelper.null2String(m.get("begintime"));
									endtime = StringHelper.null2String(m.get("endtime"));
								}else{//如果数据库中没有维护则默认一个值 
									begintime = "16:30:00";
									endtime = "19:00:00";
								}
								//boolean dinnersk = false;
								//3 判断是否有刷卡
								if(comtype.equals("4028804d2083a7ed012083ebb988005b") || comtype.equals("40285a90488ba9d101488bbdeeb30008")){//常熟厂	或长沙厂
									fsql = "select a.id from acc_monitor_log a,userinfo b where a.pin=b. badgenumber and rtrim(ltrim(b.political))='"+objno+"' and convert(varchar(100),a.[time],8)>=convert(varchar(100),'"+begintime+"',8) and convert(varchar(100),a.[time],8)<=convert(varchar(100),'"+endtime+"',8)  and convert(varchar(100),a.[time],23)=convert(varchar(100),'"+nday+"',23)";		
								}
								if(comtype.equals("40285a90488ba9d101488bbd09100007")){ //盘锦厂
									fsql = "select a.userid from checkinout a,userinfo b where a.userid=b.userid and rtrim(ltrim(b.ssn))='"+objno+"' and convert(varchar(100),a.[checktime],8)>=convert(varchar(100),'"+begintime+"',8) and convert(varchar(100),a.[checktime],8)<=convert(varchar(100),'"+endtime+"',8)  and convert(varchar(100),a.[checktime],23)=convert(varchar(100),'"+nday+"',23)";	
								}
								flist = otherdataservices.getValues(fsql);
								if(flist.size()>0){//有刷卡
									dinnersk = true;
								}
							}
							fsql = "";
							if(dinnersc){//送餐
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb2' and a.rules='40285a90495b4eb0014975338fba5bbb' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!dinnersc && dinnerdc && dinnersk){//有订有刷卡
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb2' and a.rules='40285a90495b4eb0014975338fba5bb7' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!dinnersc && !dinnerdc && dinnersk){//无订有刷卡
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb2' and a.rules='40285a90495b4eb0014975338fba5bb8' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else if(!dinnersc && dinnerdc && !dinnersk){//有订无刷卡
								fsql = "select to_char(a.money) money from uf_hr_foodrule a where a.comtype='"+comtype+"' and a.times='40285a90495b4eb0014975329a4e5bb2' and a.rules='40285a90495b4eb0014975338fba5bb9' and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
							}else{
								fsql = "";
							}
							if(fsql.equals("")){//没订餐没刷卡
								dm = 0.0;
							}else{
								flist = baseJdbc.executeSqlForList(fsql);
								if(flist.size()>0){
									m = (Map)flist.get(0);
									String mon = StringHelper.null2String(m.get("money"));
									dm = Double.valueOf(mon).doubleValue();
								}else dm = 0.0;
							}
						}//晚餐 dm 计算结束 
						total = total + bm + lm + dm;
					}				
					//把数据插入数据库中
					if(total>0.0){
						String usql = "insert into uf_hr_monthtotalsub (id,requestid,objname,jobno,sapid,objdept,objcom,total) values (sys_guid(),'"+requestid+"','"+hid+"','"+objno+"','"+sapid+"','"+oid+"','"+comid+"',to_number('"+String.format("%.2f",total)+"'))";
						baseJdbc.update(usql);
					}
				}
			}	
			
            System.out.println("员工每月就餐扣款计算结束 requestid:"+requestid);			
		}
	}	
	return ;
%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
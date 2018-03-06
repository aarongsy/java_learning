<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>


<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>

<%

    EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 	
	

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	String userId = currentuser.getId();
	String comtype = ds.getValue("select extrefobjfield5 from humres where id='"+userId+"'");
	
	String action=StringHelper.null2String(request.getParameter("action"));
	//String yearmon=StringHelper.null2String(request.getParameter("yearmon"));

	//System.out.println("pureshare  action="+action+" yearmon="+yearmon);	
	
	//test：2014-12 //当前年月
	String sql = "select distinct jcdedept from uf_hr_pundept a,formbase b where a.requestid=b.id and b.isdelete=0 and a.comtype='"+comtype+"'";	
		
	String err="";	
    String passdept="";
	String faildept="";
	String failreason = ""; //1:重复  2:公司代码为空，无法生成编号
 	 
	JSONObject jo = new JSONObject();
	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start JXDE......list.size="+list.size());
		
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String jcdedept = StringHelper.null2String(map.get("jcdedept"));//奖惩定额归属部门
			String jcdedename = ds.getValue("select objname from orgunit where id='"+jcdedept+"'"); //部门名称
			SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM");
			String yearmon = ft.format(new Date());//当前年月
			
			String sql2 = "select a.dept,a.yearmon,a.requestid from uf_hr_punrewquota a,formbase b where a.requestid=b.id and b.isdelete=0 and a.dept= '"+ jcdedept+"' and a.yearmon= '"+ yearmon +"'";
			List ls = baseJdbc.executeSqlForList(sql2);
			if(ls.size()>0){
				System.out.println("database had jcdedept="+jcdedept+" yearmon="+yearmon +" JCDE Table, can't created!");
				err = "1";
				faildept = faildept+";"+jcdedename;
				failreason = failreason+";1";
				
			}else{
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String Dtime = format.format(new Date());
				String depttype=ds.getValue("select typeid from orgunit where id='"+jcdedept+"'");
				String company = ds.getValue("select nr.id from (select id,objname from (SELECT CONNECT_by_root orgt.objname,orgt.* FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID) orgt START WITH orgt.ID='"+jcdedept+"' CONNECT BY PRIOR orgt.pid=orgt.id) where id<>'402881e70ad1d990010ad1e5ec930008' order by rownum desc) nr where rownum=1");
				//String comtype = ds.getValue("select extrefobjfield5 from humres where id='"+userId+"'");
				String iniflag = "";
				String lastno = "";
				int beginnum = 0;
				int lastbeginnum = 0;
				int diffnum = 0;
				float lastquota=0;
				int totalquota =0;
				float usedquota = 0;
				int leftquota =0;
				String comcode = ds.getValue("select objno from orgunit where id='"+company+"'");

				//String benum = ds.getValue("select sum(a.curnum) curnum from stationinfo a where exists (select id from (SELECT id FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID and a.isdelete=0 and a.unitstatus='402880d31a04dfba011a04e4db5f0003') orgu START WITH orgu.id='"+jcdedept+"' CONNECT BY PRIOR ORGU.id=orgu.pid) b where a.orgid=b.id) and a.STATIONSTATUS='402880d319eb81720119eba4e1e70004' and a.isdelete=0" );
				String benum = ds.getValue("select count(id) curnum from humres where HRSTATUS ='4028804c16acfbc00116ccba13802935' and (extselectitemfield14 is null or extselectitemfield14!='40288098276fc2120127704884290210')  and MAINSTATION in (select a.id from stationinfo a where exists (select id from (SELECT id FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID and a.isdelete=0 and a.unitstatus='402880d31a04dfba011a04e4db5f0003' ) orgu START WITH orgu.id='"+jcdedept+"' CONNECT BY PRIOR ORGU.id=orgu.pid) b where a.orgid=b.id) and a.STATIONSTATUS='402880d319eb81720119eba4e1e70004' and a.isdelete=0 )");
				beginnum = Integer.parseInt(benum);
				
				String quoYear = yearmon.substring(0,4);
				int mm = Integer.parseInt(yearmon.substring(5));
				if(mm==1){
					iniflag = "40288098276fc2120127704884290210"; //是
					lastno = "";
					lastbeginnum = beginnum;
					lastquota = 0;
					diffnum = beginnum-lastbeginnum; //异动人数			
					//totalquota = (int)((float)(lastquota + beginnum*0.3*(12-mm+1)/2)); 	//2015规则
					totalquota = (int)((float)(lastquota + beginnum*2.5)); 		//2016规则
				}else{
					//取得当前部门、当前月份、厂区的定额表(额度表为提报年份存在的最后一个月份的额度)
					sql2= "select t.leftquota,t.no,t.totalquota,t.usedquota,t.requestid,t.id,t.beginnum from ( select a.*,rownum from uf_hr_punrewquota a,formbase b where a.requestid=b.id and b.isdelete='0' and substr(a.yearmon,0,4)='"+quoYear+"' and a.dept='"+jcdedept+"' order by a.yearmon desc) t where rownum =1";
					List ls3 = baseJdbc.executeSqlForList(sql2);
					if(ls3.size()>0){
						Map m = (Map)ls3.get(0);
						iniflag = "40288098276fc2120127704884290211"; //否
						lastno = StringHelper.null2String(m.get("requestid"));//上期奖惩定额编号
						lastbeginnum = Integer.parseInt(StringHelper.null2String(m.get("beginnum"))); //上期期初人数
						lastquota = Float.parseFloat(StringHelper.null2String(m.get("leftquota"))); //上期剩余
						diffnum = beginnum-lastbeginnum; //异动人数			
						//totalquota = (int)((float)(lastquota + diffnum*0.3*(12-mm+1)/2));  	//2015规则
						totalquota = (int)((float)(lastquota + diffnum*2.5));  	//2016规则
					}else{
						iniflag = "40288098276fc2120127704884290210"; //是
						lastno = "";
						lastbeginnum = beginnum;
						lastquota = 0;
						diffnum = beginnum-lastbeginnum; //异动人数			
						//totalquota = (int)((float)(beginnum*0.3*(12-mm+1)/2)); 	//2015规则
						totalquota = (int)((float)(beginnum*2.5)); 		//2016规则
					}				
				}
				usedquota = 0;
				leftquota = (int)totalquota;			
				
				String belongdept=ds.getValue("select pid from orgunitlink where isdelete='0' and oid ='"+jcdedept+"'");
				String bedepttype=ds.getValue("select typeid from orgunit where id='"+belongdept+"'");
				//String currentno = ds.getValue("SELECT CURRENTNO from SEQUENCE where ID ='2c91a0302bbcd476012c1127e22c3fbe'");
				if(comcode.equals("") ||  jcdedename.equals("") || yearmon.equals("")){
					err = "2";
					faildept = faildept+";"+jcdedename;
					failreason = failreason+";2";
								
				}else{
					String no=comcode+"-"+jcdedename+"-"+yearmon;
					StringBuffer buffer = new StringBuffer(1024);
					//String newrequestid = IDGernerator.getUnquieID();
					buffer.append("insert into uf_hr_punrewquota").append("(id,requestid,no,reqman,reqdate,yearmon,dept,deptid,depttype,company,comtype,iniflag,lastno,beginnum,lastbeginnum,diffnum,lastquota,totalquota,usedquota,leftquota,belongdept,belongdeptid,bedepttype,comcode) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");
					
					buffer.append("'").append(no).append("',");//奖惩定额编号
					buffer.append("'").append(userId).append("',");//填单人
					buffer.append("'").append(Dtime).append("',");//填单日期
					buffer.append("'").append(yearmon).append("',");//年月
					buffer.append("'").append(jcdedept).append("',");//部门
					buffer.append("'").append("").append("',");//部门编号
					buffer.append("'").append(depttype).append("',");//部门类型
					
					buffer.append("'").append(company).append("',");//所属公司
					buffer.append("'").append(comtype).append("',");//厂区别
					buffer.append("'").append(iniflag).append("',");//初次使用标识
					buffer.append("'").append(lastno).append("',");//上期编号
					buffer.append("'").append(beginnum).append("',");//月初在编人数
					buffer.append("'").append(lastbeginnum).append("',");//上期月初在编人数
					buffer.append("'").append(diffnum).append("',");//异动人数
					buffer.append("'").append(lastquota).append("',");//上期剩余额度
					buffer.append("'").append(totalquota).append("',");//总额度
					buffer.append("'").append(usedquota).append("',");//使用额度
					buffer.append("'").append(leftquota).append("',");//剩余额度
					buffer.append("'").append(belongdept).append("',");//上级部门
					buffer.append("'").append("").append("',");//上级部门编号
					buffer.append("'").append(bedepttype).append("',");//上级部门类型
					buffer.append("'").append(comcode).append("')");//公司代码
					
					FormBase formBase = new FormBase();
					String categoryid = "40285a904931f62b01493bec992f532c";
					//创建formbase
					formBase.setCreatedate(DateHelper.getCurrentDate());
					formBase.setCreatetime(DateHelper.getCurrentTime());
					formBase.setCreator(StringHelper.null2String(userId));
					formBase.setCategoryid(categoryid);
					formBase.setIsdelete(0);
					FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
					formBaseService.createFormBase(formBase);
					String insertSql = buffer.toString();
					insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
					baseJdbc.update(insertSql);
					PermissionTool permissionTool = new PermissionTool();
					permissionTool.addPermission(categoryid,formBase.getId(), "uf_hr_punrewquota");	
					passdept = passdept +";"+jcdedename;
				}
			}
			System.out.println("auto JXDE end..i="+i +"  jcdedept="+jcdedept +" err="+err +" faildept="+faildept+" failreason="+failreason);
		}
	}else{
		err="0";
	}

	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("passdept",passdept);
		jo.put("faildept",faildept);	
		jo.put("failreason",failreason);	
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("passdept",passdept);
		jo.put("faildept",faildept);	
		jo.put("failreason",failreason);	
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>

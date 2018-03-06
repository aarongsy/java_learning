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
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@page import="com.eweaver.mobile.layout.convert.BrowserConvert"%>

<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.security.util.PermissionTool"%>
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%@ page import="org.json.simple.JSONArray" %>

<%@ include file="/app/base/init.jsp"%>
<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String issave=StringHelper.null2String(request.getParameter("issave"));
String comtype=StringHelper.null2String(request.getParameter("comtype"));
String yearmon=StringHelper.null2String(request.getParameter("yearmon"));
String liquid=StringHelper.null2String(request.getParameter("liquid"));
BrowserConvert browserConvert = new BrowserConvert();
browserConvert.setTypeid("40285a904a2e9985014a3899438a4824");
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
int days =  Integer.parseInt(ds.getValue("select to_char(last_day(to_date('"+yearmon+"-01','yyyy-mm-dd')),'dd') from dual") ); //得到最后一天的日期
//int itemsize =Integer.parseInt(ds.getValue("select count(ID) from uf_yz_liqmonreadsub where requestid='"+requestid+"'")); //得到累计量项目个数

	String[] dayarr = new String[]{"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};

	String sql = "";
	String datasql = "";	
	String upsql = "";
	String opflag ="";

	for(int i=0;i<days;i++){
		//String strdate = dayarr[i];
		String readdate = yearmon + "-"+ dayarr[i]; 
		sql = "select a.requestid,a.liquid,a.mon,a.reqman,a.reqdate,a.reqdept,a.comtype,b.liqitemid,b.liqitem,b.unit,b.day"+dayarr[i]+ " reading,a.mon||'-"+dayarr[i]+"' readdate from uf_yz_liqmonread a,uf_yz_liqmonreadsub b,formbase c where a.requestid=b.requestid and a.requestid=c.id and c.isdelete=0 and b.requestid='"+requestid+"' and b.DAY"+dayarr[i]+" is not null";
		System.out.println("i="+i+"  sql="+sql);
		List datalist = baseJdbc.executeSqlForList(sql);

		if(datalist.size()>0){			
			sql = "select a.requestid,a.liquid,a.mon,a.reqman,a.reqdate,a.reqdept,a.comtype,b.liqitemid,b.liqitem,b.unit,nvl(b.day"+dayarr[i]+ ",'') reading,a.mon||'-"+dayarr[i]+"' readdate from uf_yz_liqmonread a,uf_yz_liqmonreadsub b,formbase c where a.requestid=b.requestid and a.requestid=c.id and c.isdelete=0 and b.requestid='"+requestid+"' order by b.liqitemid asc ";
			List datalist1 = baseJdbc.executeSqlForList(sql);			
			String dayreqid =""; //每日读数分类ID
			String reqidsql = "select r.requestid from uf_yz_liqreading r,formbase f where r.requestid=f.id and f.isdelete=0 and  r.comtype='"+comtype+"' and r.liquid='"+liquid+"' and r.readdate='"+readdate+"'";
			System.out.println("i="+i+"  reqidsql="+reqidsql);
			List ls = baseJdbc.executeSqlForList(reqidsql);
			if(ls.size()==0){
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String Dtime = format.format(new Date());
				//不存在每日累计量主表,创建分类
				String reqman = userid;
				String reqdate = Dtime;
				String reqdept = ds.getValue("select orgid from humres where ID ='"+userid+"'");
				
				
				StringBuffer buffer = new StringBuffer(512);
				buffer.append("insert into uf_yz_liqreading").append("(id,requestid,reqman,reqdate,reqdept,comtype,liquid,readdate,stateflag,conflag) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");
				buffer.append("'").append(reqman).append("',"); //填单人
				buffer.append("'").append(reqdate).append("',"); //填单日期
				buffer.append("'").append(reqdept).append("',"); //填单部门
				buffer.append("'").append(comtype).append("',"); //厂区别
				buffer.append("'").append(liquid).append("',"); //公用流体
				buffer.append("'").append(readdate).append("',"); //读数日期
				buffer.append("'").append("40285a9049d58e9e0149ea20d3cf6c78").append("',"); //待审核
				buffer.append("'").append("40288098276fc2120127704884290211").append("')"); //待确认
				FormBase formBase = new FormBase();
				String categoryid = "40285a9049d58e9e0149ea2b02e16e66";
				//创建formbase
				formBase.setCreatedate(DateHelper.getCurrentDate());
				formBase.setCreatetime(DateHelper.getCurrentTime());
				formBase.setCreator(StringHelper.null2String(userid));
				formBase.setCategoryid(categoryid);
				formBase.setIsdelete(0);
				FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
				formBaseService.createFormBase(formBase);
				String insertSql = buffer.toString();
				insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
				baseJdbc.update(insertSql);
				PermissionTool permissionTool = new PermissionTool();
				permissionTool.addPermission(categoryid,formBase.getId(), "uf_yz_liqreading");	
				dayreqid = formBase.getId();				
			}else{
				//存在每日累计量主表
				Map mm = (Map)ls.get(0); 
				dayreqid = StringHelper.null2String(mm.get("requestid"));
			}	
			
			baseJdbc.update("delete uf_yz_liqreadingsub where requestid='"+dayreqid+"'");
			
			for(int j=0;j<datalist1.size();j++){
			
				Map dmap = (Map)datalist1.get(j);
				//String ID= "(select sys_guid() from dual)";
				String REQUESTID =dayreqid;
				String NO=String.valueOf(j+1);
				String ROWINDEX = String.format("%03d",(j+1));
				String LIQITEMID = StringHelper.null2String(dmap.get("liqitemid"));
				String LIQITEM = StringHelper.null2String(dmap.get("liqitem"));
				String UNIT = StringHelper.null2String(dmap.get("unit"));
				String READING = StringHelper.null2String(dmap.get("reading"));
				
				upsql = "insert into uf_yz_liqreadingsub (ID, REQUESTID, ROWINDEX, NO, LIQITEMID, LIQITEM, UNIT, READING) values ((select sys_guid() from dual),'"+REQUESTID+"','"+ROWINDEX+"','"+NO+"','"+LIQITEMID+"','"+LIQITEM+"','"+UNIT+"','"+READING+"')";		
				/*
				String detailsql = "select * from uf_yz_liqreadingsub where requestid='"+dayreqid+"' and LIQITEM='"+LIQITEM+"'";
				System.out.println("j="+j+"  detailsql="+detailsql);
				List detls = baseJdbc.executeSqlForList(detailsql);
				if(detls.size()==0){
					//不存在每日累计量明细表
					opflag = "insert";
					upsql = "insert into uf_yz_liqreadingsub (ID, REQUESTID, ROWINDEX, NO, LIQITEMID, LIQITEM, UNIT, READING) values ((select sys_guid() from dual),'"+REQUESTID+"','"+ROWINDEX+"','"+NO+"','"+LIQITEMID+"','"+LIQITEM+"','"+UNIT+"','"+READING+"')";					
				}else{
					//存在每日累计量明细表
					opflag = "update";
					upsql = "update uf_yz_liqreadingsub set READING='"+READING+"' where REQUESTID='"+REQUESTID+"' and LIQITEM='"+LIQITEM+"'"; 
				}	
				*/
				System.out.println("i="+i+" j="+j+" upsql="+upsql);	
				baseJdbc.update(upsql);
			}			
		}		
	}
	JSONObject jo = new JSONObject();
	jo.put("msg","true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();

%>

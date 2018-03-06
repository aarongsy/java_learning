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
<%@ page import="com.eweaver.app.dccm.dmhr.leave.DMHR_LeftQuotaDetailAction"%>
<%@ page import="com.eweaver.app.dccm.dmhr.leave.DMHR_Class_ZHR_IT2006_DETAIL_GET_MY"%>

<%@ include file="/base/init.jsp"%>

<%

	String action=StringHelper.null2String(request.getParameter("action"));

	
	response.setContentType("application/json; charset=utf-8");
	JSONObject jsonObject = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("getAllLeftQuota")){	//getAllLeftQuota
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String sdate=StringHelper.null2String(request.getParameter("sdate"));
		String quotadate=StringHelper.null2String(request.getParameter("quotadate"));
		String quotaid=StringHelper.null2String(request.getParameter("quotaid"));
		String force=StringHelper.null2String(request.getParameter("force"));
		//Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));
		Boolean forceflag = true;
		if ( "true".equals(force) ) {
			forceflag = true;
		} else {
			forceflag = false;
		}		
	
		DMHR_LeftQuotaDetailAction app = new DMHR_LeftQuotaDetailAction();
		try {		
			String flag = app.getAllLeftQuota( "40285a8d56d542730156e9932c4d32e4", sdate, quotadate, quotaid, forceflag ,requestid );
			//String flag =  "";
			jsonObject.put("info",flag);	
			jsonObject.put("msg","true");	
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());	
			jsonObject.put("msg","false");				
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}

	
	
	/* 测试成功的 
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	  String comtype = StringHelper.null2String(request.getParameter("comtype"));
	  String sdate = StringHelper.null2String(request.getParameter("sdate"));
	  String quotadate = StringHelper.null2String(request.getParameter("quotadate"));
	  String quotaid = StringHelper.null2String(request.getParameter("quotaid"));
	  String force = StringHelper.null2String(request.getParameter("force"));
	  Boolean forceflag = true;
	  if ( "true".equals(force) ) {
		forceflag = true;
	  } else {
		forceflag = false;
	  }
	  String requestid = StringHelper.null2String(request.getParameter("requestid"));
	 // String flag = "";	 
	  JSONObject jsonObject = new JSONObject();
	  //EweaverUser eweaveruser = BaseContext.getRemoteUser();
     // Humres currentuser = eweaveruser.getHumres();
     // String userid = currentuser.getId();      
      String today = ds.getSQLValue("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual");
      
      String sql = "select a.objno,a.exttextfield15 empsapid,a.objname,exttextfield26 nickname,i.dept deptscode from humres a"
    		  +" left join uf_dmhr_applevel i on a.id=i.jobno and exists(select 1 from formbase where id=i.requestid and isdelete=0) "
    		  +" where a.isdelete = 0 and a.hrstatus = '4028804c16acfbc00116ccba13802935'"
    		  + " and (a.extselectitemfield14 is null or a.extselectitemfield14!='40288098276fc2120127704884290210') and a.objname <> 'sysadmin'";
	  if ( !"".equals(comtype) ) {
		  sql = sql +" and a.extrefobjfield5='"+comtype+"'";
	  }
	  
	  List list = baseJdbcDao.executeSqlForList(sql);
	  
	  if ( list.size() > 0 ) {		  
		  try {
			  for ( int i=0;i<list.size();i++  ) {
				  Map map = (Map)list.get(i);
				  String empsapid = StringHelper.null2String(map.get("empsapid"));
				  String jobno = StringHelper.null2String(map.get("objno"));
				  String jobname = StringHelper.null2String(map.get("objname"));
				  String nickname = StringHelper.null2String(map.get("nickname"));
				  String deptscode = StringHelper.null2String(map.get("deptscode"));
				 
				  DMHR_Class_ZHR_IT2006_DETAIL_GET_MY app = new DMHR_Class_ZHR_IT2006_DETAIL_GET_MY();
				  String flag = app.GetLeaveQuotaDetail(empsapid,sdate,quotadate, quotaid, forceflag,requestid);
				  jsonObject.put(jobno, flag);
				              
			  }	
		     System.out.println(jsonObject.toString());
		  } catch (Exception e) {
			 // TODO Auto-generated catch block
			 e.printStackTrace();
			 System.out.println("getAllLeftQuotaAction.jsp error！");
		  }
	  }	
	*/
	
%>
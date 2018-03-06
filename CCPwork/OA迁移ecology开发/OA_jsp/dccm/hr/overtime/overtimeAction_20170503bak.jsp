<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="com.eweaver.app.dccm.dmhr.overtime.DMHR_OverTimeAction"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("toSAP")){	//加班申请抛SAP
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));	
		String sql ="select a.flowno,a.empsapid,a.ottypecode,a.paycode,a.reasoncode,a.acthours,a.actstime,a.actetime,to_char(to_date(a.actsdate || ' ' || a.actstime,'yyyy-MM-dd HH24:MI:SS'),'yyyyMMdd HH24MI') || '00' sdatetime,to_char(to_date(a.actedate || ' ' || a.actetime,'yyyy-MM-dd HH24:MI:SS'),'yyyyMMdd HH24MI') || '00' edatetime,a.sbreakdate,a.sbreaktime,a.ebreakdate,a.ebreaktime,a.msgty2,a.message2,to_char(sysdate,'yyyyMMdd') today,(select otreason from uf_dmhr_otreason where requestid=a.reason) reasontxt,a.transallow,a.msgty,a.message from uf_dmhr_otapp a where a.requestid='"+requestid+"'";
		List list = baseJdbcDao.executeSqlForList(sql);
		if ( list.size()>0 ) {
			Map map = (Map)list.get(0);
			String sbreakdate = StringHelper.null2String(map.get("sbreakdate"));
			String sbreaktime = StringHelper.null2String(map.get("sbreaktime"));
			String ebreakdate = StringHelper.null2String(map.get("ebreakdate"));
			String ebreaktime = StringHelper.null2String(map.get("ebreaktime"));
		
			DMHR_OverTimeAction app = new DMHR_OverTimeAction();
			String flag = "";
			String flag2 = "";
			if ( "".equals(sbreakdate) ||  "".equals(sbreaktime)  ||  "".equals(ebreakdate) || "".equals(ebreaktime) ) {
				try {
					flag = app.OTAppToSAP(requestid,force);
					if ( "pass".equals(flag) ) {
						jsonObject.put("info",flag);	
						jsonObject.put("msg","true");		
					} else{
						jsonObject.put("info",flag);	
						jsonObject.put("msg","false");	
					}			
				} catch (Exception e) {
					e.printStackTrace();
					jsonObject.put("info",e.getMessage());	
					jsonObject.put("msg","false");				
				}
			} else {
				try {				
					flag = app.OTAppToSAP1( requestid, false , sbreakdate , sbreaktime );
					flag2 = app.OTAppToSAP2( requestid, false , ebreakdate , ebreaktime );
					if ( "pass".equals(flag) &&  "pass".equals(flag2)) {
						jsonObject.put("info",flag +";"+ flag2);	
						jsonObject.put("msg","true");		
					} else {
						jsonObject.put("info",flag +";"+ flag2);
						jsonObject.put("msg","false");	
					}	
					
				} catch (Exception e) {
					e.printStackTrace();
					jsonObject.put("info",e.getMessage());	
					jsonObject.put("msg","false");	
				}
			}
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
			
	}
	
	if (action.equals("toSAP1")){	//加班申请抛SAP sdate--sbreak
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String sbreakdate = StringHelper.null2String(request.getParameter("sbreakdate"));
		String sbreaktime = StringHelper.null2String(request.getParameter("sbreaktime"));
		Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));	
		
		DMHR_OverTimeAction app = new DMHR_OverTimeAction();
		String flag = "";
		String flag2 = "";

		try {				
			flag = app.OTAppToSAP1( requestid, force , sbreakdate , sbreaktime );
			if ( "pass".equals(flag) ) {
				jsonObject.put("info",flag);	
				jsonObject.put("msg","true");		
			} else {
				jsonObject.put("info",flag);
				jsonObject.put("msg","false");	
			}	
			
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());	
			jsonObject.put("msg","false");	
		}

		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
	
	if (action.equals("toSAP2")){	//加班申请抛SAP ebreak--edate
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String ebreakdate = StringHelper.null2String(request.getParameter("ebreakdate"));
		String ebreaktime = StringHelper.null2String(request.getParameter("ebreaktime")); 
		Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));	
		
		DMHR_OverTimeAction app = new DMHR_OverTimeAction();
		String flag = "";
		String flag2 = "";

		try {				
			flag = app.OTAppToSAP2( requestid, force , ebreakdate , ebreaktime );
			if ( "pass".equals(flag2) ) {
				jsonObject.put("info",flag2);	
				jsonObject.put("msg","true");		
			} else {
				jsonObject.put("info",flag2);
				jsonObject.put("msg","false");	
			}	
			
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());	
			jsonObject.put("msg","false");	
		}

		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
	
	if (action.equals("toSAP1")){	//加班申请抛SAP1 sdate-- sbreak
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String sbreakdate = StringHelper.null2String(request.getParameter("sbreakdate"));
		String sbreaktime = StringHelper.null2String(request.getParameter("sbreaktime")); 		
		Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));		
		DMHR_OverTimeAction app = new DMHR_OverTimeAction();
		String flag = "";
		try {
			flag = app.OTAppToSAP1(requestid,force , sbreakdate , sbreaktime);
			if ( "pass".equals(flag) ) {
				jsonObject.put("info",flag);	
				jsonObject.put("msg","true");		
			} else{
				jsonObject.put("info",flag);	
				jsonObject.put("msg","false");	
			}			
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());	
			jsonObject.put("msg","false");				
		}		
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
	
	if (action.equals("getOTAllowance")){	//加班申请获取OT Allowance
		JSONObject jsonObject = new JSONObject();		
		String requestid = StringHelper.null2String(request.getParameter("requestid"));
		Boolean preflag = new Boolean(StringHelper.null2String(request.getParameter("preflag")));		//true 用预计时间计算	
		String sdate = StringHelper.null2String(request.getParameter("sdate"));
		DMHR_OverTimeAction app = new DMHR_OverTimeAction();
		String flag = "";
		try {
			flag = app.OTAllowrance(requestid,preflag,sdate);
			if ( "pass".equals(flag) ) {
				jsonObject.put("info",flag);	
				jsonObject.put("msg","true");		
			} else{
				jsonObject.put("info",flag);	
				jsonObject.put("msg","false");	
			}			
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());	
			jsonObject.put("msg","false");				
		}		
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
	
	if (action.equals("getCardTime")){	//取刷卡时间	      
		JSONObject jsonObject = new JSONObject();		
		String empsapid=StringHelper.null2String(request.getParameter("empsapid"));		
		String sdate=StringHelper.null2String(request.getParameter("sdate"));	
		String stime=StringHelper.null2String(request.getParameter("stime"));
		String stype=StringHelper.null2String(request.getParameter("type"));
		if ( !"".equals(empsapid) && !"".equals(sdate) && !"".equals(stime) ) {
			DMHR_OverTimeAction app = new DMHR_OverTimeAction();
			String flag = "";
			try {
				flag = app.GetCardTime(empsapid,sdate,stime,stype);
				if ( flag.indexOf("error") >0 ) {	//返回错误
					String[] a = flag.split("@@");
					jsonObject.put("info",a[1]);	
					jsonObject.put("msg","false");
				}else if ( flag.indexOf("!!!") >0 ) {	//返回多行，先不处理
					//String[] arr = flag.split("!!!");
					jsonObject.put("info",flag);	
					jsonObject.put("msg","true");	
				}else{	//返回单行
					//String[] a = arr[0].split("@@");
					jsonObject.put("info",flag);	
					jsonObject.put("msg","true");
				}				
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("info",e.getMessage());	
				jsonObject.put("msg","false");				
			}		
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();	
	}		
	
%>
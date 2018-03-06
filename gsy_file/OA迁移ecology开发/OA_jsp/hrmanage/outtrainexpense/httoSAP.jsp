<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	//	String  num= StringHelper.null2String(request.getParameter("num"));//次数


		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select a.requestid,a.sapid,a.endrenew,(select case objname when '固定期限合同' then 'Z1'  when '无固定期限合同' then 'Z2' when '实习协议' then 'Z4' when '劳务协议' then 'Z5' else 'Z3' end from selectitem where id=a.contype) as contype,a.startrenew,a.reason from uf_hr_contract a left join requestbase b on a.requestid=b.id where 0=b.isdelete and 1=b.isfinished and objname in(select id from humres where instr('C2008,C2014,C2017,C2018,C2947,C2949,C2951,C2954,C2955,C2956,C2958,C2959,C2960,C2962,C2970,C2971,C2972,C2973,C2975,C2979,C2983,C2984,C2985,C2986,C2989,C2993,C2997,C2998,C3000,C3003,C3005,C3007,C3009,C3011,C3015,C3019,C3020,C3023,C3027,C3031,C3037,C3040,C3044,C3052,C3055,C3056,C3063,C3064,C3073,C3077,C3078,C3081,C3094,C3097,C3098,C3099,C3101,C3102,C3106,C3110,C3111,C3115,C3860,JS1009,S1205,S1317,S1319,S1323,S1324,U1056',objno)>0)";
		//C2007
//C2008,C2014,C2017,C2018,C2947,C2949,C2951,C2954,C2955,C2956,C2958,C2959,C2960,C2962,C2970,C2971,C2972,C2973,C2975,C2979,C2983,C2984,C2985,C2986,C2989,C2993,C2997,C2998,C3000,C3003,C3005,C3007,C3009,C3011,C3015,C3019,C3020,C3023,C3027,C3031,C3037,C3040,C3044,C3052,C3055,C3056,C3063,C3064,C3073,C3077,C3078,C3081,C3094,C3097,C3098,C3099,C3101,C3102,C3106,C3110,C3111,C3115,C3860,JS1009,S1205,S1317,S1319,S1323,S1324,U1056

		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		String sapid="";
		String endrenew="";
		String contype="";
		String startrenew="";
		String reason="";
		String getsql = "";
		String requestid="";
		List getlist;
		Map getmap;
		//String sapid = "";
		//String Money="";
		if(list.size()>0){
			for(int i=0;i<list.size();i++)
			{
			 map = (Map)list.get(i);
			 requestid=StringHelper.null2String(map.get("requestid"));
			 sapid = StringHelper.null2String(map.get("sapid"));
			 endrenew = StringHelper.null2String(map.get("endrenew"));
			 contype = StringHelper.null2String(map.get("contype"));
			 startrenew = StringHelper.null2String(map.get("startrenew"));
			 reason = StringHelper.null2String(map.get("reason"));
			


			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZHR_IT0000_Z5_CREATE";//ZHR_IT0015_M2_CREATE
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			//function.getImportParameterList().setValue("LGART","7030");

			function.getImportParameterList().setValue("PERNR",sapid);//SAP编号
			function.getImportParameterList().setValue("CTEDT",endrenew);//结束日期
			function.getImportParameterList().setValue("CTTYP",contype);//合同类型
			function.getImportParameterList().setValue("BEGDA",startrenew); //开始日期
			function.getImportParameterList().setValue("MASSG",reason);
			System.out.println(sapid);
			System.out.println(endrenew);
			System.out.println(contype);
			System.out.println(startrenew);
			System.out.println(reason);
			
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			

			String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
			String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
			//更新数据库中对应的行项信息
			String upsql = "update uf_hr_contract  set message='"+MESSAGE+"',msgty='"+MSGTY+"' where requestid='"+requestid+"'";   
			baseJdbc.update(upsql);
			System.out.println(upsql);
			
			JSONObject jo = new JSONObject();		

			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		
			}
		}

%>

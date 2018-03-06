<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>

<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("toSap")){
		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		String cqtype=StringHelper.null2String(request.getParameter("cqtype"));//出勤类型
		String startdate=StringHelper.null2String(request.getParameter("startdate"));//开始日期
		if(startdate.equals(""))
		{
			startdate = StringHelper.null2String(request.getParameter("sdate")).split(" ")[0];//开始日期
		}
		startdate = startdate.replace("-", "");
		String starttime=StringHelper.null2String(request.getParameter("starttime"));//开始时间
		if(starttime.equals(""))
		{
			starttime = StringHelper.null2String(request.getParameter("sdate")).split(" ")[1];//开始时间
		}
		starttime = starttime.replace(":", "");
		String enddate=StringHelper.null2String(request.getParameter("enddate"));//结束日期
		if(enddate.equals(""))
		{
			enddate = StringHelper.null2String(request.getParameter("edate")).split(" ")[0];//结束日期
		}
		enddate = enddate.replace("-", "");
		String endtime=StringHelper.null2String(request.getParameter("endtime"));//结束时间
		if(endtime.equals(""))
		{
			endtime = StringHelper.null2String(request.getParameter("edate")).split(" ")[1];//结束时间
		}
		endtime = endtime.replace(":", "");
		String flowno=StringHelper.null2String(request.getParameter("flowno"));//流程单号
		String reqdate=StringHelper.null2String(request.getParameter("reqdate"));//流程单号
		reqdate = reqdate.split(" ")[0];
		reqdate = reqdate.replace("-", "");
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		
		JSONObject jo = new JSONObject();
		//System.out.println("****************************************************");
		//System.out.println("cqtype:"+cqtype+",startdate:"+startdate+"starttime,"+starttime+",enddate:"+enddate+",endtime:"+endtime+",flowno:"+flowno+",reqdate:"+reqdate);
		//String sql = " select a.id,a.sapno from uf_hr_outlessonsub a where a.requestid = '"+requestid+"' and NVL(a.msgtype,'0')<>'I'";
		String sql = " select a.id,a.sapno from uf_hr_outlessonsub a where a.requestid = '"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i = 0;i<list.size();i++)
			{
				Map map = (Map)list.get(i);
				String sapid = StringHelper.null2String(map.get("sapno"));//SAP员工工号
				String theid = StringHelper.null2String(map.get("id"));//子表ID
				
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT2002_AT_CREATE";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}	
				System.out.println("sapid:"+sapid+",cqtype:"+cqtype+",startdate:"+startdate+"starttime,"+starttime+",enddate:"+enddate+",endtime:"+endtime+",flowno:"+flowno+",reqdate:"+reqdate);
				//插入字段
				function.getImportParameterList().setValue("PERNR",sapid);
				function.getImportParameterList().setValue("AWART",cqtype);
				function.getImportParameterList().setValue("BEGDA",startdate);
				function.getImportParameterList().setValue("BEGUZ",starttime);
				function.getImportParameterList().setValue("ENDDA",enddate);
				function.getImportParameterList().setValue("ENDUZ",endtime);
				function.getImportParameterList().setValue("ZZNUM",flowno);
				function.getImportParameterList().setValue("ZZADA",reqdate);

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
					jo.put("msg","true");
				} catch (JCoException e) {
					// TODO Auto-generated catch block  
					jo.put("msg","false");
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					jo.put("msg","false");
					e.printStackTrace();
				}

				//返回值
				String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
				String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
				//System.out.println(MESSAGE);
				//System.out.println(MSGTY);
				String upsql="update uf_hr_outlessonsub set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where id='"+theid+"'";
				//System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"+upsql);
				baseJdbc.update(upsql);
			}
		}

		sql = "select msgtype from uf_hr_outlessonsub where requestid = '"+requestid+"' ";
		list = baseJdbc.executeSqlForList(sql);
		int mm = 1;
		if(list.size()>0){
			for(int ii = 0;ii<list.size();ii++)
			{
				Map submap1 = (Map)list.get(ii);
				String msgtype = StringHelper.null2String(submap1.get("msgtype"));//子表ID
				if(msgtype.equals("I"))
				{
				}
				else
				{
					mm = 0;
				}
			}
		}
		if(mm == 1)
		{
			sql = "update uf_hr_outlesson set msgtype = 'I' where requestid = '"+requestid+"'";
			baseJdbc.update(sql);
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>
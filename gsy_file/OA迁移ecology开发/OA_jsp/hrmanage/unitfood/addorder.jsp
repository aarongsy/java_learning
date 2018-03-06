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


<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>

<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if(action.equals("getData"))
	{
		//主表
		String reqname =StringHelper.null2String(request.getParameter("reqname"));//填单人
		String reqdate =StringHelper.null2String(request.getParameter("reqdate"));//填单日期
		String dept =StringHelper.null2String(request.getParameter("dept"));//订餐部门
		String orderdate =StringHelper.null2String(request.getParameter("orderdate"));//开始日期，结束日期，订餐日期
		String objname =StringHelper.null2String(request.getParameter("objname"));//订餐人
		//子表
		//部门
		String objno =StringHelper.null2String(request.getParameter("objno"));//工号
		//姓名
		//
		String breakfast =StringHelper.null2String(request.getParameter("breakfast"));//早餐
		String lunch =StringHelper.null2String(request.getParameter("lunch"));//中餐
		String dinner =StringHelper.null2String(request.getParameter("dinner"));//晚餐
		//String requestid = this.requestid;//当前流程requestid 
		EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	 
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		String userId = currentuser.getId();
	
		StringBuffer buffer = new StringBuffer(512);
		//String newrequestid = IDGernerator.getUnquieID();
		buffer.append("insert into uf_hr_unitfoot ").append("(id,requestid,reqman,reqdate,reqdept,begindate,enddate,names) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

		buffer.append("'").append(reqname).append("',");//填单人
		buffer.append("'").append(reqdate).append("',");//填单日期
		
		buffer.append("'").append(dept).append("',");//订餐部门
		buffer.append("'").append(orderdate).append("',");//订餐开始日期
		buffer.append("'").append(orderdate).append("',");//订餐结束日期
		buffer.append("'").append(objname).append("')");//订餐员工


		FormBase formBase = new FormBase();
		String categoryid = "40285a90495b4eb001496544fef97c7d";
		//创建formbase
		//formBase.setCreatedate(DateHelper.getCurrentDate());
		//formBase.setCreatetime(DateHelper.getCurrentTime());
		formBase.setCreator(reqname);
		formBase.setCategoryid(categoryid);
		formBase.setIsdelete(0);
		FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
		formBaseService.createFormBase(formBase);
		String insertSql = buffer.toString();
		String newrequesid=formBase.getId();
		insertSql = insertSql.replace("$ewrequestid$",newrequesid);
		//System.out.println(insertSql);
		baseJdbc.update(insertSql);
		PermissionTool permissionTool = new PermissionTool();
		permissionTool.addPermission(categoryid,formBase.getId(), "uf_hr_unitfoot");	
	    insertSql="insert into uf_hr_unitfootsub (id,requestid,reqdept,jobno,objname,thedate,breakfast,lunch,dinner) values ('"+IDGernerator.getUnquieID()+"','"+newrequesid+"','"+dept+"','"+objno+"','"+objname+"','"+orderdate+"','"+breakfast+"','"+lunch+"','"+dinner+"')";
		//System.out.println(insertSql);
		baseJdbc.update(insertSql);

		//返回值
		String ERR_MSG = "success";
		//String EXCH_RATE = function.getExportParameterList().getValue("EXCH_RATE").toString();
		//String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		
		JSONObject jo = new JSONObject();		
		jo.put("msg", ERR_MSG);
		//jo.put("rate", EXCH_RATE);
		//jo.put("flag", FLAG);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
%>

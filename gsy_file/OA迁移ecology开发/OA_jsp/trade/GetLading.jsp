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
	if (action.equals("getData")){
		String company=StringHelper.null2String(request.getParameter("company"));//公司别
		String startdate=StringHelper.null2String(request.getParameter("startdate"));//开始日期 
		String enddate=StringHelper.null2String(request.getParameter("enddate"));//结束日期
		String supplycode=StringHelper.null2String(request.getParameter("supplycode"));//供应商简码
		String comtype=StringHelper.null2String(request.getParameter("comtype"));//厂区别
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//表单的requestid
		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		
		String  delsql = "delete uf_tr_ciccreatedetail where requestid = '"+requestid+"'";
		baseJdbcDao.update(delsql);
		String sql = "select imgoodsid,reqman,reqdate,arrtype,suppliercode from uf_tr_lading  ";
		//进口到货编号，经办人，经办日期，到货类型，供应商简码
		sql = sql +"  where isinspection = '40288098276fc2120127704884290210' and requestid not in (select imgoodsid from uf_tr_cicappform) ";
		//sql = sql +" isinspection = '40288098276fc2120127704884290210' and imgoodsid is not null";
		
		if(!company.equals(""))
		{
			sql = sql +" and company = '"+company+"'";
		}
		if(!startdate.equals(""))
		{
			sql = sql +" and  reqdate >='"+startdate+"'";
		}
		if(!enddate.equals(""))
		{
			sql = sql +" and reqdate <='"+enddate+"'";
		}
		if(!supplycode.equals(""))
		{
			sql = sql +" and suppliercode = '"+supplycode+"'";
		}
		if(!comtype.equals(""))
		{
			sql = sql +" and factory = '"+comtype+"'";
		}
		System.out.println(sql);		//输出SQL语句
		List ls = baseJdbcDao.executeSqlForList(sql);
		int success = 0;
		if(ls.size()>0)//如果查询到数据
		{
            success = ls.size();
			for(int i = 0;i<ls.size();i++)
			{
				Map m = (Map)ls.get(i);
				String imgoodsid = StringHelper.null2String(m.get("imgoodsid"));//进口到货编号，
				String reqman = StringHelper.null2String(m.get("reqman"));//经办人
				String reqdate = StringHelper.null2String(m.get("reqdate"));//经办日期
				String arrtype = StringHelper.null2String(m.get("arrtype"));//到货类型
				String suppliercode = StringHelper.null2String(m.get("suppliercode"));//供应商简码
				String  insertsql = "insert into uf_tr_ciccreatedetail (no,id,requestid,importno,supplycode,goodstyle,creater,createdate)values('"+(i+1)+"','"+IDGernerator.getUnquieID()+"','"+requestid+"','"+imgoodsid+"','"+suppliercode+"','"+arrtype+"','"+reqman+"','"+reqdate+"')";
				baseJdbcDao.update(insertsql);

			}
		}
		
		JSONObject jo = new JSONObject();		
		jo.put("success", success);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
	%>

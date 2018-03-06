<%@page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@page import="jxl.biff.IntegerHelper"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
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
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>
<%
	
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	DataService csfkkqdataservices = new DataService();
	csfkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfkkq"));//访客	
	//csygkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csygkq"));//员工	

	String mark="1";//标识
	String idcard="";//初始化身份证号
	String sdate="";//初始化开始日期
	String edate="";//初始化结束日期
	String sql="select identify,min(ddate) as startdate,max(ddate) as enddate from uf_oa_forwarderlist where requestid='"+requestid+"' group by identify";
	List list=baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			idcard=StringHelper.null2String(map.get("identity"));
			sdate=StringHelper.null2String(map.get("startdate"));
			sdate=sdate+" "+"00:00:00.000";//匹配格式
			edate=StringHelper.null2String(map.get("enddate"));
			edate=edate+" "+"00:00:00.000";//匹配格式
			//更新包工有效日期
			String upsql = "update USERINFO set acc_startdate='"+sdate+"',acc_enddate='"+edate+"' where identitycard='"+idcard+"'";
			csfkkqdataservices.executeSql(upsql);//执行SQL
		}
	}
	else
	{
		mark="0";
	}

	JSONObject jo = new JSONObject();
	if(mark.equals("1"))
	{			
		//System.out.println("成功!");
		jo.put("msg","true");
	}
	else
	{
		//System.out.println("失败！");
		jo.put("msg","false");
	}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
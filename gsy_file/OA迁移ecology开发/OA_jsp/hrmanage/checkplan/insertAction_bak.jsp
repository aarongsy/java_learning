<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
	//EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String reqType=StringHelper.null2String(request.getParameter("reqType"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	System.out.println("555"+requestid);
	String beginDate=StringHelper.null2String(request.getParameter("beginDate"));
	String endDate=StringHelper.null2String(request.getParameter("endDate"));
	String comtype=StringHelper.null2String(request.getParameter("comtype"));//厂区别
	System.out.println(comtype);
	String differdate=StringHelper.null2String(request.getParameter("differdate"));//计划结束日期
	System.out.println(differdate);
	String position=StringHelper.null2String(request.getParameter("position"));//考核类型对应的职位
System.out.println(differdate);
	String employgroup=StringHelper.null2String(request.getParameter("employgroup"));//员工组
	//清空历史数据
	String sql = "delete from uf_hr_checkplansub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
    int len=differdate.split(";").length;
	
	System.out.println("考核计划start22222-------------");
	for(int j=0;j<len;j++)
	{
		String com=differdate.split(";")[j].split("/")[0];
		String day=differdate.split(";")[j].split("/")[1];
		String posi=position.split(";")[j].split("/")[1];
		System.out.println(com);
		System.out.println(day);
		System.out.println(posi);
		//重新插入(根据厂区别,员工组,考核开始日期与入职日期的比较,考核类型对应的职位,是否离职,来过滤员工数据)
		//String sql2 = "select objno,id,orgid,extrefobjfield4,extdatefield0 from humres where isdelete=0 and hrstatus='4028804c16acfbc00116ccba13802935' and instr('"+comtype+"',extrefobjfield5)>0 and instr('"+position+"',extrefobjfield4)>0 and extdatefield0<'"+differdate+"' and instr('"+employgroup+"',extselectitemfield11)>0";//这里增加查询条件，暂时没加，后面加上
		String sql2 = "select objno,id,orgid,extrefobjfield4,extdatefield0 from humres where isdelete=0 and hrstatus='4028804c16acfbc00116ccba13802935' and instr('"+com+"',extrefobjfield5)>0 and instr('"+posi+"',extrefobjfield4)>0 and extdatefield0<'"+day+"' and instr('"+employgroup+"',extselectitemfield11)>0";//这里增加查询条件，暂时没加，后面加上
		System.out.println(sql2);
		List list = baseJdbc.executeSqlForList(sql2);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map m = (Map)list.get(i);
				String jobno = StringHelper.null2String(m.get("objno"));
				String objid = StringHelper.null2String(m.get("id"));
				String objdept = StringHelper.null2String(m.get("orgid"));//所属部门
				String objprofe = StringHelper.null2String(m.get("extrefobjfield4"));//职称
				String indate = StringHelper.null2String(m.get("extdatefield0"));//入职日期
				String sql3 = "insert into uf_hr_checkplansub (id,requestid,jobno,objname,objdept,objprofe,indate) values (sys_guid(),'"+requestid+"','"+jobno+"','"+objid+"','"+objdept+"','"+objprofe+"','"+indate+"')";
				baseJdbc.update(sql3);
			}
			
		}	
		
	}
	String sql4 = "update uf_hr_checkplan set imtype='2' where requestid='"+requestid+"'";
	baseJdbc.update(sql4);
	System.out.println("考核计划end------------");
	return;
%>
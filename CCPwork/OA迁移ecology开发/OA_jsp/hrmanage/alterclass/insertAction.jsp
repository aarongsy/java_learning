<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="org.json.simple.JSONValue" %>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String beginDate=StringHelper.null2String(request.getParameter("beginDate"));
	String endDate=StringHelper.null2String(request.getParameter("endDate"));
	String objname=StringHelper.null2String(request.getParameter("objname"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	int no = 0;
	//清空历史数据
	String sql = "delete from uf_hr_alterclasssub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	//重新插入
	sql = "select thedate,classno,classname,hours from uf_hr_classplan  where objname='"+objname+"' and thedate>='"+beginDate+"' and thedate<='"+endDate+"'";
	List ls = baseJdbc.executeSqlForList(sql);
	if(ls.size()>0){
		for(int k=0 ; k<ls.size(); k++) 
		{
			Map m = (Map)ls.get(k);
			no = k+1;
			String thedate = StringHelper.null2String(m.get("thedate"));
			String classno = StringHelper.null2String(m.get("classno"));
			String classname = StringHelper.null2String(m.get("classname"));
			String hours = "";
			if(classno.equals("40285a904931f62b014937218d0b2bc6") || classno.equals("40285a904931f62b014937218df82c0e")){
				hours = "0";
			}else hours = StringHelper.null2String(m.get("hours"));
			String sql2 = "insert into uf_hr_alterclasssub (id,requestid,olddate,oldno,oldname,oldnums,objname) values (sys_guid(),'"+requestid+"','"+thedate+"','"+classno+"','"+classname+"',to_number('"+hours+"'),'"+objname+"')";
			baseJdbc.update(sql2);
		}
	}	
	return;
%>
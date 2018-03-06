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
	String reqType=StringHelper.null2String(request.getParameter("reqType"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String beginDate=StringHelper.null2String(request.getParameter("beginDate"));
	String endDate=StringHelper.null2String(request.getParameter("endDate"));
	String comtype=StringHelper.null2String(request.getParameter("comtype"));//厂区别
	//清空历史数据
	String sql = "delete from uf_hr_checkplansub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	//重新插入
	String sql2 = "select objno,id,orgid,extrefobjfield4,extdatefield0 from humres where isdelete=0 and hrstatus='4028804c16acfbc00116ccba13802935'";//这里增加查询条件，暂时没加，后面加上
	List list = baseJdbc.executeSqlForList(sql2);
	if(list.size()>0){
		for(int i=0;i<list.size();i++){
			Map m = (Map)list.get(i);
			String jobno = StringHelper.null2String(m.get("objno"));
			String objid = StringHelper.null2String(m.get("id"));
			String objdept = StringHelper.null2String(m.get("orgid"));
			String objprofe = StringHelper.null2String(m.get("extrefobjfield4"));
			String indate = StringHelper.null2String(m.get("extdatefield0"));
			String sql3 = "insert into uf_hr_checkplansub (id,requestid,jobno,objname,objdept,objprofe,indate) values (sys_guid(),'"+requestid+"','"+jobno+"','"+objid+"','"+objdept+"','"+objprofe+"','"+indate+"')";
			baseJdbc.update(sql3);
		}
		String sql4 = "update uf_hr_checkplan set imtype='2' where requestid='"+requestid+"'";
		baseJdbc.update(sql4);
	}	
	return;
%>
<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="java.util.*"%><%@ page import="com.eweaver.base.util.*" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.label.service.LabelService" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.humres.base.model.Humres" %><%@ page import="com.eweaver.humres.base.service.HumresService" %><%@ page import="com.eweaver.base.setitem.service.SetitemService" %><%@ page import="org.json.simple.JSONValue" %><%@ page import="org.springframework.dao.DataAccessException"%><%@ page import="org.springframework.jdbc.core.JdbcTemplate"%><%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%><%@ page import="org.springframework.transaction.*"%><%@ page import="org.springframework.transaction.PlatformTransactionManager"%><%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%><%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String theid=StringHelper.null2String(request.getParameter("theid"));
	String newno=StringHelper.null2String(request.getParameter("newno"));
	String newname = StringHelper.null2String(request.getParameter("newname"));
	String newnums = StringHelper.null2String(request.getParameter("newnums"));	
	String nums = StringHelper.null2String(request.getParameter("nums"));
	StringBuffer buf = new StringBuffer();
	
	String sql = "update uf_hr_alterclasssub set newno='"+newno+"',newname='"+newname+"',newnums=to_number('"+newnums+"'),nums=to_number('"+nums+"') where id='"+theid+"'";

	baseJdbc.update(sql);
	buf.append("throw=0");
	response.getWriter().print(buf.toString());
	return;
%>
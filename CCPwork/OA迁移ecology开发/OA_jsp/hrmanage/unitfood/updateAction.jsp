<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="java.util.*"%><%@ page import="com.eweaver.base.util.*" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.label.service.LabelService" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.humres.base.model.Humres" %><%@ page import="com.eweaver.humres.base.service.HumresService" %><%@ page import="com.eweaver.base.setitem.service.SetitemService" %><%@ page import="org.json.simple.JSONValue" %><%@ page import="org.springframework.dao.DataAccessException"%><%@ page import="org.springframework.jdbc.core.JdbcTemplate"%><%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%><%@ page import="org.springframework.transaction.*"%><%@ page import="org.springframework.transaction.PlatformTransactionManager"%><%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%><%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String theid=StringHelper.null2String(request.getParameter("theid"));
	String come=StringHelper.null2String(request.getParameter("come"));
	String test = StringHelper.null2String(request.getParameter("test"));
	StringBuffer buf = new StringBuffer();
	String sql = "update uf_hr_entrylessonsub2 set come='"+come+"',test='"+test+"' where id='"+theid+"'";

	baseJdbc.update(sql);
	buf.append("throw=0");
	response.getWriter().print(buf.toString());
	return;
%>
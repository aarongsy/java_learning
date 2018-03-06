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
	String rzsj=StringHelper.null2String(request.getParameter("rzsj"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	int no = 0;
	//清空历史数据
	String sql = "delete from uf_hr_entrylessonsub2 where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	//重新插入
	sql = "select a.name,a.jobno,b.lesson,b.lessonname from uf_hr_talentpool a  cross join uf_hr_entrylessonsub1 b  where b.requestid='"+requestid+"' and a.entrydate='"+rzsj+"' and a.marktype='40285a8f489c17ce0148a127f5c80d8d' order by a.name,b.lesson";
	List ls = baseJdbc.executeSqlForList(sql);
	if(ls.size()>0){
		for(int k=0 ; k<ls.size(); k++) 
		{
			Map m = (Map)ls.get(k);
			no = k+1;
			String name = StringHelper.null2String(m.get("name"));
			String jobno = StringHelper.null2String(m.get("jobno"));
			String lessonid = StringHelper.null2String(m.get("lesson"));
			String lessonname = StringHelper.null2String(m.get("lessonname"));
			
			String sql2 = "insert into uf_hr_entrylessonsub2 (id,requestid,no,objname,jobno,lessonid,lessonname) values (sys_guid(),'"+requestid+"',to_number('"+no+"'),'"+name+"','"+jobno+"','"+lessonid+"','"+lessonname+"')";
			baseJdbc.update(sql2);
		}
	}	
	return;
%>
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
	String sql = "delete from uf_hr_entrysub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	sql = "update uf_hr_entry set yesno='2' where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	//重新插入
	sql = "select requestid,dept,name,sex,birthday,cardno,entrydate from uf_hr_talentpool a,formbase b where a.requestid=b.id and b.isdelete=0 and marktype='40285a8f489c17ce0148a127f5c80d8c' and rqtype='40285a8f489c17ce0148a12871bb0d99' and entrydate='"+rzsj+"'";
	List ls = baseJdbc.executeSqlForList(sql);
	if(ls.size()>0){
		for(int k=0 ; k<ls.size(); k++) 
		{
			Map m = (Map)ls.get(k);
			no = k+1;
			String reqid = StringHelper.null2String(m.get("requestid"));
			String dept = StringHelper.null2String(m.get("dept"));
			String name = StringHelper.null2String(m.get("name"));
			String sex = StringHelper.null2String(m.get("sex"));
			String birthday = StringHelper.null2String(m.get("birthday"));
			String cardno = StringHelper.null2String(m.get("cardno"));
			String entrydate = StringHelper.null2String(m.get("entrydate"));
			//查询出入职员工部门的二级部门
			String twodept = "";
			//sql = "select id from (SELECT CONNECT_by_root orgt.objname,orgt.* FROM "+ 
					//"(SELECT a.id,a.objname,a.typeid,a.isdelete,a.unitstatus,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID) orgt "+
					//"START WITH orgt.ID='"+dept+"' CONNECT BY PRIOR orgt.pid=orgt.id) where typeid='2c91a0302b19639f012b196ec20e0010' and isdelete=0 and unitstatus='402880d31a04dfba011a04e4db5f0003'";
			
			sql = "select id from (SELECT CONNECT_by_root orgt.objname,orgt.* FROM "+
					"(SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID) orgt "+
					"START WITH orgt.ID='"+dept+"' CONNECT BY PRIOR orgt.pid=orgt.id)"+ 
					"where id<>'402881e70ad1d990010ad1e5ec930008' order by rownum desc";
			List ls2 = baseJdbc.executeSqlForList(sql);
			if(ls2.size()>=3){
				Map m2 = (Map)ls2.get(2);
				twodept = StringHelper.null2String(m2.get("id"));
			} else twodept = dept;
			String sql2 = "insert into uf_hr_entrysub (id,requestid,no,objdept,objname,sex,birthday,cardid,entrydate,discount,discountdate,reqid,twodept,flowtype) values (sys_guid(),'"+requestid+"',to_number('"+no+"'),'"+dept+"','"+name+"','"+sex+"','"+birthday+"','"+cardno+"','"+entrydate+"',90,to_char((to_date('"+entrydate+"','yyyy-mm-dd')+91),'YYYY-MM-DD'),'"+reqid+"','"+twodept+"','40285a8f489c17ce0148a12871bb0d99')";
			baseJdbc.update(sql2);
		}
	}
	return;
%>
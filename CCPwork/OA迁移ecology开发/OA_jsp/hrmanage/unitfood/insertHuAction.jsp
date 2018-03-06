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
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.ParseException"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String humres=StringHelper.null2String(request.getParameter("humres"));
	String theyear=StringHelper.null2String(request.getParameter("themonth"));
	theyear = theyear+"-01";
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	//清空历史数据
	String sql = "delete from uf_hr_unitfootsub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
	//获取员工数组
	String[] hnames = humres.split(",");
	//获取月的天数
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	Calendar cd = Calendar.getInstance();
	try {
		
		cd.setTime(sf.parse(theyear));
	} catch (ParseException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	}
	int days = cd.getActualMaximum(Calendar.DAY_OF_MONTH);
	for(int i=0;i<hnames.length;i++){
		String sql2 = "select orgid,objno,id from humres where id='"+hnames[i]+"'";
		List list = baseJdbc.executeSqlForList(sql2);
		if(list.size()>0){
			Map map = (Map)list.get(0);
			String reqdept = StringHelper.null2String(map.get("orgid"));
			String jobno = StringHelper.null2String(map.get("objno"));
			String objname = StringHelper.null2String(map.get("id"));
			for(int m=0;m<days;m++){
				cd.setTime(sf.parse(theyear));
				cd.add(Calendar.DATE,m);
				Date d = cd.getTime();
				String thedate = sf.format(d);
				String sql3 = "insert into uf_hr_unitfootsub (id,requestid,reqdept,jobno,objname,thedate) values (sys_guid(),'"+requestid+"','"+reqdept+"','"+jobno+"','"+objname+"','"+thedate+"')";
				baseJdbc.update(sql3);
			}
		}
	}	
	return;
%>
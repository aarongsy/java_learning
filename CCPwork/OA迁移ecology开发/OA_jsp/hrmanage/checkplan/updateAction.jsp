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
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");	
	String action=StringHelper.null2String(request.getParameter("action"));
	StringBuffer buf = new StringBuffer();
	if(action.equals("delsub")){
		String theid=StringHelper.null2String(request.getParameter("theid"));
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String[] ids = theid.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "delete from uf_hr_checkplansub where requestid='"+requestid+"' and id='"+ids[i]+"'";
			baseJdbc.update(sql);
		}	
		buf.append("throw=0");
		response.getWriter().print(buf.toString());
		return;
	}
	if(action.equals("insertsub")){
		JSONObject jo = new JSONObject();
		boolean msg = true;
		String obj=StringHelper.null2String(request.getParameter("obj"));
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String[] hnames = obj.split(",");
		for(int i=0;i<hnames.length;i++){
			String sql = "select a.objname id,b.objname,b.objno from uf_hr_checkplansub a left join humres b on a.objname=b.id where a.objname='"+hnames[i]+"' and a.requestid='"+requestid+"'";
			List list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0){
				Map map = (Map)list.get(0);
				String thename = StringHelper.null2String(map.get("objname"));
				String theno = StringHelper.null2String(map.get("objno"));
				jo.put("name", thename+" "+theno);
				msg = false;
				break;
			}
		}
		if(msg){
			for(int i=0;i<hnames.length;i++){
				String sql2 = "select objno,id,orgid,extrefobjfield4,extdatefield0 from humres where id='"+hnames[i]+"'";
				List list2 = baseJdbc.executeSqlForList(sql2);
				if(list2.size()>0){
					Map m = (Map)list2.get(0);
					String jobno = StringHelper.null2String(m.get("objno"));
					String objid = StringHelper.null2String(m.get("id"));
					String objdept = StringHelper.null2String(m.get("orgid"));
					String objprofe = StringHelper.null2String(m.get("extrefobjfield4"));
					String indate = StringHelper.null2String(m.get("extdatefield0"));
					String sql3 = "insert into uf_hr_checkplansub (id,requestid,jobno,objname,objdept,objprofe,indate) values (sys_guid(),'"+requestid+"','"+jobno+"','"+objid+"','"+objdept+"','"+objprofe+"','"+indate+"')";
					baseJdbc.update(sql3);
				}
			}
			jo.put("msg", "true");
		}else{
			jo.put("msg", "false");
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
	
%>
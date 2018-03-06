<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%
	DataService ds = new DataService();
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	int total = 0;
	if (action.equals("getData")){
		String objname=StringHelper.null2String(request.getParameter("objname"));
		String lzsj=StringHelper.null2String(request.getParameter("lzsj"));
		String sql = "select a.requestid,to_char(to_date(a.startdate,'yyyy-MM-dd HH24:mi:ss'),'yyyy-mm-dd') startdate,to_char(to_date(a.enddate,'yyyy-MM-dd HH24:mi:ss'),'yyyy-mm-dd') enddate,a.money from uf_hr_renege a,formbase b where a.requestid=b.id and b.isdelete=0 and a.objname='"+objname+"'";
		List ls = baseJdbcDao.executeSqlForList(sql);
		if (ls.size()>0){
			for (int i=0;i<ls.size();i++){
				Map m = (Map)ls.get(i);
				String startdate = StringHelper.null2String(m.get("startdate"));
				String enddate = StringHelper.null2String(m.get("enddate"));
				String money2 = StringHelper.null2String(m.get("money"));
				if(money2.equals("")) money2="0";
				String reqid = StringHelper.null2String(m.get("requestid"));
				float money = Float.parseFloat(money2);
				float wyj = 0;
				SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
				Date s = ft.parse(startdate);
				Date e = ft.parse(enddate);
				Date l = ft.parse(lzsj);
				float a = e.getTime() - s.getTime();
				a = a / 1000 / 60 / 60 / 24+1;
				float b = e.getTime() - l.getTime();
				b = b / 1000 / 60 / 60 / 24+1;
				if (b>0){
					wyj =  (b/a)*money;
				}
				int thewyj = Math.round(wyj);
				//把违约金更新到分类中
				String usql = "update uf_hr_renege set renegemoney = to_number('"+StringHelper.null2String(thewyj)+"') where requestid='"+reqid+"'";
				baseJdbcDao.update(usql);
				total = total + thewyj;
			}
		}
		JSONObject jo = new JSONObject();
		jo.put("total",total);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>

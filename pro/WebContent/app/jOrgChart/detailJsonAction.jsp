<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
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
String orgid = StringHelper.null2String(request.getParameter("orgid"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String sql = "select NVL(count(a.id),0) gws,NVL(sum(a.MAXNUM),0) db,NVL(sum(a.CURNUM),0) zb,NVL((sum(a.MAXNUM)-sum(a.CURNUM)),0) qb from stationinfo a where exists (select id from (SELECT id FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID and a.isdelete=0 and a.unitstatus='402880d31a04dfba011a04e4db5f0003') orgu START WITH orgu.id='"+orgid+"' CONNECT BY PRIOR ORGU.id=orgu.pid) b where a.orgid=b.id) and a.STATIONSTATUS='402880d319eb81720119eba4e1e70004' and a.isdelete=0";
List ls = baseJdbc.executeSqlForList(sql);
if(ls.size()>0){
	Map m = (Map)ls.get(0);
	String gws = m.get("gws").toString();
	String db = m.get("db").toString();
	String zb = m.get("zb").toString();
	String qb = m.get("qb").toString();
	JSONObject jo = new JSONObject();
	jo.put("gws",gws);
	jo.put("db",db);
	jo.put("zb",zb);
	jo.put("qb",qb);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
}
%>


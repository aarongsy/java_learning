<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.DataService"%>


<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	//DataService ds = new DataService();
	//String ladno=StringHelper.null2String(request.getParameter("ladno"));//提入单号
	//String loadplanno=StringHelper.null2String(request.getParameter("loadplanno")); //装卸计划号
	//String ispond = StringHelper.null2String(request.getParameter("ispond")); //是否过磅
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	//System.out.println("ladno="+ladno+" loadplanno="+loadplanno+" ispond="+ispond+" requestid="+requestid);
	String delsql = "delete from uf_lo_pobatchladsub where requestid='"+requestid+"'";
	int ret = baseJdbc.update(delsql);
	delsql = "delete from uf_lo_pobatchsub where requestid='"+requestid+"'";
	ret += baseJdbc.update(delsql);
	JSONObject jsonObject = new JSONObject();
	if(ret>=1){
		jsonObject.put("msg","true");
		jsonObject.put("info","删除成功");
	}else{
		jsonObject.put("msg","false");
		jsonObject.put("info","删除失败");	
	}
	response.getWriter().write(jsonObject.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
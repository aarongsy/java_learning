<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String pid = StringHelper.null2String(request.getParameter("pId"));
String actiontype = StringHelper.null2String(request.getParameter("actiontype"));
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String nodeid  = StringHelper.null2String(request.getParameter("id"));
// System.out.println(pid+">>>"+actiontype);
String sql = "";
if(actiontype.startsWith("addElement")){
	String saptablename = StringHelper.null2String(request.getParameter("sapparam"));
	String otablename = StringHelper.null2String(request.getParameter("oparam"));
	String convertsql = StringHelper.null2String(request.getParameter("convertsql"));
	String type = actiontype.substring("addElement".length());
// 	System.out.println(type+"<<"+type);
	String id = IDGernerator.getUnquieID();
// 	sql="insert into sapconfig(id,name,remark,otabname,oremark,type,oconvert,pid) values('"+id
// 	+"','"+saptablename+"','"+saptablename+"','"+otablename+"','"+otablename+"','"+type+"','"+convertsql+"','"+pid+"')";
	sql="insert into sapconfig(id,name,remark,otabname,oremark,type,oconvert,pid) values(?,?,?,?,?,?,?,?)";
	List valueObject = new ArrayList();
	valueObject.add(id);
	valueObject.add(saptablename);
	valueObject.add(saptablename);
	valueObject.add(otablename);
	valueObject.add(otablename);
	valueObject.add(type);
	valueObject.add(convertsql);
	valueObject.add(pid);
	baseJdbcDao.getJdbcTemplate().update(sql, valueObject.toArray());;
	out.print("success");
}else if(actiontype.startsWith("deleteElement")){
	sql = "delete from sapconfig where id='"+nodeid+"'";
	baseJdbcDao.update(sql);
	out.print("success");
}
%>

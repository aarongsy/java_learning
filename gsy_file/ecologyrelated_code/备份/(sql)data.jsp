<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>
<%
	BaseBean basebean=new BaseBean();
	basebean.writeLog("");
	
	Map<String,Object> map = new HashMap<String,Object>();
	String requestid = Util.null2String(request.getParameter("requestid")).trim();
	String sql = "";
	rs.executeSql(sql);
	int count = rs.getCounts();
	if(count>0){
		rs.next();
		String[] arr = rs.getColumnName();
		for(int i=0;i<arr.length;i++){
			map.put(arr[i].toLowerCase(), rs.getString(arr[i]));
		}
	}
	JSONObject json = JSONObject.fromObject(map);
	response.setContentType("application/json;charset=utf-8");
	response.getWriter().write(json.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
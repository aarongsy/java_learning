<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>
<%
	BaseBean basebean=new BaseBean();
	basebean.writeLog("");
	
	ArrayList<String> arrayList = new ArrayList<String>();
	JSONObject jsonObject = new JSONObject();
	JSONArray json = new JSONArray();

	String requestid = Util.null2String(request.getParameter("requestid")).trim();
	String sql = "";
	rs.executeSql(sql);
	String[] arr = rs.getColumnName();
	int count = rs.getCounts();
	if(count>0){
		while(rs.next()){
			HashMap<String,Object> hashMap = new HashMap<String,Object>();
			for(int i=0;i<arr.length;i++){
				hashMap.put(arr[i].toLowerCase(), rs.getString(arr[i]));
			}
			json.add(hashMap);
		}
	}
	response.setContentType("application/json;charset=utf-8");
	response.getWriter().write(json.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
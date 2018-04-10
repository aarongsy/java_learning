
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="java.text.SimpleDateFormat,java.text.DateFormat" %>

<%
	
	
	RecordSet rs = new RecordSet();
	try {
		String list = request.getParameter("list");
		String comtype = request.getParameter("comtype");
		JSONArray jsonArr = new JSONArray();
		rs.writeLog("++++++++++++++++++++++++");
		rs.writeLog("list："+list);
		rs.writeLog("comtype:"+comtype);
		/* JSONArray json = JSONArray.fromObject(list);
		String strremark = Util.null2String(request.getParameter("strremark"));	
		String userid = Util.null2String(request.getParameter("userid"));
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");//可以方便地修改日期格式	
		SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm"); 
		String curdate = dateFormat.format( now ); 	 
		String curtime = timeFormat.format( now ); 
		
		Map<String, String> retmap = new HashMap<String, String>();	
		JSONObject jo = new JSONObject();
		int errcount = 0;
		int succount = 0;
		String successNo ="";
		String errNo ="";
		String errmsg = ""; */
	}catch (Exception e) {
		// TODO: handle exception
		out.write("fail" + e);
		errmsg = e.toString();
		e.printStackTrace();
	}
			
		
%>	

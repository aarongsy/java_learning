<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String supplycode=StringHelper.null2String(request.getParameter("supplycode"));
		//String requestid = this.requestid;//当前流程requestid 

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select times1,times2,times3,times4,times5,times6,times7,times8,times9,times10,times11,times12,times13,times14,times15,times16,times17 from uf_yz_supplyeval  ";
		sql = sql +" where 1=(select a.isfinished from requestbase a where a.id = requestid) and supplier = '"+supplycode+"'";
		//System.out.println(sql);
		List tlist = baseJdbc.executeSqlForList(sql);
		
		String getsql = "";
		List getlist;
		Map getmap;
		int times1 = 0;
		int times2 = 0;
		int times3 = 0;
		int times4 = 0;
		int times5 = 0;
		int times6 = 0;
		int times7 = 0;
		int times8 = 0;
		int times9 = 0;
		int times10 = 0;

		int times11 = 0;
		int times12 = 0;
		int times13 = 0;
		int times14 = 0;
		int times15 = 0;
		int times16 = 0;
		int times17 = 0;
		if(tlist.size()>0){
		System.out.println("456");
			for(int i = 0;i<tlist.size();i++)
			{
				Map map = (Map)tlist.get(i);
				System.out.println(Integer.parseInt(StringHelper.null2String(map.get("times1"))));
				times1 += Integer.parseInt(StringHelper.null2String(map.get("times1")));
				times2 += Integer.parseInt(StringHelper.null2String(map.get("times2")));
				times3 += Integer.parseInt(StringHelper.null2String(map.get("times3")));
				times4 += Integer.parseInt(StringHelper.null2String(map.get("times4")));
				times5 += Integer.parseInt(StringHelper.null2String(map.get("times5")));
				times6 += Integer.parseInt(StringHelper.null2String(map.get("times6")));
				times7 += Integer.parseInt(StringHelper.null2String(map.get("times7")));
				times8 += Integer.parseInt(StringHelper.null2String(map.get("times8")));
				times9 +=Integer.parseInt(StringHelper.null2String(map.get("times9")));
				times10 +=Integer.parseInt(StringHelper.null2String(map.get("times10")));
				times11 +=Integer.parseInt(StringHelper.null2String(map.get("times17")));

				times12 += Integer.parseInt(StringHelper.null2String(map.get("times11")));
				times13 += Integer.parseInt(StringHelper.null2String(map.get("times12")));
				times14 += Integer.parseInt(StringHelper.null2String(map.get("times13")));
				times15 += Integer.parseInt(StringHelper.null2String(map.get("times14")));
				times16 += Integer.parseInt(StringHelper.null2String(map.get("times15")));
				times17 += Integer.parseInt(StringHelper.null2String(map.get("times16")));
			}

		}
			JSONObject jo = new JSONObject();		
			jo.put("times1", times1);
			jo.put("times2", times2);
			jo.put("times3", times3);
			jo.put("times4", times4);
			jo.put("times5", times5);
			jo.put("times6", times6);
			jo.put("times7", times7);
			jo.put("times8", times8);
			jo.put("times9", times9);
			jo.put("times10", times10);
			jo.put("times11", times11);
			jo.put("times12", times12);
			jo.put("times13", times13);
			jo.put("times14", times14);
			jo.put("times15", times15);
			jo.put("times16", times16);
			jo.put("times17", times17);
			
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
	}
%>

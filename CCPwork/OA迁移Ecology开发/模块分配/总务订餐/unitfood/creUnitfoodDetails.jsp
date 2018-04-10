<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*, weaver.systeminfo.SystemEnv" %> 
<%@page import="org.json.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bs" class="weaver.general.BaseBean"/>
<%@ page import="weaver.interfaces.gd.unitfood.CreUnitfoodDetail" %>

<%
 	//empids, sdate, edate, deptcode, floornum, remark
	String empids = Util.null2String(request.getParameter("empids"));	//empids	
	String sdate = Util.null2String(request.getParameter("sdate"));	//sdate
	String edate = Util.null2String(request.getParameter("edate"));	//edate
	String deptcode = Util.null2String(request.getParameter("deptcode"));	//deptcode
	String floornum = Util.null2String(request.getParameter("floornum"));	//floornum
	String remark = Util.null2String(request.getParameter("remark"));	//remark
	String userid = Util.null2String(request.getParameter("userid"));
	String action = Util.null2String(request.getParameter("action"));	//action
	bs.writeLog("empids="+empids+" sdate="+sdate+" edate="+edate+" deptcode="+deptcode+" floornum="+floornum
	+" remark="+remark+" userid="+userid);	
	
	JSONObject jo = new JSONObject();	
	try {
		CreUnitfoodDetail creapp = new CreUnitfoodDetail();
		creapp.creUnitfoodDetails(empids, sdate, edate, deptcode, floornum, remark,userid);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	

	jo.put("msg", "true");	
	jo.put("flag", "ok");
	
%>

<%=jo.toString() %>

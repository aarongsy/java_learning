<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection" %>

<%
String path = request.getParameter("");
try {
		DataSource ds=(DataSource) StaticObj.getServiceByFullname(("datasource.eweaverTestOA"),
		weaver.interfaces.datasource.DataSource.class);
		  Connection conn=ds.getConnection();
		  Statement st=conn.createStatement();
		  int DELIVERYNO=8000066;
		  String sql="select SHIPADVSTATUS,SHIPADVICENO from V_ECO_SHIPADVICE"+" where DELIVERYNO='8000066'";
		  ResultSet rs=st.executeQuery(sql);
		  String outcall="";
		  while(rs.next()){
			  outcall+=rs.getString("SHIPADVSTATUS")+"--";
			  outcall+=rs.getString("SHIPADVICENO")+"--";
			  
			  
		  }
		  
		  out.write("suceess："+outcall);
	} catch (Exception e) {
		// TODO: handle exception
		out.write("fail"+e);
		e.printStackTrace();
		
	}


%>



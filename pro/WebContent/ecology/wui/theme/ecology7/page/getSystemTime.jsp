<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.*"%>

<%
String result = "";

String field = request.getParameter("field");

Calendar calendar = Calendar.getInstance();
calendar.setTime(new Date());
if (field != null && field.equals("HH")) {
	out.print(calendar.get(Calendar.HOUR_OF_DAY));
	return;
} 
out.print(0);
%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String strweek = StringHelper.null2String(request.getParameter("strweek"));
String companyscheduledate = StringHelper.null2String(session.getAttribute("companyscheduledate"));
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
int weekNum = 0;
if(("lastWeek".equals(strweek)||"nextWeek".equals(strweek))&&!StringHelper.isEmpty(companyscheduledate)){
	Date date=sdf.parse(companyscheduledate);
	weekNum = DateHelper.getDayOfWeek(date);
}else{
	companyscheduledate = DateHelper.getCurrentDate();
	Date date=sdf.parse(companyscheduledate);
	weekNum = DateHelper.getDayOfWeek(date);
}
String datepar = "";
String fdate = "";
String ldate = "";
if("ready".equals(strweek)){
	
}else if("clear".equals(strweek)){
	session.setAttribute("companyscheduledate",null);
}else if("currentDay".equals(strweek)){
	datepar=DateHelper.getCurrentDate();
	session.setAttribute("companyscheduledate",datepar);
}else if("lastWeek".equals(strweek)){//上一周
	fdate = DateHelper.dayMove(companyscheduledate,2-weekNum-7);
	ldate = DateHelper.dayMove(companyscheduledate,1-weekNum);
	datepar = fdate+","+ldate;
	session.setAttribute("companyscheduledate",fdate);
}else if("currentWeek".equals(strweek)){
	fdate = DateHelper.dayMove(companyscheduledate,2-weekNum);
	ldate = DateHelper.dayMove(companyscheduledate,8-weekNum);
	datepar = fdate+","+ldate;
	session.setAttribute("companyscheduledate",fdate);
}else if("nextWeek".equals(strweek)){
	fdate = DateHelper.dayMove(companyscheduledate,9-weekNum);
	ldate = DateHelper.dayMove(companyscheduledate,15-weekNum);
	datepar = fdate+","+ldate;
	session.setAttribute("companyscheduledate",fdate);
}
out.print(datepar);
%>

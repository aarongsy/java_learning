<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.attendance.service.AttendanceService" %>
<%@ include file="/base/init.jsp"%>
<%
    String currmonth = StringHelper.null2String(request.getParameter("currmonth"));
    String currmonthsql = "";
    int currm = 0;
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    AttendanceService attendanceService = (AttendanceService) BaseContext.getBean("attendanceService");
    String temp_date = "";
    String temp_date2 = "";
    if (StringHelper.isEmpty(currmonth)) {
       currm = NumberHelper.string2Int(DateHelper.getCurrentMonth().split("-")[1]);
       temp_date = DateHelper.getCurrentDate();
       currmonthsql = "convert(varchar,year(getdate()))+'-'+convert(varchar,month(getdate()))";
       temp_date2 = DateHelper.getCurrentMonth();
    } else {
       temp_date = currmonth + "-01";
       currmonthsql ="'"+currmonth+"'";
       currm = NumberHelper.string2Int(currmonth.split("-")[1]);
       temp_date2 = currmonth;
    }
    String attsql = "select a.hrmid,Max(h.objname) hurmsname,h.orgid,o.objname orgname,max(month(date1)) m,(select count(*) " + 
                    "from attendance where hrmid=a.hrmid and (convert(varchar,year(date1))+'-'+convert(varchar,month(date1))) = "+currmonthsql+" and attendance != 2) cont, " + 
                    "(select count(*) from attendance where hrmid=a.hrmid and attendance = 1 and (convert(varchar,year(date1))+'-'+convert(varchar,month(date1))) = "+currmonthsql+") attcount " +  
                    "from attendance a " +  
                    "join humres h on a.hrmid = h.id join orgunit o on h.orgid=o.id where (convert(varchar,year(date1))+'-'+convert(varchar,month(date1))) = "+currmonthsql+" and attendance != 2 " + 
                    "group by a.hrmid,convert(varchar,year(date1))+'-'+convert(varchar,month(date1)),h.orgid,o.objname " +  
                    "order by h.orgid";
    List attarr = baseJdbcDao.getJdbcTemplate().queryForList(attsql);
    StringBuffer sb = new StringBuffer("<center><font size=\"4\">立特营销机构"+currm+"月考勤报表</font></center>");
    sb.append("<table id=\"tab\" cellspacing=\"0\"><caption><input type=\"text\" id=\"dateval\" value=\""+temp_date2+"\" readonly=\"true\" onfocus=\"javascrpt:WdatePicker({dateFmt:'yyyy-M'})\" /> " + 
                       "<input type=\"button\" onclick=\"onSearch();\" value=\"搜索\"/></caption><tbody><tr><th scope=\"col\">部门名称</th><th scope=\"col\">员工姓名</th><th scope=\"col\">工作日天数</th><th scope=\"col\">签到次数</th></tr>");
    String startDate = DateHelper.getFirstDayOfMonthWeek(DateHelper.parseDate(temp_date));
    String endDate = DateHelper.getLastDayOfMonthWeek(DateHelper.parseDate(temp_date));
    
    if (attarr.size()>0) {
    //int i = 0;
       for (Object object : attarr) {
         String hrmid = StringHelper.null2String(((Map)object).get("hrmid"));//员工id
         String hurmsname = StringHelper.null2String(((Map)object).get("hurmsname"));//员工姓名
         String orgname = StringHelper.null2String(((Map)object).get("orgname"));//部门名称
         String orgid = StringHelper.null2String(((Map)object).get("orgid"));//部门id
         String month = StringHelper.null2String(((Map)object).get("m"));//月份
         //String cont = StringHelper.null2String(((Map)object).get("cont"));//工作日天数
         String cont = StringHelper.null2String(attendanceService.getWorkdaysCount(startDate,endDate));
         String attcount = StringHelper.null2String(((Map)object).get("attcount"));//签到天数
         sb.append("<tr>");
         sb.append("<td>"+orgname+"</td>");
         sb.append("<td>"+hurmsname+"</td>");    
         sb.append("<td>"+cont+"</td>"); 
         sb.append("<td>"+attcount+"</td>"); 
         sb.append("</tr>");
       }
    }
    sb.append("</tbody></table>");
%>
<html>
  <head>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
<style type="text/css">
  /* CSS Document */ 
	body {  color: #4f6b72;  } 
	a    { color: #c75f3e; } 
	#_tab { width: 100%; padding: 0; margin: 0; } 
	caption    { padding: 0 0 5px 0; width: 100%; font: italic 11px "Trebuchet MS", Verdana,
    Arial, Helvetica, sans-serif; text-align: right; } 
	th { font: bold 11px "Trebuchet MS", Verdana, Arial, Helvetica; color: #4f6b72;border-right: 1px solid #C1DAD7; border-bottom: 1px solid #C1DAD7; border-top:1px solid #C1DAD7; letter-spacing:2px; text-transform:uppercase; text-align:left; padding: 6px 6px 6px 12px; background: #CAE8EA url(images/bg_header.jpg)
    no-repeat; } 
	th.nobg { border-top: 0; border-left: 0; border-right: 1px solid #C1DAD7; background: none; } td { border-right: 1px solid #C1DAD7; border-bottom: 1px solid #C1DAD7; background: #fff; font-size:11px; padding: 6px 6px 6px 12px;color: #4f6b72; } 
	td.alt { color:#797268;border-left: 1px solid #C1DAD7;} 
	th.spec { border-left: 1px solid #C1DAD7; border-top: 0; background:#fff url(images/bullet1.gif) no-repeat; font: 10px "Trebuchet MS",Verdana, Arial, Helvetica; } 
	th.specalt { border-left: 1px solid #C1DAD7; border-top: 0; background: #f5fafa url(images/bullet2.gif)
    no-repeat; font: bold 10px "Trebuchet MS", Verdana, Arial, Helvetica;
    color: #797268; } 
	/*---------for IE 5.x bug*/ html>body td{ font-size:11px;}
</style>
	</head>
     
  <body onload="load()">
                       <%out.println(sb.toString());%>
    <script>
       function onSearch(){
           var dateval = document.getElementById("dateval").value;
           var url = "/app/attendance/orgattendancesearch.jsp?currmonth="+dateval;
           location.href = url;
       }
       function load(){
       var count = 1,start=0;
       var tab=document.getElementById("tab"); 
		  var name=""; 
		  for(var i=1;i <tab.rows.length;i++) { 
		  if(name==tab.rows[i].cells[0].innerHTML) { 
		  count++;
		  
		  if (start == 0) 
		     start = i - 1;
		  tab.rows[start].cells[0].rowSpan=count;
		  tab.rows[i].deleteCell(0);
		  } else { 
		     name = tab.rows[i].cells[0].innerHTML;
		     count=1;
		     start=0;
		  }
		  }
		  } 
       
    </script>
  </body>
</html>

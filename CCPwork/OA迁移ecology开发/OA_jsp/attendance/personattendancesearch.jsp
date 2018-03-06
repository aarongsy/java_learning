<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.attendance.service.AttendanceService" %>
<%@ include file="/base/init.jsp"%>
<%
 String currmonth = StringHelper.null2String(request.getParameter("currmonth"));
 int currm = 0;
 String temp_date = "";
 String temp_date2 = "";
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    AttendanceService attendanceService = (AttendanceService) BaseContext.getBean("attendanceService");
    String attsql = "select substring(date1,1,10) date1,h.objname,(select objname from orgunit where id=h.orgid) orgname, " + 
                    "month(date1) m,attendance,substring(date1,12,9) time1 from Attendance a join humres h " +  
                    "on a.hrmid = h.id where (convert(varchar,year(date1))+'-'+convert(varchar,month(date1))) = ";
    if (StringHelper.isEmpty(currmonth)) {
       attsql += "convert(varchar,year(getdate()))+'-'+convert(varchar,month(getdate()))";
       currm = NumberHelper.string2Int(DateHelper.getCurrentMonth().split("-")[1]);
       temp_date = DateHelper.getCurrentDate();
       temp_date2 = DateHelper.getCurrentMonth();
    } else {
       attsql += "'"+currmonth+"'";
       currm = NumberHelper.string2Int(currmonth.split("-")[1]);
       temp_date = currmonth + "-01";
       temp_date2 = currmonth;
    }
    attsql += " and attendance != 2 and h.id='"+currentuser.getId()+"'";
    
    String humressql = "select h.id hid,h.objname hname,o.id orgid,o.objname orgname from humres h join orgunit o on h.orgid=o.id where h.id='"+currentuser.getId()+"'";
    List humresarr = baseJdbcDao.getJdbcTemplate().queryForList(humressql);
    String hid = "";
    String hname = "";
    String orgid = "";
    String orgname = "";
     if (humresarr.size()>0) {
        hid = StringHelper.null2String(((Map)humresarr.get(0)).get("hid"));
        hname = StringHelper.null2String(((Map)humresarr.get(0)).get("hname"));
        orgid = StringHelper.null2String(((Map)humresarr.get(0)).get("orgid"));
        orgname = StringHelper.null2String(((Map)humresarr.get(0)).get("orgname"));
     }
    String startDate = DateHelper.getFirstDayOfMonthWeek(DateHelper.parseDate(temp_date));
    String endDate = DateHelper.getLastDayOfMonthWeek(DateHelper.parseDate(temp_date));
    List attarr = baseJdbcDao.getJdbcTemplate().queryForList(attsql);
    StringBuffer sb = new StringBuffer("<center><font size=\"4\">我的考勤报表</font></center>");
    sb.append("<table id=\"tab\" cellspacing=\"0\"><caption><input type=\"text\" id=\"dateval\" value=\""+temp_date2+"\" readonly=\"true\" onfocus=\"javascrpt:WdatePicker({dateFmt:'yyyy-M'})\" /> " + 
                       "<input type=\"button\" onclick=\"onSearch();\" value=\"搜索\"/></caption><tbody><tr><th scope=\"col\">姓名："+hname+"</th><th scope=\"col\">部门："+orgname+"</th><th scope=\"col\">考勤月份："+currm+"</th></tr><tr><th scope=\"col\">工作日</th><th scope=\"col\">是否签到</th><th scope=\"col\">签到时间</th></tr>");
    List workdays = attendanceService.getWorkdays(startDate,endDate);
    if (workdays.size() > 0 ) {
      for (int i = 0,j = 0 ; i < workdays.size() ; i++) {
        if (attarr.size()>0 && attarr.size() > j && ((Map)attarr.get(j)) != null && ((Map)attarr.get(j)).get("date1") != null && workdays.get(i).toString().equals(StringHelper.null2String(((Map)attarr.get(j)).get("date1")))) {
          String attendance = StringHelper.null2String(((Map)attarr.get(j)).get("attendance")).equals("1") ? "是" : "否";//是否签到
          String time1 = StringHelper.null2String(((Map)attarr.get(j)).get("time1"));//签到时间
          sb.append("<tr>");
          sb.append("<td>"+workdays.get(i).toString()+"</td>");
          sb.append("<td>"+attendance+"</td>");    
          sb.append("<td>"+time1+"</td>"); 
          sb.append("</tr>");
          j++;
       /**for (Object object : attarr) {
         String date1 = StringHelper.null2String(((Map)object).get("date1"));//日期
         String attendance = StringHelper.null2String(((Map)object).get("attendance")).equals("1") ? "是" : "否";//是否签到
         String time1 = StringHelper.null2String(((Map)object).get("time1"));//签到时间
         sb.append("<tr>");
         sb.append("<td>"+date1+"</td>");
         sb.append("<td>"+attendance+"</td>");    
         sb.append("<td>"+time1+"</td>"); 
         sb.append("</tr>");
       }**/
         } else {
           sb.append("<tr>");
           sb.append("<td>"+workdays.get(i).toString()+"</td>");
           sb.append("<td>否</td>");    
           sb.append("<td></td>"); 
           sb.append("</tr>");
         }
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
     
  <body>
                       <%out.println(sb.toString());%>
    <script>
       function onSearch(){
           var dateval = document.getElementById("dateval").value;
           var url = "/app/attendance/personattendancesearch.jsp?currmonth="+dateval;
           location.href = url;
       }
    </script>
  </body>
</html>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%
String begindatecnd = request.getParameter("bd");
String enddatecnd = request.getParameter("ed");
String userCndID=request.getParameter("userCndID");
String mc = URLDecoder.decode(request.getParameter("mc"));
String bm = URLDecoder.decode(request.getParameter("bm"));
String zt = URLDecoder.decode(request.getParameter("zt"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <%@ include file="/base/init.jsp"%>
    <title></title>


  </head>
  
  <body>
  <%
    List<Map> cdList= new ArrayList<Map>();
    DataService ds = new DataService();
	String sql="select date1,isholiday,isworkday,daytype from holidaysinfo where convert(varchar(10),cast(date1 as datetime),120) between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
	List holidaysList = ds.getValues(sql);
	//请假记录
	sql ="select reqman,requestid,begindate,begintime,enddate,endtime,actualdays from uf_leave x where  reqman='"+userCndID+"' and  begindate between '"+begindatecnd+"' and '"+enddatecnd+"' and  enddate between '"+begindatecnd+"' and '"+enddatecnd+"' and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by begindate";
	List leaveList = ds.getValues(sql);
	//出差记录
	sql ="select reqman,requestid,actualbegindate,actualenddate,actualdays from uf_workout x where  reqman='"+userCndID+"' and actualbegindate between '"+begindatecnd+"' and '"+enddatecnd+"' and  actualenddate between '"+begindatecnd+"' and '"+enddatecnd+"' and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1)";
	List outList = ds.getValues(sql);
	//考勤异常
	sql ="select reqman,requestid,happendate,begintime,endtime,title from uf_specialattendance x where  reqman='"+userCndID+"' and happendate between '"+begindatecnd+"' and '"+enddatecnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by happendate";
	List bugList = ds.getValues(sql);
	//考勤记录
	sql ="select convert(varchar(10),date1,120) date2,date1,hrmid,attendance,time1,convert(varchar,cast(date1 as datetime),108) time2  from  attendance  where hrmid='"+userCndID+"' and attendance='1' and date1 between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";

	List attList = ds.getValues(sql);
	
	int size3=outList.size();
	int size5=attList.size();
	
	String thenowday=begindatecnd;
	while(thenowday.compareToIgnoreCase(enddatecnd)<=0)
	{
	
		//判断是否是节假日，是不明是周末
		if(isWeekEnd(thenowday,holidaysList))
		{
			thenowday=addDate(thenowday);
			continue;
		}
		
		boolean outbool=false;
		//判断是否外出
		for(int k=0 ; k<size3 ; k++) {
			Map m = (Map)outList.get(k);
			String tempdatefrom = StringHelper.null2String(m.get("actualbegindate"),"0") ;
			String tempdateto = StringHelper.null2String(m.get("actualenddate"),"0") ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) >= 0 && thenowday.compareToIgnoreCase(tempdateto)<=0 ) 
			{
				
				outbool=true;
				break;
			}
		}
		if(outbool)
		{
			thenowday=addDate(thenowday);
			continue;
		}
		boolean cdboolexist=false;
		//判断考勤
		for(int k=0 ; k<size5 ; k++) {
			Map m = (Map)attList.get(k);
			String date2 = StringHelper.null2String(m.get("date2"),"0") ;
			String time1 = StringHelper.null2String(m.get("time1"),"0") ;
			String time2 = StringHelper.null2String(m.get("time2"),"0") ;
			String attendance = StringHelper.null2String(m.get("attendance"),"0") ;
			if(thenowday.compareToIgnoreCase(date2) == 0) 
			{
					cdboolexist=true;
					if(time1.compareToIgnoreCase(time2)<0)
					{
						if(isBug(bugList,thenowday,time1,attendance)&&isLeave(leaveList,thenowday,time1,attendance))
						{
							cdList.add(m);
						}				
					}
			}
		}
		thenowday=addDate(thenowday);
	}
	
	
   %>
   
   <table width="100%" border="0">
    <tr>
  	<td align="right" height="40">
  		<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendanceTotal.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=mc%>&bm=<%=bm%>&zt=<%=zt%>&userCndID=<%=userCndID%>"><%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f") %><!-- 返回 --></a>
     </td>
  </tr>
   
  <tr>
    <td align="center" height="40"><span class="STYLE2"><strong><%out.println(begindatecnd+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+enddatecnd+labelService.getLabelNameByKeyId("4028834734b2554c0134b2554d750000")); %></strong></span></td><!-- 迟到明细 -->
  </tr>
</table>
<table style="width:100%;" border="0" cellpadding="0" cellspacing="1" align="center" bgcolor="#000000">
<col width=20%/> <col width=20%/>  <col width=15%/><col width=15%/> <col width=30%/>
  <tr>
    <td  align="center" height="25" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b25a3d0134b25a3dd00000") %></td><!-- 部门名称 -->
    <td  align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b") %></td><!-- 姓名 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019") %></td><!-- 状态 -->
	<td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b273010134b27301cc0000") %></td><!-- 考勤时间 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b274990134b2749a330000") %></td><!-- 签到时间 -->
  </tr>
  <%
   for(int i=0;i<cdList.size();i++){
     Map m = (Map)cdList.get(i);
     String date1 = StringHelper.null2String(m.get("date1"),"0") ;
	 String time1 = StringHelper.null2String(m.get("time1"),"0") ;
   %>
  <tr>
    <td height="25" bgcolor="#FFFFFF"><%=bm%></td>
    <td bgcolor="#FFFFFF"><%=mc%></td>
    <td bgcolor="#FFFFFF"><%=zt%></td>
	<td bgcolor="#FFFFFF"><%=time1 %></td>
    <td bgcolor="#FFFFFF"><%=date1 %></td>
  </tr>
  <%} %>
</table>
<br>
<%@ include file="/app/attendance/include.jsp"%>
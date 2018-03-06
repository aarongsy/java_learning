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

String imagefilename = "/images/hdMaintenance.gif";
String begindatecnd = request.getParameter("bd");
String enddatecnd = request.getParameter("ed");
String userCndID=request.getParameter("userCndID");
String mc = URLDecoder.decode(request.getParameter("mc"));
String bm = URLDecoder.decode(request.getParameter("bm"));
String zt = URLDecoder.decode(request.getParameter("zt"));


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <head>
    <%@ include file="/base/init.jsp"%>
    <title></title>


  </head>
  
  <body>
  <%
    DataService ds = new DataService();
    String sql="select date1,time1 from attendance where hrmid='"+userCndID+"'  and attendance='1' and date1 between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
	System.out.println(sql);
    List inList=ds.getValues(sql);
   %>
   
   <table width="100%" border="0">
   <tr>
  	<td align="right" height="40">
  		<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendanceTotal.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=mc%>&bm=<%=bm%>&zt=<%=zt%>&userCndID=<%=userCndID%>"><%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f") %><!-- 返回 --></a>
     </td>
  </tr>
   
  <tr>
    <td align="center" height="40"><span class="STYLE2"><strong><%out.println(begindatecnd+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+enddatecnd+labelService.getLabelNameByKeyId("4028834734b2554c0134b2554d750000")); %></strong></span></td><!-- 至    迟到明细 -->
  </tr>

</table>
<table style="width:100%;" border="0" cellpadding="0" cellspacing="1" align="center" bgcolor="#000000">
<col width=20%/> <col width=20%/>  <col width=15%/><col width=15%/> <col width=30%/>
  <tr>
    <td  align="center" height="25" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b25a3d0134b25a3dd00000") %></td><!-- 部门名称 -->
    <td  align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b") %></td><!-- 姓名 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b1f3dc000f") %></td><!-- 开始时间 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b24e600012") %></td><!-- 结束时间 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b25eea0134b25eeb170000") %></td><!--  出差天数 -->
  </tr>
  <%
   for(int i=0;i<inList.size();i++){
     Map m = (Map)inList.get(i);
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

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
    List outList= new ArrayList();
    DataService ds = new DataService();
	//请假记录
	String sql ="select reqman,requestid,begindate,begintime,enddate,endtime,actualdays,objname from uf_leave x left join selectitem s on x.reqstyle=s.id where  reqman='"+userCndID+"' and begindate between '"+begindatecnd+"' and '"+enddatecnd+"' and  enddate between '"+begindatecnd+"' and '"+enddatecnd+"' and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by begindate";
	outList = ds.getValues(sql);

   %>
   
   <table width="100%" border="0">
    <tr>
  	<td align="right" height="40">
  		<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendanceTotal.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=mc%>&bm=<%=bm%>&zt=<%=zt%>&userCndID=<%=userCndID%>"><%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f") %><!-- 返回 --></a>
     </td>
  </tr>
   
  <tr>
    <td align="center" height="40"><span class="STYLE2"><strong><%out.println(begindatecnd+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+enddatecnd+labelService.getLabelNameByKeyId("402883d934c0258c0134c0258d050000")); %></strong></span></td><!-- 到   请假明细 -->
  </tr>
</table>
<table style="width:100%;" border="0" cellpadding="0" cellspacing="1" align="center" bgcolor="#000000">
<col width=20%/> <col width=20%/>  <col width=20%/> <col width=20%/><col width=10%/><col width=10%/>
  <tr>
    <td  align="center" height="25" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b25a3d0134b25a3dd00000") %></td><!-- 部门名称 -->
    <td  align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b") %></td><!-- 姓名 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b1f3dc000f") %></td><!-- 开始时间 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b24e600012") %></td><!-- 结束时间 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c027da0134c027db1d0000") %></td><!-- 请假天数 -->
    <td align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c029810134c02981cf0000") %></td><!-- 请假类型 -->
  </tr>
  <%
   for(int i=0;i<outList.size();i++){
     Map m = (Map)outList.get(i);
     String bdate = StringHelper.null2String(m.get("begindate")) ;
     String btime = StringHelper.null2String(m.get("begintime")) ;
     String edate = StringHelper.null2String(m.get("enddate")) ;
     String etime = StringHelper.null2String(m.get("endtime")) ;
     String ac= StringHelper.null2String(m.get("actualdays")) ;
     String lx = StringHelper.null2String(m.get("objname")) ;
   %>
  <tr>
    <td height="25" bgcolor="#FFFFFF"><%=bm%></td>
    <td bgcolor="#FFFFFF"><%=mc%></td>
    <td bgcolor="#FFFFFF"><%=bdate+" "+ btime%></td>
    <td bgcolor="#FFFFFF"><%=edate+" "+etime  %></td>
    <td bgcolor="#FFFFFF"><%=ac %></td>
    <td bgcolor="#FFFFFF"><%=lx %></td>
  </tr>
  <%} %>
</table>
<br>
<%@ include file="/app/attendance/include.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.*"%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<jsp:useBean id="appDao" class="com.eweaver.blog.AppDao"></jsp:useBean>
<%
  Humres user=BaseContext.getRemoteUser().getHumres();
  HumresService humresService = (HumresService)BaseContext.getBean("humresService");
  OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  
  int isSignInOrSignOut=NumberHelper.getIntegerValue(request.getParameter("isSignInOrSignOut"),0).intValue();
  
  String userid=StringHelper.null2String(request.getParameter("userid")); //需要查看的微博(用户)id
  int year=NumberHelper.getIntegerValue(request.getParameter("year"),currentYear).intValue();
  int month=NumberHelper.getIntegerValue(request.getParameter("month"),currentMonth).intValue();
  String monthStr=month<10?("0"+month):(""+month);
  
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  Map blogResultMap=reportManager.getBlogReportByUser(userid,year,month); 
  Map moodResultMap=reportManager.getMoodReportByUser(userid,year,month); 

  List reportList=(List)blogResultMap.get("reportList");
  List moodReportList=(List)moodResultMap.get("reportList");
  
  List totaldateList=(List)blogResultMap.get("totaldateList");          //当月总的天数
  int totalWorkday=((Integer)blogResultMap.get("totalWorkday")).intValue();    //当月工作日总数
  int totalUnsubmit=((Integer)blogResultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
  double workIndex=((Double)blogResultMap.get("workIndex")).doubleValue();        //工作指数
  double moodIndex=((Double)moodResultMap.get("moodIndex")).doubleValue();    //心情指数
  
%>
<table id="reportList" style="width:100%;;border-collapse:collapse;margin-top: 3px"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	  <!-- 日期行  -->
	  <tr style="background: url('images/report-head-bg.png');background-repeat: repeat-x;" height="20px">
	    <td style="width:55px" nowrap="nowrap"></td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	  int day=((Integer)totaldateList.get(i)).intValue();
	    	  if(i<reportList.size()){
	    		  Map map=(Map)reportList.get(i);
		    	  boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
		    	  if(isWorkday){
		%>
		      <td class="tdWidth" nowrap="nowrap"><%=day%></td>
		<%    		  
		    	  }
	    	  }else{
	    %>
	          <td class="tdWidth" nowrap="nowrap"><%=day%></td>
	    <%}}%>
	    <td style="width: 5%" align="center">指数</td><!-- 指数 -->
	</tr>
	<!-- 日期行  -->
	
	<!-- 微博报表  -->
	<tr class="item1">
	    <td>微博报表</td> <!-- 微博报表 -->
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    %>
	     <%if(isWorkday){%>
		    <td align="center" >
		       <%if(isSubmited){%>
		        <div><img src="images/submit-ok.png" /></div>
		       <%}else{ %>
		        <div><img src="images/submit-no.png" /></div> 
		       <%} %> 
		    </td>
		  <%}else{%>
		    
	    <%}}else{%>
	       <td >&nbsp;</td>
	    <%}
	    }%>
	    <td><span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday%>天"><%=reportManager.getReportIndexStar(workIndex)%></span><span style="font-weight: bold;margin-left: 3px;color: #666666"><%=workIndex%></span><a href="javascript:openChart('blog','<%=userid %>',<%=year%>,1,'<%=humresService.getHrmresNameById(userid)%>微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
		<!-- 微博报表  -->
		<%if(appDao.getAppVoByType("mood").isActive()) {%>
	<tr class="item1">
	    <td>心情报表</td><!-- 心情报表 -->
	    
	    <%
	    int happyDays=((Integer)moodResultMap.get("happyDays")).intValue();
	    int unHappyDays=((Integer)moodResultMap.get("unHappyDays")).intValue();
	    for(int i=0;i<totaldateList.size();i++){ 
	    	if(i<reportList.size()){
	    	   Map map=(Map)moodReportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    	   String faceImg=(String)map.get("faceImg");
	    	   if(isWorkday){
	    	   %>
	    		<td align="center"">
	    			 <%if(isSubmited&&!"".equals(faceImg)){%>
			        	<div><img src="<%=faceImg %>" /></div>
			       	<%}else{ %>
			        	
			       	<%} %> 
	    		</td>
	    		<%}else{ %>
	    		
	    		<%}}else{ %>
	    		<td>&nbsp;</td>
	    		<%} %>
	    	
	    <%} %>
	    
	    <td><span title="不高兴<%=unHappyDays%>天高兴<%=happyDays%>天"><%=reportManager.getReportIndexStar(moodIndex)%></span><span style="font-weight: bold;margin-left: 3px;color: #666666"><%=moodIndex%></span><a href="javascript:openChart('mood','<%=userid%>',<%=year%>,1,'<%=humresService.getHrmresNameById(userid)%>心情报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	 </tr>
	 <%} 
	  if(isSignInOrSignOut==1){
		  Map schedulrResultMap=reportManager.getScheduleReportByUser(userid,year,month); 
		  List scheduleReportList=(List)schedulrResultMap.get("reportList"); 
		  double scheduleIndex=((Double)schedulrResultMap.get("scheduleIndex")).doubleValue();    //考勤指数
		  int totalAbsent=((Integer)schedulrResultMap.get("totalAbsent")).intValue();        //旷工总天数
		  int totalLate=((Integer)schedulrResultMap.get("totalLate")).intValue();            //迟到总天数
	 %>
	<tr class="item1">
	    <td>考勤报表</td><!-- 考勤报表 -->
	    <%for(int i=0;i<totaldateList.size();i++){ 
	    	if(i<reportList.size()){
	    	   Map map=(Map)scheduleReportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isLate=((Boolean)map.get("isLate")).booleanValue();
	    	   boolean isAbsent=((Boolean)map.get("isAbsent")).booleanValue();
	    	   if(isWorkday){
	    	   %>
	    		<td align="center">
	    			 <%if(isLate){%>
			        	<div><img width="18px" src="images/sign-no.png"/></div>
			       	<%}else if(isAbsent){ %>
			        	<div><img width="18px"  src="images/sign-absent.png"/></div>
			       	<%}else { %> 
			       	    <div><img width="18px"  src="images/sign-ok.png" /></div>
			       	<%} %>
	    		</td>
	    		<%}else{ %>
	    		
	    		<%}}else{ %>
	    		<td>&nbsp;</td>
	    		<%} %>
	    	
	    <%} %> 
	    <td><span title="旷工<%=totalAbsent%>次迟到<%=totalLate %>次共<%=totalWorkday%>个工作日"><%=reportManager.getReportIndexStar(scheduleIndex)%></span><span style="font-weight: bold;margin-left: 3px;color: #666666"><%=scheduleIndex%></span><a href="javascript:openChart('schedule','<%=userid%>',<%=year%>,1,'<%=humresService.getHrmresNameById(userid)%>考勤报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
	<%} %>
 </table> 


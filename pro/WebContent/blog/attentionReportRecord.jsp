<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="com.eweaver.blog.BlogManager"%>

<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>

<%
  Humres user=BaseContext.getRemoteUser().getHumres();
  HumresService humresService = (HumresService)BaseContext.getBean("humresService");
  OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  String userid=""+user.getId();
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  String type=StringHelper.null2String(request.getParameter("type"));
  int year=NumberHelper.getIntegerValue(request.getParameter("year"),currentYear).intValue();
  int month=NumberHelper.getIntegerValue(request.getParameter("month"),currentMonth).intValue();
  String monthStr=month<10?("0"+month):(""+month);
  
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  Map resultMap=new HashMap();
  int allUnsubmit=0;
  int allWorkday=0;
  double allWorkIndex=0;
  if("blog".equals(type)){
	  resultMap=reportManager.getBlogAttentionReport(userid,year,month);
	  allUnsubmit=((Integer)resultMap.get("allUnsubmit")).intValue();      //被关注人未提交总数
	  allWorkday=((Integer)resultMap.get("allWorkday")).intValue();      //被关注人未提交总数
	  allWorkIndex=((Double)resultMap.get("allWorkIndex")).doubleValue();      //被关注人未提交总数
  }else if("mood".equals(type)){
	  resultMap=reportManager.getMoodAttentionReport(userid,year,month);
  }else{
	  out.println("无数据可显示");
	  return;
  }
  List resultList=(List)resultMap.get("resultList");          //统计结果
  List totaldateList=(List)resultMap.get("totaldateList");          //当月总的天数
  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
  
  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //有效日期统计list
  List resultCountList=(List)resultMap.get("resultCountList"); //有效日期统计list
  
  int total=resultList.size();
%>
	<div id="blogReportDiv" class="reportDiv" style="overflow-x: auto;width: 100%;">
	 <table id="reportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px;"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
 	<tr style="background: url('images/report-head-bg.png');background-repeat: repeat-x;" height="20px">
	    <td style="width:8%;min-width: 80px" class="tdWidth"  nowrap="nowrap"> 
	      <div style="float: left;">
	           <input type="checkbox"  onclick="selectBox(this)" title="全选"/>  <!-- 全选 -->
	       </div>
	       <div style="float: left;">
			   <a class="btnEcology" id="compareBtn"  href="javascript:void(0)" onclick="compareChart('blogReportDiv','关注报表','<%=type %>')">
				 <div class="left" style="width:45px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span>对比</span></div><!-- 对比 -->
				 <div class="right"> &nbsp;</div>
			   </a>
		  </div>
	    </td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	  int day=((Integer)totaldateList.get(i)).intValue();
	    	  if(i<isWorkdayList.size()){
	    		  boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    	  if(isWorkday){
		%>
		      <td class="tdWidth" nowrap="nowrap"><%=day%></td>
		<%    		  
		    	  }
	    	  }else{
	    %>
	          <td class="tdWidth" nowrap="nowrap"><%=day%></td>
	    <%}}%>
	    
	    <td style="width: 5%" align="center">
	    	<%if("blog".equals(type)) {%>
	    	工作指数<!-- 工作指数 -->
	    	<%} else if("mood".equals(type)){%>
	    		心情指数<!-- 心情指数 -->
	    	<%} else{%>
	    		考勤指数<!-- 考勤指数 -->
	    	<%} %>
	    </td>
	</tr>
	<%
	  
	  if("blog".equals(type)){
		  for(int i=0;i<resultList.size();i++){
	    	  Map reportMap=(Map)resultList.get(i);
	    	  String attentionid=(String)reportMap.get("attentionid");
	    	  List reportList=(List)reportMap.get("reportList");
	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    	  double workIndex=((Double)reportMap.get("workIndex")).doubleValue();
	    	  String attentionName = humresService.getHrmresNameById(attentionid);
	  %>
	  <tr class="item1">
	     <td><input type="checkbox" conType="1" conValue="<%=attentionid%>" attentionid="<%=attentionid%>" class="condition" /><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=attentionName %>的微博','blog_<%=attentionid%>')" ><%=attentionName%></a></td>
	  <%
	     for(int j=0;j<totaldateList.size();j++){
	       if(j<isWorkdayList.size()){	 
	         boolean isWorkday=((Boolean)isWorkdayList.get(j)).booleanValue();
	         boolean isSubmited=((Boolean)reportList.get(j)).booleanValue();
	  %> 
	       <%if(isWorkday){%>
		    <td align="center">
		       <%if(isSubmited){%>
		        <div><img src="images/submit-ok.png" /></div>
		       <%}else{ %>
		        <div><img src="images/submit-no.png" /></div> 
		       <%} %> 
		    </td>
		  <%}else{%>
	  <%}}else{%>
	        <td >&nbsp;</td>
	 <%}}%>
	    <td>
	     <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=attentionName %>的微博','blog_<%=attentionid%>')" class="index"><span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday%>天"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=attentionid%>',<%=year%>,'1','<%=humresService.getHrmresNameById(attentionid)%>微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	 </tr>
	 <% }%>
	 <tr>
	    <td align="left">总计</td><!-- 总计 -->
	<%
	  for(int i=0;i<totaldateList.size();i++){
		  if(i<isWorkdayList.size()){	 
		    boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    int unsubmit=((Integer)resultCountList.get(i)).intValue();
		    if(isWorkday){
	%>
	      <td align="center" style="width: 18px;"><span style="color:red"><%=unsubmit%></span>/<%=total%></td>
	<% 	    	
		    }else{
    %>
    <%		    	
		    }
	}else{
	%>
	      <td>&nbsp;</td>
	<%	
	}
	  }
	%>    
	    <td><span title="未提交<%=allUnsubmit%>天应提交<%=allWorkday%>天"><%=reportManager.getReportIndexStar(allWorkIndex)%></span><%=allWorkIndex%></td>
	</tr>
	<%}else if("mood".equals(type)){
			for(int i=0;i<resultList.size();i++){
		    	  Map reportMap=(Map)resultList.get(i);
		    	  String attentionid=(String)reportMap.get("attentionid");
		    	  List reportList=(List)reportMap.get("reportList");
		    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    		  double moodIndex=((Double)reportMap.get("moodIndex")).doubleValue();
	    		  int happyDays=((Integer)reportMap.get("happyDays")).intValue();
	    		    int unHappyDays=((Integer)reportMap.get("unHappyDays")).intValue();
	    		    String attentionName = humresService.getHrmresNameById(attentionid);
	    		  %>
	    		  <tr class="item1">
	    		     <td><input type="checkbox" conType="1" conValue="<%=attentionid%>" class="condition" /><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=attentionName %>的微博','blog_<%=attentionid%>')"><%=attentionName%></a></td>
	    		  <%
	    		     for(int j=0;j<totaldateList.size();j++){
	    		       if(j<isWorkdayList.size()){	 
	    		         boolean isWorkday=((Boolean)isWorkdayList.get(j)).booleanValue();
	    		         String faceImg=(String)reportList.get(j);
	    		  			%> 
	    		       <%if(isWorkday){%>
	    			    <td align="center">
	    			       <%if("".equals(faceImg)){%>
	    			        &nbsp;
	    			       <%}else{ %>
	    			        <div><img src="<%=faceImg %>" /></div> 
	    			       <%} %> 
	    			    </td>
	    			  <%}else{%>
	    		  <%}}else{%>
	    		        <td >&nbsp;</td>
	    		 <%}}%>
	    		    <td>
	    		     <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=attentionName %>的微博','blog_<%=attentionid%>')" class="index" ><span title="不高兴<%=unHappyDays%>天高兴<%=happyDays%>天"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=attentionid%>',<%=year%>,'1','<%=humresService.getHrmresNameById(attentionid)%>心情报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	    		 </tr>
	    		  
	    <%
	    	  }
		%>
		<tr>
	    <td align="left">总计</td><!-- 总计 -->
	<%
	 for(int i=0;i<totaldateList.size();i++){
		  if(i<isWorkdayList.size()){	 
		    boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    int unHappy=((Integer)((HashMap)resultCountList.get(i)).get("unhappy")).intValue();
		    int happy=((Integer)((HashMap)resultCountList.get(i)).get("happy")).intValue();
		    if(isWorkday){
	%>
	      <td align="center" style="width: 18px;"><span style="color:red"><%=unHappy%></span>/<%=unHappy+happy%></td>
	<% 	    	
		    }else{
    %>
    <%		    	
		    }
	}else{
	%>
	      <td>&nbsp;</td>
	<%	
	}
	  }
	%>    
	    <td><span title="不高兴<%=resultMap.get("totalUnHappyDays") %>天高兴<%=resultMap.get("totalHappyDays") %>天"><%=reportManager.getReportIndexStar(((Double)resultMap.get("totalMoodIndex")).doubleValue())%></span><%=resultMap.get("totalMoodIndex") %></td>
	</tr>
		<%} %>  
	  
	
	</table>
  </div>	
 

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%--<%@page import="weaver.hrm.company.SubCompanyComInfo"%>--%>
<%--<%@page import="weaver.hrm.company.DepartmentComInfo"%>--%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>

<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.util.StringHelper"%>

<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<%
  String userid=""+user.getId();
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  
  int year=NumberHelper.getIntegerValue(request.getParameter("year"),currentYear).intValue();
  int month=NumberHelper.getIntegerValue(request.getParameter("month"),currentMonth).intValue();
  String monthStr=month<10?("0"+month):(""+month);
  
  String isAppend=StringHelper.null2String(request.getParameter("isAppend"));
  String isExtend=StringHelper.null2String(request.getParameter("isExtend"));
  String value=StringHelper.null2String(request.getParameter("value"));
  //String index=StringHelper.null2String(request.getParameter("index"));
  String tempid=StringHelper.null2String(request.getParameter("tempid"));
  String conditionid=StringHelper.null2String(request.getParameter("conditionid"));
  String reportType=StringHelper.null2String(request.getParameter("reportType"));
  String type=StringHelper.null2String(request.getParameter("type"));

  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
%>
<%
 if(type.equals("1")){
	 Map resultMap=new HashMap();
	 if("blog".equals(reportType)){
		 resultMap= reportManager.getBlogReportByUser(value,year,month); 
	 }
	 else if("mood".equals(reportType)){
		 resultMap=reportManager.getMoodReportByUser(value,year,month);
	 }
	 conditionid=reportManager.addTempCondition(tempid,type,value);
	 List reportList=(List)resultMap.get("reportList");
	 List totaldateList=(List)resultMap.get("totaldateList");    //当月总的天数
	 int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
	 int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
	 
 if(isAppend.equals("false")){
%>
   <table id="blogReportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	  <!-- 日期行  -->
	  <tr style="background: url('images/report-head-bg.png');background-repeat: repeat-x;" height="20px">
	    <td style="width:120px" class="tdWidth" nowrap="nowrap">
	        <div style="float: left;">
              <input type="checkbox"  onclick="selectBox(this)" conType="<%=type%>" conValue="<%=value%>" title="全选"/>  <!-- 全选 -->
             </div>
	        <div style="float: left;">
			   <a class="btnEcology" id="compareBtn"  href="javascript:void(0)" onclick="compareChart('blogReportList','<%=reportType%>')"> <!-- 自定义报表 -->
				 <div class="left" style="width:45px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span>对比</span></div><!-- 对比 -->
				 <div class="right"> &nbsp;</div>
			   </a>
		     </div>
	    </td>
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
	    <td style="width: 5%" align="center">
	    <%if("blog".equals(reportType))
		    out.println("工作指数");
	     else
	    	out.println("心情指数");
	    %>
	    </td><!-- 工作指数 心情指数 -->
	</tr>
<%} %>	
	<!-- 日期行  -->
	<%if("blog".equals(reportType)){ 
		 double workIndex=((Double)resultMap.get("workIndex")).doubleValue();  
	%>
	<!-- 微博报表  -->
	<tr class="item<%=conditionid%>">
	    <td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=value%>"/><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=value%>','<%=humresService.getHrmresNameById(value) %>的微博','blog_<%=value%>')" class="index" ><%=humresService.getHrmresNameById(value)%></a><img src="images/delete.png" onclick="delCon(this,<%=conditionid%>)" style="margin-left: 3px;width:12px;cursor: pointer;" align="absmiddle"/></td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
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
	    <%}
	    }%>
	    <td><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=value%>','<%=humresService.getHrmresNameById(value) %>的微博','blog_<%=value%>')" class="index" ><span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday%>天"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=value%>',<%=year%>,<%=type%>,'<%=humresService.getHrmresNameById(value)%>微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
		<%
			}else{ 
				int happyDays=((Integer)resultMap.get("happyDays")).intValue();
    		    int unHappyDays=((Integer)resultMap.get("unHappyDays")).intValue();
				double	moodIndex=((Double)resultMap.get("moodIndex")).doubleValue();
		%>
			<tr class="item<%=conditionid%>">
	    		<td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=value%>"/><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=value%>','<%=humresService.getHrmresNameById(value) %>的微博','blog_<%=value%>')" class="index"><%=humresService.getHrmresNameById(value)%></a><img src="images/delete.png" onclick="delCon(this,<%=conditionid%>)" style="margin-left: 3px;width:12px;cursor: pointer;" align="absmiddle"/></td>
			<% 
				 for(int i=0;i<totaldateList.size();i++){ 
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    	   String faceImg=(String)map.get("faceImg");
	    	   if(isWorkday){
	    	   %>
	    		<td align="center"> 
	    			       <%if("".equals(faceImg)){%>
	    			        &nbsp;
	    			       <%}else{ %>
	    			        <div><img src="<%=faceImg %>" /></div> 
	    			       <%} %> 
	    	     </td>
	    		<%}else{ %>
	    		<%}}else{ %>
	    		<td>&nbsp;</td>
	    		<%} %>
	    	
	    <%} %>
	    <td>
	       <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=value%>','<%=humresService.getHrmresNameById(value) %>的微博','blog_<%=value%>')" class="index" ><span title="不高兴<%=unHappyDays%>天高兴<%=happyDays%>天"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=userid %>',<%=year%>,1,'<%=humresService.getHrmresNameById(value)%>心情报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
		<%} %>
		<!-- 微博报表  -->
  <%
  if(isAppend.equals("false")){
  %>
	</table>
 <%} %>	
 
 <%}else if(type.equals("2")||type.equals("3")){
 if(!isExtend.equals("true")){	 
  Map resultMap= reportManager.getOrgReportCount(userid,value,type,year,month); 
  
  if(resultMap==null){
	out.print("null");
	return ;
  }
  conditionid=reportManager.addTempCondition(tempid,type,value);
  List resultCountList=(List)resultMap.get("resultCountList");
  List isWorkdayList=(List)resultMap.get("isWorkdayList");
  List totaldateList=(List)resultMap.get("totaldateList");
  int totalAttention=((Integer)resultMap.get("totalAttention")).intValue();
  int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();
  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();
  double workIndex=((Double)resultMap.get("workIndex")).doubleValue();
  String orgName=orgunitService.getOrgunitName(value);
  if(isAppend.equals("false")){
 %>
  	<table id="blogReportList" style="width:100%;;border-collapse:collapse;margin-top: 3px"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	    <tr style="background: url('images/report-head-bg.png');background-repeat: repeat-x;" height="20px">
		    <td style="width: 8%" class="tdWidth" nowrap="nowrap">
	         <div style="float: left;">
               <input type="checkbox"  onclick="selectBox(this)" conType="<%=type%>" conValue="<%=value%>" title="全选"/>  <!-- 全选 -->
             </div>
	         <div style="float: left;">
			   <a class="btnEcology" id="compareBtn"  href="javascript:void(0)" onclick="compareChart('blogReportList','<%=reportType%>')"> <!-- 自定义报表 -->
				 <div class="left" style="width:45px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span>对比</span></div><!-- 对比 -->
				 <div class="right"> &nbsp;</div>
			   </a>
		     </div>
		   </td>
		    <%
	        for(int i=0;i<totaldateList.size();i++){
	          int day=((Integer)totaldateList.get(i)).intValue();	
	    	  if(i<resultCountList.size()){
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
		    <td style="width: 5%" align="center">工作指数</td><!-- 工作指数 -->
	    </tr>
  <%} %>	    
	    <tr class="item">
	    <td align="left"><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=value%>"/><span style="cursor: pointer;" onclick="extendRecord(this,<%=value%>,<%=type%>,<%=year%>,<%=month %>,<%=conditionid%>,'<%=reportType %>')" extend="false" isLoad='false'><img src="images/extend.png"/><%=orgName%></span><img src="images/delete.png" onclick="delCon(this,<%=conditionid%>)" style="margin-left: 3px;width:12px" align="absmiddle"/></td>
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unsubmit=((Integer)resultCountList.get(i)).intValue();
	        	if(isWorkday){
	    %>
	            <td align="center" style="width: 18px;"><span style="color:red"><%=unsubmit%></span>/<%=totalAttention%></td>
	    <%   		
	        	}
	    %>
	    <%    		
	        }else{
	    %>
	            <td>&nbsp;</td>
	    <%    	
	        }
	    } %>
	    <td><span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday*totalAttention%>天"><%=reportManager.getReportIndexStar(workIndex)%></span><%=workIndex%><a href="javascript:openChart('blog','<%=value%>',<%=year%>,<%=type%>,'<%=orgName%>微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
  <%if(isAppend.equals("false")){ %>	
	</table>  
  <%}}else{ 
	  if("blog".equals(reportType)){
	  Map resultMap=reportManager.getOrgReportRecord(userid,value,type,year,month);
	  
	  if(resultMap==null){
			out.print("null");
			return ;
	  }	  
	  List resultList=(List)resultMap.get("resultList");          //统计结果
	  List totaldateList=(List)resultMap.get("totaldateList");          //当月总的天数
	  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
	  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //有效日期统计list
	  for(int i=0;i<resultList.size();i++){
	    	  Map reportMap=(Map)resultList.get(i);
	    	  String attentionid=(String)reportMap.get("attentionid");
	    	  List reportList=(List)reportMap.get("reportList");
	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    	  double workIndex=((Double)reportMap.get("workIndex")).doubleValue();
	  %>
	  <tr class="item<%=conditionid%>">
	     <td class="name"><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=humresService.getHrmresNameById(attentionid) %>的微博','blog_<%=attentionid%>')" class="index" ><%=humresService.getHrmresNameById(attentionid)%></a></td>
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
	     <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=humresService.getHrmresNameById(attentionid) %>的微博','blog_<%=attentionid%>')" class="index" ><span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday%>天"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=attentionid%>',<%=year%>,1,'<%=humresService.getHrmresNameById(attentionid)%>微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	 </tr>
	<%} 
     	}else if("mood".equals(reportType)){
     		Map resultMap=reportManager.getOrgMoodReportRecord(userid,value,type,year,month);
     		  
     		  if(resultMap==null){
     				out.print("null");
     				return ;
     		  }	  
     		  List resultList=(List)resultMap.get("resultList");          //统计结果
     		  List totaldateList=(List)resultMap.get("totaldateList");          //当月总的天数
     		  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
     		  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //有效日期统计list

       		
       		 for(int i=0;i<resultList.size();i++){
  	   	    	  Map reportMap=(Map)resultList.get(i);
  	   	    	  String attentionid=(String)reportMap.get("attentionid");
  	   	    	  List reportList=(List)reportMap.get("reportList");
  	   	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
  	   	    	  double workIndex=((Double)reportMap.get("moodIndex")).doubleValue();
  	   	    	  double moodIndex=((Double)reportMap.get("moodIndex")).doubleValue();
  	   	    	
	 	   	   int happyDays=((Integer)reportMap.get("happyDays")).intValue();
	 		    int unHappyDays=((Integer)reportMap.get("unHappyDays")).intValue();
  	   	    	 %>
  	   	    	 <tr class="item<%=conditionid%>">
  	    			 <td class="name"><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=humresService.getHrmresNameById(attentionid) %>的微博','blog_<%=attentionid%>')" class="index" ><%=humresService.getHrmresNameById(attentionid)%></a></td>
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
	    		     <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=humresService.getHrmresNameById(attentionid) %>的微博','blog_<%=attentionid%>')" class="index" ><span title="不高兴<%=unHappyDays%>天高兴<%=happyDays%>天"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=attentionid%>',<%=year%>,'1','<%=humresService.getHrmresNameById(attentionid)%>心情报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
  	    		</tr>
  	   	    	 <%
     	    	}
     	}
	  %>
	  
	  <%
	  }
 }%>
 

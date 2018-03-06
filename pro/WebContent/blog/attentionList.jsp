<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.AppItemVo"%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogReplyVo"%>
<%@page import="com.eweaver.blog.AppDao"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<%
    String userid=""+user.getId();
	String workDate=StringHelper.null2String(request.getParameter("workDate"));
    String blogType = StringHelper.null2String(request.getParameter("blogType"));
    String name = StringHelper.null2String(request.getParameter("name"));
    BlogManager blogManager=new BlogManager(user);
    SimpleDateFormat datefrm=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat monthDayFormater=new SimpleDateFormat("M月dd日");
    SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Map map=blogManager.getAttentionDiscussMap(""+user.getId(),workDate); 
    
    Date today=new Date();
	long   todaytime=datefrm.parse(datefrm.format(today)).getTime(); 
	long   worktime=datefrm.parse(workDate).getTime(); 

	long sepratorday=(todaytime-worktime)/(24*60*60*1000);
	
    
    List resultList=(List)map.get("resultList");
    Map  discussMap=(Map)map.get("discussMap");
    
   	BlogDao blogDao=new BlogDao();
    AppDao appDao=new AppDao();
    boolean moodIsActive=appDao.getAppVoByType("mood").isActive();
    
    //周一 周二 周三 周四 周五 周六 周日
    String []week={"周日","周一","周二","周三","周四","周五","周六"};
%>
<table width="100%" style="TABLE-LAYOUT: fixed;">
  <tr>
  <td valign="top" width="75px" nowrap="nowrap">
     <div class="dateArea">
				<%if(workDate.equals(datefrm.format(new Date()))){ %>
					<div class="day">今天</div><!-- 今天 -->
				<%} else{%>
					<div class="day"><%=week[datefrm.parse(workDate).getDay()] %></div>
				<%
					
				} %>			
				<div class="yearAndMonth"><%=monthDayFormater.format(datefrm.parse(workDate)) %></div>
     </div>
     <%if(sepratorday<7){ %>
	     <div style="width: 100%;text-align: center;cursor: pointer;" onclick="unSumitRemindAll(this,'<%=user.getId()%>','<%=workDate%>')">
	        <a>全部提醒</a><!-- 全部提醒 -->
	     </div>				
     <%} %>
  </td>
  <td valign="top" style="padding-top: 4px">
  <div class="listArea">
<% for(int i=0;i<resultList.size();i++){ 
	String attentionid=(String)resultList.get(i);
	BlogDiscessVo discessVo=(BlogDiscessVo)discussMap.get(attentionid);
	String discussid=discessVo.getId();
%>
	<%if(discussid!=null) {
	%>
	<div class="reportItem" userid="<%=discessVo.getUserid()%>" forDate="<%=discessVo.getWorkdate() %>" id="<%=discessVo.getId()%>" tid="<%=discessVo.getId() %>" style="margin-bottom: 10px;float: left;width: 100%">
           <div class="discussView">
			<div class="sortInfo">
			  <span style="float: left;">
				<span class="name">&nbsp;<a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=discessVo.getUserid()%>','<%=discessVo.getUsername() %>的微博','blog_<%=discessVo.getUserid()%>')" ><%=discessVo.getUsername()  %></a>&nbsp;</span>
				<%if("0".equals(discessVo.getIsReplenish())){ %>
						<div class="state ok"></div>
						<span class="datetime">
							提交于&nbsp;<!-- 提交于 -->
						</span>
					<%}else { %>
						<div class="state after"></div>
						<span class="datetime">
							补交于&nbsp;<!-- 补交于 -->
						</span>
					<%} %>
					<!-- 上级评分 -->
						<span style='width: 100px' score='<%=discessVo.getScore()%>' readOnly='<%=StringHelper.null2String(humresService.getHumresById(attentionid).getManager()).indexOf(user.getId())==-1%>' discussid='<%=discussid%>' target='blog_raty_keep_<%=discussid%>' class='blog_raty' id='blog_raty_<%=discussid%>'></span>
				<!-- 心情 -->	
				<%if(moodIsActive){ 
					AppItemVo  appItemVo=appDao.getappItemByDiscussId(discussid);
					if(appItemVo!=null){
						String itemName1=appItemVo.getItemName();
	  						if(NumberHelper.getIntegerValue(itemName1).intValue()==26917){
	  							 itemName1="高兴";
	  						}else{
	  							 itemName1="不高兴";
	  						}
				%>
					<img style="margin-left: 2px;margin-right: 2px" width="16px" src="<%=appItemVo.getFaceImg()%>" alt="<%=itemName1%>"/>
				<%}} %>
				</span>
				<span class="sortInfoRightBar" >
				  <a href="javascript:void(0)" onclick="showReplySubmitBox(this,'<%=discessVo.getId() %>',{'uid':'<%=user.getId() %>','level':'0'},0)">评论</a><!-- 评论 -->
				  <a href="javascript:void(0)" onclick="showReplySubmitBox(this,'<%=discessVo.getId() %>',{'uid':'<%=user.getId() %>','level':'0'},1)">私评</a><!-- 私评 -->
				</span>
			</div>
			<div class="clear reportContent">
				<%=discessVo.getContent() %>
			</div>
			<%
			List replayList2=blogDao.getReplyList(discessVo.getUserid(),discessVo.getWorkdate(),userid); 
			if(replayList2.size()>0){
			%>
			<!-- 回复 -->
			<div class="reply" > 
				<%
				BlogReplyVo replyVo=new BlogReplyVo();
				for(int j=0;j<replayList2.size();j++){
					replyVo=(BlogReplyVo)replayList2.get(j);
					
					String replyComefrom=replyVo.getComefrom();
					String commentType=replyVo.getCommentType();
					String replyComefromTemp="";
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp="(";
				    if(commentType.equals("1"))	
				    	   replyComefromTemp+="私评";
				    	
					if(replyComefrom.equals("1"))  
						replyComefromTemp+="&nbsp;来自Iphone";
					else if(replyComefrom.equals("2"))  
						replyComefromTemp+="&nbsp;来自Ipad)";
					else if(replyComefrom.equals("3"))  
						replyComefromTemp+="&nbsp;来自Android";          
					else if(replyComefrom.equals("4"))  
						replyComefromTemp+="&nbsp;来自Web手机版";
				         
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp+=")";
					
				%>
			  <div id="re_<%=replyVo.getId()%>">
				<div class="sortInfo replyTitle">
						<span class="name">&nbsp;<a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=replyVo.getUserid() %>','<%=replyVo.getUsername() %>的微博','blog_<%=replyVo.getUserid()%>')" ><%=replyVo.getUsername()%></a>&nbsp;</span>
						<div class="state re"></div>
						<span class="datetime">
							<%=replyVo.getCreatedate()+" " + replyVo.getCreatetime()%>&nbsp;<!-- 评论于 -->
							<span class="comefrom"><%=replyComefromTemp%></span>
						</span>
						<span class="sortInfoRightBar">
							<%if((""+user.getId()).equals(replyVo.getUserid())&&j==replayList2.size()-1){
								long sepratorTime=(today.getTime()-dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime()).getTime())/(1000*60);
								if(sepratorTime<=10){
							%>
								<a href='javascript:void(0)' class='deleteOperation' onclick="deleteDiscuss(this,'<%=discussid%>','<%=replyVo.getId()%>')">删除</a><!-- 删除 -->
							<%}} %>
							<a href="javascript:void(0)"  onclick="showReplySubmitBox(this,'<%=discussid%>',{'uid':'<%=replyVo.getUserid()%>','name':'<%=replyVo.getUsername()%>','level':'1','replyid':'<%=replyVo.getId() %>'},0)">评论</a><!-- 评论 -->
						    <a href="javascript:void(0)"  onclick="showReplySubmitBox(this,'<%=discussid%>',{'uid':'<%=replyVo.getUserid()%>','name':'<%=replyVo.getUsername()%>','level':'1','replyid':'<%=replyVo.getId() %>'},1)">私评</a><!-- 私评 -->
						</span>
					</div>
					<div class="clear reportContent">
						<%=replyVo.getContent()%>
					</div>
				</div>
				<%if(j<replayList2.size()-1){%>
				  <div class="dotedline"></div>
				<%} %>
			<%} %>
			</div>
	<%} %>
	</div>
	<div class="commitBox"></div>
</div>
<%}else{ %>
<div class="reportItem" tid="0" userid="<%=discessVo.getUserid()%>" forDate="<%=discessVo.getWorkdate() %>" style="margin-bottom:6px;">
    <div class="discussView">
		<div class="sortInfo" style="height: 20px;float: none;">
		 <span>
		 
			<span class="name">&nbsp;<a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid %>','<%=humresService.getHrmresNameById(attentionid) %>的微博','blog_<%=attentionid%>')"><%=humresService.getHrmresNameById(attentionid) %></a>&nbsp;</span>
			<div class="state no"></div>
			<span class="unSumit">
				&nbsp;未提交&nbsp;<!-- 未提交 -->
			</span>
		</span>
		<span class="sortInfoRightBar">
			<%if(sepratorday<7){ %>
				<span class="unSumitRemind" attentionid="<%=attentionid%>" style="cursor: pointer" onclick="unSumitRemind(this,'<%=attentionid%>','<%=user.getId()%>','<%=workDate%>');">
					<a class="remindOperation">提醒</a><!-- 提醒 -->
				</span>
			<%} %>
			<a href="javascript:void(0)" onclick="showReplySubmitBox(this,0,{'uid':'<%=discessVo.getUserid()%>','level':'0'},0)">评论</a><!-- 评论 -->
			<a href="javascript:void(0)" onclick="showReplySubmitBox(this,0,{'uid':'<%=discessVo.getUserid()%>','level':'0'},1)">私评</a><!-- 私评 -->
		</span>
	</div>
	<div class="clear reportContent"></div>
		<%
			List replayList2=blogDao.getReplyList(discessVo.getUserid(),discessVo.getWorkdate(),userid); 
			if(replayList2.size()>0){
			%>
			<!-- 回复 -->
			<div class="reply" > 
				<%
				BlogReplyVo replyVo=new BlogReplyVo();
				for(int j=0;j<replayList2.size();j++){
					replyVo=(BlogReplyVo)replayList2.get(j);
					
					String replyComefrom=replyVo.getComefrom();
					String commentType=replyVo.getCommentType();
					String replyComefromTemp="";
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp="(";
				    if(commentType.equals("1"))	
				    	   replyComefromTemp+="私评";
				    	
					if(replyComefrom.equals("1"))  
						replyComefromTemp+="&nbsp;来自Iphone";
					else if(replyComefrom.equals("2"))  
						replyComefromTemp+="&nbsp;来自Ipad)";
					else if(replyComefrom.equals("3"))  
						replyComefromTemp+="&nbsp;来自Android";          
					else if(replyComefrom.equals("4"))  
						replyComefromTemp+="&nbsp;来自Web手机版";
				         
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp+=")";
					
				%>
			  <div id="re_<%=replyVo.getId()%>">
				<div class="sortInfo replyTitle">
						<span class="name">&nbsp;<a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=replyVo.getUserid() %>','<%=replyVo.getUsername() %>的微博','blog_<%=replyVo.getUserid()%>')"><%=replyVo.getUsername()%></a>&nbsp;</span>
						<div class="state re"></div>
						<span class="datetime">
							<%=replyVo.getCreatedate()+" " + replyVo.getCreatetime()%>&nbsp;<!-- 评论于 -->
							<span class="comefrom"><%=replyComefromTemp%></span>
						</span>
						<span class="sortInfoRightBar">
							<%if((""+user.getId()).equals(replyVo.getUserid())&&j==replayList2.size()-1){
								long sepratorTime=(today.getTime()-dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime()).getTime())/(1000*60);
								if(sepratorTime<=10){
							%>
								<a href='javascript:void(0)' class='deleteOperation' onclick="deleteDiscuss(this,0,'<%=replyVo.getId()%>')">删除</a><!-- 删除 -->
							<%}} %>
							<a href="javascript:void(0)"  onclick="showReplySubmitBox(this,0,{'uid':'<%=replyVo.getUserid()%>','name':'<%=replyVo.getUsername()%>','level':'1','replyid':'<%=replyVo.getId() %>'},0)">评论</a><!-- 评论 -->
						    <a href="javascript:void(0)"  onclick="showReplySubmitBox(this,0,{'uid':'<%=replyVo.getUserid()%>','name':'<%=replyVo.getUsername()%>','level':'1','replyid':'<%=replyVo.getId() %>'},1)">私评</a><!-- 私评 -->
						</span>
					</div>
					<div class="clear reportContent">
						<%=replyVo.getContent()%>
					</div>
				</div>
				<%if(j<replayList2.size()-1){%>
				  <div class="dotedline"></div>
				<%} %>
			<%} %>
			</div>
	<%} %>
	<div class="commitBox"></div>
</div>
</div>
<%} %>
<div class="clear"></div>
<%}%>
</div>
</td>
</tr>
</table>

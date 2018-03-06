<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="java.util.*"%>
<%--<%@page import="weaver.conn.RecordSet"%>--%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String userid=""+user.getId();
BlogDao blogDao=new BlogDao();
String recordType=request.getParameter("recordType");
int visitTotal=NumberHelper.getIntegerValue(request.getParameter("total"),0).intValue();
int visitCurrentpage=NumberHelper.getIntegerValue(request.getParameter("currentpage"),0).intValue();
int visitTotalpage=visitTotal%5>0?visitTotal/5+1:visitTotal/5;
List visitorList;
if(recordType.equals("visit"))
   visitorList=blogDao.getVisitorList(userid,visitCurrentpage,5,visitTotal);
else
	visitorList=blogDao.getAccessList(userid,visitCurrentpage,5,visitTotal);
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");
SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");
%>
<%if(visitorList.size()>0){ %>
<ul class="people-list" style="width: 100%">
	<%for(int i=0;i<visitorList.size();i++){
		Map map=(Map)visitorList.get(i);
		String visitor=(String)map.get("userid");
		String visitdate=(String)map.get("visitdate");
		visitdate=dateFormat2.format(dateFormat1.parse(visitdate));
		String visittime=(String)map.get("visittime");
		visittime=timeFormat.format(timeFormat.parse(visittime));
	%>
	<li style="margin-right: 0px;width: 100%;height: 45px">
			<div style="float: left;">
			  <a  href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=visitor%>','<%=humresService.getHrmresNameById(visitor) %>的微博','blog_<%=visitor%>')" >
			      <img style="border: 0px;cursor: pointer;" src="<%=BlogDao.getBlogIcon(visitor)%>" width="40px">
			  </a>
			</div>
			<div style="float: left;margin-left: 5px">
			   <span class="name" style="text-align: left;height: 40px;">
			      <span style="margin-bottom:3px;text-align: left;">
			        <a  href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=visitor%>','<%=humresService.getHrmresNameById(visitor) %>的微博','blog_<%=visitor%>')"><%=humresService.getHrmresNameById(visitor) %></a>
			      </span>
			      <span style="color: #666;text-align: left;"><%=visitdate+" "+visittime%></span>
			   </span>
			</div>
	  </li>
	<%}%>
  </ul>
<%}%>

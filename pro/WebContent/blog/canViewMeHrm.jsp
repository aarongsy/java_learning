<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="java.util.*"%>
<%--<%@page import="weaver.conn.RecordSet"%>--%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>--%>
<%
	Humres user=BaseContext.getRemoteUser().getHumres();
	HumresService humresService = (HumresService)BaseContext.getBean("humresService");
	OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String from=StringHelper.null2String(request.getParameter("from"));
    String currentuserid=""+user.getId();
	String userid=StringHelper.null2String(request.getParameter("userid"));
	BlogShareManager shareManager=new BlogShareManager();  
	List shareList=shareManager.getShareList(userid);
	

if(shareList.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%">
<UL>
<%
for(int i=0;i<shareList.size();i++){
	  String attentionid=(String)shareList.get(i);
	  if(attentionid.equals(currentuserid))
		  continue;
      String username=humresService.getHrmresNameById(attentionid);
      String deptName=orgunitService.getOrgunitName(humresService.getHumresById(attentionid).getOrgid());
%>
  <LI class="LInormal" style="height: 75px">
	<DIV class="LIdiv">
	   <A class=figure href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')" ><IMG src="<%=BlogDao.getBlogIcon(attentionid) %>" width=55  height=55></A>
	   <DIV class=info style="margin-top: 3px;">
	      <SPAN class=line><A class=name href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')" ><%=username%></A></SPAN> 
	      <SPAN class="line gray-time" style="margin-top: 12px;" title="<%=deptName%>"><%=deptName%></SPAN>
	    </DIV>
	</DIV>
  </LI>
<%} %>
</UL>
</DIV>
<div style="margin-top: 10px;text-align: left;color: #666;clear: both;">取消他人对你的能查看权限，请到“<a href="blogSetting.jsp?tabItem=share">微博设置--分享设置</a>”中删除</div>
<%
}else
    out.println("<div class='norecord'>没有可以显示的数据</div>");
%>
<script>
  jQuery("#footwall_visitme li").hover(
    function(){
       jQuery(this).addClass("LIhover");
    },function(){
       jQuery(this).removeClass("LIhover");
    }
  );
</script>
<script type="text/javascript" language="javascript" src="/js/main.js"></script>
<br/>
<br/>      

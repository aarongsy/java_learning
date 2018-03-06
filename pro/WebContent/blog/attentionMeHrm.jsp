<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="java.util.*"%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%--<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />--%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>--%>
<script>
  function addAttention(attentionid,islower){
      jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid="+attentionid);
      jQuery("#cancelAttention_"+attentionid).show();
      jQuery("#addAttention_"+attentionid).hide();
   }
  function cancelAttention(attentionid,islower){
      jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid="+attentionid);
      jQuery("#cancelAttention_"+attentionid).hide();
      jQuery("#addAttention_"+attentionid).show();
   }
  function requestAttention(obj,attentionid){
    if(jQuery(obj).attr("isApply")!="true"){
      jQuery.post("blogOperation.jsp?operation=requestAttention&attentionid="+attentionid,function(){
         jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span>已申请");
         jQuery(obj).attr("isApply","true");
         alert("申请已经发送");//申请已经发送
      });
     }else{
         alert("申请已经发送");//申请已经发送
     }  
   } 
</script>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String from=StringHelper.null2String(request.getParameter("from"));
String userid=""+user.getId();
String attentionedid=StringHelper.null2String(request.getParameter("userid"));
BlogDao blogDao=new BlogDao();
List attentionList=blogDao.getAttentionMe(attentionedid);
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");

BlogShareManager shareManager=new BlogShareManager();

if(attentionList.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%;float: left;">
<UL>
<%	
for(int i=0;i<attentionList.size();i++){
	  String attentionid=(String)attentionList.get(i);
	  int status=shareManager.viewRight(attentionid,userid);
	  String islower="0";
	  if(status==2||status==4) 
		  islower="1";
	  String username=humresService.getHrmresNameById(attentionid);
      String deptName=orgunitService.getOrgunitName(humresService.getHumresById(attentionid).getOrgid());
%>
   <LI class="LInormal" style="height: 75px">
	<DIV class="LIdiv">
	   <A class=figure href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')"><IMG src="<%=BlogDao.getBlogIcon(attentionid) %>" width=55  height=55></A>
	   <div class=info>
	    <SPAN class=line><A class=name href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')"><%=username%></A></SPAN> 
	    <SPAN class="line gray-time" title="<%=deptName%>"><%=deptName%></SPAN>
	   
	    <div> 
			<%if(!"view".equals(from)) {%>
			   <a class="btnEcology" id="addAttention_<%=attentionid%>" href="javascript:void(0)" onclick="addAttention('<%=attentionid%>',<%=islower%>)" style="margin-right: 8px;display: <%=status==1||status==2?"":"none"%>">
					<div class="left" style="width:70px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span>添加关注</span></div><!-- 添加关注 -->
					<div class="right"> &nbsp;</div>
	           </a>
		        <a class="btnEcology" id="cancelAttention_<%=attentionid%>" href="javascript:void(0)" onclick="cancelAttention('<%=attentionid%>',<%=islower%>)" style="margin-right: 8px;display: <%=status==3||status==4?"":"none"%>">
					<div class="left" style="width:70px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">-</span>取消关注</span></div><!-- 取消关注 -->
					<div class="right"> &nbsp;</div>
	            </a>
		        <a class="btnEcology" id="requestAttention_<%=attentionid%>" href="javascript:void(0)" onclick="requestAttention(this,'<%=attentionid%>')" style="margin-right: 8px;display: <%=status==0?"":"none"%>">
					<div class="left" style="width:70px;color: #666"><span id="btnLabel"><span class="apply">√</span>申请关注</span></div><!-- 申请关注 -->
					<div class="right"> &nbsp;</div> 
	            </a>
		    <%} %>
		 </div>
	   </div>	   
	</DIV>
  </LI>
   <%}%>
</UL>
</DIV>      
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
<br/>
<br/>      

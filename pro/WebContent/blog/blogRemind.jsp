<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="java.text.MessageFormat"%>
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
<script type="text/javascript" language="javascript" src="/js/main.js"></script>
<script>
  function delMsg(msgid,remindType){
     jQuery.post("blogOperation.jsp?operation=delMsg&msgid="+msgid+"&remindType="+remindType);
     jQuery("#msg_"+msgid).remove();
     jQuery("#remindcount").text(jQuery("#remindcount").text()-1);
  }
</script>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String userid=""+user.getId();
BlogDao blogDao=new BlogDao();
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("M月d日");

List remindList=blogDao.getMsgRemidList(user,"remind",""); 

%>
 <div class="title_bg">
     <div class="title_remind">消息提醒</div><!-- 消息提醒 -->
 </div>
 <%if(remindList.size()>0){ %>
 <div style="text-align: left; padding-left: 20px; padding-top: 10px;" class="msgContainer">
 <%
 
 for(int i=0;i<remindList.size();i++){ 
    Map map=(Map)remindList.get(i);
    
    String id=(String)map.get("id");
    String remindType=(String)map.get("remindType");
    String remindid=(String)map.get("remindid");
    String relatedid=(String)map.get("relatedid");
    String remindValue=(String)map.get("remindValue");
 %>
   <div id="msg_<%=id%>" class="msg" style="width: 95%;border-bottom: #e3eef8 1px solid;margin-bottom: 8px;clear: both;height: 22px;background: url('images/remind.gif') no-repeat;padding-left: 20px;">
     <div style="text-align: left; float: left; padding-left: 5px;width:100%">
      <%if(remindType.equals("1")) { %>
           <div style="text-decoration: none;float: left;">
           	  <%
           	String relatedname = humresService.getHrmresNameById(relatedid);
           	  %>
			  <FONT class=font><FONT class=font><%=relatedname %>&nbsp;向你申请关注</FONT></FONT><!-- 向你申请关注 -->
		   </div>
		   <div style="float: right;">
		       <a  style="margin-right: 8px;color: #1d76a4;text-decoration: none;" href="javascript:dealRequest('<%=relatedid%>',<%=id%>,'<%=relatedname %>',-1)">拒绝</a> <!-- 拒绝 -->
		       <a  style="margin-right: 8px;color: #1d76a4;text-decoration: none;" href="javascript:dealRequest('<%=relatedid%>',<%=id%>,'<%=relatedname %>',1)">同意</a> <!-- 同意 -->
		   </div>
      <%}else if(remindType.equals("2")) {%>
         <!-- 关注申请 -->
         <div><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=relatedid%>','<%=humresService.getHrmresNameById(relatedid) %>的微博','blog_<%=relatedid%>')" style="margin-right: 3px"><%=humresService.getHrmresNameById(relatedid)%></a>&nbsp;接受了你的关注请求</div><!-- 接受了你的关注请求 -->
       <%}else if(remindType.equals("3")){%>
         <!-- 关注申请拒绝 -->
         <div><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=relatedid%>','<%=humresService.getHrmresNameById(relatedid) %>的微博','blog_<%=relatedid%>')" style="margin-right: 3px"><%=humresService.getHrmresNameById(relatedid)%></a>&nbsp;拒绝了你的关注请求</div>  <!-- 拒绝了你的关注请求 -->
       <%}else if(remindType.equals("8")){
    	   Object object[]=new Object[1];
		   object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+remindValue+"</span>&nbsp;";
    	   String message = MessageFormat.format("系统提醒：你已经连续{0}天没有提交工作微博",object);
       %>
         <!-- 微博未提交系统提醒 -->
         <div><%=message %></div>
       <%}else if(remindType.equals("6")){
    	  BlogDiscessVo discessVo=blogDao.getDiscussVo(remindValue);   
    	  if(discessVo==null) continue;
    	  String content=discessVo.getContent();
          String contentHtml=content.replaceAll("<[^>].*?>","");
          String workdate=dateFormat2.format(dateFormat1.parse(discessVo.getWorkdate()));
          Object object[]=new Object[1];
		  object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+workdate+"</span>&nbsp;";
          String message = MessageFormat.format("提交了{0}工作微博",object);
    	%>
    	<!-- 微博提交提醒 -->
         <div>
         <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=relatedid%>','<%=humresService.getHrmresNameById(relatedid) %>的微博','blog_<%=relatedid%>')" style="margin-right: 3px"><%=humresService.getHrmresNameById(relatedid)%></a><%=message%></div>
         <div style="padding-left:5px;padding-right:5px">
              <a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=relatedid%>','<%=humresService.getHrmresNameById(relatedid) %>的微博','blog_<%=relatedid%>')" style="">
	              <%
	                    	   out.println(content); 
	             %>
	          </a>
         </div>
       <%}else if(remindType.equals("7")){
    	    remindValue=dateFormat2.format(dateFormat1.parseObject(remindValue));
    	    Object object[]=new Object[1];
  		    object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+remindValue+"</span>&nbsp;";
			String message = MessageFormat.format("提醒你提交{0}工作微博",object);
       %>
         <!-- 微博未提交提交提醒 -->
         <div><a href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=relatedid%>','<%=humresService.getHrmresNameById(relatedid) %>的微博','blog_<%=relatedid%>')" style="margin-right: 3px"><%=humresService.getHrmresNameById(relatedid)%></a><%=message%></div>
       <%} %>
     </div>
   </div>  
   <%} %>
 </div>   
 <script>
   jQuery("#remindcount").hide();
   
   function dealRequest(sender,requestid,name,status){
     if(status==-1){
	     if(window.confirm("确认拒绝\“"+name+"\”申请")){  //确认拒绝申请  
	        jQuery.post("blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#msg_"+requestid).remove();
	        if(jQuery(".msg").length==0)
	           jQuery(".msgContainer").append("<div class='norecord'>没有可以显示的数据</div>");
	     }
	 }else {
	    if(window.confirm("确认同意\“"+name+"\”申请?")){ //确认同意申请
	        jQuery.post("blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#msg_"+requestid).remove();
	        if(jQuery(".msg").length==0)
	           jQuery(".msgContainer").append("<div class='norecord'>没有可以显示的数据</div>");
	    } 
	 }
  }
   
 </script>
 <%
   //删除已经查看的提醒
   String sql="delete from blog_remind where remindid='"+userid+"' and (remindType=2 or remindType=3 or remindType=7 )";
   baseJdbcDao.update(sql);
   //更新系统未提交提醒状态
   sql="update blog_remind set status=-1  where remindid='"+userid+"' and remindType=8";
   baseJdbcDao.update(sql);
   
   sql="update blog_remind set status=1  where remindid='"+userid+"' and remindType=1";
   baseJdbcDao.update(sql);
 }else
	 out.println("<div class='norecord'>没有可以显示的数据</div>");
 %>

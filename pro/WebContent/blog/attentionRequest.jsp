<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%--<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />--%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>--%>
<%@ include file="/blog/bloginit.jsp" %>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<script>
   function dealApplay(sender,requestid,name,status){
     if(status==-1){
	     if(window.confirm("确认拒绝\""+name+"\"申请")){  //确认拒绝申请  
	        jQuery.post("blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#request_"+requestid).remove();
	        var requestCount=jQuery("#requestCount").text();
	        if(requestCount==1){
	         jQuery("#requestMsgCount").hide();
	        }else
	         jQuery("#requestCount").text(requestCount-1); 
	     }
	 }else {
	    if(window.confirm("确认同意\""+name+"\"申请?")){ //确认同意申请
	        jQuery.post("blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#request_"+requestid).remove();
	        var requestCount=jQuery("#requestCount").text();
	        if(requestCount==1)
	         jQuery("#requestMsgCount").hide();
	        else
	         jQuery("#requestCount").text(requestCount-1); 
	    } 
	 }
  }
</script>
 <div style="background:f0f5f8;color:#333;text-align: left;direction: ltr;height: 30px;padding-left: 8px;padding-top: 5px">
     <img src="images/request.gif" align="absmiddle"><span style="font-weight: bold;margin-left: 3px">关注请求</span><!-- 关注请求 --> 
 </div>
<%
 String userid=""+user.getId();
 BlogDao blogDao=new BlogDao();
 List historyList=blogDao.getAttentionRequest(userid); 

 SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
 SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");

 String departmentid=user.getOrgid();   //用户所属部门
 //int subCompanyid=user.getUserSubCompany1();  //用户所属分部
 String seclevel=user.getSeclevel()+"";          //用于安全等级
 
 if(historyList.size()>0){
	 
 %>
 <% 	 
	 for(int i=0;i<historyList.size();i++){ 
		 Map history=(Map)historyList.get(i);
		  
		 String id=(String)history.get("id");
		 String createdate=(String)history.get("createdate");
		 createdate=dateFormat2.format(dateFormat.parse(createdate));
		 String sender=(String)history.get("sender");
		 String senderName=humresService.getHrmresNameById(sender);
   %> 
      <div style="border-bottom:#d8d8d8 1px dashed;float: left;padding-top:8px" id="request_<%=id%>">
             <div style="float: left;padding-right: 10px;padding-left: 10px">
                 <a href="viewBlog.jsp?blogid=<%=sender%>"><img width="45px" border="0" src="<%=BlogDao.getBlogIcon(sender)%>"/></a>
             </div>
             <div style="float: right;">
	             <div style="float: left;"> 
	               <div style="float: left;"> 
	                  <a href="viewBlog.jsp?blogid=<%=sender%>" style="color:#2b4a78 !important;font-size: 14px !important;"><%=senderName%></a>
	               </div>
	               <div style="float: right;">
		               <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="dealApplay('<%=sender%>',<%=id%>,'<%=senderName%>',1)" style="margin-right: 8px;">
							<div class="left" style="width:40px;"><span>同意</span></div><!-- 同意 -->
							<div class="right"> &nbsp;</div>
			           </a>
			           <a class="btnEcology" id="addAttention" href="javascript:void(0)" onclick="dealApplay('<%=sender%>',<%=id%>,'<%=senderName%>',-1)" style="margin-right: 8px;">
							<div class="left" style="width:40px;"><span>拒绝</span></div><!-- 拒绝 -->
							<div class="right"> &nbsp;</div>
			           </a>
		           </div>
	              </div> 
	              
	              <div style="text-align: left;">
	                    <div style="color: #999;height:45px;padding-top: 6px">申请时间 <%=createdate%></div> <!-- 申请时间 -->
	              </div>
             </div>
         </div>     
       <%} %> 
<%}else{ 
	out.println("<div class='norecord'>没有可以显示的数据</div>");
}%>
<br/>
<br/>	    

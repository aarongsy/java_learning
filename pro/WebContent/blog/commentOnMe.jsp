<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogReplyVo"%>
<%@page import="com.eweaver.blog.AppDao"%>
 <div class="title_bg">
     <div class="title_comment">评论我的</div><!-- 评论我的 -->
 </div>
 <div id="commentDiv">
 </div>
<script type="text/javascript">
  jQuery.post("discussList.jsp?requestType=commentOnMe",function(data){
	  jQuery("#commentDiv").html(data);
     //初始化处理图片
     jQuery('.reportContent img').each(function(){
		initImg(this);
     });
	 //上级评分初始化
	 jQuery(".blog_raty").each(function(){
	   managerScore(this);
	   jQuery(this).attr("isRaty","true"); 
	 });
     jQuery("#commentcount").hide();
     jQuery.post("blogOperation.jsp?operation=markCommentRead"); //删除评论提醒
  });

</script>




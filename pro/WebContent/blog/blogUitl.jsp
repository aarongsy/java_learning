<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.MessageFormat"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<% 
Humres user =  BaseContext.getRemoteUser().getHumres();
%>
<script type="text/javascript" src="js/blogUitl.js"></script>
<script type="text/javascript">
function deleteDiscuss(obj,discussid,replyid){
	  if(window.confirm("确认删除评论")){ //确认删除评论
		  var backInfo=saveBlogItem({'discussid':discussid,'replyid':replyid,'action':'del'},"blogCommentOparation.jsp");
		  if(backInfo.status=="1"){
			var dotedline=jQuery("#re_"+replyid).prev(".dotedline");
			if(dotedline.length==0){
				dotedline=jQuery("#re_"+replyid).next(".dotedline");
			}
			if(jQuery("#re_"+replyid).parent().find(".sortInfo").length==1){
				jQuery("#re_"+replyid).parent().remove();
			}
			dotedline.remove();
			jQuery("#re_"+replyid).remove();
		  }else if(backInfo.status=="-1"){
	        alert("有最新评论"); //有最新评论
	        jQuery(obj).parents(".reply").find(".deleteOperation").hide();
		  }else if(backInfo.status=="-2"){
		    <%
		    Object object[]=new Object[1];
		    object[0]="10";
		    String message=MessageFormat.format("评论超过{0}分钟",object);%>
		    alert("<%=message%>");
		    jQuery(obj).parents(".reply").find(".deleteOperation").hide();
		 }
	  }
	}
 </script>
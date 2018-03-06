<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="org.light.portlets.*"%>
<%@ page import="org.light.portal.core.entity.PortletObject"%>
<%@ page import="org.light.portal.core.service.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="java.text.*"%>
<%@page import="com.eweaver.blog.BlogReplyVo"%>
<%!
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
RequestlogService requestlogService = (RequestlogService)BaseContext.getBean("requestlogService");
NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
PortalService portalService = (PortalService)BaseContext.getBean("portalService");
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

//获取微博 
/*
 status 状态 comment评论，remind提醒，update微博更新

**/
private List<Map<String,String>> getBlog(Humres user,String status,String nCount){
	BlogDao blogDao=new BlogDao();
    List<Map<String,String>> commentList=blogDao.getBlogStatusRemidList(user,status,nCount);
    return commentList;
}

private Map getBlogCount(Humres user,String status){
	BlogDao blogDao=new BlogDao();
	Map map=blogDao.getReindCount(user);
	return map;
}
%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
BlogDao blogDao=new BlogDao();
int portletId = NumberHelper.string2Int(request.getParameter("id"));//TODO 每种流程元素单独设置
String tabParams = StringHelper.null2String(request.getParameter("tabParams"));
JSONObject json = (JSONObject)JSONValue.parse(tabParams);

PortletObject portlet = portalService.getPortletById(portletId);

String status = StringHelper.null2String(json.get("status"));
int nCount = NumberHelper.string2Int(json.get("nCount"),0);
String workflowIds = "";
SimpleDateFormat frm1=new SimpleDateFormat("MM月dd日");
SimpleDateFormat frm2=new SimpleDateFormat("yyyy-MM-dd");
StringBuffer sb = new StringBuffer();
Map map = null;
List<Map<String,String>> list = getBlog(user,status,nCount+"");
Map mapCount = getBlogCount(user,status);
int totalSize = 0;
if("comment".equals(status)){
	totalSize = NumberHelper.string2Int(mapCount.get("commentCount"), 0);
} else if("remind".equals(status)){
	totalSize = NumberHelper.string2Int(mapCount.get("remindCount"), 0);
} else if("update".equals(status)){
	totalSize = NumberHelper.string2Int(mapCount.get("updateCount"), 0);
}	
int commentCount=NumberHelper.string2Int(mapCount.get("commentCount"),0);
int remindCount=NumberHelper.string2Int(mapCount.get("remindCount"),0);
int updateCount=NumberHelper.string2Int(mapCount.get("updateCount"),0);
sb.append("<table class='requestTabTable' id='rqstListContainer"+portletId+"'>");
for(int i=0;i<list.size();i++){
	sb.append("<tr class='"+(i%2==0?"odd":"even")+"'><td class='itemIcon'></td>");
	map = (Map)list.get(i);
	String id=(String)map.get("id");  
	String remindType=(String)map.get("remindType");
	String relatedid=(String)map.get("relatedid");
	String createdate=(String)map.get("createdate");
	String remindValue=(String)map.get("remindValue");
	String relatedName = humresService.getHrmresNameById(relatedid);
	
	sb.append("<td >");
	if("1".equals(remindType)){
	  sb.append("<A href=\"javascript:openRemind('"+status+"','sysremind')\">");
      sb.append("<FONT class=font>"+relatedName+"向你申请关注</FONT></A> ");
	}else if("2".equals(remindType)){
	  sb.append("<A href=\"javascript:openRemind('"+status+"','sysremind')\">");
	  sb.append("<FONT class=font>"+relatedName+"接受了你的关注申请</FONT></A>");
	}else if("3".equals(remindType)){
	  sb.append("<A href=\"javascript:openRemind('"+status+"','sysremind')\">");
	  sb.append("<FONT class=font>"+relatedName+"拒绝了你的关注申请</FONT></A>");
	}else if("4".equals(remindType)){
	  sb.append("<A href=\"javascript:openRemind('"+status+"','sysremind')\">");
	  sb.append("<FONT class=font>"+relatedName+"关注了你</FONT></A>");		
	}else if("6".equals(remindType)){
		BlogDiscessVo discussVo= blogDao.getDiscussVo(remindValue);
		//如果微博记录不存在，则删除提醒
		if(discussVo==null){
		   baseJdbcDao.update("delete from blog_remind where id="+id);
		   continue;	
		}
		String workdate=discussVo.getWorkdate();
		try{
			workdate=frm1.format(frm2.parseObject(workdate));
	    }catch(Exception e){
	    	e.printStackTrace();
	    }
        String message="提交"+workdate+"工作微博";
        sb.append("<A href=\"javascript:openRemind('"+status+"','homepage')\">");
  	    sb.append("<FONT class=font>"+relatedName+message+"</FONT></A>");
	}else if("7".equals(remindType)){
		if("".equals(remindValue))
			continue;
	    try{
	    	remindValue=frm1.format(frm2.parseObject(remindValue));
	    }catch(Exception e){
	    	e.printStackTrace();
	    }
		
		String message="提醒提交"+remindValue+"工作微博";
		sb.append("<A href=\"javascript:openRemind('"+status+"','sysremind')\">");
  	    sb.append("<FONT class=font>"+relatedName+message+"</FONT></A>");
	}else if("8".equals(remindType)){
		Object object[]=new Object[1];
		object[0]=remindValue;
		String message = MessageFormat.format("系统提醒：你已经连续{0}天没有提交工作微博",object);
		sb.append("<A href=\"javascript:openRemind('"+status+"','sysremind')\">");
  	    sb.append("<FONT class=font>"+message+"</FONT></A>");
	}else if("9".equals(remindType)){

		String disucssid=StringHelper.TokenizerString2(remindValue, "|")[0];  //微博id
		String beReplayid=StringHelper.TokenizerString2(remindValue, "|")[1];   //被评论的评论id
		String replayid=StringHelper.TokenizerString2(remindValue, "|")[2];//评论id
		
		BlogReplyVo replyVo=blogDao.getReplyById(replayid);
		BlogReplyVo beReplayVo=blogDao.getReplyById(beReplayid);
		
		if(replyVo==null||(!beReplayid.equals("0")&&beReplayVo==null))
			continue;
		
		String workdate=replyVo.getWorkdate();
		try{
			workdate=frm1.format(frm2.parseObject(workdate));
	    }catch(Exception e){
	    	e.printStackTrace();
	    }
		
		String message="";
		if("0".equals(beReplayid)){
			Object object[]=new Object[1];
		    object[0]=workdate;
			message=MessageFormat.format("评论了你{0}工作微博",object); //评论了你{0}工作微博
		}	
		else if(replyVo.getBediscussantid().equals(""+user.getId())){
			Object object[]=new Object[1];
		    object[0]=workdate;
			message=MessageFormat.format("在你{0}的工作微博中回复了你",object); //在你{0}的工作微博中回复了你
		}else{
			Object object[]=new Object[1];
		    object[0]=humresService.getHrmresNameById(replyVo.getBediscussantid())+workdate;
			message=MessageFormat.format("在{0}的工作微博中回复了你",object); //在{0}的工作微博中回复了你
		}
		sb.append("<A href=\"javascript:openRemind('"+status+"','comment')\">");
  	    sb.append("<FONT class=font>"+relatedName+message+"</FONT></A>");
	}
	
	sb.append("</td>");
	sb.append("</tr>");
	//sb.append("<tr height='1'><td class='line' colspan='10'></td></tr>");
}
sb.append("</table>");
out.println(sb);
%>

<div class="requestTabPortletFooter"><span class="refresh" onclick="doRefresh();"></span>
<%if(totalSize>0){
	String mainTypeMore = status;
	String menuItemMore = "";
	if("comment".equals(status)){
		menuItemMore="comment";
	}else if("remind".equals(status)){
		menuItemMore="sysremind";
	}else if("update".equals(status)){
		menuItemMore="homepage";
	}
%>
<a href="javascript:openRemind('<%=mainTypeMore %>','<%=menuItemMore %>')"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015") %><!-- 更多 -->(<%=totalSize%>)...</a>
<%}%>
</div>

<script type="text/javascript" language="javascript" src="/js/main.js"></script>
<script type="text/javascript">
  function doRefresh(){
	var portletRefreshBtn = document.getElementById('a_refresh_<%=portletId %>');
	if(portletRefreshBtn){
		portletRefreshBtn.click();
	}
  }
  function openRemind(mainType,menuItem){
    onUrl('/blog/blogView.jsp?menuItem='+menuItem,'<%=user.getObjname()%>的微博','blog_<%=user.getId()%>')
  }
  Ext.onReady(function() {
		  var updateTab = Ext.getCmp('t<%=portletId+"_0"%>');
		  if(updateTab){
			 var title = updateTab.title;
			 var index = title.lastIndexOf("(");
			 if(index>-1){
			  title = title.substring(0,index);
			 }
			 title = title + '(<%=updateCount%>)';
         	 updateTab.setTitle(title);
		  }
          var remindTab = Ext.getCmp('t<%=portletId+"_1"%>');
		  if(remindTab){
			 var title = remindTab.title;
			 var index = title.lastIndexOf("(");
			 if(index>-1){
			  title = title.substring(0,index);
			 }
			 title = title + '(<%=remindCount%>)';
         	 remindTab.setTitle(title);
		  }
		  var commentTab = Ext.getCmp('t<%=portletId+"_2"%>');
		  if(commentTab){
			 var title = commentTab.title;
			 var index = title.lastIndexOf("(");
			 if(index>-1){
			  title = title.substring(0,index);
			 }
			 title = title + '(<%=commentCount%>)';
         	 commentTab.setTitle(title);
		  }
  });

<%--if(totalSize>0 && (status==0 || status==5 || status==6)){%>
var o = Ext.getCmp('t<%=portletId+"_"+status%>');
var title = o.title + '(<%=totalSize%>)';
//o.setTitle(title);
<%}--%>

<%--
放在portal上的参数
{"tabs":[{"id":"0","name":"更新","label":"","src":"/blog/blogPortlet.jsp?1=2","params":{"status":"update","nCount":"10"}},{"id":"1","name":"提醒","label":"","src":"/blog/blogPortlet.jsp?1=2","params":{"status":"remind","nCount":"10"}},{"id":"2","name":"评论","label":"","src":"/blog/blogPortlet.jsp?1=2","params":{"status":"comment","nCount":"10"}}]}

--%>
</script>

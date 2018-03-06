<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.MessageFormat"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<%@page import="weaver.hrm.job.JobActivitiesComInfo"%>--%>
<%@ include file="/blog/bloginit.jsp" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.conn.RecordSet"%>--%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.AppDao"%>
<%@page import="com.eweaver.blog.AppItemVo"%>
<%@page import="com.eweaver.blog.AppVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.blog.HtmlLabel"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />--%>
<%--<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>--%>
<%--<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>--%>
<%--<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>--%>
<%--<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />--%>
<html>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<link rel=stylesheet href="/ecology/css/Weaver.css" type="text/css" />
<script type="text/javascript">var languageid="";</script>

<script type="text/javascript" src="/ecology/wui/common/jquery/jquery.js"></script>
<script type="text/javascript" src="/ecology/js/jquery/plugins/client/jquery.client.js"></script>
<script type="text/javascript" src="/ecology/wui/common/jquery/plugin/jQuery.modalDialog.js"></script>

<script type="text/javascript" src="/ecology/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/ecology/kindeditor/kindeditor-Lang.js"></script>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<script type='text/javascript' src='js/highlight/jquery.highlight.js'></script>
<link href="js/weaverImgZoom/weaverImgZoom.css" rel="stylesheet" type="text/css">
<script src="js/weaverImgZoom/weaverImgZoom.js"></script>

<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDrag.js"></script>

<script type="text/javascript" src="js/raty/js/jquery.raty.js"></script>
<script type="text/javascript" src="/js/main.js"></script>
<jsp:include page="blogUitl.jsp"></jsp:include>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<%

String blogid=StringHelper.null2String(request.getParameter("blogid"));   //要查看的微博id
String userid=""+user.getId();
BlogDao blogDao=new BlogDao();
BlogShareManager shareManager=new BlogShareManager();
int status=shareManager.viewRight(blogid,userid); //微博查看权限
AppDao appDao=new AppDao();
List appItemVoList=appDao.getAppItemVoList("mood");

Calendar calendar=Calendar.getInstance();
int currentMonth=calendar.get(Calendar.MONTH)+1;
int currentYear=calendar.get(Calendar.YEAR);

BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

Date today=new Date();
Date startDateTmp=new Date();
SimpleDateFormat frm=new SimpleDateFormat("yyyy-MM-dd");
String curDate=frm.format(today);    //当前日期
startDateTmp.setDate(startDateTmp.getDate()-30);
String startDate=frm.format(startDateTmp);
String enableDate=blogDao.getSysSetting("enableDate");         //微博启用日期 
String attachmentDir=blogDao.getSysSetting("attachmentDir");   //附件上传目录
if(frm.parse(enableDate).getTime()>frm.parse(startDate).getTime()){
	startDate=enableDate;
}
Humres blogHumres = humresService.getHumresDao().getHumresById(blogid);
%>
<title>微博:<%=humresService.getHrmresNameById(blogid)%></title>
</head>
<body style="overflow-y: hidden;"> 
<%--<%@ include file="/blog/uploader.jsp" %>--%>
<%--<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>

 <div>
	 <DIV id=bg></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/ecology/images/loading2.gif" style="vertical-align: middle"><label id="loadingMsg">正在保存，请稍等...</label>
			</div>
	 </div>
 </div>

<div style="height: 100%;overflow: auto;margin-left: 10px">
<div class="TopTitle">
	<div class="topNav" >
		<ul>
			<li><a href="javascript:toMyBlog()">我的微博</a></li><!-- 我的微博 -->
			<li class="splite1"></li>
			<li><a href="javascript:toMyAttention()">我的关注</a></li><!-- 我的关注 -->
		</ul>
<%--		<span style="float: right;margin-top: 5px;margin-right: 5px" >--%>
<%--		    <button title="加入收藏夹" class="btnFavorite" id="BacoAddFavorite" onclick="openFavouriteBrowser()" type="button"></button><!-- 加入收藏夹 -->--%>
<%--	        <button title="帮助" style="margin-left:5px" class="btnHelp" id="btnHelp" onclick="alert('帮助');" type="button"></button><!-- 帮助-->--%>
<%--		</span>--%>
	</div>
 </div>	
	<div style="height:6px;padding:0;font-size:0;"></div>
   <%
  //如果status=0则不具有查看权限 status=-1 不能查看且不允许申请
   if (status>0||userid.equals(blogid)) {
 
       blogDao.addReadRecord(userid,blogid); //添加已读记录
       blogDao.addVisitRecord(userid,blogid);
       
       //删除被查看用户的更新提醒
       String sql="delete from blog_remind where remindType=6 and remindid='"+userid+"' and relatedid='"+blogid+"'";
	   //RecordSet recordSet=new RecordSet();
	   //recordSet.execute(sql);
	   baseJdbcDao.update(sql);
       
   %>
	<div class="personalInfo" style="background: url('images/person-bg.png');border-left: 1px solid #D9DBE5;border-right: 1px solid #D9DBE5;">
		<div class="logo">
			<img src="<%=BlogDao.getBlogIcon(blogid) %>">
		</div>
		<div class="sortInfo" style="width:400px">
			<div class="sortInfoTop"  style="padding-top:10px">
			  <div>
			    <a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=blogid %>','<%=blogHumres.getObjname() %>','tab<%=blogid %>')" style="font-weight: bold;"><%=blogHumres.getObjname() %></a>
			    <a href="javascript:onUrl('/base/orgunit/orgunitview.jsp?id=<%=blogHumres.getOrgid()%>','<%=orgunitService.getOrgunitName(blogHumres.getOrgid())%>','tab<%=blogHumres.getOrgid()%>')" style="margin-left: 8px"><%=orgunitService.getOrgunitName(blogHumres.getOrgid()) %></a>
			  </div>
			</div>
			<div style="padding-top:8px">
			  <table width="600px">
			    <tr>
			       <td width="180px" valign="top">
					   <span style="color: #666">
					     <!-- 工作指数 -->
							 <a href="javascript:void(0)" class="index" onclick="openReport()">工作指数：<span id="workIndexCount" title="未提交0天应提交0天"><%=reportManager.getReportIndexStar(0)%></span><span id="workIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></a><br/><!-- 未提交 应提交 -->
							 <%if(appDao.getAppVoByType("mood").isActive()){ 
							 %>
							 <!-- 心情指数 -->
							 <a href="javascript:void(0)" class="index" onclick="openReport()">心情指数：<span id="moodIndexCount" title="不高兴0天高兴0天"><%=reportManager.getReportIndexStar(0)%></span><span id="moodIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></a><br/><!-- 不高兴 高兴 -->
							 <%}%>
							 <%-- String isSignInOrSignOut=StringHelper.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能
							    if(isSignInOrSignOut.equals("1")){
							 --%>
							 <!-- 考勤指数 -->
<%--							 <a href="javascript:void(0)" class="index" onclick="openReport()">考勤指数：<span id="scheduleIndexCount" title="旷工0次迟到0次共0个工作日"><%=reportManager.getReportIndexStar(0)%></span><span id="scheduleIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></a><!-- 旷工 迟到 -->--%>
						     <%--} --%>
					   </span>
			    </td>
			    <td>
			    	   <%
			    	   String manager = humresService.getHumresById(blogid).getManager();
			    	   String[] managerArray = manager.split(",");
			    	   %>
			           <!-- 上级 -->
			           <span style="color: #666666;" >上级：
			           <%for(int i=0;i<managerArray.length;i++){
			        	    String tmpManagerId =managerArray[i].trim();
			           		if(StringHelper.isEmpty(tmpManagerId)||tmpManagerId.equals(blogid)){
			           			continue;
			           		}
			           		String tmpManagerName = humresService.getHrmresNameById(tmpManagerId);
			           %>
			        	   <a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=tmpManagerId %>','<%=tmpManagerName %>','tab<%=tmpManagerId %>')" ><%=tmpManagerName%></a>
			        	   <%if(i!=managerArray.length-1){out.print(",");}
			           } %>
			           </span><br>
			           <!-- 电话 -->
			           <span style="color: #666666">电话：<%=StringHelper.null2String(blogHumres.getTel1())%></span><br>
			           <!-- 手机 -->
			           <span style="color: #666666">手机：<%=StringHelper.null2String(blogHumres.getTel2())%></span>
			    </td>
			    </tr>
			  </table>
			   
			</div>
	    </div>
		<div class="actions" style="padding-top: 8px">
			<div style="float: right;margin-right: 15px">
				     <a class="btnEcology" id="addAttention" href="javascript:void(0)" onclick="addAttention(<%=status%>)" status="<%=status%>" style="margin-right: 8px;display: <%=status==1||status==2?"":"none"%>">
						<div class="left" style="width:68px;color: #666"><span ><span style="font-size: 13px;font-weight: bolder;margin-right: 3px">+</span>添加关注</span></div><!-- 添加关注 -->
						<div class="right"> &nbsp;</div>
				     </a>
				     <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(<%=status%>)" status="<%=status%>" style="margin-right: 8px;display: <%=status==3||status==4?"":"none"%>">
						<div class="left" style="width:68px;color: #666"><span ><span style="font-size: 13px;font-weight: bolder;margin-right: 3px">-</span>取消关注</span></div><!-- 取消关注 -->
						<div class="right"> &nbsp;</div>
				     </a>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	<div class="clear"></div>

	<%
	  String blogTabName="他的微博";//他的微博
	  String reportTabName="他的报表"; //他的报表
	  String myAttentionTabName="他关注的";//他关注的
	  String attentionMeTabName="关注他的"; //关注他的
	  if(userid.equals(blogid)){
		  blogTabName="我的微博"; //我的微博
		  reportTabName="我的报表"; //我的报表
		  myAttentionTabName="我关注的";//我关注的
		  attentionMeTabName="关注我的"; //关注我的
	  }else if(StringHelper.null2String(blogHumres.getGender()).equals("402881e90cba854b010cba9c9364000d")){
		  blogTabName="她的微博"; //她的微博
		  reportTabName="她的报表"; //她的报表
		  myAttentionTabName="她关注的";//她关注的
		  attentionMeTabName="她注我的"; //她注我的
	  }
	%>
	<div class="tabStyle2">
		<UL>
			<LI id="blog" class="select2" url="discussList.jsp?blogid=<%=blogid %>&requestType=myblog"><A href="javascript:void(0)"><%=blogTabName%></A></LI>
			<LI id="report" url="myBlogReport.jsp?from=view&userid=<%=blogid%>"><A href="javascript:void(0)"><%=reportTabName%></A></LI>
			<LI url="myAttentionHrm.jsp?from=view&userid=<%=blogid%>"><A href="javascript:void(0)" ><%=myAttentionTabName%></A></LI>
			<LI url="attentionMeHrm.jsp?from=view&userid=<%=blogid%>"><A href="javascript:void(0)" ><%=attentionMeTabName%></A></LI>
		</UL>
		
	</div>
	<div id="searchDiv"  align="right" style="display: block;float: right;margin-top: 4px;border-bottom: #e4e9ed 1px solid;width: 100%;padding-bottom: 5px">
		<table  cellpadding=0 cellspacing=0>
		<tr>
			
			<td>
			     <INPUT id=startdate name=startdate type=hidden value="<%=startDate%>">
				 <INPUT id=startdate_ name=startdate_ type=hidden value="<%=startDate%>">
				 <BUTTON type="button" class=Calendar onclick="getDate('startdatespan','startdate')"></BUTTON>
				 <SPAN id="startdatespan"><%=startDate%></SPAN>
				 	至&nbsp;
				 <BUTTON type="button" class=Calendar onclick="getDate('enddatespan','enddate')"></BUTTON> 
				 <SPAN id=enddatespan><%=curDate%></SPAN>&nbsp;
				 <INPUT id=enddate name=enddate type=hidden value="<%=curDate%>">
				 <INPUT id=enddate_ name=enddate_ type=hidden value="<%=curDate%>">
				<span>&nbsp;</span>
			</td>
			<td align="right">
                <div class="searchBox">
                <input id="content" class="searchInput"  onkeydown="if(event.keyCode==13) jQuery('#searchBtn').click();"/>
                <div class="searchBtn" id="searchBtn" from="user" onclick="search('content','startdate','enddate',this,'<%=blogid %>');jQuery('.tabStyle2').find('.select2').each(function(){jQuery(this).removeClass('select2');jQuery('.tabStyle2 li:first').addClass('select2')});"></div>
                </div>
			</td>
		</tr>
	</table>
	</div>
	<div class="reportBody" id="reportBody" style="width: 100%">
			
	</div>
	<%}else if(status==-1){ 
		Object object[]=new Object[1];
		object[0]="<a href=\"javascript:onUrl('/humres/base/humresview.jsp?id="+blogid+"','"+blogHumres.getObjname()+"','"+blogid+"')\" style='font-weight: bold;text-decoration: underline !important;'>"+blogHumres.getObjname()+"</a>";
	    String message=MessageFormat.format("你当前不具有对{0}工作微博的查看权限，请联系对方将微博分享给你！",object);
	%>
        <div style="margin-top: 40px;text-align: center;">
            <%=message%>
        </div>
    <%}else if(status==0) {
    	Object object[]=new Object[1];
		object[0]="<a href=\"javascript:onUrl('/humres/base/humresview.jsp?id="+blogid+"','"+blogHumres.getObjname()+"','"+blogid+"')\" style='font-weight: bold;text-decoration: underline !important;'>"+blogHumres.getObjname()+"</a>";
		Map countMap = baseJdbcDao.executeForMap("select count(*) as cou FROM blog_remind where remindid='"+blogid+"' and relatedid='"+userid+"' and remindType=1 and status=0 ");
		int countInt = NumberHelper.getIntegerValue(countMap.get("cou"));
		String message = "";
		if(countInt==0){
    		message=MessageFormat.format("你当前不具有对{0}工作微博的查看权限，请联系对方将微博分享给你，或向他发关注申请！",object);
    		%>
    		<div style="margin-top: 40px;text-align: center;">
           <%=message%>
           <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="doAttention(this,'<%=blogid%>',0,event);" status="apply" style="margin-right: 8px;">
				<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class="apply">√</span>申请关注</span></div><!-- 申请关注 -->
				<div class="right"> &nbsp;</div>
		   </a>
        </div>   
    		<%
		}else{
			message=MessageFormat.format("你当前不具有对{0}工作微博的查看权限，请联系对方将微博分享给你",object);
			%>
			<div style="margin-top: 40px;text-align: center;">
			<%=message%>
			<a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="" status="" style="margin-right: 8px;">
				<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class='apply'>√</span>已申请</span></div><!-- 已申请 -->
				<div class="right"> &nbsp;</div>
		    </a>
			</div>
			<%
		}
		
    %>
        
    <%} %>
</div>

<iframe id="downloadFrame" style="display: none"></iframe>
<div class="editorTmp" style="display:none">
<table>
	<tr>
		<td>
		   <textarea name="submitText"  scroll="none" style="border: solid 1px;"></textarea>
		</td>
	</tr>
	<tr>
		<td class="appItem_bg">
			<div style="float: left;margin-right: 10px;">
				<!-- 保存 -->
				<input type="button" class="submitButton" onclick="saveContent(this)"/>
				<!-- 取消 -->
				<input type="button" class="editCancel" onclick="editCancel(this);" value="取消">
			</div>  
	   	 <%
	   	   List appVoList=appDao.getAppVoList();
	   	 	Iterator appVoListIter=appVoList.iterator();
	   	 	while(appVoListIter.hasNext()){
	   	 		AppVo appVo=(AppVo)appVoListIter.next();
	   	 		if("mood".equals(appVo.getAppType())){
	   	 		if(appItemVoList!=null&&appItemVoList.size()>0){ 
			   		Iterator itr=appItemVoList.iterator();
			   		AppItemVo appItemVo1=(AppItemVo)appItemVoList.get(0);
			   		String itemType1=appItemVo1.getType();
			   		String itemName1=appItemVo1.getItemName();
			   		if(itemType1.equals("mood")){
			   			if("26917".equals(itemName1)){
			   				itemName1="高兴";
			   			}else{
			   				itemName1="不高兴";
			   			}
			   			//itemName1=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName1),user.getLanguage());
			   		}
			   %>
			    <!-- 心情 -->
			   <div class="optItem" style="width:90px;position: relative;">
				  <div id="mood_title" class="opt_mood_title"  onclick="show_select('mood_title','mood_items','qty_<%=appItemVo1.getType() %>','mood',event,this)">
				 	
				    <img src="<%=appItemVo1.getFaceImg() %>" width="16px" alt="<%=itemName1%>" align="absmiddle" style="margin-right:3px;margin-left:2px">
				    
				    <a href="javascript:void(0)">心情</a><!-- 心情 -->
				 
				  </div>
				  <div id="mood_items" style="display:none" class="opt_items">
				  		<%
				  			while(itr.hasNext()) {
				  				AppItemVo appItemVo= (AppItemVo)itr.next();
				  				String itemType=appItemVo.getType();
				  				String itemName=appItemVo.getItemName();
				  				if(itemType.equals("mood")){
				  					if("26917".equals(itemName1)){
						   				itemName1="高兴";
						   			}else{
						   				itemName1="不高兴";
						   			}
				  				   //itemName=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName),user.getLanguage());
				  				}
				  		%>
					   		<div class='qty_items_out'  val='<%=appItemVo.getId() %>'><img src="<%=appItemVo.getFaceImg() %>" alt="<%=itemName%>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><%=itemName%></div>
					   <%} %>
				  </div> 
				  <input name="qty_<%=appItemVo1.getType() %>" class="qty" type="hidden" id="qty_<%=appItemVo1.getType() %>" value="<%=appItemVo1.getId() %>" />
			   </div>
				
		   	 <%} 
	   	   }else if("attachment".equals(appVo.getAppType())){
	   	 %>
	   	    <!-- 附件 -->
	   	    <div class="optItem" style="width: 120px;position: relative;">
			  <div id="temp_title" style="width: 120px" class="opt_title" onclick="openApp(this,'')">
			   <%
			   if(attachmentDir!=null&&!attachmentDir.trim().equals("")){ 
				   String attachmentDirs[]=StringHelper.TokenizerString2(attachmentDir,"|");
				   //RecordSet recordSet=new RecordSet();
				   List list = baseJdbcDao.executeSqlForList("select maxUploadFileSize from DocSecCategory where id="+attachmentDirs[2]);
				   String maxsize = "";
				   if(list.size()>0){
					   Map map = (Map)list.get(0);
					   maxsize = StringHelper.null2String(map.get("maxUploadFileSize"));
				   }
			   %>
			    <a href="javascript:void(0)"><div class="uploadDiv" mainId="<%=attachmentDirs[0]%>" subId="<%=attachmentDirs[1]%>" secId="<%=attachmentDirs[2]%>" maxsize="<%=maxsize%>"></div></a>
			   <%}else{ %>
			    <span style="color: red">附件上传目录未设置</span>
			   <%} %>
			  </div>
		  </div>
	   	 <%}else{ %>
			  <div class="optItem">
				  <div id="temp_title" class="opt_title" onclick="openApp(this,'<%=appVo.getAppType() %>')">
				    <img src="<%=appVo.getIconPath() %>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><a href="javascript:void(0)"><%=HtmlLabel.appHtmlLabel.get(appVo.getName()) %></a>
				  </div>
	
			  </div>
		  <%}} %>
</td>
	</tr>
	</table>
</div>
</body>
</html>
<script>
    //跳转到我的微博
	function toMyBlog(){
	   //if(jQuery(window.parent.document).find("#blogList").is(":hidden"))
	      onUrl('/blog/myBlog.jsp','我的微博','tab<%=userid%>'); 
	   //else
	   //   window.parent.location.href='blogView.jsp';   
	}
    
    //跳转到我的关注
    function toMyAttention(){
       if(jQuery(window.parent.document).find("#blogList").is(":hidden"))
          window.parent.location.href='blogView.jsp?item=attention';
	   else
	      window.location.href='myAttention.jsp'; 
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

function disAttention(status){
    var itemName="<%=blogHumres.getObjname()%>";
    var islower=0;
	if(status==4||status==2) islower=1;
	jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid=<%=blogid%>");
	jQuery("#cancelAttention").hide();
	jQuery("#addAttention").show();    
}

function addAttention(status){
    var itemName="<%=blogHumres.getObjname()%>";
    var islower=0;
    if(status==4||status==2) islower=1;
	jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid=<%=blogid%>");
	jQuery("#cancelAttention").show();
	jQuery("#addAttention").hide();     
}


function requestAttention(obj,attentionid,attentionName,islower){
	 jQuery.post("blogOperation.jsp?operation=requestAttention&islower="+islower+"&attentionid="+attentionid,function(){
	   alert("申请已经发送"); //申请已经发送
	 });
}
    
jQuery(function(){
	jQuery(".tabStyle2 li").click(function(obj){
			jQuery(".tabStyle2 li").each(function(){
				jQuery(this).removeClass("select2");
			});
			jQuery(this).addClass("select2");
			var url=jQuery(this).attr("url");
			var tabid=jQuery(this).attr("id");
			
			if(tabid=="blog")
			   jQuery("#searchDiv").show();
			else
			   jQuery("#searchDiv").hide();   
			
			displayLoading(1,"page"); 
			jQuery.post(url,{},function(a){
				jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
				
				//显示今天编辑器
				jQuery(".editor").each(function(){
				 if(jQuery(this).css("display")=="block"){
					 showAfterSubmit(this);
					}
			    });
				    
				if(tabid=="blog"){
				    //图片缩小处理   
					jQuery('.reportContent img').each(function(){
					    initImg(this);
					});
					
					//上级评分初始化
					jQuery(".blog_raty").each(function(){
					   if(jQuery(this).attr("isRaty")!="true"){
					       managerScore(this);
					       jQuery(this).attr("isRaty","true"); 
			           }
					})
				}else if(tabid=="report"){  
				    jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
				}
				displayLoading(0);
			});
		});
		displayLoading(0);
		if(<%=status%>>0||'<%=userid%>'=='<%=blogid%>'){
		    displayLoading(1,"page"); 
		    jQuery(".tabStyle2 li:first").click();
		    getIndex('<%=blogid%>'); 
		}
		jQuery(document.body).bind("click",function(){
			jQuery(".dropDown").hide();
			jQuery(".opt_items").hide();
	    });
		try{
			parent.displayLoading(0);
		}catch(e){
			
		}
		try{
			displayLoading(0);
		}catch(e){
			
		}
});
function openApp(obj,type){
	   var editorId=jQuery(obj).parents(".editor").find("textarea[name=submitText]").attr("id");
	   var htmlstr="";
	   if(type=='doc')
	      htmlstr=onShowDoc();
	   else if(type=='project')   
	      htmlstr=onShowProject();
	   else if(type=='task')   
	      htmlstr=onShowTask();
	   else if(type=='crm')   
	      htmlstr=onShowCRM();
	   else if(type=='workflow')   
	      htmlstr=onShowRequest();
	         
	   KE.insertHtml(editorId,htmlstr);
	} 
   //添加到收藏夹
    function openFavouriteBrowser(){
	   var url=window.location.href;
	   fav_uri=url.substring(url.indexOf("/blog/"),url.length)+"&";
	   fav_uri = encodeURIComponent(fav_uri,true); 
	   var fav_pagename=jQuery("title").html();
	   window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
    }
   
</script>
<SCRIPT language="javascript" src="/ecology/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/main.js"></script>
<SCRIPT language="javascript"  src="/datapicker/WdatePicker.js"></script>


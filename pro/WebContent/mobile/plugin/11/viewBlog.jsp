<%@ page language="java" pageEncoding="UTF-8"%> 
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%

	String module = StringHelper.null2String((String)request.getParameter("module"));
	String scope = StringHelper.null2String((String)request.getParameter("scope"));

	String title = StringHelper.null2String((String)request.getParameter("title"));
	String titleurl = URLEncoder.encode(title);

	String clienttype = StringHelper.null2String((String)request.getParameter("clienttype"));
	String clientlevel = StringHelper.null2String((String)request.getParameter("clientlevel"));
	String sessionKey = StringHelper.null2String(request.getParameter("sessionkey"));
	String userid= sessionKey;
	ServiceUser user = new ServiceUser();
	user.setId(userid);
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title><%=title %></title>
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="/mobile/plugin/11/js/mylibs/showLoading/jquery.showLoading.js"></script>
	<script type="text/javascript" src="/mobile/plugin/js/asyncbox/AsyncBox.v1.4.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/js/asyncbox/skins/ZCMS/asyncbox.css">
	<link rel="stylesheet" href="/mobile/plugin/11/css/blog.css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile.css" type="text/css">
	<script type="text/javascript" src="/mobile/plugin/11/js/blog.js"></script>
	<script type="text/javascript" src="/mobile/plugin/11/js/script.js"></script>
	<script type="text/javascript">
	/*
	function afterAndroidRedirect(id, flag) {
		try {
			if ((flag + "") == "1") { 
				$("#wfisnew_" + id).remove();
				$("#wf_" + id).remove();
			}
		} catch(e) {
		}
	}
	*/
	
	var today=new Date();
	
	function showItemDetailed(requestid,isnew) {
		//var path = "/workflow/edit.do?requestid=" + requestid + "&module=" + $("input[name='module']").val() + "&scope=" + $("input[name='scope']").val() + "&unread=false&isnew=" + isnew;
		//window.location.href = path;
	} 

	$(document).ready(function () {
		//alert(1111111);
		bindNavEvent();
		//加载数据
		getDataList(getUrlParam("view"), true);
	});
	
	/**
	 * 获取url参数
	 */
	function getUrlParam(type,enddatestr) {
		var sessionkey = $("input[name='sessionkey']").val();
		var module = $("input[name='module']").val();
		var scope = $("input[name='scope']").val();
		var blogid = $("input[name='blogid']").val();
		var userid = $("input[name='userid']").val();
		var pagesize =config.newListPageSize;
		var paras = "method=getpage&dataType=json&userid="+userid+"&";
		if (type=="more") {
			paras=paras+"operation=getBlogListBydate&blogid="+blogid; //加载非第一页
		}else if(type=="view") {
		    paras=paras+"operation=viewBlog&blogid="+blogid;            //加载第一页
		}
		else if(type=="saveBlog") {
		    paras=paras+"operation=saveBlog";            //提交微博
		}
		else if(type=="replyBlog")    
		    paras=paras+"operation=saveBlogReply";       //提交评论
		else if(type=="updateBlog")    
		    paras=paras+"operation=updateBlog";          //更新微博
		else if(type=="sendRemind")    
		    paras=paras+"operation=sendRemind";          //更新微博    
		paras =paras+"&sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&pagesize=" + pagesize + 
			"&tk" + new Date().getTime() +"=1";
		
		if (!util.isNullOrEmpty(enddatestr)) {
			paras += "&enddatestr=" + enddatestr;
		}
		return paras;
	}
	
	function getDataList(paras, isFirst){
	    util.getData({
	    	"loadingTarget" : document.body,
    		"paras" : paras,//得数据的URL,
    		"callback" : function (data){
		    	if(data.error){
		    		$("#listArea").html("<div class=\"listitem listitemmore\">没有数据</div>");
				} else {
				   
				    //验证权限 status<=0没有查看权限
				    if(data.status<=0){
				       $("#listArea").html("<div class=\"listitem listitemmore\">没有查看权限</div>");
				       return ;
				    }
				       
				
					var pageindex = data.pageindex;
					var pagesize = data.pagesize;
					var count = data.count;
					var ishavepre = data.ishavepre;
					var ishavenext = data.ishavenext
					var pagecount = data.pagecount;
					$("input[name='pageindex']").val(pageindex);
					$("input[name='pagesize']").val(pagesize);
					$("input[name='count']").val(count);
					$("input[name='ishavepre']").val(ishavepre);
					$("input[name='ishavenext']").val(ishavenext);
					$("input[name='pagecount']").val(pagecount);
					var listItemString = "<div id=\"pagecontent_" + pageindex + "\">";
					var currentPageDataCnt = 0;
					 
					today=new Date(data.todaydate.replace(/-/g,"/")); 
					 
					var enddatestr=data.enddatestr;    //分页结束时间
					$("input[name='enddatestr']").val(enddatestr);
					//用户微博信息
					if(isFirst){
					
					   //菜单数字提醒
					   var unReadCount=data.menuItemCount.unReadCount;
					   var remindCount=data.menuItemCount.remindCount;
						
					   $("#unReadCount").html(unReadCount>0?"("+unReadCount+")":"");
					   $("#remindCount").html(remindCount>0?"("+remindCount+")":"");
					
					   var userInfo=data.userInfo;
					   var username=userInfo.username;
					   var deptName=userInfo.deptName;
					   var subName=userInfo.subName;
					   var jobtitle=userInfo.jobtitle;
					   var attentionCount=userInfo.attentionCount;
					   
					   var imageUrl=userInfo.imageUrl;
					   var attentionMeCount=userInfo.attentionMeCount;
					   var blogCount=userInfo.blogCount;
					   
					   var attentionName="他关注";
					   var attentionMeName="关注他";
					   if(data.currentuserid==userInfo.userid){
					      attentionName="我关注";
					      attentionMeName="关注我";
					   }else if(userInfo.sex=="1"){
					      attentionName="她关注";
					      attentionMeName="关注她";
					   }
					   
					   var userInfostr="<div class='persnlblock'>"
									+"<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
									+"	<tr>"
									+"		<td width='5px'>"
									+"		</td>"
									+"		<td width='44px'>"
									+"			<img src='/download.do?url="+imageUrl+"' width='39px' height='39px'>"
									+"		</td>"
									+"		<td width='*'>"
									+"			<div class='namedepmtblock' >"
									+"				<span class='namespan'>"+username+"&nbsp;&nbsp;</span><span class='depmtspan'>"+jobtitle+"</span>"
									+"			</div>"
									+"			<div class='addressblock'>"+subName+"&nbsp;&nbsp;"+deptName+"</div>"
									+"		</td>"
									+"		<td width='5px'>"
									+"		</td></tr></table>"
									+"	</div>"
									+"<div class='blankLines'>&nbsp;</div>"
									+"	<div class='blogrelevantblock'>"
									+"		<span class='bloginfospan'>微博"+blogCount+"条&nbsp;&nbsp;</span>"
									+"		<span class='bloginfospan'>"+attentionName+attentionCount+"人&nbsp;&nbsp;</span>"
									+"		<span class='bloginfospan'>"+attentionMeName+attentionMeCount+"人</span>"
									+"	</div>";
									
						$("#userInfo").html(userInfostr);			
					}
					
					//今天提交编辑器
					var todayIssubmit=data.todayIssubmit;  //今天是否已经提交
					var isCurrentUser=data.isCurrentUser;  //是否为当前用户
					
					var todaydate=today.pattern("yyyy-MM-dd");
					var todaydatetemp=today.pattern("MM月dd日");
					var week = {"0" : "周日","1" : "周一","2" : "周二","3" : "周三", "4" : "周四","5" : "周五","6" : "周六"};
					var weekday=week[today.getDay()];      
					
					if(isCurrentUser==1){
					    var todaystr="<div class='listitem' onclick='javascript:showItemDetailed();' isToday='true' workdate='"+todaydate+"' userid='"+data.currentuserid+"'>"
									+" 	<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
									+"		<tr>"
									+"			<TD class='itempreview' valign='top'>"
									+"				<div class='dateblock'>"
									+"					<div class='weekdspblock'>今天</div>"
									+"					<div class='captdtblock'>"+todaydatetemp+"</div>"
									+"				</div>"
									+"			</TD>"
									+"			<TD class='itemcontent'>"
									+"				<div class='bloginputblock'>"
									+"					<textarea style='width:100%;margin-top:5px;height:40px' onfocus='this.style.height=\"80px\"' onblur='if(this.value==\"\") this.style.height=\"40px\";' name='content'/>"
									+"				</div>"
									+"				<div class='operationBt' onclick='doSave(this)' action='saveBlog'>保存</div>"
									+"			</TD>"
									+"			<TD class='itemnavpoint'>"
									+"			</TD>"
									+"		</TR>"
									+"	</TABLE>"
									+"  </div>";
					    $("#listArea").append(todaystr);
					}
					
					if(data.discessList.length==0&&ishavenext!="1")
					   listItemString=listItemString+"<div class=\"listitem listitemmore\">没有发表微博</div>";
					
					$.each(data.discessList, function (i, item){ 
						currentPageDataCnt++;
						var workdate=item.workdate;
						var discussid=item.id;
						var userid=item.userid;
						var isTodayItem=todaydate==workdate?"true":"false";
						var unsubmit=discussid==""?"true":"false";
                        var itemstr="<div class='listitem' onclick='javascript:showItemDetailed();' workdate='"+workdate+"' discussid='"+discussid+"' userid='"+userid+"' isTodayItem='"+isTodayItem+"' unsubmit='"+unsubmit+"'>";
                        itemstr=itemstr+getDiscuddItem(item,data.currentuserid);
                        itemstr=itemstr+" </div>";
                        
                        listItemString=listItemString+itemstr;
					
					});
					
					listItemString += "</div>";
					if (isFirst == true && currentPageDataCnt != 0) {
						//$("#listArea").html("");
						if (ishavenext == "1") {
							listItemString += "<div class=\"listitem listitemmore\" id=\"listItemMore\">更多...</div>";
						}
						
						$("#listArea").append(listItemString);

						$("#listItemMore").bind("click", function () {
							$("#listItemMore").html("<img src=\"/mobile/plugin/11/images/ajax-loader.gif\" style=\"vertical-align:middle;\">&nbsp;正在加载...");
							getDataList(getUrlParam("more",$("input[name='enddatestr']").val()), false);
						});
					} else {
						$("#listItemMore").before(listItemString);
						if (ishavenext == "1") {
							$("#listItemMore").html("更多...");
						} else {
							$("#listItemMore").hide();
						}
					}
					
				}
			}
	    });
	    //最后更新时间
	    $("#lastupdatedate").html("最后更新&nbsp;今天：" + util.getCurrentDate4Format("hh:mm:ss") + "&nbsp;&nbsp;");
    }
    /**
     * resize
     */
	window.onresize = function () {
	};
	
	function openBlog(blogid){
	   jQuery(document.body).showLoading();
	   window.location.href="/mobile/plugin/11/viewBlog.jsp?userid=<%=userid%>&module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&blogid="+blogid;
	};
	function goBack() {
		location = "/home.do";
	}
</script>
</head>
<%
 String blogid=request.getParameter("blogid");
 blogid=blogid==null?"":blogid;
%>
<body onload="setTimeout(function() { window.scrollTo(0, 1) }, 100);" />
<div id="view_page">
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width: 100%; height: 40px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title"><%=title %></div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>
	<div  class="content" style="background:#fff;">
		<!-- 存放必须数据区域 START -->
		<input type="hidden" name="sessionkey" value="<%=request.getParameter("mobileSession") %>">
		<input type="hidden" name="module" value="<%=request.getParameter("module") %>">
		<input type="hidden" name="scope" value="<%=request.getParameter("scope") %>">
		<!-- 当前页索引 -->
		<input type="hidden" name="pageindex" value="">
		<!-- 每页记录条数 -->
		<input type="hidden" name="pagesize" value="5">
		<!-- 总记录条数 -->
		<input type="hidden" name="count" value="">
		<!-- 是否有上一页 -->
		<input type="hidden" name="ishavepre" value="">
		<!-- 是否有下一页 -->
		<input type="hidden" name="ishavenext" value="">
		<!-- 总页数 -->
		<input type="hidden" name="pagecount" value="">
		
		<!-- 分页结束日期 -->
		<input type="hidden" name="enddatestr" value="">
		<!-- 当前被查看的微博id -->
		<input type="hidden" name="blogid" value="<%=blogid%>">
		<!-- 当前登陆者id -->
		<input type="hidden" name="userid" value="<%=userid%>">
		
		<!-- 存放必须数据区域 END -->
		
		
		<!-- 微薄顶部导航区域 START -->
		
		<div class="navblock">
			<div class="navbtnblock">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;color:#395582;">
					<tr>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter navbtnleft" url="/mobile/plugin/11/mainPage.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=userid%>">
								主页<span id="unReadCount"></span>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter" url="/mobile/plugin/11/list.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=userid%>">
								关注<span id="attentionCount"></span>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn <%="".equals(blogid)?"navbtnslt":""%> navbtncenter" navbtncenter" url="/mobile/plugin/11/viewBlog.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=userid%>">
								我的
							</div>
						</td>
						<td width="*" align="center">
							<div class="navbtn navbtncenter navbtnright" url="/mobile/plugin/11/comment.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=userid%>">
								评论<span id="remindCount"></span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<!-- 微薄顶部导航区域 END -->
		
		<!-- 微博信息 -->
		<div class="pdecblock" id="userInfo"></div>
		
		<div class="blankLines"></div>
		
		<!-- 列表区域 -->
		<div class="listArea" id="listArea"></div>
		
		<div class="lastupdatedate" id="lastupdatedate">
			最后更新&nbsp;今天：16:12:18&nbsp;&nbsp;
		</div>
	</div>
	</div>
</body>
</html>

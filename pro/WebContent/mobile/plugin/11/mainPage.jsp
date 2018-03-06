<%@ page language="java" pageEncoding="utf-8"%>
<%
	String userid = request.getParameter("userid");
%>
<!DOCTYPE html>
<html>
<head>
	<title>Blog Home</title>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
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
	function showItemDetailed(requestid,isnew) {
		//var path = "/workflow/edit.do?requestid=" + requestid + "&module=" + $("input[name='module']").val() + "&scope=" + $("input[name='scope']").val() + "&unread=false&isnew=" + isnew;
		//window.location.href = path;
	} 

	$(document).ready(function () {
		bindNavEvent();
		//加载数据
		getDataList(getUrlParam("view"), true);
	});
	
	/**
	 * 获取url参数
	 */
	function getUrlParam(type,pageindex) {
		var sessionkey = $("input[name='sessionkey']").val();
		var module = $("input[name='module']").val();
		var scope = $("input[name='scope']").val();
		var userid = $("input[name='userid']").val();
		var pagesize = config.newListPageSize;
		var paras = "method=getpage&dataType=json&userid="+userid+"&";
		if (type=="more") {
			paras=paras+"operation=getBlogDynamic"; 			  //加载非第一页
		}else if(type=="view") {
		    paras=paras+"operation=viewBlogDynamic";            //加载第一页
		}
		else if(type=="saveBlog")
		    paras=paras+"operation=saveBlog";            //提交微博
		else if(type=="replyBlog")    
		    paras=paras+"operation=saveBlogReply";       //提交评论
		else if(type=="markRead")    
		    paras=paras+"operation=markBlogRead";          //标记已读
		    
		paras =paras+"&sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&pagesize=" + pagesize + 
			"&tk" + new Date().getTime() +"=1";
			
		if (!util.isNullOrEmpty(pageindex)) {
			paras += "&pageindex=" + pageindex;
		}
		
		return paras;
	}
	
	
	function getDataList(paras, isFirst){
	    util.getData({
	    	"loadingTarget" : document.body,
    		"paras" : paras,//得数据的URL,
    		"callback" : function (data){
		    	if(data.error){
		    		$("#listArea").html("<div class=\"listitem listitemmore\">没有数据</div><div class=\"blankLines\"></div>");
				} else {
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
					
					//第一次加载时
					if(isFirst){
					     
					    $("#listArea").html(""); 
					    
					    //菜单数字提醒
						var unReadCount=data.menuItemCount.unReadCount;
						var attentionCount=data.menuItemCount.attentionCount;
						var remindCount=data.menuItemCount.remindCount;
						
						$("#unReadCount").html(unReadCount>0?"(<span class='count'>"+unReadCount+"</span>)":"");
						$("#remindCount").html(remindCount>0?"(<span class='count'>"+remindCount+"</span>)":"");
						
					}
					
					var listItemString = "<div id=\"pagecontent_" + pageindex + "\">";
					var currentPageDataCnt = 0;
					var todayIssubmit=data.todayIssubmit;  //今天是否已经提交 
					if(data.discussList.length==0&&todayIssubmit!=0){
					   $("#listArea").append("<div class=\"listitem listitemmore\">没有发表微博</div><div class=\"blankLines\"></div>");
					}
					
					$.each(data.discussList, function (i, item){ 
						currentPageDataCnt++;

						var workdate=item.workdate;
						var discussid=item.id;
						var userid=item.userid;
						var isread=item.isnew;
                        var itemstr="<div class='listitem' workdate='"+workdate+"' discussid='"+discussid+"' userid='"+userid+"' isread='"+isread+"' onmousemove='markRead(this)'>";
                        itemstr=itemstr+getDiscuddItem(item,"0");
                        itemstr=itemstr+" </div><div class='blankLines'></div>";
                        
                        listItemString=listItemString+itemstr;
					});
					
					listItemString += "</div>";
					if (isFirst == true && currentPageDataCnt != 0) {
						
						if (ishavenext == "1") {
							listItemString += "<div class='listitem listitemmore' id='listItemMore'>更多...</div><div class=\"blankLines\"></div>";
						}
						
						$("#listArea").append(listItemString);

						$("#listItemMore").bind("click", function () {
							$("#listItemMore").html("<img src=\"/mobile/plugin/11/images/ajax-loader.gif\" style=\"vertical-align:middle;\">&nbsp;正在加载...");
							getDataList(getUrlParam("more",parseInt($("input[name='pageindex']").val()) + 1), false);
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
    
   //已读标记 
   function markRead(obj){
     var item=$(obj);
     if(item.attr("isread")=="0"){
        item.attr("isread","1");
        var discussid=item.attr("discussid");
        var blogid=item.attr("userid");
        
        var paras=getUrlParam("markRead");
        paras=paras+'&discussid='+discussid+"&blogid="+blogid; 
        util.getData({
    		"paras" : paras,//得数据的URL,
    		"callback" : function (data){
    		    item.find(".img_new").hide();
    		    var count=$("#unReadCount .count").text();
    		    count=count-1;
    		    if(count>0)
    		      $("#unReadCount").html(count>0?"(<span class='count'>"+count+"</span>)":"");
    		    else 
    		      $("#unReadCount").hide();  
    		}
       });
     }
   } 
    
   function getDiscuddItem(item,isCurrentUser){
        
        var today=new Date();
		var todaydate=today.pattern("yyyy-MM-dd");
        var week = {"0" : "周日","1" : "周一","2" : "周二","3" : "周三", "4" : "周四","5" : "周五","6" : "周六"};
        var weekday="";
        
        var discussid=item.id;
        var userid=item.userid;
        var username=item.username;
		var workdate=item.workdate;
		var tempdate=new Date(workdate.replace(/-/g,"/"));
		var workdatetemp=tempdate.pattern("MM月dd日");
		if(workdate==todaydate)
		   weekday="今天";
		else   
		   weekday=week[tempdate.getDay()];
		
		var isCanAppend=(isCurrentUser==1)&&(getDaydiff(todaydate,workdate)<=7);  //是否可以补交
		var isCanEdit=(isCurrentUser==1)&&(getDaydiff(todaydate,createdate)<=3);  //是否可以编辑
		
		var listItemString="";
		    
	    var isReplenish=item.isReplenish;
	    var content=item.content;
	    var createdate=item.createdate
	    var createtime=item.createtime;
	    var createtimetemp=(new Date(createdate.replace(/-/g,"/")+" "+createtime)).pattern("MM月dd日 HH:mm");
	    var imageurl=item.imageurl;
	    var isnew=item.isnew;
	    var comefrom=item.comefrom;
		    if(comefrom=="1")  
		        comefrom="(来自Iphone)";
		    else if(comefrom=="2")  
		        comefrom="(来自Ipad)";
		    else if(comefrom=="3")  
		        comefrom="(来自Android)";          
		    else if(comefrom=="4")  
		        comefrom="(来自Web手机版)";
		    else
		        comefrom="";    
	    
	    
	    todaydate=today.pattern("yyyy-MM-dd");
	    
	    //回复内容
	    var replaystr="";
		$.each(item.replyVoArray,function(i,replyItem){
		    replaystr=replaystr+getReplyItem(replyItem);
		});
		
		listItemString ="<table class='tblItemTitle' width='100%' height='100%' border='0' cellspacing='0' cellpadding='0'>"
					+"		<tr>"
					+"			<TD class='itempreview' valign='top'>"
					+"				<img src='/downloadpic.do?url="+imageurl+"'>"
					+"			</TD>"
					+"			<TD class='itemcontent' valign='top' >"
					+"				<div class='itemcontenttitle'>"
					+"					<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
					+"						<tr>"
					+"							<TD class='ictwz' valign='top'>"
					+"								<span class='ictwz_gw' onclick='openBlog("+userid+")'>"+username+"</span>"
					+"								<span class='ictwz_img'><IMG src='/mobile/plugin/11/images/blog/"+(isReplenish=="1"?"stateAppend.png":"stateOk.png")+"'></span>"
					+"								<span class='ictwz_tm'>"+createtimetemp+"</span>"
					+"							</TD>"	
					+"						</TR>"
					+"						<TR>"
					+"							<TD class='itemoperation'>"
					+"								"+(isCanEdit?"<div onclick='doEdit(this)'>编辑</div>":"")
					+"								<div onclick='showReply(this,0)'>评论</div>"
					+"								<div onclick='showReply(this,1)'>私评</div>"
					+"							</TD>"
					+"						</TR>"
					+"					</TABLE>"
					+"				</div>" 				
					+"			</TD>"
					+"			<TD class='itemnavpoint'></TD>"
					+"		</TR>"
					+"		<TR  style='height:5px;'><TD></TD></TR>"
					+"		<TABLE>"
					+"		<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0'>"
					+"		<TR>"
					+"			<TD>"
					+"				<div class='itemcontentitdt'>"
					+"                <div class='blogCotent'>"+content+"</div>"
			        +"                <div class='reply'>"+replaystr+"</div>"
			        +"				  <div class='fromBlock' style='clear:both'>"+comefrom+"</div>"
					+"				</div>"
					+"			</TD>"
					+"		</TR>"
					+"	</TABLE>"
	
		
					
      return listItemString;
      
    } 
	
	function openBlog(blogid){
	   jQuery(document.body).showLoading(); 
	   window.location.href="viewBlog.jsp?userid=<%=request.getParameter("userid")%>&module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&blogid="+blogid;
	}
	
	function goBack() {
		location = "/home.do";
	}
	</script>
</head>

<body onload="setTimeout(function() { window.scrollTo(0, 1) }, 100);" />
<div id="view_page">
	<div id="view_header">
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
					<div id="view_title">工作微博</div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>
	<div  class="content">
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
		<!-- 当前登陆者id -->
		<input type="hidden" name="userid" value="<%=userid%>">
		
		<!-- 存放必须数据区域 END -->
		
		<!-- 微薄顶部导航区域 START -->
		
		<div class="navblock">
			<div class="navbtnblock">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;color:#395582;">
					<tr>
						<td width="25%" align="center">
							<div class="navbtn navbtnslt navbtnleft" url="/mobile/plugin/11/mainPage.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>">
								主页<span id="unReadCount"></span>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter" url="/mobile/plugin/11/list.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>">
								关注<span id="attentionCount"></span>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter" url="/mobile/plugin/11/viewBlog.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>">
								我的
							</div>
						</td>
						<td width="*" align="center">
							<div class="navbtn navbtncenter navbtnright" url="/mobile/plugin/11/comment.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>">
								评论<span id="remindCount"></span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<!-- 微薄顶部导航区域 END -->
		
		
		<!-- 列表区域 -->
		<div class="listArea" id="listArea"></div>
		
		<div class="lastupdatedate" id="lastupdatedate">
			最后更新&nbsp;今天：16:12:18&nbsp;&nbsp;
		</div>
	</div>
	</div>
</body>
</html>

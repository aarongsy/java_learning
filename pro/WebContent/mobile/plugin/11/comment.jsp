<%@ page language="java" pageEncoding="UTF-8"%>
<%
	String userid = request.getParameter("userid");
%>
<!DOCTYPE html>
<html>
<head>
	<title>BLog Comment</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
	var today=new Date();
	
	function showItemDetailed(requestid,isnew) {
		//var path = "/workflow/edit.do?requestid=" + requestid + "&module=" + $("input[name='module']").val() + "&scope=" + $("input[name='scope']").val() + "&unread=false&isnew=" + isnew;
		//window.location.href = path;
	} 

	$(document).ready(function () {
		bindNavEvent();
		//加载数据
		getDataList(getUrlParam("comment"), false);
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
		var pagesize = config.newListPageSize;
		var paras = "method=getpage&dataType=json&userid="+userid+"&";
		if (type=="more") {
			paras=paras+"operation=getBlogListBydate&blogid="+blogid; //加载非第一页
		}else if(type=="view") {
		    paras=paras+"operation=viewBlog&blogid="+blogid;            //加载第一页
		}
		else if(type=="saveBlog")
		    paras=paras+"operation=saveBlog";            //提交微博
		else if(type=="replyBlog")    
		    paras=paras+"operation=saveBlogReply";       //提交评论
		else if(type=="updateBlog")    
		    paras=paras+"operation=updateBlog";          //更新微博
		else if(type=="sendRemind")    
		    paras=paras+"operation=sendRemind";          //更新微博    
		else if(type=="comment")    
		    paras=paras+"operation=getCommentList";      //获得评论      
		paras =paras+"&sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&pagesize=" + pagesize + 
			"&module="+ module +
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
					
					//菜单数字提醒
					var unReadCount=data.menuItemCount.unReadCount;
					var attentionCount=data.menuItemCount.attentionCount;
					var remindCount=data.menuItemCount.remindCount;
						
					$("#unReadCount").html(unReadCount>0?"("+unReadCount+")":"");
					$("#remindCount").html(remindCount>0?"("+remindCount+")":"");
					
					today=new Date(data.todaydate.replace(/-/g,"/")); 
					
					var listItemString = "<div id=\"pagecontent_" + pageindex + "\">";
					var currentPageDataCnt = 0;
					
					if(data.discussList.length==0)
					   listItemString=listItemString+"<div class=\"listitem listitemmore\">没有评论</div><div class=\"blankLines\"></div>";
					
					$.each(data.discussList, function (i, item){ 
						currentPageDataCnt++;
						var workdate=item.workdate;
						var discussid=item.id;
						var userid=item.userid;
						
                        var itemstr="<div class='listitem' onclick='javascript:showItemDetailed();' workdate='"+workdate+"' discussid='"+discussid+"' userid='"+userid+"'>";
                        itemstr=itemstr+getDiscuddItem(item,data.currentuserid);
                        itemstr=itemstr+" </div><div class='blankLines'></div>";
                        
                        listItemString=listItemString+itemstr;
					
					});
					
					listItemString += "</div>";
					
					$("#listArea").append(listItemString);
					
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
	<div  class="content" style="background:#fff;">
		<!-- 存放必须数据区域 START -->
		<input type="hidden" name="sessionkey" value="<%=request.getParameter("mobileSession") %>">
		<input type="hidden" name="module" value="<%=request.getParameter("module") %>">
		<input type="hidden" name="scope" value="<%=request.getParameter("scope") %>">
		<input type="hidden" name="userid" value="<%=userid%>">
		
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
		
		<!-- 存放必须数据区域 END -->
		
		<!-- 微薄顶部导航区域 START -->
		
		<div class="navblock">
			<div class="navbtnblock">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;color:#395582;">
					<tr>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter navbtnleft" url="/mobile/plugin/11/mainPage.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>">
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
							<div class="navbtn navbtnslt navbtnright" url="/mobile/plugin/11/comment.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>">
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

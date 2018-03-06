<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%

String clienttype = StringHelper.null2String(request.getParameter("clienttype"));
 %>
<html>
<head>
	<title>新建流程</title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<!-- private css -->
	<script type='text/javascript' src='/js/jquery/1.6.2/jquery.min.js'></script>
		<style type="text/css">
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		background: #00538D;
	}
	a {
		text-decoration: none;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
	}
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	#header #title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
	/* 流程搜索区域 */
	.search {
		width: 100%;
		height: 42px;
		text-align: center;
		position: relative;
		background: #7F94AF;
		background: -moz-linear-gradient(0, #A4B0C0, #7F94AF);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(#A4B0C0), to(#7F94AF) );
		border-bottom: 1px solid #5D6875;
	}
	/* 流程搜索text */
	.searchText {
		width: 100%;
		height: 28px;
		margin-left: auto;
		margin-right: auto;
		border: 1px solid #687D97;
		background: #fff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		border-radius: 5px;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	}
	.prompt {
		color: #777878;
	}
	/* 列表区域 */
	.listArea {
		width: 100%;
		background: url(/mobile/images/bg_w_75.png);
	}
	/* 列表项*/
	.listitem {
		width: 100%;
		height: 60px;
		background: url(/mobile/images/bg_w_25.png);
		border-bottom: 1px solid #D8DDE4;
	}
	/* 列表项后置导航 */
	.itemnavpoint {
		height: 100%;
		width: 26px;
		text-align: center;
	}
	/* 列表项后置导航图  */
	.itemnavpoint img {
		width: 10px;
		heigth: 14px;
	}
	/* 流程创建人头像区域  */
	.itempreview {
		height: 100%;
		width: 50px;
		text-align: center;
	}
	/* 流程创建人头像  */
	.itempreview img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 14px;
	}
	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-weight: bold;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		font-size: 5px;
	}
	/* 列表项内容简介 */
	.itemcontentitdt {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-size: 12px;
		color: #777878;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	/* 更多 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		font-weight: bold;
		color: #777878;
		background:url(/mobile/images/bg_w_75.png);
	}
	/* 列表更新时间 */
	.lastupdatedate {
		width: 100%;
		height: 20px;
		text-align: right;
		font-size: 12px;
		line-height: 20px;
		background: #E1E8EC;
		background: -moz-linear-gradient(0, white, #E1E8EC);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(white),
			to(#E1E8EC) );
	}
	/* 间隔 */
	.blankLines {
		width: 100%;
		height: 1px;
		overflow: hidden;
	}
	/* 列表项标题 */
	 .ictwz {
		width: *;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		font-size: 12px;
		font-weight: bold;
		color:blue;
		
	}
	/* new */
	.ictnew {
		width: 20px;
	}
	</style>
	<script type="text/javascript">

	function showItemDetailed(requestid) {
		var path = "/mobile/plugin/1/view.jsp?workflowid=" + requestid + "&module=" + $("input[name='module']").val() + "&scope=" + $("input[name='scope']").val() + "&unread=false";
		window.location.href = path;
	} 

	$(document).ready(function () {
		bindSearch();
		//加载数据
		getDataList(getUrlParam(), true);
		$(".searchText").css("width", window.innerWidth - 40);
	});

	function bindSearch() {
		$("#keyword").bind("keydown", function() {
			if (event.keyCode == 13) {
				$("input[name='keyword']").val($(this).val());
				$("#listArea").html("");
				$(this).blur();
				//加载数据
				getDataList(getUrlParam(null, $("input[name='keyword']").val()), true);
			}
		});
		$("#searchit").bind("click", function() {
			    $("input[name='keyword']").val($("#keyword").val());
				$("#listArea").html("");
				$("#keyword").blur();
				//加载数据
				getDataList(getUrlParam(null, $("input[name='keyword']").val()), true);
		});
	}
	
	/**
	 * 获取url参数
	 */
	function getUrlParam(pageindex, keyword) {
		var sessionkey = $("input[name='sessionkey']").val();
		var module = $("input[name='module']").val();
		var scope = $("input[name='scope']").val();
		var pagesize = 20;
		var paras = "/mobile/plugin/1/createlist.jsp?sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&pagesize=" + pagesize + 
			"&tk" + new Date().getTime() + "=1";
		if (!isNullOrEmpty(keyword)) {
			paras += "&keyword=" + keyword;
		}
		if (!isNullOrEmpty(keyword)) {
			paras += "&pageindex=" + pageindex;
		}
		return paras;
	}
	function getData(para,passobj){
	    //if(para.loadingTarget!=null) jQuery(para.loadingTarget).showLoading();
		jQuery.ajax({
			type: "post",
		    url:  para.paras,
		    dataType: "json", 
		    contentType : "CHARSET=UTF-8", 
		    complete: function(){
				//if(para.loadingTarget!=null)  jQuery(para.loadingTarget).hideLoading();
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		       //alert(errorThrown);
		    } , 
		    success:function (data, textStatus) {
		    	para.callback.call(this,data,passobj);
		    } 
	    });
	}

	function isNullOrEmpty(data) {
		if (data == undefined || data == null || data == "") {
			return true;
		}
		return false;
	}	
	
   function getCurrentDate4Format(formatstring) {
		var testDate = new Date(); 
		var testStr = testDate.format(formatstring);
		return testStr;
	}
	function getDataList(paras, isFirst){
		
	    getData({
	    	"loadingTarget" : document.body,
    		"paras" : paras,//得数据的URL,
    		"callback" : function (data){
		    	if(data.error){
		    		$("#listArea").html("<div class=\"listitem listitemmore\">"+data.error+"</div><div class=\"blankLines\"></div>");
				} else if(data.errormsg) {
				    $("#listArea").html("<div class=\"listitem listitemmore\">"+data.errormsg+"</div><div class=\"blankLines\"></div>");
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
					var listItemString = "<div id=\"pagecontent_" + pageindex + "\"></div>";
					var currentPageDataCnt = 0;
					$.each(data.wfs, function (i, item){ 
						currentPageDataCnt++;	
						var wfid = item.wfid;
						var wftype = item.wftype;
						var wftitle = item.wftitle;
						var creatorpic = "-1";
						var appendNewEleString = wftitle;
						var creatorpicHtml = "";
                        var imageurl = "";
						if (isNullOrEmpty(creatorpic) || creatorpic == "-1") {
							creatorpicHtml = msgerurlImg = "<img src=\"/mobile/images/default.png\">";
							imageurl="/mobile/images/default.png";
						} else {
							creatorpicHtml = "<img src=\"/download.do?fileid=" + creatorpic + "\">";
							imageurl="/download.do?fileid=" + creatorpic;
						}
						
						listItemString += 
						    '<a href="javascript:showItemDetailed(\''+wfid+'\')">'+
							'<div class="listitem" id="id_'+wfid+'">'+
							'	<table style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">'+
							'		<tbody>'+
							'			<tr>'+
							'				<td class="itempreview">'+
							'					<img src="'+imageurl+'">'+
							'				</td>'+
							'				<td class="itemcontent">'+
							'					<div class="itemcontenttitle">'+
							'						<table style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">'+
							'							<tbody>'+
							'								<tr>'+
							'									<td class="ictwz">'+wftitle+'</td>'+
							(0==1?'					<td class=\"ictnew\" id=\"wfisnew_" + wfid + "\"><img src=\"/images/new.gif\" width=\"20\" ></td>':'')+
							'								</tr>'+
							'							</tbody>'+
							'						</table>'+
							'					</div>'+
							'					<div class="itemcontentitdt">&nbsp;&nbsp;所属模块:['+ wftype + ']</div>'+
							'				</td>'+
							'				<td class="itemnavpoint">'+
							'					<img src="/images/icon-right.png">'+
							'				</td>'+
							'			</tr>'+
							'		</tbody>'+
							'	</table>'+
							'</div>'+
							'<div class="blankLines"></div>'+
							'</a>';
					});
					//listItemString += "</div>";
					if (isFirst == true && currentPageDataCnt != 0) {

						if (ishavenext == "1") {
							listItemString += "<div class=\"listitem listitemmore\" id=\"listItemMore\">更多...</div><div class=\"blankLines\"></div>";
						}
						//alert(listItemString);
						//prompt('',listItemString);
						$("#listArea").html(listItemString);

						$("#listItemMore").bind("click", function () {
							$("#listItemMore").html("<img src=\"/images/ajax-loader.gif\" style=\"vertical-align:middle;\">&nbsp;正在加载...");
							getDataList(getUrlParam(parseInt($("input[name='pageindex']").val()) + 1, $("input[name='keyword']").val()), false);
						});
					} else {
						$("#listItemMore").before(listItemString);
						if (ishavenext == "1") {
							$("#listItemMore").html("更多...");
						} else {
							$("#listItemMore").hide();
						}
					}
					//设置列表宽度
					$(".itemcontenttitle").css("width", window.innerWidth - 85);
					$(".itemcontentitdt").css("width", window.innerWidth - 85);
					
					$.each($("#pagecontent_" + pageindex + " .ictwz"), function (index, item){
						if ($(this).width() > window.innerWidth - 85 - 20) {
							$(this).css("width", window.innerWidth - 85 - 20);	
						}
					});
				}
			}
	    });
	    //最后更新时间
	    $("#lastupdatedate").html("最后更新&nbsp;今天：" + getCurrentDate4Format("hh:mm:ss") + "&nbsp;&nbsp;");
    }
    /**
     * resize
     */
	window.onresize = function () {
		//设置列表宽度
		$(".itemcontenttitle").css("width", window.innerWidth - 85);
		$(".itemcontentitdt").css("width", window.innerWidth - 85);
		$(".searchText").css("width", window.innerWidth - 40);
		$.each($(".ictwz"), function (index, item){
			if ($(this).width() >= window.innerWidth - 85 - 20) {
				$(this).css("width", window.innerWidth - 85 - 20);	
			} else {
				$(this).css("width", "");	
			}
		});
		
	};
	
	function doSearch(){

	   var sessionkey = $("input[name='sessionkey']").val();
		var module = $("input[name='module']").val();
		var scope = $("input[name='scope']").val();
		var pagesize = config.newListPageSize;
		var keyword = $("#keyword").val();
		var paras = "/mobile/plugin/1/createlist.jsp&sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&keyword=" + encodeURIComponent(keyword) +
			"&tk" + new Date().getTime() + "=1";
       getDataList(paras, true);             	      
	}
	</script>
</head>

<body onload="setTimeout(function() { window.scrollTo(0, 1) }, 100);" />
		<!-- 存放必须数据区域 START -->
		<input type="hidden" name="sessionkey" value="<%=request.getParameter("sessionkey") %>">
		<input type="hidden" name="module" value="<%=request.getParameter("module") %>">
		<input type="hidden" name="scope" value="<%=request.getParameter("scope") %>">
		<input type="hidden" name="keyword" value=""/>
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
		
		<!-- 存放必须数据区域 END -->
		
		<!-- 搜索区域 -->
		<table id="page">
			<tr>
				<td width="100%" height="100%" valign="top" align="left">
				<%if(!ClientType.IPHONE.toString().equalsIgnoreCase(clienttype)) { %>
         <div id="header">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="/home.do">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;font-size:9pt;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title">创建流程</div>
					</td>
				</tr>
			</table>
		</div>
         <%} %>
		<div class="search">
			<input type="text" id="keyword" name="keyword" class="searchText prompt" style="position:absolute;top:6px;left:3px;width:88%;padding-left:35px;" value="">
			<input type="submit" id="searchit" value="" onclick="doSearch()" style="border:none;width: 25px; height: 25px; position: absolute; top: 12px; left: 10px;background:url('/images/icon-search.png') no-repeat;"/>

		</div>
         
		<!-- 列表区域 -->
		<div class="listArea" id="listArea">
		</div>
		<input type="submit" id="listItemMore" value="&#28857;&#20987;&#33719;&#21462;&#26356;&#22810;..." class="listitem listitemmore" style="border:none;"/>	
		<div class="lastupdatedate" id="lastupdatedate"></div>
	</td></tr></table>
</body>
</html>
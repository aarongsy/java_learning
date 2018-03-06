<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
	List<Skin> softwareSkinList = skinService.getSkinsBySkinType("0");	//软件模式皮肤
	List<Skin> websiteSkinList = skinService.getSkinsBySkinType("1");	//网站模式皮肤
%>
<html>
<head>
<title>skinChoose</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<style type="text/css">
html,body{
	border: 0px;
}
#skinChoose{
	margin: 5px 10px 2px 10px;
	
	/*display: none;*/	
}
#skinChoose .title{/*每种类型的皮肤相应的标题说明对应的样式*/
	position: relative;	/*定位*/
	height: 20px;		/*高度*/
}
#skinChoose .title .line{/*标题中的线*/
	position: absolute;			/*定位*/
	height: 1px;				/*高度*/
	width: 100%;				/*宽度*/
	border-top: 1px dotted #0282C4;/*上边框(宽度  样式  颜色)*/
	top: 10px;					/*距离顶部的距离*/
	left: 0px;					/*距离左边的距离*/
	z-index: 0;					/*z轴显示位置*/
}
#skinChoose .title .text{/*标题中的文本*/
	position: absolute;	/*定位*/
	background: #fff;	/*背景*/
	font-size: 12px;	/*字体大小*/
	padding: 0px 5px;	/*内边距（上下  左右）*/
	top: 4px;			/*距离顶部的距离*/
	left: 43%;			/*距离左边的距离*/
	z-index: 1;			/*z轴显示位置*/
	color: #0282C4;
}
#skinChoose .skinList{	/*皮肤列表框对应的样式*/
	height: 500px;	/*高度足够大,在js中会做调整*/
}
#skinChoose .skinList ul{
	margin: 0px;
	padding: 0px;
	list-style: none;
	height: 115px;
}
#skinChoose .skinList ul li{
	text-align: center;
	width: 160px;
	float: left;
	display: inline;
	margin: 5px 0px 5px 20px;
}
#skinChoose .skinList ul li span.preview{
	position: relative;
	width: 160px;
	height: 90px;
	display: block;
	background: url("/images/main/skinpreview-bg.png") no-repeat;
	overflow: hidden;
}
#skinChoose .skinList ul li span.preview:hover{
	background: url("/images/main/skinpreview-available-bg.png") no-repeat;
}
#skinChoose .skinList ul li span.selected{
	background: url("/images/main/skinpreview-available-bg.png") no-repeat;
}
#skinChoose .skinList ul li span.preview a{
	position:absolute;
	width: 140px;
	height: 70px;
	overflow: hidden;
	top: 10px;
	left: 10px;
	cursor: pointer;
}
#skinChoose .skinList ul li span.preview a img{
	width: 140px;
	height: 70px;
}
#skinChoose .skinList ul li span.skin-name{
	font-family: Microsoft YaHei;
	margin-top: 2px;
	color: #0282C4;
}
/*
#skinChoose .skinList a:hover img{ 
	border-color: #999;	
}
#skinChoose .skinList a img{ 
	height: 60px;	
	width: 100px;	
	margin-right: 20px;	
	margin-bottom: 20px;	
	border: 1px solid #DDDDDD;	
	padding: 1px;	
	cursor: pointer;	
}
#skinChoose .skinList a.selected img{
	border-color: red;	/*边框颜色
}*/
</style>
<script type="text/javascript">
//更新当前用户的皮肤
function changeSkin(mainPageType,skinId){
	if(!confirm("提示：更换皮换时会重新加载页面,您确定要更换皮肤吗？")){
		return;
	}
	
	Ext.Ajax.request({
	   url: "/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=changeCurrentUserSkin&id="+skinId+"&mainPageType="+mainPageType,
	   success: function(res){
			top.closeSkinChooseDialogAndToTargetUrl(res.responseText);
	   },
	   failure: function(res){
			alert('Error:'+res.responseText);
	   }
	});
}

function changeWebsiteSkinListHeight(skinListId, skinCount){
	var $skinList = $("#" + skinListId);
	var $oneSkin = $("#skinChoose .skinList ul li");
	var oneLineCanContainCount = parseInt($skinList.outerWidth(true) / $oneSkin.outerWidth(true));
	var lineCount;
	if((skinCount % oneLineCanContainCount) == 0){
		lineCount = skinCount / oneLineCanContainCount;
	}else{
		lineCount = parseInt(skinCount / oneLineCanContainCount) + 1;
	}
	$skinList.css("height", (lineCount * $oneSkin.outerHeight(true) + 5) + "px");
}

$(function(){
	changeWebsiteSkinListHeight("softwareSkinList", <%=softwareSkinList.size()%>);
	changeWebsiteSkinListHeight("websiteSkinList", <%=websiteSkinList.size()%>);
	changeWebsiteSkinListHeight("classicSkinList", 5);
});
</script>
</head>
  
<body>
  <div id="skinChoose">
	<div class="title">
		<div class="text">软件模式皮肤</div>
		<div class="line"></div>
	</div>
	<div class="skinList" id="softwareSkinList">
		<ul>
		<% for(Skin skin : softwareSkinList){ 
			String className = "";
			if(skin.getId().equals(currentSkin.getId()) && MainPageDefined.MAINPAGETYPE_NEW.equals(userMainPage.getType())){
				className = " selected";
			}
		%>
			<li>
				<span class="preview<%=className %>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_NEW %>','<%=skin.getId() %>');" class="preview-img"><img src="<%=skin.getPreviewPicPath() %>" title="<%=skin.getObjname() %>"/></a>
				</span>
				<span class="skin-name"><%=skin.getObjname() %></span>
			</li>
		<% } %>
		</ul>
	</div>
	
	<div class="title">
		<div class="text">网站模式皮肤</div>
		<div class="line"></div>
	</div>
	<div class="skinList" id="websiteSkinList">
		<ul>
		<% for(Skin skin : websiteSkinList){ 
			String className = "";
			if(skin.getId().equals(currentSkin.getId()) && MainPageDefined.MAINPAGETYPE_NEW.equals(userMainPage.getType())){
				className = " selected";
			}
		%>
			<li>
				<span class="preview<%=className %>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_NEW %>','<%=skin.getId() %>');" class="preview-img"><img src="<%=skin.getPreviewPicPath() %>" title="<%=skin.getObjname() %>"/></a>
				</span>
				<span class="skin-name"><%=skin.getObjname() %></span>
			</li>
		<% } %>
		</ul>
	</div>
	
	<div class="title">
		<div class="text">传统模式皮肤</div>
		<div class="line"></div>
	</div>
	<div class="skinList" id="classicSkinList">
		<ul>
			<li>
				<span class="preview<%if("default".equals(style) && MainPageDefined.MAINPAGETYPE_CLASSIC.equals(userMainPage.getType())){ %> selected<%}%>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_CLASSIC %>','default');" class="preview-img"><img src="/images/main/classic_skin_preview/light-blue.png" title="浅蓝色风格"/></a>
				</span>
				<span class="skin-name">浅蓝色风格</span>
			</li>
			<li>
				<span class="preview<%if("gray".equals(style) && MainPageDefined.MAINPAGETYPE_CLASSIC.equals(userMainPage.getType())){ %> selected<%}%>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_CLASSIC %>','gray');" class="preview-img"><img src="/images/main/classic_skin_preview/gray.png" title="灰色风格"/></a>
				</span>
				<span class="skin-name">灰色风格</span>
			</li>
			<li>
				<span class="preview<%if("purple".equals(style) && MainPageDefined.MAINPAGETYPE_CLASSIC.equals(userMainPage.getType())){ %> selected<%}%>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_CLASSIC %>','purple');" class="preview-img"><img src="/images/main/classic_skin_preview/purple.png" title="紫色风格"/></a>
				</span>
				<span class="skin-name">紫色风格</span>
			</li>
			<li>
				<span class="preview<%if("olive".equals(style) && MainPageDefined.MAINPAGETYPE_CLASSIC.equals(userMainPage.getType())){ %> selected<%}%>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_CLASSIC %>','olive');" class="preview-img"><img src="/images/main/classic_skin_preview/olive.png" title="绿色风格"/></a>
				</span>
				<span class="skin-name">绿色风格</span>
			</li>
			<li>
				<span class="preview<%if("light-orange".equals(style) && MainPageDefined.MAINPAGETYPE_CLASSIC.equals(userMainPage.getType())){ %> selected<%}%>">
					<a onclick="changeSkin('<%=MainPageDefined.MAINPAGETYPE_CLASSIC %>','light-orange');" class="preview-img"><img src="/images/main/classic_skin_preview/light-orange.png" title="橙色风格"/></a>
				</span>
				<span class="skin-name">橙色风格</span>
			</li>
		
		
		
		</ul>
	</div>
</div>
</body>
</html>

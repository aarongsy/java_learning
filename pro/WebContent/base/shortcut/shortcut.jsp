<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.skin.SkinConstant"%>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<style type="text/css">
.x-toolbar table {width:0}
#pagemenubar table {width:0}
.x-panel-btns-ct {
    padding: 0px;
}
.x-panel-btns-ct table {width:0}
.ux-maximgb-treegrid-breadcrumbs{
    display:none;
}
</style>
<title>shortcut</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/cycle/jquery.cycle.all.js"></script>
<script type="text/javascript" src="/base/shortcut/js/shortcut.js"></script>
<% if(userMainPage.getIsUseSkin()){ //当前用户选择的首页是使用皮肤的%>
<link rel="stylesheet" type="text/css" id="shortcut_css" href="<%=currentSkin.getBasePath() %>/<%=SkinConstant.SHORTCUT_CSS_NAME %>" />
<% } %>
</head>
<body>
<div id="shortcut">
<div class="data">
<!-- 原型html
<table>
	<tr>
		<td>
			<ul>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  	</ul>
		</td>
	</tr>
	<tr>
		<td>
			<ul>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  		<li><a><div class="pic">图片</div><div class="text">人事管理</div></a></li>
		  	</ul>
		</td>
	</tr>
</table> -->
</div>
<div class="handler">
	<div class="prev"></div>
	<div class="next"></div>
	<div class="setting"></div>
</div>
</div>
</body>
</html>

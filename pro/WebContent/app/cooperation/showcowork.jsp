<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<link  type="text/css" rel="stylesheet" href="/app/cooperation/css/default.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<%if(userMainPage.getIsUseSkin()){%>
<link rel="stylesheet" type="text/css" id="main_css" href="<%=currentSkin.getBasePath() %>/cooperation.css"/> 
<%}%>
<style>
.open {
	background:url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1_1.png) no-repeat 0 50%;
}
.closed {
	background:url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1.png) no-repeat 0 50%;
}
.open_closed{
    height:100%;
	width: 6px;
	overflow: hidden;
	display: block;
	cursor: pointer;
}
</style>
<script language="javascript">
var isShowLeftMenu = false;
function levelMouseOver(){
	if(isShowLeftMenu){
		document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj2.png) no-repeat 0 50%";
	}else{
		document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj2_1.png) no-repeat 0 50%";
	}
}
function levelMouseOut(){
	if(isShowLeftMenu){
		document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1.png) no-repeat 0 50%";
	}else{
		document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1_1.png) no-repeat 0 50%";
	}
}
function mnToggleleft(){
	with(window.parent.document.getElementById("frameBottom")){
		if(cols == '0,*'){
			cols = '400,*';
			window.document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1_1.png) no-repeat 0 50%";
			window.document.getElementById("LeftHideShow").title = ''
			isShowLeftMenu = false;
		}else{
			cols = '0,*';
			window.document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1.png) no-repeat 0 50%";
			window.document.getElementById("LeftHideShow").title = ''
			isShowLeftMenu = true;
		}
	}
}
</script>
</head>
<body class="bodyWelcome">
<div class="coworkWelcomeContainer">
	<table class="coworkWelcome">
	<tr><td class="coworkTitle">欢迎进入协同工作区</td><td class="coworkTitleBack"></td></tr>
	<tr><td colspan="2" class="coworkKeyword">
		<ul><li>协同</li><li>跨部门</li><li>多事项</li><li>高效运作</li></ul>
	</td></tr>
	<tr><td colspan="2" class="coworkMsg">注：您可以在协作区(Co-Work-Zone)进行跨部门、多任务协同工作。<br/>所有协作区的主题事项都可以自定义，如您需要增加协作区主题事项，<br/>请与系统管理员联系。</td></tr>
	</table>
</div>
</body>
</html>
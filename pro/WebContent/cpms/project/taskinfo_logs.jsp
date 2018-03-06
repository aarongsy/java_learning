<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%

String taskid = StringHelper.null2String(request.getParameter("taskid"));

%>
<html>
<head>
<title>任务活动日志</title>

<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript">
Ext.onReady(function(){
	var tb1 = new Ext.Toolbar();
	tb1.render('menubar');
	addBtn(tb1,'刷新','R','refresh',function(){refresh();});
});
</script>
</head>
<body>
<div id="menubar"></div>
<div id="taskinfo">
	<div class="title">任务活动日志</div>
	<ul>
		<li>2011-02-24 16:30 流程提交</li>
	</ul>
</div>
</body>
<script type="text/javascript">
function refresh(){
	
}
</script>
</html>
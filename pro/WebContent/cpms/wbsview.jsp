<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.math.*"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%
String projectid=StringHelper.null2String(request.getParameter("projectid"));
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
DataService dataService = new DataService();
%>
<html>
<head>
<script type="text/javascript" src="scripts/project.js"></script>
<script type="text/javascript" src="scripts/treetable.js"></script>
<script type="text/javascript" src="scripts/treetableconfig.js"></script>
<script type="text/javascript" src="scripts/wbsview.js"></script>
<style type="text/css">
table {
	border-collapse: collapse;
	width:100%;
	border: solid 1px #909090;
}
td {
	padding: 2px;
}
</style>
</head>
<body style="margin:0px;padding:0px">
<div id="pagemenubar"></div>
<div id="wbsdiv" style="width: 100%;padding: 5 10 5 10; text-align: left;">

</div>
</body>
<script type="text/javascript">
initWBS('wbsdiv');
</script>
</html>
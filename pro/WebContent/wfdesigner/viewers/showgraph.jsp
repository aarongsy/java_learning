<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%
String workflowid=StringHelper.null2String(request.getParameter("workflowid"));
String url=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=getxml&id="+workflowid;

WorkflowVersionService workflowVersionService=(WorkflowVersionService)BaseContext.getBean("workflowVersionService");
WorkflowVersion workflowVersion=workflowVersionService.getWorkflowVersionByWorkflowid(workflowid);

int divwidth=NumberHelper.string2Int(request.getParameter("width"),0);
int divheight=NumberHelper.string2Int(request.getParameter("height"),0);
divheight=divheight-25;
%>
<html>
<head>
<script type="text/javascript">
var mxBasePath = '../src/';
function showOperators(){
}
</script>
<script type="text/javascript" src="../src/js/mxClient.js"></script>
<script type="text/javascript" src="js/GraphViewer.js"></script>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script>
function load(){
	loadGraph('<%=url%>');
}
</script>
<link rel="stylesheet" type="text/css" href="css/graphviewer.css" />
</head>
<body onload="load();">
	<%if(workflowVersion!=null){%>
	<div style="display: block;bgcolor:red;">
		<%=workflowVersion.getVersion()%>
	</div>
	<div id="graphDiv" style="display:block;width:<%=divwidth%>px;height:<%=divheight%>px;overflow:scroll;"></div>
	<%}%>
</body>
</html>

<!-- 指定特定的流程 -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.category.service.*" %>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%
int division =NumberHelper.string2Int(request.getParameter("cols"),3);//列数
int width = 98/division;//每列宽百分比
StringBuffer parameters = new StringBuffer();
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String pName = e.nextElement().toString().trim();
	String pValue = StringHelper.null2String(request.getParameter(pName));
	if(!StringHelper.isEmpty(pName)){
		parameters.append("&").append(pName).append("=").append(URLEncoder.encode(pValue, "UTF-8"));
	}
}
String url="/workflow/request/workflow.jsp?workflowid={id}"+parameters.toString();

EweaverUser eweaveruser = BaseContext.getRemoteUser();
StartWorkflowService startWorkflowService = new StartWorkflowService();
startWorkflowService.setUrl(url);
List[] lists =startWorkflowService.getWorkflowList(division,eweaveruser);
DataService dataService = new DataService();
String wfids = "402882882ec6c26f012ec7c87dc60a1f,402882882ed5f68c012ed68346a40378,402882882ed5f68c012ed7153b160612,"+
			   "402882882ed5f68c012ed7327ef80688,402882882f104ae8012f141a5eb20391,402882882ec2b967012ec2eeaec9036f,"+
		       "402882882ec6c26f012ec755cab403bd,402882882ed5f68c012ed74ec6f506dd,402882882ec6c26f012ec7eb72fd0a97";

String sql = "select w.id,w.objname,w.moduleid,n.id as nodeid from workflowinfo w,nodeinfo n "
	+"where n.workflowid=w.id and n.nodetype=1 "
	+"and w.isdelete=0 and w.isactive=1  "
	+"and n.isdelete=0 and '"+wfids+"' like '%'||w.id||'%' order by w.dsporder";

List list = dataService.getValues(sql);

Map map = new HashMap();
map.put("objname","辅助流程");
map.put("workflows",list);
%>
<html>
<head>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type='text/javascript' language="javascript" src='/js/workflow.js'></script>
<link href="/css/eweaver.css" type="text/css" rel="STYLESHEET">
<style>
div{width:<%=width%>%;height:100%;float:left;}
ul{margin:2 0 2 20;color:#333; font-size: 15px;font-weight: bold;}
li ul{;font-size: 12px;font-weight: normal;}
a{margin:2 px;}
a:link{color:#33f}
</style>
</head>
<body>
<div >
	<%=startWorkflowService.getWorkflowStartHtml(map)%>
</div>
</body>
</html>
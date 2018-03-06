<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.cpms.project.task.*" %>
<%
String projectid=StringHelper.null2String(request.getParameter("projectid"));
TaskService taskService=(TaskService)BaseContext.getBean("taskService");
DataService dataService = new DataService();
String sql = "select h.objname as managername,o.objname as unitname,t.* from cpms_task t "
	+ "left join humres h on t.manager=h.id left join orgunit o on t.orgunit=o.id "
	+ "where t.projectid='"+projectid+"' order by t.dsporder";
List allTasks = dataService.getValues(sql);

String projectSQL = "select h.objname as hname,p.* from cpms_project p left join humres h on p.manager=h.id where p.requestid = '"+projectid+"'";
Map project = dataService.getValuesForMap(projectSQL);

//任务中的文档
String docSQL1 = "select d.subject,d.createdate,c.objname as category,h.objname as creator,l.* from docbase d,cpms_doclink l,category c,humres h "
	+"where l.projectid='"+projectid+"' and d.id = l.docid and d.categoryids=c.id and d.creator=h.id and l.objtype !='template'";
List docList1 = dataService.getValues(docSQL1);
//参考文档
String docSQL2 = "select d.subject,d.createdate,c.objname as category,h.objname as creator,l.* from docbase d,cpms_doclink l,category c,humres h "
	+"where l.projectid='"+projectid+"' and d.id = l.docid and d.categoryids=c.id and d.creator=h.id and l.objtype='template'";
List docList2 = dataService.getValues(docSQL2);
//任务中的流程
String flowSQL="select h.objname,r.requestname,r.createdate,r.createtime,l.* from cpms_flowlink l,requestbase r,humres h where l.requestid=r.id and h.id=r.creater and l.requestid is not null and l.projectid='"+projectid+"'";
List flowList = dataService.getValues(flowSQL);

DocFlowService docFlowService = new DocFlowService();
docFlowService.setAllTasks(allTasks);
docFlowService.setDocList1(docList1);
docFlowService.setDocList2(docList2);
docFlowService.setFlowList(flowList);
%>
<html>
<head>
<title>文档流程视图</title>

<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/cpms/scripts/project.js"></script>
<script type="text/javascript" src="/cpms/scripts/treetable.js"></script>
<script type="text/javascript" src="/cpms/scripts/wbsview_docflow.js"></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript">
Ext.onReady(function(){
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'刷新','R','refresh',function(){refresh();});
});
var data={"id":"<%=projectid%>",
		"wbs":"0",
		"objname":"<%=StringHelper.null2String(project.get("objname"))%>",
		"managername":"<%=StringHelper.null2String(project.get("hname"))%>",
		"planstart":"<%=StringHelper.null2String(project.get("planstart"))%>",
		"planfinish":"<%=StringHelper.null2String(project.get("planfinish"))%>",
		"startdate":"<%=StringHelper.null2String(project.get("startdate"))%>",
		"finishdate":"<%=StringHelper.null2String(project.get("finishdate"))%>",
		"tasks":<%=docFlowService.getDocFlowJson(null).toString()%>};
</script>
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
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.cpms.project.task.*" %>
<%@ page import="com.eweaver.humres.base.service.*" %>
<%@ page import="com.eweaver.base.orgunit.service.*" %>
<%
String projectid=StringHelper.null2String(request.getParameter("projectid"));
TaskService taskService=(TaskService)BaseContext.getBean("taskService");
OrgunitService orgunitService=(OrgunitService)BaseContext.getBean("orgunitService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
DataService dataService = new DataService();
String sql = "select s1.objname as statusname,t.* from cpms_task t left join selectitem s1 on t.status=s1.id "
	+	"where t.projectid='"+projectid+"' order by t.dsporder";
List allTasks = dataService.getValues(sql);
for(int i = 0; i < allTasks.size(); i++){
	Map<String,Object> task = (Map<String,Object>)allTasks.get(i);
	String managername = "";
	if(task.get("manager") != null && !task.get("manager").toString().equals("")){
		managername = humresService.getHrmresNameById(StringHelper.null2String(task.get("manager")));
	}
	String unitname = "";
	if(task.get("orgunit") != null && !task.get("orgunit").toString().equals("")){
		unitname = orgunitService.getOrgunitName(StringHelper.null2String(task.get("orgunit")));
	}
	task.put("managername",managername);
	task.put("unitname",unitname);
}

String projectSQL = "select h.objname as hname,s1.objname as statusname,p.* from cpms_project p left join humres h on p.manager=h.id "+
	"left join selectitem s1 on s1.id=p.objstatus where p.requestid = '"+projectid+"'";
Map project = dataService.getValuesForMap(projectSQL);

Humres manager = humresService.getHumresById(StringHelper.null2String(project.get("manager")));
%>
<html>
<head>
<title>任务进度视图</title>

<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/cpms/scripts/project.js"></script>
<script type="text/javascript" src="/cpms/scripts/treetable.js"></script>
<script type="text/javascript" src="/cpms/scripts/wbsview_execute.js"></script>
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
		"statusname":"<%=dataService.getValue("select objname from selectitem where id='"+StringHelper.null2String(project.get("objstatus"))+"'")%>",
		"unitname":"<%=orgunitService.getOrgunitName(manager.getOrgid())%>",
		"managername":"<%=StringHelper.null2String(project.get("hname"))%>",
		"planstart":"<%=StringHelper.null2String(project.get("planstartdate"))%>",
		"planfinish":"<%=StringHelper.null2String(project.get("planfinishdate"))%>",
		"startdate":"<%=StringHelper.null2String(project.get("restartdate"))%>",
		"finishdate":"<%=StringHelper.null2String(project.get("refinishdate"))%>",
		"tasks":<%=taskService.getJsonArray(null,allTasks).toString()%>};
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
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
String sql = "select t.* from cpms_task t where t.projectid='"+projectid+"' order by t.dsporder";
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

String projectSQL = "select h.objname as hname,p.* from cpms_project p left join humres h on p.manager=h.id where p.requestid = '"+projectid+"'";
Map project = dataService.getValuesForMap(projectSQL);

Humres manager = humresService.getHumresById(StringHelper.null2String(project.get("manager")));
%>
<html>
<head>
<title>任务分解视图</title>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/cpms/scripts/project.js"></script>
<script type="text/javascript" src="/cpms/scripts/treetable.js"></script>
<script type="text/javascript" src="/cpms/scripts/wbsview_plan.js"></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<style type="text/css">
    .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
</style>
<script type="text/javascript">
var dlg0;
Ext.onReady(function(){
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'刷新','R','refresh',function(){location.reload();});
   addBtn(tb,'添加任务','N','tag_blue_add',function(){onAdd('<%=projectid%>','');});
   addBtn(tb,'导入WBS模板','I','database_copy',function(){onImport('<%=projectid%>');});
   addBtn(tb,'导入MPP文件','M','database_copy',function(){importXML('<%=projectid%>');});
   addBtn(tb,'导出MPP','E','database_go',function(){exportXML('<%=projectid%>');});
 
});
var dlg0;
function openchild(url,title,id,width,height)
{
    dlg0 = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:width,
                height:height,
                buttons: [{
                    text     : '关闭',
                    handler  : function(){
                        dlg0.hide();
                    }

                }],
                items:[{
                id:'dlgpanel',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }]
            });
  this.dlg0.getComponent('dlgpanel').setSrc(""+url);
  this.dlg0.show();
}
function closechild(){
	if(dlg0){
		dlg0.close();
	}
}
var data={"id":"<%=projectid%>",
		"wbs":"0",
		"objname":"<%=StringHelper.null2String(project.get("objname"))%>",
		"managername":"<%=StringHelper.null2String(project.get("hname"))%>",
		"unitname":"<%=orgunitService.getOrgunitName(manager.getOrgid())%>",
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
function test(){
	var id=top.frames[1].contentPanel.getActiveTab().getId();
	var frame=top.frames[1].Ext.getDom(id+'frame');
	frame.contentWindow.Ext.getDom('402882082f4a8311012f4ac60a740004frame').contentWindow.location.reload();
	//top.frames[1].commonDialog.hide();
	//location.reload();
}
</script>
</html>
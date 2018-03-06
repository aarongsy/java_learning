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
<%@ page import="com.eweaver.cpms.project.wbstemplate.*" %>
<%
String projectid=StringHelper.null2String(request.getParameter("projectid"));
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
TaskTempService taskTempService=(TaskTempService)BaseContext.getBean("taskTempService");
DataService dataService = new DataService();
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");

String tasktempid = StringHelper.null2String(request.getParameter("tasktempid"));
boolean opttype = permissiondetailService.checkOpttype(tasktempid, OptType.VIEW);
if(!opttype){
	response.sendRedirect("/nopermit.jsp");
	return;
}
List alltasksList = taskTempService.getAllTasksByTempid(tasktempid);
String tttdata = taskTempService.getChildrenStr(tasktempid,null,alltasksList);

String sql = "select * from cpms_wbstemplate where requestid = '"+tasktempid+"'";
Map tasktemp = dataService.getValuesForMap(sql);
%>
<html>
<head>

<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/cpms/scripts/project.js"></script>
<script type="text/javascript" src="/cpms/scripts/treetable.js"></script>
<script type="text/javascript" src="/cpms/scripts/wbstemplate.js"></script>
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
Ext.onReady(function(){
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'刷新','R','refresh',function(){refresh();});
   addBtn(tb,'添加任务','N','application_add',function(){onAdd('<%=tasktempid%>');});
   addBtn(tb,'导入MPP文件','M','database_copy',function(){importXML('<%=tasktempid%>');});
});
var data={'id':'<%=tasktempid%>',
	'name':'<%=StringHelper.null2String(tasktemp.get("objname"))%>',
	'tasks':<%=tttdata%>
};
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
</script>
<style type="text/css">
#wbsdiv table {
	border-collapse: collapse;
	width:100%;
	border: solid 1px #909090;
}
#wbsdiv td {
	padding: 2px;
}
</style>
</head>
<body style="margin:0px;padding:0px">
<div id="pagemenubar"></div>
<div id="wbsdiv" style="width: 100%;padding: 5 10 5 10; text-align: left;"></div>
</body>
<script type="text/javascript">
initWBS('wbsdiv');
function openTask(taskid,name){
	onUrl('/cpms/project/tasktemplate_info.jsp?taskid='+taskid+'&tasktempid=<%=tasktempid%>',name,'tab_'+taskid);
}
function onAdd(taskid){
	var url='/cpms/project/tasktemplate_info.jsp?tasktempid=<%=tasktempid%>&ptaskid='+taskid;
	openchild(url,'新建任务','bullet_plus',700,400);
}

function onDelete(taskid){
	if(confirm('确定删除吗?')){
		location.href = '/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=deletetasktemp&taskid='+taskid+'&tasktempid=<%=tasktempid%>';
	}
}
function onUp(taskid){
	location.href = '/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=moveup&taskid='+taskid+'&tasktempid=<%=tasktempid%>';
}
function onDown(taskid){
	location.href = '/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=movedown&taskid='+taskid+'&tasktempid=<%=tasktempid%>';
}
function onLeft(taskid){
	location.href = '/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=moveleft&taskid='+taskid+'&tasktempid=<%=tasktempid%>';
}
function onRight(taskid){
	location.href = '/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=moveright&taskid='+taskid+'&tasktempid=<%=tasktempid%>';
}
function onAddDetail(url){
	openWin(url,'新建',600,800);
}
function importXML(tasktempid){
	var value = openDialog('/base/popupmain.jsp?url=/document/file/fileuploadbrowser.jsp');
	if(value[0]!=''){
		location.href="/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=importtempbympp&attachid="+value[0]+"&tasktempid="+tasktempid;
	}
}
</script>
</html>
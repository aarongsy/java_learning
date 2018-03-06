<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
FormService formService = (FormService)BaseContext.getBean("formService");
FormBaseService formbaseService = (FormBaseService)BaseContext.getBean("formbaseService");
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");

DataService dataService = new DataService();

String id = StringHelper.null2String(request.getParameter("requestid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));
String taskid= StringHelper.null2String(request.getParameter("taskid"));
String categoryid=formbaseService.getFormBaseById(id).getCategoryid();
Category category = categoryService.getCategoryById(categoryid);
Forminfo forminfo = forminfoService.getForminfoById(category.getPFormid());

Map formParameters = new HashMap();
formParameters.put("requestid",id);
formParameters.put("bNewworkflow",0);

Map initparameters = new HashMap();
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String pName = e.nextElement().toString().trim();
	String pValue = StringHelper.trimToNull(request.getParameter(pName));
	if(!StringHelper.isEmpty(pName)){
		initparameters.put(pName,pValue);
    }
}
formParameters.put("bviewmode","1");
formParameters.put("bView","0");
formParameters.put("bWorkflowform","2");
formParameters.put("initparameters",initparameters);

String layoutid="";
List layoutlist = formlayoutService.getOptLayoutList(id,OptType.VIEW);
for (Object layout : layoutlist) {
    if(layout==null)
    continue;
    if (formlayoutService.getFormlayoutById((String) layout).getTypeid() == 1){
        layoutid = formlayoutService.getFormlayoutById((String) layout).getId();
        break;
    }
}
if (StringHelper.isEmpty(layoutid)){
    layoutid = category.getPViewlayoutid();
}
formParameters.put("layoutid",layoutid);
formParameters.put("formid",forminfo.getId());
formParameters = formService.WorkflowView(formParameters);
layoutid = StringHelper.null2String(formParameters.get("layoutid"));
String needcheckfields = StringHelper.null2String(formParameters.get("needcheck"));
String formcontent = StringHelper.null2String(formParameters.get("formcontent"));
String tasksSQL = "select t.objname,l.* from cpms_tasklink l,cpms_task t where objid='"+id+"' and t.requestid=l.pretaskid";
List taskList = dataService.getValues(tasksSQL);
String resourceSQL = "select a.id,a.humresid,b.objname,a.role,a.theunit,a.plantime,a.realtime,a.description from cpms_taskresource a,humres b "
		+"where a.humresid=b.id and a.taskid='"+id+"'";
List resourceList = dataService.getValues(resourceSQL);

String taskSQL = "select h.objname as hname,r.requestname as rname,w.objname as wname,t.* from cpms_task t left join humres h on t.manager=h.id "+
" left join requestbase r on t.flowreqid=r.id left join workflowinfo w on t.workflowid=w.id where t.requestid='"+id+"'";
Map task = dataService.getValuesForMap(taskSQL);
if(StringHelper.isEmpty(projectid)){
	projectid = (String)task.get("projectid");
}

if(StringHelper.isEmpty(taskid)){
	taskid = (String)task.get("requestid");
}
String projectSQL = "select * from cpms_project where requestid = '"+projectid+"'";
Map project = dataService.getValuesForMap(projectSQL);
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
boolean editPermission = permissiondetailService.checkOpttype(taskid, OptType.MODIFY) || currentuser.getId().equals(project.get("manager"));//||currentuser.getId().equals(task.get("manager"));//任务权限
boolean deletePermission = permissiondetailService.checkOpttype(taskid, OptType.DELETE) || currentuser.getId().equals(project.get("manager"));
%>
<html>
<head>
<title>任务信息</title>

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
	<%if(editPermission){%>
	addBtn(tb1,'编辑','E','application_form_edit',function(){location.href='/cpms/project/taskedit.jsp?requestid=<%=id%>&projectid=<%=projectid%>';});
	<%}%>
	<%if(deletePermission){%>
	addBtn(tb1,'删除','D','delete',function(){deleteTask();});
	<%}%>
	addBtn(tb1,'刷新','R','refresh',function(){refresh();});
});
</script>
<style type="text/css">
#menubar table {width:0}
table caption span{font-size: 14px;}
</style>
</head>
<body>
<input type="hidden" name="taskid" id="taskid" value="<%=id%>">
<div id="taskinfoPanel">
<div id="menubar"></div>
<%=formcontent%>
<div id="taskinfodiv">
<table class="layouttable" style="margin: -2 0 0 0 " border="1">
	<tr height="25px">
		<td width="12%" class="FieldName">前置任务</td>
		<td width="88%">
		<%if(taskList.size()>0){%>
		<table width="100%">
			<tr class="header">
				<td width="30%">前置任务名称</td>
				<td width="15%">类型</td>
				<td width="15%">延迟(天)</td>
				<td width="40%">备注</td>
			</tr>
			<%for(int i=0;i<taskList.size();i++){
				Map map = (Map)taskList.get(i);
			%>
			<tr height="25px">
				<td width="30%"><a href="javascript:onUrl('/cpms/project/taskinfo.jsp?projectid=<%=projectid%>&requestid=<%=map.get("pretaskid")%>','<%=map.get("objname")%>','exec_<%=map.get("pretaskid")%>');"><%=StringHelper.null2String(map.get("objname"))%></a></td>
				<td width="15%"><%=StringHelper.null2String(map.get("objtype"))%></td>
				<td width="15%"><%=map.get("lag")%>天</td>
				<td width="40%"><%=StringHelper.null2String(map.get("description"))%></td>
			</tr>
			<%}%>
		</table>
		<%}%>
		</td>
	</tr>
	<tr height="25px">
		<td width="12%" class="FieldName">资源 </td>
		<td width="88%">
		<%if(resourceList.size()>0){%>
		<table width="100%" style="padding: 0;margin: 0;border: none;">
			<tr class="header">
				<td width="15%">资源名称</td>
				<td width="15%">角色</td>
				<td width="10%">使用单位</td>
				<td width="10%">计划工时</td>
				<td width="10%">实际工时</td>
				<td width="40%">备注</td>
			</tr>
			<%for(int i=0;i<resourceList.size();i++){
				Map map = (Map)resourceList.get(i);
			%>
			<tr height="25px">
				<td ><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=map.get("humresid")%>','<%=StringHelper.null2String(map.get("objname"))%>','tab<%=map.get("humresid")%>');"><%=StringHelper.null2String(map.get("objname"))%></a></td>
				<td><%=StringHelper.null2String(map.get("role"))%></td>
				<td><%=StringHelper.null2String(map.get("theunit"))%></td>
				<td><%=StringHelper.null2String(map.get("plantime"))%></td>
				<td><%=StringHelper.null2String(map.get("realtime"))%></td>
				<td><%=StringHelper.null2String(map.get("description"))%></td>
			</tr>
			<%}%>
		</table>
		<%}%>
		</td>
	</tr>
</table>
</div>
</div>
<script type="text/javascript">
function refresh(){
	location.reload();
}
function deleteTask(){
	if(confirm("该操作将删除当前任务以及子任务！确定要删除吗?")){
		Ext.Ajax.request({
		   url: "/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=deletewithasync&requestid=<%=id%>&projectid=<%=projectid%>",
		   success: function(res){
				if(res.responseText == "success"){
					alert("删除成功!");
					if(parent && parent.parent && parent.parent.openchild && parent.parent.dlg0 && parent.parent.store){	//从列表中用窗体打开的
						parent.parent.dlg0.hide();
						parent.parent.store.reload();
					}else{
						refreshTargetTab('tab402883ba33a629fc0133a63620a70016');	//刷新任务待办列表
					}
            	    refreshTargetTab('tab<%=projectid%>');	//刷新项目tab页
            	    //关闭所有可能和该项目任务关联的tab页
            	    closeTargetTab('tab<%=id%>');
            	    closeTargetTab('exec_<%=id%>');
            	    closeTargetTab('plan_<%=id%>');
				}else{
					alert("删除失败:\n"+res.responseText);
				}
		   },
		   failure: function(res){
				alert('Error:'+res.responseText);
		   }
		});
	}
}
function closeTargetTab(tabid){
	if(top && typeof(top.closeTabWhenExist) == 'function'){	//新首页关闭标签页
		top.closeTabWhenExist(tabid);
	}else if(top.frames[1] && top.frames[1].name == 'leftFrame'){	//传统首页关闭标签页
		var tabpanel=top.frames[1].contentPanel;
		if(tabpanel.getItem(tabid)){
			tabpanel.remove(tabpanel.getItem(tabid));
		}
	}
}
function refreshTargetTab(tabid){
	if(top && typeof(top.refreshTabIfExisted) == 'function'){		//新首页
   	    top.refreshTabIfExisted(tabid);
   	}else if(top.frames[1] && top.frames[1].name == 'leftFrame'){	//传统首页
   		var tabpanel=top.frames[1].contentPanel;
   		if(tabpanel.getItem(tabid)){
   		    tabpanel.getItem(tabid).getFrameWindow().location.reload();
   		}
   	}
}
</script>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.math.*"%>
<%@ page import="com.eweaver.cpms.project.task.TaskService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%
String taskid = StringHelper.null2String(request.getParameter("taskid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));
DataService dataService = new DataService();
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");

String taskSQL = "select r.requestname as rname,r.isfinished,w.objname as wname,t.* from cpms_task t "+
		" left join requestbase r on t.flowreqid=r.id left join workflowinfo w on t.workflowid=w.id where t.requestid='"+taskid+"'";
Map task = dataService.getValuesForMap(taskSQL);
String taskManager = StringHelper.null2String(task.get("manager"));
String taskManagerName = humresService.getHrmresNameById(taskManager);

if(StringHelper.isEmpty(projectid)){
	projectid = (String)task.get("projectid");
}

String docSQL1 = "select d.subject,c.objname as category,h.objname as creator,l.* from docbase d,cpms_doclink l,category c,humres h "
	+"where l.taskid='"+taskid+"' and d.id = l.docid and d.categoryids=c.id and l.operator=h.id and l.objtype='template'";
List docList = dataService.getValues(docSQL1);//模板文档/参考文档

String docSQL2="select l.id as doclinkid,d.id,d.subject,l.operatetime,h.objname,l.objtype,l.operator from docbase d,humres h,cpms_doclink l where l.operator=h.id and d.id =l.docid and l.taskid='"+taskid+"' and l.objtype!='template'";
List docs = dataService.getValues(docSQL2);//输出文档

String doctypeSQL="select c.objname as cname,w.objname as wname,l.* from cpms_doctypelink l left join category c on l.doctypeid=c.id "
	+"left join workflowinfo w on w.id = l.workflowid where l.taskid='"+taskid+"'";
List doctypeList = dataService.getValues(doctypeSQL);//输出文档类型

String flowSQL="select w.objname,l.* from cpms_flowlink l left join workflowinfo w on l.workflowid=w.id where l.requestid is null and l.taskid='"+taskid+"'";
List flowList = dataService.getValues(flowSQL);//流程类型定义

String sql="select h.objname,r.requestname,l.* from cpms_flowlink l,requestbase r,humres h where l.requestid=r.id and h.id=l.operator and l.requestid is not null and l.taskid='"+taskid+"'";
List flows = dataService.getValues(sql);//关联的具体流程


String planstart = StringHelper.null2String(task.get("planstart"));
String planfinish = StringHelper.null2String(task.get("planfinish"));
String startdate = StringHelper.null2String(task.get("startdate"));
String finishdate = StringHelper.null2String(task.get("finishdate"));
//任务延迟判断
boolean delayStart = StringHelper.isEmpty(startdate)&&DateHelper.getCurrentDate().compareTo(planstart)>0||startdate.compareTo(planstart)>0;
boolean delayFinish = StringHelper.isEmpty(finishdate)&&DateHelper.getCurrentDate().compareTo(planfinish)>0||finishdate.compareTo(planfinish)>0;

String taskResourcesSql = "select * from cpms_taskresource where taskid='"+taskid+"' and humresid='"+currentuser.getId()+"'";
List resourcesList = dataService.getValues(taskResourcesSql);

boolean permission = permissiondetailService.checkOpttype(taskid, 15);//||currentuser.getId().equals(task.get("manager"));//文档流程删除权限
boolean editPermission = permission||resourcesList.size()>0;//文档流程添加权限
//是否再分解(是)
boolean isAgainDecompose = task.get("isagaindecompose") != null && task.get("isagaindecompose").equals("2c91a0302aa21947012aa31fc13e00ab");
//是否是任务负责人
boolean isManager = taskManager.contains(currentuser.getId());
boolean againDecomposePermission = permission && isAgainDecompose && isManager;

TaskService taskService=(TaskService)BaseContext.getBean("taskService");
OrgunitService orgunitService=(OrgunitService)BaseContext.getBean("orgunitService");
String projectSQL = "select h.objname as hname,s1.objname as statusname,p.* from cpms_project p left join humres h on p.manager=h.id "+
	"left join selectitem s1 on s1.id=p.objstatus where p.requestid = '"+projectid+"'";
Map project = dataService.getValuesForMap(projectSQL);

Humres manager = humresService.getHumresById(StringHelper.null2String(project.get("manager")));

String sqlAllTasks = "select s1.objname as statusname,t.* from cpms_task t left join selectitem s1 on t.status=s1.id "
	+ "where t.projectid='"+projectid+"' order by t.dsporder";
List allTasks = dataService.getValues(sqlAllTasks);
for(int i = 0; i < allTasks.size(); i++){
	Map<String,Object> oneTask = (Map<String,Object>)allTasks.get(i);
	String managername = "";
	if(oneTask.get("manager") != null && !oneTask.get("manager").toString().equals("")){
		managername = humresService.getHrmresNameById(StringHelper.null2String(oneTask.get("manager")));
	}
	String unitname = "";
	if(oneTask.get("orgunit") != null && !oneTask.get("orgunit").toString().equals("")){
		unitname = orgunitService.getOrgunitName(StringHelper.null2String(oneTask.get("orgunit")));
	}
	oneTask.put("managername",managername);
	oneTask.put("unitname",unitname);
}

JSONArray childTasksJSONArray = taskService.getJsonArray(taskid,allTasks);

String trDisplay="block";
//是否接受此任务
String isaccept=task.get("isaccept")==null?"":task.get("isaccept").toString();

if("2c91a0302aa21947012aa31fc13e00ab".equals(isaccept)){
	String sql2="select * from cpms_task where pid='"+task.get("requestid").toString()+"'";
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	List checklist = baseJdbc.executeSqlForList(sql2);
	boolean flag=true;
	if (checklist.size() > 0) {
		for(int i=0;i<checklist.size();i++){
			Map map=(Map)checklist.get(i);
			String objpercent=map.get("objpercent").toString();
			if(!"100".equals(objpercent)){
				flag=false;
				break;
			}
		}
	}
	if(!flag){
		trDisplay="none";
	}
}
%>
<html>
<head>
<title>任务进展</title>

<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/cpms/scripts/project.js"></script>
<script type="text/javascript" src="/cpms/scripts/treetable.js"></script>
<script type="text/javascript" src="/cpms/scripts/taskinfo_process.js"></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript">
Ext.onReady(function(){
	var tb1 = new Ext.Toolbar();
	tb1.render('menubar');
	<%if(permission){%>
	//addBtn(tb1,'编辑','E','application_form_edit',function(){location.href='/cpms/project/taskedit.jsp?requestid=<%=taskid%>&projectid=<%=projectid%>';});
	<%}%>
	addBtn(tb1,'刷新','R','refresh',function(){location.reload();});
	<%if(againDecomposePermission){%>
		addBtn(tb1,'添加子任务','A','add',function(){onAdd('<%=projectid %>','<%=taskid %>');});
	<%}%>
	var taskinfoPanel = new Ext.Panel({
	    title:'任务进展',iconCls:Ext.ux.iconMgr.getIcon('report_go'),
	    layout: 'border',
	    items: [{region:'center',autoScroll:true,contentEl:'taskinfoPanel'}]
	});
	
	var contentPanel = new Ext.TabPanel({
        region:'center',
        id:'tabPanel',
        border:false,
        deferredRender:false,
        enableTabScroll:true,
        autoScroll:true,
        activeTab:0,
        items:[taskinfoPanel]
    });
	addTab(contentPanel,'/cpms/project/taskinfo.jsp?projectid=<%=projectid%>&requestid=<%=taskid%>','任务信息','report');
	addTab(contentPanel,'/cpms/comment/comment.jsp?objid=<%=projectid%>&taskid=<%=taskid%>','协作交流','comments');
	//addTab(contentPanel,'/cpms/project/taskinfo_logs.jsp?taskid=<%=taskid%>','活动日志','report_edit');
  	//Viewport
	var viewport = new Ext.Viewport({
	    layout: 'border',
	    items: [contentPanel]
	});
	initView();
	<%if(!childTasksJSONArray.isEmpty()){ %>
		initWBS('wbsdiv');
	<%} %>
	
	document.getElementById('taskflow').style.display="<%=trDisplay%>";
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
		"tasks":<%=childTasksJSONArray.toString()%>};
</script>
<style type="text/css">
#menubar table {width:0}
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
</head>
<body>
<div id="taskinfoPanel">
<div id="menubar"></div>
	<div id="taskinfo">
		<table class="layouttable">
			<caption><%=StringHelper.null2String(task.get("objname"))%></caption>
			<tr>
				<td class="fieldname"  width="12%">责任人</td>
				<td class="fieldvalue">
					<%
						if(!StringHelper.isEmpty(taskManager)){
							String[] managerNames = taskManagerName.split(",");
							String[] managerIds = taskManager.split(",");
							if(managerNames.length == managerIds.length){
								for(int i = 0; i < managerNames.length; i++){%>
									<a href=javascript:onUrl('/humres/base/humresview.jsp?id=<%=managerIds[i]%>','<%=managerNames[i]%>','tab<%=managerIds[i]%>') style="margin-right: 3px;"><%=StringHelper.null2String(managerNames[i])%></a>	
								<%}
							}
						}
					%>
				</td>
				<td class="fieldname"  width="12%">上级任务</td>
				<td class="fieldvalue">
				<%if(!StringHelper.isEmpty((String)task.get("pid"))){
					String pName = dataService.getValue("select objname from cpms_task where requestid='"+task.get("pid")+"'");
				%>
					<a href=javascript:onUrl('/cpms/project/taskinfo_process.jsp?taskid=<%=task.get("pid")%>','<%=pName%>','tab<%=task.get("pid")%>')><%=StringHelper.null2String(pName)%></a>
				<%}else{
					String pName = dataService.getValue("select objname from cpms_project where requestid='"+projectid+"'");
				%>
				<%=StringHelper.null2String(pName)%>
				<%} %>
				</td>
			</tr>
			<tr>
				<td class="fieldname" width="12%">计划开始日期</td>
				<td class="fieldvalue" width="38%"><%=planstart%></td>
				<td class="fieldname"  width="12%">计划完成日期</td>
				<td class="fieldvalue"  width="38%"><%=planfinish%></td>
			</tr>
			<tr>
				<td class="fieldname" width="12%">实际开始日期</td>
				<td class="fieldvalue" width="38%">
					<%=startdate%>
					<%if(delayStart){%><span style="color:red">开始时间延期</span><%}%>
				</td>
				<td class="fieldname"  width="12%">实际完成日期</td>
				<td class="fieldvalue"  width="38%">
					<%=finishdate%>
					<%if(delayFinish){%><span style="color:red">完成时间延期</span><%}%>
				</td>
			</tr>
			<tr>
				<td class="fieldname" width="12%">完成进度</td>
				<td class="fieldvalue">
				<%
				BigDecimal progress = (BigDecimal)task.get("objpercent");
				progress = progress==null?BigDecimal.ZERO:progress;
				String colorbd="#999";
				String colorbg="#ddd";
				String imgSrc="/cpms/images/bullet_orange.gif";
				if(progress.intValue()>0){
					colorbd="#50abff";
					colorbg="#d4e6ff";
					imgSrc="/cpms/images/bullet_right.gif";
				}
				if(progress.intValue()==100){
					colorbd="#9fc54e";
					colorbg="#dbeace";
					imgSrc="/cpms/images/bullet_tick.gif";
				}
				%>
				<div>
					<img src="<%=imgSrc%>" style="float: left">
					<div style="width:200px;height:12px;background-color:<%=colorbg%>;border: <%=colorbd%> 1px solid;float:left; padding:1 0 0 0;margin:2 0 0 0">
						<div style="background-color: <%=colorbd%>;width:<%=progress.intValue()*2%>px;height:10px;overflow:hidden;"></div>
					</div><%=progress.intValue()%>%
					<%if(editPermission){%>
						<%if(progress.intValue()==0){%><a href="javascript:start();">开始</a><%}%>
						<%if(progress.intValue()>0&&progress.intValue()<100){%><a id="modifyTag" href="javascript:showUpdate();" style="margin: 0 10 0 0">修改进度</a><%}%>
						<span id="percentSpan" style="display:none">
							<input type="text" name="percentValue" id="percentValue" style="width=20px;height:18px;font-size: 11px;" value="<%=task.get("objpercent")%>">%
							<a href="javascript:update();" style="margin: 0 10 0 0">确定</a>
							<a href="javascript:cancelUpdate();" style="margin: 0 10 0 0">取消</a>
						</span>
						<%if(progress.intValue()>0&&progress.intValue()<100){%><a id="finishTag" href="javascript:finish();">完成</a><%}%>
					<%}%>
				</div>
				</td>
				<td class="fieldname" width="12%">任务状态</td>
				<td class="fieldvalue" colspan="3">
					<%
					String status =(String)task.get("status");
					String statusName = dataService.getValue("select objname from selectitem where id='"+status+"'");
					%>
					<%=statusName%>
				</td>
			</tr>
			<tr id="taskflow" style="display:none">
				<td class="fieldname" width="12%">任务流程</td>
				<td class="fieldvalue" colspan="3">
					<input type="hidden" id="tasktype" name="tasktype" value="<%=StringHelper.null2String(task.get("tasktype"))%>">
					<input type="hidden" id="workflowid" name="workflowid" value="<%=StringHelper.null2String(task.get("workflowid"))%>" title="<%=StringHelper.null2String(task.get("wname"))%>">
					<input type="hidden" id="flowreqid" name="flowreqid" value="<%=StringHelper.null2String(task.get("flowreqid"))%>" title="<%=StringHelper.null2String(task.get("rname"))%>" isfinished="<%=task.get("isfinished")%>">
					<span id="flowspan"><a href="javascript:openFlow('<%=StringHelper.null2String(task.get("flowreqid"))%>','<%=StringHelper.null2String(task.get("rname"))%>')"><%=StringHelper.null2String(task.get("rname"))%></span>
				</td>
			</tr>
			<%
			String workflowid=StringHelper.null2String(task.get("workflowid"));
			String flowreqid=StringHelper.null2String(task.get("flowreqid"));
			if(StringHelper.isEmpty(workflowid) && !StringHelper.isEmpty(flowreqid)){
				workflowid = dataService.getValue("select workflowid from requestbase where id='"+flowreqid+"'");
			}
			String formid=dataService.getValue("select formid from workflowinfo where id='"+workflowid+"'");
			if(!StringHelper.isEmpty(formid)&&!StringHelper.isEmpty(flowreqid)){
				ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
				Forminfo forminfo = forminfoService.getForminfoById(formid);
				String formTable = "";
				if(forminfo.getObjtype() == 1){	//抽象表单
					String strHql = "from Formlink where oid='" + forminfo.getId() + "' order by pid";
					FormlinkService formlinkService = (FormlinkService)BaseContext.getBean("formlinkService");
					List formlinks = formlinkService.findFormlink(strHql);
					if(formlinks.size() > 0){
						Formlink formlink = (Formlink)formlinks.get(0);
						Forminfo mainForminfo = forminfoService.getForminfoById(formlink.getPid());
						formTable = mainForminfo.getObjtablename();
						formid = mainForminfo.getId();
					}
				}else{
					formTable = forminfo.getObjtablename();
				}
				String fields=dataService.getValue("select fieldname from formfield where (fieldtype='402881e70bc70ed1010bc710b74b000d' or fieldtype='402881e70ebfb96c010ebfbf16de0004')and formid='"+formid+"'");
				if(!StringHelper.isEmpty(fields) && !StringHelper.isEmpty(formTable)){
					String sql1 = "select "+fields+" from "+formTable+" where requestid='"+flowreqid+"'";
					String docids=dataService.getValue(sql1);
					if(!StringHelper.isEmpty(docids)){
						String[] ids = docids.split(",");
			%>
			<tr height="25px">
				<td width="12%" class="FieldName"> 流程文档</td>
				<td class="processList" colspan="3">
				<%for(String id:ids){
					Docbase docbase = docbaseService.getDocbase(id);
				%>
				<ul>
					<a href="javascript:openDoc('<%=id%>','<%=docbase.getSubject()%>');"><%=docbase.getSubject()%></a>
				</ul>
				<%}%>
				</td>
			</tr>
			<%}}}%>
			<tr height="25px">
				<td width="12%" class="FieldName"> 参考文档</td>
				<td class="processList" colspan="3">
				<%for(int i=0;i<docList.size();i++){
					Map map = (Map)docList.get(i);
				%>
				<ul>
					<a href="javascript:openDoc('<%=map.get("docid")%>','<%=map.get("subject")%>');"><%=map.get("subject")%></a>
					<span style="color:#666; padding: 0 5 0 5;"><%=map.get("category")%>  <%=map.get("creator")%> , <%=map.get("operatetime")%></span>
					<span><%=StringHelper.null2String(map.get("description"))%></span>
				</ul>
				<%}%>
				</td>
			</tr>
			<tr height="25px">
				<td class="FieldName"> 输出文档</td>
				<td class="processList" colspan="3">
				<%for(int i=0;i<doctypeList.size();i++){
					Map map = (Map)doctypeList.get(i);
					int isnecessary = NumberHelper.getIntegerValue(map.get("isnecessary"));
					String necessaryStr = isnecessary==1?"<span id='necessaryDoc' value='"+map.get("id")+"' style='color:red;'>(必须)</span>":"";
				%>
				<ul>
					<div>
						<span style="font-weight: bold;color: #549c00;"><%=StringHelper.null2String(map.get("cname"))%><%=necessaryStr%></span>
						<%if(editPermission){%>
						[<a href="javascript:addDoc('<%=map.get("doctypeid")%>','<%=map.get("id")%>');">添加文档</a>] [<a href="javascript:newDoc('<%=map.get("doctypeid")%>','<%=map.get("id")%>');">新建文档</a>]
						<%}%>
					</div>
					<%
					for(int j=0;j<docs.size();j++){
						Map doc = (Map)docs.get(j);
						if(!StringHelper.null2String(map.get("id")).equals(doc.get("objtype")))	continue;//指定分类的文档
					%>
					<li>
						<input type="hidden" id="<%=map.get("id")%>">
						<a href="javascript:openDoc('<%=doc.get("id")%>','<%=doc.get("subject")%>');"><%=doc.get("subject")%></a>
						<span style="color: #666;padding: 0 5 0 5;"><%=doc.get("objname")%> , <%=StringHelper.null2String(doc.get("operatetime"))%></span>
						<%if(permission||currentuser.getId().equals(doc.get("operator"))){ %>
						<img style="cursor:hand;" align="absmiddle" src="/cpms/images/delete.gif" title="删除" onclick="javascript:delDoc('<%=doc.get("doclinkid")%>');">
						<%} %>
					</li>
					<%}%>
				</ul>
				<%}%>
				<ul>
					<div>
						<span style="font-weight: bold;color: #549c00;">其他文档</span>
						<%if(editPermission){%>
						[<a href="javascript:addDoc();">添加文档</a>] [<a href="javascript:newDoc();">新建文档</a>]
						<%}%>
					</div>
					<%
					for(int j=0;j<docs.size();j++){
						Map doc = (Map)docs.get(j);
						if(!"task".equals(doc.get("objtype")))	continue;//未分类文档
					%>
					<li>
						<a href="javascript:openDoc('<%=doc.get("id")%>','<%=doc.get("subject")%>');"><%=doc.get("subject")%></a>
						<span style="color: #666;padding: 0 5 0 5;"><%=doc.get("objname")%> , <%=StringHelper.null2String(doc.get("operatetime"))%></span>
						<%if(permission||currentuser.getId().equals(doc.get("col1"))){ %>
						<img style="cursor:hand;" align="absmiddle" src="/cpms/images/delete.gif" title="删除" onclick="javascript:delDoc('<%=doc.get("doclinkid")%>');">
						<%} %>
					</li>
					<%}%>
				</ul>
				</td>
			</tr>
			<tr height="25px">
				<td class="FieldName"> 任务流程</td>
				<td class="processList" colspan="3">
				<%for(int i=0;i<flowList.size();i++){
					Map map =(Map)flowList.get(i);
					int isnecessary = NumberHelper.getIntegerValue(map.get("isnecessary"));
					String necessaryStr = isnecessary==1?"<span id='necessaryFlow' value='"+map.get("id")+"' style='color:red;'>(必须)</span>":"";
				%>
				<ul>
					<div>
						<span style="font-weight: bold;color: #4e96dd;"><%=StringHelper.null2String(map.get("objname"))%><%=necessaryStr%></span>
						<%if(editPermission){%>
						[<a href="javascript:addFlow('<%=map.get("workflowid")%>');">添加流程</a>]  [<a href="javascript:newFlow('<%=map.get("workflowid")%>');">新建流程</a>]
						<%}%>
					</div>
					<%
					for(int j=0;j<flows.size();j++){
						Map flow = (Map)flows.get(j);
						if(!StringHelper.null2String(flow.get("workflowid")).equals(map.get("workflowid")))	continue;//已定义类别的流程
					%>
					<li>
						<input type="hidden" id="<%=map.get("id")%>">
						<a href="javascript:openFlow('<%=flow.get("requestid")%>','<%=flow.get("requestname")%>');"><%=flow.get("requestname")%></a>
						<span style="color: #666;padding: 0 5 0 5;"><%=flow.get("objname")%> , <%=flow.get("operatetime")%></span>
						<%if(permission||currentuser.getId().equals(flow.get("operator"))){ %>
						<img style="cursor:hand;" align="absmiddle" src="/cpms/images/delete.gif"  title="删除" onclick="javascript:delFlow('<%=flow.get("id")%>');">
						<%} %>
					</li>
					<%}%>
				</ul>
				<%}%>
				<ul>
					<div>
						<span style="font-weight: bold;color: #4e96dd;">其他类流程</span>
						<%if(editPermission){%>
						[<a href="javascript:addFlow();">添加流程</a>] [<a href="javascript:newFlow();">新建流程</a>]
						<%}%>
					</div>
					<%
					for(int j=0;j<flows.size();j++){
						Map flow = (Map)flows.get(j);
						if(!"others".equals(flow.get("objtype")))	continue;//未定义类别流程
					%>
					<li>
						<a href="javascript:openFlow('<%=flow.get("requestid")%>','<%=flow.get("requestname")%>');"><%=flow.get("requestname")%></a>
						<span style="color: #666;padding: 0 5 0 5;"><%=flow.get("objname")%> , <%=flow.get("operatetime")%></span>
						<%if(permission||currentuser.getId().equals(flow.get("operator"))){ %>
						<img style="cursor:hand;" align="absmiddle" src="/cpms/images/delete.gif"  title="删除" onclick="javascript:delFlow('<%=flow.get("id")%>');">
						<%} %>
					</li>
					<%}%>
				</ul>
				</td>
			</tr>
		</table>
		
		<div id="childTasksDiv" style="padding: 15 10 0 0;width:100%;display: none;">
			<span style="color: #5e84c2;font-weight: bold;">〖子任务信息〗</span>
			<div id="wbsdiv" style="width: 100%;padding: 4 4 4 4; text-align: left;">
				
			</div>
		</div>
		
		<div id="iframeDiv" style="display:none">
			<h5 style="margin: 5px;">任务流程图：</h5>
			<iframe id="chartframe" width="100%" height="450px" border=0></iframe>
		</div>
	</div>
</div>
<script type="text/javascript">
var projectid='<%=projectid%>';
var taskid='<%=taskid%>';
function openDoc(docid,title){
	onUrl('/document/base/docbaseview.jsp?id='+docid,title,'tab_'+docid);
}
function newDoc(categoryid,doclinkid){
	if(categoryid){
		onUrl('/document/base/docbasecreate.jsp?categoryid='+categoryid+'&messageKey=docMessage&taskid='+taskid+'&projectid='+projectid+'&objtype='+doclinkid,'创建文档','taskDoc_'+taskid);
	}else{
		onUrl('/document/base/startdocument.jsp?messageKey=docMessage&taskid='+taskid+'&projectid='+projectid+'&objtype=task','创建文档','taskDoc_'+taskid);
	}
}
function addDoc(categoryid,doclinkid){
	var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=402881e70bc70ed1010bc710b74b000d';
	if(categoryid){url+='&con4028819b124662b301124662b7310356_value='+categoryid;}
	var value = openDialog(url);
	if(value){
		var docid = value[0];
		doclinkid = doclinkid?doclinkid:'task';
		categoryid = categoryid?categoryid:'';
		location.href='/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=saveDoc&taskid='
			+taskid+'&projectid='+projectid+'&docid='+docid+'&objtype='+doclinkid+'&categoryid='+categoryid+'&from=task';
	}
}
function delDoc(id){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=delDoc&taskid='
			+taskid+'&projectid='+projectid+'&id='+id+'&process=1';
	}
}
function addFlow(workflowid){
	var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=402881980cf7781e010cf8060910009b';
	if(workflowid){
		url+='&workflowid='+workflowid;
	}
	var value = openDialog(url);
	if(value&&value[0]){
		var action = '/ServiceAction/com.eweaver.cpms.project.flow.FlowAction?action=addFlow&taskid='+taskid+'&projectid='+projectid+'&requestid='+value[0];
		if(workflowid){
			action+='&workflowid='+workflowid;
		}else{
			action+='&objtype=others';
		}
		location.href=action;
	}
}
function delFlow(id){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.flow.FlowAction?action=delFlow&taskid='
			+taskid+'&projectid='+projectid+'&id='+id+'&process=1';
	}
}
function updateFlow(workflowid){
	var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=402881980cf7781e010cf8060910009b';
	if(workflowid){
		url+='&workflowid='+workflowid;
	}
	var value = openDialog(url);
	if(value&&value[0]){
		var action = '/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=updateflow&taskid='+taskid+'&projectid='+projectid+'&requestid='+value[0];
		location.href=action;
	}
}
function newFlow(workflowid){
	if(workflowid){
		onUrl('/workflow/request/workflow.jsp?workflowid='+workflowid+'&messageKey=flowMessage&taskid='+taskid+'&projectid='+projectid,'创建流程','taskFlow_'+taskid);
	}else{
		onUrl('/workflow/request/startworkflow.jsp?&messageKey=flowMessage&objtype=others&taskid='+taskid+'&projectid='+projectid,'新建流程','pmflow');
	}
}
function openFlow(requestid,title){
	onUrl('/workflow/request/workflow.jsp?requestid='+requestid,title,'tab_'+requestid);
}
function start(){
	location.href='/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=start&taskid='+taskid+'&projectid='+projectid;
}
function update(){
	var percentValue = document.getElementById("percentValue").value;
	var reg = /^([1-9]|[1-9][0-9])$/;
	if(reg.test(percentValue)){
		location.href='/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=update&taskid='+taskid+'&projectid='+projectid+'&percentValue='+percentValue;
	}
}
function finish(){
	var flowreq = document.getElementById("flowreqid");
	var tasktype = document.getElementById("tasktype");
	//流程类别的任务判断流程是否完成
	if(tasktype.value=="4028d6812d8f0fcc012d8f670f3c0003"){
		if(!flowreq.value){
			alert("任务流程未创建，不能完成任务");
			return;
		}
		if(flowreq.isfinished!="1"){
			alert("任务流程未完成，不能完成任务");
			return;
		}
	}
	//必须上传的文档判断
	var necessaryDocCheck=true;
	var necessaryFlowCheck=true;
	var necessaryDocs = document.all("necessaryDoc");
	var necessaryFlows = document.all("necessaryFlow");
	if(necessaryDocs){
		necessaryDocs=necessaryDocs.length?necessaryDocs:[necessaryDocs];
		for(var i=0;i<necessaryDocs.length;i++){
			var necessaryDoc = necessaryDocs[i];
			var necessaryTypeid=necessaryDoc.value;
			if(!document.all(necessaryTypeid)){
				necessaryDocCheck=false;
				break;
			}
		}
		if(!necessaryDocCheck){
			alert("必须完成的文档未提交，不能完成任务!");
			return;
		}
	}
	if(necessaryFlows){
		necessaryFlows=necessaryFlows.length?necessaryFlows:[necessaryFlows];
		for(var i=0;i<necessaryFlows.length;i++){
			var necessaryFlow = necessaryFlows[i];
			var necessaryTypeid=necessaryFlow.value;
			if(!document.all(necessaryTypeid)){
				necessaryFlowCheck=false;
				break;
			}
		}
		if(!necessaryFlowCheck){
			alert("必须完成的流程未提交，不能完成任务!");
			return;
		}
	}
	location.href='/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=finish&taskid='+taskid+'&projectid='+projectid;
}
function initView(){//流程类别的任务显示处理
	if(document.getElementById('tasktype').value!='4028d6812d8f0fcc012d8f670f3c0003')	return;
	document.getElementById('taskflow').style.display='';
	var flowid = document.getElementById('workflowid').value;
	var requestid = document.getElementById('flowreqid').value;
	var requestName = document.getElementById('flowreqid').title;
	var workflowName = document.getElementById('workflowid').title;
	var flowspan = document.getElementById('flowspan');
	if(!requestid){
		if(<%=editPermission%>){//操作权限
			flowspan.innerHTML='<a href=javascript:createFlow();><img src="/images/silk/add.gif" align="absmiddle"> 新建'
				+workflowName.trim()+'</a> <a style="margin-left:10px;" href=javascript:updateFlow("'+flowid+'");> 添加</a>';
		}
	}else{//显示流程图
		document.getElementById('iframeDiv').style.display='';
		document.getElementById('chartframe').src='/wfdesigner/viewers/graphviewer.jsp?requestid='+requestid;
	}
}
function createFlow(){
	var workflowid = document.getElementById('workflowid').value;
	var workflowName = document.getElementById('workflowid').title;
	var url='/workflow/request/workflow.jsp?workflowid='+workflowid+'&messageKey=taskMessage&taskid='+taskid+'&projectid='+projectid;
	if(!workflowid){
		url='/workflow/request/startworkflow.jsp?&messageKey=taskMessage&taskid='+taskid+'&projectid='+projectid;
		workflowName='新建流程';
	}
	onUrl(url,workflowName,'tab'+workflowid);
}
function showUpdate(){
	document.getElementById("modifyTag").style.display="none";
	document.getElementById("finishTag").style.display="none";
	document.getElementById("percentSpan").style.display="";
}
function cancelUpdate(){
	document.getElementById("modifyTag").style.display="";
	document.getElementById("finishTag").style.display="";
	document.getElementById("percentSpan").style.display="none";
}
</script>
</body>
</html>
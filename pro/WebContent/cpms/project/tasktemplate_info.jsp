<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%> 
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%@ page import="com.eweaver.base.category.service.*" %>
<%@ page import="com.eweaver.base.category.model.*" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.cpms.project.wbstemplate.*" %>
<%
String selectTypeId="4028d6812d8f0fcc012d8f6639780002";//任务类别
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
HumresService humresService = (HumresService) BaseContext.getBean("humresService"); 
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService"); 
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService"); 

SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");


TaskTempService taskTempService = (TaskTempService)BaseContext.getBean("taskTempService");
DataService dataService = new DataService();

String taskid = StringHelper.null2String(request.getParameter("taskid"));
String tasktempid = StringHelper.null2String(request.getParameter("tasktempid"));
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
String messageid = StringHelper.null2String(request.getParameter("messageid"));

String ptaskid = StringHelper.null2String(request.getParameter("ptaskid"));//上级任务id
String tlevel = StringHelper.null2String(request.getParameter("tlevel"));//ceng ji 


TaskTemplate taskTemplate = taskTempService.getTaskTemp(taskid);
if(null == taskTemplate){
	taskTemplate = new TaskTemplate();
}
TaskTemplate ptm = taskTempService.getTaskTemp(ptaskid);//参数
if(!StringHelper.isEmpty(taskid))
	ptm = taskTempService.getTaskTemp(taskTemplate.getPid());//如果是编辑
	
if(null == ptm){
	ptm = new TaskTemplate();
}

String tabStr="";
boolean hasTab=false;
	pagemenustr += "addBtn(tb,'保存','S','disk',function(){javascript:onSave()});";

paravaluehm.put("{id}",taskid);
paravaluehm.put("{reftype}",reftype);
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(theuri,paravaluehm);
pagemenustr += menuList.get(0);
tabStr += menuList.get(1);

if(!tabStr.equals(""))
	hasTab=true;

List doctypeList = dataService.getValues("select a.id,a.doctypeid as categoryid,"+
	"a.workflowid as workflowid,a.description,a.isnecessary "+
	"from cpms_DoctypeLink a "+
	"where a.taskid='"+taskid+"' order by a.id desc");
List docList = dataService.getValues("select a.id,a.docid,b.subject as docname,a.description "+
	"from cpms_Doclink a,docbase b where a.docid=b.id and a.taskid='"+taskid+"' order by a.id desc");
	
List flowList = dataService.getValues("select a.id,"+
	"a.workflowid as workflowid,a.description,a.isnecessary "+
	"from cpms_flowlink a "+
	"where a.taskid='"+taskid+"' order by a.id desc");
List pretaskList = dataService.getValues("select a.id,b.objname,a.objtype,a.lag,a.description,a.pretaskid from cpms_tasklink a,cpms_tasktemplate b"+
	" where a.pretaskid=b.id and a.objid='"+taskid+"' order by a.id desc");
%>
<html>
  <head>
    <style type="text/css">
   #pagemenubar table {width:0}
</style>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script  type='text/javascript' src='/js/workflow.js'></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript">
  function getOrgByHumres(){
	var humresid = document.getElementById('humresid');
	var orgid = document.getElementById('orgid');
	var orgidspan = document.getElementById('orgidspan');
	if(humresid.value!=''){
		var sql = "select o.id,o.objname from orgunit o ,HUMRES h where h.ORGID=o.ID and h.id='"+humresid.value+"'";
		DWREngine.setAsync(false);	
		 DataService.getValues(sql,{                                               
	          callback: function(data){   
	              if(data && data.length>0){ 
	            	  orgid.value = data[0].id;
	            	  orgidspan.innerHTML=data[0].objname;
	              } 
	          }                 
	      });               
		DWREngine.setAsync(true);	
	}else{
		orgid.value="";
		orgidspan.innerHTML="";
	}
  }

  Ext.onReady(function() {
  Ext.QuickTips.init();
 <%if(!pagemenustr.equals("")){%>
     var tb = new Ext.Toolbar();
     tb.render('pagemenubar');
 <%=pagemenustr%>
 <%}%>

  var c = new Ext.Container({
         autoEl: {},
         <%if(hasTab){%>title:'<%=labelService.getLabelName("表单信息")%>',iconCls:Ext.ux.iconMgr.getIcon('application_form'),<%}else{%>region:'center',<%}%>
         width:Ext.lib.Dom.getViewportWidth(),
         height: Ext.lib.Dom.getViewportHeight(),
         layout: 'border',
         items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
     });
    <%if(hasTab){%>
    var contentPanel = new Ext.TabPanel({
           region:'center',
           id:'tabPanel',
           deferredRender:false,
           enableTabScroll:true,
           autoScroll:true,
           activeTab:0,
           items:[c]
       });
      <%=tabStr%>
      <%}%>
     //Viewport
var viewport = new Ext.Viewport({
       layout: 'border',
       items: [<%if(hasTab){%>contentPanel<%}else{%>c<%}%>]
});
 });
</script>
</head>
<body>
<div id="divSum">
<div id="pagemenubar"></div>
<form action="/ServiceAction/com.eweaver.cpms.project.wbstemplate.TaskTemplateAction?action=savebaseinfo" name="EweaverForm"  method="post">
<input type="hidden" name="pid" id="pid" value="<%=ptm.getId()==null?"":ptm.getId() %>"/><!-- parent tasktemp id -->
<input type="hidden" name="tlevel" id="tlevel" value="<%=tlevel %>"/>
<input type="hidden" name="taskid" id="taskid" value="<%=taskid %>"/>
<input type="hidden" name="tasktempid" id="taskid" value="<%=tasktempid %>"/>
<DIV id=layoutDiv>
<table class=layouttable border=1>
	<colgroup> 
		<col width="12%">
		<col width="38%">
		<col width="12%">
		<col width="38%">
	</colgroup>	
<tr>
<td class=FieldName>名称</td>
<td class=FieldValue><input type="text" name="objname" id="objname" value="<%=StringHelper.null2String(taskTemplate.getObjname())%>" style="width:90%"></td>
<td class=FieldName>父级任务</td>
<td class=FieldValue><%=StringHelper.null2String(ptm.getObjname()) %></td>
</tr>
<tr>

<td class=FieldName>负责人</td>
<td class=FieldValue><button type=button  class=Browser name="button_humresid" 
onclick="javascript:getrefobj('humresid','humresidspan','402881e70bc70ed1010bc75e0361000f','','/humres/base/humresinfo.jsp?id=','0');">
</button><input type="hidden" id="humresid" name="humresid"  value="<%=StringHelper.null2String(taskTemplate.getHumresid()) %>"  style="width: 80%" onpropertychange="getOrgByHumres()"  >
<span id="humresidspan" name="humresidspan" ><%=humresService.getHrmresNameById(taskTemplate.getHumresid()) %></span></td>
<td class=FieldName>负责部门</td>
<td class=FieldValue><button type=button  class=Browser name="button_orgid" 
onclick="javascript:getrefobj('orgid','orgidspan','402881e60bfee880010bff17101a000c','','/base/orgunit/orgunitview.jsp?id=','0');">
</button><input type="hidden" id="orgid" name="orgid" value="<%=StringHelper.null2String(taskTemplate.getOrgid()) %>"  style="width: 80%"  >
<span id="orgidspan" name="orgidspan" ><%=orgunitService.getOrgunitName(taskTemplate.getOrgid()) %></span></td>

</tr>
<tr style="display:none">
<td class=FieldName>是否关键任务</td>
<td class=FieldValue>
<input type="checkbox" id="iskey" name="iskey" value="1" <%if(StringHelper.null2String(taskTemplate.getIskey()).equals("1")){ %>checked<%} %>>
</td>
<td class=FieldName>监控点</td>
<td class=FieldValue>
<%
List controlPointList  = selectitemService.getSelectitemList2("402882082e9d4d64012e9e03486b0002",null);
for(int i=0;i<controlPointList.size();i++){ 
Selectitem selectitem = (Selectitem)controlPointList.get(i);
%>
<input type="checkbox" id="controlPoint" name="controlPoint" value="<%=selectitem.getId()%>" 
<%if(StringHelper.null2String(taskTemplate.getControlPoint()).indexOf(selectitem.getId())!=-1){ %>checked<%} %>> <%=selectitem.getObjname()%>
<%}%>
</td>
</tr>
<tr>
<td class=FieldName>任务类别</td>
<td class=FieldValue>
<select id="tasktype" name="tasktype" onchange="changeTaskType(this);">
<%
List selectitemList2 = selectitemService.getSelectitemList(selectTypeId,null);
for(int i=0;i<selectitemList2.size();i++){ 
Selectitem selectitem = (Selectitem)selectitemList2.get(i);%>
<option value="<%=selectitem.getId() %>" <%if(selectitem.getId().equals(taskTemplate.getTasktype())){ %>selected<%} %> ><%=selectitem.getObjname() %></option>
<%} %></select>
<span id="workflowspan" style="padding-left: 10px;color: blue;display:<%=StringHelper.isEmpty(taskTemplate.getWorkflowid())?"none":""%>;">
	任务流程：
	<button type=button class=Browser onclick="javascript:getrefobj('workflowid','workflowidspan','402880371d60e90c011d6107be5c0008','','','0');">
	</button><input type="hidden" name="workflowid" value="<%=StringHelper.null2String(taskTemplate.getWorkflowid())%>" ><span id="workflowidspan" name="workflowidspan" >
	<%=workflowinfoService.getWorkflowName(taskTemplate.getWorkflowid())%></span>
</span>
</td>

<td class=FieldName>工期</td>
<td class=FieldValue>
<input type="text" style="width:30px" name="limittime"  id="limittime" value="<%=taskTemplate.getLimittime() %>"  
onblur="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','工期')"  onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','工期');" />
<span id="limittimespan" name="limittimespan" >(天)</span></td>
</tr>
<tr>
<td class=FieldName>描述</td>
<td class=FieldValue colspan=3><TEXTAREA name="desc" id="desc" style='width: 100%;'><%=StringHelper.null2String(taskTemplate.getDescription()) %></TEXTAREA>
</td>
</tr>
</table>
</div>
<%if(!StringHelper.isEmpty(taskid)){%>
<div id="taskinfo">
<table class="layouttable">
<tr><td width="12%" class="FieldName">参考文档</td><td>
<table id="tab1" >
<tr class="Header">
<td width="60%"> 标题 [<a href="javascript:editDoc('<%=taskid%>','')"> 添加 </a>]</td>
<td>备注</td>
<td width="60px;">操作</td>
</tr>
<%if(null != docList && docList.size()>0){ 
for(int i=0;i<docList.size();i++){
Map map = (Map)docList.get(i);
%>
<tr>
<td><a href="javascript:openDoc('<%=map.get("docid")%>','<%=map.get("docname")%>');"><%=StringHelper.null2String(map.get("docname")) %></a></td>
<td><%=StringHelper.null2String(map.get("description")) %></td>
<td><img style="cursor:hand;" src="/images/silk/delete.gif" id="delete1" title="删除" onclick="javascript:deleteDoc('<%=StringHelper.null2String(map.get("id")) %>')">
	<img style="cursor:hand;" src="/images/silk/pencil.gif" id="modify1" title="编辑" onclick="javascript:editDoc('<%=taskid %>','<%=StringHelper.null2String(map.get("id")) %>')">
</td>
</tr>

<%}} %>
</table>
</td></tr>

<tr>
<td width="12%" class="FieldName">前置任务</td><td>
<table id="tab2">
<tr class="Header">
<td width="30%">前置任务名称   [<a href="javascript:editPertask('<%=taskid%>','')"> 添加 </a>]</td>
<td width="15%">类型</td>
<td width="15%">延迟(天)</td>
<td>备注</td>
<td width="60px">操作</td>
</tr>
<%if(null != pretaskList && pretaskList.size()>0){
for(int i=0;i<pretaskList.size();i++){
Map map = (Map)pretaskList.get(i);
%>
<tr>
<td><a href="javascript:onUrl('/cpms/template/taskTemplateView.jsp?taskid=<%=StringHelper.null2String(map.get("pretaskid")) %>&tasktempid=<%=tasktempid %>','<%=StringHelper.null2String(map.get("objname")) %>','tab1')"><%=StringHelper.null2String(map.get("objname")) %></a></td>
<td><%=StringHelper.null2String(map.get("objtype")) %></td>
<td><%=StringHelper.null2String(map.get("lag")) %></td>
<td><%=StringHelper.null2String(map.get("description")) %></td>
<td><img style="cursor:hand;" src="/images/silk/delete.gif" id="delete1" title="删除" onclick="javascript:deletePertask('<%=StringHelper.null2String(map.get("id")) %>')">
<img style="cursor:hand;" src="/images/silk/pencil.gif" id="modify1" title="编辑" onclick="javascript:editPertask('<%=taskid %>','<%=StringHelper.null2String(map.get("id")) %>')">
</td>   
</tr>
<%}} %>
</table>
</td></tr>
<tr><td width="12%" class="FieldName">输出文档定义</td><td>
<table id="tab3" >
<tr class="Header">
<td width="30%">文档类别   [<a href="javascript:openDoctype('<%=taskid%>','')"> 添加 </a>]</td>
<td width="15%">审批流程</td>
<td width="15%">是否必须</td>
<td>备注</td>
<td width="60px">操作</td>
</tr>
<%if(null != doctypeList && doctypeList.size()>0){ 
for(int i=0;i<doctypeList.size();i++){
Map map = (Map)doctypeList.get(i);
%>
<tr>
<%
String categoryname = categoryService.getCategoryNameStrByCategory(StringHelper.null2String(map.get("categoryid")));
 %>
<td><a><%=categoryname %></a></td>
<%
String workflowinfoname = workflowinfoService.getWorkflowName(StringHelper.null2String(map.get("workflowid")));
 %>
<td><a><%=workflowinfoname%></a></td>
<td><%if("1".equals(StringHelper.null2String(map.get("isnecessary")))){ %>
<img src="/images/base/bacocheck.gif"><%}else{ %><img src="/images/base/bacocross.gif"><%} %>
</td>
<td><%=StringHelper.null2String(map.get("description")) %></td>
<td><img style="cursor:hand;" src="/images/silk/delete.gif" id="delete1" title="删除" onclick="javascript:deleteDoctype('<%=StringHelper.null2String(map.get("id")) %>')">
<img style="cursor:hand;" src="/images/silk/pencil.gif" id="modify1" title="编辑" onclick="javascript:openDoctype('<%=taskid %>','<%=StringHelper.null2String(map.get("id")) %>')">
</td>
</tr>
<%}} %>
</table>
</td></tr>

<tr><td width="12%" class="FieldName">任务流程定义</td><td>

<table id="tab4" >

<tr class="Header">
	<td width="45%">流程类别   [<a href="javascript:editFlow('<%=taskid%>','')"> 添加 </a>]</td>
	<td width="15%">是否必须</td>
	<td>备注</td>
	<td width="60px">操作</td>
</tr>
<%if(null != flowList && flowList.size()>0){
for(int i=0;i<flowList.size();i++){
Map map = (Map)flowList.get(i);
%>
<tr>
<%
String workflowinfoname = workflowinfoService.getWorkflowName(StringHelper.null2String(map.get("workflowid")));
 %>
<td><a><%=workflowinfoname%></a></td>
<td><%if("1".equals(StringHelper.null2String(map.get("isnecessary")))){ %>
<img src="/images/base/bacocheck.gif"><%}else{ %><img src="/images/base/bacocross.gif"><%} %></td>
<td><%=StringHelper.null2String(map.get("description")) %></td>
<td><img style="cursor:hand;" src="/images/silk/delete.gif" id="delete1" title="删除" onclick="javascript:deleteFlow('<%=StringHelper.null2String(map.get("id")) %>')">
<img style="cursor:hand;" src="/images/silk/pencil.gif" id="modify1" title="编辑" onclick="javascript:editFlow('<%=taskid %>','<%=StringHelper.null2String(map.get("id")) %>')">
</td>
</tr>
<%}} %>
</table>
</td></tr>
</table>
</div>
<%}%>
</form>
</div>
<script language=javascript>
function onSave(){
	if(document.getElementById("objname").value){
		document.EweaverForm.submit();
	}else{
		alert("任务名称未填写");
	}
}
function changeTaskType(select){
	document.getElementById('workflowspan').style.display='none';
	var value = select.value;
	if(value=='4028d6812d8f0fcc012d8f670f3c0003'){//流程
		document.getElementById('workflowspan').style.display='';
	}
}
function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
          if(document.getElementById('input_'+inputname)!=null)
     document.getElementById('input_'+inputname).value="";
    var param = parserRefParam(inputname,param);
	var idsin = document.all(inputname).value;
       if(inputname=='station'){
           var mainstation=document.all('mainstation').value;
           idsin=idsin.replace(mainstation,'');
       }
	var id;
    try{
    id=openDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
function openDoc(docid,title){
	onUrl('/document/base/docbaseview.jsp?id='+docid,title,'tab_'+docid);
}
function editDoc(taskid,id){
	var url='/cpms/project/doclink.jsp?taskid='+taskid+'&id='+id+'&tasktempid=<%=tasktempid%>';
	openWin(url,'参考文档','bullet_plus',700,300);
}
function deleteDoc(id){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=delDoc&id='+id+'&taskid=<%=taskid%>&tasktempid=<%=tasktempid%>';
	}
}
function editPertask(taskid,id){
	var url='/cpms/project/pretask.jsp?objid=<%=taskid%>&tasktempid=<%=tasktempid%>&id='+id;
	openWin(url,'前置任务','bullet_plus',700,300);
}
function deletePertask(id){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.pretask.PreTaskAction?action=delete&id='+id+'&taskid=<%=taskid%>&tasktempid=<%=tasktempid%>';
	}
}
//文档分类
function openDoctype(taskid,id){//新增
	var url='/cpms/project/doctype.jsp?id='+id+'&taskid=<%=taskid%>&tasktempid=<%=tasktempid%>';
	openWin(url,'文档分类','bullet_plus',700,300);
}
function deleteDoctype(id){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=delDoctype&id='+id+'&taskid=<%=taskid%>&tasktempid=<%=tasktempid%>';
	}
}
function editFlow(taskid,id){
	var url='/cpms/project/flowtype.jsp?taskid='+taskid+'&id='+id+'&tasktempid=<%=tasktempid%>';
	openWin(url,'任务流程','bullet_plus',700,300);
}
function deleteFlow(id){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.flow.FlowAction?action=delFlow&id='+id+'&taskid=<%=taskid%>&tasktempid=<%=tasktempid%>';
	}
}
</script>
</body>
</html>
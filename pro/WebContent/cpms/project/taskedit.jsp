<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.cpms.project.doc.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="java.math.*"%>
<%@ page import="com.eweaver.document.weaverocx.WeaverOcx"%>

<%
String categoryid = "402880ac2d823840012d825c62750003";//任务分类ID
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));
FormService formService = (FormService)BaseContext.getBean("formService");
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
FormBaseService formbaseService = (FormBaseService)BaseContext.getBean("formbaseService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
//是否启用附件大小控件检测
String weatherCheckFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b14fbae82000b").getItemvalue());
//文档附件大小
String maxFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b153bbc17000b").getItemvalue());
DataService dataService = new DataService();
String tSQL = "select * from cpms_task where requestid = '"+requestid+"'";
Map t = dataService.getValuesForMap(tSQL);
String pid = StringHelper.null2String(t.get("pid"));
String pPlanstart = "";
String pPlanfinish = "";
if(!StringHelper.isEmpty(pid)){
	String pTaskSQL = "select t.* from cpms_task t where t.requestid='"+pid+"'";
	Map pTask = dataService.getValuesForMap(pTaskSQL);
	pPlanstart = StringHelper.null2String(pTask.get("planstart"));
	pPlanfinish = StringHelper.null2String(pTask.get("planfinish"));
}

Category category = categoryService.getCategoryById(categoryid);
Forminfo forminfo = forminfoService.getForminfoById(category.getPFormid());

Map formParameters = new HashMap();
formParameters.put("bNewworkflow",0);
formParameters.put("requestid",requestid);
formParameters.put("bviewmode","2");
formParameters.put("bView","0");
formParameters.put("bWorkflowform","2");

Map initparameters = new HashMap();
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String pName = e.nextElement().toString().trim();
	String pValue = StringHelper.trimToNull(request.getParameter(pName));
	if(!StringHelper.isEmpty(pName)){
		initparameters.put(pName,pValue);
    }
}
formParameters.put("initparameters",initparameters);

String layoutid="";
List layoutlist = formlayoutService.getOptLayoutList(null,OptType.VIEW);
for (Object layout : layoutlist) {
    if(layout==null)
    continue;
    if (formlayoutService.getFormlayoutById((String) layout).getTypeid() == 1){
        layoutid = formlayoutService.getFormlayoutById((String) layout).getId();
        break;
    }
}
if (StringHelper.isEmpty(layoutid)){
    layoutid = category.getPEditlayoutid();
}
formParameters.put("layoutid",layoutid);
formParameters.put("formid",forminfo.getId());
formParameters = formService.WorkflowView(formParameters);
layoutid = StringHelper.null2String(formParameters.get("layoutid"));
String needcheckfields = StringHelper.null2String(formParameters.get("needcheck"));
String formcontent = StringHelper.null2String(formParameters.get("formcontent"));
String fieldcalscript = StringHelper.null2String(formParameters.get("fieldcalscript"));
String triggercalscript = StringHelper.null2String(formParameters.get("triggercalscript"));

String docSQL = "select d.subject,c.objname as category,h.objname as creator,l.* from docbase d,cpms_doclink l,category c,humres h "
		+"where l.taskid='"+requestid+"' and d.id = l.docid and d.categoryids=c.id and d.creator=h.id and l.objtype='template'";
List docList = dataService.getValues(docSQL);
String taskSQL = "select t.objname,l.* from cpms_tasklink l,cpms_task t where objid='"+requestid+"' and t.requestid=l.pretaskid";
List taskList = dataService.getValues(taskSQL);
String resourceSQL = "select a.id,a.humresid,b.objname,a.role,a.theunit,a.plantime,a.realtime,a.description from cpms_taskresource a,humres b "
		+"where a.humresid=b.id and a.taskid='"+requestid+"' and a.projectid='"+projectid+"'";
List resourceList = dataService.getValues(resourceSQL);
String doctypeSQL="select c.objname as cname,w.objname as wname,l.* from cpms_doctypelink l left join category c on l.doctypeid=c.id "
		+"left join workflowinfo w on w.id = l.workflowid where l.taskid='"+requestid+"'";
List doctypeList = dataService.getValues(doctypeSQL);
String flowSQL="select w.objname,l.* from cpms_flowlink l left join workflowinfo w on l.workflowid=w.id where requestid is null and l.taskid='"+requestid+"'";
List flowList = dataService.getValues(flowSQL);
%>
<html>
<head>
<title>修改任务</title>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script src='/dwr/interface/DataService.js'></script>

<script type="text/javascript" language="javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/js/formbase.js"></script>
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" src="/cpms/scripts/base.js"></script>
<script type='text/javascript' src='/js/workflow.js'></script>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var tb1 = new Ext.Toolbar();
	tb1.render('pagemenubar');
	addBtn(tb1,'保存','S','disk',function(){save();});
	addBtn(tb1,'显示视图','B','arrow_undo',function(){location.href='/cpms/project/taskinfo.jsp?projectid=<%=projectid%>&requestid=<%=requestid%>';});
	attachEvents();
});
</script>
</head>
<body>
<div id="pagemenubar"></div>
<%if("1".equals(weatherCheckFileSize)){%>
<OBJECT classid="<%=WeaverOcx.clsid%>" codebase="<%=WeaverOcx.codebase%>" id="filecheck" style="display:none"></OBJECT>
<%}%>
<input type="hidden" id="402881e50b14f840010b14fbae82000b" value="<%=weatherCheckFileSize%>" />
<input type="hidden" id="402881e50b14f840010b153bbc17000b" value="<%=maxFileSize%>" />
<form id="EweaverForm" name="EweaverForm" enctype="multipart/form-data" action="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=modify" method="post">
<input type="hidden" name=requestid value="<%=requestid%>">
<input type="hidden" name="projectid" value="<%=projectid%>">
<input type="hidden" name="formid" value="<%=forminfo.getId()%>">
<%=formcontent%>
<div id="taskinfodiv">
<table class="layouttable" style="margin-top: -2px;">
	<tr>
		<td width="12%" class="FieldName">参考文档</td>
		<td>
		<table border=1 cellspacing="1">
			<tr class="header">
				<td width="30%">标题 [<a href="javascript:editDocument('','<%=requestid%>','<%=projectid%>')"> 添加 </a>]</td>
				<td width="15%">文档类别</td>
				<td width="15%">创建者</td>
				<td>备注</td>
				<td width="40px">操作</td>
			</tr>
			<%for(int i=0;i<docList.size();i++){
				Map map = (Map)docList.get(i);
			%>
			<tr height="25px">
				<td><a href="javascript:openDoc('<%=map.get("docid")%>','<%=map.get("subject")%>');"><%=map.get("subject")%></a></td>
				<td><%=map.get("category")%></td>
				<td><%=map.get("creator")%></td>
				<td><%=StringHelper.null2String(map.get("description"))%></td>
				<td >
					<img style="cursor:hand;" src="/images/silk/pencil.gif" title="编辑" onclick="javascript:editDocument('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
					<img style="cursor:hand;" src="/images/silk/delete.gif" title="删除" onclick="javascript:delDocument('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
				</td>
			</tr>
			<%}%>
		</table>
		</td>
	</tr>
	<tr>
		<td class="FieldName">前置任务</td>
		<td>
		<table style="margin:3px;">
			<tr class="header">
				<td width="30%">前置任务名称   [<a href="javascript:editPretask('','<%=requestid%>','<%=projectid%>')"> 添加 </a>]</td>
				<td width="15%">类型</td>
				<td width="15%">延迟(天)</td>
				<td>备注</td>
				<td width="40px">操作</td>
			</tr>
			<%for(int i=0;i<taskList.size();i++){
				Map map = (Map)taskList.get(i);
			%>
			<tr height="25px">
				<td width="30%"><a><%=StringHelper.null2String(map.get("objname"))%></a></td>
				<td width="15%"><%=StringHelper.null2String(map.get("objtype"))%></td>
				<td width="15%"><%=map.get("lag")%>天</td>
				<td><%=StringHelper.null2String(map.get("description"))%></td>
				<td>
					<img style="cursor:hand;" src="/images/silk/pencil.gif" title="编辑" onclick="javascript:editPretask('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
					<img style="cursor:hand;" src="/images/silk/delete.gif" title="删除" onclick="javascript:delPretask('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
				</td>
			</tr>
			<%}%>
		</table>
		</td>
	</tr>
	<tr>
		<td width="12%" class="FieldName">资源 </td>
		<td>
		<table style="margin:3px;">
			<tr class="header">
				<td width="30%">人员  [<a href="javascript:editResource('','<%=requestid%>','<%=projectid%>')"> 添加 </a>]</td>
				<td width="15%">角色</td>
				<td width="15%">使用单位</td>
				<td>备注</td>
				<td width="40px">操作</td>
			</tr>
			<%for(int i=0;i<resourceList.size();i++){
				Map map = (Map)resourceList.get(i);
			%>
			<tr height="25px">
				<td ><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=map.get("humresid")%>','<%=StringHelper.null2String(map.get("objname"))%>','tab<%=map.get("humresid")%>');"><%=StringHelper.null2String(map.get("objname"))%></a></td>
				<td><%=StringHelper.null2String(map.get("role"))%></td>
				<td><%=StringHelper.null2String(map.get("theunit"))%></td>
				<td ><%=StringHelper.null2String(map.get("description"))%></td>
				<td>
					<img style="cursor:hand;" src="/images/silk/pencil.gif" title="编辑" onclick="javascript:editResource('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
					<img style="cursor:hand;" src="/images/silk/delete.gif" title="删除" onclick="javascript:delResource('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
				</td>
			</tr>
			<%}%>
		</table>
		</td>
	</tr>
	<tr>
		<td class="FieldName">输出文档定义</td>
		<td>
		<table style="margin:3px;">
			<tr class="header">
				<td width="30%">文档类别   [<a href="javascript:editDoctype('','<%=requestid%>','<%=projectid%>')"> 添加 </a>]</td>
				<td width="20%">审批流程</td>
				<td width="10%">是否必须</td>
				<td>备注</td>
				<td width="40px">操作</td>
			</tr>
			<%for(int i=0;i<doctypeList.size();i++){
				Map map = (Map)doctypeList.get(i);
			%>
			<tr height="25px">
				<td width="30%"><a><%=StringHelper.null2String(map.get("cname"))%></a></td>
				<td width="20%"><%=StringHelper.null2String(map.get("wname"))%></td>
				<td width="10%">
				<%if(NumberHelper.getIntegerValue(map.get("isnecessary"))==1){%><img src="/images/base/bacocheck.gif"/><%}%>
				</td>
				<td><%=StringHelper.null2String(map.get("description"))%></td>
				<td>
					<img style="cursor:hand;" src="/images/silk/pencil.gif" title="编辑" onclick="javascript:editDoctype('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
					<img style="cursor:hand;" src="/images/silk/delete.gif" title="删除" onclick="javascript:delDoctype('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
				</td>
			</tr>
			<%}%>
		</table>
		</td>
	</tr>
	<tr>
		<td class="FieldName">任务流程定义</td>
		<td>
		<table style="margin:3px;">
			<tr class="header">
				<td width="30%">流程类别   [<a href="javascript:editFlow('','<%=requestid%>','<%=projectid%>')"> 添加 </a>]</td>
				<td width="30%">是否必须</td>
				<td>备注</td>
				<td width="40px">操作</td>
			</tr>
			<%for(int i=0;i<flowList.size();i++){
				Map map =(Map)flowList.get(i);
			%>
			<tr>
				<td width="30%"><a><%=StringHelper.null2String(map.get("objname"))%></a></td>
				<td width="30%">
				<%if(NumberHelper.getIntegerValue(map.get("isnecessary"))==1){%><img src="/images/base/bacocheck.gif"/><%}%>
				</td>
				<td><%=StringHelper.null2String(map.get("desc"))%></td>
				<td width="40px">
					<img style="cursor:hand;" src="/images/silk/pencil.gif" title="编辑" onclick="javascript:editFlow('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
					<img style="cursor:hand;" src="/images/silk/delete.gif" title="删除" onclick="javascript:delFlow('<%=map.get("id")%>','<%=requestid%>','<%=projectid%>');">
				</td>
			</tr>
			<%}%>
		</table>
		</td>
	</tr>
</table>
</div>
</form>
<script type="text/javascript">
function save(){
	onCal();
	EweaverForm.submit();
}
function openDoc(docid,title){
	onUrl('/document/base/docbaseview.jsp?id='+docid,title,'tab_'+docid);
}
function editDocument(id,taskid,projectid){
	var url='/cpms/project/doclink.jsp?taskid='+taskid+'&id='+id+'&projectid='+projectid;
	openWin(url,'参考文档','bullet_plus',700,300);
}
function delDocument(id,taskid,projectid){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=delDoc&taskid='
			+taskid+'&projectid='+projectid+'&id='+id;
	}
}
//获取前置任务
function editPretask(id,taskid,projectid){
	var url='/cpms/project/pretask.jsp?id='+id+'&objid='+taskid+'&projectid='+projectid;
	openWin(url,'前置任务','bullet_plus',700,300);
}
function delPretask(id,taskid,projectid){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.pretask.PreTaskAction?action=delete&taskid='
			+taskid+'&projectid='+projectid+'&id='+id;
	}
}
function editResource(id,taskid,projectid){
	var url='/base/popupmain.jsp?url=/cpms/project/taskresource.jsp?taskid='+taskid+'&projectid='+projectid+'&objid='+id;
	openWin(url,'任务资源','bullet_plus',700,300);
}
function delResource(id,taskid,projectid){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.resource.TaskResourceAction?action=delresource&projectid='+projectid+'&id='+id+'&taskid='+taskid;
	}
}
function editDoctype(id,taskid,projectid){
	var url='/base/popupmain.jsp?url=/cpms/project/doctype.jsp?id='+id+'&projectid='+projectid+'&taskid='+taskid;
	openWin(url,'文档类别','bullet_plus',700,300);
}
function delDoctype(id,taskid,projectid){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.doc.DocAction?action=delDoctype&taskid='
			+taskid+'&projectid='+projectid+'&id='+id;
	}
}
function editFlow(id,taskid,projectid){
	var url='/cpms/project/flowtype.jsp?id='+id+'&projectid='+projectid+'&taskid='+taskid;
	openWin(url,'文档类别','bullet_plus',700,300);
}
function delFlow(id,taskid,projectid){
	if(confirm('确定删除吗?')){
		location.href='/ServiceAction/com.eweaver.cpms.project.flow.FlowAction?action=delFlow&taskid='
			+taskid+'&projectid='+projectid+'&id='+id;
	}
}
function attachEvents(){
	flowEvent();
	dateEvent();
}
function flowEvent(){
	var workflowspan = document.getElementById('workflowspan');
	workflowspan.style.display='none';
	var select = document.getElementById('field_402882082e5a59c2012e5ad46da0000f');
	if(select.value=='4028d6812d8f0fcc012d8f670f3c0003'){
		workflowspan.style.display='';
	}
	select.onchange =function(){
		workflowspan.style.display='none';
		var value = select.value;
		if(value=='4028d6812d8f0fcc012d8f670f3c0003'){
			workflowspan.style.display='';
		}
	}
}
function dateEvent(){
	var date1 = document.getElementById('field_402882082e5a59c2012e5aa95a26000a');
	date1.onclick=function(){
		WdatePicker({minDate:'<%=pPlanstart%>',maxDate:"#F{$dp.$D('field_402882082e5a59c2012e5aa95a2c000b')}"});
	}
	var date2 = document.getElementById('field_402882082e5a59c2012e5aa95a2c000b');
	date2.onclick=function(){
		WdatePicker({minDate:"#F{$dp.$D('field_402882082e5a59c2012e5aa95a26000a')}",maxDate:'<%=pPlanfinish%>'});
	}
}       
function checkFileSize(filepath,maxSize){
    var size=getFileSize(filepath);
    if(size>maxSize)
    return false;
    return true;
}
function getFileSize(filepath){
	 if(filepath=='')
	 {
		return null;
	 }
	 try
	 {
		 filecheck.FilePath=filepath;
		 var size=filecheck.getFileSize()/(1024*1024);
		 return size;
	 }
	 catch(e)
	 {
		alert(e);
		return null;
	}
 return null;
}

var strSQLs = new Array();
var strValues = new Array();
<%=triggercalscript%>
function SQL(param){
	param = encode(param);

	if(strSQLs.indexOf(param)!=-1){
		var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
		return retval;
	}else{
		var _url= "/ServiceAction/com.eweaver.base.DataAction?sql="+encodeURIComponent(param);
		//将Msxml.xmldocument加载xml文件改为JQuery自带的Ajax封装类并同步加载
		var xmlrequest=jQuery.ajax({
			type: "GET",
			async:false,
			url: _url,
			error:function (XMLHttpRequest, textStatus, errorThrown){
					alert('Error:'+errorThrown);
					return '';
			}
		});
		var XMLDoc=xmlrequest.responseXML;//返回结果集的Xmldom对象，即原先new ActiveXObject创建的对象
		var XMLRoot=XMLDoc.documentElement;//返回根结点，在FireFox下不是该属性名称且XMLRoot.text属性也不可用。
		//var retval = getValidStr(XMLRoot.text);
		if(XMLRoot==null)
			XMLRoot = loadXML(xmlrequest.responseText.replace(/&mdash;/g, '-')).documentElement;
		var retval = XMLRoot.firstChild ? getValidStr(XMLRoot.firstChild.nodeValue) : "";
		strSQLs.push(param);
		strValues.push(retval);
		return retval;
	}
}
var loadXML = function(xmlFile){ 
    var xmlDoc; 
    if(window.ActiveXObject){ 
        var ARR_ACTIVEX = ["MSXML4.DOMDocument","MSXML3.DOMDocument","MSXML2.DOMDocument","MSXML.DOMDocument","Microsoft.XmlDom"]; 
        for (var i = 0;i < ARR_ACTIVEX.length;i++) { 
            try { 
                var objXML = new ActiveXObject(ARR_ACTIVEX[i]); 
                xmlDoc = objXML; 
                break; 
            } catch (e) {} 
        } 
        if (xmlDoc) { 
            xmlDoc.async = false; 
            xmlDoc.loadXML(xmlFile); 
        }else{ 
            return; 
        } 
    }else if (document.implementation && document.implementation.createDocument){//判断是不是遵从标准的浏览器 
        //建立DOM对象的标准方法 
        xmlDoc = document.implementation.createDocument('', '', null); 
        xmlDoc.load(xmlFile); 
    }else{ 
        return null; 
    } 
    return xmlDoc; 
}

function onCal(){
	try{
		var rowindex = 0;
		<%=fieldcalscript%>
		function SUM(param){
			var result = 0;
			for(index=0;index<rowindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				result += tmpval;
			}
			rowindex = 0;
			return result;
		}
		function RMB(param){
			var tmpval = eval(param)*1;
			var result =  convertCurrency(tmpval);
			return result;
		}
		function COUNT(param){
			var result = 0;
			for(index=0;index<rowindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				if(tmpval != 0)
					result ++;
			}
			rowindex = 0;
			return result;
		}
		function PROD(param){
			var result = 1;
			for(index=0;index<rowindex;index++){
				tmpval = 1;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 1;
				}
				result = result * tmpval;
			}
			rowindex = 0;
			return result;
		}
		function MAX(param, thisindex){
			this.tempIndex = index;//用于进这个函数志强的index值
			var result = 0;
			for(index=0;index<thisindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				if(tmpval > result)
					result = tmpval;
			}
			index = this.tempIndex;//还原在被此函数用了的index值
			return result;
		}
	}catch(e){
	}
}
var task=new Ext.util.DelayedTask(onCal);
</script>     
<SCRIPT FOR = document EVENT = onselectionchange>
var caldelay=200;
task.delay(caldelay,null,this);
</SCRIPT>
</body>
</html>
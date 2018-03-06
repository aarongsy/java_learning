<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.document.weaverocx.WeaverOcx"%>
<%
String categoryid = "402880ac2d823840012d825c62750003";//任务分类ID
String projectid = StringHelper.null2String(request.getParameter("projectid"));//项目ID
String pid = StringHelper.null2String(request.getParameter("pid"));//父任务ID
DataService dataService = new DataService();
String pPlanstart = "";
String pPlanfinish = "";
if(!StringHelper.isEmpty(pid)){
	String pTaskSQL = "select t.* from cpms_task t where t.requestid='"+pid+"'";
	Map pTask = dataService.getValuesForMap(pTaskSQL);
	pPlanstart = StringHelper.null2String(pTask.get("planstart"));
	pPlanfinish = StringHelper.null2String(pTask.get("planfinish"));
}

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
Category category = categoryService.getCategoryById(categoryid);
Forminfo forminfo = forminfoService.getForminfoById(category.getPFormid());

Map formParameters = new HashMap();
formParameters.put("bNewworkflow",1);
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
List layoutlist = formlayoutService.getOptLayoutList(null,OptType.CREATE);
for (Object layout : layoutlist) {
    if(layout==null)
    continue;
    if (formlayoutService.getFormlayoutById((String) layout).getTypeid() == 1){
        layoutid = formlayoutService.getFormlayoutById((String) layout).getId();
        break;
    }
}
if (StringHelper.isEmpty(layoutid)){
    layoutid = category.getPCreatelayoutid();
}
formParameters.put("layoutid",layoutid);
formParameters.put("formid",forminfo.getId());
formParameters = formService.WorkflowView(formParameters);
layoutid = StringHelper.null2String(formParameters.get("layoutid"));
String checkfields = StringHelper.null2String(formParameters.get("needcheck"));
String formcontent = StringHelper.null2String(formParameters.get("formcontent"));
String fieldcalscript = StringHelper.null2String(formParameters.get("fieldcalscript"));
String triggercalscript = StringHelper.null2String(formParameters.get("triggercalscript"));
%>
<html>
<head>
<title>任务创建</title>
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
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" src="/cpms/scripts/base.js"></script>
<script type='text/javascript' src='/js/workflow.js'></script>
<script type="text/javascript" language="javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var tb1 = new Ext.Toolbar();
	tb1.render('pagemenubar');
	addBtn(tb1,'保存','S','disk',function(){save();});
	addBtn(tb1,'关闭','C','delete',function(){if(parent && parent.closechild){parent.closechild();}});
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
<form id="EweaverForm" name="EweaverForm" enctype="multipart/form-data"  action="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=create" method="post">
<input type="hidden" name="projectid" value="<%=projectid%>">
<input type="hidden" name="categoryid" value="<%=categoryid%>">
<input type="hidden" name="formid" value="<%=forminfo.getId()%>">
<input type="hidden" name="pid" value="<%=pid%>">
<%=formcontent%>
</form>
<script type="text/javascript">
function save(){
	var checkfields = '<%=checkfields%>';
	var checkmessage = '必填项不能为空!';
	onCal();
	if(checkForm(EweaverForm,checkfields,checkmessage)){
		EweaverForm.submit();
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
<%@ page import="java.util.*,com.eweaver.base.util.VtlEngineHelper,java.io.*" %>
<jsp:directive.page import="org.apache.velocity.VelocityContext"/>
<jsp:directive.page import="com.eweaver.workflow.form.service.FormBaseService"/>
<jsp:directive.page import="com.eweaver.base.BaseContext"/>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.workflow.form.model.*"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.model.DynamicFormAction"/>
<jsp:directive.page import="com.eweaver.workflow.form.service.ForminfoService"/>
<jsp:directive.page import="com.eweaver.workflow.form.service.FormfieldService"/>
<jsp:directive.page import="com.eweaver.base.BaseJdbcDao"/>
<jsp:directive.page import="com.eweaver.base.Page"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.service.TemplateEngine"/>
<jsp:directive.page import="org.springframework.jdbc.core.JdbcTemplate"/>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ include file="/base/init.jsp"%>
<%!private ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
private FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
private BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
private JdbcTemplate jdbcTemp=baseJdbcDao.getJdbcTemplate();
private void TemplateAction(String fname){


}

/**
 * 根据模板分析数据表别名
 *
 **/
private List<String> parseTempateVarname(String strTemp){
	List<String> list1=StringHelper.parseTemplateVar(strTemp, StringHelper.REGEXP_VAR1);
	List<String> fields=new ArrayList<String>();
	String tmp=null;
	for(String f:list1){
		//System.out.println(f);
		f=f.trim();
		if(f.endsWith("List")){
			tmp=f.substring(0, f.length()-4);
			if(!fields.contains(tmp)) fields.add(tmp);
		}
		int pos=f.lastIndexOf("Object.");
		if(pos>0){
			tmp=f.substring(0,pos);
			if(!fields.contains(tmp)) fields.add(tmp);
		}
	}//end if.
	return fields;
}

/**
 * 根据对象名获取Formid
 *
 **/
private String getFromIdByTableName(String objTbName){
	String id=null;
	String sql="select id,objtablename from forminfo where replace(objtablename,'_','')='"+objTbName+"'";
	List list1=jdbcTemp.queryForList(sql);
	Map m=null;
	if(list1!=null && list1.size()>0) m=(Map)list1.get(0);
	if(m!=null && m.size()>0)
		id=m.get("id").toString();
	return id;
}

private List getFormListByTableName(Forminfo formInfo){
	List list1=new ArrayList();
	
	String sql="select * from "+formInfo.getObjtablename()+" where rownum<=10";
	
	return jdbcTemp.queryForList(sql);
}

private VelocityContext _getContextData(String formId,VelocityContext context){
	if(context==null) context=new VelocityContext();

	Forminfo formInfo=forminfoService.getForminfoById(formId);
	String tbName=this.filterObjectName(formInfo.getObjtablename());
	context.put(tbName+"Object", formInfo);
	context.put(tbName+"List", this.getFormListByTableName(formInfo));
	context.put("title", "测试模板");
	
	return context;
}

private String filterObjectName(String tableName){
	if(!StringHelper.isEmpty(tableName)){
		tableName=tableName.replaceAll("_","");
		tableName=tableName.toLowerCase();
		//tableName+="Object";
	}
	return tableName;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<!--
<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
 -->
<script language="javascript" src="<%=request.getContextPath()%>/js/main.js"></script>
<title>模板编辑</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/tree.css" />

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript">
function onSubmit(){
	//alert('aaa'); templateText title
	//if(){
		if(document.getElementsByName('title')[0].value.trim().length<=0){//||$('templateText').value.trim().length<=0
				alert('标题不能为空！');
				return;
		}	
		document.form1.submit();
	//}
}
WeaverUtil.imports(['<%=request.getContextPath()%>/dwr/engine.js','<%=request.getContextPath()%>/dwr/util.js','<%=request.getContextPath()%>/dwr/interface/FormfieldService.js']);
WeaverUtil.isDebug=false;

Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';
var topBar=null;
WeaverUtil.load(function(){
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'保存','S','accept',function(){onSubmit()});  //document.form1.submit();
	addBtn(topBar,'返回','B','arrow_redo',function(){location.href='<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction';});
	topBar.addSeparator();
	addBtn(topBar,'全屏编辑','F','arrow_out',fullScreen);
	addBtn(topBar,'插入SelectItem','I','textfield_add',insertSelectItem);
	addBtn(topBar,'插入Browser对话框','D','application',insertBrowserBox);
	addBtn(topBar,'生成默认模板','G','application_view_tile',createDefaultTemplate);
	window.onresize=onResizeEditor;
	SqlEditor.init("sqlobjectName");

});



function getFields(obj){
	var a=obj.options[obj.selectedIndex];
	FormfieldService.getAllFieldByFormIdExist(a.value,function(data){
		DWRUtil.removeAllOptions('formFields');
		DWRUtil.addOptions('formFields',data,function(item){return item.fieldname;}, function(item){return item.labelname+"--"+item.fieldname;});
	});
}

function copyVarName(){
	var objSel=$("formList");
	var opt=objSel.options[objSel.selectedIndex];
	var sText=opt.getAttribute("_varname");
	window.clipboardData.setData("Text",sText);
}

function copyFieldName(){
	var objSel=$("formFields");
	var opt=objSel.options[objSel.selectedIndex];
	$('data1').focus();
	document.selection.createRange().text='$'+'{'+opt.value.toLowerCase()+'}';
}
var objRow=1;
<c:if test="${not empty sqlCounts}">
objRow=<c:out value="${sqlCounts}"/>;
</c:if>

function addObjectRow(spanId,isDel){
	if(typeof(isDel)=='boolean' && isDel){
		Element.remove($(spanId));
		return;
	}

	var s='ObjectName'+objRow+':<input name="objectName'+objRow+'">&nbsp;&nbsp;SQL:<input onfocus="SqlEditor.Show(event)" id="sqlobjectName'+objRow+'" name="sqlobjectName'+objRow+'" size="50"><input type="button" value="-" onclick="addObjectRow(\''+spanId+objRow+'\',true);"><br/>';
	var objSpan=document.createElement("span");
	objSpan.id=spanId+objRow;
	objSpan.innerHTML=s;
	$(spanId).appendChild(objSpan);
	objRow+=1;
}

function onUpdate(id,editAction){
	if(typeof(editAction)=='undefined'){
		$('viewerId').value=id;
		$('action').value='update';
		$('form2').submit();
	}else{
		$('editId').value=id;
		$('editAction').value='editActionUpdate';
		
		$('editForm').submit();
		
	}
}

function onDelete(id){
if(confirm('确认删除该模板吗(Y/N)?')){
	$('viewerId').value=id;
	$('action').value='delete';
	$('form2').submit();
}//end if.
}

function insertSelectItem(){
	$('data1').focus();
	var url='<%=request.getContextPath()%>/base/selectitem/selectitemtypebrowser.jsp';
	var itemId=getBrowserValue(url);
	if(itemId!=null){
		var fieldName=prompt('请输入Input字段名称:','soft');
		var s="#SelectItem('"+itemId[0].trim()+"','"+fieldName+"','')\n";
		document.selection.createRange().text=s;
	}else alert('SelectItem.id is null!');
}

function insertBrowserBox(){
	$('data1').focus();
	
	var url='<%=request.getContextPath()%>/base/refobj/refobjbrowser.jsp';
	var itemId=getBrowserValue(url);
	if(itemId!=null){
		var fieldName=prompt('请输入Input字段名称:','soft');
		var s="#BrowserBox('"+itemId[0]+"','"+fieldName+"','','')\n";
		document.selection.createRange().text=s;
	}else alert('refobj.id is null!');
}

function fullScreen(btn){
	var oText=$('textContainer');
	var editor=$('data1');
	if(!btn.isFull){
		btn.isFull=true;
		btn.setText("退出全屏(<u>F</u>)");
		btn.setIconClass('btnNotFull');
		oText.style.position='absolute';
		var top=(topBar==null)?0:topBar.getSize().height;
		var w=600,h=500;
		w=document.documentElement.clientWidth;//Ext.getBody().getWidth();
		h=document.documentElement.clientHeight;//Ext.getBody().getHeight();
		h=parseInt(h)-top-10;
		w=parseInt(w)-8;		
		editor.style.width='600px';
		editor.style.height='500px';
		oText.style.backgroundColor="#FFFFFF";
		oText.style.left='1px';
		oText.style.top=top+'px';
		document.body.scroll="no";
	}else{
		btn.isFull=false;
		btn.setText("全屏编辑(<u>F</u>)");
		btn.setIconClass('btnFull');
		editor.style.width='600px';
		editor.style.height='300px';
		oText.style.backgroundColor="transparent";
		oText.style.position="static";
		document.body.scroll="yes";
	}
}

function onResizeEditor(e){
	var btn=null;
	topBar.items.each(function(item){
		if(item.id=='F'){btn=item;return false;}
	});
	if(btn==null)return;
	//var a=Ext.getDom('btnFull');
	if(btn.isFull/*a && a.getAttribute("isFull")=="true"*/){
		var editor=$('data1');
		var top=(topBar==null)?0:topBar.getSize().height;
		var w=600,h=500;
		w=document.documentElement.clientWidth;//Ext.getBody().getWidth();
		h=document.documentElement.clientHeight;//Ext.getBody().getHeight();
		h=parseInt(h)-top-10;
		w=parseInt(w)-8;
		editor.style.width=w+'px';
		editor.style.height=h+'px';
	}
}

function toEdit(obj){
	/*
	FCKEditorExt.initEditor('data1',false);
	FCKEditorExt.complete=function(oEditor){
		oEditor.SwitchEditMode();
	}*/
	var fck=new FCKeditor('data1');
	fck.ReplaceTextarea();
	obj.disabled=true;
}
function FCKeditor_OnComplete(editorInstance)
{
	editorInstance.SwitchEditMode();
}

function showHelp(obj){
	var id='helpDiv';
	if(Element.visible(id)){
		Element.hide(id);
		obj.className="helpCollapse";
	}else{
		Element.show(id);
		obj.className="helpExpand";
	}//end if.
}
var win=null;
function createDefaultTemplate(){//弹出生成默认模板的对话框
	// create the window on the first click and reuse on subsequent clicks
	var _callback=function(win){
		var param={
			formId:win.$F('formId'),
			isEdit:win.$('isEdit').checked?'true':'false',
			tableWidth:win.$F('tableWidth'),
			tableColumn:win.$F('tableColumn'),
			oName:win.$F('oName'),
			namePrefix:win.$F('namePrefix')
		};
		//alert('p:'+Ext.encode(param));
		var ofg={
		url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction?action=defaultTemplate',
		method:'post',
		success:function(resp,opt){
			var s=resp.responseText;
			var  r  =  $('data1').createTextRange();  
			r.moveStart('character',  $('data1').value.length);
			r.collapse();
			r.select();
			$('data1').focus();
			document.selection.createRange().text='\n\n'+s;
		},
		failure:function(resp,opt){
			alert('提交数据失败:\n  '+resp.responseText);
		},
		//headers:{ 'my-header': 'foo'}
		params:param};
		Ext.Ajax.request(ofg);
	};
	var win=top.ExtWidnow.open('<%=request.getContextPath()%>/base/previewTemplate.jsp?'+(new Date().toString()),_callback);
}

</script>
<style>
ul li ol{margin-left:10px;}
#data1{font-family:宋体;font-size:14px;}
.helpContainer{padding:2px;font-size:9pt;margin:10px;border:1px solid #3300FF;}
.helpContainer ul{list-style-type:circle;margin-bottom:5px;margin-left:15px;}
.helpContainer li{line-height:20px;margin-left:20px;}
.helpContainer li.title{list-style-type:none;margin-left:5px;font-weight:bold;}
.paramsexplain{margin-left: 132px;}

.helpExpand{background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/layout/ns-expand.gif) no-repeat;}
.helpCollapse{background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/layout/ns-collapse.gif) no-repeat;}
.x-window-footer table,.x-toolbar table{width:auto;}
.btnFull{background-image:url(<%=request.getContextPath()%>/images/application/silk/arrow_out.gif) !important};
.btnNotFull{background-image:url(<%=request.getContextPath()%>/images/application/silk/arrow_in.gif) !important};
</style>
</head>

<body>
<div id="pagemenubar"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction" method="post" name="form2" id="form2">
<input type="hidden" name="action" id="action" value="update" />
<input type="hidden" name="id" id="viewerId" value="" />
</form>
<%

Page pageObject = this.forminfoService.getPagedByQuery("from Forminfo order by id desc",1,100);
List list = (List) pageObject.getResult();
Forminfo forminfo=(Forminfo)list.get(0);

forminfo.setObjtablename(this.filterObjectName(forminfo.getObjtablename()));
request.setAttribute("formInfo",forminfo);

List list1=formfieldService.getAllFieldByFormId(forminfo.getId());
request.setAttribute("formFields",list1);

%>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction" method="post" name="form1">
<input type="hidden" name="id" value='<c:out value="${viewerObject.id}"/>' />
<input type="hidden" name="editId" value='<c:out value="${viewerObject.editId}"/>' />
<input type="hidden" name="action" value="save" />
<table align="center" width="96%" border="0">
<tr><td width="72%" valign="top">
标题:<input name="title" value='<c:out value="${viewerObject.title}"/>' size="80" /><br/>
<div id="textContainer">
<div>
<!-- 
<input type="button" id="btnFull" value="全屏编辑" isFull="false" onClick="fullScreen(this)"/>
<input type="button" value="FCKEditor" onClick="toEdit(this)"/>&nbsp;&nbsp;
<input type="button" value="插入SelectItem" onClick="insertSelectItem()" />&nbsp;&nbsp;
<input type="button" value="插入BrowserBox" onClick="insertBrowserBox()" />
<input type="button" value="生成默认模板" onclick="createDefaultTemplate()"/>
-->
</div>
<textarea name="templateText" id="data1" style="width:600px;height:330px;"><c:out value="${viewerObject.templateText}"/></textarea>
</div>
</td>
<td width="28%" valign="top">
<strong>表单：</strong><br/><select title="Tip:单击复制变量名称，双击获取字段列表" id="formList" name="formList"
 size="10" ondblclick="getFields(this);"  onclick="copyVarName();">
<%
for(int i=0;i<list.size();i++)
{
	forminfo=(Forminfo)list.get(i);
	out.print("<option value=\""+forminfo.getId()+"\" ");
	String tbName=this.filterObjectName(forminfo.getObjtablename());
	out.print(" _varname=\"${"+tbName+"Object}   ${"+tbName+"List}\" ");
	out.print(" title=\""+forminfo.getObjname()+"["+tbName+"Object-----"+tbName+"List]\"");
	//if(formId.equalsIgnoreCase(forminfo.getId())) out.print(" selected=\"selected\" ");
	out.print(">"+forminfo.getObjname());
	out.println("</option>");
}
%></select><br/>
<strong>字段：</strong><br/>
<select name="formFields" id="formFields" title="Tip:单击复制字段名称" size="10" onclick="copyFieldName(this);">
<c:forEach var="field" items="${formFields}"><option value='<c:out value="${field.fieldname}"/>' title='<c:out value="${field.labelname}--${field.fieldname}"/>'>
<c:out value="${field.labelname}"/></option></c:forEach>
</select><br/>
<hr/>
<c:if test="${not empty viewerObject.editId}">
<a href="javascript:;" onClick="onUrl('<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction?editId=<c:out value="${viewerObject.editId}"/>&action=editActionUpdate','编辑Action:','editActionTab')">编辑Action</a>
</c:if>
</td>
</tr>
<tr><td height="43" colspan="2" valign="top">
<c:if test="${empty sqlList}">
ObjectName:<input name="objectName0">&nbsp;&nbsp;SQL:<input id="sqlobjectName0" name="sqlobjectName0" size="50"><input type="button" value="+" onClick="addObjectRow('cccSpan');"><br/>
</c:if>
<c:forEach var="osql" items="${sqlList}" varStatus="status">
<span id='cccSpan<c:out value="${status.index}"/>'>ObjectName:<input name='objectName<c:out value="${status.index}"/>' value='<c:out value="${osql.key}"/>'>&nbsp;&nbsp;SQL:<input id="sqlobjectName<c:out value="${status.index}"/>" name="sqlobjectName<c:out value="${status.index}"/>" size="50" value='<c:out value="${osql.value}"/>'>
<c:if test="${status.index==0}"><input type="button" value="+" onClick="addObjectRow('cccSpan');"/></c:if>
<c:if test="${status.index>0}"><input type="button" value="-" onClick="addObjectRow('cccSpan<c:out value="${status.index}"/>',true);"/></c:if>
<br/></span>
</c:forEach>
<span id="cccSpan">
</span><br>
</td>
</tr>
<c:if test="${viewerObject.id=='402880352774807901277495bc07003b'}">
<tr>
<td colspan="2" height="25">
	邮件内容模版参数说明：流程创建者：${flowcreator}，流程名称：${requestname}，节点操作者：${humresname}</br>
	<span class="paramsexplain">节点操作者部门：${department}，上一节点操作者：${upnodeoperator}，邮件中直接查看流程路径：${url}</span>
</td>
</tr>
</c:if>
<tr><td colspan="2">

<a href="#helpAnchor" onclick="showHelp(this);" class="helpCollapse"><b>帮助说明：</b></a>
<div id="helpDiv" style="display:none">
<a name="helpAnchor"></a>
更多Vcelocity语法见：<a href="http://velocity.apache.org/engine/devel/vtl-reference-guide.html" target="_blank">
VTL-reference-guide</a>

<div class="helpContainer">
<ul>
<li class="title">说明：</li>
<li>ObjectName的键值用于#SqlValue()或$GlobalObject.getSQLValue()调用时必须以<span style="color:red;">SQL**</span>为前缀，否则模板解析时不运行该SQL语句</li>
<li>模板的参数和Request请求的参数使用方法：模板中用变量<span style="color:red;">${Params.varName}</span>，SQL中直接名称引用<span style="color:red;">${varName}</span>.</li>

</ul>
</div>

<div class="helpContainer">
<ul>
<li class="title">模板默认变量：</li>
<li>${FormAction} － 用于编辑模板时Form的Action属性（编辑模板只有添加EditAction后有效），如：&lt;form action=&quot;${FormAction}&quot; ... </li>
<li>${Params.xx} －表示页面传递的参数，如：${Params.abc} 相当于Java语句request.getParameter(&quot;abc&quot;)</li>
<li>${viewId} － 当前模板ID号</li>
<li>${currentuser} － 当前登录用户ID</li>
<li>${currentdate} － 模板运行的当前日期</li>
<li>${currenttime} － 当前时间</li>
<li class="title"></li>
<li class="title">模板自定义函数：</li>
<li>#ViewInclude($id,$args) －嵌套显示另一模板</li>
<li>#SelectItem($id,$name,$selected) － 表单下拉选择框字段的编辑样式</li>
<li>#BrowserBox($id,$name,$selected,$fnName) － 表单Browser框字段的编辑样式</li>
<li>#AttachList($name,$val,$isEdit) －表单附件字段类型的编辑样式和显示样式</li>
<li>#SqlValue($objName,$whereMap) － 在模板内执行指定对象的Sql语句,$objName须以SQL**为前缀，$whereMap为JSONObject格式或一个字符串</li>
<li style="color:gray;">#SetVariable($varName,$objName,$whereMap) － (现无效)同将#SqlValue($objName,$where)的查询结果置于$varName的变量中</li>
<li>#set($varName = $GlobalObject.getSQLValue($viewId,$objName,$whereMap)) － $viewId变量固定写法,$varName为新定义变量名</li>
<li>#set($varName = $SQL.getSQLValue($objName,$dsName) － $dsName为数据源名称</li>
<li>#set($varName = $SQL.getSQLValue($objName,$whereMap,$dsName) － $dsName为数据源名称</li>
<li>$GlobalObject.exportFile($Params.type)-判断是否导出文件操作,需要在添加字段&lt;input type="hidden" name="type" id="type"/&gt;</li>
</ul>
</div>

<div class="helpContainer">
<ul>
<li class="title">客户端JS函数：</li>
<li>loadView(viewId,containerId,_params[optional],_callback[optional]) － JS动态加载模板</li>
<li>getSQLValue(objName, sqlWhere) as {String,Array,Array[Object]} － 获取服务器数据，根据指定Sql语句加条件参数,objName顺以SQL**为前缀</li>
<li>browserBox(bid,inputname,isneed,_callback) － 调用Browser框的JS函数</li>
<li>getSubSelect(this,chid,allowEmpty[optional]) － SelectItem联动时绑定在触发&lt;select的onchange事件中,chid表示联动的子项Id。</li>
</ul>
</div>

</div>
</td></tr>
</table>

</form>

</body>
</html>

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
	tableName=tableName.replaceAll("_","");
	tableName=tableName.toLowerCase();
	//tableName+="Object";
	return tableName;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" src="/js/prototype.js"></script>
<!-- 
<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
 -->
    <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
<script type="text/javascript" language="javascript" src="/fckeditor2.6/fckeditor.js"></script>
<script language="javascript" src="/js/weaverUtil.js"></script>
<script type="text/javascript" src="/js/main.js"></script>
<title>模板编辑</title>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>

<script type="text/javascript">
var iconBase = '/images';
var fckBasePath= '/fck/';
var contextPath='';
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/FormfieldService.js']);
WeaverUtil.isDebug=false;

Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

WeaverUtil.load(function(){
	var topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'新增','N','add',onToolbar);
	addBtn(topBar,'编辑','E','application_form_edit',onToolbar);
	addBtn(topBar,'删除','D','delete',onToolbar);
	addBtn(topBar,'复制','C','page_copy',onToolbar);
	addBtn(topBar,'预览','P','application_view_detail',onToolbar);
	
});

function getSelectedId(){
	var rec=sm.getSelected();
	if(rec==null){
		alert('请选择一行操作！');
		return null;
	}
	return rec.get('id');
}

function onToolbar(b){
	var id=null;
	if(b.id!='N'){
		id=getSelectedId();
		if(id==null)return;
	}
	var url=contextPath+'/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction';
	var url2=contextPath+'/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction';
	switch(b.id){
	case 'N':
		location.replace(url+'?action=update');
	break;
	case 'E':
		location.replace(url+'?action=update&id='+id);
	break;
	case 'D':
		onDelete(id);
	break;
	case 'C':
		location.replace(url+'?action=update&amp;copy=true&amp;id='+id);
	break;	
	case 'P':
		onUrl(url2+"?id="+id,"模板预览","templatePreview");
	break;
	default:
		//...
	}//end switch.
}

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
	document.selection.createRange().text='\\'+'${'+opt.value.toLowerCase()+'}';
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

	var s='ObjectName'+objRow+':<input name="objectName'+objRow+'">&nbsp;&nbsp;SQL:<input name="sqlobjectName'+objRow+'" size="50"><input type="button" value="-" onclick="addObjectRow(\''+spanId+objRow+'\',true);"><br/>';
	var objSpan=document.createElement("span");
	objSpan.id=spanId+objRow;
	objSpan.innerHTML=s;
	$(spanId).appendChild(objSpan);
	objRow+=1;
}

//新建动作脚本页面
function onNewAction(id){
	$('editId').value='';
	$('viewerId').value=id;
	$('action').value='editActionUpdate';		
	$('form2').submit();
}

function onUpdate(id,editAction){
	if(typeof(editAction)=='undefined'){
		$('viewerId').value=id;
		$('action').value='update';
		
	}else{
		$('editId').value=id;
		$('action').value='editActionUpdate';
	}
	
	$('form2').submit();
}

function onDelete(id){
if(confirm('确认删除该模板吗(Y/N)?')){
	$('viewerId').value=id;
	$('action').value='delete';
	$('form2').submit();
}//end if.
}
function getBrowserValue(url){
	var ret=null;
	var id = openDialog("/base/popupmain.jsp?url="+encodeURIComponent(url));
	if(typeof(id)!='undefined'){
		if(Object.prototype.toString.apply(id) === '[object Array]'&&id[0]!="0"){
			ret = id[0];
		}
	};
	return ret;
}
function insertSelectItem(){
	$('data1').focus();
	var url='/base/selectitem/selectitemtypebrowser.jsp';
	var itemId=getBrowserValue(url);
	if(itemId!=null){
		var fieldName=prompt('请输入Input字段名称:','soft');
		var s="#SelectItem('"+itemId+"','"+fieldName+"','')\n";
		document.selection.createRange().text=s;
	}else alert('SelectItem.id is null!');
}

function insertBrowserBox(){
	$('data1').focus();
	
	var url='/base/refobj/refobjbrowser.jsp';
	var itemId=getBrowserValue(url);
	if(itemId!=null){
		var fieldName=prompt('请输入Input字段名称:','soft');
		var s="#BrowserBox('"+itemId+"','"+fieldName+"','')\n";
		document.selection.createRange().text=s;
	}else alert('refobj.id is null!');
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
</script>
<style>
ul li ol{margin-left:10px;}
#data1{font-family:Courier New;font-size:14px;}
</style>
</head>

<body>
<div id="pagemenubar"></div>
<form action="/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction" method="post" name="form2" id="form2">
<input type="hidden" name="action" id="action" value="update" />
<input type="hidden" name="id" id="viewerId" value="" />
<input type="hidden" name="editId" id="editId" value="" />
</form>

<script>
function renderTitle(v,p,r){
	var s="<a href='javascript:;' onclick='onUrl(\"/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?id="+r.data.id+"\",\"模板预览\",\"templatePreview\")'";
	s+=" title='点击预览模板"+r.data.id+"'>"+v+"</a>";
	return s;
}

function renderEditAction(v,p,r){
	var s=null;

	if(Ext.isEmpty(v))
		s='<a href="javascript:onNewAction(\''+r.data.id+'\',1)">New Action</a>';
	else
		s='<a href="javascript:onUpdate(\''+v+'\',1)">编辑Action</a>';
	return s;
}

// 标题 数据表单 树形 级联子树条件
var sm = new Ext.grid.CheckboxSelectionModel();
var store;
Ext.onReady(function(){
        store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '/ServiceAction/com.eweaver.base.security.servlet.SysresourceAction?action=json'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['title','editid','id']
           })
       });
    var grid2 = new Ext.grid.GridPanel({
        store:store,
        cm: new Ext.grid.ColumnModel([
            sm,
            {header: "标题",renderer:renderTitle, sortable: true, dataIndex: 'title'},
            {header: "是否数据交互操作",renderer:renderEditAction,sortable: true, dataIndex: 'editAction'}
        ]),
        sm: sm,
        //width:document.documentElement.clientWidth,
        //height:document.documentElement.clientHeight,
        region: 'center',
        autoWidth:true,
        header:false,
        frame:true,
        title:'查看模板列表',
        iconCls:'icon-grid' ,
        viewConfig: {
                                    forceFit:true,
                                    enableRowBody:true,
                                    sortAscText:'升序',
                                    sortDescText:'降序',
                                    columnsText:'列定义'
                                },
         bbar: new Ext.PagingToolbar({
                     store: store,
                     pageSize: 20,
                     displayInfo: true,
                     beforePageText:"第",
                     afterPageText:"页/{0}",
                     firstText:"第一页",
                     prevText:"上页",
                     nextText:"下页",
                     lastText:"最后页",
                     displayMsg: '显示 {0} - {1}条记录 / {2}',
                     emptyMsg: "没有结果返回"
                 })
    });
    var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',height:23},grid2]
        });
    store.load({params:{start:0, limit:20}});
});
</script>
</body>
</html>

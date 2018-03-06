<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
    var iconBase = '<%=request.getContextPath()%>/images';
    var fckBasePath= '<%=request.getContextPath()%>/fck/';
    var contextPath='<%=request.getContextPath()%>';
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>

<title>DynamicReport example </title>
<style type="text/css">
	.x-toolbar table {width:0}
	#pagemenubar table {width:0}
	.x-panel-btns-ct {padding: 0px;}
	.x-panel-btns-ct table {width:0}
</style>

<script language="javascript" type="text/javascript">
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
	var url=contextPath+'/ServiceAction/ServiceAction/com.eweaver.report.servlet.DynamicReportListAction';
	var url2=contextPath+'/ServiceAction/ServiceAction/com.eweaver.report.servlet.DynamicReportAction';
	switch(b.id){
	case 'N':
		//url='http://localhost:8081/example/fckeditor/_samples/html/sample06.html';
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
		onUrl(url2+"?id="+id,"报表预览","reportPreview");
	break;
	default:
		//...
	}//end switch.
}
function onDelete(id){
	if(confirm('确认删除该模板吗(Y/N)?')){
		$('vid').value=id;
		$('action').value='delete';
		$('form2').submit();
	}//end if.
}
</script>
</head>

<body>
<form id="form2" name="form2" action="<%=request.getContextPath()%>/ServiceAction/ServiceAction/com.eweaver.report.servlet.DynamicReportListAction">
<input type="hidden" name="action" value="delete"/>
<input type="hidden" name="id" id="vid" value=""/>
</form>

<div id="pagemenubar"> </div>
<script language="javascript" type="text/javascript">

// 标题 数据表单 树形 级联子树条件
var sm = new Ext.grid.CheckboxSelectionModel();
var store;
var topBar=null;

function renderTitle(v,p,r){
	var s="<a href='javascript:;' onclick='onUrl(\"<%=request.getContextPath()%>/ServiceAction/com.eweaver.report.servlet.DynamicReportAction?id="+r.data.id+"\",\"报表预览\",\"reportPreview\")'";
	s+=" title='点击预览报表："+r.data.id+"'>"+v+"</a>";
	return s;
}

Ext.onReady(function(){

	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'新增','N','add',onToolbar);
	addBtn(topBar,'编辑','E','application_form_edit',onToolbar);
	addBtn(topBar,'删除','D','delete',onToolbar);
	addBtn(topBar,'复制','C','page_copy',onToolbar);
	addBtn(topBar,'预览','P','application_view_detail',onToolbar);

        store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.report.servlet.DynamicReportListAction?action=json'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['title','id']
           })
       });
    var grid2 = new Ext.grid.GridPanel({
        store:store,
        cm: new Ext.grid.ColumnModel([
            sm,
            {header: "标题",renderer:renderTitle, sortable: true, dataIndex: 'title'}
            //{header: "是否数据交互操作",renderer:renderEditAction,sortable: true, dataIndex: 'editAction'}
        ]),
        sm: sm,
        //width:document.documentElement.clientWidth,
        //height:document.documentElement.clientHeight,
        region: 'center',
        autoWidth:true,
        header:false,
        frame:true,
        title:'查看报表列表',
        tbar:topBar,
        iconCls:'icon-grid' ,
        viewConfig: {
          forceFit:true,
          enableRowBody:true,
          sortAscText:'升序',
          sortDescText:'降序',
          columnsText:'列定义'},
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
		items: [{region:'north'},grid2]
	});
    store.load({params:{start:0, limit:20}});
});
</script>
</body>
</html>

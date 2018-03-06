<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
<style>
<!--
.x-window-footer table,.x-toolbar table{width:auto;}
-->
</style>
<script type="text/javascript">
var url="<%=request.getRequestURI()%>";
var Page={
	onNew:function(){
		onUrl(url+'?action=edit','新建门户页面','newHomePages');
	},
	onDelete:function(){
	
	},
getSelectedId:function(){
	var rec=sm.getSelected();
	if(rec==null){
		alert('请选择一行操作！');
		return null;
	}
	return rec.get('id');
},
	onEdit:function(id1,_title){
		var id=null;
		if(typeof(id1)!='string'){
			id=Page.getSelectedId();
			_title=sm.getSelected().get('title');
		}else id=id1;
		if(!Ext.isEmpty(id)) onUrl(url+'?action=edit&id='+id+'&_t='+new Date().toString(),'编辑页面('+_title+')',Ext.id(null,'editHomePages'));
	},
	onPreview:function(){
		var id=Page.getSelectedId();
		if(!Ext.isEmpty(id)) window.open('/index.jsp?id='+id);
	}
};

function renderTitle(v,p,r){
	return "<a href=\"javascript:Page.onEdit('"+r.data.id+"','"+r.data.title+"')\" title='"+v+"'>"+v+"</a>";
}
var topBar=null;
function initToolbar(){
	topBar = new Ext.Toolbar({region:'north'});
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'新增','N','add',Page.onNew);
	addBtn(topBar,'编辑','E','application_form_edit',Page.onEdit);
	addBtn(topBar,'删除','D','delete',Page.onDelete);
	addBtn(topBar,'预览','C','application_view_detail',Page.onPreview);
}

var store;
var sm = new Ext.grid.CheckboxSelectionModel();
Ext.onReady(function(){
    initToolbar();
      store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.homepage.servlet.PagesListAction?action=json'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['id','title','isHomepage','type','filename']
           })
       });
    var grid2 = new Ext.grid.GridPanel({
        store: store,
        renderTo:'gridlist',
        cm: new Ext.grid.ColumnModel([
            sm,
            {header: "标题", width: 380, sortable: true, dataIndex: 'title',renderer:renderTitle},
            {header: "是否首页", width: 100, sortable: true,dataIndex: 'isHomepage'},
            {header: "类别", width: 100, sortable: true, dataIndex: 'type'},
            {header: "模板名称", width: 100, sortable: true, dataIndex: 'filename'}
        ]),
        sm: sm,
        region: 'center',
        iconCls:'icon-grid',
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
            items: [topBar,grid2]
        });
    store.load({params:{start:0, limit:20}});

});

</script>
</head>

<body>
<div id="pagemenubar" style="z-index:100;"></div>
<div id="gridlist"></div>
</body>
</html>

<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
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
  <%
   String rootid="r00t";
String roottext="系统模块";
     String moduleid= StringHelper.null2String(request.getParameter("moduleid"));
  %>
<title>Tree example </title>
<style type="text/css">
 v\:* { behavior: url(#default#vml) }
.x-window-footer table,.x-toolbar table{width:auto;}

</style>

<script language="javascript" type="text/javascript">
    var dlgtree;
    var nodeid;
    var moduleTree
    var selected = new Array();
var isUpdate=false;
//<c:if test="${viewerInfo!=NULL}">
	isUpdate=true;
//</c:if>

var topBar=null;
function initToolbar(){
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'新增','N','add',Tree.onNew);
	//addBtn(topBar,'编辑','E','application_form_edit',Tree.onEdit);
	addBtn(topBar,'删除','D','delete',Tree.onDelete);
	addBtn(topBar,'复制','C','page_copy',Tree.onCopyTree);
	//addBtn(topBar,'预览','P','application_view_detail',Tree.onPreview);
	addBtn(topBar,'复制链接地址','U','world_link',Tree.onCopyUrl);
   addBtn(topBar,'移动','X','cut',function(){onMove()});

}


var Tree={
url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction',
url2:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction',
onNew:function(b){
	//location.replace(Tree.url+"?action=update");
	onUrl(Tree.url+"?action=update&moduleid=<%=moduleid%>","新建树形","treeCreate");
},
getSelectedId:function(){
	var rec=sm.getSelected();
	if(rec==null){
		alert('请选择一行操作！');
		return null;
	}
	return rec.get('id');
},
onEdit:function(name){
	var id=Tree.getSelectedId();
	if(id!=null){
		//location.replace(Tree.url+"?action=update&id="+id);
		onUrl(Tree.url+"?action=update&id="+id,"编辑("+name+")","edit"+id);
	}
},
onEditSubTree:function(t){
	if(t!=null){
		var ar0=t.split(":");
		onUrl(Tree.url+"?action=update&id="+ar0[0],"编辑("+ar0[1]+")","edit"+ar0[0]);
	}
},
onDelete:function(b){
	var id=Tree.getSelectedId();
	if(id!=null){
		if(confirm("确认删除该记录吗(Y/N)?")){
			location.replace(Tree.url+"?action=delete&id="+id);
		}
	}//end if.
},
onCopyTree:function(b){
	var id=Tree.getSelectedId();
	if(id!=null){
		//location.replace(Tree.url+"?action=update&copytree=true&id="+id);
		onUrl(Tree.url+"?action=update&copytree=true&id="+id,"新建树形","treeCreate");
	}
},
onPreview:function(b){
	var id=null;
	var name=null;
	if(typeof(b)!='string'){
		id=Tree.getSelectedId();
		if(id==null) return;
	}else{
		id=b.substring(0,b.indexOf(','));
		name=b.substring(b.indexOf(',')+1,b.length);
	}
	onUrl(Tree.url2+"?viewerId="+id+"&rootId=&level=2","预览("+name+")","treePreview"+id);
},
onCopyUrl:function(b){
	var id=Tree.getSelectedId();
	if(id==null)return;
	var sText=Tree.url2+"?id="+id;
	window.clipboardData.setData("Text",sText);
	alert('URL已复制到剪贴板！');
}

};

function onCopy(id){
	var sText="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?viewerId="+id+"&rootId=&level=";
	window.clipboardData.setData("Text",sText);
	alert('URL已复制到剪贴板！');
}

function onCopyBrowser(id){
	var sText="<%=request.getContextPath()%>/base/refobj/treeviewerBrowser.jsp?id="+id+"&mutil=false&sync=false";
	window.clipboardData.setData("Text",sText);
	alert('URL已复制到剪贴板！');
}

</script>
<script>
function renderSubTree(t){
	var ret="";
	if(!Ext.isEmpty(t)){
		var ar0=t.split(":");
		ret='是<a href="javascript:Tree.onEditSubTree(\''+t+'\')" title="'+ar0[1]+'">编辑子树</a>';
	}
	return ret;
}
var store;
var sm = new Ext.grid.CheckboxSelectionModel();
Ext.onReady(function(){
    initToolbar();
      store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction?action=treejson&moduleid=<%=moduleid%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['id','title','preView','dataForm','treeType','viewType','cascadeTree','modulename']
           })
       });
    var grid2 = new Ext.grid.GridPanel({
        store: store,
        cm: new Ext.grid.ColumnModel([
            sm,
            {header: "标题", width: 380, sortable: true, dataIndex: 'title'},
			{header: "预览", width: 80, sortable: true,dataIndex: 'preView'},
            {header: "数据表单", width: 100, sortable: true,dataIndex: 'dataForm'},
            {header: "树形类别", width: 100, sortable: true, dataIndex: 'treeType'},
            {header: "树显示类型", width: 100, sortable: true, dataIndex: 'viewType'},
            {header: "有级联子树", width: 100,renderer:renderSubTree,sortable: true, dataIndex: 'cascadeTree'},
             {header: "模块名称", width: 100,sortable: true, dataIndex: 'modulename'}

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
      sm.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                               return;
                           }
                       }
              selected.push(reqid)
          }
                  );
          sm.on('rowdeselect',function(selMdl,rowIndex,rec){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                              selected.remove(reqid)
                               return;
                           }
                       }

          }
                  );
      moduleTree = new Ext.tree.TreePanel({
             checkModel: 'single',
            animate: false,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            region:'center',
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottext%>',
                id:'<%=rootid%>',
                iconCls:'pkg',
                expanded:true,
                hrefTarget:'moduleframe',
                href:'/base/module/modulemodify.jsp',
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig&isonlytree=1",
            preloadChildren:false,
             baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
        }
                )
    });
    moduleTree.on('checkchange',function(n,c){
     nodeid=n.id ;
    })
       dlgtree = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:400,
           height:400,
           buttons: [{
               text: '确定',
               handler  : function() {
                   Ext.Ajax.request({
                                           url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?action=move',
                                                params:{ids:selected.toString(),nodeid:nodeid},
                                               success: function() {
                                                   this.dlgtree.hide();
                                                   this.location.href='<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction';
                                               }
                                           });



               }

           },{text: '取消',
               handler  : function() {
                   dlgtree.hide();
               }
           }],
           items:[moduleTree]
       });
        
       dlgtree.render(Ext.getBody());
      var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,split:true},grid2]
        });
    store.load({params:{start:0, limit:20}});

});

    function onMove(){
        if (selected.length == 0) {
           Ext.Msg.buttonText={ok:'确定'};
            Ext.MessageBox.alert('', '请选择要移动的内容！');
            return;
        }
        dlgtree.show();
    }
</script>
</head>

<body>
<div id="pagemenubar" style="z-index:100;"></div>
<form id="DeleteForm"  name="DeleteForm" method="post" action="#">
<input type="hidden" id="action" name="action" value="delete"/>
<input type="hidden" id="viewerId" name="id" value=""/>
</form>


  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
<!--
是否多选：mutil=true
是否单选：mutil=false
是否同步选择：sync
是否叶子结点才允许选择：leaf
是否在框架Tab页的框架内:iframe=true
不显示Browser框按钮：browser=0
显示右栏框架：browser=1
显示右栏框架和右击菜单：browser=2

 -->
</body>
</html>

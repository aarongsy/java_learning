<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<%
  String rootid="r00t";
String roottext=labelService.getLabelNameByKeyId("402881e70b65f558010b65f9d4d40003");//系统模块
String tagetUrl = "categorymodify.jsp?id=";
String createUrl = "categorycreate.jsp";
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
//List categorylist = categoryService.getSubCategoryList2(null,null,null,null);
 String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
%>

<html>
  <head>
  
  	  <script src='/dwr/interface/DataService.js'></script>
      <script src='/dwr/engine.js'></script>
      <script src='/dwr/util.js'></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <style type="text/css">
       .x-toolbar table {width:0}
      .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript">
  Ext.SSL_SECURE_URL='about:blank';
  var categoryTree;
  var dlg0;
   var dlgtree;
   var modulenodeid;
    var  moduleTree
  var categorynodeid;
  Ext.override(Ext.tree.TreeLoader, {
	createNode : function(attr){
        // apply baseAttrs, nice idea Corey!
        if(this.baseAttrs){
            Ext.applyIf(attr, this.baseAttrs);
        }
        if(this.applyLoader !== false){
            attr.loader = this;
        }
        if(typeof attr.uiProvider == 'string'){
           attr.uiProvider = this.uiProviders[attr.uiProvider] || eval(attr.uiProvider);
        }

        var n = (attr.leaf ?
                        new Ext.tree.TreeNode(attr) :
                        new Ext.tree.AsyncTreeNode(attr));

	if (attr.expanded) {
			n.expanded = true;
		}

        return n;
	}
});
  Ext.onReady(function(){
     categoryTree = new Ext.tree.TreePanel({
            animate:true,
            //title: '&nbsp;',
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            //lines:true,
            region:'west',
            width:200,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=labelService.getLabelNameByKeyId("402881e70b227478010b22783d2f0004")%>',//分类体系
                id:'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }),
        loader:new Ext.tree.TreeLoader({           

            <%if(StringHelper.isEmpty(moduleid)){%>
            dataUrl: "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenExt",

            <%}else{%>
            dataUrl: "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenExt&moduleid=<%=moduleid%>",
            <%}%>
            preloadChildren:false
        }
                ),
        contextMenu: new Ext.menu.Menu({
            items: [{
                id: 'add-node',
                text: '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")%>'//新建
            },{
                id: 'delete-node',
                text: '<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>'//删除
            },{
              id: 'move-node',
                text: '<%=labelService.getLabelNameByKeyId("402883d934c1b7b70134c1b7b8860000")%>'//移动
           }],
            listeners: {
                itemclick: function(item) {
                    switch (item.id) {
                        case 'delete-node':
                            var n = item.parentMenu.contextNode;
                                 if(n.hasChildNodes()){
                                        Ext.Msg.buttonText={ok:'确定'};
                                        Ext.MessageBox.alert('','当前节点有子节点，不可删除');
                                        return;
                             }
                            
                            var flag = false;//判断分类下是否有文档
                            var sql = "SELECT * FROM docbase where categoryids ='"+n.id+"' and isdelete=0";
                            DWREngine.setAsync(false);//设置ＤＷＲ为同步获取数据
                            DataService.getValues(sql,{                                               
          						callback: function(data){   
						              if(data && data.length>0){ 
										flag = true;
						              } 
						        }                 
						     });
                            DWREngine.setAsync(true);//重置ＤＷＲ为异步请求
                            if(flag){//分类下有文档不允许删除
                            	Ext.Msg.buttonText={ok:'确定'};
                                Ext.MessageBox.alert('','对应文档目录下存在文档，不可删除');
                                return;
                            }
                                
                            Ext.Ajax.request({
                               url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=removeNodeExt',
                                success: function() {
                                    if (n.parentNode) {
                                        categoryTree.getSelectionModel().select(n.parentNode);
                                        categoryframe.location='categorymodify.jsp?id='+n.parentNode.id;
                                        n.remove();                                       
                                    }
                                },
                               failure: function(){},
                               params: {node: n.id}
                            });


                            break;
                        case 'add-node':
                                <%if(StringHelper.isEmpty(moduleid)){%>
                            categoryframe.location ='categorymodify.jsp?pid='+item.parentMenu.contextNode.id;
                                <%}else{%>
                                categoryframe.location ='categorymodify.jsp?moduleid=<%=moduleid%>&pid='+item.parentMenu.contextNode.id;
                                <%}%>
                            break;
                    case 'move-node':
                            var n = item.parentMenu.contextNode;
                            onMove();
                           categorynodeid=n.id;
                            /*if (n.parentNode) {
                                categoryTree.getSelectionModel().select(n.parentNode);
                                n.remove();
                            }*/
                            break;
                    }
                }
            }
        }),
        listeners: {
            contextmenu: function(node, e) {
                //          Register the context node with the menu so that a Menu Item's handler function can access
                //          it via its parentMenu property.
                var menu;
                <%if(StringHelper.isEmpty(moduleid)){%>
                node.getOwnerTree().contextMenu.items.item(0).disable();
                <%}%>
                if(node.id=='r00t') {
                  node.getOwnerTree().contextMenu.items.item(2).disable();
                }else{
                	
	              if(node.parentNode.id=='r00t'){
	                  if(node.id=='4028803523cacb540123caff02a50012'){
	                      node.getOwnerTree().contextMenu.items.item(1).disable();
	                  }else{
	                      node.getOwnerTree().contextMenu.items.item(1).enable();
	                  }
	                node.getOwnerTree().contextMenu.items.item(2).enable();
	              }else {
	                node.getOwnerTree().contextMenu.items.item(2).disable();
	              }
	              //不能删除的分类
	              if(node.id=='40288148117d0ddc01117d8c36e00dd4'
	            		  ||node.id=='2c91a0302ab11213012ac0f5daac03ac'
	            		  ||node.id=='4028803529d3bbfb0129d3d18c740003'
	            		  ||node.id=='4028803523cacb540123caff02a50012'){
	            	  node.getOwnerTree().contextMenu.items.item(1).disable();
	              }else{
	            	  node.getOwnerTree().contextMenu.items.item(1).enable();
	              }
                }
                node.select();
                var c;
                 c = node.getOwnerTree().contextMenu;
                c.contextNode = node;
                c.showAt(e.getXY());
            }
        }
    });
    moduleTree = new Ext.tree.TreePanel({
           // animate:true,
            //title: '&nbsp;',
             checkModel: 'single',
            animate: false,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            //lines:true,
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
                href:'<%= request.getContextPath()%>/base/module/modulemodify.jsp',
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig&isonlytree=1",
            preloadChildren:false,
             baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
        }
                )
    });
    moduleTree.on('checkchange',function(n,c){
     modulenodeid=n.id ;
    })
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [categoryTree,
                {
                //title: '分类',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'categoryframe', name:'categoryframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});
  dlgtree = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.4,
           height:viewport.getSize().height * 0.4,
           buttons: [{
               text: '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>',//确定
               handler  : function() {
                   this.disable();
                   Ext.Ajax.request({
                                           url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=move',
                                                params:{categorynodeid:categorynodeid,modulenodeid:modulenodeid},
                                               success: function() {
                                                   Ext.Msg.buttonText = {ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                                                       Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790067")%>', function() {//移动成功！

                                                       });
                                                   this.dlgtree.hide();

                                               }
                                           });
                   this.enable();
               }

           },{text : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%>',//取消
               handler  : function() {
                   dlgtree.hide();
               }
           }],
          items:[moduleTree]
       });
       dlgtree.render(Ext.getBody());
  });
      
  </script>

  <style>

   </style>
  <script type="text/javascript">
      function onMove()
    {
         this.dlgtree.show();
    }
  </script>
  </head> 	
  <body >	
  <script>Ext.BLANK_IMAGE_URL = '<%= request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </body>
</html>

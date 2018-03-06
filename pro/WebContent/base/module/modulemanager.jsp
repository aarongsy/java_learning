<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%

String rootid="r00t";
String roottext="系统模块";


%>

<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/ModuleService.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/util.js'></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>

  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
      .pkg{
          background-image: url(<%=request.getContextPath()%>/images/silk/config.gif) !important;
      }
  </style>
  <script type="text/javascript">
  Ext.SSL_SECURE_URL='about:blank';
  var categoryTree;
  Ext.override(Ext.tree.TreeLoader, {
	createNode : function(attr){
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
     moduleTree = new Ext.tree.TreePanel({
            animate:true,
            //title: '&nbsp;',
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            enableDD:true,
            ddAppendOnly:true,
            ddGroup:'dnd',
            //lines:true,
            region:'west',
            width:200,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottext%>',
                id:'<%=rootid%>',
                iconCls:'pkg',
                expanded:true,
                hrefTarget:'moduleframe',
                href:'<%=request.getContextPath()%>/base/module/modulemodify.jsp',
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig",
            preloadChildren:false
        }
                ),
        contextMenu: new Ext.menu.Menu({
            items: [{
                id: 'add-node',
                text: '新建'
            },{
                id: 'delete-node',
                text: '删除'
            }],
            listeners: {
                itemclick: function(item) {
                    switch (item.id) {
                        case 'delete-node':
                            Ext.Msg.buttonText={yes:'是',no:'否'};
                            Ext.Msg.confirm('', '您确定要删除吗', function(btn, text){
                                if (btn == 'yes') {
                                    var n = item.parentMenu.contextNode;
                                     if(n.hasChildNodes()){
                                        Ext.Msg.buttonText={ok:'确定'};
                                         Ext.MessageBox.alert('','当前节点有子节点，不可删除');
                                         return;
                                     }
                                    Ext.Ajax.request({
                                        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=removeMenu',
                                        success: function() {
                                            if (n.parentNode) {
                                                moduleTree.getSelectionModel().select(n.parentNode);
                                                moduleframe.location = 'modulemodify.jsp?id=' + n.parentNode.id;
                                                n.remove();
                                            }
                                        },
                                        failure: function() {
                                        },
                                        params: {node: n.id}
                                    });
                                }
                            });

                            break;
                        case 'add-node':
                            moduleframe.location ='modulemodify.jsp?pid='+item.parentMenu.contextNode.id+"&isnewmodule=1";
                            break;
                    }
                }
            }
        }),
        listeners: {
            contextmenu: function(node, e) {
                //          Register the context node with the menu so that a Menu Item's handler function can access
                //          it via its parentMenu property.
                if(node.id=='r00t'){
                    node.getOwnerTree().contextMenu.items.item(1).disable();
                }else{
                     node.getOwnerTree().contextMenu.items.item(1).enable(); 
                }

                node.select();
                var c = node.getOwnerTree().contextMenu;
                c.contextNode = node;
                c.showAt(e.getXY());
            }
        }
    });
    moduleTree.on('nodedrop',function(e){
        ModuleService.setPid(e.dropNode.id,e.target.id)
    });
    
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [moduleTree,
                {
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'moduleframe', name:'moduleframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});

  })

  </script>

  <style>

   </style>

  </head>
  <body >
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </body>
</html>

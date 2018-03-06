<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    String rootid = "0";
    String roottext = labelService.getLabelNameByKeyId("402883de35273f910135273f955b002a");
%>

<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/RemotePortal.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
 
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
  <script type="text/javascript">

  var menuname;
var text1;
  var categorytext1;

  var pidvalue;
  Ext.SSL_SECURE_URL='about:blank';
  var portalTree;
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

     portalTree = new Ext.tree.TreePanel({
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
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.portal.servlet.PortalAction?action=getPortalTabs",
            baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
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
            }],
            listeners: {
                itemclick: function(item) {
                    switch (item.id) {
                        case 'delete-node':
                            var n = item.parentMenu.contextNode;
                            Ext.Ajax.request({
                               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.portal.servlet.PortalAction?action=removePortalTab&node='+n.id,
                                success: function() {
                                    if (n.parentNode) {
                                        portalTree.getSelectionModel().select(n.parentNode);
                                        portalframe.location='portalmodify.jsp?id='+n.parentNode.id;
                                        n.remove();
                                    }
                                },
                               failure: function(){}
                            });


                            break;
                        case 'add-node':
                            portalframe.location ='portalmodify.jsp?pid='+item.parentMenu.contextNode.id;
                            break;
                    }
                }
            }
        }),
        listeners: {
            contextmenu: function(node, e) {
                //          Register the context node with the menu so that a Menu Item's handler function can access
                //          it via its parentMenu property.
                if (node.id == 'r00t') {
                    node.getOwnerTree().contextMenu.items.item(1).disable();
                } else {
                    node.getOwnerTree().contextMenu.items.item(1).enable();
                }
                node.select();
                var c = node.getOwnerTree().contextMenu;
                c.contextNode = node;
                c.showAt(e.getXY());
            }
        }
    });
    portalTree.on('checkchange',function(n,c){
        if(c)
        RemotePortal.setIsShow(n.id,1);
        else
        RemotePortal.setIsShow(n.id,0);
    });
    portalTree.on('nodedrop',function(e){
        RemotePortal.setPid(e.dropNode.id,e.target.id)
    });
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [portalTree,
                {
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'portalframe', name:'portalframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});
  });

  </script>

  <style>

   </style>

  </head>
  <body >
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </body>

</html>

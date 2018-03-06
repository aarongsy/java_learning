<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/MenuService.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
  <script type="text/javascript">
  Ext.SSL_SECURE_URL='about:blank';
  var notifyTree;
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
     notifyTree = new Ext.tree.TreePanel({
            animate:true,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            enableDD:true,
            ddAppendOnly:true,
            region:'west',
            width:200,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4003c") %>',//提醒消息
                id:'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=getChildren",
            preloadChildren:false
        }
                )


    });
      notifyTree.on('click ',function(t,e){
          alert('aaa');

      })
        //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [notifyTree,
                {
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'notifyframe', name:'notifyframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                defaultSrc:{url:'<%=request.getContextPath()%>/notify/SysRemindInfoDefault.jsp',discardUrl:true},
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

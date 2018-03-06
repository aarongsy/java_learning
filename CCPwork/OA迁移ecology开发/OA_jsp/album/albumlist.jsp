<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.app.album.service.AlbumService"%>
<%
	AlbumService albumService = (AlbumService)BaseContext.getBean("albumService");
	boolean isAlbumManager = albumService.theCurrentUserIsAlbumManager();
%>
<html>
<head>
<title>album list</title>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/TreeCheckNodeUI.js"></script>
<script type="text/javascript">
	Ext.SSL_SECURE_URL='about:blank';
	
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

	        var n = (attr.leaf ?new Ext.tree.TreeNode(attr) :new Ext.tree.AsyncTreeNode(attr));
	
			if (attr.expanded) {
				n.expanded = true;
			}
	
			return n;
		}
	});
	
	var albumTree;
	Ext.onReady(function(){
		albumTree = new Ext.tree.TreePanel({
            animate:true,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            region:'west',
            width:200,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '相册类别',
                id:'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }),
        	loader:new Ext.tree.TreeLoader({           
            	dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=getAlbums",
            	preloadChildren:false
        	})
			<% if(isAlbumManager){ //是管理员才添加右键菜单%>
        	,contextMenu: new Ext.menu.Menu({
            	items: [{
                	id: 'add-node',
                	text: '新建'
            	},{
            		id: 'edit-node',
                	text: '编辑'
            	},{
              		id: 'delete-node',
                	text: '删除'
				}],
	            listeners: {
	                itemclick: function(item) {
        				var n = item.parentMenu.contextNode;
	                    switch (item.id) {
	                        case 'add-node':
	                        	albumFrame.location ='/app/album/albummodify.jsp?pid='+n.id;
	                            break;
	                        case 'edit-node':
	                        	albumFrame.location ='/app/album/albummodify.jsp?id='+n.id;
	                            break;
	                    	case 'delete-node':
	                    		if(confirm("删除该节点会级联删除该节点所有子节点，以及它们所关联的照片信息，确认执行此操作吗？")){
	                    			Ext.Ajax.request({
		                               url: '/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=deleteAlbum',
		                               params: {id: n.id}, 
		                               success: function(res) {
		                                   if(res.responseText == "success"){
		                                	   if (n.parentNode) {
		                                        	albumTree.getSelectionModel().select(n.parentNode);
		                                       		n.remove();                                       
		                                    	}
		                                   }else{
		                                	   alert("操作失败！\n" + res.responseText);
		                                   }
		                               }
		                            });
	                    		}
	                            break;
	                    }
	                }
	            }
			}),
        	listeners: {
            	contextmenu: function(node, e) {
                	var menu;
                	if(node.id=='r00t') {
                		node.getOwnerTree().contextMenu.items.item(1).disable();
                  		node.getOwnerTree().contextMenu.items.item(2).disable();
                	}else{
                		node.getOwnerTree().contextMenu.items.item(1).enable();
                  		node.getOwnerTree().contextMenu.items.item(2).enable();
                	}
                	node.select();
                	var c;
                 	c = node.getOwnerTree().contextMenu;
					c.contextNode = node;
                	c.showAt(e.getXY());
            	}
        	}
        	<% } %>
    	});
		
		
		var viewport = new Ext.Viewport({
        	layout: 'border',
        	items: [albumTree,
                {
	                region:'center',
	                xtype     :'iframepanel',
	                frameConfig: {
	                    id:'albumFrame', name:'albumFrame', frameborder:0 ,
	                    eventsFollowFrameLinks : false
	                },
	                autoScroll:true
            	}
        	]
		});
	});
</script>
</head>
<body>
	<script>
		Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';
	</script>
</body>
</html>
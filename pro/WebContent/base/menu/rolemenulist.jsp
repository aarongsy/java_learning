<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="com.eweaver.base.security.service.logic.*" %>
<%@ page import="com.eweaver.base.security.model.Sysrole" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%
String type = StringHelper.null2String(request.getParameter("type"));

SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");
String from = (String)request.getAttribute("from");
List results = (List)request.getAttribute("list");
%>

<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/menuorgService.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
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
  var orgTree;
  var nodeid;
   DWREngine.setAsync(false);//设置ＤＷＲ为同步获取数据
   var sql = "select id from selectitem where typeid='402881ea0b8bf8e3010b8bfc850b0009' and isdelete=0";
				DataService.getValues(sql,{                                               
         				 callback: function(data){
         				 	nodeid=data;
         				 }
         		});
   DWREngine.setAsync(true);//设置ＤＷＲ为同步获取数据
  Ext.onReady(function(){
	orgTree = new Ext.tree.TreePanel({
		region:'west',
		width:200,
        split:true,
        animate:true,
        title: '角色单元',
        useArrows :true,
        containerScroll: true,
        autoScroll:true,
        //tbar:[divReftype],
        //lines:true,
        collapsed : false,
        root:new Ext.tree.AsyncTreeNode({
            text: '角色列表',
            expanded:true,
            id: '',
            href:"#",
            allowDrag:false,
            allowDrop:false
        }),
       	loader:new Ext.tree.TreeLoader({
			dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getroletree4rolemenu",
			preloadChildren:false,
			listeners:{"beforeload":function(treeLoader, node) {
				this.baseParams.ojbectId = node.id;
	        }}
       	}),
       	contextMenu: new Ext.menu.Menu({
			items: [{
				id: 'add',
				text: '初始化菜单',
				handler:function(item) {
				    var n = item.parentMenu.contextNode;
				    var callbackfunc=function(){
				        changeOrg(n.id, n.text, true,n);
				    }
				    menuorgService.createMenuByOrgid('Role123_'+n.id,callbackfunc);
				}
	           	},{
				id: 'delete',
				text: '删除菜单',
				handler:function(item) {
				    var n = item.parentMenu.contextNode;
				    var callbackfunc=function(){
				        changeOrg(n.id, n.text, false,n);
				    }
				    menuorgService.delMenuByOrgid('Role123_'+n.id,callbackfunc);
				
				}
			}]
		}),
		listeners: {
			contextmenu: function(node, e) {
				node.select();
				var flag = true;
				for(var i=0;i<nodeid.length;i++){
					if(node.id=="ynode-7"){//禁用掉根节点右键菜单（因为只有在具体角色和角色类型上才有意义）
						flag = false;
						break;
					}else{
						continue;
					}
				}
				if(flag){
					var c = node.getOwnerTree().contextMenu;
					c.contextNode = node;
					if (node.attributes.isDefined) {
					    c.items.item(1).enable();
					    c.items.item(0).disable();
					} else {
					    c.items.item(1).disable();
					    c.items.item(0).enable();
					}
					c.showAt(e.getXY());
				}
             }
        }
	});//end of orgtree
	//start menuTree
	menuTree = new Ext.tree.TreePanel({
	    animate:true,
	    title: '角色菜单',
	    useArrows :true,
	    containerScroll: true,
	    autoScroll:true,
	    //lines:true,
	    region:'center',
	    rootVisible:false,
	    root:new Ext.tree.AsyncTreeNode({
	        text: 'orgmenu',
	        id:'root',
	        expanded:true,
	        allowDrag:false,
	        allowDrop:false
	    }),
		loader:new Ext.tree.TreeLoader({
		    dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getrolemenuconfig",
		    baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
		    preloadChildren:false
		})
    });
    menuTree.on('check',function(n,c){
        if(c)
	        menuorgService.setCheckList([n.id],[n.id],menuTree.getLoader().baseParams.type);
        else
    	    menuorgService.setCheckList([],[n.id],menuTree.getLoader().baseParams.type);
    })
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [orgTree,menuTree]
	});
    orgTree.root.eachChild(function(c){c.remove()}) ;
	orgTree.root.appendChild([
		<%
		 MenuorgService menuorgService = (MenuorgService) BaseContext.getBean("menuorgService");
		 List<String> orgMenus=menuorgService.getUnitid(MenuorgService.TYPE_ROLE);
		List<Selectitem> roleTypeList = selectitemService.getSelectitemList("402881ea0b8bf8e3010b8bfc850b0009", null);//角色类型
		for(int i=0;i<roleTypeList.size();i++){
			Selectitem selectitemRole = roleTypeList.get(i);
			boolean isDefined=orgMenus.contains(selectitemRole.getId());//是否已经创建
			String text = isDefined?"<font color=red>"+selectitemRole.getObjname()+"</font>":selectitemRole.getObjname();
			String href = "javascript:changeOrg('"+selectitemRole.getId()+"','"+selectitemRole.getObjname()+"',"+isDefined+")";
		%>
			new Ext.tree.AsyncTreeNode({
		      text: '<%=text%>',
		      id: '<%=roleTypeList.get(i).getId()%>',
		      isDefined:<%=isDefined%>,
		      expanded:false,
		      leaf:false,
		      href:"<%=href%>",
		      allowDrag:false,
		      allowDrop:false
		      
		  	})
		<%
			if(i!=roleTypeList.size()-1) out.println(",");
		}%>
	]);
  });
  function changeOrg(id,name,isdefined,n){
      if(isdefined){
          var typeid='Role123_'+id;

          menuTree.getLoader().baseParams.roleid = id;
          menuTree.getLoader().baseParams.type = typeid;
          
          if(n){
	          n.attributes.isDefined=true;
    	      n.getUI().getAnchor().href="javascript:changeOrg('"+n.id +"','"+n.text+"',true)";
        	  n.setText('<font color=red>'+name+'</font>');
          }

      }else{
          menuTree.getLoader().baseParams.roleid="";
          menuTree.getLoader().baseParams.type='';
          name=name.replace(/<.*?>/g,'');
          if(n){
          n.attributes.isDefined=false;
          n.getUI().getAnchor().href="javascript:changeOrg('"+n.id+"','"+n.text+"',false)";
          n.setText(name);
          }
      }

      menuTree.root.eachChild(function(c){c.remove()}) ;
      menuTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: name,
                id: 'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }));

      menuTree.root.expand();
   }

	
  </script>

  </head>
  <body >
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </body>
</html>
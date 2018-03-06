<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.portal.service.PortalorgService"%>
<%@page import="com.eweaver.portal.model.Portalorg"%>
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
PortalorgService portalorgService=(PortalorgService)BaseContext.getBean("portalorgService");

String from = (String)request.getAttribute("from");
List results = (List)request.getAttribute("list");
%>

<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/portalorgService.js'></script>
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
  
  Ext.onReady(function(){
	orgTree = new Ext.tree.TreePanel({
		region:'west',
		width:200,
        split:true,
        animate:true,
        title: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0030")%>',//角色单元
        useArrows :true,
        containerScroll: true,
        autoScroll:true,
        //tbar:[divReftype],
        //lines:true,
        collapsed : false,
        root:new Ext.tree.AsyncTreeNode({
            text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0031")%>',//角色列表
            expanded:true,
            id: '',
            href:"#",
            allowDrag:false,
            allowDrop:false
        }),
       	loader:new Ext.tree.TreeLoader({
			dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getroletree4roleportal",
			preloadChildren:false,
			listeners:{"beforeload":function(treeLoader, node) {
				this.baseParams.ojbectId = node.id;
	        }}
       	}),
       	contextMenu: new Ext.menu.Menu({
			items: [{
				id: 'add',
				text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002e")%>',//初始化门户
				handler:function(item) {
				    var n = item.parentMenu.contextNode;
				    var callbackfunc=function(){
				        changeOrg(n.id, n.text, true,n);
				    }
				    portalorgService.createportalorgByOrgid('Role_'+n.id,callbackfunc);
				}
	           	},{
				id: 'delete',
				text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002f")%>',//删除门户
				handler:function(item) {
				    var n = item.parentMenu.contextNode;
				    var callbackfunc=function(){
				        changeOrg(n.id, n.text, false,n);
				    }
				    portalorgService.delportalorguByOrgid('Role_'+n.id,callbackfunc);
				
				}
			}]
		}),
		listeners: {
			contextmenu: function(node, e) {
				node.select();
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
	});//end of orgtree
	//start menuTree
	menuTree = new Ext.tree.TreePanel({
	    animate:true,
	    title: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0032")%>',//角色门户
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
		    dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.portal.servlet.PortalAction?action=getportalorgs",
		    baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
		    preloadChildren:false
		})
    });
    menuTree.on('check',function(n,c){
    	var orgNode=orgTree.getSelectionModel().getSelectedNode();
        if(c)
        portalorgService.setCheckList([n.id],[],"Role_"+orgNode.id);
        else
        portalorgService.setCheckList([],[n.id],"Role_"+orgNode.id);
    })
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [orgTree,menuTree]
	});
    orgTree.root.eachChild(function(c){c.remove()}) ;
    <%
	    List<Selectitem> selectitemlist = selectitemService.getSelectitemList("402881ea0b8bf8e3010b8bfc850b0009",null);//角色类型 
	    List<String> rolePortals=portalorgService.getDefinedObejctId(Portalorg.TYPE_ROLE);
	    StringBuffer treenode = new StringBuffer("[");
	    for (Selectitem selectitem : selectitemlist) {
	    	boolean isDefined=rolePortals.contains(selectitem.getId());//是否已经创建
	    	String text = isDefined?"<font color=red>"+selectitem.getObjname()+"</font>":selectitem.getObjname();
	    	List roleList = sysroleService.getAllSysroleByRoletype(selectitem.getId());
	    	treenode.append("new Ext.tree.AsyncTreeNode({");
	    	treenode.append("text: '"+text+"',");
	    	treenode.append("id: '"+selectitem.getId()+"',");
	    	treenode.append("expanded:false,");
	    	treenode.append("isDefined:"+isDefined+",");
    		treenode.append("href:\"javascript:changeOrg('"+selectitem.getId()+"','"+selectitem.getObjname()+"',"+isDefined+")\",");
	    	if (roleList != null && roleList.size() > 0) {
	    		treenode.append("leaf:false,");
	    	} else {
	    		treenode.append("leaf:true,");
	    	}
	    	treenode.append("allowDrag:false,");
	    	treenode.append("allowDrop:false");
	    	treenode.append("}),");
	    }
	    treenode.deleteCharAt(treenode.lastIndexOf(","));
	    treenode.append("]");
    %>
	orgTree.root.appendChild(<%out.print(treenode.toString());%>);
  });
  function changeOrg(id,name,isdefined,n){
      if(isdefined){

          menuTree.getLoader().baseParams.orgid = id;
          menuTree.getLoader().baseParams.typeid = 3;
          
          if(n){
	          n.attributes.isDefined=true;
    	      n.getUI().getAnchor().href="javascript:changeOrg('"+n.id +"','"+n.text+"',true)";
        	  n.setText('<font color=red>'+name+'</font>');
          }

      }else{
          menuTree.getLoader().baseParams.orgid="";
          menuTree.getLoader().baseParams.typeid='';
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
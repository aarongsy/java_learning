<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.menu.service.MenuorgService" %>
<%@ page import="com.eweaver.portal.service.PortalorgService" %>
<%@ page import="com.eweaver.portal.model.Portalorg" %>
<%@ page import="org.light.portal.core.service.PortalService" %>
<%@ page import="org.light.portal.core.entity.PortalTab" %>
<%
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
PortalorgService portalorgService = (PortalorgService)BaseContext.getBean("portalorgService") ;
PortalService portalService = (PortalService)BaseContext.getBean("portalService") ;
  String reftype = StringHelper.trimToNull(request.getParameter("reftype"));

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
List<Orgunit> ous=orgunitService.find("from Orgunit where isRoot=1");
String rootid="";
String roots="";
JSONArray ja=new JSONArray();
for(Orgunit ou:ous){
    JSONObject jo=new JSONObject();
    jo.put("id",ou.getId());
    jo.put("reftype",ou.getReftype());
    jo.put("name",ou.getObjname());
    if(ou.getReftype().equals(reftype))
        rootid=ou.getId();
    
    boolean isdefined=portalorgService.isdefined(ou.getId());
    jo.put("isdefined",isdefined);
    ja.add(jo);
}
roots=ja.toString();

if(StringHelper.isEmpty(rootid)){
	rootid = "402881e70ad1d990010ad1e5ec930008";
}
Orgunit orgunit = orgunitService.getOrgunit(rootid);
boolean  isOrgMenuDefined=portalorgService.isdefined(rootid);
String orgdefined=  isOrgMenuDefined?"true":"false";
String orgname=orgunit.getObjname();
if(isOrgMenuDefined)
   orgname= "<font color=red>"+orgunit.getObjname()+"</font>";
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
  var orgtb;

  var reftype='<%=reftype%>';
  var rootsArray=<%=roots%>;
  Ext.onReady(function(){
	 orgtb = new Ext.Toolbar();
     orgTree = new Ext.tree.TreePanel({
            region:'west',
            width:200,
            split:true,
            animate:true,
            title: '<%=labelService.getLabelNameByKeyId("402881e30fa73306010fa79e77890883")%>',//组织单元
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            tbar:orgtb,
            collapsed : false,
            rootVisible:false,
            root:new Ext.tree.AsyncTreeNode({
                text: 'org',
                id:'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }),
         loader:new Ext.tree.TreeLoader({
             dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitTreeAction?action=getChildrenExt&isportal=true",
             preloadChildren:false,
             listeners:{"beforeload":function(treeLoader, node) {
                 orgTree.getLoader().baseParams.reftype = reftype;
             }}
         }
                 ),
         contextMenu: new Ext.menu.Menu({
             items: [{
                 id: 'add',
                 text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002e")%>',//初始化门户
                 handler:function(item) {
                     var n = item.parentMenu.contextNode;
                     var callbackfunc=function(){
                         changeOrg(n.id, n.text, true,n);
                         changeRootsArray(n.id,true);
                     }
                     portalorgService.createportalorgByOrgid(n.id,callbackfunc);

                 }
             },{
                 id: 'delete',
                 text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002f")%>',//删除门户
                 handler:function(item) {
                     var n = item.parentMenu.contextNode;
                     var callbackfunc=function(){
                         changeOrg(n.id, n.text, false,n);
                         changeRootsArray(n.id,false);
                     }
                     portalorgService.delportalorguByOrgid(n.id,callbackfunc);

                 }
             }]
         }),
         listeners: {
             contextmenu: function(node, e) {

                     node.select();
                     var c = node.getOwnerTree().contextMenu;
                     c.contextNode = node;
                     var isDefined=(node.text.indexOf('color="color"')>0 || node.text.indexOf('color=red')>0);
                     c.items.item(0).setDisabled(isDefined);
                     c.items.item(1).setDisabled(!isDefined);
                     c.showAt(e.getXY());
             }
         }
        });
        menuTree = new Ext.tree.TreePanel({
            animate:true,
            title: '<%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f191e610030")%>',//组织门户
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
        }
                )
    });
    menuTree.on('check',function(n,c){
    	var orgNode=orgTree.getSelectionModel().getSelectedNode();
        if(c)
        portalorgService.setCheckList([n.id],[],orgNode.id);
        else
        portalorgService.setCheckList([],[n.id],orgNode.id);
    })
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [orgTree,menuTree]
	});
    orgTree.root.appendChild(
    new Ext.tree.AsyncTreeNode({
        text: '<%=orgname%>',
        expanded:true,
        isorgdefined:<%=orgdefined%>,
        id: 'Orgunit_<%=rootid%>',
        href:"javascript:changeOrg('Orgunit_<%=rootid%>','<%=orgunit.getObjname()%>',<%=orgdefined%>)",
        allowDrag:false,
        allowDrop:false
    }));
	orgtb.add(Ext.get('divReftype').dom.innerHTML);
  });
  function changeReftype(rt){
       reftype=rt
       orgTree.root.eachChild(function(c){c.remove()}) ;
       newRootName="";
       newRootId="";
       var newIsdefined=false;
       Ext.each(rootsArray,function(o){
           if(o.reftype==rt){
               newRootId=o.id;
               newRootName=o.name;
               newIsdefined=o.isdefined;
           }
       });
       orgTree.getLoader().baseParams.reftype = reftype;
       orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: newIsdefined==true?'<font color=red>'+newRootName+'</font>':newRootName,
                id: 'Orgunit_'+newRootId,
                expanded:true,
                isorgdefined:newIsdefined,
                href:"javascript:changeOrg('Orgunit_"+newRootId+"','"+newRootName+"',"+newIsdefined+")",
                allowDrag:false,
                allowDrop:false
            }));
       orgTree.root.expand();
   }

function changeRootsArray(orgid,isdefined){
	Ext.each(rootsArray,function(o){
		if(("Orgunit_"+o.id)==orgid){
			o.isdefined=isdefined;
		}
	});
}

var getTypeIdById=function(id){
	var typeid=0;
	var sid='';
	if(id.startsWith('Orgunit_')){
		typeid=0;
		sid=id.substring(8);
	}else if(id.startsWith('Station_')){
		typeid=1;
		sid=id.substring(8);
	}else if(id.startsWith('Person_')){
		typeid=2;
		sid=id.substring(7);	
	}
	return [typeid,sid];
};
  function changeOrg(id,name,isdefined,n){        //isdefined true初始化了 false没有被初始化
	var typeids=getTypeIdById(id);
      if(isdefined){
      		menuTree.getLoader().baseParams.orgid = typeids[1];
			menuTree.getLoader().baseParams.typeid=typeids[0];
			//Station_,Orgunit_,Person_
          if(n){
          n.attributes.isorgdefined=true;
          n.getUI().getAnchor().href="javascript:changeOrg('"+typeids[1]+"','"+n.text+"',true)";
          n.setText('<font color=red>'+name+'</font>');
          }

      }else{
          menuTree.getLoader().baseParams.orgid="";
          menuTree.getLoader().baseParams.typeid=typeids[0];
          name=name.replace(/<.*?>/g,'');
          if(n){
          n.attributes.isorgdefined=false;
          n.getUI().getAnchor().href="javascript:changeOrg('"+typeids[1]+"','"+n.text+"',false)";
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
  <div id="divReftype">
  	<%
        List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016", null);
        if (selectlist.size() > 0) {%>
    	<SELECT onChange="changeReftype(this.value)">
        <%
       	Iterator it = selectlist.iterator();
        while (it.hasNext()) {
            Selectitem selectitem = (Selectitem) it.next();
            String selected = selectitem.getId().equals(reftype) ? "selected" : "";
        %>
        	<OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%></OPTION>
        <% }%>
    </SELECT>
    <% }%>
  </div>
  </body>
</html>

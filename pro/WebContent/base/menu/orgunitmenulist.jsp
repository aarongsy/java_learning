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
<%
String orgunitid=StringHelper.null2String(request.getParameter("orgunitid"));
String suborg = StringHelper.null2String(request.getParameter("suborg"));
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService") ;
String from = (String)request.getAttribute("from");
List results = (List)request.getAttribute("list");
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
    
    boolean isdefined=menuorgService.isOrgDefined(ou.getId());
    jo.put("isdefined",isdefined);
    ja.add(jo);
}
roots=ja.toString();

if(StringHelper.isEmpty(rootid)){
	rootid = "402881e70ad1d990010ad1e5ec930008";
}
Orgunit orgunit = orgunitService.getOrgunit(rootid);
boolean isOrgMenuDefined = menuorgService.isOrgDefined(rootid);
String orgdefined=  isOrgMenuDefined?"true":"false";
String orgname=orgunit.getObjname();
if(isOrgMenuDefined)
   orgname= "<font color=red>"+orgunit.getObjname()+"</font>";
%>

<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/menuorgService.js'></script>
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
            title: '组织单元',
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
             dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitTreeAction?action=getorgtree4orgmenu",
             preloadChildren:false,
             listeners:{"beforeload":function(treeLoader, node) {
                 orgTree.getLoader().baseParams.reftype = reftype;
             }}
         }
                 ),
         contextMenu: new Ext.menu.Menu({
             items: [{
                 id: 'add',
                 text: '初始化菜单',
                 handler:function(item) {

                     var n = item.parentMenu.contextNode;
                     var callbackfunc=function(){
                         changeOrg(n.id, n.text, true,n);
                         changeRootsArray(n.id,true);
                     }
                     menuorgService.createMenuByOrgid(n.id,callbackfunc);

                 }
             },{
                 id: 'delete',
                 text: '删除菜单',
                 handler:function(item) {
                     var n = item.parentMenu.contextNode;
                     var callbackfunc=function(){
                         changeOrg(n.id, n.text, false,n);
                         changeRootsArray(n.id,false);
                     }
                     menuorgService.delMenuByOrgid(n.id,callbackfunc);

                 }
             }]
         }),
         listeners: {
             contextmenu: function(node, e) {
        
                     node.select();
                     var c = node.getOwnerTree().contextMenu;

                     c.contextNode = node;
                     if (node.attributes.isorgdefined) {
                         c.items.item(1).enable();
                         c.items.item(0).disable();
                     } else {
                         c.items.item(1).disable();
                         c.items.item(0).enable();
                     }
                     c.showAt(e.getXY());
             }
         }
        });
        menuTree = new Ext.tree.TreePanel({
            animate:true,
            title: '组织菜单',
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
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getorgmenuconfig",
            baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
            preloadChildren:false
        })
    });
    menuTree.on('check',function(n,c){
    	//alert(n.id+','+c);
		/* DWR调用，暂时注释掉，采用异步请求action的方式替代
        if(c)
	        menuorgService.setCheckList([n.id],[n.id],menuTree.getLoader().baseParams.type);
        else
    	    menuorgService.setCheckList([],[n.id],menuTree.getLoader().baseParams.type);
		*/
		
		var checkIdVal;
    	if(c){
    		checkIdVal = n.id;
    	}else{
    		checkIdVal = "";
    	}
    	Ext.Ajax.request({   
			url: "/ServiceAction/com.eweaver.base.menu.servlet.MenuorgAction?action=doMenuCheck",   
			method : 'post',
			params:{   
    			checkId : checkIdVal,
    			id : n.id,
				orgId : menuTree.getLoader().baseParams.type
			}, 
			success: function (response)    
	        {   
				if(response.responseText != "success"){
					alert("错误提示：组织菜单未能成功设置\n错误原因：" + response.responseText);
				}
	        },
		 	failure: function(response,opts) {    
			 	alert('doMenuCheck error : \n' + response.responseText);   
			}  
		}); 
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
  
  function changeOrg(id,name,isdefined,n){
      if(isdefined){
          var typeid='Orgunit_'+id;
          if(id.startsWith('Station_') || id.startsWith('Persons_') || id.startsWith('Orgunit_')){
          	typeid=id;
          	id=id.substring(8);
          }

          menuTree.getLoader().baseParams.orgid = id;
          menuTree.getLoader().baseParams.type = typeid;
          
          if(n){
	          n.attributes.isorgdefined=true;
    	      n.getUI().getAnchor().href="javascript:changeOrg('"+n.id+"','"+n.text+"',true)";
        	  n.setText('<font color=red>'+name+'</font>');
          }

      }else{
          menuTree.getLoader().baseParams.orgid="";
          menuTree.getLoader().baseParams.type='';
          name=name.replace(/<.*?>/g,'');
          if(n){
          n.attributes.isorgdefined=false;
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
  <div id="divReftype">
    <%
        List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016", null);
        if (selectlist.size() > 0) {%>
    <SELECT onChange="changeReftype(this.value)">
        <% Iterator it = selectlist.iterator();
            while (it.hasNext()) {
                Selectitem selectitem = (Selectitem) it.next();
                String selected = selectitem.getId().equals(reftype) ? "selected" : "";
        %>
        <OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%>
        </OPTION>
        <% }%>
    </SELECT>
    <% }%>
</div>
  </body>
</html>

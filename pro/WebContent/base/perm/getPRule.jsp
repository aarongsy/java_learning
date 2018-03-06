<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="org.json.simple.JSONArray" %>


<%

OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
String humresid = StringHelper.null2String(request.getParameter("requestid"));
String reftype = "402881e510e8223c0110e83d427f0018";
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
    ja.add(jo);
}
roots=ja.toString();
%>


<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    }
</style>
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
</script>


<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
    Ext.LoadMask.prototype.msg='加载...';

    var reftype='<%=reftype%>';

    var rootsArray=<%=roots%>;
    var orgTree ;
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
    orgTree = new Ext.tree.TreePanel({
            animate:true,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            //lines:true,
            region:'west',
            width:200,
            split:true,
            collapsible: true,
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
                dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitTreeAction?action=getprule&userid=<%=humresid%>",
                preloadChildren:false,
                listeners:{"beforeload":function(treeLoader, node) {
                    orgTree.getLoader().baseParams.reftype = reftype;
                }}
            }
            ),
            listeners:{
                'expand':function(p){ p.getRootNode().expand();
                }
            }

        });

    //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [orgTree,
            {
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'orgframe', name:'orgframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});
    orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: '流程',
                expanded:true,
                id: 'workflow',
                href:'javascript:void(0)',
                hrefTarget:'orgframe',
                allowDrag:false,
                allowDrop:false
            }));
    orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: '分类',
                expanded:true,
                id: 'category',
                href:'javascript:void(0)',
                hrefTarget:'orgframe',
                allowDrag:false,
                allowDrop:false
            }));
    orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: '报表',
                expanded:true,
                id: 'report',
                href:'javascript:void(0)',
                hrefTarget:'orgframe',
                allowDrag:false,
                allowDrop:false
            }));
});

</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">
<script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

    <div id="messagePage"></div>
  <script language="javascript" type="text/javascript">



   function doOrg(nodeid){

   }

   function changeReftype(rt){
       reftype=rt
       orgTree.root.eachChild(function(c){c.remove()}) ;
       newRootName="";
       newRootId="";
       Ext.each(rootsArray,function(o){
           if(o.reftype==rt){
               newRootId=o.id;
               newRootName=o.name;
           }
       })
       orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: newRootName,
                id: newRootId,
                expanded:true,
                hrefTarget:'orgframe',
                allowDrag:false,
                allowDrop:false
            }));
       orgTree.getLoader().on("beforeload", function(treeLoader, node) {
           orgTree.getLoader().baseParams.reftype = reftype;
       });
       orgTree.root.expand();
   }



   </script>



  </body>
</html>
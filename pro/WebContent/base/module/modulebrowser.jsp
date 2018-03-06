<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%

String rootid="r00t";
String roottext="系统模块";


%>
<%

pagemenustr +=  "addBtn(tb,'清除','C','erase',function(){onClear()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
%>
<html>
<head>


  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <style type="text/css">
       .x-toolbar table {width:0}
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
    var store;
    var selected=new Array();

    Ext.onReady(function(){
    var tb = new Ext.Toolbar();
   moduleTree = new Ext.tree.TreePanel({
            animate:true,
            tbar:tb,
            //title: '&nbsp;',
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            //lines:true,
            region:'center',
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottext%>',
                id:'<%=rootid%>',
                iconCls:'pkg',
                expanded:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig&isonlytree=1",
            preloadChildren:false
        }
                )

    });
    moduleTree.on('click',function(n,e){
        if(n.id=='r00t')
        return;
       getArray(n.id,n.text);
    });

    /*sm.on('rowselect',function(selMdl,rowIndex,rec ){
       getArray(rec.get('requestid'),rec.get(showfield));
       //getArray(rec.get('requestid'),rec.get('requestid')rec.get(cm.getDataIndex(1)));
    }
            );*/
    
    //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [moduleTree]
	});
     <%if(!pagemenustr.equals("")){%>

        <%=pagemenustr%>
        <%}%>    
});

</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">
 <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </body>

<script>
	function onClear(){
		getArray("0","");
	}
	function onReturn(){
		 if(!Ext.isSafari){
			window.parent.close();
		 }else{
			 parent.win.close();
		 }
	}
    function getArray(id,value){
        if(!Ext.isSafari){
		    window.parent.returnValue = [id,value];
	        window.parent.close();
 		}else{
 		   dialogValue=[id,value];
 	       parent.win.close();
 		}
    }
</script>
</html>
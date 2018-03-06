<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%
String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));
%>
<html>
<head>
<style>
#searchTable {
    width: 0
}
</style>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script>Ext.BLANK_IMAGE_URL = '<%= request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
<script type="text/javascript"> 

var contentPanel;
var classTree;
Ext.override(Ext.tree.TreeLoader, {
    createNode : function(attr) {
        // apply baseAttrs, nice idea Corey!
        if (this.baseAttrs) {
            Ext.applyIf(attr, this.baseAttrs);
        }
        if (this.applyLoader !== false) {
            attr.loader = this;
        }
        if (typeof attr.uiProvider == 'string') {
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
	classTree = new Ext.tree.TreePanel({
		checkModel: 'single',
		singleExpand: false,
        animate: false,
        useArrows :true,
        containerScroll: true,
        region:'center' ,
        autoScroll:true,
        collapsible: true,
        collapsed : false,
        rootVisible:true,
        root:new Ext.tree.AsyncTreeNode({
            text: '<%=labelService.getLabelNameByKeyId("402881e70b227478010b22783d2f0004")%>',
            id:'r00t',
            expanded:true,
            allowDrag:false,
            allowDrop:false
        }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenExt&browser=1&sqlwhere=<%=sqlwhere%>",
            preloadChildren:false
        }
                )
    });
	classTree.on('click', function(n, c) {
        getArray(n.id,n.text);
        });
	Ext.QuickTips.init();
    
    var tb = new Ext.Toolbar();
    tb.render('pagemenubar');
    //addBtn(tb,'快捷搜索','S','accept',function(){onSearch()});
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")%>','C','erase',function(){onClear();});//清除
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")%>','R','arrow_redo',function(){onReturn();});//返回

	var classTreePanel = new Ext.Panel({
	    title:'<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790061")%>',//分类树
	    tbar:tb,
	    layout: 'border',
	    items: [{region:'north',autoScroll:true,contentEl:'classPanel',split:true,collapseMode:'mini'},classTree]
	});
	
	contentPanel = new Ext.TabPanel({
        region:'center',
        id:'tabPanel',
        deferredRender:false,
        enableTabScroll:true,
        autoScroll:false,
        activeTab:0,
        items:[classTreePanel]
    });
	addTab(contentPanel,'/base/category/categorylist.jsp?sqlwhere=<%=sqlwhere%>','<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790062")%>','');//分类列表

	
	var viewport = new Ext.Viewport({
	    layout: 'border',
	    items: [contentPanel]
	});
});
function getArray(id,value){
    window.parent.returnValue = [id,value];
    window.parent.close();
}
</script>
<script language=vbs>
    Sub onClear
        getArray "0",""
     End Sub
 
     Sub onReturn
        window.parent.Close
     End Sub
</script>
<script type="text/javascript">
    function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
		var param;
	if (id[0] != '0') {
        document.all(inputname).value = id[0];
        document.all(inputspan).innerHTML = id[1];
        param = id[0];
    }else{
		document.all(inputname).value = '';
		param = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
     }
	var loader = classTree.getLoader();    
    classTree.on('beforeload', function(){     
            loader.dataUrl = loader.dataUrl ;    
            loader.baseParams.moduleid = param;    
    });   
    classTree.root.reload();
    }
 }
 </script>
</head>
<body>
<div id="classPanel">
   <div id="pagemenubar" style="z-index:100;"></div>
      <table id="searchTable">
        <tr>
           <td class="FieldName" width="120" nowrap><%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%><!-- 模块名称 --></td>
         <td class="FieldValue" width="100">
              <button  type="button" class=Browser onclick="javascript:getBrowser('/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden"  name="moduleid" id="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
	    </tr>        
      </table>
   </div>
</body>
</html>


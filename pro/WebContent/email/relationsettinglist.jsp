<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.service.EmailtypeService" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ page import="com.eweaver.email.service.EmailsetinfoService" %>
<%@ page import="com.eweaver.email.model.Emailsetinfo" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.email.servlet.EmailAction?action=relation&from=list";

%>
<head>

    <style type="text/css">
.x-toolbar table {width:0}
#pagemenubar table {width:0}
  .x-panel-btns-ct {
    padding: 0px;
}
.x-panel-btns-ct table {width:0}
  </style>
  <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
  <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
  <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
    var selected = new Array();
    Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
    var store;
    var dlg0;
    Ext.onReady(function() {
        Ext.QuickTips.init();
    <%if(!pagemenustr.equals("")){%>
        var tb = new Ext.Toolbar();
        tb.render('pagemenubar');
    <%=pagemenustr%>
    <%}%>
        store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '<%=action%>'
            }),
            reader: new Ext.data.JsonReader({
                root: 'result',
                totalProperty: 'totalcount',
                fields: ['objname','objtype','browservalue','id','str']


            })

        });
        var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0003")%>", sortable: false,  dataIndex: 'objname'},//设置名称
            {header: "<%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026")%>", sortable: false,  dataIndex: 'objtype'},//类型
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0017")%>", sortable: false,   dataIndex: 'browservalue'},//browser框
             {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e")%>", sortable: false,   dataIndex: 'str'}//操作

        ]);
        var grid = new Ext.grid.GridPanel({
            region: 'center',
            store: store,
            cm: cm,
            trackMouseOver:false,
            loadMask: true,
             viewConfig: {
                                     forceFit:true,
                                     enableRowBody:true,
                                     sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                     sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                     columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                     getRowClass : function(record, rowIndex, p, store){
                                         return 'x-grid3-row-collapsed';
                                     }
                                 },
                                 bbar: new Ext.PagingToolbar({
                                     pageSize: 20,
                      store: store,
                      displayInfo: true,
                      beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                      afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                      firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                      prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                      nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                      lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                      displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录
                      emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                  })

        });
        store.load({params:{start:0, limit:20}});
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });

    });

  </script>

</head>
<body>
<div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
    </div>
</body>
<script type="text/javascript">
    function onModify(id){
     location.href="<%=request.getContextPath()%>/email/relationsettingcreate.jsp?id="+id;
    }
</script>
</html>
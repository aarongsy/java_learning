<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService" %>

<%
    String requestid = StringHelper.null2String(request.getParameter("requestid"));
    String nodeid = StringHelper.null2String(request.getParameter("nodeid"));
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=operatorshow";

%>


<html>
  <head>

      <style type="text/css">
         .x-toolbar table {width:0}
         #pagemenubar table {width:0}
           .x-panel-btns-ct {
             padding: 0px;
         }
         .x-panel-btns-ct table {width:0}
          .x-grid3-cell-inner,.x-grid3-hd-inner{overflow:hidden;-o-text-overflow:ellipsis;text-overflow:ellipsis;padding:3px 3px 3px 5px;white-space:normal;}
     </style>

      <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script language="javascript">
      Ext.SSL_SECURE_URL='about:blank';
      Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
      var store;
      var selected = new Array();
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
                  fields: ['operatortype','value']


              })

          });
          var sm = new Ext.grid.CheckboxSelectionModel();

          var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220043")%>", width:100, sortable: false,  dataIndex: 'operatortype'},//操作者类型
              {header: "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005e")%>", sortable: false, width:500,   dataIndex: 'value'}//操作人
          ]);
          cm.defaultSortable = true;
          var grid = new Ext.grid.GridPanel({
              region: 'center',
              store: store,
              cm: cm,
              trackMouseOver:false,
              sm:sm ,
              enableHdMenu:false,
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
                                   }


          });
          var viewport = new Ext.Viewport({
              layout: 'border',
              items: [grid]
          });
           store.baseParams.nodeid = '<%=nodeid%>';
          store.baseParams.requestid = '<%=requestid%>';
          store.load({params:{start:0, limit:20}});
               });
      </script>


  </head>

  <body></body>
</html>

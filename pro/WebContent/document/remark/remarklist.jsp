<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.Constants"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<%
    String objid=StringHelper.null2String(request.getParameter("objid"));
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction?action=list";
%>

<!--页面菜单开始-->

<html>
  <head>
   <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
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
       store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['humresname','score','createdate','objdesc']


           })

       });

       var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004d")%>", sortable: false,  dataIndex: 'humresname'},//点评人
           {header: "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004e")%>", sortable: false,   dataIndex: 'score'},//分值
           {header: "<%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")%>",  sortable: false,dataIndex: 'createdate'},//日期
           {header: "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004f")%>",  sortable: false,dataIndex: 'objdesc'}//评语
       ]);
       cm.defaultSortable = true;
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
                           displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',// 显示   条记录
                           emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                       })

             });
       //Viewport
          var viewport = new Ext.Viewport({
           layout: 'border',
           items: [grid]
       });
       store.baseParams.objid = '<%=objid%>';
       store.load({params:{start:0, limit:20}});

   });
   </script>
  </head>

  <body>
 <SCRIPT language="javascript"></script>
  </body>
</html>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.notify.service.NotifyService" %>
<%@ page import="com.eweaver.base.notify.model.Notify" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>

<%
String currentHumresId=BaseContext.getRemoteUser().getId();
String defineId=StringHelper.trimToNull(request.getParameter("id"));
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=getChildrenlist";
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
      <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/NotifyService.js'></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/util.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
        <script language="javascript">
        Ext.SSL_SECURE_URL='about:blank';
        Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
        var store;
        var dlg0;
        var selected = new Array();
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
                    fields: ['objname']


                })

            });
            var sm = new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40038") %>",  sortable: false, dataIndex: 'objname'}//提醒信息
            ]);
            cm.defaultSortable = true;
            var grid = new Ext.grid.GridPanel({
                region: 'center',
                store: store,
                cm: cm,
                trackMouseOver:false,
                sm:sm ,
                loadMask: true,
                 viewConfig: {
                                         forceFit:true,
                                         enableRowBody:true,
                                         sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
						                sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
						                columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                                         getRowClass : function(record, rowIndex, p, store){
                                             return 'x-grid3-row-collapsed';
                                         }
                                     },
                                     bbar: new Ext.PagingToolbar({
                                         pageSize: 20,
                          store: store,
                          displayInfo: true,
                          beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
			            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
			            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
			            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
			            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
			            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
			            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示     条记录
			            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>" 
                      })

            });
            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [grid]
            });
            store.baseParams.defineId = '<%=defineId%>';
            store.baseParams.currentHumresId = '<%=currentHumresId%>';
            store.load({params:{start:0, limit:20}});
        });
        </script>

  </head>
  <body></body>
<script language="javascript" type="text/javascript">

  function markRead(notifyId){
    NotifyService.markRead(notifyId);
  }
 </script>
</html>



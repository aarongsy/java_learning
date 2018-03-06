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
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.RequestlogAction?action=getrelog";
    String requestid=StringHelper.null2String(request.getParameter("requestid"));
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

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/examples/grid/RowExpander.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/chooser/chooser.js"></script>
   <script language="javascript">
   Ext.SSL_SECURE_URL='about:blank';
   Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
    var requestid='<%=requestid%>';
      Ext.grid.RowExpander.override({expandAll:function(){
        var g = this.grid;
        var exp = this;
        g.getStore().each(function(rec) {

            var rowIndex = g.getStore().indexOfId(rec.id) ;
            var row = g.view.getRow(rowIndex);
            //if (rec.get('message') != '')
                exp.toggleRow(row);
        })
    }});
   window.onload = function() {
       Ext.QuickTips.init();
              var commentstore = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
            url: '<%=action%>'
           }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: ['Datatime','operator','point','opertype','message']
        })
         });
        var expander = new Ext.grid.RowExpander({
			tpl : new Ext.Template(
				'<tr><div style="white-space:normal;word-break:break-all;line-height: 1.4">{message}<div>'
			)

    });
       var commentPanel = new Ext.grid.GridPanel({
                store: commentstore,
                region:'center',
                columns: [
                       expander,
                     {header: "",  sortable: true,  dataIndex: '' , width:60},
                    {header: "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005e") %>", sortable: true,   dataIndex: 'operator', width:10},//操作人
                    {header: "<%=labelService.getLabelNameByKeyId("402881820d467b14010d4687e3be0008") %>", sortable: true, dataIndex: 'Datatime', width:14},//时间
                    {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %>",  sortable: true, dataIndex: 'opertype', width:6},//操作
                    {header: "<%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76b1f3260037") %>",  sortable: true,  dataIndex: 'point', width:10}//节点
                ],
                autoScroll:true,
                plugins: expander,
                 viewConfig: { forceFit:true,
                               enableRowBody:true,
                               sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
	                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
	                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                               getRowClass : function(record, rowIndex, p, store){
                                   return 'x-grid3-row-collapsed';
                               }
                           },
                 tbar:[{text:'<%=labelService.getLabelName("显示签字流转信息")%>',
                     enableToggle: true,
                     pressed: false,
                     toggleHandler: function(item,pressed) {
                         if(pressed)
                         {
                           this.setText('<%=labelService.getLabelName("显示全部流转信息")%>'),
                           commentstore.baseParams.showmore=0;
                           commentstore.load();
                         }else
                         {
                         this.setText('<%=labelService.getLabelName("显示签字流转信息")%>'),
                         commentstore.baseParams.showmore=1;
                         commentstore.load();
                         }

                     }
                 }]
             });
        commentstore.on('load',function(s,records){
             expander.expandAll();
        })
       var viewport = new Ext.Viewport({
           layout: 'border',
           items: [commentPanel]
       });

                   commentstore.baseParams.showmore=1;
                    commentstore.baseParams.requestid=requestid;
                   commentstore.load();

   };
   </script>
  </head>

  <body>

<div id="divSearch"></div>
  </body>
</html>

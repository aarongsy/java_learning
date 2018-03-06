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
    String requestid=StringHelper.null2String(request.getParameter("requestid"));
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=getremarks&requestid="+requestid ;    
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
  </style>

   <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/examples/grid/RowExpander.js"></script>
   <script language="javascript">
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
        Ext.onReady(function() {
              var commentstore = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
            url: '<%=action%>'
           }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: ['objnamestr','remark','submitdate']
        })
         });
        var expander = new Ext.grid.RowExpander({
			tpl : new Ext.Template(
				'<tr><div style="white-space:normal;word-break:break-all;line-height: 1.4">{remark}<div>'
			)

    });
         var commentPanel = new Ext.grid.GridPanel({
            store: commentstore,
            region:'center',
            columns: [
                   expander,
                 {header: "",  sortable: true,  dataIndex: '' , width:60},
                {header: "操作人", sortable: true,   dataIndex: 'objnamestr', width:10},
				{header: "提交时间", sortable: true, dataIndex: 'submitdate', width:14}
            ],
            autoScroll:true,
            plugins: expander,
             viewConfig: { forceFit:true,
                           enableRowBody:true,
                           sortAscText:'升序',
                           sortDescText:'降序',
                           columnsText:'列定义',
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       }
         });
    commentstore.on('load',function(s,records){
         expander.expandAll();
    });
            commentstore.load({params:{start:0, limit:20}});
        var viewport = new Ext.Viewport({
           layout: 'border',
           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},commentPanel]
       });
        });

   </script>
  </head>

  <body>

<div id="divSearch">
    <div id="pagemenubar"></div>
</div>


 <SCRIPT language="javascript"></script>
  </body>
</html>

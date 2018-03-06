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
request.setCharacterEncoding("UTF-8");
    String workflowid1=StringHelper.null2String(request.getParameter("workflow1"));//获得流程1的id
String action=request.getContextPath()+"/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=getlist";

%>

<!--页面菜单开始-->
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','N','add',function(){onCreate()});";
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";
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
               fields: ['objname','formname','description','id']


           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0004")%>",  sortable: false,  dataIndex: 'objname'},//设置名
           {header: "<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460002")%>", sortable: false,    dataIndex: 'formname'},//表单名
           {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%>", sortable: false,    dataIndex: 'description'}//说明

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


       //Viewport
       store.on('load',function(st,recs){
              for(var i=0;i<recs.length;i++){
                  var reqid=recs[i].get('id');
              for(var j=0;j<selected.length;j++){
                          if(reqid ==selected[j]){
                               sm.selectRecords([recs[i]],true);
                           }
                       }
          }
          }
                  );
          sm.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                               return;
                           }
                       }
              selected.push(reqid)
          }
                  );
          sm.on('rowdeselect',function(selMdl,rowIndex,rec){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                              selected.remove(reqid)
                               return;
                           }
                       }

          }
                  );

       var viewport = new Ext.Viewport({
           layout: 'border',
           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
       });

       store.load({params:{start:0, limit:20}});
   });
   </script>
  </head>

  <body>

<div id="divSearch">
    <div id="pagemenubar"></div>
</div>


 <SCRIPT language="javascript">

  function onCreate(){
    document.location.href="<%=request.getContextPath()%>/customaction/customactioncreate.jsp";
  }
     function onDelete()
     {
         if (selected.length == 0) {
             Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
             Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000")%>');//请选择要删除的内容！
             return;
         }
         Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>'};//是//否
         Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075")%>', function (btn, text) {//您确定要删除吗?
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=delete',
                     params:{ids:selected.toString()},
                     success: function() {
                         selected = [];
                         store.load({params:{start:0, limit:20}});
                     }
                 });
             } else {

             }
         });

     }
     function onModify(id){
     document.location.href="<%=request.getContextPath()%>/customaction/customactionmodify.jsp?actionid="+id;
     }
      
  </script>
  </body>
</html>

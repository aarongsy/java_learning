<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<jsp:useBean id="forminfoService" class="com.eweaver.workflow.form.service.ForminfoService" />
<%
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.cowork.servlet.CoworkAction?action=getcoworksetlist";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onPopup('"+request.getContextPath()+"/cowork/coworksetmodify.jsp')});";
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除

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
   
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script language="javascript">
   Ext.SSL_SECURE_URL='about:blank';
   Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
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
               fields: ['objname','formname','description','id']


           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0003")%>", sortable: false,  dataIndex: 'objname'},//设置名称
           {header: "<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002")%>", sortable: false,   dataIndex: 'formname'},//表单名称
           {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790040")%>",  sortable: false, dataIndex: 'description'}//设置说明
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
       dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%>',//取消
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
                   store.load({params:{start:0, limit:20}});
               }

           }],
           items:[{
               id:'dlgpanel',
               region:'center',
               xtype     :'iframepanel',
               frameConfig: {
                   autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                   eventsFollowFrameLinks : false
               },
               autoScroll:true
           }]
       });
       dlg0.render(Ext.getBody());
   });
   </script>
  </head>

  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div>
  	<span color='#F4E19F' class=unread>sssssssssssss</span>
  </body>
  <script language="javascript" type="text/javascript">
   function onPopup(url){
         //document.EweaverForm.submit();
          this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()
     }
      function onModify(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show()   
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
                               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction?action=delcoworkset',
                               params:{ids:selected.toString()},
                               success: function() {

                                   selected = [];
                                   store.load({params:{start:0, limit:20}});

                               }
                           });
                       }
                   });

               }


   </script>

</html>


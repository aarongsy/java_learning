<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.util.FormlinkTranslate"%>
<%@ page import="com.eweaver.base.Page"%>

<%
String id=request.getParameter("forminfoid");
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
pagemenustr += "addBtn(tb,'新增','E','add',function(){oncreateformlink('/workflow/form/formlinkcreate.jsp?forminfoid="+id+"&moduleid="+moduleid+"')});"; 
String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.form.servlet.FormlinkAction?action=getformlinklist&id="+id;
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
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script language="javascript">
      Ext.SSL_SECURE_URL='about:blank';
      Ext.LoadMask.prototype.msg='加载...';
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
                  fields: ['objname','fieldmap','typestr','del','id']


              })

          });
          var cm = new Ext.grid.ColumnModel([ {header: "<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbfb0bde0008") %>",sortable: false,  dataIndex: 'objname'},//关联表单ID
              //{header: "<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf73bda0006") %>", sortable: false,    dataIndex: 'fieldmap'},//字段对应
              {header: "<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf6a5350005") %>",  sortable: false, dataIndex: 'typestr'},//关系类型
              {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %>",  sortable: false, dataIndex: 'del'}//操作
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
			            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示  条记录
			            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>"
                    })

          });
          //Viewport
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
           width:viewport.getSize().width * 0.9,
           height:viewport.getSize().height * 0.9, 
           buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>',//取消
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
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
            <div id="pagemenubar"></div>
		</div>
  <script type="text/javascript">
         function oncreateformlink(url) {
             this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();
         }
         function onDeleteFormlink(id) {
                  Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是   否
         Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075") %>', function (btn, text) {//您确定要删除吗?
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlinkAction?action=delete&id='+id,
                     success: function() {
                         store.load({params:{start:0, limit:20}});
                     }
                 });
             } else {
                 store.load({params:{start:0, limit:20}});
             }
         });

         }
  </script>
  </body>
</html>


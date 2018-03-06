<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionBatchActionService" %>
<%@ page import="com.eweaver.base.security.model.PermissionBatchAction" %>

<%
   PermissionBatchActionService permissionBatchActionService = (PermissionBatchActionService) BaseContext.getBean("permissionBatchActionService");
   List actionList = permissionBatchActionService.getAllPermissionBatchAction();
   PermissionBatchAction permissionBatchAction=new PermissionBatchAction();
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=getpermlist";
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','N','add',function(){onCreate('/base/security/permissionBatchAction/permissionBatchActionCreate.jsp')});";
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";
    pagemenustr +="addBtn(tb,'新建转移组','D','add',function(){createGroup()});";
    pagemenustr +="addBtn(tb,'搜索转移组','S','zoom',function(){searchGroup()});";
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
}
  </style>

   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
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
               fields: ['objname','objdesc','str','id']


           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "操作名称", width:300, sortable: false,  dataIndex: 'objname'},
           {header: "操作描述", sortable: false, width:500,   dataIndex: 'objdesc'},
           {header: "类型",  sortable: false,width:50, dataIndex: 'str'}
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
                                    sortAscText:'升序',
                                    sortDescText:'降序',
                                    columnsText:'列定义',
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }
                                },
                                bbar: new Ext.PagingToolbar({
                                    pageSize: 20,
                     store: store,
                     displayInfo: true,
                     beforePageText:"第",
                     afterPageText:"页/{0}",
                     firstText:"第一页",
                     prevText:"上页",
                     nextText:"下页",
                     lastText:"最后页",
                     displayMsg: '显示 {0} - {1}条记录 / {2}',
                     emptyMsg: "没有结果返回"
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
           width:viewport.getSize().width * 0.66,
           height:viewport.getSize().height * 0.6,
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '确认',
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
<!--页面菜单开始-->
<div id="divSearch">
<div id="pagemenubar"></div>
</div>
<SCRIPT language="javascript">
    function onDelete()
        {
            if (selected.length == 0) {
                Ext.Msg.buttonText={ok:'确定'};                                               
                Ext.MessageBox.alert('', '请选择要删除的内容！');
                return;
            }
            Ext.Msg.buttonText={yes:'是',no:'否'};
            Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                if (btn == 'yes') {
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=deleteext',
                        params:{ids:selected.toString()},
                        success: function() {
                            selected = [];
                            store.load({params:{start:0, limit:20}});
                        }
                    });
                } else {
                    selected = [];
                    store.load({params:{start:0, limit:20}});
                }
            });

        }

  function onCreate(url){
      window.location=contextPath+url;
  }
  function createGroup(){
      <%--this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionGroupCreate.jsp");--%>
      <%--this.dlg0.show()--%>
      if(selected==""){
          alert("您还没有选择新建组中包含的主任务！");
          return;
      }
      onUrl("<%= request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionGroupCreate.jsp?permissionBatchActionIds="+selected,"新建权限转移组","");
  }

  function searchGroup(){
      onUrl("<%= request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionGroupList.jsp","搜索权限转移组","");
  }
</SCRIPT>
  </body>
</html>

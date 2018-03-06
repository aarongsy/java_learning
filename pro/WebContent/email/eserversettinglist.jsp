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
      pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa85e6aed0001")+"','N','email_add',function(){onAdd()});";//新增
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','email_delete',function(){onDelete()});";//删除
    String id=StringHelper.null2String(request.getParameter("id"));
    EmailsetinfoService emailsetinfoService = (EmailsetinfoService)BaseContext.getBean("emailsetinfoService");
    Emailsetinfo emailsetinfo=new Emailsetinfo();
    if(!StringHelper.isEmpty(id)){
         emailsetinfo=emailsetinfoService.getEmailsetinfo(id);
    }
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.email.servlet.EmailAction?action=getserverinfolist";

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
                fields: ['servername','servertype','smtpname','isattestr','issavestr','id','sport','gport','ssslstr','gsslstr','objname']


            })

        });
           var sm = new Ext.grid.CheckboxSelectionModel();
        var cm = new Ext.grid.ColumnModel([sm,{header: "<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0003")%>", sortable: false,  dataIndex: 'objname'},//设置名称
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0010")%>", sortable: false,  dataIndex: 'servername'},//服务器名称
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0011")%>", sortable: false,   dataIndex: 'servertype'},//服务器类型
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0006")%>",  sortable: false, dataIndex: 'smtpname'},//SMTP服务器
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0012")%>",  sortable: false, dataIndex: 'gport'},//收件端口号
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0013")%>",  sortable: false, dataIndex: 'sport'},//发件端口号
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0014")%>",  sortable: false, dataIndex: 'ssslstr'},//发件是否SSL
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0015")%>",  sortable: false, dataIndex: 'gsslstr'},//收件是否SSL
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0008")%>",  sortable: false, dataIndex: 'isattestr'},//是否需要发件认证
            {header: "<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0009")%>",  sortable: false, dataIndex: 'issavestr'}//是否保留服务器上的邮件

        ]);
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
        store.load({params:{start:0, limit:20}});

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
    });

  </script>

</head>
<body>
<div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
    </div>
</body>
<script type="text/javascript">
   function onSubmit(){
       var id=document.getElementById('id').value;
       var objname=document.getElementById('objname').value;
       var emailaddress=document.getElementById('emailaddress').value;
       Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=emailsettingsave&from=esetinfo',
        params:{id:id,objname:objname,emailaddress:emailaddress},
        success: function() {
            pop( '设置成功！');
        }

       });


   }

    function onAdd(url){
        var url='<%=request.getContextPath()%>/email/emailserver.jsp'
        window.location=url;
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
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=delserverinfo',
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
     location.href="<%=request.getContextPath()%>/email/emailservermodify.jsp?id="+id;
    }
</script>
</html>
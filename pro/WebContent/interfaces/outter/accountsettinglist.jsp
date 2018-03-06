<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionBatchActionService" %>
<%@ page import="com.eweaver.base.security.model.PermissionBatchAction" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','C','add',function(){onCreate('/interfaces/outter/accountsettingcreate.jsp')});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){ondelete()});";//删除
    String id=currentuser.getId();

%>
<html>
  <head>
  <STYLE>
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-bottom-style: solid;
	border-bottom-color: #cccccc;
}
</STYLE>
  <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/rtxint.js"></script>
  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/browinfo.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript">
 Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>';//加载中,请稍后...
    var store;
    var selected=new Array();
    var dlg0;
  <%
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=settinglist";
  %>
         Ext.onReady(function(){
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
            fields: ['accountname','visittype','outtersysname','id']
        })

    });
    var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80035")%>",  sortable: false,  dataIndex: 'accountname'},//账户
                {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780008")%>", sortable: false,   dataIndex: 'visittype'},//访问类型
    {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000b")%>", sortable: false,   dataIndex: 'outtersysname'}]);//登录系统名称

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

    //Viewport
var viewport = new Ext.Viewport({
          layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	});
             store.baseParams.id = '<%=id%>';
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
<!--页面菜单开始-->
<div id="divSearch">
    <div id="pagemenubar" style="z-index:100;"></div>
</div>
<SCRIPT language="javascript">
  function onSubmit(){
    document.EweaverForm.submit();
  }
  function onCreate(url){
       this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();
  }
  function ondelete()
  {
     var totalsize = selected.length;
              if (totalsize == 0) {
                  Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                  Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000c")%>');//请选中您所要删除的内容！
                  return;
              }
               Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>'};//是//否
              Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075")%>', function (btn, text) {//您确定要删除吗?
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: ' <%= request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=delsetting',
                          params:{ids:selected.toString()},
                          success: function() {
                           store.load({params:{start:0, limit:20}});
                          }
                      });
                  } else {
                      selected=[];
                      store.load({params:{start:0, limit:20}});
                  }
              });

  }
function onSearch(){
  var objname=document.all("inputText").value;
  objname=encodeURI(Trim(objname));
  EweaverForm.action="<%= request.getContextPath()%>/base/notify/notifyDefineList.jsp?objname="+objname;
  EweaverForm.submit();
}
function onModify(url){
 this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();}
</SCRIPT>
  </body>
</html>

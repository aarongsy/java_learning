<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.sequence.Sequence" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
SequenceService sequenceService = (SequenceService)BaseContext.getBean("sequenceService");
String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.personalSignature.servlet.PersonalSignatureAction?action=getpersonalsignaturelist";

%>
<%
    pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001") + "','S','accept',function(){onCreate()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f2090018")+"','S','page',function(){onSetdef()});";//设置为默认值
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f209001a")+"','S','page',function(){Canceldef()});";//取消设置默认值

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
      <style type="text/css">
            .x-toolbar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
  </style>

  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
         <script language="javascript">
             Ext.LoadMask.prototype.msg = '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021") %>';//加载中,请稍后...
             var store;
             var selected = new Array();
             var dlg0;
             function renderDefvalue(val) {
                 if (val == '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>') {//否
                     return  val;
                 } else if (val == '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>') {//是
                     return '<span style="color:red;">' + val + '</span>';
                 }
                 return val;
             }
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
                         fields: [
                             'objvalue',
                             'humres',
                             'id',
                             'defvalue',
                             'candel'
                         ]

                     })

                 });
                 //store.setDefaultSort('id', 'desc');

                 var sm = new Ext.grid.CheckboxSelectionModel();

                 var cm = new Ext.grid.ColumnModel([
                     sm,
                     {
                         header: "<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20a001d") %>",//个人签字
                         width:200,
                         sortable: false,
                         dataIndex: 'objvalue'
                     },
                     {
                         header: "<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f2090018") %>",//设置为默认值
                         width:200,
                         sortable: false,
                         renderer: renderDefvalue,
                         dataIndex: 'defvalue'
                     },
                     {
                         header:"<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980020")%>" ,//人员
                         width:50,
                         sortable: false,
                         dataIndex: 'humres'
                     }
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
                         getRowClass : function(record, rowIndex, p, store) {
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

                 store.on('load', function(st, recs) {
                     for (var i = 0; i < recs.length; i++) {
                         var reqid = recs[i].get('id');
                         for (var j = 0; j < selected.length; j++) {
                             if (reqid == selected[j]) {
                                 sm.selectRecords([
                                     recs[i]
                                 ], true);
                             }
                         }
                     }
                 }
                         );
                 sm.on('rowselect', function(selMdl, rowIndex, rec) {
                     var reqid = rec.get('id');
                     var candels = rec.get('candel');
                     var reqidandisdelete = reqid+','+candels;
                     for (var i = 0; i < selected.length; i++) {
                         if (reqidandisdelete == selected[i]) {
                             return;
                         }
                     }
                     selected.push(reqidandisdelete);
                 }
                         );
                 sm.on('rowdeselect', function(selMdl, rowIndex, rec) {
                     var reqid = rec.get('id');
                     var candels = rec.get('candel');
                     var reqidandisdelete = reqid+','+candels;
                     for (var i = 0; i < selected.length; i++) {
                         if (reqidandisdelete == selected[i]) {
                             selected.remove(reqidandisdelete)
                             return;
                         }
                     }

                 }
                         );


                 //Viewport
                 var viewport = new Ext.Viewport({
                     layout: 'border',
                     items: [
                         {
                             region:'north',
                             autoScroll:true,
                             contentEl:'divSearch',
                             split:true,
                             collapseMode:'mini'
                         },
                         grid
                     ]
                 });
                 store.load({
                     params:{
                         start:0,
                         limit:20
                     }
                 });
                 dlg0 = new Ext.Window({
                     layout:'border',
                     closeAction:'hide',
                     plain: true,
                     modal :true,
                     width:viewport.getSize().width * 0.8,
                     height:viewport.getSize().height * 0.8,
                     buttons: [
                         {
                             text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
                             handler  : function() {
                             	 dlg0.getComponent('dlgpanel').setSrc('');
                                 dlg0.hide();
                                 store.load({
                                     params:{
                                         start:0,
                                         limit:20
                                     }
                                 });
                             }

                         }
                     ],
                     items:[
                         {
                             id:'dlgpanel',
                             region:'center',
                             xtype     :'iframepanel',
                             frameConfig: {
                                 autoCreate:{
                                     id:'dlgframe',
                                     name:'dlgframe',
                                     frameborder:0
                                 } ,
                                 eventsFollowFrameLinks : false
                             },
                             autoScroll:true
                         }
                     ]
                 });
             });
         </script>
  </head>
  <body>


<!--页面菜单开始-->

<div id="divSearch">
 <div id="pagemenubar"></div>

</div>


<script language="javascript">
 <!--
   function onPopup(url){
         //document.EweaverForm.submit();
          this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()
     }
    function onCreate(){
     var url="<%= request.getContextPath()%>/base/personalSignature/personalSignatureModify.jsp?action=create";
	 onPopup(url);
   }
   function nopower(){
         alert("管理员创建的签字意见不允许删除或修改。");
   }
   function onModify(id,eweaverid,humresid){
     var url="<%= request.getContextPath()%>/base/personalSignature/personalSignatureModify.jsp?action=modify&id="+id;
	 onPopup(url);
   }
   function onDelete(id){
   <%--  if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
     	var url="/ServiceAction/com.eweaver.base.sequence.SequenceAction?action=delete&id="+id;
		window.location.href=url;
   	}--%>
   	 if(selected.length==0){
          Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定      
          Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000") %>');//请选择要删除的内容！
          return;
     }
   	 var idsstr = selected.toString();
   	 var reqidstr = "";
   	 for(var i = 0;i<selected.length;i++){
   	 	var reqidandisdelete = selected[i];
   	 	var isdelete = reqidandisdelete.substr(reqidandisdelete.indexOf(',')+1,1);
   	 	if("1"==isdelete){
   	 		alert("管理员创建的签字意见不允许删除或修改。");
   	 		return;
   	 	}
   	 	var reqid = reqidandisdelete.substring(0,reqidandisdelete.indexOf(','));
   	 	reqidstr = reqidstr + "," + reqid;
   	 }
            Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是   否
     		Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075") %>', function (btn, text) {//您确定要删除吗?
                     if (btn == 'yes') {
                         Ext.Ajax.request({
                             url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.personalSignature.servlet.PersonalSignatureAction?action=delete',
                             params:{ids:reqidstr},
                             success: function() {
                                 selected=[];
                                 store.load({params:{start:0, limit:20}});
                             }
                         });
                     } else {
                         selected=[];
                        store.load({params:{start:0, limit:20}});
                     }
                 });
   }
 -->
 </script>
  <script type="text/javascript">
      function onSetdef(){
          if(selected.length==0){
             Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
              Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20a0020") %>');//请选择一行数据进行操作！
              return;
          }
            if(selected.length>1){
                  Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20b0022") %>');//只能选择一行数据！
                return;
            }
          if(selected.length==1){
              Ext.Ajax.request({
                             url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.personalSignature.servlet.PersonalSignatureAction?action=defvalue',
                             params:{id:selected.toString().substring(0,selected.toString().indexOf(','))},
                             success: function(res) {
                                 if(res.responseText=='failure1'){
                                        Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                                     Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20b0024") %>');//此数据已是默认值!
                                 }else if(res.responseText=='success'){
                                           Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                                        Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20b0026") %>',function(){//设置默认值成功!
                                        selected=[];
                                       store.load({params:{start:0, limit:20}});
                                     });
                                 }else if(res.responseText=='failure2'){
                                        Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                                     Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20b0028") %>');//已经存在默认值,不可再设置默认值!
                                 }
                                
                             }
                         });
          }
      }
      function Canceldef(){
         if(selected.length==0){
            Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
              Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20a0020") %>');//请选择一行数据进行操作！
             return;
          }
             if(selected.length>1){
                 Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20b0022") %>');//只能选择一行数据！
                return;
            }
            Ext.Ajax.request({
                             url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.personalSignature.servlet.PersonalSignatureAction?action=canceldefvalue',
                             params:{id:selected.toString().substring(0,selected.toString().indexOf(','))},
                             success: function(res) {
                                 if(res.responseText=='failure1'){
                                    Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                                     Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20b002a") %>');//此数据不是默认值!
                                
                                 }else if(res.responseText=='success'){
                                    Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
                                        Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c002c") %>',function(){//取消默认值成功!
                                        selected=[];
                                       store.load({params:{start:0, limit:20}});
                                     });
                                 }

                             }
                         });
      }
  </script>
  </body>
</html>
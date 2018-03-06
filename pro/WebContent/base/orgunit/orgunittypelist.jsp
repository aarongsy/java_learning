<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunittype"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ include file="/base/init.jsp"%>
<%
OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){onCreate()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除

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
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
       <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
        <script language="javascript">
          Ext.LoadMask.prototype.msg='加载中,请稍后...';
             var store;
             var selected=new Array();
             var dlg0;
           <%
            String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitAction?action=getorgunittype";
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

                       fields: ['typename','iscomstr','level','color','order','modify','id']

                 })

             });
             //store.setDefaultSort('id', 'desc');

             var sm=new Ext.grid.CheckboxSelectionModel();
function viewColor(v,m,r){
	if(Ext.isEmpty(v)) v='51B5EE';
	return '<div style="width:100px;height:15px;background-color:'+v+';color:#000000;">#'+v+'</div>';
}
             var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc187bfa000c") %>",  sortable: false,  dataIndex: 'typename'},//组织类型
                         {header: "<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f207000b") %>", sortable: false,   dataIndex: 'iscomstr'},//是否公司类型
                         {header: "<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f207000d") %>",  sortable: false, dataIndex: 'level'},//类型级别
                         {header:"<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f207000f") %>",sortable: false, dataIndex: 'color',renderer:viewColor},//颜色
                         {header: "<%=labelService.getLabelNameByKeyId("402881e50ad58ade010ad58f1aef0001") %>",  sortable: false, dataIndex: 'order'},//顺序
                          {header: "",  sortable: false, dataIndex: 'modify'}
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
					                //------解决火狐浏览器extpanel单元格中字符太多时显示错乱问题start-----
					                ,layout : function() {
								    var obj = this; 	
									obj.el.dom.style.width = "100%";
									  setTimeout(function(){	
		                        	 	if (!obj.mainBody) {
							       			return; // not rendered
										}
										var g = obj.grid;
										var c = g.getGridEl();
										var csize = c.getSize(true);
										var vw = csize.width;
										var vh=csize.height;
										var colTotalWidth = 0;
										var clModel = g.getColumnModel();
										var clWidthArr = new Array();
										var gsm = g.getSelectionModel();
										for(var i = 0; i < clModel.getColumnCount(); i++){
											if(i==0){
												if(gsm.id){
												 	clWidthArr.push(clModel.getColumnWidth(i));
												 	continue;
												}
											}
										 	clWidthArr.push(clModel.getColumnWidth(i)-10);
										}
										var gview = g.getView();
										var rowcount = store.getCount();
										for(var i=0;i<rowcount;i++){
											for(var j=0;j<clWidthArr.length;j++){
												var td = gview.getCell(i,j);
												td.firstChild.style.width = clWidthArr[j]+"px";
											}
										}
										if (obj.forceFit) {
											if (obj.lastViewWidth != vw) {
												obj.fitColumns(false, false);
												obj.lastViewWidth = vw;
											}
										} else {
											obj.autoExpand();
											obj.syncHeaderScroll();
										}
		                             }, 10);
						       		}
					                 //------解决火狐浏览器extpanel单元格中字符太多时显示错乱问题end-----
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
               store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
                             handler  : function(){
                                 dlg0.hide();
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
         });
          </script>
  </head> 
  <body>
<!--页面菜单开始-->
<div id="divSearch">
	<div id="pagemenubar" style="z-index:100;"></div>
</div>
<script language="javascript">
 <!--
    function onCreate(){
     var url="<%=request.getContextPath()%>/base/orgunit/orgunittypecreate.jsp";
	 window.location.href=url;
   }
   function onModify(id){
     var url="<%=request.getContextPath()%>/base/orgunit/orgunittypemodify.jsp?id="+id;
	 window.location.href=url;
   }
   function onDelete(){
 if(selected.length==0){
                  Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定                              
           Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f2090013") %>！');//请选择组织类型
           return;
           }
          Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是   否
     Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075") %>', function (btn, text) {//您确定要删除吗?
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunittypeAction?action=delete',
                          params:{ids:selected.toString()},
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
  </body>
</html>
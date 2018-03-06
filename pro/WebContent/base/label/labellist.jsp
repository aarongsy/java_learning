<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.label.model.Label"%>
<%@ page import="com.eweaver.base.label.service.LabelService"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ include file="/base/init.jsp"%>
<%
Label label = (Label) request.getAttribute("queryObject");
Page pageObject = (Page) request.getAttribute("pageObject");
 SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
if (pageObject == null) {
	pageObject = ((LabelService)BaseContext.getBean("labelService")).getPagedByQuery("from Label order by id desc",1,20);
}
 String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=getlabellist";
%>

<%
    pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004") + "','S','zoom',function(){onSearch()});";
    pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001") + "','C','add',function(){onPopup('/base/label/labelcreate.jsp')});";
 //  pagemenustr += "addBtn(tb,'删除','D','delete',function(){onDelete()});";
    pagemenustr += "addBtn(tb,'清空条件','R','erase',function(){onReset()});";


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
               fields: ['labelid','labelname','labeldesc','modify','id']


           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "标签ID", width:300, sortable: false,  dataIndex: 'labelid'},
           {header: "标签名", sortable: false, width:200,   dataIndex: 'labelname'},
           {header: "标签说明",  sortable: false,width:200, dataIndex: 'labeldesc'},
           {header: "&nbsp;",  sortable: false, width:50,dataIndex: 'modify'}
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
          
      	var labelPanel = new Ext.Panel({
		    title:'系统标签',iconCls:Ext.ux.iconMgr.getIcon('page_white_code'),
		    layout: 'border',
		    items: [{region:'north',autoScroll:true,contentEl:'divSearch',split: true,collapseMode: "mini"},grid]
		});
      	
		var contentPanel = new Ext.TabPanel({
		  region:'center',
		  id:'tabPanel',
		  deferredRender:false,
		  enableTabScroll:true,
		  autoScroll:false,
		  activeTab:0,
		  items:[labelPanel]
		});
	
		addTab(contentPanel,'/base/label/labelcustomlist.jsp','自定义标签','page_white_code_red');

       var viewport = new Ext.Viewport({
           layout: 'border',
           items: [contentPanel]
       });
         store.baseParams.language=document.getElementById('language').value;
       store.load({params:{start:0, limit:20}});
       dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '关闭',
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
<div id="pagemenubar" ></div>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=search" name="EweaverForm" method="post" id="EweaverForm">
			<table>
				<tr>
					<td class="FieldName">
						<%=labelService.getLabelName("402881e60aabb6f6010aabbdcc70000a")%>:
					</td>
					<td class="FieldValue">
						<input type="text" name="id" value='<%=label==null?"":label.getId()%>' />
					</td>

					<td class="FieldName">
						<%=labelService.getLabelName("402881e60aabb6f6010aabbe161b000b")%>:
					</td>
					<td class="FieldValue">
						<input type="text" name="labelname" value='<%=label==null?"":label.getLabelname()%>' />
					</td>

					<td class="FieldName">
						关键字:
					</td>
					<td class="FieldValue">
						<input type="text" name="keyword" value='<%=label==null?"":label.getKeyword()%>' />
					</td>
                    <td class="FieldName">
                      语言
					</td>
					<td class="FieldValue">
					<select id="language" name="language" onchange="onSearch()">
                        <%
                            List selectitemlist=selectitemService.getSelectitemList2("4028803522c5ca070122c5d78b8f0002",null);//从select字段中获取语言种类
                            for(int i=0;i<selectitemlist.size();i++){
                                Selectitem setitem=(Selectitem)selectitemlist.get(i);
                            %>
                             <option value="<%=setitem.getObjname()%>"><%=setitem.getObjdesc()%></option>
                           <% } %>
					</select>
					</td>
				</tr>
			</table>

		</form>
   </div>
<script language="javascript" type="text/javascript">

   function onPopup(url){
       var url=encodeURI(url);
        this.dlg0.getComponent('dlgpanel').setSrc(url);
      this.dlg0.show()
   }
    function onReset() {
         $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').val('');
         $('#EweaverForm select').val('');

       }
    function onSearch(){
     var o = $('#EweaverForm').serializeArray();
      var data = {};
      for (var i = 0; i < o.length; i++) {
          if (o[i].value != null && o[i].value != "") {
              data[o[i].name] = o[i].value;
          }
      }
      store.baseParams = data;
      store.load({params:{start:0, limit:20}});
   }
   $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch();
       }
   });
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
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=delete',
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

 </script>
	</body>
</html>

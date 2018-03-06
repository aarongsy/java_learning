<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.lang.String"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.util.FormfieldTranslate"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%
    String id = request.getParameter("forminfoid");
    Forminfo forminfo = ((ForminfoService) BaseContext.getBean("forminfoService")).getForminfoById(id);
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a", null);
    Selectitem selectitem;
    String selectItemId = forminfo.getSelectitemid();
    String action = request.getContextPath() + "/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=getformfieldlist&id=" + id + "&isexcel=1";
    String actionExcel= request.getContextPath() + "/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=formfieldExcel&id=" + id;
    pagemenustr += "addBtn(tb,'保存','S','accept',function(){saveexcelfield('"+id+"')});";

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
      Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
      var store;
      var selected = new Array();
      var dlg0;
      var grid;
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
                  fields: ['fieldname','htmltype','fieldtype','fieldattr','fieldcheck','labelname','formlabelname','only','needlog','id','selurl','refurl','fieldtype1','isexcel','excelordernum']
              }),
              remoteSort: true
          });
          var sm = new Ext.grid.CheckboxSelectionModel();
          sm.handleMouseDown = Ext.emptyFn;
          var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96212bc80009") %>", sortable: false,  dataIndex: 'fieldname'},//字段名称
              {header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc55f035001a") %>", sortable: false,    dataIndex: 'formlabelname'},//显示名称
              {header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b9621ab87000a") %>", sortable: false,    dataIndex: 'htmltype'},//表现形式
              {header: "<%=labelService.getLabelNameByKeyId("402883f83b1ba447013b1ba4486f0000") %>", sortable: false,    dataIndex: 'excelordernum',editor: new Ext.form.TextField({
                   allowBlank: true
               })}//导出顺序
          ]);
          cm.defaultSortable = true;
          grid = new Ext.grid.EditorGridPanel({
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
                                   }

          });


          //Viewport
          store.on('load',function(st,recs){
                 for(var i=0;i<recs.length;i++){
                     var isexcel=recs[i].get('isexcel');
                     if(isexcel==1){
                          sm.selectRecords([recs[i]],true);
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
      
      function initSelected(){
    	  selected=new Array();
    	  var sm=grid.getSelectionModel();
    	  if(sm.hasSelection()){
    		  var sel=sm.getSelections();
    		  for(var i=0;i<sel.length;i++){
    			  var rec=sel[i];
    			  selected.push(rec.get('id')+";"+rec.get('excelordernum'));
    		  }
    	  }
      }
      </script>

  </head>

  <body>
  <div id="divSearch">
      <div id="pagemenubar"></div>          
  </div>
  <script type="text/javascript">
   function saveexcelfield(formid) {
	   initSelected();
       Ext.Ajax.request({
           url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=saveformfieldExcel',
           params:{ids:selected.toString(),formid:'<%=id%>'},
           success: function() {
             Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3937005d") %>',function(btn,text){//导入导出字段已成功保存！
                 if(btn=='ok'){
                       store.load({params:{start:0, limit:20}});
                 }

             });


           }
       });
   }
  </script>
  </body>
</html>

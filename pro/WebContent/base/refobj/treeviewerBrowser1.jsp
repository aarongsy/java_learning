<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<jsp:useBean id="forminfoService" class="com.eweaver.workflow.form.service.ForminfoService" />
<%
  String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?action=browser1";
%>
 <%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'清除','C','cancel',function(){onClear()});";
   pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";

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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
    <script language="javascript">
    Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='加载...';
    var store;
    var selected = new Array();
    var dlg0;
    var dlgtree;
    var nodeid;

     var  moduleTree
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
                fields: ['title','viewtypename','treetypename','formname','id']


            })

        });
        var sm = new Ext.grid.CheckboxSelectionModel();

        var cm = new Ext.grid.ColumnModel([{header: "标题", sortable: false,  dataIndex: 'title'},
            {header: "树形类别", sortable: false,   dataIndex: 'treetypename'},
            {header: "树显示类型",  sortable: false, dataIndex: 'viewtypename'},
            {header: "表名",  sortable: false,dataIndex: 'formname'}
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
           sm.on('rowselect',function(selMdl,rowIndex,rec ){
               getArray(rec.get('id'),rec.get('title'));

           });


        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        store.load({params:{start:0, limit:20}});
    });
    </script>
   <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
    </head>

  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
      </div>

<script language="javascript">
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
  function getBrowser(viewurl, inputname, inputspan, isneed) {
          var id;
          try {
              id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
          } catch(e) {
          }
          if (id != null) {
              if (id[0] != '0') {
                  document.all(inputname).value = id[0];
                  document.all(inputspan).innerHTML = id[1];
              } else {
                  document.all(inputname).value = '';
                  if (isneed == '0')
                      document.all(inputspan).innerHTML = '';
                  else
                      document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

              }
          }
      }

</script>
  <script language=vbs>
    Sub onClear
        getArray "0",""
     End Sub

     Sub onReturn
        window.parent.Close
     End Sub
      </script>
  <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>



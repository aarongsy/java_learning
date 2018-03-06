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
String name=StringHelper.null2String(request.getParameter("name"));
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.sequence.SequenceAction?action=getsequencelist";
%>
 <%
    //pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
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

        Ext.LoadMask.prototype.msg='加载中,请稍后...';
           var store;
           var selected=new Array();
           var dlg0;
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
                     fields: ['name','description','startno','incrementno','modify','id']

               })

           });
           //store.setDefaultSort('id', 'desc');

           var sm=new Ext.grid.CheckboxSelectionModel();

           var cm = new Ext.grid.ColumnModel([sm, {header: "名称", width:100, sortable: false,  dataIndex: 'name'},
                       {header: "描述", sortable: false, width:500 ,dataIndex: 'description'},
                       {header: "初始值", width:50, sortable: false, dataIndex: 'startno'},
                       {header: "增量", width:50, sortable: false, dataIndex: 'incrementno'}
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

               
  sm.on('rowselect',function(selMdl,rowIndex,rec ){
              getArray(rec.get('id'),rec.get('name'));
  });


           //Viewport
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
       <form action="" name="EweaverForm"  method="post">
	   <input type="hidden" name="searchName" value="">
	   <table id=searchTable>
	       <tr>
	         <td class="FieldName" width=5% nowrap>
				 <%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%>:
			 </td>
	    	<td width="80%">&nbsp;&nbsp;<input id="name" class="infoinput" name="inputText" type="text" size="10" value="<%=name%>">
	    	<input type="button" name="Button" value="<%=labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004") %>" onClick="javascript:onSearch();"></td>
	     </tr>
	   </table>
	 </form>
  </div>

<script language="javascript">
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
    function onSearch(){
	    var name = document.getElementById("name").value;
	    store.baseParams.name = name;
	    store.load({params:{start:0, limit:20}});
	    event.srcElement.disabled = false;
	}

   $(document).keydown(function(event) {
       if (event.keyCode == 13) {
    	   document.getElementById("name").blur();
           onSearch();
       }
   });
</script>
  </body>
</html>



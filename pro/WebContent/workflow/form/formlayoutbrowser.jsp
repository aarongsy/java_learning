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
    String action = request.getContextPath() + "/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=getformlayoutlist";
    ForminfoService fs = (ForminfoService) BaseContext.getBean("forminfoService");
%>
 <%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','cancel',function(){onClear()});";//清除
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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
    <script language="javascript">
    Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
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
                  fields: ['layoutname','formlayouttype','modify','del','id','attr','formname']


              })

          });
        var sm = new Ext.grid.CheckboxSelectionModel();

          var cm = new Ext.grid.ColumnModel([ {header: "<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf3138d0002") %>",  sortable: false,  dataIndex: 'layoutname'},//应用对象
              {header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71eddb260038") %>", sortable: false,   dataIndex: 'formlayouttype'}//布局类型

          ]);
          cm.defaultSortable = true;
          var grid = new Ext.grid.GridPanel({
              region: 'center',
              store: store,
              cm: cm,
              sm:sm ,
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
                                   }

          });
        //Viewport
           sm.on('rowselect',function(selMdl,rowIndex,rec ){
               var str=rec.get('layoutname')+'('+rec.get('formname')+')';
               getArray(rec.get('id'),str);

           });


        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        store.baseParams.id = '402881e50bff706e010bff7fd5640006';//文档表的id
        store.load({params:{start:0, limit:20}});
    });
    </script>
   <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
    </head>

  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=searchbrowser" name="EweaverForm" id="EweaverForm" target="_self" method="post">
	   <table id=searchTable>
	     <colgroup>
		   <col width="20%">
		   <col width="80%">

		</colgroup>
       <tr>
         	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %><!-- 表单名称 --></td>
           <td class="FieldValue">
               <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/form/forminfobrowser.jsp','formid','formidspan','1');"></button>
                         <input type="hidden"   name="formid" value="" />
                         <span id = "formidspan" >
                           
                         </span>
           </td>
       </tr>
   </table>
			<br>

		</form>
      </div>

<script language="javascript">
function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
            }
         }
 }
   function onSearch()
  {
    var formid=document.all('formid').value;
      store.baseParams.id=formid;
      store.load({params:{start:0, limit:20}});
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



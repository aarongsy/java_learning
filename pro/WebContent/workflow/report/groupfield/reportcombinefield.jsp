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
<%@ page import="com.eweaver.workflow.report.service.CombinefieldService" %>
<%@ page import="com.eweaver.workflow.report.model.Combinefield" %>
<%
    response.setHeader("cache-control", "no-cache");
       response.setHeader("pragma", "no-cache");
       response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");    
      String reportid = StringHelper.null2String(request.getParameter("reportid"));
    String formid = StringHelper.null2String(request.getParameter("formid"));
    CombinefieldService combinefieldService=(CombinefieldService)BaseContext.getBean("combinefieldService");
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){savefield()});";//保存
    String action = request.getContextPath() + "/ServiceAction/com.eweaver.workflow.report.servlet.CombinefieldAction?action=getformfieldlist&reportid="+reportid+"&formid="+formid; 
   String hql="from Combinefield where reportid='"+reportid+"'";
    List list=combinefieldService.getCombinefieldList(hql);
    String objname="";
    if(list.size()>0){
        Combinefield combinefield=(Combinefield)list.get(0);
        objname=combinefield.getObjname();
    }


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
     
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>      
      <script language="javascript">
      Ext.SSL_SECURE_URL='about:blank';
      Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
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
                  fields: ['fieldname','labelname','objtablename','id']
              }),
              remoteSort: true
          });
          var sm = new Ext.grid.CheckboxSelectionModel();

          var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96212bc80009")%>", sortable: false,  dataIndex: 'fieldname'},//字段名称
              {header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b965dc554000c")%>", sortable: false,    dataIndex: 'labelname'},//显示名称    
              {header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006c")%>", sortable: false,    dataIndex: 'objtablename'}//表名
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
                                       sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                       sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                       columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                       getRowClass : function(record, rowIndex, p, store){
                                           return 'x-grid3-row-collapsed';
                                       }
                                   }

          });


          //Viewport
          store.on('load',function(st,recs){
              for (var i = 0; i < recs.length; i++) {
                  var id = recs[i].get('id');
                  Ext.Ajax.request({
                      url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.CombinefieldAction?action=checkedfield',
                      sync:true,
                      params:{formfieldid:id,reportid:'<%=reportid%>'},
                      success: function(res) {
                          if (res.responseText == 'true') {
                              sm.selectRecords([recs[i]], true);
                          }
                      }
                  });
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
      </script>

  </head>

  <body>
  <div id="divSearch">
      <div id="pagemenubar"></div>
       <table id=searchTable>    
       <tr>
          <td class="FieldName" width=20% nowrap>
			<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460000")%><!-- 组合字段名称 -->
		  </td>
		  <td class="FieldValue">
		     <input type="text" class="InputStyle2" style="width=60%" name="objname" value="<%=StringHelper.null2String(objname)%>"/>
		  </td>
	    </tr>

   </table>
      
  </div>
  <script type="text/javascript">
   function savefield(formid) {
     var objname=document.all('objname').value;
       Ext.Ajax.request({
           url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.CombinefieldAction?action=savecombinefield',
           params:{ids:selected.toString(),formid:'<%=formid%>',reportid:'<%=reportid%>',objname:objname},
           success: function() {
             Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460001")%>',function(btn,text){//组合字段已成功保存！
                 if(btn=='ok'){
                      location.href='<%=request.getContextPath()%>/workflow/report/groupfield/reportcombinefield.jsp?reportid=<%=reportid%>&formid=<%=formid%>';
                 }

             });


           }
       });
   }
  </script>
  </body>
</html>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.calendar.base.service.SchedulesetService" %>
<%@ page import="com.eweaver.calendar.base.model.Scheduleset" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.report.groupfield.service.GroupfieldService" %>
<%@ page import="com.eweaver.workflow.report.groupfield.model.Groupfield" %>
<%@ page import="com.eweaver.workflow.report.groupfield.model.Groupfielddetail" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
 String reportid=StringHelper.null2String(request.getParameter("reportid"));
    String groupid=StringHelper.null2String(request.getParameter("groupid"));
    GroupfieldService groupfieldService = (GroupfieldService)BaseContext.getBean("groupfieldService");
     Groupfield groupfield=groupfieldService.getGroupfield(groupid);
    String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.groupfield.servlet.GroupfieldAction?action=getreportsearchfield&reportid="+reportid+"";
%>
<%
     pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','D','accept',function(){onSubmit()});";//确定
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
      <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
      <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
      <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript">
          var store;
          var selected = new Array();
           <%
           if(!StringHelper.isEmpty(groupid)) {
           Set<Groupfielddetail> groupfielddetail=groupfield.getGroupfielddetail();
           for(Groupfielddetail detail:groupfielddetail){
           %>
          selected.push('<%=detail.getFieldid()%>');

          <% }
           }
          %>
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
               fields: ['formfieldname','labelname','formname','id']
           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();
       var cm = new Ext.grid.ColumnModel([sm, {header: "字段名", sortable: false,  dataIndex: 'formfieldname'},
           {header: "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0067")%>", sortable: false,   dataIndex: 'labelname'},//显示名
           {header: "<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460002")%>",  sortable: false, dataIndex: 'formname'}//表单名
       ]);
       cm.defaultSortable = true;
       var grid = new Ext.grid.GridPanel({
           renderTo: 'grid1',
           region: 'center',
           store: store,
           width:600,
           height:300,
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
                                    pageSize: 10,
                     store: store,
                     displayInfo: true,
                     beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                     afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                     firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                     prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                     nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                     lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                     displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示   条记录
                     emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
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
             store.load({params:{start:0, limit:10}});
        });
      </script>

  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
		<form action="../report" name="EweaverForm" method="post">
<table class=noborder>
<colgroup>
	<col width="150px">
	<col width="*">
</colgroup>
	<tr>
		<td class="FieldName" nowrap>
		<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460003")%><!-- 组名 -->
		</td>
		<td class="FieldValue">
		    <input type="text" name="groupname" id="groupname" class=inputstyle value="<%=StringHelper.null2String(groupfield.getGroupname())%>">
		</td>
	</tr>
	<tr >
		<td class="FieldName" nowrap>
		<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460004")%><!-- 关系 -->
		</td>
		<td class="FieldValue">
		   <select id="logic" name="logic" class="inputstyle" >
	                       <option value="0">or</option>
	                      <%--  <option value="1">and</option>--%>
		   </select>
		</td>
	</tr>
    <tr>
        <td><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460005")%></td><!-- 请选择组成关系的字段 -->
        <td>
            <div id="grid1"></div>
        </td>
    </tr>
    <tr >
        <td class="FieldName" nowrap>
            <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
        </td>
        <td class="FieldValue">
            <textarea rows="3" cols="50" id="description" name="description" ><%=StringHelper.null2String(groupfield.getDescription())%></textarea>
        </td>
    </tr>
</table>
</form>
<script language="javascript">
    function onSubmit(){
    var groupname=document.getElementById('groupname').value;
    var logic=document.getElementById('logic').value;
    var description=document.getElementById('description').value;
        if(selected.length==0||selected.length==1){
            Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};     // 确定      
         Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460006")%>');//请选择一个以上的字段！
            return;
            
        }
    Ext.Ajax.request({
    url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.groupfield.servlet.GroupfieldAction?action=creategroupfield&id=<%=groupid%>&reportid=<%=reportid%>',
    params:{ids:selected.toString(),groupname:groupname,description:description,logic:logic},
    success: function() {
      pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
    }
    });

    }
</script>
  </body>
</html>

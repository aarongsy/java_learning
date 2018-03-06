<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.base.security.model.Cardcombinationdetail" %>
<%@ page import="com.eweaver.customaction.service.CustomactionService" %>
<%@ page import="com.eweaver.customaction.model.Customaction" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    String actionid=StringHelper.null2String(request.getParameter("actionid"));
    String formid=StringHelper.null2String(request.getParameter("formid"));
  String action= request.getContextPath()+"/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=getdetails&actionid="+actionid;
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
    CustomactionService customactionService = (CustomactionService) BaseContext.getBean("customactionService");
    Customaction customaction=customactionService.getCustomaction(actionid);

%>

<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";
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
      a { color:blue; cursor:pointer; }
   </style>
   <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
     <script type="text/javascript">
         Ext.SSL_SECURE_URL='about:blank';
         Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
         var store;
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
                     fields: ['labelname','defvalue','del','id']


                 })

             });
             var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790049")%>", sortable: false,  dataIndex: 'labelname'},//字段显示名
                 {header: "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0063")%>", sortable: false,   dataIndex: 'defvalue'},//默认值
                 {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e")%>",  sortable: false, dataIndex: 'del'}//操作
             ]);
             var grid = new Ext.grid.GridPanel({
                 region: 'center',
                 store: store,
                 cm: cm,
                 trackMouseOver:false,
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
                                     tbar: [Ext.get('divadd').dom.innerHTML],
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
             store.load({params:{start:0, limit:20}});


             var viewport = new Ext.Viewport({
                 layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
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
  <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=modify" name="EweaverForm" method="post">
 <input type="hidden" name="actionid" value="<%=actionid%>">
<table>
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>
  <tr>
	<td valign=top>
		       <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
                    <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790048")%><!-- 操作名称 -->
					</td>
					<td class="FieldValue">
					    <input type="text" name="objname" id="objname" class=inputstyle value="<%=customaction.getObjname()%>">
					</td>
				</tr>
                   <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
					</td>
					<td class="FieldValue">
                        <%
                         if(StringHelper.isEmpty(customaction.getFormid())){
                        %>
                         <button type="button"  class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp','formid','formidspan','0');"></button>
                        <%}%>
                        <input type="hidden"  name="formid" id="formid" value="<%=StringHelper.null2String(customaction.getFormid())%>"/>
                                 <%
                                 Forminfo forminfo=forminfoService.getForminfoById(StringHelper.null2String(customaction.getFormid()));
                                 %>
                        <span id="formidspan"><%=StringHelper.null2String(forminfo.getObjname())%></span>
					</td>
				</tr>
		        <tr>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
                       </td>
                       <td class="FieldValue">
                         <textarea rows="5" cols="50" id="description" name="description" ><%=StringHelper.null2String(customaction.getDescription())%></textarea>
                       </td>
                   </tr>
</table>
</td>
    </tr>
    </table>
    </form>
  </div>
<div id="divadd">
    <table>
        <tr>
            <td><th colspan=2 nowrap><a onclick="add()"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290049")%><!-- 添加 --></a></th></td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    function add(){
        var url='/customaction/customactiondetailcreate.jsp?actionid=<%=StringHelper.null2String(customaction.getId())%>&formid=<%=customaction.getFormid()%>';
        this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
        this.dlg0.show();
    }
    function onModify(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show();
    }
    function onSubmit(){
         document.EweaverForm.submit();
    }
function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        var objname=document.getElementById("objname").value;
        try {
            id = openDialog(contextPath + '/base/popupmain.jsp?url=' + viewurl);
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
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
        }
    }
  function onReturn(){
      window.location="customactionlist.jsp";

  }
</script>
  </body>
</html>

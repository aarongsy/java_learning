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
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
 String reportid=StringHelper.null2String(request.getParameter("reportid"));
    String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.groupfield.servlet.GroupfieldAction?action=getgroupfieldlist&reportid="+reportid;
%>
<%
  pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onPopup('"+request.getContextPath()+"/workflow/report/groupfield/reportfieldorcreate.jsp?reportid="+reportid+"')});";
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
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
          var store;
          var dlg0;
         Ext.onReady(function() {
             var xg = Ext.grid;
       Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%>

                var reader=new Ext.data.JsonReader({
            root:'result',
            totalProperty:'totalcount',
            fields:['fieldname','groupname','formname','labelname',
                    'id','groupid' ]
        });

             var store=new Ext.data.GroupingStore({
            id:'GroupStore',
            reader: reader,
            remoteSort:true,
            sortInfo:{field: 'fieldname', direction: 'ASC'},
            groupField:'groupid',
            proxy:new Ext.data.HttpProxy({
                url:'<%=action%>',
                autoAbort:true,  
                disableCaching:true,
                timeout:180000,
                method:'POST'
            })
        });
        store.load();
                   var grid = new Ext.grid.GridPanel({
                       store: store,                          
                       region: 'center',
                       columns: [
                           {header: "groupid", hidden : true, sortable: true, dataIndex: 'groupid'},
                           {id:'id',header: "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0061")%>", width: 60, sortable: true, dataIndex: 'fieldname'},//字段名
                           {header: "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0067")%>", width: 20, sortable: true,dataIndex: 'labelname'},//显示名
                           {header: "<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460002")%>", width: 20, sortable: true, dataIndex: 'formname'},//表单名
                           {header: "<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460003")%>", width: 20, sortable: true, dataIndex: 'groupname'}//组名

                           ],
                       view: new Ext.grid.GroupingView({
                               forceFit:true,
                               startCollapsed:true,
							   sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                               sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
							   groupByText:'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0064")%>',//按此列分组
							   showGroupsText:'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0065")%>',//分组显示
                               columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                               groupTextTpl: '{[values.rs[0].get("groupname")]}     <a  id="{text}" onclick="getGroupid(this)"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%></a>   <a  id="{text}" onclick="modify(this)"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b7750a15b000b")%></a>  '
                           }),//删除   编辑
                       frame:true,
                           collapsible: false,
                           animCollapse: true,
                           //title: '列表',
                           iconCls: 'icon-grid'

    });


    //Viewport
    //ie6 bug



          var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	});
        dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width: 780,
           height:(Ext.getBody().getHeight() * 0.8),
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
                   store.load();
                   
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
      </div>
  </body>
<script type="text/javascript">
       function onPopup(url){
         //document.EweaverForm.submit();
          this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()
     }
    function getGroupid(obj)
    {
        var  groupid=obj.id.substring(8);
        Ext.Ajax.request({
           url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.groupfield.servlet.GroupfieldAction?action=del&groupid='+groupid,
           success: function() {
             pop( '<%=labelService.getLabelNameByKeyId("402883d934c1aae90134c1aae9d80000")%>');//删除成功！
             this.location.href="<%=request.getContextPath()%>/workflow/report/groupfield/reportfieldorlist.jsp?reportid=<%=reportid%>";
           }
           });

    }
    function modify(obj){
        var groupid = obj.id.substring(8);
        var url='<%=request.getContextPath()%>/workflow/report/groupfield/reportfieldorcreate.jsp?reportid=<%=reportid%>&groupid='+groupid;
         this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()


    }
</script>
</html>

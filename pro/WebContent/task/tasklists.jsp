<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.calendar.base.model.CalendarSetting"  %>
<%@ page import="com.eweaver.calendar.base.service.SchedulesetService" %>
<%@ page import="com.eweaver.calendar.base.model.Scheduleset" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
 String action = request.getContextPath()+"/ServiceAction/com.eweaver.task.servlet.TaskModelAction?action=list";
 String id = request.getParameter("id");
  pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834035424d660135424d67130011")+"','C','add',function(){onPopup('"+request.getContextPath()+"/task/taskmodify.jsp')});";//新增规则
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834035424d660135424d67130012")+"','C','add',function(){onPopup('"+request.getContextPath()+"/task/jobtaskmodify.jsp')});";//新增工作任务
  
    	  pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onOperate('delete')});";//删除
    	   pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0008")+"','D','delete',function(){onOperate('start')});";//开始
    	    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834035424d660135424d67130013")+"','D','delete',function(){onOperate('pause')});";//暂停
    	    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834035424d660135424d67130014")+"','D','delete',function(){onOperate('stop')});";//停止
 %>
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
		<title><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130015") %><!-- 任务列表 --></title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript">
		var store;
   		var dlg0;
   		var selected = new Array();
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
               fields: ['taskName','status','id','view']
           })
       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, 
           {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006") %>", sortable: false,  dataIndex: 'taskName'},//任务名称
           {header: "<%=labelService.getLabelNameByKeyId("402881ea0cc094ad010cc09ec149000b") %>", sortable: false,   dataIndex: 'status'},//任务状态
           {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %>",  sortable: false, dataIndex: 'view'}//操作
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
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>',//取消
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
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
       
		})		
		</script>
	</head>
	<%
	 
	 %>
	<body>
	<div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div>
	</body>
	<script type="text/javascript">  
	 function onPopup(url){
          this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()
     }
	
	  function onModify(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show()   
      }
      
 
 
function onOperate(opt) {
	var msg = '';
	var action = '';
	if(opt == 'delete') {
		msg = '<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>';//删除
		action = 'delete';
	} else if(opt == 'stop') {
		msg = '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130014") %>';//停止
		action = 'stop';
	} else if(opt == 'pause') {
		msg = '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130013") %>';//暂停
		action = 'pause';
	} else if(opt == 'start') {
		msg = '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0008") %>';//开始
		action = 'start';
	}
   if (selected.length == 0) {
       Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
       Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130016") %>'+msg+'<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130017") %>');//请选择要   的内容！
       return;
   }
   Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是  否
   Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130018") %>'+msg+'<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130019") %>?', function (btn, text) {//您确定要    吗
   if (btn == 'yes') {
      Ext.Ajax.request({
          url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.task.servlet.TaskModelAction?action='+opt,
          params:{ids:selected.toString()},
          success: function() {
                    selected = [];
                    store.load({params:{start:0, limit:20}});
                    }
                    });
                     }
     });

  }	
  
    function onOperateOne(opt,id) {
	    var msg = '';
	var action = '';
	if(opt == 'delete') {
		msg = '<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>';//删除
		action = 'delete';
	} else if(opt == 'stop') {
		msg = '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130014") %>';//停止
		action = 'stop';
	} else if(opt == 'pause') {
		msg = '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130013") %>';//暂停
		action = 'pause';
	} else if(opt == 'start') {
		msg = '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0008") %>';//开始
		action = 'start';
	}
   Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};
   Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130018") %>'+msg+'<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67130019") %>?', function (btn, text) {
   if (btn == 'yes') {
      Ext.Ajax.request({
          url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.task.servlet.TaskModelAction?action='+action,
          params:{ids:id},
          success: function() {
                    store.load({params:{start:0, limit:20}});
                    }
                    });
                     }
     });
  }
  
	function onSubmit() {
		EweaverForm.submit();
	}

</script>
</html>

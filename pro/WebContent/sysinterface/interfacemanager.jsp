<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo" %>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%
  String rootid="r00t";

String roottext=labelService.getLabelNameByKeyId("402881e70b65f558010b65f9d4d40003");//系统模块
String tagetUrl = "categorymodify.jsp?id=";
String createUrl = "categorycreate.jsp";
NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");

String objtype = StringHelper.null2String(request.getParameter("objtype"));
String objid = StringHelper.null2String(request.getParameter("objid"));
String action = request.getContextPath()+"/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=loadlist&objid="+objid;
pagemenustr += "addBtn(tb,'保存','S','accept',function(){onSubmit()});";
pagemenustr += "addBtn(tb,'刷新','S','accept',function(){onReload()});";
String actiontypestr= "['0','保存'],['1','提交'],['4','退回'],['3','撤回'],['2','提交到达'],['5','撤回到达'],['6','退回到达'],['7','干预到达'],['9','提交离开']";
if("node".equalsIgnoreCase(objtype) && !StringHelper.isEmpty(objid)) {
	Nodeinfo nodeinfo = nodeinfoService.get(objid);
	Integer nodetype = nodeinfo.getNodetype();	
	if(nodetype!= null && 1== nodetype) {
		actiontypestr = "['0','保存'],['10','删除'],['1','提交'],['5','撤回到达'],['6','退回到达'],['7','干预到达']";
	} else if(nodetype!= null && 4== nodetype) {
	    actiontypestr = "['0','保存'],['2','提交到达'],['7','干预到达']";
	}
} else if("category".equalsIgnoreCase(objtype) && !StringHelper.isEmpty(objid)) {
	actiontypestr = "['0','保存'],['11','新建'],['12','修改'],['10','删除']";
}
%>

<html>
  <head>
 
 	<script src='/dwr/interface/DataService.js'></script>
    <script src='/dwr/engine.js'></script>
    <script src='/dwr/util.js'></script>
  	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
    <title>接口配置</title>   
    <link href="/js/jquery/plugins/asyncbox/skins/ZCMS/asyncbox.css" type="text/css" rel="stylesheet" />   
    <script src="/js/jquery/1.6.2/jquery.min.js"/></script>
  	<script src="/js/jquery/1.6.2/jq.eweaver.js"/></script> 	
  	<script src="/js/jquery/plugins/asyncbox/AsyncBox.v1.4.js"/></script>
  	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  	
  	 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/columnLock.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/columnLock.css"/>
  	<base target="_self">
  <style type="text/css">
       .x-toolbar table {width:0}
      .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <script language="javascript">
	
	var objid = '<%=objid%>';
	var objtype = '<%=objtype%>';
	Ext.SSL_SECURE_URL='about:blank';
  	var store;
   	var dlg0;
   	var selected = new Array();
   	
	function onDelete(linkid){
		if(confirm('确实要删除此项吗?')){    
		     Ext.Ajax.request({
	              url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=deleteLink',
	              params:{linkid:linkid},
	              success: function(res) {
	                  store.load({params:{start:0, limit:20}});
	              }
	          });
		}	 
   }
         function onSubmit() {
          var myMask = new Ext.LoadMask(Ext.getBody());
          records = store.getModifiedRecords();
          datas = new Array();
          if(records.length==0){
              alert('无记录被修改!');
              return;
          }
          for (i = 0; i < records.length; i++) {             
              datas.push(records[i].data);
          }        
          var jsonstr = Ext.util.JSON.encode(datas);
          //alert(jsonstr);
          myMask.show();
          Ext.Ajax.request({
              url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=saveLink',
              params:{jsonstr:jsonstr,objid:'<%=objid%>'},
              success: function(res) {
                  myMask.hide();
                  //alert((res.responseText));
                  if(res.responseText == '1') {
                      alert('保存成功');
                      store.load({params:{start:0, limit:20}});
                  } else {
                      alert('保存失败');
                  }
              }
          });
      }
      
      function onReload() {
          store.load({params:{start:0, limit:20}});      
      }
   function onEdit(id) {
	   var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=view&id='+id+'&objid='+objid+'&objtype='+objtype;
	   categoryframe.location=url;
   }
   function onAdd() {
	   var url = '/sysinterface/interfaceAdd.jsp?objid='+objid+'&objtype='+objtype;
	   categoryframe.location=url;
   }
   function createInterface(pid) {
        var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=direct&objtype='+objtype+'&objid='+objid+'&pid=' + pid
        categoryframe.location=url;
   }
   
   function loadInterfaceMenu() {
   		Ext.Ajax.request({
          url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=menu',
          params:{objid:objid,
                  objtype:objtype
                 },
          success: function(response) {
                   var data = response.responseText;
                   //alert(data);
                   var jmenu = Ext.util.JSON.decode(response.responseText);
                   tb.add(jmenu);
                   tb.add(Ext.util.JSON.decode('{text:\'添加\',handler:function(){onAdd()}}'));
                   tb.add(Ext.util.JSON.decode('{text:\'保存\',handler:function(){onSubmit()}}'));
                   tb.add(Ext.util.JSON.decode('{text:\'刷新\',handler:function(){onReload()}}'));
                    }
                    });
  }
</script>
  <script type="text/javascript">
        var tb = new Ext.Toolbar();
   		var actiontypestore=new Ext.data.SimpleStore({
               id:0,
               fields:['value', 'text'],
               data: [<%=actiontypestr%>]
           });
        var turnstore=new Ext.data.SimpleStore({
               id:0,
               fields:['value', 'text'],
               data: [['0','否'],['1','是']]
           });   
        function actiontypeRender(value, m, record, rowIndex, colIndex){
           var iscombox=actiontypestore.getById(value);
	       if (typeof(iscombox) == "undefined")	
	           return ''
	       else
	           return iscombox.get('text');
        }
         function turnRender(value, m, record, rowIndex, colIndex){
           var iscombox=turnstore.getById(value);
	       if (typeof(iscombox) == "undefined")	
	           return ''
	       else
	           return iscombox.get('text');
        }
		Ext.onReady(function() {
		Ext.QuickTips.init();    
       // tb.render('pagemenubar');
       
        var fm = Ext.form;
		 store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['objname','actiontype','isturnon','id','opthref','linkid']
           })
       });
       var sm = new Ext.grid.CheckboxSelectionModel();      
       var cm = new Ext.grid.LockingColumnModel([
              sm,
           {
              id:'objname',
               header: "接口名称",//字段名称
               dataIndex: 'objname',
               locked:true,
               width:100
           },{
               header: '触发类型',
               dataIndex: 'actiontype',
               width:100,
               renderer:actiontypeRender
           },{
               header: '是否启用',
               dataIndex: 'isturnon',
               width:100,
               renderer:turnRender
           },{
             header: "操作",
             dataIndex: 'opthref',
             width:100,
             locked:true
          }
          ,{
             header: "id",
             dataIndex:'id',
              hidden:true
          }
          ,{
             header: "linkid",
             dataIndex:'linkid',
              hidden:true
          }
      ]);
       
       cm.defaultSortable = true;
       var grid = new Ext.grid.EditorGridPanel({
           
            region:'west',
            width:380,
            split:true,
           store: store,
           tbar :tb,
           cm: cm,
           sm:sm ,
           frame: true,
           clicksToEdit: 1,
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
       //tb.add(Ext.util.JSON.decode('{text:\'保存\',handler:function(){onSubmit()}}'));
       loadInterfaceMenu();
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
                  
                  /**
          sm.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('id');
               onEdit(reqid);
               
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
          
                  );**/
                                   
                  grid.on("cellclick",function (grid, rowIndex, columnIndex, e) {
	                  if(columnIndex==2){
	                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
			                  typeAhead: true,
			                  triggerAction: 'all',
			                  store:actiontypestore,
			                  mode: 'local',
			                  valueField:'value',
			                  displayField:'text',
			                  lazyRender:true,
			                  listClass: 'x-combo-list-small'
		                  })));
	                   }
                   if(columnIndex==3){
	                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
			                  typeAhead: true,
			                  triggerAction: 'all',
			                  store:turnstore,
			                  mode: 'local',
			                  valueField:'value',
			                  displayField:'text',
			                  lazyRender:true,
			                  listClass: 'x-combo-list-small'
		                  })));
	                   }
                   });
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid,
                {
                title: '接口配置',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'categoryframe', name:'categoryframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});
	
	store.load({params:{start:0, limit:20}});
  });
      
  
  </script>

  </head> 	
  <body >	
  <script>Ext.BLANK_IMAGE_URL = '<%= request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div>
  </body>
</html>

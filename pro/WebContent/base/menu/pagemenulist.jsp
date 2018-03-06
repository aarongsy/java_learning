<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.menu.servlet.*"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu" %>

<%
  String rootid="r00t";
String roottext="系统模块";
    String view="sfsd";
PagemenuService pagemenuService=(PagemenuService)BaseContext.getBean("pagemenuService");
Pagemenu pagemenu=null;
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=getpagemenulist";
    String  actiontree=request.getContextPath()+"/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=getpagemenulisttree";
String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
if(!StringHelper.isEmpty(moduleid))
action=request.getContextPath()+"/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=getpagemenulist&moduleid="+moduleid;
%>
<%
if(!StringHelper.isEmpty(moduleid))
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onCreate('"+request.getContextPath()+"/base/menu/pagemenucreate.jsp?moduleid="+moduleid+"')});";

pagemenustr +="addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSubmit()});";
pagemenustr +="addBtn(tb,'清空条件','R','erase',function(){onReset()});";
    pagemenustr+="addBtn(tb,'移动','X','cut',function(){onMove()});";
    pagemenustr+="addBtn(tb,'复制','D','page_copy',function(){onCopy()});";


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
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/TreeGrid.css"/>
 
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
   <script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/ux/TreeGrid.js'></script>

   <script language="javascript">
   var currentid;
   var currentmoduleid=new Array();
   Ext.SSL_SECURE_URL='about:blank';
   Ext.LoadMask.prototype.msg='加载...';
   var store;
   var selected = new Array();
   var dlg0;
    var dlgtree;
   var nodeid;
    var  moduleTree
   var grid ;
   Ext.onReady(function() {
       Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%>
       var sm = new Ext.grid.CheckboxSelectionModel();
       <%if(!view.equals("树形")){%>
       store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['showname','pageprop','accesskey','objid','objtable','righttype','dsporder','isshow','tourl','modulename','id','moduleid']


           })

       });

       var cm = new Ext.grid.ColumnModel([sm, {header: "扩展名称", width:100, sortable: false,  dataIndex: 'showname'},
           {header: "链接源", sortable: false, width:200,   dataIndex: 'pageprop'},
           /*{header: "Accesskey",  sortable: false,width:50, dataIndex: 'accesskey'},
           {header: "ObjId",  sortable: false, width:50,dataIndex: 'objid'},
           {header: "ObjTable",  sortable: false,width:50, dataIndex: 'objtable'},
           {header: "RightType",  sortable: false,width:50, dataIndex: 'righttype'},
           {header: "DspOrder",  sortable: false, width:50,dataIndex: 'dsporder'},*/
           {header: "是否显示",  sortable: false,width:50, dataIndex: 'isshow'},
           {header: "链接目标",  sortable: false,width:300, dataIndex: 'tourl'},
           {header: "模块名称",  sortable: false,width:100, dataIndex: 'modulename'}
       ]);
       cm.defaultSortable = true;
        grid = new Ext.grid.GridPanel({
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
     <%}else{%>
       store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
    	autoLoad : true,
    	url: '<%=actiontree%>',
			reader: new Ext.data.JsonReader(
				{
					id: '_id',
					root: 'result',
					totalProperty: 'totalCount',
                    fields: ['showname','pageprop','accesskey','objid','objtable','righttype','dsporder','isshow','tourl','modulename','id','moduleid']
                }),
        remoteSort: true
        });
           var cm = new Ext.grid.ColumnModel([{header: "扩展名称", width:100, sortable: false,  dataIndex: 'showname'},
           {header: "链接源", sortable: false, width:200,   dataIndex: 'pageprop'},
           /*{header: "Accesskey",  sortable: false,width:50, dataIndex: 'accesskey'},
           {header: "ObjId",  sortable: false, width:50,dataIndex: 'objid'},
           {header: "ObjTable",  sortable: false,width:50, dataIndex: 'objtable'},
           {header: "RightType",  sortable: false,width:50, dataIndex: 'righttype'},
           {header: "DspOrder",  sortable: false, width:50,dataIndex: 'dsporder'},*/
           {header: "是否显示",  sortable: false,width:50, dataIndex: 'isshow'},
           {header: "链接目标",  sortable: false,width:300, dataIndex: 'tourl'},
           {header: "模块名称",  sortable: false,width:100, dataIndex: 'modulename'}
       ]);
       cm.defaultSortable = true;

  grid = new Ext.ux.maximgb.treegrid.GridPanel({
      region: 'center',
      store: store,
      master_column_id : 'pageprop',
      cm: cm,
      stripeRows: true,
      autoExpandColumn: 'pageprop',
      loadMask: true,
    trackMouseOver:false,
      viewConfig: {
         enableRowBody:true
     },
      bbar: new Ext.ux.maximgb.treegrid.PagingToolbar({
          store: store,
          displayInfo: true,
          beforePageText:"第",
          afterPageText:"页/{0}",
          firstText:"第一页",
          prevText:"上页",
          nextText:"下页",
          lastText:"最后页",
          refreshText:"刷新",
          displayMsg: '显示 {0} - {1}条记录 / {2}',
          emptyMsg: "没有结果返回",
          pageSize:20
      })
    });
      <%}%>
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
                });
       
                sm.on('rowselect',function(selMdl,rowIndex,rec ){
                    var reqid=rec.get('id');
                    currentid=rec.get('id');
                    for(var i=0;i<selected.length;i++){
                        if(reqid ==selected[i]){
                            return;
                        }
                    }
                    selected.push(reqid);
                    currentmoduleid.push(rec.get('moduleid'));
                });
                
                sm.on('rowdeselect',function(selMdl,rowIndex,rec){
                    var reqid=rec.get('id');
                    currentid='';
                    for(var i=0;i<selected.length;i++){
	                    if(reqid ==selected[i]){
	                        selected.remove(reqid);
	                        currentmoduleid.remove(rec.get('moduleid'));
	                        return;
	                    }
                    }
                });

       var viewport = new Ext.Viewport({
           layout: 'border',
           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
       });
       store.load({params:{start:0, limit:20}});

       moduleTree = new Ext.tree.TreePanel({
           // animate:true,
            //title: '&nbsp;',
             checkModel: 'single',
            animate: false,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            //lines:true,
            region:'center',
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottext%>',
                id:'<%=rootid%>',
                iconCls:'pkg',
                expanded:true,
                hrefTarget:'moduleframe',
                href:'<%=request.getContextPath()%>/base/module/modulemodify.jsp',
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig&isonlytree=1",
            preloadChildren:false,
             baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
        }
                )
    });
    moduleTree.on('checkchange',function(n,c){
     nodeid=n.id ;
    })
       dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '关闭',
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


        dlgtree = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.4,
           height:viewport.getSize().height * 0.4,
           buttons: [{
               text     : '确定',
               handler  : function() {
                   this.disable();
                   Ext.Ajax.request({
                                           url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=move',
                                                params:{ids:selected.toString(),nodeid:nodeid},
                                               success: function() {
                                                   selected=[];
                                                   currentmoduleid=[];
                                                   this.dlgtree.hide();
                                                   onSubmit();
                                               }
                                           });


               }

           },{text     : '取消',
               handler  : function() {
                   dlgtree.hide();
               }
           }],
           items:[moduleTree]
       });
       dlgtree.render(Ext.getBody());
   });
   </script>
   <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
<!--页面菜单开始-->
<div id="divSearch">
<div id="pagemenubar"></div>
   <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=search" name="EweaverForm" id="EweaverForm" method="post">
   <table id=searchTable>
  <tr>
	<td valign=top>
		       <table class=noborder>	
   				<colgroup> 
					<col width="10%">
					<col width="30%">
					<col width="10%">
					<col width="30%">
				</colgroup>    
				<tr>
					<td class="FieldName" nowrap>
					扩展名称
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" width=95% name="showname"/>
					</td>
					<%
                  if(StringHelper.isEmpty(moduleid)){
                  %>
                       <td class="FieldName"  nowrap>
                           模块
                       </td>
                       <td class="FieldValue" >

                           <button type="button" class=Browser
                                   onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
                           <input type="hidden" name="moduleid" value=""/>
                           <span id="moduleidspan"></span>
                       </td>
                       <%}%>
				</tr>  
				<tr>
					<td class="FieldName" nowrap>
					链接源
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%"  name="pageprop"/>
					</td>
					<td class="FieldName" nowrap>
					链接目标
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%"  name="tourl"/>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
					关联表名
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objtable"/>
					</td>
					<td class="FieldName" nowrap>
					是否显示
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%"  name="isshow"/>
					</td>
				</tr>

				</table>
	</table>
 </form>
 </div>
<SCRIPT language="javascript">
     function onMove()
    {
       if (selected.length == 0) {
            Ext.MessageBox.alert('', '请选择要移除的内容！');
            return;
        }
         this.dlgtree.show();
    }
  function onSubmit(){
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
       $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSubmit();
       }
   });
  function onCreate(url){
     this.dlg0.getComponent('dlgpanel').setSrc(url);
     this.dlg0.show()
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
</SCRIPT>   
<script language="javascript" type="text/javascript">
    function onReset(){
   $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').val('');
         $('#EweaverForm select').val('');
    }
    function onCopy(){
        if(selected.toString()==''){
             Ext.MessageBox.alert('','请选择要复制的页面菜单!');
             return;
         }
         else if(selected.toString().indexOf(",")>-1){
         	Ext.MessageBox.alert('','只能选择一个页面菜单!');
             return;
         }

       this.location.href='<%=request.getContextPath()%>/base/menu/pagemenumodify.jsp?iscopy=1&id='+selected.toString()+'&copymoduleid='+currentmoduleid;
    }
</script>  
  </body>
</html>

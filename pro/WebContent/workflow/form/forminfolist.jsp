<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<jsp:useBean id="forminfoService" class="com.eweaver.workflow.form.service.ForminfoService" />
<%
  String rootid="r00t";
String roottext=labelService.getLabelNameByKeyId("402881e70b65f558010b65f9d4d40003");//系统模块
String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a",null);
 String view=StringHelper.null2String(request.getParameter("view"));
Selectitem selectitem;
Forminfo forminfo = (Forminfo) request.getAttribute("queryObject");
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=getforminfolisttree";
    String actionlist=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=getforminfolist";
    String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
if(!StringHelper.isEmpty(moduleid)){
    action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=getforminfolisttree&moduleid="+moduleid;
    actionlist=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=getforminfolist&moduleid="+moduleid;
}
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    if(!StringHelper.isEmpty(moduleid))
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onPopup('"+request.getContextPath()+"/workflow/form/forminfocreate.jsp?moduleid="+moduleid+"')});";
      if(!view.equals("tree")) {
          pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除
          pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934c1b7b70134c1b7b8860000")+"','X','cut',function(){onMove()});";//移动
      }


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
     .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
  </style>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/TreeGrid.css"/>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/examples/grid/RowExpander.js'></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/ux/TreeGrid.js'></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
   <script language="javascript">
   Ext.SSL_SECURE_URL = 'about:blank';
   Ext.LoadMask.prototype.msg = '<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
   var store;
   var selected = new Array();
   var dlg0;
   var dlgtree;
   var nodeid;
   var moduleTree;
   var grid;
   var sm = new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
   Ext.onReady(function() {
       Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');

   <%=pagemenustr%>
   <%}%>
        tb.add({
                id:'attachs',
                xtype: 'tbsplit',
                iconCls: Ext.ux.iconMgr.getIcon('application_view_list'),
                text: '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380071") %>',//视图切换
               menu:new Ext.menu.Menu({
                    id:'attachsmenu',
                    items: [
                        {
                            text:'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380072") %>',//树形显示
                            checked:true,
                            iconCls: Ext.ux.iconMgr.getIcon('shape_align_left'),
                            checkHandler :onItCheck
                        },{
                            text:'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380073") %>',//列表显示
                            checked:true,
                            iconCls: Ext.ux.iconMgr.getIcon('application_view_list'),
                           checkHandler :onItCheck
                        }
                    ]
                })
            }) ;
            <%if(!StringHelper.isEmpty(moduleid)){%>
            tb.add({
                id:'abstract',
                //xtype: 'tbsplit',
                iconCls: Ext.ux.iconMgr.getIcon('text_list_numbers'),
                text: '<%=labelService.getLabelNameByKeyId("402883de403278460140327846bc0000") %>',//新建抽象表单
                handler:onAbstract
            }) ;
            <%}%>
       <%
        if(!view.equals("tree")){
       %>
          store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=actionlist%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['objname','formtype','objtable','modify','modulename','id']


           })

       });
          var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %>", sortable: false, width:200, dataIndex: 'objname'},//表单名称
           {header: "<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c21eed0001") %>",  sortable: false, width:80, dataIndex: 'formtype'},//表单类型
           {header: "<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c3f9fc0002") %>",  sortable: false, width:120,dataIndex: 'objtable'},//数据库表名
           {header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380074") %>",  sortable: false, width:60, dataIndex: 'modify'},//动作
           {header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000") %>",  sortable: false, width:80, dataIndex: 'modulename'}//模块名称
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
		            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示  条记录
		            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>"
                 })

       });
       <%}else{%>
        store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
    	autoLoad : true,
    	url: '<%=action%>',
			reader: new Ext.data.JsonReader(
				{
					id: '_id',
					root: 'result',
					totalProperty: 'totalCount',
                    fields: ['_id','_parent','_is_leaf','objname','objtable','modify','modulename','formtype']
                }),
        remoteSort: true
        });
        var cm = new Ext.grid.ColumnModel([{id:'objname',header: "<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %>", sortable: false, width:200, dataIndex: 'objname'},//表单名称
           {header: "<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c21eed0001") %>",  sortable: false, width:80, dataIndex: 'formtype'},//表单类型
           {header: "<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c3f9fc0002") %>",  sortable: false, width:120,dataIndex: 'objtable'},//数据库表名
           {header: "&nbsp;",  sortable: false, width:60, dataIndex: 'modify'},
           {header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000") %>",  sortable: false, width:80, dataIndex: 'modulename'}//模块名称
       ]);
       cm.defaultSortable = true;

  grid = new Ext.ux.maximgb.treegrid.GridPanel({
      region: 'center',
      store: store,
      sm:sm,
      master_column_id : 'objname',
      cm: cm,
      stripeRows: true,
      autoExpandColumn: 'objname',
      loadMask: true,
    trackMouseOver:false,
      viewConfig: {
         enableRowBody:true
     },
      bbar: new Ext.ux.maximgb.treegrid.PagingToolbar({
          store: store,
          displayInfo: true,
          beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
          prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
          lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
          refreshText:"<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027") %>",//刷新
          displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示  条记录
          emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>",
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
          }
                  );
          sm.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                               return;
                           }
                       }
              selected.push(reqid);
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
           items: [{autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini',region:'north'},grid]
       });
       store.baseParams.selectItemId='<%=selectItemId%>' ;
       store.baseParams.moduleid = '<%=moduleid%>';
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
                href:'/base/module/modulemodify.jsp',
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
           buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>',//取消
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '关闭',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
                   selected = [];
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
               text: '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>',//确定
               handler  : function() {
                   this.disable();
                   Ext.Ajax.request({
                                           url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=move',
                                                params:{ids:selected.toString(),nodeid:nodeid},
                                               success: function() {
                                                   selected=[];
                                                   this.dlgtree.hide();
                                                   onSearch();
                                               }
                                           });
                   this.enable();



               }

           },{text: '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>',//取消
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
  <div id="divSearch" style="display:block">
     <div id="pagemenubar" style="z-index:100;"></div>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=search" name="EweaverForm" id="EweaverForm" method="post" onsubmit="return false">

		<input type="hidden" name="id" value='' />
		<input type="hidden" name="forminfo_id" value='' />
		<input type="hidden" name="objtype" value='' />
		   <table id=searchTable>
       <tr>
           <%if(StringHelper.isEmpty(moduleid)){%>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
		 </td>
         <td class="FieldValue">

              <select class="inputstyle" style='size:30;' id="selectitemid" name="selectitemid" onChange="javascript:onSearch();">
                  <option value="" <%=selectItemId==null?"selected":""%>></option>
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectitem.getId().equals(selectItemId)) selected = "selected";
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>

                   <%
                   } // end while
                   %>
		       </select>
          </td>
           <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("402883d934c1bfa30134c1bfa4540000") %><!-- 模块 -->
		 </td>
         <td class="FieldValue" width="15%">
              <button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden"  name="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
           <%}else{//当是具体模块时，分类名不显示%>

             <%}%>
          <td  class="FieldName" nowrap>
            <%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %><!-- 表单名称 -->
          </td>
          <td class="FieldValue">
             <input type="text" name= "tbname" id="tbname"/>
          </td>
	    </tr>

   </table>
		</form>
      </div>
  </body>
<script language="javascript" type="text/javascript">
function onMove(){
	if (selected.length == 0) {
		Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
		Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1c4290134c1c42a830000") %>');//请选择要移动的内容！
		return;
	}
	this.dlgtree.show();
}
function onPopup(url){
	//document.EweaverForm.submit();
	this.dlg0.getComponent('dlgpanel').setSrc(url);
	this.dlg0.show()
}
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
$(document).keydown(function(event) {
	if (event.keyCode == 13) {
		onSearch();
	}
});

function onAbstract(){
	if(selected.toString()==""){
		alert("<%=labelService.getLabelNameByKeyId("402883de4032a39a014032a39b330000") %>");//请选择实际表单！
		return;
	}else if(selected.length==1){
	  alert('至少选择两个以上实际表单 ');
	  return;
	}else{
		Ext.Ajax.request({
			url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=boolFormtype',
			params:{ids:selected.toString()},
			success: function(res) {
				if(res.responseText == 'false'){
					alert("<%=labelService.getLabelNameByKeyId("402883de4032a39a014032a39b330001") %>");//选择的表单必须是实际表单！
					return;
				}else{
					onPopup("<%=request.getContextPath() %>/workflow/form/abstractformcreate.jsp?moduleid=<%=moduleid %>&selected="+selected.toString());
				}
			}
		});
	}
}
function onDelete(){
	if (selected.length == 0) {
		Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
		Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000") %>');//请选择要删除的内容！
		return;
	}
	Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是  否                                 
	Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075") %>', function (btn, text) {//您确定要删除吗?
		if (btn == 'yes') {
			Ext.Ajax.request({
				url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=delete',
				params:{ids:selected.toString()},
				success: function(res) {
					if(res.responseText == 'nodel'){
						Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
						Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380076") %>',function(){}) ;//系统表不可删除
					}else{
						selected = [];
						store.load({params:{start:0, limit:20}});
					}
				}
			});
		} else {
			selected = [];
			store.load({params:{start:0, limit:20}});
		}
	});

}

//修改表单
function onModify(id){
	document.location = "<%=request.getContextPath()%>/workflow/form/forminfomodify.jsp?moduleid=<%=moduleid%>&id="+id;
}
//复制表单
function onClone(id){
	onPopup("<%=request.getContextPath()%>/workflow/form/forminfoClone.jsp?moduleid=<%=moduleid%>&id="+id);
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
function onItCheck(item,checked){
	if(item.text=="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380072") %>"){//树形显示
		document.location='<%=request.getContextPath()%>/workflow/form/forminfolist.jsp?view=tree&moduleid=<%=moduleid%>&selectitemid=<%=selectItemId%>';
	}else{
		document.location='<%=request.getContextPath()%>/workflow/form/forminfolist.jsp?moduleid=<%=moduleid%>&selectitemid=<%=selectItemId%>';
	}
}
</script>
</html>


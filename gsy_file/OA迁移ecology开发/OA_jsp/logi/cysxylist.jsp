<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%
String action=request.getContextPath()+"/app/logi/cysxy.jsp";
%>
<%
	pagemenustr +=  "addBtn(tb,'快捷搜索','S','zoom',function(){onSearch()});";
	//pagemenustr +=  "addBtn(tb,'重置条件','R','erase',function(){reset()});";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  	<head>
      	<style type="text/css">
        	.x-toolbar table {width:0}
        	.x-panel-btns-ct {
         		padding: 0px;
      		}
      		.x-panel-btns-ct table {width:0}
      		#pagemenubar table {width:0}
  		</style>
	
		<script src='/dwr/interface/DataService.js'></script>
		
		<script src='/dwr/engine.js'></script>
		<script src='/dwr/util.js'></script>
	 	<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
	
	  	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
	    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
	   	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	   	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
	   	<script language="javascript">
		Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>';//加载中,请稍后...
     	var store;
      	var grid;
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
                 	fields:['plant',
                 	        'conname',
                 	       	'concode',
                 	      	'wtjds',
                 	      	'sjjds',
                 	      	'jdl',
                 	      	'sjzqdhs',
                 	      	'dhl',
                 	      	'sjzddcs',
                 	      	'zdl',
                 	      	'ljjdje',
                 	      	'zwtljje',
                 	      	'ljjdjebl',
                 	      	'jhjdjebl',
                 	      	'xyfs',
                 	      	'cartype']
               	})
        	});
            var sm;
			sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    		sm=new Ext.grid.CheckboxSelectionModel();
			var cm = new Ext.grid.ColumnModel([sm,
			         {header:'厂区别',dataIndex:'plant',hidden:false,width:20,sortable:true},
			         {header:'承运商名称',dataIndex:'conname',hidden:false,width:60,sortable:true},
			         {header:'承运商代码',dataIndex:'concode',hidden:false,width:30,sortable:true},
			         {header:'运输车型',dataIndex:'cartype',hidden:false,width:20,sortable:true},
			         {header:'委托接单数',dataIndex:'wtjds',hidden:false,width:30,sortable:true},
			         {header:'实际接单数',dataIndex:'sjjds',hidden:false,width:30,sortable:true},
			         {header:'接单率',dataIndex:'jdl',hidden:false,width:20,sortable:true},
			         {header:'实际正确到货数',dataIndex:'sjzqdhs',hidden:false,width:30,sortable:true},
			         {header:'到货率',dataIndex:'dhl',hidden:false,width:20,sortable:true},
			         {header:'实际准点到厂数',dataIndex:'sjzddcs',hidden:false,width:30,sortable:true},
			         {header:'准点率',dataIndex:'zdl',hidden:false,width:20,sortable:true},
			         {header:'累计接单金额',dataIndex:'ljjdje',hidden:false,width:40,sortable:true},
			         {header:'总委托累计金额',dataIndex:'zwtljje',hidden:false,width:40,sortable:true},
			         {header:'累计接单金额比例',dataIndex:'ljjdjebl',hidden:false,width:40,sortable:true},
			         {header:'计划接单金额比例',dataIndex:'jhjdjebl',hidden:false,width:40,sortable:true},
			         {header:'信用分数',dataIndex:'xyfs',hidden:false,width:20,sortable:true}
			]);       
            cm.defaultSortable = true;
          	grid = new Ext.grid.GridPanel({
                     	region: 'center',
                     	store: store,
                     	cm: cm,
                       	sm:sm ,
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
                                    		}, 
                       		scrollOffset: -3 , //去掉右侧空白区域  
          					layout : function() {
          					      	if (!this.mainBody) {
          					       		return; // not rendered
          					      	}
          					      	var g = this.grid;
          					      	var c = g.getGridEl();
          					      	var csize = c.getSize(true);
          					      	var vw = csize.width;
          					      	var vh=csize.height;
          					      	if (!g.hideHeaders && (vw < 20 || csize.height < 20)) { // display:
          					       		return;
          					      	}
          					      	if (g.autoHeight) {
          					       		this.el.dom.style.width = "100%";
          					       		var girdcount=store.getCount();
         					          	var gridHeight=0;
          					       		for(var i=0;i<girdcount;i++){
          					           		gridHeight=gridHeight+grid.getView().getRow(i).clientHeight;
          					        	} 
          					       		this.el.dom.style.height =gridHeight+75;//75是菜单栏和分页栏高度和
          					       		this.el.dom.style.overflowX = "auto"; //只显示横向滚动条
          					
          					      	} else {
          					       		this.el.setSize(csize.width, csize.height);
          					       		var hdHeight = this.mainHd.getHeight();
          					       		var vh = csize.height - (hdHeight);
          					       		this.scroller.setSize(vw, vh);
          					       		if (this.innerHd) {
          					        		this.innerHd.style.width = (vw) + 'px';
          					       		}
          					      	}
          					      	if (this.forceFit) {
          					       		if (this.lastViewWidth != vw) {
          					        		this.fitColumns(false, false);
          					        		this.lastViewWidth = vw;
          					       		}
          					      	} else {
          					       		this.autoExpand();
          					       		this.syncHeaderScroll();
          					      	}
          					      	this.onLayout(vw, vh);
          					  	} 
                       		},
                          	bbar: new Ext.PagingToolbar({
                             		pageSize: 80000,
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

			sm.on('rowselect',function(selMdl,rowIndex,rec ){
        	var reqid=rec.get('deliveryno');
        	for(var i=0;i<selected.length;i++){
              	if(reqid == selected[i]){
                  	return;
               	}
           	}
        	selected.push(reqid);
    	});
    	sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        	var reqid=rec.get('deliveryno');
        	for(var i=0;i<selected.length;i++){
             	if(reqid == selected[i]){
                  	selected.remove(reqid);
                  	return;
               	}
           	}
    	});
        var viewport = new Ext.Viewport({
             		layout: 'border',
                 	items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             	});
       	dlg0 = new Ext.Window({
             layout:'border',
             closeAction:'hide',
             plain: true,
             modal :true,
             width:viewport.getSize().width*0.8,
             height:viewport.getSize().height*0.8,
             buttons: [{
                 text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
                 handler  : function(){
                     dlg0.hide();
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
  	});
    Ext.override(Ext.grid.CheckboxSelectionModel, {   
      	handleMouseDown : function(g, rowIndex, e){     
           	if(e.button !== 0 || this.isLocked()){     
                return;     
          	}     
           	var view = this.grid.getView();     
           	if(e.shiftKey && !this.singleSelect && this.last !== false){     
                var last = this.last;     
                this.selectRange(last, rowIndex, e.ctrlKey);     
                this.last = last; // reset the last     
                view.focusRow(rowIndex);     
          	}else{     
                var isSelected = this.isSelected(rowIndex);     
                if(isSelected){     
                  this.deselectRow(rowIndex);     
                }else if(!isSelected || this.getCount() > 1){     
                  this.selectRow(rowIndex, true);     
                  view.focusRow(rowIndex);     
                }     
         	}     
       	}   
  	});              
 	</script>
  </head> 
<body>
<!--页面菜单开始-->     
<div id="divSearch">
 <div id="pagemenubar"></div>
 <form id="EweaverForm" name="EweaverForm" action="<%=action%>">
 <table>
 	<colgroup>
 		<col width="8%">
 		<col width="24%">
 		<col width="8%">
 		<col width="24%">
 		<col width="8%">
 		<col width="24%">
 	</colgroup>
   <tr>
 	<td  class="FieldName" nowrap>统计开始日期</td>
    <td  class="FieldValue"  nowrap>
        <input type=text class=inputstyle style="width:40%" readonly name="startdate" id="startdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<%=DateHelper.dayMove(DateHelper.getCurrentDate(),-1) %>" > 到
    </td>
    <td class="FieldName" nowrap>统计结束日期</td>
	<td class="FieldValue" nowrap>
		<input type=text class=inputstyle style="width:40%" readonly name="enddate" id="enddate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<%=DateHelper.getCurrentDate() %>" >
	</td>
 	<td class="FieldName" nowrap >承运商</td>
	<td class="FieldValue" nowrap>
		<BUTTON onclick="getrefobj('conname','connamespan','40285a9048f924a70148fda977c105cd','','','0');" class=Browser></BUTTON> 
		<INPUT type=hidden name="conname"> 
		<SPAN id="connamespan" name="connamespan"></SPAN>
	</td>
	</tr>
 </table>
</form>
</div>
<script language="javascript">
   	function onSearch(){
	  	var $ = jQuery;
      	var o=$('#EweaverForm').serializeArray();
      	var data={action:'searchall'};
      	for(var i=0;i<o.length;i++) {
          	if(o[i].value!=null&&o[i].value!=""){
          		data[o[i].name]=o[i].value;
          	}
      	}
	   	store.baseParams=data;
       	store.load({params:{start:0, limit:9999}});
       	selected = [];
        store.on({   
	     	load:{   
	       		fn:function(){   
	          		//grid.getSelectionModel().selectAll();  
        		}       
	   		},   
	   		scope:this       
	   	});  
  	}
   	var myMask1 = new Ext.LoadMask(document.body, {msg:'系统加载中，请稍后......',removeMask:true});//请稍等,数据加载中...
 </script>  
  </body>
</html>
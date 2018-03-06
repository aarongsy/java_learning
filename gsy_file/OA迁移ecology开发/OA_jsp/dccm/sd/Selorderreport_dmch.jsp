<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%
String action=request.getContextPath()+"/ServiceAction/com.eweaver.app.trade.servlet.SelSaleOrderAction_MM?action=search";
%>
<%
	pagemenustr +=  "addBtn(tb,'Search','S','zoom',function(){onSearch()});";
	pagemenustr +=  "addBtn(tb,'Reset','R','erase',function(){reset()});";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List rolist = baseJdbcDao.executeSqlForList("select * from sysuserrolelink l,sysuser s where s.id=l.userid and l.roleid='8a8ad0a03d76e071013d7b26edf802f5' and s.objid='"+BaseContext.getRemoteUser().getId()+"'");
	//if(rolist.size()>0){
		//pagemenustr +=  "addBtn(tb,'同步','T','erase',function(){sync()});";	
	//}
	Humres currentHumres = BaseContext.getRemoteUser().getHumres();
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
                 	fields:['sono','soitem','wlh','shortxt','quantity','unit','gcxg','whloc','batchno','shipdate','basequan','baseunit','price','amount','packdesc',
                 	      	'commission','ordertype','ordertypedes','pono','profit','speflag','speflagdesc','sellto','selltoname','selltocontry','selltoaddr',
							'sendto','sendtoname','sendtocontry','sendtoaddr','paytermcode','paytermdesc','icon1','icon1desc','icon2','currency','paycode',
							'paycodedesc','comcode','company','costcen','cpdl','fxqd','khtj','pckdes','zcredit','zeta','zetd','zcldate','zkhwlms','zkhbz','zpzhb','zjjz','zkhcgddrq','rebate','cmpsa','tsgg','dlskhcode','dlskhtxt','orddate','kpein']
                 })
             });
            var sm;
			sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    		sm=new Ext.grid.CheckboxSelectionModel();
			var cm = new Ext.grid.ColumnModel([sm,
			                                   {header:'SaleOrder No',dataIndex:'sono',hidden: false ,width:30,sortable: true},
											   {header:'Grade Item',dataIndex:'soitem',hidden: false ,width:30,sortable: true},
											   {header:'Product Code',dataIndex:'wlh',hidden: false ,width:30,sortable: true},
											   {header:'Product Description',dataIndex:'shortxt',hidden: false ,width:30,sortable: true},
											   {header:'Order Quantity',dataIndex:'quantity',hidden: false ,width:30,sortable: true},
											   {header:'Unit',dataIndex:'unit',hidden: false ,width:30,sortable: true},
											   {header:'Engineering Change',dataIndex:'gcxg',hidden: true ,width:30,sortable: true},
											   {header:'Stock Location',dataIndex:'whloc',hidden: true ,width:30,sortable: true},
											   {header:'Lot Number',dataIndex:'batchno',hidden: true ,width:30,sortable: true},
											   {header:'ETD',dataIndex:'shipdate',hidden: false ,width:30,sortable: true},
											   {header:'Basic Unit Number',dataIndex:'basequan',hidden: true ,width:30,sortable: true},
											   {header:'Basic Unit',dataIndex:'baseunit',hidden: true ,width:30,sortable: true},
											   {header:'Net price',dataIndex:'price',hidden: true ,width:30,sortable: true},
											   {header:'Net Worth',dataIndex:'amount',hidden: true ,width:30,sortable: true},
											   {header:'Packing Type',dataIndex:'packdesc',hidden: false ,width:30,sortable: true},
											   {header:'Commission& Rebate',dataIndex:'commission',hidden: false ,width:30,sortable: true},
			                                   {header:'Type of Sale order',dataIndex:'ordertype',hidden: true ,width:30,sortable: true},
			                                   {header:'Type Description',dataIndex:'ordertypedes',hidden: false ,width:30,sortable: true},
			                                   {header:'Order Numbe',dataIndex:'pono',hidden: true ,width:30,sortable: true},
			                                   {header:'Profit',dataIndex:'profit',hidden: true ,width:30,sortable: true},		                                   
			                                   {header:'Special Flag',dataIndex:'speflag',hidden: true ,width:30,sortable: true},
			                                   {header:'Special Flag Description',dataIndex:'speflagdesc',hidden: true ,width:30,sortable: true},
			                                   {header:'Buyer Code',dataIndex:'sellto',hidden: true ,width:30,sortable: true},
			                                   {header:'Buyer',dataIndex:'selltoname',hidden: false ,width:30,sortable: true},
			                                   {header:'Buyer Country',dataIndex:'selltocontry',hidden: true ,width:30,sortable: true},
			                                   {header:'Buyer Address',dataIndex:'selltoaddr',hidden: true ,width:30,sortable: true},
			                                   {header:'Delivery to',dataIndex:'sendto',hidden: true ,width:30,sortable: true},
			                                   {header:'Delivery Name',dataIndex:'sendtoname',hidden: false ,width:30,sortable: true},
			                                   {header:'Delivery Country',dataIndex:'sendtocontry',hidden: true ,width:30,sortable: true},
			                                   {header:'Delivery Address',dataIndex:'sendtoaddr',hidden: true ,width:30,sortable: true},
			                                   {header:'Payment term',dataIndex:'paytermcode',hidden: true ,width:30,sortable: true},
			                                   {header:'Payment term',dataIndex:'paytermdesc',hidden: false ,width:30,sortable: true},
			                                   {header:'Incoterm1',dataIndex:'icon1',hidden: true ,width:30,sortable: true},
			                                   {header:'Incoterm1',dataIndex:'icon1desc',hidden: false ,width:30,sortable: true},
			                                   {header:'Incoterm2',dataIndex:'icon2',hidden: false ,width:30,sortable: true},
			                                   {header:'Currency',dataIndex:'currency',hidden: true ,width:30,sortable: true},
			                                   {header:'Payment Method',dataIndex:'paycode',hidden: true ,width:30,sortable: true},
			                                   {header:'Payment Method',dataIndex:'paycodedesc',hidden: false ,width:30,sortable: true},
											   {header:'Company Code',dataIndex:'comcode',hidden: false ,width:30,sortable: true},
			                                   {header:'Company Name',dataIndex:'company',hidden: true ,width:30,sortable: true},
							                   {header:'Cost Center',dataIndex:'costcen',hidden: false ,width:30,sortable: true},
											   {header:'Product Category',dataIndex:'cpdl',hidden: true ,width:30,sortable: true},
											   {header:'Distribution Channel',dataIndex:'fxqd',hidden: true ,width:30,sortable: true},
							                   {header:'Customer Condition',dataIndex:'khtj',hidden: true ,width:30,sortable: true},
							                   {header:'Packing Description',dataIndex:'pckdes',hidden: false ,width:30,sortable: true},
							                   {header:'Financial Voucher Number(Credit)',dataIndex:'zcredit',hidden: true ,width:30,sortable: true},
							                   {header:'ZETA',dataIndex:'zeta',hidden: true ,width:30,sortable: true},
							                   {header:'ZETD',dataIndex:'zetd',hidden: true ,width:30,sortable: true},
							                   {header:'Closing Date',dataIndex:'zcldate',hidden: true ,width:30,sortable: true},
							                   {header:'Customer Material Description',dataIndex:'zkhwlms',hidden: false ,width:30,sortable: true},
							                   {header:'Customer Notes',dataIndex:'zkhbz',hidden: false ,width:30,sortable: true},
							                   {header:'Voucher Currency',dataIndex:'zpzhb',hidden: false ,width:30,sortable: true},
							                   {header:'Net Value',dataIndex:'zjjz',hidden: false ,width:30,sortable: true},
							                   {header:'Purchase Order Date',dataIndex:'zkhcgddrq',hidden: false ,width:30,sortable: true},
							                   {header:'Rebate',dataIndex:'rebate',hidden: false ,width:30,sortable: true},
							                   {header:'Credit Freeze',dataIndex:'cmpsa',hidden: false ,width:30,sortable: true},
							                   {header:'Special Specifications',dataIndex:'tsgg',hidden: false ,width:30,sortable: true},
							                   {header:'Agent Customer Code',dataIndex:'dlskhcode',hidden: true ,width:30,sortable: true},
							                   {header:'Agent Customer Name',dataIndex:'dlskhtxt',hidden: true ,width:30,sortable: true},
											   {header:'Sale Order Date',dataIndex:'orddate',hidden: true ,width:30,sortable: true},
												{header:'Per',dataIndex:'kpein',hidden: true ,width:30,sortable: true}
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
                                    sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                    sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                    columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }//-------------给报表grid添加左右滚动条start-----------
                                    , scrollOffset: -3 , //去掉右侧空白区域  
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
          					       // none?
          					       return;
          					      }
          					      if (g.autoHeight) {
          					       this.el.dom.style.width = "100%";
          					       
          					       //计算grid高度
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
                                     
                                    //-------------给报表grid添加左右滚动条end-----------  
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
//'sono','soitem','wlh','shortxt','quantity','unit','gcxg','whloc','batchno','shipdate','basequan','baseunit','price','amount','packdesc',                 	      	'commission','ordertype','ordertypedes','pono','profit','speflag','speflagdesc','sellto','selltoname','selltocontry','selltoaddr',							'sendto','sendtoname','sendtocontry','sendtoaddr','paytermcode','paytermdesc','icon1','icon1desc','icon2','currency','paycode',							'paycodedesc','comcode','company'
        var reqid=rec.get('sono')+'^@^'+rec.get('soitem')+'^@^'+rec.get('wlh')+'^@^'+rec.get('shortxt')+'^@^'+rec.get('quantity')+'^@^'+rec.get('unit')+
		'^@^'+rec.get('gcxg')+'^@^'+rec.get('whloc')+'^@^'+rec.get('batchno')+'^@^'+rec.get('shipdate')+'^@^'+rec.get('basequan')+'^@^'+rec.get('baseunit')+
		'^@^'+rec.get('price')+'^@^'+rec.get('amount')+'^@^'+rec.get('packdesc')+'^@^'+rec.get('commission')+'^@^'+rec.get('ordertype')+'^@^'+rec.get('ordertypedes')+
		'^@^'+rec.get('pono')+'^@^'+rec.get('profit')+'^@^'+rec.get('speflag')+'^@^'+rec.get('speflagdesc')+'^@^'+rec.get('sellto')+'^@^'+rec.get('selltoname')+
		'^@^'+rec.get('selltocontry')+'^@^'+rec.get('selltoaddr')+'^@^'+rec.get('sendto')+'^@^'+rec.get('sendtoname')+'^@^'+rec.get('sendtocontry')+
		'^@^'+rec.get('sendtoaddr')+'^@^'+rec.get('paytermcode')+'^@^'+rec.get('paytermdesc')+'^@^'+rec.get('icon1')+'^@^'+rec.get('icon1desc')+'^@^'+rec.get('icon2')+'^@^'+rec.get('currency')+'^@^'+rec.get('paycode')+'^@^'+rec.get('paycodedesc')+'^@^'+rec.get('comcode')+'^@^'+rec.get('company')+'^@^'+rec.get('costcen')+'^@^'+rec.get('cpdl')+'^@^'+rec.get('fxqd')+'^@^'+rec.get('khtj')+'^@^'+rec.get('pckdes')+'^@^'+rec.get('zcredit')+'^@^'+rec.get('zeta')+'^@^'+rec.get('zetd')+'^@^'+rec.get('zcldate')+'^@^'+rec.get('zkhwlms')+'^@^'+rec.get('zkhbz')+'^@^'+rec.get('zpzhb')+'^@^'+rec.get('zjjz')+'^@^'+rec.get('zkhcgddrq')+'^@^'+rec.get('rebate')+'^@^'+rec.get('cmpsa')+'^@^'+rec.get('tsgg')+'^@^'+rec.get('dlskhcode')+'^@^'+rec.get('dlskhtxt')+'^@^'+rec.get('orddate')+'^@^'+rec.get('kpein');
        for(var i=0;i<selected.length;i++){
                    if(reqid == selected[i]){
                         return;
                     }
                 }
        selected.push(reqid);
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('sono')+'^@^'+rec.get('soitem')+'^@^'+rec.get('wlh')+'^@^'+rec.get('shortxt')+'^@^'+rec.get('quantity')+'^@^'+rec.get('unit')+
		'^@^'+rec.get('gcxg')+'^@^'+rec.get('whloc')+'^@^'+rec.get('batchno')+'^@^'+rec.get('shipdate')+'^@^'+rec.get('basequan')+'^@^'+rec.get('baseunit')+
		'^@^'+rec.get('price')+'^@^'+rec.get('amount')+'^@^'+rec.get('packdesc')+'^@^'+rec.get('commission')+'^@^'+rec.get('ordertype')+'^@^'+rec.get('ordertypedes')+
		'^@^'+rec.get('pono')+'^@^'+rec.get('profit')+'^@^'+rec.get('speflag')+'^@^'+rec.get('speflagdesc')+'^@^'+rec.get('sellto')+'^@^'+rec.get('selltoname')+
		'^@^'+rec.get('selltocontry')+'^@^'+rec.get('selltoaddr')+'^@^'+rec.get('sendto')+'^@^'+rec.get('sendtoname')+'^@^'+rec.get('sendtocontry')+
		'^@^'+rec.get('sendtoaddr')+'^@^'+rec.get('paytermcode')+'^@^'+rec.get('paytermdesc')+'^@^'+rec.get('icon1')+'^@^'+rec.get('icon1desc')+'^@^'+rec.get('icon2')+'^@^'+rec.get('currency')+'^@^'+rec.get('paycode')+'^@^'+rec.get('paycodedesc')+'^@^'+rec.get('comcode')+'^@^'+rec.get('company')+'^@^'+rec.get('costcen')+'^@^'+rec.get('cpdl')+'^@^'+rec.get('fxqd')+'^@^'+rec.get('khtj')+'^@^'+rec.get('pckdes')+'^@^'+rec.get('zcredit')+'^@^'+rec.get('zeta')+'^@^'+rec.get('zetd')+'^@^'+rec.get('zcldate')+'^@^'+rec.get('zkhwlms')+'^@^'+rec.get('zkhbz')+'^@^'+rec.get('zpzhb')+'^@^'+rec.get('zjjz')+'^@^'+rec.get('zkhcgddrq')+'^@^'+rec.get('rebate')+'^@^'+rec.get('cmpsa')+'^@^'+rec.get('tsgg')+'^@^'+rec.get('dlskhcode')+'^@^'+rec.get('dlskhtxt')+'^@^'+rec.get('orddate')+'^@^'+rec.get('kpein');
        for(var i=0;i<selected.length;i++){
                    if(reqid == selected[i]){
                        selected.remove(reqid);
                         return;
                     }
                 }
    }
            );



             //Viewport
         var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
               //store.load({params:{start:0, limit:20}});
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

         //onSearch();  //页面展开即首次查询
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
 	<td  class="FieldName" nowrap>Sale Order </td>
    <td  class="FieldValue"  nowrap>
           <input type=text class=inputstyle style="width:80%" name="vbeln" id="vbeln" value="0000185212" >
    </td>
    
	</tr>
 </table>
<input type="hidden" id="tmprequestid" value="">
</form>
</div>
<script language="javascript">
		   var win;
		   function getrefobj(inputname,inputspan,refid,viewurl,isneed){
		 	var idsin = document.getElementsByName(inputname)[0].value;
		 	var id;
		     if(Ext.isIE){
		     try{
		          var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
		             if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
		                 url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid;
		             }
		     id=openDialog(url);
		     }catch(e){return}
		     if (id!=null) {

		     if (id[0] != '0') {
		 		document.all(inputname).value = id[0];
		 		document.all(inputspan).innerHTML = id[1];

		     }else{
		 		document.all(inputname).value = '';
		 		if (isneed=='0')
		 		document.all(inputspan).innerHTML = '';
		 		else
		 		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

		             }
		          }
		     }else{
		     url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
		     var callback = function() {
		             try {
		                 id = dialog.getFrameWindow().dialogValue;
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
		         if (!win) {
		              win = new Ext.Window({
		                 layout:'border',
		                 width:Ext.getBody().getWidth()*0.8,
		                 height:Ext.getBody().getHeight()*0.8,
		                 plain: true,
		                 modal:true,
		                 items: {
		                     id:'dialog',
		                     region:'center',
		                     iconCls:'portalIcon',
		                     xtype     :'iframepanel',
		                     frameConfig: {
		                         autoCreate:{ id:'portal', name:'portal', frameborder:0 },
		                         eventsFollowFrameLinks : false
		                     },
		                     defaultSrc:url,
		                     closable:false,
		                     autoScroll:true
		                 }
		             });
		         }
		         win.close=function(){
		                     this.hide();
		                     win.getComponent('dialog').setSrc('about:blank');
		                     callback();
		                 } ;
		         win.render(Ext.getBody());
		         var dialog = win.getComponent('dialog');
		         dialog.setSrc(url);
		         win.show();
		     }
		 }

		
   function onDetail(id){
     var url="<%= request.getContextPath()%>/app/attendance/attendanceDetail.jsp?id=8a8adbb73a632823013a635214e10008";
	 onUrl(url,'考勤详细列表','tab_8a8adbb73a632823013a635214e10008');                                                                                 
   }
   function onSearch(){
	   //if(EweaverForm.ERSDA_FROM.value==""||EweaverForm.ERSDA_TO.value==""){
	//   alert("创建日期必填！");
	//	   return;
	//   }
	  var $ = jQuery;
      var o=$('#EweaverForm').serializeArray();
      var data={};
      for(var i=0;i<o.length;i++) {
          if(o[i].value!=null&&o[i].value!=""){
          	data[o[i].name]=o[i].value;
          }
      }
	   store.baseParams=data;
       store.baseParams.datastatus='';
       store.baseParams.isindagate='';
       store.load({params:{start:0, limit:20}});
       selected = [];
  }
   var myMask1 = new Ext.LoadMask(document.body, {msg:'系统加载中，请稍后......',removeMask:true});//请稍等,数据加载中...
   function sync(){
	   myMask1.show();
	   setTimeout(syncDo,1000);
   }
   
   function syncDo(){
	   try{
		   DWREngine.setAsync(false);//设置为同步获取数据
	       Ext.Ajax.request({
	    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.trade.servlet.SalesOrderSyncAction',
	    	    params: {
	    	     jsonstr : selected+"",
	    	     action : "synchronous"
	    	     //配置传到后台的参数
	    	    },
	    	    success: function(response){  //success中用response接受后台的数据
	    	    	alert(response.responseText);
	    	    },
	    	    failure: function(){
	    	     Ext.Msg.show({
	    	      title: '错误提示',
	    	      msg: '访问数据库时发生错误!',
	    	      buttons: Ext.Msg.OK,
	    	      icon: Ext.Msg.ERROR
	    	     });
	    	    }
	    	   }); 
	       
	       
		   /* SAPSyncService.syncProduct(selected+"",{
		          callback: function(data){
			   		if(data&&data!=''){
			   			alert(data);
			   		}
		          }
		      }); */
		   DWREngine.setAsync(true);//设置为同步获取数据
	   }catch(e){
		   alert(e);
	   }
	   myMask1.hide();
   }
  
   //----xxy 20150908add begin
   function sel(){
 		if(selected.length<1){
		 	alert("未选中行数据!");
			return "";
	   	}else{
			//alert(selected[0]);
			return selected;
	   	}     
   }
   //----xxy 20150908 add end     
   
   

   function reset(){
       $('#EweaverForm span').text('');
       $('#EweaverForm input[type=hidden]').val('');
       $('#EweaverForm input[type=text]').val('');
       $("#scope").get(0).options[0].selected = true ; 
  }

   
  jQuery(document).keydown(function(event) {
      if (event.keyCode == 13) {
		 event.preventDefault();
         onSearch(); 
      }
  });

   
 </script>  
  </body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
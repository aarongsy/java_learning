<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@page import="com.eweaver.app.configsap.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%
String action=request.getContextPath()+"/ServiceAction/com.eweaver.app.sap.iface.WorkflowDealAction?action=search";
%>
<%
	pagemenustr +=  "addBtn(tb,'快捷搜索','S','zoom',function(){onSearch()});";
	pagemenustr +=  "addBtn(tb,'重置条件','R','erase',function(){reset()});";
	pagemenustr +=  "addBtn(tb,'Excel导出','E','page_excel',function(){exportExcel1()});";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List rolist = baseJdbcDao.executeSqlForList("select * from sysuserrolelink l,sysuser s where s.id=l.userid and l.roleid='8a8ad0a03d76e071013d7b26edf802f5' and s.objid='"+BaseContext.getRemoteUser().getId()+"'");
	//if(rolist.size()>0){
		//pagemenustr +=  "addBtn(tb,'同步','T','erase',function(){sync()});";	
	//}
	Humres currentHumres = BaseContext.getRemoteUser().getHumres();
	
	
	String id = StringHelper.null2String(request.getParameter("id"));
	String istop = StringHelper.null2String(request.getParameter("istop"));
	SapConfigService scService = new  SapConfigService();
	SapConfig sc = scService.findSapConfigById(id);


	List<SapConfig> inputList = scService.findInputSapConfigs(id);
	List<SapConfig> outputList =scService.findOutputSapConfigs(id);
	Map<SapConfig,List<SapConfig>> outTableMap = scService.findOutTableSapConfigs(id);
	for(Map.Entry<SapConfig,List<SapConfig>> entry : outTableMap.entrySet()) {
		outputList = entry.getValue();
	}
	if(sc == null){
		sc = new SapConfig();
	}
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
                 	fields:[
                 	       <%for(int o = 0;o<outputList.size();o++){
                 	    	   if(o+1<outputList.size()){%>
                           	'<%=outputList.get(o).getId()%>',
                           <%}else{%>
                          	'<%=outputList.get(o).getId()%>'
                           <%}}%>
                 	       ]
                 })
             });
            var sm;
			sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    		sm=new Ext.grid.CheckboxSelectionModel();
			var cm = new Ext.grid.ColumnModel([
			                                   <%for(int o = 0;o<outputList.size();o++){if(o+1<outputList.size()){%>
			                                   	{header:'<%=outputList.get(o).getRemark()%>',dataIndex:'<%=outputList.get(o).getId()%>',hidden: false ,width:30,sortable: true},
			                                   <%}else{%>
			                                  	 {header:'<%=outputList.get(o).getRemark()%>',dataIndex:'<%=outputList.get(o).getId()%>',hidden: false ,width:30,sortable: true}
			                                   <%}}%>
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
        var reqid=rec.get('ebele');
        for(var i=0;i<selected.length;i++){
                    if(reqid == selected[i]){
                         return;
                     }
                 }
        selected.push(reqid);
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('ebele');
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

         
    	</script>
  </head> 
  <body>

		
<!--页面菜单开始-->     

<div id="divSearch" <%if("1".equals(istop)){%>style="display: none"<%}%>>
 <div id="pagemenubar"></div>
 <form id="EweaverForm" name="EweaverForm" action="<%=action%>">
  <table id='exptable'>
 	<colgroup>
 		<col width="8%">
 		<col width="24%">
 		<col width="8%">
 		<col width="24%">
 		<col width="8%">
 		<col width="24%">
 	</colgroup>
 	
   <tr>
   <%for(int i=0;i<inputList.size();i++){ %>
 	<td  class="FieldName" nowrap><%=inputList.get(i).getRemark()%></td>
    <td  class="FieldValue"  nowrap>
           <input type=text class=inputstyle style="width:80%" name="<%=inputList.get(i).getId()%>_input" id="<%=inputList.get(i).getId()%>_input" value="<%=StringHelper.null2String(request.getParameter(inputList.get(i).getId())) %>" >
    </td>
    <%if((i+1)%3==0){ %>
    </tr><tr>
    <%}} %>
	</tr>
 </table>
<input type="hidden" id="rfcid" value="<%=id%>" name="rfcid">
</form>
</div>
<script language="javascript">
		  
   function onSearch(){
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
   function reset(){
       $('#EweaverForm span').text('');
       $('#EweaverForm input[type=hidden]').val('');
       $('#EweaverForm input[type=text]').val('');
       $("#scope").get(0).options[0].selected = true ; 
  }

function exportExcel1(){     
    var oXL = new ActiveXObject('Excel.Application');      
    var oWB = oXL.Workbooks.Add();     
    var oSheet = oWB.ActiveSheet;     
	var div=document.getElementById('ext-gen122').getElementsByTagName('div')[0].getElementsByTagName('table')[0];
	var lie = div.rows(0).cells.length; 
	for (j=0;j<lie;j++)
		{     
			oSheet.Cells(1,j+1).NumberFormatLocal = '@';     
			oSheet.Cells(1,j+1).Font.Bold = true;     
			oSheet.Cells(1,j+1).Font.Size = 10;     
			oSheet.Cells(1,j+1).value =div.rows(0).cells(j).childNodes[0].innerText;    		 
		} 
	var len=document.getElementsByTagName('table').length;
	var table;
	var row=0;
	for(var k=0;k<len;k++)
	{
		 table=document.getElementsByTagName('table')[k];
		if(table.className=='x-grid3-row-table')
		{
			row++;
			var hang = table.rows.length;     
			var lie = table.rows(0).cells.length;   
			for (i=0;i<hang-1;i++){   
				for (j=0;j<lie;j++){     
					oSheet.Cells(row+i+1,j+1).NumberFormatLocal = '@';     
					oSheet.Cells(row+i+1,j+1).Font.Bold = true;     
					oSheet.Cells(row+i+1,j+1).Font.Size = 10;     
					oSheet.Cells(row+i+1,j+1).value = table.rows(i).cells(j).childNodes[0].innerHTML;    
					 
				} 
				
			} 
		}
	}
    oXL.Visible = true;     
    oXL.UserControl = true;     
}  
   
  jQuery(document).keydown(function(event) {
      if (event.keyCode == 13) {
         onSearch(); 
      }
  });


  setTimeout(onSearch,1000);  //页面展开即首次查询
 </script>  
  </body>
</html>
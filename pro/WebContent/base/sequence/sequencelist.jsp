<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.sequence.Sequence" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
SequenceService sequenceService = (SequenceService)BaseContext.getBean("sequenceService");
String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.sequence.SequenceAction?action=getsequencelist";
String name=StringHelper.null2String(request.getParameter("name"));
%>
<%
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','S','accept',function(){onCreate()});";
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";

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

  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
         <script language="javascript">
          Ext.LoadMask.prototype.msg='加载中,请稍后...';
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
                       fields: ['name','description','startno','incrementno','modify','id']

                 })

             });
             //store.setDefaultSort('id', 'desc');

             var sm=new Ext.grid.CheckboxSelectionModel();

             var cm = new Ext.grid.ColumnModel([sm, {header: "名称", width:100, sortable: false,  dataIndex: 'name'},
                         {header: "描述", sortable: false, width:500 ,dataIndex: 'description'},
                         {header: "初始值", width:50, sortable: false, dataIndex: 'startno'},
                         {header: "增量", width:50, sortable: false, dataIndex: 'incrementno'},
                         {header:"" , width:50, sortable: false, dataIndex: 'modify'}

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


             //Viewport
         	var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
             
             store.baseParams.name='<%=name%>';
             store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '关闭',
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

<div id="divSearch">
 <div id="pagemenubar"></div>
	 <form action="" name="EweaverForm"  method="post">
	   <input type="hidden" name="searchName" value="">
	   <table id=searchTable>
	       <tr>
	         <td class="FieldName" width=5% nowrap>
				 <%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%>:
			 </td>
	    	<td width="80%">&nbsp;&nbsp;<input id="name" class="infoinput" name="inputText" type="text" size="10" value="<%=name%>">
	    	<input type="button" name="Button" value="Search" onClick="javascript:onSearch();"></td>
	     </tr>
	   </table>
	 </form>
</div>


<script language="javascript">
	function onSearch(){
	    var name = document.getElementById("name").value;
	    store.baseParams.name = name;
	    store.load({params:{start:0, limit:20}});
	    event.srcElement.disabled = false;
	}

   $(document).keydown(function(event) {
       if (event.keyCode == 13) {
    	   document.getElementById("name").blur();
           onSearch();
       }
   });


 <!--
    function onCreate(){
     var url="<%= request.getContextPath()%>/base/sequence/sequencecreate.jsp";
	 window.location.href=url;
   }
   function onModify(id){                                                                                 
     var url="<%= request.getContextPath()%>/base/sequence/sequencemodify.jsp?id="+id;
	 window.location.href=url;
   }
   function onDelete(id){
   <%--  if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
     	var url="/ServiceAction/com.eweaver.base.sequence.SequenceAction?action=delete&id="+id;
		window.location.href=url;
   	}--%>
   	 if(selected.length==0){
              Ext.Msg.buttonText={ok:'确定'};
              Ext.MessageBox.alert('', '请选择要删除的内容！');
              return;
              }
          Ext.Msg.buttonText={yes:'是',no:'否'};                                 
        Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                     if (btn == 'yes') {
                         Ext.Ajax.request({
                             url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.sequence.SequenceAction?action=delete',
                             params:{ids:selected.toString()},
                             success: function() {
                                 selected=[];
                                 store.load({params:{start:0, limit:20}});
                             }
                         });
                     } else {
                         selected=[];
                        store.load({params:{start:0, limit:20}});
                     }
                 });
   }
 -->
 
 
 </script>
  </body>
</html>
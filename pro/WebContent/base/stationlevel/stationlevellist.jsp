<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.*"%>
<%@ page import="com.eweaver.base.selectitem.service.*"%>
<%@ page import="com.eweaver.base.stationlevel.service.StationlevellinkService"%>
<%@ page import="com.eweaver.base.stationlevel.model.Stationlevellink"%>
<%@ page import="com.eweaver.humres.base.service.StationinfoService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%
StationlevellinkService linkService = (StationlevellinkService)BaseContext.getBean("stationlevellinkService");
StationinfoService stationService = (StationinfoService)BaseContext.getBean("stationinfoService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
List list=selectitemService.getSelectitemList("40288019120556350112058e3b92000c",null);
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','N','add',function(){onCreate()});";
    pagemenustr += "addBtn(tb,'删除','D','delete',function(){onDelete()});";
%>
<html>
  <head>
  <STYLE>
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-bottom-style: solid;
	border-bottom-color: #cccccc;
}
</STYLE>
       <style type="text/css">
      TABLE {
          width: 0;
      }
  </style>
  
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>   
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
         <script language="javascript">
          Ext.LoadMask.prototype.msg='加载中,请稍后...';
             var store;
             var selected=new Array();
             var dlg0;
           <%
            String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.stationlevel.servlet.StationlevelAction?action=getstationlevel";
           %>
                   Ext.onReady(function(){
                       Ext.QuickTips.init();
                   <%if(!pagemenustr.equals("")){%>
                       var tb = new Ext.Toolbar();
                       tb.render('pagemenubar');
                   <%=pagemenustr%>
                   <%}%>
             store = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=action+"&pagesize=20"%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',

                       fields: ['name','stationinfoname','add','id']

                 })

             });
             //store.setDefaultSort('id', 'desc');

             var sm=new Ext.grid.CheckboxSelectionModel();

             var cm = new Ext.grid.ColumnModel([sm, {header: "岗位级别名称", width:100, sortable: false,  dataIndex: 'name'},
                         {header: "岗位", sortable: false, width:500 ,dataIndex: 'stationinfoname'},
                         {header: "添加岗位", width:50, sortable: false, dataIndex: 'add'}

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
         });
          </script>
</head>
  
  <body>
<div id="divSearch" style="z-index:100;">
    <div id="pagemenubar" style="z-index:100;"></div>
</div>


<SCRIPT language="javascript"> 
function openWin(url,title,height,width){
	var left=(screen.width-width)/2;
	var top=(screen.height-height)/2-30;
	window.open("<%= request.getContextPath()%>"+url, title, "height="+height+", width="+width+", top="+top+", left="+left+", toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}
function onDelete(id){
    if(selected.length==0){
        Ext.Msg.buttonText={ok:'确定'};                                                                                     
              Ext.MessageBox.alert('', '请选择岗位级别名称！');
              return;
              }
             Ext.Msg.buttonText={yes:'是',no:'否'};
        Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                     if (btn == 'yes') {
                         Ext.Ajax.request({
                             url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.stationlevel.servlet.StationlevelAction?action=delete',
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
function onModify(id){
    var url="/base/stationlevel/stationlevelcreate.jsp?id="+id;
      this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show()
    //openWin(url,"",480,640);
} 
function onAddStation(levelid){
   var url="/base/stationlevel/addstation.jsp?&levelid="+levelid;
    openWin(url,"",600,800);
      //this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
     // this.dlg0.show()
} 
function onCreate(){
	var url="/base/stationlevel/stationlevelcreate.jsp";
   // openWin(url,"",480,640);
      this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show()
}
</SCRIPT>     
  </body>
</html>

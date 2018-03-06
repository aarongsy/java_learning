<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjmodel"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjmodelService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%@ include file="/base/init.jsp"%>

<html>
<%
    String modeltype = StringHelper.null2String(request.getParameter("modeltype"));
    if (StringHelper.isEmpty(modeltype))
        modeltype = "4028818211b28bbb0111b37e5e910011";
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    List selectitemlist = selectitemService.getSelectitemList("4028818211b28bbb0111b35d77fb000f", null);
    Selectitem selectitem;
    String action = request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjmodelAction?action=getrefobjmodellist";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','S','accept',function(){onPopup('/base/refobj/refobjmodelcreate.jsp?modeltype=" + modeltype + "')});";
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";

%>
  <head>
      <style type="text/css">
        .x-toolbar table {width:0}
      #pagemenubar table {width:0}
      </style>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
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
            fields: ['refname','objtype','linktype','refsql','refurl','refobjtype','maxnum','isview','id']
        })

    });
    //store.setDefaultSort('id', 'desc');

    var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm, {header: "协同名称",width:200,  sortable: false,  dataIndex: 'refname'},
                {header: "对象类型", sortable: false,width:200,   dataIndex: 'objtype'},
                {header: "关联字段", sortable: false,width:100,   dataIndex: 'linktype'},
                {header: "查询语句", sortable: false,width:500,  dataIndex: 'refsql'},
                {header: "关联URL",  sortable: false,width:500, dataIndex: 'refurl'},
                {header: "关联对象类型", sortable: false, width:200, dataIndex: 'refobjtype'},
                {header: "最大显示个数", sortable: false, width:200, dataIndex: 'maxnum'},
                {header: "是否显示", sortable: false,width:100, dataIndex: 'isview'}
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
    /*store.on('beforeload',function(){
        alert(selected.length);
    });*/


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
      store.baseParams.modeltype='<%=modeltype%>'
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
                         selected=[];
                        store.baseParams.modeltype='<%=modeltype%>'
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
<div id="divSearch">
<div id="pagemenubar" ></div>
<table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
		 </td>                  
         <td class="FieldValue">
		     <select class="inputstyle" id="selectitemid" name="selectitemid" onChange="onsearch(this.value)">
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectitem.getId().equals(modeltype)) selected = "selected";              
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>
                   
                   <%
                   } // end while
                   %>
		       </select>
		      
          </td>
          </tr>
         </table>
    </div>

<script language="javascript">
    function onsearch(value)
    {
      store.baseParams.modeltype=value
      store.load({params:{start:0, limit:20}});
    }
   function onPopup(url){
  	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
   	this.location.href="<%=request.getContextPath()%>/base/refobj/refobjmodellist.jsp?modeltype=<%=modeltype%>";
       // this.dlg0.getComponent('dlgpanel').setSrc(url);
     // this.dlg0.show()
   }
     function onDelete()
     {
         if (selected.length == 0) {
             Ext.Msg.buttonText={ok:'确定'};                                            
             Ext.MessageBox.alert('', '请选择要删除的内容！');
             return;
         }
         Ext.Msg.buttonText={yes:'是',no:'否'};
         Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjmodelAction?action=deleteext',
                     params:{ids:selected.toString()},
                     success: function() {
                         selected = [];
                         store.load({params:{start:0, limit:20}});
                     }
                 });
             } else {
                 selected = [];
                 store.load({params:{start:0, limit:20}});
             }
         });

     }
 </script>
  </body>
</html>

<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.sequence.Sequence" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
  HumresService humresService = (HumresService) BaseContext.getBean("humresService");
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
  String byagent = StringHelper.null2String(request.getParameter("byagent"));
  String byagentName = StringHelper.null2String(humresService.getHumresById(byagent).getObjname());
  String agent = StringHelper.null2String(request.getParameter("agent"));
  String agentName = StringHelper.null2String(humresService.getHumresById(agent).getObjname());
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.word.servlet.WordModuleAction?action=search";
  List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//资源类型
  String sqlwhere = StringHelper.null2String(request.getParameter("sqlwhere"));
  Selectitem selectitem = new Selectitem();

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){onPopup('"+request.getContextPath()+"/document/base/wordmodulecreate.jsp')});";
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";
//    pagemenustr +="addBtn(tb,'清空条件','R','erase',function(){onReset()});";

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
</style>
    <script src='<%= request.getContextPath()%>/dwr/interface/ModuleService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
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
                    fields: ['objname','objdesc','orgids','orgnames','id']

                 })

             });

             var sm=new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([sm, {header: "模板名称", sortable: false,  dataIndex: 'objname',width:1/5},
                    {header: "使用部门", sortable: false,  dataIndex: 'orgnames',width:2/5},{header: "模板说明", sortable: false,  dataIndex: 'objdesc',width:2/5}
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
				   
				store.baseParams.sqlwhere='<%=sqlwhere%>';
                store.baseParams.selectItemId='<%=selectItemId%>';
                store.baseParams.byagent='<%=byagent%>';
                store.baseParams.agent='<%=agent%>';
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
                       dlg0.render(Ext.getBody());
         });
  </script>
  </head>
  <body>
	
</div>
<!--页面菜单开始-->

  <div id="divSearch">
    <div id="pagemenubar"></div>
    
<form action="<%= action%>" name="EweaverForm" method="post" id="EweaverForm">
<input type=hidden name="sqlwhere" value="<%=sqlwhere%>">
<table id="myTable" class=viewform>

<tr class=title >

<td  class="FieldName" width=10% nowrap>
 模板名称
</td>
<td width=15% class='FieldValue'> 
<input type=text class=inputstyle name="objname" value=""/>
</td> 
<td  class="FieldName" width=10% nowrap>
 模板描述
</td>
<td width=15% class='FieldValue'>
<input type=text class=inputstyle name="objdesc" value=""/> 
</td> 
<!-- 
<td  class="FieldName" width=10% nowrap>
 使用部门
</td>
<td width=15% class='FieldValue'> 
<button type=button class=Browser name="button_objdesc" onclick="javascript:getBrowser('/base/refobj/baseobjbrowser.jsp?id=8a81808a31cca6590131cd05a5b40065','objdesc','objdescspan','1');"></button><input type="hidden" name="objdesc" value=""  style='width: 80%'  ><span id="objdescspan" name="objdescspan" ></span>
</td>
 -->
</tr>
</table>
</form>
 </div>
<script language="javascript">

 <!--
   function onPopup(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show()

   }
    function onSearch()
    {
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

   function onReset(){
        $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').val('');
         $('#EweaverForm select').val('');
   }

    function onDelete()
    {
        if (selected.length == 0) {
            Ext.Msg.buttonText={ok:'确定'};
            Ext.MessageBox.alert('', '请选择要删除的内容！');
            return;
        }
        Ext.Msg.buttonText = {yes:'是',no:'否'};
        Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.word.servlet.WordModuleAction?action=delete',
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

function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
		if(inputname=="workflowid"){
            DWREngine.setAsync(false);
		    ModuleService.getModuleByWorkflowid(id[0],rollback);
            DWREngine.setAsync(true);
		}
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function rollback(data){
    var id = data.id;
    var name = data.objname;
    if(id!=null){
        document.forms[0].moduleid.value = id;
    }else{
        document.forms[0].moduleid.value = "";
    }
    if(name!=null){
        document.getElementById("moduleidspan").innerText = name;
    }else{
        document.getElementById("moduleidspan").innerText = "";
    }
 }
 -->
 </script>
  </body>
  <script type="text/javascript" language="javascript" src="/oa/datapicker/WdatePicker.js"></script>
</html>
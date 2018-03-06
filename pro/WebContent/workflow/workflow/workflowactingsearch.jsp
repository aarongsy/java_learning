<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.sequence.Sequence" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService" %>
<%@ page import="com.eweaver.base.security.model.Sysuser" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
  response.setHeader("cache-control", "no-cache");
  response.setHeader("pragma", "no-cache");
  response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
  HumresService humresService = (HumresService) BaseContext.getBean("humresService");
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
  String byagent = eweaveruser.getId();
  String byagentName = StringHelper.null2String(humresService.getHumresById(byagent).getObjname());
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=search";
  List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//资源类型
  Selectitem selectitem = new Selectitem();
  boolean hasPriv=false;
  if(eweaveruser.getId().equalsIgnoreCase("402881e70be6d209010be75668750014")){//系统管理员有权
  	hasPriv = true;
  }
  SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
  Sysuser su=new Sysuser();
  su.setId(eweaveruser.getSysuserid());
  //原来的资源文件需要重新定义，暂时只对系统管理员开放操作权限
  //hasPriv=sysuserService.checkUserPerm(su,"com.eweaver.workflow.workflow.service.WorkflowactingService.save");
  
%>
<%    
    if(hasPriv){
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042")+"','R','erase',function(){onReset()});";//清空条件
        }
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){onPopup('"+request.getContextPath()+"/workflow/workflow/workflowactingcreate.jsp','"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")+"',null)});";//新建
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除
    if(hasPriv){
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0015")+"','A','application_view_detail',function(){onPopup('"+request.getContextPath()+"/workflow/workflow/workflowactinglist.jsp','"+labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0015")+"','')});";//代理明细     代理明细
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
</style>
    <script src='<%= request.getContextPath()%>/dwr/interface/ModuleService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
         <script language="javascript">
          Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>';//加载中,请稍后...'
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
                    fields: ['byagent','agent','createtime','count','result','id']

                 })

             });

             var sm=new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([sm,
                                             new Ext.grid.RowNumberer(),
                         {header: "<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0008")%>", width:80, sortable: false,  dataIndex: 'byagent'},//被代理人
                         {header: "<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0009")%>", sortable: false, width:100 ,dataIndex: 'agent'},//代理人
                         {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008")%>", sortable: true, width:100 ,dataIndex: 'createtime'},//创建时间
                         {header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3932002a")%>", width:50, sortable: false, dataIndex: 'count'},//数量
                         {header: "<%=labelService.getLabelNameByKeyId("402881e80b708c4f010b70a20640002b")%>", width:50, sortable: false, dataIndex: 'result'}//列表
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
                                    sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                    sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                    columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }
                                },
                                bbar: new Ext.PagingToolbar({
                                    pageSize: 20,
                     store: store,
                     displayInfo: true,
                     beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                     afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                     firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                     prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                     nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                     lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                     displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示     条记录 
                     emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
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
                store.baseParams.selectItemId='<%=selectItemId%>';
                store.baseParams.byagent='<%=byagent%>';
                store.baseParams.agent='<%=byagent%>';
               store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.9,
                         height:viewport.getSize().height*0.9,
                         buttons: [{
                             text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
                             handler  : function(){
                                 dlg0.hide();
                                 store.load({params:{start:0, limit:20}});
                                 dlg0.getComponent('dlgpanel').setSrc('about:blank');
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


<!--页面菜单开始-->

  <div id="divSearch" >
    <div id="pagemenubar"></div>
     <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=search" name="EweaverForm" id="EweaverForm" method="post" onsubmit="return false">


      <table id=searchTable <%if(!hasPriv){%>style='display:none;'<%}%>>
        <tr>
		 <td class="FieldName" width=15% nowrap>
			<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0008")%> <!--被代理人--><!-- 流程表单-->
		 </td>
		 <td class="FieldValue" width=35%>
			<button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp?objtype=0','byagent','byagentspan','0');"></button>
			<input type="hidden"  name="byagent" value="<%=byagent%>"/>
			<span id="byagentspan"><%=byagentName%></span>
		 </td>

		 <td class="FieldName" width=15% nowrap>
			<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0009")%> <!--代理人--><!-- 流程表单-->
		 </td>
		 <td class="FieldValue" width=35%>
			<button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp?objtype=0','agent','agentspan','0');"></button>
			<input type="hidden"  name="agent" value=""/>
			<span id="agentspan"></span>
		 </td>
        </tr>
       </table <%if(!hasPriv){%>style='display:none;'<%}%>>
     </form>
     </div>

<script language="javascript">

 <!--

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
            Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
            Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000")%>');//请选择要删除的内容！
            return;
        }
        //判断是否删除的是自己创建的或者sysadmin创建 
        var sum=0;
        var selary = selected.toString().split(',');
        for(var j=0;j<selary.length;j++){
        	var val = selary[j].toString();
        	var byagent = val.substr(0,val.indexOf("_"));       	 			
  			 if(byagent!='<%=BaseContext.getRemoteUser().getHumres().getId()%>'){ 	
  			 	if("<%=hasPriv %>"!="true"){ 			 		
  			 		sum = sum + 1;			 		
  			 	}			 	
  			 }					 
        }
        if(sum>0){
        	Ext.MessageBox.alert('', '非管理员只能删除被代理人是自己的流程代理！');
            return;
        }
        
        Ext.Msg.buttonText = {yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>'};//是    否
        Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075")%>', function (btn, text) {//您确定要删除吗?
              
            if (btn == 'yes') {
                Ext.Ajax.request({

                    url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=deleteSearch',
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
   function onPopup(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show()

   }

var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
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
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
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
	    var winHeight = Ext.getBody().getHeight() * 0.95;
	    var winWidth = Ext.getBody().getWidth() * 0.95;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
     if (!win) {
          win = new Ext.Window({
             layout:'border',
             width:winWidth,
             height:winHeight,
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
     dialog.setSrc(viewurl);
     win.show();
	}
 }

 function rollback(data){
    var id = data.id;
    var name = data.objname;
    if(id!=null){
        document.forms[0].moduleid.value = id;
    }
    if(name!=null){
        document.getElementById("moduleidspan").innerText=name;
    }
 }
 -->
 </script>
  </body>
  <script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
</html>
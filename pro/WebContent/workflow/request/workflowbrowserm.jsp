<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%
  int pageSize=20;
String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
  String workflowid  =  StringHelper.null2String(request.getParameter("workflowid"));
  String creator=StringHelper.null2String(request.getParameter("creator"));
  String createdatefrom  =  StringHelper.null2String(request.getParameter("createdatefrom"));
  String createdateto=StringHelper.null2String(request.getParameter("createdateto"));
  String keyfield=StringHelper.null2String(request.getParameter("keyfield"));
  String showfield=StringHelper.null2String(request.getParameter("showfield"),"requestname");
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  int maxselected = 100;
String userid = request.getParameter("userid");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
  EweaverUser curuser = BaseContext.getRemoteUser();
	String username = curuser.getUsername();
%>
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','erase',function(){onClear()});";//清除
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','R','accept',function(){onSubmit()});";//确定
%>
<html>
  <head>
  <style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    .icon-del {background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif) ! important;
    }

</style>
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/ext/resources/css/RowActions.css" type="text/css">
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
      <script type="text/javascript">
      <%
      String idsin=StringHelper.null2String(request.getParameter("idsin"));
      String refid=StringHelper.null2String(request.getParameter("refid"));
      String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=getworkflowlist&refid="+refid;
  Refobj refobj1=refobjService.getRefobj(refid);
  showfield=refobj1.getViewfield();
  String _viewurl=refobj1.getViewurl();
  List listidsin=StringHelper.string2ArrayList(idsin,",");
    String strdata="";
    for(int i=0;i<listidsin.size();i++)
    {
        String id=listidsin.get(i).toString();
        String sql="select "+refobj1.getViewfield()+" from "+refobj1.getReftable()+" where "+refobj1.getKeyfield()+"='"+id+"'";
       List fieldlist=baseJdbcDao.getJdbcTemplate().queryForList(sql);
        String showfieldname="";
           for (Object o : fieldlist) {
                showfieldname=((Map) o).get(showfield).toString();
           }
           String showname=showfieldname;
			if(!StringHelper.isEmpty(_viewurl)){
				showname = "<a title=\""+showfieldname+"\" href=javascript:try{onUrl(\""
				+ _viewurl
				+ id
				+ "\",\""
				+ showfieldname
				+ "\",\"tab"
				+ id + "\")}catch(e){}>";
				showname += showfieldname;
				showname += "</a>";
			}
        if(i==0){
            strdata="{"+refobj1.getKeyfield()+":'"+id+"',"+showfield+":'"+showname+"'}";
        }else{
           strdata+=","+"{"+refobj1.getKeyfield()+":'"+id+"',"+showfield+":'"+showname+"'}";
        }
    }
    	if(StringHelper.isEmpty(showfield)) showfield = "requestname";
      %>
      var showfield = '<%=showfield%>';
      Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
      var store;
      var selectedStore;
      var sm;
      var dialogValue;
      Ext.grid.RowSelectionModel.override({
          initEvents : function() {
              this.grid.on("rowclick", function(grid, rowIndex, e) {
                  var target = e.getTarget();
                  if (target.className !== 'x-grid3-row-checker' && e.button === 0 && !e.shiftKey && !e.ctrlKey) {
                      if(target.tagName=='A'){
                      e.stopEvent();
                      }
                      this.selectRow(rowIndex, true);
                      grid.view.focusRow(rowIndex);
                  }
                  else if (e.shiftKey &&this.last !== false && this.lastActive !== false) {
                          var last = this.last;
                          this.selectRange(this.last,rowIndex);
                          this.grid.getView().focusRow(rowIndex);
                          if (last !== false) {
                              this.last = last;
                          }
                      }

              }, this);
              this.rowNav = new Ext.KeyNav(this.grid.getGridEl(), {
                  "up" : function(e) {
                      if (!e.shiftKey) {
                          this.selectPrevious(e.shiftKey);
                      } else if (this.last !== false && this.lastActive !== false) {
                          var last = this.last;
                          this.selectRange(this.last, this.lastActive - 1);
                          this.grid.getView().focusRow(this.lastActive);
                          if (last !== false) {
                              this.last = last;
                          }
                      } else {
                          this.selectFirstRow();
                      }
                  },
                  "down" : function(e) {
                      if (!e.shiftKey) {
                          this.selectNext(e.shiftKey);
                      } else if (this.last !== false && this.lastActive !== false) {
                          var last = this.last;
                          this.selectRange(this.last, this.lastActive + 1);
                          this.grid.getView().focusRow(this.lastActive);
                          if (last !== false) {
                              this.last = last;
                          }
                      } else {
                          this.selectFirstRow();
                      }
                  },
                  scope: this
              });

          }
      });
      Ext.onReady(function(){
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
              fields: ["id","requestname","time","creator","isfinish"]
          }),
          remoteSort: true,
          autoLoad:false
      });
      //store.setDefaultSort('id', 'desc');
      sm=new Ext.grid.CheckboxSelectionModel();
      var cm = new Ext.grid.ColumnModel([sm,{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060") %>", sortable: false,  dataIndex: 'requestname'},//流程名称
          {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008") %>", sortable: false,   dataIndex: 'time'},//创建时间
          {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006") %>", sortable: false,   dataIndex: 'creator'},//创建者
          {header: "<%=labelService.getLabelNameByKeyId("402881ec0cbb8cc8010cbbf030f8002d") %>", sortable: false,   dataIndex: 'isfinish'}//是否结束
      ]);
      cm.defaultSortable = true;
                     var grid = new Ext.grid.GridPanel({
                         title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050005") %>',//待选
                         region: 'center',
                         store: store,
                         cm: cm,
                         trackMouseOver:false,
                         sm:sm ,
                         loadMask: true,
                         enableColumnMove:false,
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
                             pageSize: <%=pageSize%>,
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
          store.baseParams.creator='<%=creator%>';
            store.baseParams.workflowid='<%=workflowid%>';
          store.baseParams.createdateto='<%=createdateto%>';
            store.baseParams.createdatefrom='<%=createdatefrom%>';
          store.baseParams.sqlwhere='<%=sqlwhere%>';
    store.load({params:{start:0, limit:<%=pageSize%>}});
      store.on('load',function(st,recs){

          for(var i=0;i<recs.length;i++){
              var reqid=recs[i].get('id');
              selectedStore.each(function(record){
                  if(record.get('id')==reqid)
                    sm.selectRecords([recs[i]],true);
              })

      }
      }
              );
      sm.on('rowselect',function(selMdl,rowIndex,rec ){
         try{
             var foundItem = selectedStore.find('id', rec.data.id);
             if(foundItem==-1)
             selectedStore.add(rec);
          }catch(e){}
      });
      sm.on('rowdeselect',function(selMdl,rowIndex,rec ){
          try{
              var foundItem = selectedStore.find('id', rec.data.id);
              if(foundItem!=-1)
                  selectedStore.remove(selectedStore.getAt(foundItem));
          }catch(e){}
      }
              );
      //selected grid
          var sm1 = new Ext.grid.RowSelectionModel();
          var action = new Ext.ux.grid.RowActions({
              header:"<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' onclick='selectedStore.removeAll();sm.clearSelections();'>",
              actions:[{
                  iconCls:'icon-del',
                  tooltip:'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>',//删除
                  style:'icon-del'
              }]
          });
          var cm1 = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060") %>", sortable: false,  dataIndex: 'requestname'},//流程名称
           {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008") %>", sortable: false,   dataIndex: 'time'}//创建时间
          ,action]);
          cm1.defaultSortable = false;
          var myData = {
                  records : [
                      <%=strdata%>
      ]
              };
          selectedStore = new Ext.data.JsonStore({
                  fields : ["id","requestname","time","creator","isfinish",'action'],
                  data   : myData,
                  root   : 'records'
              });

          action.on({
              action:function(grid, record, action, row, col) {
                  selectedStore.remove(record);
                  var foundItem = store.find('id', record.data.id);
                  if (foundItem != -1)
                      sm.deselectRow(foundItem);
              }}
                  );
          var selectedGrid = new Ext.grid.GridPanel({
              title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050006") %>',//已选
              region: 'east',
              ddGroup: 'selectedGridDDGroup',
              ddText:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050007") %>',//拖动
              enableDragDrop   : true,
              store: selectedStore,
              cm: cm1,
              trackMouseOver:false,
              sm:sm1 ,
              enableColumnHide:false,
              enableHdMenu:false,
              collapseMode:'mini',
              split:true,
              width: 225,
              loadMask: true,
              plugins:[action],
              enableColumnMove:false,
              viewConfig: {
                  forceFit:true,
                  enableRowBody:true,
                  getRowClass : function(record, rowIndex, p, store) {
                      return 'x-grid3-row-collapsed';
                  }
              },
              bbar:[{
                  text: '<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050008") %>',//清空
                  handler : function() {
                      selectedStore.removeAll();
                      sm.clearSelections();
                  }
              }],
              store: selectedStore
          });

          //Viewport
          var viewport = new Ext.Viewport({
              layout: 'border',
              items: [{region:'north',autoScroll:true,split:true,contentEl:'divSearch',height:screen.height*0.7*0.3},grid,selectedGrid]
          });
          //d&d
          var selectedGridDropTargetEl =  selectedGrid.getView().el.dom.childNodes[0].childNodes[1];

          var selectedGridDropTarget = new Ext.dd.DropTarget(selectedGridDropTargetEl, {
                  ddGroup    : 'selectedGridDDGroup',
                  copy       : false,
                  notifyDrop : function(ddSource, e, data){
                      var targetEl = e.getTarget();
                      var rowIndex = selectedGrid.getView().findRowIndex(targetEl);
                      if(typeof(rowIndex)=='boolean')
                      return false;
                      selectedStore.remove(ddSource.dragData.selections[0]);
                      selectedStore.insert(rowIndex, ddSource.dragData.selections[0]);
                      return true;
                  },
                  notifyEnter:function(ddSource, e, data){
                      var proxy = ddSource.getProxy();
                      proxy.update(ddSource.dragData.selections[0].get(showfield));
                  }
              });

      });


      </script>
  </head>
  
  <body>    
<div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
   	<form action="<%=action%>" name="EweaverForm" method="post" id="EweaverForm"onsubmit="onSearch2();return false;">

		       <table class=noborder>
				<colgroup> 
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>	    
    <tr>
       	  	<td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c76926bcf0007")%></td>
       		<td class="FieldValue">
       		
       			<select name=requestlevel>
       				<option value="" selected></option>
       				<option value="402881eb0c42cba0010c42ff38860008" ><%=labelService.getLabelName("402881eb0bd74dcf010bd751b7610004")%></option> 
       				<option value="402881eb0c42cba0010c42ff38860009" ><%=labelService.getLabelName("402881ef0c768f6b010c76ac26f80014")%></option>
       				<option value="402881eb0c42cba0010c42ff3886000a"><%=labelService.getLabelName("402881ef0c768f6b010c76abd9740011")%></option> 
       			</select> 
       		</td>	
        <td class="FieldName" nowrap><%=labelService.getLabelName("402881e50c6d5390010c6d5d5d220007")%></td><!--流程类型 -->
       <td class="FieldValue">

          	<input type="button"  class=Browser onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflowid','workflowidspan','0');" />
            <input type="hidden" name="workflowid" value="<%=workflowid%>"/>
            <span id="workflowidspan"></span>
       </td>
     </tr>
     
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71e4c130007")%></td>
       		<td class="FieldValue">
       			<select name=isfinished><!-- isfinished-->
       				<option value="-1" selected></option> 
       				<option value="1" ><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option> 
       				<option value="0" ><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option>
       			</select> 
       		</td>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c7692e5360009")%></td>
       		<td class="FieldValue">
       			<select name=isdelete>
       				<option value="-1" selected></option> 
       				<option value=0 ><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option> 
       				<option value=1 ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
       			</select> 
       		</td>	
     </tr>
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd7215e7b000a")%></td>
      	<td class="FieldValue">
       		<input type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');" />
              <input type=hidden name="creator" id="creator" value="">
              <span id=creatorspan></span>
	    </td>

	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
       		<td class="FieldValue" align=left>
       			<input type="text"  name="createdatefrom" size="10" onclick="WdatePicker()"/>
					-&nbsp&nbsp
       			<input type="text"  name="createdateto" size="10" onclick="WdatePicker()"/>
       			 </td>
     	</tr>
	     <tr>
	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></td>
	      	<td class="FieldValue"><input name="requestname" value="" class="InputStyle2" style="width=95%" ></td>
		    <td class="FieldName" nowrap></td>
	        <td class="FieldValue" align=left></td>
	     </tr>
		</table>
    </form>
</div>
<script language="javascript">
  function onReturn(){
	  if(!Ext.isSafari){
        	window.parent.close();
	  }else{
          window.parent.close();
       }
}

  function onClear(){
     if(!Ext.isSafari){
       	getArray("0","");
     }else{
        getArray("0","");
       	//dialogValue=["0",""];
        parent.win.close();
     }
}
    function onSubmit(){
       var ids='';
       var names='';
       selectedStore.each(function(record){
           if(ids!=''){
           ids+=','+record.get('id');
           names+=','+record.get('<%=showfield%>');
           }
           else{
           ids+=record.get('id');
           names+=record.get('<%=showfield%>');
           }
       })
       if(!Ext.isSafari){
       		getArray(ids,names);
       }else{
           var tem = new Array();
           tem[0] = ids;
            tem[1] = names;
          window.parent.returnValue = tem;
          window.parent.close();
	      // dialogValue=tem;
	     // parent.window.close();
	    //  dialogValue=[ids,names];
	     // alert(2);
	      //dialogValue =tem;
	       // dialogValue = [ids,names];
            //parent.dialogValue = [ids,names];
         // parent.dialogValue = tem;
	     // parent.window.close();
       }
   }
    var win;
     function getBrowser(viewurl,inputname,inputspan,isneed){
    	 if(!Ext.isSafari){  
		    var id;
		    try{
		    id=openDialog('/base/popupmain.jsp?url='+viewurl);
		    }catch(e){}
			if (id!=null) {
				if (id[0] != '0') {
					document.all(inputname).value = id[0];
					document.all(inputspan).innerHTML = id[1];
			
			    }else{
					document.all(inputname).value = '';
					if (isneed=='0')
					document.all(inputspan).innerHTML = '';
					else
					document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
			
			    }
		     }
    	 }else{
    		//----
       	    var callback = function() {
       	            try {
       	                id = dialog.getFrameWindow().dialogValue;
       	            } catch(e) {
       	            }
       	         if (id!=null) {
     				if (id[0] != '0') {
     					document.all(inputname).value = id[0];
     					document.all(inputspan).innerHTML = id[1];
     			
     			    }else{
     					document.all(inputname).value = '';
     					if (isneed=='0')
     					document.all(inputspan).innerHTML = '';
     					else
     					document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
     			
     			    }
     		     }
       	        }
       	        if (!win) {
       	             win = new Ext.Window({
       	                layout:'border',
       	                width:Ext.getBody().getWidth()*0.95,
       	                height:Ext.getBody().getHeight()*0.95,
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
       		
       	//----
 }
function onSearch2(){
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
       store.baseParams.sqlwhere='<%=sqlwhere%>';
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
    $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
</script>
<script language=vbs>

Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub

Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

Sub btnclear_onclick()
     getArray "0",""
End Sub
Sub btnok_onclick()
	 
	 reloadResourceArray()
	 setResourceStr()
	tmp = selectedids
	curnum = 0
	while InStr(tmp,",") <> 0
		curid = Mid(tmp,1,InStr(tmp,",")-1)
		tmp = Mid(tmp,InStr(tmp,",")+1,Len(tmp))
		curnum = curnum+1
	wend
	if curnum><%=maxselected%> then 
		msgbox "人数超过限制<%=maxselected%>" 
	else
		getArray selectedids,namesselected
	end if
End Sub

</script>

  <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>








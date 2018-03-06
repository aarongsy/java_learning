<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.List"%>

<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>

<%
    int pageSize=20;
   String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
   if(selectItemId.equals("")) selectItemId = "402881e80b9a072f010b9a385914000a";//默认权限
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881e80b9a072f010b9a362b030008",null);//权限类型  
   SyspermsService syspermsService =(SyspermsService) BaseContext.getBean("syspermsService");
     RefobjService refobjService =(RefobjService) BaseContext.getBean("refobjService");
    BaseJdbcDao baseJdbcDao =(BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
   Selectitem selectitem = new Selectitem();;
   Sysperms sysperms = new Sysperms();   
%>

 <%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";
pagemenustr +=  "addBtn(tb,'清除','C','erase',function(){onClear()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
pagemenustr += "addBtn(tb,'确定','R','accept',function(){onSubmit()});";
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
      <script type="text/javascript">
      <%
      String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SyspermsAction?action=browserm";
         String idsin=StringHelper.null2String(request.getParameter("idsin"));
 String refid=StringHelper.null2String(request.getParameter("refid"));
  Refobj refobj1=refobjService.getRefobj(refid);
  String showfield=refobj1.getViewfield();
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

     // String showname="<a href=\"javascript:onUrl("+refobj1.getViewurl()+id+","+showfieldname+",tab"+id+")\" >"+showfieldname+"</a>";
        if(i==0){
            strdata="{"+refobj1.getKeyfield()+":'"+id+"',"+showfield+":'"+showfieldname+"'}";
        }else{
           strdata+=","+"{"+refobj1.getKeyfield()+":'"+id+"',"+showfield+":'"+showfieldname+"'}";
        }
    }
      %>
      var showfield = '<%=showfield%>';
      Ext.LoadMask.prototype.msg='加载...';
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
              fields: ["id","operation","permdesc"]
          }),
          remoteSort: true,
          autoLoad:false
      });
      //store.setDefaultSort('id', 'desc');
      sm=new Ext.grid.CheckboxSelectionModel();
      var cm = new Ext.grid.ColumnModel([sm,{header: "权限名称", sortable: false,  dataIndex: 'operation'},
           {header: "权限描述", sortable: false,   dataIndex: 'permdesc'}
      ]);
      cm.defaultSortable = true;
                     var grid = new Ext.grid.GridPanel({
                         title:'待选',
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
                             sortAscText:'升序',
                             sortDescText:'降序',
                             columnsText:'列定义',
                             getRowClass : function(record, rowIndex, p, store){
                                 return 'x-grid3-row-collapsed';
                             }
                         },
                         bbar: new Ext.PagingToolbar({
                             pageSize: <%=pageSize%>,
              store: store,
              displayInfo: true,
              beforePageText:"第",
              afterPageText:"页/{0}",
              firstText:"第一页",
              prevText:"上页",
              nextText:"下页",
              lastText:"最后页",
              refreshText:"刷新",
              displayMsg: '显示 {0} - {1}条记录 / {2}',
              emptyMsg: "没有结果返回"
          })
      });
            store.baseParams.selectItemId='<%=selectItemId%>';
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
                  tooltip:'删除',
                  style:'icon-del'
              }]
          });
          var cm1 = new Ext.grid.ColumnModel([{header: "资源名称", sortable: false,  dataIndex: 'operation'}
          ,action]);
          cm1.defaultSortable = false;
          var myData = {
                  records : [
                      <%=strdata%>
      ]
              };
          selectedStore = new Ext.data.JsonStore({
                  fields : ["id","operation","permdesc"],
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
              title:'已选',
              region: 'east',
              ddGroup: 'selectedGridDDGroup',
              ddText:'拖动',
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
                  text: '清空',
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
    <form action="<%= request.getContextPath()%>/base/security/sysperms/syspermsbrowserm.jsp" name="EweaverForm" id="EweaverForm"  method="post">
      <table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 权限名称
			 </td>
         <td class="FieldValue" width=40%>
            <input type="text" class="InputStyle2" id="objname" name="objname">
          </td>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcc6bb95e0021")%>
		 </td>                  
         <td class="FieldValue" width=40%>
		     <select class="inputstyle" id="selectItemId" name="selectItemId" onChange="javascript:onSearch2();">
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectItemId.equals(selectitem.getId())) selected = "selected";
                   
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>
                   <%
                   } // end while
                   %>
		       </select>
          </td>
    
	    </tr>        
       </table>
    </form>
    </div>
  </body>
 <script type="text/javascript">
        function onSearch2(){
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
       store.load({params:{start:0, limit:20}});
   }
         $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
        function onReturn(){
    if(Ext.isIE)
        window.parent.close();
        else{
            parent.win.close();
        }
}

       function onClear(){
    if(Ext.isIE)
       getArray("0","");
        else{
       dialogValue=["0",""];
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
       if(Ext.isIE)
       getArray(ids,names);
       else{
       dialogValue=[ids,names];
       parent.win.close();}
   }
  </script>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
</html>

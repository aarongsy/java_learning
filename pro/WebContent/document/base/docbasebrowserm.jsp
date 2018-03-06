<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjlinkService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjlink"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>

<%
    int pageSize=20;
String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
String categoryid=StringHelper.trimToNull(request.getParameter("categoryid"));
String doctypeid=StringHelper.trimToNull(request.getParameter("doctypeid"));
String author=StringHelper.trimToNull(request.getParameter("author"));
String createdatefrom=StringHelper.trimToNull(request.getParameter("createdatefrom"));
String createdateto=StringHelper.trimToNull(request.getParameter("createdateto"));
RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
 BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";
//清除
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','erase',function(){onClear()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
//确定
pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','R','accept',function(){onSubmit()});";
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
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
      <script type="text/javascript">
      <%
      String action=request.getContextPath()+"/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=docbasebrowser";
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
    	if(StringHelper.isEmpty(showfield)) showfield = "subject";
      %>
      var showfield = '<%=showfield%>';      
      Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
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
              fields: ["id","subject","objno"]
          }),
          remoteSort: true,
          autoLoad:false
      });
      //store.setDefaultSort('id', 'desc');
      sm=new Ext.grid.CheckboxSelectionModel();
      //文档标题     编号
      var cm = new Ext.grid.ColumnModel([sm,{header: "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890000")%>", sortable: false,  dataIndex: 'subject'},{header: "<%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772f75e3000a")%>", sortable: false,  dataIndex: 'objno'}
      ]);
      cm.defaultSortable = true;
                     var grid = new Ext.grid.GridPanel({
                         title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050005")%>',//待选
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
                             sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                             sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                             columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                             getRowClass : function(record, rowIndex, p, store){
                                 return 'x-grid3-row-collapsed';
                             }
                         },
                         bbar: new Ext.PagingToolbar({
                             pageSize: <%=pageSize%>,
              store: store,
              displayInfo: true,
              beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
              afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
              firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
              prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
              nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
              lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
              refreshText:"<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027")%>",//刷新
              displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示     条记录 
              emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
          })
      });
          store.baseParams.author='<%=author%>';            
          store.baseParams.doctypeid='<%=doctypeid%>';
          store.baseParams.categoryid='<%=categoryid%>';
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
                  tooltip:'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>',//删除
                  style:'icon-del'
              }]
          });
          var cm1 = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890000")%>", sortable: false,  dataIndex: 'subject'}//文档标题
          ,action]);
          cm1.defaultSortable = false;
          var myData = {
                  records : [
                      <%=strdata%>
      ]
              };
          selectedStore = new Ext.data.JsonStore({
                  fields : ["id","subject","objno",'action'],
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
              title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050006")%>',//已选
              region: 'east',
              ddGroup: 'selectedGridDDGroup',
              ddText:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050007")%>',//拖动
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
                  text: '<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050008")%>',//清空
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
   <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=browserm&sqlwhere=<%=sqlwhere%>" name="EweaverForm" id="EweaverForm" method="post">
     <TABLE ID=searchTable>
		  <tr>
			<td valign=top>
				       <table class=noborder>
						<colgroup> 
							<col width="20%">
							<col width="30%">
							<col width="20%">
							<col width="30%">
						</colgroup>	        
		     <tr>
				<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71c27e80004")%></td><!-- 主题-->
				<td class="FieldValue" ><input name="subject" value=""></td>
				<td class="FieldName" nowrap><%=labelService.getLabelName("402881ee0c715de3010c71ad6d46000a")%></td><!-- 作者-->
				<td class="FieldValue" >
		       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp','author','authorspan','0');"></button>
		            <span id="authorspan"></span>
		          	<input type="hidden" name="author" value=""/>
		       </td>     
		     </tr>
		     <tr>
		       <td class="FieldName" nowrap><%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%></td><!-- 分类体系-->
		       <td class="FieldValue" >      			
		          	<button type="button" class=Browser onclick="javascript:getBrowser('/base/category/categorybrowser.jsp?model=docbase','categoryid','categoryidspan','0');"></button>
		            <span id="categoryidspan"></span>
		            <input type="hidden" name="categoryid" value=""/>
		       </td>
		       <!-- <td class="FieldName" nowrap><%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%></td>--><!-- 文档类型-->
		       <!-- <td class="FieldValue">
		       		<input type="hidden" name="doctypeid" value=""/>
		          	<button  type="button" class=Browser onclick=""></button>
		            <span id="doctypeidspan"></span>
		       </td> -->
		     </tr>
		       <tr>
			       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
		       		<td class="FieldValue" align=left>
		       			<!-- <button class="Calendar" id=SelectDate  onclick="javascript:getdate('createdatefrom','createdatefromspan','0')"></button>&nbsp; 
		       			<button type="button" class="Calendar" id=SelectDate  onclick="javascript:getdate('createdatefrom','createdatefromspan','0')"></button>&nbsp; 
		       			<span id=createdatefromspan></span>-&nbsp;&nbsp;
		       			<button type="button" class="Calendar" id=SelectDate2 onclick="javascript:getdate('createdateto','createdatetospan','0')"></button>&nbsp; 
		       			<span id=createdatetospan></span>
		       			<input type=hidden name="createdatefrom" value="">
		       			<input type=hidden name="createdateto" value=""> -->
		       			<input type="text"  name="createdatefrom" size="10" onclick="WdatePicker()"/>
						-&nbsp&nbsp
       					<input type="text"  name="createdateto" size="10" onclick="WdatePicker()"/>
		       		</td>
		       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71b621f0003")%></td>
	       			<td class="FieldValue"><input name="objno" value=""></td>
			   </tr>
				</table>
	</TABLE>
   </form>
</div>
<script language="javascript" type="text/javascript">

    function onReturn(){
      if(!Ext.isSafari){
          window.parent.close();
          }else{
              window.parent.close();
          }
  }

         function onClear(){
      if(!Ext.isSafari)
         getArray("0","");
          else{
              getArray("0","");
              window.parent.close();
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
         if(!Ext.isSafari)
         getArray(ids,names);
         else {
         //dialogValue=[ids,names];
          getArray(ids,names);
          window.parent.close();}
     }
       function getBrowser(viewurl,inputname,inputspan,isneed){
      var id;
      try{
      id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
   }
        function getdate(inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",null,"dialogHeight:320px;dialogwidth:275px");
    }catch(e){}

	if (id!=null) {
		document.all(inputname).value = id;
		document.all(inputspan).innerHTML = id;
        if (id==""&&isneed=="1")
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
    }
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

</script>
  <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>








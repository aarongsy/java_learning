<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>

<%@ include file="/base/init.jsp"%>

<%
String pid=StringHelper.null2String(request.getParameter("pid"));
String searchName=StringHelper.trimToNull(request.getParameter("searchName"));
String typeid=request.getParameter("typeid");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");// new SelectitemService(); 
Selectitem selectitem = null;

if(!StringHelper.isEmpty(pid)){
	selectitem = selectitemService.getSelectitemById(pid);
	typeid=selectitem.getTypeid();
}

Selectitemtype selectitemtype= new Selectitemtype();
if(!StringHelper.isEmpty(typeid)){
	selectitemtype = ((SelectitemtypeService)BaseContext.getBean("selectitemtypeService")).getSelectitemtypeById(typeid);
}
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemAction?action=browser";

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'清除','C','cancel',function(){onClear()});";
   pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";

%>

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

        <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
        <script language="javascript">
        Ext.SSL_SECURE_URL='about:blank';
        Ext.LoadMask.prototype.msg='加载...';
        var store;
        var selected = new Array();
        var dlg0;
        var dlgtree;
        var nodeid;

         var  moduleTree
        Ext.onReady(function() {
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
                    fields: ['objname','objdesc','id']


                })

            });
            var sm = new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([{header: "选择项名称", sortable: false,  dataIndex: 'objname'},
                {header: "选择项说明", sortable: false,   dataIndex: 'objdesc'}

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
            //Viewport
               sm.on('rowselect',function(selMdl,rowIndex,rec ){
                   getArray(rec.get('id'),rec.get('objname'));

               });


            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
            });
            store.baseParams.typeid='<%=typeid%>' ;
            store.baseParams.pid = '<%=pid%>';
            store.load({params:{start:0, limit:20}});
        });
        </script>
       <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
         
  </head>

<body>
<div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
<form action="" name="EweaverForm" method="post" id="EweaverForm">
<input type="hidden" name="typeid" value="<%=typeid%>">
<input type="text" name="pid" style="display:none;"/>
<table>
			<tr class=Title>
				 <td class="FieldName" width=10% nowrap>
					   <%=labelService.getLabelName("402881e50acc0d40010acc4452220002")%>
					   <input type="text" class="InputStyle2" name="searchName" value="<%=StringHelper.null2String(searchName)%>"/>
				 </td>
			</tr>
			

<table>
</form>
</div>
  </body>

  <script>
  	var dialogValue;
	function onClear(){
		getArray("0","");
	}

	function onReturn(){
		 if(!Ext.isSafari){
			window.parent.close();
		 }else{
			 parent.win.close();
		 }
	}
  
    function getArray(id,value){
        if(!Ext.isSafari){
		    window.parent.returnValue = [id,value];
	        window.parent.close();
 		}else{
 		   dialogValue=[id,value];
 	       parent.win.close();
 		}
    }
</script>
<script language="javascript" type="text/javascript">
 function onSearch(){
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
 document.onkeydown=function(event){
	 var e = event || window.event || arguments.callee.caller.arguments[0];
	 if(e && e.keyCode==13){
		 onSearch();
	 }
 }  
</script>
</html>
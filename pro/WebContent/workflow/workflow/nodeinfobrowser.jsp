<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>


<%
   String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
    String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
    String refid=StringHelper.null2String(request.getParameter("refid"));
   String sqlwhere = StringHelper.null2String(request.getParameter("sqlwhere"));
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   Selectitem selectitem = new Selectitem();
   Workflowinfo workflowinfo = new Workflowinfo();
   if(selectItemId.equals("")) selectItemId = "402881ed0bd74ba7010bd75046bd0004";//默认流程类型
   List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//流程类型
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=nodeinfobrowser&refid="+refid+"&sqlwhere="+sqlwhere;

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
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
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
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
                    fields: ['objname','workflowname','id']


                })

            });
            var sm = new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c7248aaad0072") %>", sortable: false,  dataIndex: 'objname'},//节点名称
                {header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060") %>", sortable: false,   dataIndex: 'workflowname'}//流程名称
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
                                         sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
				                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
				                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                                         getRowClass : function(record, rowIndex, p, store){
                                             return 'x-grid3-row-collapsed';
                                         }
                                     },
                                     bbar: new Ext.PagingToolbar({
                                         pageSize: 20,
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
            //Viewport
               sm.on('rowselect',function(selMdl,rowIndex,rec ){
                   getArray(rec.get('id'),rec.get('objname'));

               });


            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
            });
            store.baseParams.selectItemId='<%=selectItemId%>' ;
            store.baseParams.moduleid='<%=moduleid%>';
            store.load({params:{start:0, limit:20}});
        });
        </script>
       <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </head>
  <body>
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
    <form action="<%=request.getContextPath()%>/workflow/workflow/workflowinfobrowser.jsp" name="EweaverForm"  method="post" id="EweaverForm">
       <table id="searchTable">
        <tr>
           <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060") %><!-- 流程名称 --></td>
         <td class="FieldValue" width="15%">
              <input name="objname" id="objname" value="" />
          </td>
               <td class="FieldName" nowrap></td>
         <td class="" width="80%"></td>
	    </tr>
       </table>
     </form>
 </div>
 <script type="text/javascript">
     function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 </script>
  <script >     
   function onClear(){
	    if(!Ext.isSafari)
	       getArray("0","");
	        else{
	       dialogValue=["0",""];
	            parent.win.close();
	        }
	}

    function onReturn(){
	    if(!Ext.isSafari)
	        window.parent.close();
	        else{
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
 <script language="javascript">
 	var nav = new Ext.KeyNav("objname", {
	    "enter" : function(e){
	        onSearch();
	    },
	    scope:this
	});
 
    function onSearch() {
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

</SCRIPT>


  </body>
</html>

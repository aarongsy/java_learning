<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>


<%

    String action=request.getContextPath()+"/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=list";

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','cancel',function(){onClear()});";//清除
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
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
        <script language="javascript">
        Ext.SSL_SECURE_URL='about:blank';
        Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
        var store;
        var selected = new Array();
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
            fields: ['objname','inneradd','outteradd','username','pass','sysid']
        })

    });
    var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%>",  sortable: false,  dataIndex: 'objname'},//名称
                {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000e")%>", sortable: false,   dataIndex: 'inneradd'},//内网地址
    {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000f")%>", sortable: false,   dataIndex: 'outteradd'},//外网地址
    {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780010")%>", sortable: false,   dataIndex: 'username'},//账号参数名
    {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780011")%>", sortable: false,   dataIndex: 'pass'}]);//密码参数名

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
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
        })

    });
            //Viewport
               sm.on('rowselect',function(selMdl,rowIndex,rec ){
                   getArray(rec.get('sysid'),rec.get('objname'));

               });


            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
            });
            store.load({params:{start:0, limit:20}});
        });
        </script>
       <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </head>
  <body>
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
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
        document.all('selectItemId').value = '';
        store.baseParams.selectItemId = '';
        store.baseParams.moduleid = id[0];
        store.load({params:{start:0, limit:20}});
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
  <script language=vbs>

    Sub onClear
        getArray "0",""
     End Sub

     Sub onReturn
        window.parent.Close
     End Sub
      </script>
 <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
 <script language="javascript">
    function onSearch() {
        document.all('moduleid').value = '';
        document.all('moduleidspan').innerText = '';
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

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%
    String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
	String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getCategoryList&sqlwhere="+sqlwhere;
%>
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";//快捷搜索
pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','erase',function(){onClear()});";//清除
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
%>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="/css/global.css">
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script>Ext.BLANK_IMAGE_URL = '<%= request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <style type="text/css">
      .x-toolbar table {width:0}
      .x-panel-btns-ct {
          padding: 0px;
      }
      .pkg{
          background-image: url(<%=request.getContextPath()%>/images/silk/config.gif) !important;
      }
  </style>
<script type="text/javascript">
var store;
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
            fields: ['objid','categoryDir','objname']
        })

    });
    var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320023")%>", sortable: false,  dataIndex: 'objname'},//分类名称
        {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790065")%>", sortable: false,dataIndex: 'categoryDir'}//分类目录
    ]);
    cm.defaultSortable = true;
    var sm = new Ext.grid.CheckboxSelectionModel();
    var grid = new Ext.grid.GridPanel({
        region: 'center',
        store: store,
        cm: cm,
        trackMouseOver:false,
        sm:sm,
        loadMask: true,
        viewConfig: {
            forceFit:true,
            enableRowBody:true,
            sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
            sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
            columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>'//列定义
        }
    });
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
    	getArray(rec.get('objid'),rec.get('objname'));
    });
    //Viewport
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
    });
    onSearch();
});
</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">
  <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div> 
    <form action="<%=request.getContextPath()%>/base/category/categorylist.jsp" name="EweaverForm"  method="post" id="EweaverForm">
       <table id="searchTable">
        <tr>
           <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%><!-- 模块名称 --></td>
         <td class="FieldValue" width="15%">
            <button  type="button" class=Browser onclick="javascript:getBrowser('/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden"  name="moduleid" id="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
          <td class="FieldName" width=10% nowrap >
			 <%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320023")%><!-- 分类名称 -->
		  </td>
          <td class="FieldValue" >
              <input name="objname" id="objname" value=""/>
           </td>
	    </tr>        
       </table>
     </form>
 </div>
 <script type="text/javascript">
 var nav = new Ext.KeyNav("objname", {
 	"enter" : function(e){
     	onSearch();
 	},
 	scope:this
	}); 
	
 function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
        id=openDialog('/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
		if (id[0] != '0') {
	        document.all(inputname).value = id[0];
	        document.all(inputspan).innerHTML = id[1];
	        store.baseParams.selectItemId = '';
	        store.baseParams.moduleid = id[0];
	        store.load();
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0')
			document.all(inputspan).innerHTML = '';
			else
			document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
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
        store.load();
    }
</SCRIPT>    
</body>
</html>
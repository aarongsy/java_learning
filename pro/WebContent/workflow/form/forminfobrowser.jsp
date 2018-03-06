<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<jsp:useBean id="forminfoService" class="com.eweaver.workflow.form.service.ForminfoService" />
<%
String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
String sqlwhere = StringHelper.trimToNull(request.getParameter("sqlwhere"));
String reporttype = StringHelper.trimToNull(request.getParameter("reporttype"));
String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
    ModuleService moduleService = (ModuleService) BaseContext.getBean("moduleService");
      String modulespan="";
    if(!StringHelper.isEmpty(moduleid)){
modulespan=moduleService.getModule(moduleid).getObjname();
    }
//如果是系统报表类型
if("4028801111bdd00d0111bdd694290005".equals(reporttype)){
	selectItemId = "402881e60c85ac00010c864dfcc20057";
}

SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a",null);
Selectitem selectitem;
String strObjtype=StringHelper.null2String(request.getParameter("objtype"));
      String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=getforminfolist";
%>
 <%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'清除','C','cancel',function(){onClear()});";
   pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";

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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
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
    var dialogValue ;
    
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
                fields: ['objname','objdesc','formtype','objtable','modify','modulename','id']


            })

        });
        var sm = new Ext.grid.CheckboxSelectionModel();

        var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %>", sortable: false,  dataIndex: 'objname'},//表单名称
            {header: "<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b33919af10003") %>", sortable: false,   dataIndex: 'objdesc'},//表单描述
            {header: "<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c21eed0001") %>",  sortable: false, dataIndex: 'formtype'},//表单类型
            {header: "<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c3f9fc0002") %>",  sortable: false,dataIndex: 'objtable'},//数据库表名
            {header: "&nbsp;",  sortable: false, dataIndex: 'modify'},
            {header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000") %>",  sortable: false, dataIndex: 'modulename'}//模块名称
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
        	   if(!Ext.isSafari)
	               getArray(rec.get('id'),rec.get('objname'));
        	     else{
        	     	  dialogValue=[rec.get('id'),rec.get('objname')];
        	          parent.win.close();
        	      }

           });


        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        store.baseParams.selectItemId='<%=selectItemId%>' ;
        store.baseParams.moduleid = '<%=moduleid%>';
        store.baseParams.objtype='<%=strObjtype%>'
        store.load({params:{start:0, limit:20}});
    });
    </script>
   <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
    </head>
  
  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>      
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=searchbrowser" name="EweaverForm" id="EweaverForm" target="_self" method="post">
				<input type="hidden" name="objtype" value='<%=strObjtype%>' />
	   <table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
		 </td>                  
         <td class="FieldValue">
         <%
         if("4028801111bdd00d0111bdd694290005".equals(reporttype)){
         %>
         	<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370065") %><!-- 系统表 -->

         <%
         }else{
         %>
		     <select class="inputstyle" id="selectitemid" name="selectitemid" onchange="javascript:onSearch();">
                  <option value="" <%=selectItemId==null?"selected":""%>></option>
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";

					  if(!"402881e60c85ac00010c864dfcc20057".equals(selectitem.getId())){
						  if(selectitem.getId().equals(selectItemId)) selected = "selected";  
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>
                   
                   <%
                   }}} // end while
                   %>
		       </select>
		      
          </td>
             <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("402883d934c1bfa30134c1bfa4540000") %><!-- 模块 -->
		 </td>
         <td class="FieldValue" width="15%">

              <button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden" id="moduleid"  name="moduleid" value="<%=moduleid%>"/>
			<span id="moduleidspan" name="moduleidspan"><%=modulespan%></span>
          </td>
          <td  class="FieldName" nowrap>
            <%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %><!-- 表单名称 --> 
          </td>
          <td class="FieldValue">
             <input type="text" name= "tbname" id="tbname" />
          </td>
	  
	    </tr>        
             
   </table>


			<br>

		</form>
      </div>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script language="javascript">
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
      $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch();
          $('#tbname').blur();
       }
   });
  
  var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
	    }catch(e){}
	
          if (id != null) {
              if (id[0] != '0') {
                  document.all(inputname).value = id[0];
                  document.all(inputspan).innerHTML = id[1];
              } else {
                  document.all(inputname).value = '';
                  if (isneed == '0')
                      document.all(inputspan).innerHTML = '';
                  else
                      document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

              }
          }
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
          if (id != null) {
              if (id[0] != '0') {
                  document.all(inputname).value = id[0];
                  document.all(inputspan).innerHTML = id[1];
              } else {
                  document.all(inputname).value = '';
                  if (isneed == '0')
                      document.all(inputspan).innerHTML = '';
                  else
                      document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

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

</script>

    <script>
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
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>



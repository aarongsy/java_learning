<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>

<%@ include file="/base/init.jsp"%>

<%
String browsername=StringHelper.null2String(request.getParameter("browsername"));
RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
    ModuleService moduleService = (ModuleService)BaseContext.getBean("moduleService");

 String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getrefobjlist";
 if(!StringHelper.isEmpty(browsername)){
	 action=action+"&browsername1="+browsername;
 }
  String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
     String modulespan="";
    if(!StringHelper.isEmpty(moduleid)){
modulespan=moduleService.getModule(moduleid).getObjname();
    }
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
   Ext.SSL_SECURE_URL = 'about:blank';
   Ext.LoadMask.prototype.msg = '加载...';
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
           totalProperty: 'totalcount',
           fields: ['objname','priview','refurl','reftable','keyfield','viewfield','filter','viewurl','coll','modulename','id']


       })

   });
   var sm = new Ext.grid.CheckboxSelectionModel();

   var cm = new Ext.grid.ColumnModel([ {header: "关联对象名称", width:600, sortable: false,  dataIndex: 'objname'},
       {header: "Browser预览", sortable: false, width:300,   dataIndex: 'priview'},
       {header: "关联URL",  sortable: false,width:600, dataIndex: 'refurl'},
       {header: "模块名称",  sortable: false,width:200, dataIndex: 'modulename'},
       {header: "关联数据库表",  sortable: false, width:50,dataIndex: 'reftable'},
       {header: "主字段",  sortable: false,width:50, dataIndex: 'keyfield'},
       {header: "显示名称",  sortable: false, width:50,dataIndex: 'viewfield'},
       {header: "过滤条件",  sortable: false,width:50, dataIndex: 'filter'},
       {header: "显示URL",  sortable: false, width:50,dataIndex: 'viewurl'},
       {header: "排序",  sortable: false,width:50, dataIndex: 'coll'}
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
      }
              );


   var viewport = new Ext.Viewport({
       layout: 'border',
       items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
   });
       store.baseParams.moduleid = '<%=moduleid%>';
   store.load({params:{start:0, limit:20}});
   });
   </script>
   <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
      
  </head>

<body>
 <div id="divSearch">
  <div id="pagemenubar"></div>
      <form action="" id="EweaverForm" name="EweaverForm" method="post">

      <table>
          <tr>
               <td class="FieldName" width=8% nowrap>模块<img style="cursor:pointer;" alt="清除模块" src="/images/silk/erase.gif" align="absmiddle" onclick="javascript:cleanModule();"> </td>
         <td class="FieldValue" width="15%">

              <input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"/>
			<input type="hidden" id="moduleid"  name="moduleid" value="<%=moduleid%>"/>
			<span id="moduleidspan"><%=modulespan%></span>
          </td>
              <td class="FieldName" width=10% nowrap>browser名称：<input type="text" id="browsername" name="browsername">
		 </td>
         <td>
         <td ></td>
          </tr>
      </table>
          </form>
  </div>
	</form>
	</div>
<script type="text/javascript">
var nav = new Ext.KeyNav("browsername", {
    "enter" : function(e){
        onSearch();
    },
    scope:this
}); 

function onClear(){
	getArray(0,"");
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
function cleanModule(){
	var moduleid = document.getElementById("moduleid");
	var moduleidspan = document.getElementById("moduleidspan");
	moduleid.value="";
	moduleidspan.innerHTML="";
	onSearch();
}
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
var win;
function getBrowser(viewurl, inputname, inputspan, isneed) {
    var id;
	if(!Ext.isSafari){
	    try {
	        id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
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
	    var winHeight = Ext.getBody().getHeight() * 0.9;
	    var winWidth = Ext.getBody().getWidth() * 0.9;
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
</body>
</html>
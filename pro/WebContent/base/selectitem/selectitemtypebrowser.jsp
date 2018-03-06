<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>

<%@ include file="/base/init.jsp"%>

<%
String selectitemtypeid=StringHelper.null2String(request.getParameter("selectitemtypeid"));
SelectitemtypeService selectitemtypeService = (SelectitemtypeService)BaseContext.getBean("selectitemtypeService");
  ModuleService moduleService = (ModuleService)BaseContext.getBean("moduleService");
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
     String modulespan="";
    if(!StringHelper.isEmpty(moduleid)){
modulespan=moduleService.getModule(moduleid).getObjname();
    }
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=getselectitemtypelist";
     String sql="select * from selectitemtype where pid is null and moduleid is null";
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List selectitemlist=baseJdbcDao.getJdbcTemplate().queryForList(sql);
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
                fields: ['objname','modify','modulename','id']


            })

        });
        var sm = new Ext.grid.CheckboxSelectionModel();
        var cm = new Ext.grid.ColumnModel([ {header: "select字段名", sortable: false,  dataIndex: 'objname'},
            {header: "模块名称",  sortable: false, dataIndex: 'modulename'},
            {header: "&nbsp;",  sortable: false, dataIndex: 'modify'}

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
   <form action="<%= request.getContextPath()%>/base/selectitem/selectitemtypebrowser.jsp" name="EweaverForm" id="EweaverForm"  method="post">
   <table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
		 </td>
         <td class="FieldValue">

              <select class="inputstyle" style='size:30;' id="selectitemtypeid" name="selectitemtypeid" onChange="javascript:cleanModule();">
                  <option value=""></option>
                  <%
                  for(Object o:selectitemlist){
                         String id=((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
                         String objname=((Map) o).get("objname") == null ? "" : ((Map) o).get("objname").toString();
					  String selected = "";
					  if(id.equals(selectitemtypeid)) selected = "selected";
                   %>
                   <option value=<%=id%> <%=selected%>><%=objname%></option>

                   <%
                   } // end while
                   %>
		       </select>
          </td>
          <td class="FieldName" width=10% nowrap>模块  <img style="cursor:pointer;" alt="清除模块" src="/images/silk/erase.gif" align="absmiddle" onclick="javascript:cleanModule();"></td>
         <td class="FieldValue" width="15%">
              <input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');" />
			<input type="hidden" id="moduleid"  name="moduleid" value="<%=moduleid%>"/>
			<span id="moduleidspan"><%=modulespan%></span>
          </td>
            <td  class="FieldName" nowrap>
            select字段名
          </td>
          <td class="FieldValue">
             <input type="text" name= "objname" id="objname"/>
          </td>
	    </tr>        
             
   </table>
	</form>
	
  </div>


<SCRIPT language="javascript"> 
var dialogValue;
var nav = new Ext.KeyNav("objname", {
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
     }
 });
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
                $("#selectitemtypeid").get(0).options[0].selected =true;
                onSearch();
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
                         $("#selectitemtypeid").get(0).options[0].selected =true;
                         onSearch();
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
</script>
  </body>
</html>
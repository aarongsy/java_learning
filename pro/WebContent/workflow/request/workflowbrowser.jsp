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
<%
String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
  String workflowid  =  StringHelper.null2String(request.getParameter("workflowid"));
  String isMeddle  =  StringHelper.null2String(request.getParameter("isMeddle"));
  String creator=StringHelper.null2String(request.getParameter("creator"));
  String createdatefrom  =  StringHelper.null2String(request.getParameter("createdatefrom"));
  String createdateto=StringHelper.null2String(request.getParameter("createdateto"));
  String selectItemId = request.getParameter("selectItemId");
  String refid=StringHelper.null2String(request.getParameter("refid"));
  
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//资源类型  
  String keyfield=StringHelper.null2String(request.getParameter("keyfield"));
  String showfield=StringHelper.null2String(request.getParameter("showfield"),"requestname");
  Selectitem selectitem = new Selectitem();
  RequestbaseService requestbaseService = (RequestbaseService)BaseContext.getBean("requestbaseService");

%>

<%

CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
List workflowinfolist = workflowinfoService.getAllWorkflowinfo();
String userid = request.getParameter("userid");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
Page pageObject = (Page) request.getAttribute("pageObject");

	EweaverUser curuser = BaseContext.getRemoteUser();
	String username = curuser.getUsername();
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=browser&refid="+refid+"&isMeddle="+isMeddle;

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
        <script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
        <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
        <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
        <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
        <script type="text/javascript" src="/js/ext/ux/TreeCheckNodeUI.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
        <script language="javascript">
        Ext.SSL_SECURE_URL='about:blank';
        Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
        var store;
        var selected = new Array();
        var dlg0;
        var dlgtree;
        var nodeid;

         var  moduleTree
         var dialogValue;
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
                    fields: ['requestname','time','creator','isfinish','id']


                })

            });
            var sm = new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060") %>", sortable: false,  dataIndex: 'requestname'},//流程名称
                {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008") %>", sortable: false,   dataIndex: 'time'},//创建时间
                {header: "<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006") %>", sortable: false,   dataIndex: 'creator'},//创建者
                {header: "<%=labelService.getLabelNameByKeyId("402881ec0cbb8cc8010cbbf030f8002d") %>", sortable: false,   dataIndex: 'isfinish'}//是否结束


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
                if(!Ext.isSafari){
                   getArray(rec.get('id'),rec.get('<%=showfield%>'));
           		}else{
           			dialogValue=[rec.get('id'),rec.get('<%=showfield%>')];
           			parent.win.close();
           		}

               });


            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
            });
            store.baseParams.selectItemId='<%=selectItemId%>' ;
            store.baseParams.workflowid='<%=workflowid%>' ;
            store.baseParams.creator='<%=creator%>' ;
            store.baseParams.createdatefrom='<%=createdatefrom%>' ;
            store.baseParams.createdateto='<%=createdateto%>' ;
            <%
                if(!"".equals(isMeddle)){
            %>
                store.baseParams.isfinished=0;
            <%
                }
            %>
            store.baseParams.sqlwhere='<%=sqlwhere%>';
            store.load({params:{start:0, limit:20}});
        });
        </script>
       <script>Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';</script>

        
  </head>
  
  <body >
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div> 
	<form action="" name="EweaverForm" method="post" id="EweaverForm">
    <table width="100%">
     <colgroup>
     <col width="15%">
     <col width="35%">
     <col width="15%">
     <col width="35%">


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
       		<input type="hidden" name="workflowid" value="<%=workflowid%>"/>       			
          	<input type="button"  class=Browser onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflowid','workflowidspan','0');" />
            <span id="workflowidspan"></span>
       </td>
     </tr>
     
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71e4c130007")%></td>
       		<td class="FieldValue">
            <%
                if(!"".equals(isMeddle)){
            %>
                <span><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %><!-- 否 --></span>
            <%
                }else{
            %>
       			<select name=isfinished><!-- isfinished-->
       				<option value="-1" selected></option>
       				<option value="1" ><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option>
       				<option value="0" ><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option>
       			</select>
            <%
                }
            %>
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
	       	<span id=creatorspan></span>
	       	<input type=hidden name=creator value=>
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
 <script>
	function onClear(){
		if(!Ext.isSafari){
			getArray("0","");
   		}else{
   			dialogValue=["0",""];
   			parent.win.close();
   		}
	}

	function onReturn(){
		if(!Ext.isSafari){
            window.parent.close();
    	}else{
            parent.win.close();
        }
	}
	
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
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
        <%
            if(!"".equals(isMeddle)){
        %>
            store.baseParams.isfinished=0;
        <%
            }
        %>
      store.baseParams.sqlwhere='<%=sqlwhere%>';
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
	              id = openDialog('/base/popupmain.jsp?url=' + viewurl);
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
	                      document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	
	              }
	          }
          }else{
        	//----
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
    	                      document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
    	
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
</script>
  </body>
</html>

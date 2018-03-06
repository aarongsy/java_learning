<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<jsp:directive.page import="com.eweaver.base.refobj.service.RefobjService"/>
<jsp:directive.page import="com.eweaver.base.refobj.model.Refobj"/>
<jsp:directive.page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"/>
<jsp:directive.page import="org.json.simple.*"/>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>


<%
	String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
	String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
	String keyfield = StringHelper.null2String(request.getParameter("keyfield"));
	String showfield = StringHelper.null2String(request.getParameter("showfield"),"workflowname");
	if("objname".equals(showfield))showfield="workflowname";
	String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
	String isactive=StringHelper.null2String(request.getParameter("isactive"));
	SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
	  
	String refid=StringHelper.null2String(request.getParameter("refid"));
	RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
	Refobj refobj=refobjService.getRefobj(refid);
	String _viewurl=refobj.getViewurl();
	
   Selectitem selectitem = new Selectitem();
   Workflowinfo workflowinfo = new Workflowinfo();
   List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//流程类型
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=getworkflowinfolist&refid="+refid;
   if(!StringHelper.isEmpty(sqlwhere)){
     sqlwhere="&sqlwhere="+sqlwhere;
     action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=getworkflowinfolist&refid="+refid+sqlwhere;
   }
	
	String selected=StringHelper.null2String(request.getParameter("idsin"));
	if(!StringHelper.isEmpty(selected)){//生成已选中的值和显示文本
		
		String[] ids=selected.split(",");
		JSONObject json=new JSONObject();
		selected="";
		for(String id:ids){
			json.put("id",id);
			String objname=workflowinfoService.getWorkflowName(id);
			String showname=objname;
			if(!StringHelper.isEmpty(_viewurl)){
				showname = "<a title=\"" + objname + "\" href=javascript:try{onUrl(\""
				+ _viewurl
				+ id
				+ "\",\""
				+ objname
				+ "\",\"tab"
				+ id + "\")}catch(e){}>";
				showname += objname;
				showname += "</a>";
			}
			
			json.put("workflowname",showname);
			selected+=","+json.toString();
		}
		selected=selected.substring(1);
	}//end.if
    boolean isMulti=false;
    if(refobj!=null&&refobj.getId()!=null) {
	 isMulti=(refobj.getIsmulti()>0);
    }
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','O','accept',onOk);";//确定
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

        <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
        <script language="javascript"><!--
		
        function onOk(){
			var size=selectedStore.getCount();
			if(size<=0){
				alert('<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0001")%>');//请选中一项再确定
				return;
			}
			var ids="";
			var names="";
			for(var i=0;i<size;i++){
				var rc=selectedStore.getAt(i);
				if(i!=0){
					ids+=',';
					names+=',';
				}
				ids+=rc.get('id');
				names+=rc.get('workflowname')
			}
			if(!Ext.isSafari){
			    getArray(ids,names);
       		}else{
       			dialogValue=[ids,names];
       			parent.win.close();
       		}
		}

        Ext.SSL_SECURE_URL='about:blank';
        Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
        var store;
        var selected = new Array();
        var dlg0;
        var dlgtree;
        var nodeid;
		var selectedStore=null;
        var  moduleTree;
        var sm;
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
                    fields: ['workflowname','typename','modulename','id']


                })

            });
            sm = new Ext.grid.CheckboxSelectionModel();
   
            var cm = new Ext.grid.ColumnModel([<%if(isMulti)out.print("sm,");%>{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%>", sortable: false,  dataIndex: 'workflowname'},//流程名称
                {header: "<%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%>", sortable: false,   dataIndex: 'typename'},//分类
                {header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%>", sortable: false,   dataIndex: 'modulename'}//模块名称
            ]);
            cm.defaultSortable = true;
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
                          displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示    条记录
                          emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                      })

            });
            //Viewport
               sm.on('rowselect',function(selMdl,rowIndex,rec ){
                   <%if(!isMulti){%>
                   if(!Ext.isSafari){
	                   getArray(rec.get('id'),rec.get('<%=showfield%>'));
              		}else{
              			dialogValue=[rec.get('id'),rec.get('<%=showfield%>')];
              			parent.win.close();
              		}
					<%}else{%>
					  try{
     
           var foundItem = selectedStore.find('id', rec.data.id);
           if(foundItem==-1)
           selectedStore.add(rec);
        }catch(e){}
        <%}%>
               });
                  <%if(isMulti){%>	
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
  
    sm.on('rowdeselect',function(selMdl,rowIndex,rec ){
        try{
            var foundItem = selectedStore.find('id', rec.data.id);
            if(foundItem!=-1)
                selectedStore.remove(selectedStore.getAt(foundItem));
        }catch(e){}
    }
            );
          	
   <%}%>
       
          var sm1 = new Ext.grid.RowSelectionModel();
          var cm1 = new Ext.grid.ColumnModel([{width:25,header:"<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' style='cursor:pointer;' onclick='removeAll();'/>",sortable:false,renderer:function(v){
          		return "<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' title='<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>' style='cursor:pointer;'>";//删除
          	}},
          	{header: "<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0002")%>", width:150,sortable: false,  dataIndex: 'workflowname'}]);//工作流名称
			selectedStore = new Ext.data.JsonStore({
                  fields : ["id","workflowname"],
                  data   : [<%=selected%>],
                  id:"id"
              });
          var selectedRecord=Ext.data.Record.create([
           {name: 'id', type: 'string'},
           {name: 'workflowname', type: 'string'}]);
          
          var selectedGrid = new Ext.grid.GridPanel({
              title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050006")%>',//已选
              region: 'east',
              enableDragDrop:false,
              store: selectedStore,
              cm: cm1,
              trackMouseOver:false,
              sm:sm1 ,
              enableColumnHide:false,
              enableHdMenu:false,
              collapseMode:'mini',
              split:true,
              listeners:{
              	cellclick:function(grid,rowIndex,columnIndex,e){
              		if(columnIndex!=0) return;
              		var obj=selectedStore.getAt(rowIndex);
              		selectedStore.remove(obj);
              		var foundItem=store.find('id',obj.get('id'));
              		sm.deselectRow(foundItem);
              	}
              },
              width: 225,
              store: selectedStore
          });

            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid<%if(isMulti)out.print(",selectedGrid");%>]
            });
            onSearch();
           	
            $("#objname").keydown(function(event) {
				if (event.keyCode == 13) {
					onSearch();
				}
			});
        });
         
         function removeAll(){
        	 selectedStore.removeAll();
        	 sm.clearSelections();
         }
        --></script>
       <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </head>
  <body>
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div> 
    <form action="<%=request.getContextPath()%>/workflow/workflow/workflowinfobrowser.jsp" name="EweaverForm"  method="post" id="EweaverForm" onsubmit="return false">
       <table id="searchTable">
        <tr>

           <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%></td><!-- 模块名称 -->
         <td class="FieldValue" width="15%">

              <input type="button"  class=Browser onclick="javascript:getBrowser('/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');" />
			<input type="hidden"  name="moduleid" id="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
          <td class="FieldName" width=10% nowrap >
			 <%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%><!-- 流程名称 -->
		  </td>
          <td class="FieldValue" >
              <input   name="objname" id="objname" value=""/>

           </td>
          <td class="FieldName" width=10% nowrap >
			<%=labelService.getLabelNameByKeyId("402881e70c864b41010c867b2eb40010")%><!-- 流程状态 -->
		  </td>
          <td class="FieldValue" width=20%>
              <select id="isactive" name="isactive">
                  <option value='1' selected="selected"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%></option><!-- 显示 -->
                  <option value='2'><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%></option><!-- 隐藏 -->
                  <option value='0'><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0003")%></option><!-- 禁用 -->

              </select>
           </td>
	    </tr>        
       </table>
     </form>
 </div>
 <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
 <script type="text/javascript">
     
     var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
	    }catch(e){}
	
	if (id!=null) {
	if (id[0] != '0') {
        document.all(inputname).value = id[0];
        document.all(inputspan).innerHTML = id[1];
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
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
	if (id!=null) {
	if (id[0] != '0') {
        document.all(inputname).value = id[0];
        document.all(inputspan).innerHTML = id[1];
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

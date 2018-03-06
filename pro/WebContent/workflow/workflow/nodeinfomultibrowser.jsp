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
    String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
    String isactive=StringHelper.null2String(request.getParameter("isactive"));
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
   NodeinfoService nodeinfoService=(NodeinfoService)BaseContext.getBean("nodeinfoService");
   String keyfield=StringHelper.null2String(request.getParameter("keyfield"));
   String showfield=StringHelper.null2String(request.getParameter("showfield"),"objname");
   Selectitem selectitem = new Selectitem();
   Workflowinfo workflowinfo = new Workflowinfo();
   List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//流程类型
   
	String refid=StringHelper.null2String(request.getParameter("refid"));
	RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
	Refobj refobj=refobjService.getRefobj(refid);
	String _viewurl=refobj.getViewurl();
	
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=nodeinfobrowser&refid="+refid;
   if(!StringHelper.isEmpty(sqlwhere)){
     sqlwhere="&sqlwhere="+sqlwhere;
     action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=nodeinfobrowser&refid="+refid+sqlwhere;
   }
	String selected=StringHelper.null2String(request.getParameter("idsin"));
	if(!StringHelper.isEmpty(selected)){//生成已选中的值和显示文本
		String[] ids=selected.split(",");
		JSONObject json=new JSONObject();
		selected="";
		for(String id:ids){
			json.put("id",id);
			String objname=StringHelper.null2String(nodeinfoService.get(id).getObjname());
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
			json.put("objname",showname);
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
        var dialogValue ;
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
		names+=rc.get('<%=showfield%>')
	}
//	alert(ids+'\n'+names);
    if(!Ext.isSafari)
	    getArray(ids,names);
     else{
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
			//var multiSm=new Ext.grid.RowSelectionModel({
	          	//listeners:{rowselect :function(_this,rowIndex,r){
	          	//	var rc=new selectedRecord({id:r.get('id'),workflowname:r.get('workflowname')});
	          	//	rc.id=r.get('id');
	          	//	if(selectedStore.indexOfId(r.get('id'))<0)
		          		//selectedStore.add(rc);
	          //	}}
          //	});
        
   
            var cm = new Ext.grid.ColumnModel([<%if(isMulti)out.print("sm,");%>{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c7248aaad0072")%>", sortable: false,  dataIndex: 'objname'},//节点名称
                {header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%>", sortable: false,   dataIndex: 'workflowname'}//,流程名称
                //{header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%>", sortable: false,   dataIndex: 'id'}//模块名称
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
                   getArray(rec.get('id'),rec.get('<%=showfield%>'));
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
          var cm1 = new Ext.grid.ColumnModel([{width:25,header:"<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif'/>",sortable:false,renderer:function(v){
          		return "<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' title='<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>' style='cursor:pointer;'>";//删除
          	}},
          	{header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c7248aaad0072")%>", width:150,sortable: false,  dataIndex: 'objname'}]);//工作流名称
			selectedStore = new Ext.data.JsonStore({
                  fields : ["id","<%=showfield%>"],
                  data   : [<%=selected%>],
                  id:"id"
              });
          var selectedRecord=Ext.data.Record.create([
           {name: 'id', type: 'string'},
           {name: '<%=showfield%>', type: 'string'}]);
          
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
              		selectedStore.remove(selectedStore.getAt(rowIndex));
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
        });
        --></script>
       <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </head>
  <body>
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div> 
    <form action="<%=request.getContextPath()%>/workflow/workflow/nodeinfomultibrowser.jsp" name="EweaverForm"  method="post" id="EweaverForm">
       <table id="searchTable">
        <tr>

          <td class="FieldName" width=10% nowrap >
			 <%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%><!-- 流程名称 -->
		  </td>
          <td class="FieldValue" >
              <input   name="objname" id="objname" value=""/>

           </td>
	    </tr>        
       </table>
     </form>
 </div>


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
 <script language="javascript"> 
    function onSearch() {
        //document.all('moduleid').value = '';
        //document.all('moduleidspan').innerText = '';
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

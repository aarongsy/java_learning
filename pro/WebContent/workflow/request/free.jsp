<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.workflow.workflow.model.*" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String requestid = StringHelper.null2String(request.getParameter("requestid"));
String nodeid = StringHelper.null2String(request.getParameter("nodeid"));
String workflowid = StringHelper.null2String(request.getParameter("workflowid"));

NodeinfoFreeService nodeinfoFreeService = (NodeinfoFreeService)BaseContext.getBean("nodeinfoFreeService");
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
DataService ds = new DataService();
String sql = "";
List list = null;
Map map = null;
String strOperators="", strIds="", strObjnames="";

List<NodeinfoFree> listNode = nodeinfoFreeService.getNodelistByRequestidNodeid(requestid,nodeid);
for(NodeinfoFree nf : listNode){
	strIds = nf.getOperators();
	strObjnames = humresService.getHrmresNameById(strIds);
	strOperators += "".equals(strOperators) ? "['"+strIds+"','"+strObjnames+"']" : ",['"+strIds+"','"+strObjnames+"']";	
}
%>
<html>
<head>
<title><%=labelService.getLabelName("自由流转节点设置") %></title>
<style type="text/css">
table{width:0;}
.x-panel-btns-ct {
    padding: 0px;
}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/browserfield.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript"><!--
var ds, storeOperators;
Ext.onReady(function() {
	var NodeinfoFree = Ext.data.Record.create([
		{name: 'id', mapping: 'id'},
		{name: 'workflowid', mapping: 'workflowid'},
		{name: 'objname', mapping: 'objname'},
		{name: 'requestid', mapping: 'requestid'},
		{name: 'nodetype', mapping: 'nodetype'},
		{name: 'operators', mapping:'operators'},
		{name: 'orgunit', mapping:'orgunit'},
		{name: 'dsporder', mapping: 'dsporder'},
		{name: 'isemail', mapping: 'isemail'}
	]);
	var yesorno = [
                   ['0','否'],
                   ['1','是']
               ];
	var emailstore = new Ext.data.SimpleStore({
		id: 0,
        fields: ['value', 'text'],
        data : yesorno
    });
    var objnamestore = new Ext.data.SimpleStore({
		id: 0,
        fields: ['text'],
        data : [['会签'],['审批'],['审核']]
    });
	<%--var operatearray = [
                        ['0','流程提醒'],
	                    ['1','邮件提醒'],
	                    ['2','短消息提醒'],
	                    ['3','弹出式提醒'],
	                    ['4','RTX提醒']
	                ];
	var operatestore = new Ext.data.SimpleStore({
		id: 0,
        fields: ['value', 'text'],
        data : operatearray
    }),--%>
	ds = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.FreeAction?action=list'}),
		reader: new Ext.data.JsonReader({
			root: 'result',
			id: 'id'
		}, NodeinfoFree),
		remoteSort: true
	});
	ds.baseParams.requestid = "<%=requestid%>";
	ds.baseParams.nodeid = "<%=nodeid%>";
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	var cm = new Ext.grid.ColumnModel([sm,{
			header: '序号',
			dataIndex: 'dsporder',
			editor: new Ext.form.NumberField(),
			editable: false,
			width: 50
		},{
			header: '操作者',
			dataIndex: 'operators',
			renderer: renderOpts,
			editor: new Ext.form.TextField(),
			width: 100
		},{
			header: '部门',
			dataIndex: 'orgunit',
			width: 350
		},{
			header: '节点名称',
			id:'objname',
			dataIndex: 'objname',
			editor: new Ext.form.TextField(),
			//editor : triggerfield,
			width: 150
		},{
            header: '是否邮件提醒',
            dataIndex: 'isemail',
            renderer:isRender,
			editor:new Ext.form.ComboBox({
				typeAhead: true,
	            triggerAction: 'all',
	            store:emailstore,
	            mode: 'local',
	            valueField:'value',
                displayField:'text',
	            lazyRender:true,
	            listClass: 'x-combo-list-small'
			}),
            width: 100
	    }
	]);

	function isRender(value, m, record, rowIndex, colIndex){
        var iscombox=emailstore.getById(value);
     if (typeof(iscombox) == "undefined")
         return '否';
     else
         return iscombox.get('text');  
    }
	var btnAdd = new Ext.Action({
		iconCls:Ext.ux.iconMgr.getIcon('add'),
		text: '添加',
		handler: function(){
		    var tempDsporder = 1;
			var rows = ds.data.getRange();//alert(rows.length);
			if(rows.length>0){
				for(var i=0;i<rows.length;i++){
					tempDsporder = rows[i].get("dsporder") + 1;
				}
			}
			//alert(tempDsporder);
			var nodeinfoFree = new NodeinfoFree({
				dsporder: tempDsporder,
				operators: '',
				orgpath: '',
				objname: '',
				isemail: ''
			});
			grid.stopEditing();
			var active = sm.getSelected();
			idx = 0;
			if(active){
				idx = ds.indexOf(active)+1;
			}else{
				idx = ds.data.getRange().length;
			}
			ds.insert(idx, nodeinfoFree);
			grid.startEditing(idx, 0);
		}
	});
	var btnDelete = new Ext.Action({
		iconCls:Ext.ux.iconMgr.getIcon('delete'),
		text: '删除',
		handler: function(){
			if(confirm("是否确定删除？")){
				var rows = sm.getSelections();
				if(rows.length>0){
					for(var i=0;i<rows.length;i++){
						ds.remove(rows[i]);
					}
				}else{
					Ext.Msg.alert("");
				}
			}
		}
	});
	var btnSave = new Ext.Action({
		iconCls:Ext.ux.iconMgr.getIcon('accept'),
		text: '保存',
		handler: function(){
			var checkok = true;
			var records = ds.getRange();
			for(i=0;i<records.length;i++){
				if(records[i].data.objname==''||records[i].data.operators==''){
                  checkok = false;
                  break;
              }
			}
			if(checkok){
				doSave(records,ds);
			}else{
				alert("节点名称、操作者不能为空。");
			}
		}
	});

	var grid = new Ext.grid.EditorGridPanel({
		region:'center',
		title: '',
		store: ds,
       	cm: cm,
       	sm: sm,
       	clicksToEdit: 1,
        loadMask: {msg:'正在载入数据，请稍候...'},
        tbar: [btnAdd, btnDelete, btnSave]
	});
	
	grid.on('afteredit', function(e){

	});
	
	storeOperators = new Ext.data.SimpleStore({
		id:0,
		fields: ['value', 'text'],
		data: [<%=strOperators%>]
	});
	
	grid.on("cellclick",function(grid, rowIndex, columnIndex, e){
		if(columnIndex==2){
			cm.setEditor(2, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
               allowBlank: true,
               store: storeOperators,
               url: '<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id=402881e70bc70ed1010bc75e0361000f'
           })));
        }
	});

	grid.on("afteredit", afterEdit, grid);  
	function afterEdit(obj){ 
		if (obj.column==2) {
			var action = '/ServiceAction/com.eweaver.workflow.request.servlet.FreeAction';
			Ext.Ajax.request({
			   	url: action,
			   	success: function(resp,opts){
					var respText = Ext.util.JSON.decode(resp.responseText);   
			   		var orgpath = respText.orgpath;
					obj.record.set('orgunit',orgpath);
				},
				failure: function(){},
			   	params: { action:'getOrgpath',operatorsid:obj.value }
			})
		}
	}  
	
	var viewport = new Ext.Viewport({
        layout:'border',
        items:[grid]
    });
    
	ds.load();
});


	<%--function showbutton(value,cellmeta,record){
		var idstr = record.get('id');
	var returnStr = "<INPUT type='button' onclick=\"nodeonCreate('"+idstr+"')\" value='节点设置'>";
	return returnStr;
	} 

	function nodeonCreate(id){
	    var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/workflow/workflow/nodeinfomodify.jsp?id="+id);
	   	//tab2.fireEvent("onclick");
	}--%>
	
function renderOpts(value, m, record, rowIndex, colIndex){
	var opts = storeOperators.getById(value);
	return typeof(opts)=="undefined" ? '' : opts.get('text'); 
}
function doSave(m,d){
	var json = [];
	Ext.each(m, function(item){
		json.push(item.data);
	});
	//if(json.length>0){
		Ext.Ajax.request({
			url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.FreeAction?action=save',
			params: {jsonstr: Ext.util.JSON.encode(json), requestid:'<%=requestid%>', nodeid:'<%=nodeid%>'},
			success: function(res){
				alert("保存成功。");
		        d.reload();
			}
        });
	//}
}
</script>
<body>
   <div id="ifEmailRemind">
      <input type="checkbox" value="0" />
   </div>
</body>
</html>





			
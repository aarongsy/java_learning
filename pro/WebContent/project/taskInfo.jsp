<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.service.*" %>
<%@ page import="com.eweaver.base.selectitem.model.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService" %>
<%
	String path = request.getContextPath();
	DataService dataService = new DataService();
	SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
	String requestId = request.getParameter("requestId");
	if (StringHelper.isEmpty(requestId)){
		return;
	}
	List result = dataService.getValues("select ProjectID,ID,ParentTaskUID,Principal From edo_task where requestid = '"+requestId+"'");
	//***********检查权限是否可以访问**********************
	boolean isHumresAdmin = false;
		HumresService humresService = (HumresService) BaseContext.getBean("humresService");
		PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
	String humresroleid = "2c91a0302b278cea012b280dc7210019";//任务代办角色
	isHumresAdmin = permissionruleService.checkUserRole(eweaveruser.getId(),humresroleid,eweaveruser.getHumres().getOrgid());
	if(!isHumresAdmin && !currentuser.getId().equals(StringHelper.null2String(((Map)result.get(0)).get("Principal")).toString())){
		StringBuffer sbOutput = new StringBuffer();
		sbOutput.append("<html><head><title>"+labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001c")+"</title>	</head><body>");//没有权限
		sbOutput.append("<table width='100%' height='20%' border='0' cellspacing='0' cellpadding='0'>");
		sbOutput.append("<tr><td ><div align='center'><img src='/images/silk/cancel.gif'>");
		sbOutput.append("<font size='2'><B>"+labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001d")+"</B></font></div></td></tr>");//对不起！您暂时没有权限，请与系统管理员联系。
		sbOutput.append("</table></body></html>");
		response.getWriter().print(sbOutput);
		return;
	}
	//******************检查结束******************************
	String ProjectUID = StringHelper.null2String(((Map)result.get(0)).get("ProjectID")).toString();
	String UID = StringHelper.null2String(((Map)result.get(0)).get("ID")).toString();
	String ParentTaskID = StringHelper.null2String(((Map)result.get(0)).get("ParentTaskUID")).toString();
	result = dataService.getValues("select No,Name,State From uf_contract  where requestid='"+ProjectUID+"'");
	String contractNo = ((Map)result.get(0)).get("No").toString();
	String contractName = ((Map)result.get(0)).get("Name").toString();
	//如果合同已结项则不允许修改
	String projectState = ((Map)result.get(0)).get("State").toString();
	boolean isCanEdit = true;
	List<String> forbiddenList=new ArrayList<String>();
	forbiddenList.add("2c91a0302a8cef72012a8eabe0e803f2");
	forbiddenList.add("2c91a0302a8cef72012a8eabe0e803f3");
	forbiddenList.add("2c91a0302ab11213012ab12bf0f00021");
	if(forbiddenList.contains(projectState)){
		isCanEdit=false;
	}
	
	String typeid="2c91a0302aa6def0012aa89e54b10742";
	List<Selectitem> list = selectitemService.getSelectitemList(typeid,null);
	StringBuffer menuBuffer1 = new StringBuffer();
	StringBuffer menuBuffer2 = new StringBuffer();
	int listSize = list.size();
	for(int i=0;i<4;i++){
		if(i>=listSize){
			break;
		}
		Selectitem selectitem = (Selectitem)list.get(i);
		menuBuffer1.append("{id: 'tbar").append(i+3).append("',text: '").append(selectitem.getObjname())
		.append("',iconCls: Ext.ux.iconMgr.getIcon('page_go'),handler: function(){reportWorkFlow('")
		.append(selectitem.getId()).append("');}},");
	}
	for(int j=4;j<list.size();j++){
		Selectitem selectitem = (Selectitem)list.get(j);
		menuBuffer2.append("{text:'").append(selectitem.getObjname())
		.append("',iconCls:Ext.ux.iconMgr.getIcon('page_go'),handler: function(){reportWorkFlow('")
		.append(selectitem.getId()).append("');}},");
	}
	String menuStr1 = menuBuffer1.toString();
	String menuStr2 = menuBuffer2.length()>0?menuBuffer2.toString().substring(0,menuBuffer2.length()-1):"";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  
<title><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50049") %><!-- 任务模板 --></title>

<!--edo css-->
<link href="/project/scripts/edo/res/css/edo-all.css" rel="stylesheet" type="text/css" />
<link href="/project/scripts/edo/res/product/project/css/project.css" rel="stylesheet" type="text/css" />
<!--edo js-->
<script src="/project/scripts/edo/edo.js" type="text/javascript"></script>
<script src="/project/scripts/thirdlib/excanvas/excanvas.js" type="text/javascript"></script>
<!-- add js -->
<script src="/project/scripts/eweaver/ProjectService.js" type="text/javascript"></script>
<script src="/project/scripts/eweaver/taskInfo/banner.js" type="text/javascript"></script>
<script src="/project/scripts/eweaver/taskInfo/body.js" type="text/javascript"></script>
<script src="/project/scripts/eweaver/taskInfo/logic.js" type="text/javascript"></script>
<script src="/project/scripts/eweaver/taskInfo/menu.js" type="text/javascript"></script>
<!-- Ext Js -->
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<style type="text/css">
.x-toolbar TABLE{
width:0px;
}
</style>
</head>
<body style="background:#dfe8f6;">
	<div id="view" style="width: 100%;height: 200px">
		<div id="banner"></div>
		<div id="body" style="width: 100%"></div>
	</div>

</body>
</html>
<script type="text/javascript">
	//*****全局变量
	var ProjectUID = "<%=ProjectUID%>";
	var UID ="<%=UID%>";
	var ParentTaskID = "<%=ParentTaskID%>";
	var HeaderValue = "<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %>:<%=contractNo%>  <%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %>:<%=contractName%>";//合同编号  合同名称   
	var isCanEdit = <%=isCanEdit%>;
	var dataProject;
	var selectProject={};
	Edo.build({
	    id: 'project',
	    type: 'eweaverwbs',
	    width: document.getElementById('body').clientWidth+13,
	    height: 168,  
	    startDate: new Date(2009, 0, 28),
	    finishDate: new Date(2011, 1, 30),
	    render: document.getElementById('body')
	});
	
	//增加数据处理插件
	project.addPlugin(new GanttSchedule());
	project.addPlugin(new GanttMenu());
	//加载任务数据
	loadNodes('getSelfAndTasks',UID,true,function(data){
		dataProject = new Edo.data.DataGantt(data);
		project.set('data', dataProject);
	});
	//增加任务模式下拉框
	loadSubNodes({
		masterType: SELECTID.model,
    	method: 'getSelectOperation'
    	},
		function(data){
    		for(var i=0;i<data.length;i++){
				var result = new c(data[i].ID);
				result();
			}
			//setTimeout(project.data.endChange,2500);
			data.unshift({ID:null,OBJNAME:''});
			selectProject[SELECTID.model] = data;
		}
	);
	//增加风险等级下拉框
	loadSubNodes({
		masterType: SELECTID.RiskLevel,
    	method: 'getSelectOperation'
    	},
		function(data){
			data.unshift({ID:null,OBJNAME:''});
			selectProject[SELECTID.RiskLevel] = data;
		}
	);
	//增加重要程度下拉框
	loadSubNodes({
		masterType: SELECTID.Pri,
    	method: 'getSelectOperation'
    	},
		function(data){
			data.unshift({ID:null,OBJNAME:''});
			selectProject[SELECTID.Pri] = data;
		}
	);
	//增加任务状态下拉框
	loadSubNodes({
		masterType: SELECTID.Status,
    	method: 'getSelectOperation'
    	},
		function(data){
			data.unshift({ID:null,OBJNAME:''});
			selectProject[SELECTID.Status] = data;
		}
	);
	//增加专业下拉框
	loadSubNodes({
		masterType: SELECTID.subject,
    	method: 'getSelectOperation'
    	},
		function(data){
			data.unshift({ID:null,OBJNAME:''});
			selectProject[SELECTID.subject] = data;
		}
	);
  	</script>
  	
 	
<script type="text/javascript">

	var dlg0 = new Ext.Window({
		layout:'border',
		closeAction:'hide',
		plain: true,
		modal :true,
		width: document.getElementById('view').clientWidth*0.8,
		height: document.getElementById('view').clientHeight*1.7,
		items:[{
		        id:'dlgpanel',
		        region:'center',
		        xtype     :'iframepanel',
		        frameConfig: {
		            autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
		            eventsFollowFrameLinks : false
		        },
		        autoScroll:true
		    }]
	});
	dlg0.on('hide', function(){
		this.getComponent('dlgpanel').setSrc('about:blank');
	});

	Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004a") %>';//加载数据...
	var sm;
	var store;
	var selected=new Array();
	var viewport=null;
	Ext.onReady(function(){
	    store = new Ext.data.Store({
	        proxy: new Ext.data.HttpProxy({
	            url: '/ServiceAction/com.app.fangtian.FangTianAction?action=getDocList'
	        }),
	        reader: new Ext.data.JsonReader({
	            sql1:'sql1',
	            sql2:'sql2',
	            root: 'result',
	            totalProperty: 'totalCount',
	            fields: ['requestid','exttextfield0','subjecturl','categoryname','creator','createdate','inStore']
	        }),
	        remoteSort: true
	    });
	    sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
	    sm=new Ext.grid.CheckboxSelectionModel();
	    sm.singleSelect=true;
	    var cm = new Ext.grid.ColumnModel([sm,
	        {header:'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000e") %>',dataIndex:'exttextfield0',width:60,sortable:false},//文档编号
	        {header:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009") %>',dataIndex:'subjecturl',width:160,sortable:false},//标题
	        {header:'<%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %>',dataIndex:'categoryname',width:60,sortable:false},//分类
	        {header:'<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71ad6d46000a") %>',dataIndex:'creator',width:50,sortable:false},//作者
	        {header:'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004b") %>',dataIndex:'createdate',width:60,sortable:false},//上传时间
	        {header: "<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004c") %>",dataIndex: 'inStore',width:120,sortable: false}//是否在知识库中
		]);
		var topbar = new Ext.Toolbar({id: 'topbar',items:[
			{id: 'tbar1',text: '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004d") %>',iconCls: Ext.ux.iconMgr.getIcon('package_down'),handler: downloadTemplate},//模板下载
			{id: 'tbar2',text: '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004e") %>',iconCls: Ext.ux.iconMgr.getIcon('page_white_add'),handler: createReport},//创建报告
			<%=menuStr1%>
			<%if(menuStr2.length()>0){%>
			{id: 'tbar7',text: '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004f") %>',iconCls: Ext.ux.iconMgr.getIcon('page_white_word'),xtype: 'tbbutton',//更多审批流程
				menu: {shadow:false,items:[<%=menuStr2%>]}
			},
			<%}%>
			{id: 'tbar8',text: '<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027") %>',iconCls: Ext.ux.iconMgr.getIcon('refresh'),handler: refreshDocList}//刷新
		]});

	    var grid = new Ext.grid.GridPanel({
            region: 'center',
            store: store,
            cm: cm,
            trackMouseOver:false,
            sm:sm,
            loadMask: true,
            viewConfig: {
				forceFit:true,enableRowBody:true,
				sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
                columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
				getRowClass : function(record, rowIndex, p, store){
                    return 'x-grid3-row-collapsed';
                }
            },
            tbar : topbar,
            bbar: new Ext.PagingToolbar({
				pageSize: 20,store: store,displayInfo: true,
				beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
	            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
	            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
	            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
	            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
	            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
	            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示     条记录
	            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>" ,items:['-']
			})
		});

		store.on('load',function(st,recs){
	        for(var i=0;i<recs.length;i++){
	            var reqid=recs[i].get('requestid');
	        	for(var j=0;j<selected.length;j++){
	            	if(reqid ==selected[j]){
	                	sm.selectRecords([recs[i]],true);
	                }
	        	}
	    	}
	    });
	    sm.on('rowselect',function(selMdl,rowIndex,rec ){
	        var reqid=rec.get('requestid');
	        for(var i=0;i<selected.length;i++){
	        	if(reqid ==selected[i]){
	            	return;
	            }
	        }
	        selected.push(reqid)
	    });
	    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
	        var reqid=rec.get('requestid');
	        for(var i=0;i<selected.length;i++){
	        	if(reqid ==selected[i]){
	            	selected.remove(reqid)
	                return;
	            }
	        }
	    });
	    refreshDocList();
	var t = new Ext.Panel({
		tbar : [
				{
				    xtype: 'tbbutton',
				    text: 'Button',
				    menu: [{
					text: 'Better'
				    },{
					text: 'Good'
				    },{
					text: 'Best'
				    }]
				}
			]
		});
	var c = new Ext.Container({
               autoEl: {},
               title:'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50050") %>',iconCls:Ext.ux.iconMgr.getIcon('application_form'),//文档信息
               width:Ext.lib.Dom.getViewportWidth(),
               height: Ext.lib.Dom.getViewportHeight(),
               layout: 'border',
               items: [grid]
           });
     
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0,
            items:[c]
        });
		addTab(contentPanel,'/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=2c91a0302aeefaeb012af01d07bf01b5&con2c91a0302aeefaeb012af0101e880193_value=<%=requestId%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50051") %>','building_edit');//过程日志
		addTab(contentPanel,'/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isformbase=1&reportid=2c91a0302aeefaeb012aefff20da0166&con4028818411b2334e0111b233527701ab_value=<%=requestId%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50052") %>','table');//过程文档
		//grid.render('topic-grid');
		viewport = new Ext.Viewport({
	        layout: 'border',
	        items: [{region:'north',autoScroll:true,contentEl:'view',collapseMode:'mini'},contentPanel]
		});
	});
	function refreshDocList(){
		store.baseParams={extrefobjfield8:'<%=requestId%>'};
	    store.baseParams.datastatus='';
		store.baseParams.isindagate='';
		store.load({params:{start:0, limit:20}});
	}
	//创建报告
	function createReport(){
		if(project.tree.getSelected()&&project.tree.getSelected().Model=='2c91a84e2aa7236b012aa737d8930007'){
			var nodeId = project.tree.getSelected().RequestId;
			var title = encode(project.tree.data.children[0].Name+project.tree.getSelected().Name);
			Ext.Ajax.request({
				url: '/ServiceAction/com.app.fangtian.FangTianAction?action=getDocNO',
				success: function(request){
					var docNo = request.responseText;
					var url="/document/base/docbasecreate.jsp?categoryid=2c91a0302ab11213012ab2368c19011a&taskId=<%=requestId%>&projectId=<%=ProjectUID%>&nodeId="+nodeId+"&docNo="+docNo+"&title="+title;
					if(top.frames[1]){
						onUrl(url,'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5004e") %>','tab2c91a0302ab11213012ab2368c19011a');//创建报告
					}else{
						window.open(url);
					}
			   },
			   failure: function(){alert('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50053") %>');},//获取文档编号出错
			   params: { 'taskId': '<%=requestId%>','nodeId':nodeId }
			});
		}else{
			alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0056") %>");//请选择一个节点
		}
	}
	//下载模板
	function downloadTemplate(){
		if(project.tree.getSelected()&&project.tree.getSelected().Model=='2c91a84e2aa7236b012aa737d8930007'){
			var nodeId = project.tree.getSelected().RequestId;
			var id = openDialog('/app/fangtian/doctemplate.jsp?taskId=<%=requestId%>&projectid=<%=ProjectUID%>',window,'dialogHeight:450px;dialogWidth: 800px');
			if(id){
				var url = "/ServiceAction/com.app.fangtian.FangTianAction?action=download&docId="+id+"&nodeId="+nodeId+"&taskId=<%=requestId%>";
				location.href=url;
				//window.open(url);
			}
		}else{
			alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0056") %>");//请选择一个节点
		}
	}
	//报告审批
	function reportWorkFlow(selectid){
		//topbar.hideMenu();
		var record = sm.getSelected();
		if(record){
			var docId = record.get('requestid');
			var url="/app/fangtian/startdocflow.jsp?workflowid=2c91a0302ac122a2012ac18dd12400fb&taskId=<%=requestId%>&projectid=<%=ProjectUID%>&docId="+docId+"&selectid="+selectid;
			if(top.frames[1]){
				onUrl(url,'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50054") %>','tab2c91a0302ac122a2012ac18dd12400fb');//报告审批
			}else{
				window.open(url);
			}
		}else{
			alert("<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60055") %>");//请选中一条记录
		}
	}
</script>
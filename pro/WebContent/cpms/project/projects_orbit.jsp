<!-- 多项目轨道视图 -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.selectitem.service.*" %>
<%@ page import="com.eweaver.base.selectitem.model.*" %>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.service.acegi.*" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%
//LabelService labelService = (LabelService)BaseContext.getBean("labelService");
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
DataService dataService = new DataService();
PagemenuService pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");

String objstatus = StringHelper.null2String(request.getParameter("objstatus"));
String objtype = StringHelper.null2String(request.getParameter("objtype"));
String ptype2 = StringHelper.null2String(request.getParameter("ptype2"));
String manager = StringHelper.null2String(request.getParameter("manager"));
String managerName = humresService.getHrmresNameById(manager);

//HashMap paravaluehm = new HashMap();
paravaluehm.put("{currentuser}",currentuser.getId());
paravaluehm.put("{currentdate}", DateHelper.getCurrentDate());
ArrayList<String> menuList=pagemenuService.getPagemenuStrExt("/cpms/project/projects_orbit.jsp",paravaluehm);
String pageMenuStr = menuList.get(0);
String tabStr = menuList.get(1);

%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<title><%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0000") %><!-- 多项目导航视图 --></title>
<!-- ref in init.jsp
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script> -->
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<!-- ref in init.jsp
<script type="text/javascript" src="/js/main.js"></script> -->
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/js/formbase.js"></script>
<script type="text/javascript" src="/cpms/scripts/base.js"></script>
<!-- ref in init.jsp
<link type="text/css" rel="stylesheet" href="/css/global.css">
<link type="text/css" rel="stylesheet" href="/js/ext/resources/css/ext-all-cpms.css" />
<link type="text/css" rel="stylesheet" href="/css/eweaver-default.css"> -->
<link type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<style type="text/css">
v\:* { behavior: url(#default#VML);}
#menubar table {width:0}
.x-toolbar table {width:0}
</style>
<script type="text/javascript">
Ext.SSL_SECURE_URL='about:blank';
Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
var store;
var grid;
Ext.onReady(function(){
	var tb = new Ext.Toolbar();
	tb.render('menubar',0);
	<%=pageMenuStr%>
	addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027") %>','R','refresh',function(){location.reload();});//刷新
	addBtn(tb,'<%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000") %>','R','zoom',function(){search();});//查询

	store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '/ServiceAction/com.eweaver.cpms.project.task.ProjectOrbitAction?action=getProjectOrbitList'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalcount',
            fields: ['detail','projectid','projectno','projectname','statusname','managername','customerid',
                     'customername','planstartdate','planfinishdate','RunningState','orbitMap']
        })
    });
    function renderProjectDetail(value, p, record){
        var style='';
        if(record.data.RunningState==1){
            style='style=\'color:#FF0000\'';
        }
    	return String.format("<a href=\"javascript:onUrl('/cpms/project/projectinfo.jsp?projectid={0}','{1}','tab{0}')\" {2}>{1}</a>",
    	    	record.data.projectid,value,style);
    }
    function renderProjectName(value, p, record){
        var style='';
        if(record.data.RunningState==1){
            style='style=\'color:#FF0000\'';
        }
    	return String.format("<a href='#' {2}>{1}</a>",
    	    	record.data.projectid,value,style);
    }
    function renderCustomerName(value, p, record){
    	return String.format("<a href=\"javascript:onUrl('/workflow/request/formbase.jsp?requestid={0}','{1}','tab{0}')\">{1}</a>",
    	    	record.data.customerid,value);
    }
	function renderOrbitMap(value, p, record,rowIndex){
		var result="<div id=\"orbitDiv\" style=\"width:100%;vertical-align: middle;padding:10 0 10 0;\">";
		for(var i=0;i<value.length;i++){
			var node = value[i];
			var strokecolor='';
	        if(node.RunningState==1){
	        	strokecolor='#FF0000';
	        }
			if(i==0){
				result+= "<v:line style=\"position:relative;\" from=\"0,0\" to=\"16,0\" strokeweight = \"0\" "
						+ "strokecolor=\"#fff\"/>";
			}else{
				result+= "<v:line style=\"position:relative;top:-9;\" from=\"0,0\" to=\"30,0\" "
					+ "strokeweight = \"1.5px\" strokecolor=\"#666666\">";
				result+= "<v:stroke EndArrow=\"Classic\"/>";
				result+= "</v:line>";
			}
			if (node.status=="2c91a0302aa21947012aa232f1860011") {//完成 
				result+="<v:group style=\"position:relative;width:30;height:30;\" coordsize = \"30,30\">";
				result+=String.format("<v:oval style=\"position:relative;width:30;height:30;cursor:hand;\" "
						+ "strokeweight = \"1px\" strokecolor=\"{0}\" fillcolor = \"{0}\">",strokecolor==''?strokecolor:strokecolor);
				result+=String.format("<v:fill type=\"gradient\" color=\"{0}\" angle=\"225\"></v:fill>",node.color);
				result+="</v:oval>";
				result+=String.format("<v:oval style=\"position:relative;width:10;height:10;top:10;left:10;\" "
						+ "strokeweight = \"1px\" strokecolor=\"{0}\" fillcolor = \"{0}\" />",node.color);
				result+="</v:group>";
			} else {
				result+=String.format("<v:oval style=\"position:relative;width:30;height:30;cursor:hand;\" "
						+ "strokeweight = \"1px\" strokecolor=\"{0}\" fillcolor = \"{0}\">",node.color);
				result+=String.format("<v:fill type=\"gradient\" color=\"{0}\" angle=\"225\"></v:fill>",node.color);
				result+="</v:oval>";
			}
			result+=String.format("<a href=\"javascript:openTask('{0}','{1}','{2}');\" style=\"position: "
					+"relative;float:left;width: 70px;height:40px;text-align: center;\">{2}</a>",
					record.data.projectid,node.taskid,node.taskname);
		}
		result+= "</div>";
		return result;
    }
	var cm = new Ext.grid.ColumnModel([
		{header: "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000c") %>",	width:30,	sortable: false,	dataIndex: 'detail',		renderer: renderProjectDetail},//详细信息
		{header: "<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0001") %>",	width:60,	sortable: false,	dataIndex: 'projectno',		renderer: renderProjectName},//项目编号
		{header: "<%=labelService.getLabelNameByKeyId("402881e80c770b5e010c7737d4e00015") %>",	width:60,	sortable: false,	dataIndex: 'projectname',	renderer: renderProjectName},//项目名称
		{header: "<%=labelService.getLabelNameByKeyId("402881e80c7765f6010c78225e400052") %>",	width:30,	sortable: false,    dataIndex: 'statusname'},//项目状态
		{header: "<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160056") %>",	width:30,	sortable: false,    dataIndex: 'managername'},//项目负责人
		{header: "<%=labelService.getLabelNameByKeyId("402881ea0c1a5676010c1a62adf7001d") %>",	width:60,	sortable: false,	dataIndex: 'customername',	renderer: renderCustomerName},//客户名称
		{header: "<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0002") %>",	width:60,	sortable: false,	dataIndex: 'planstartdate'},//计划开始时间
		{header: "<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0003") %>",	width:60,	sortable: false,	dataIndex: 'planfinishdate'}//计划结束时间
		//{header: "轨道图",		width:200,	sortable: false,	dataIndex: 'orbitMap',	renderer: renderOrbitMap}
     ]);
	cm.defaultSortable = true;
    grid = new Ext.grid.GridPanel({
        region: 'center',
        store: store,
        cm: cm,
        trackMouseOver:false,
        loadMask: true,
        //autoHeight:true,
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
			pageSize: 15,
			store: store,
			displayInfo: true,
			beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
			afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
			firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
			prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
			nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
			lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
			displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示//条记录
			emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>"//没有结果返回
		})
	});
    grid.addListener('render',beforeshow);
    grid.addListener('rowclick',rowclick);
    store.addListener('load',AfterLoad);
    store.load({params:{start:0, limit:15,pagesize: 15,objtype:'<%=objtype%>',ptype2:'<%=ptype2%>'}});

	var viewport;
	function AfterLoad(store,records){
		if(!viewport){
			viewport = new Ext.Viewport({
				layout: 'border',
		        items: [{region:'north',autoScroll:true,contentEl:'menubar'},grid,{region:'south',autoScroll:true,contentEl:'orbit'}]
			});
		}else{
			if(records.length==0){
				document.getElementById('orbit').innerHTML="";
			}else{
				grid.fireEvent('rowclick',grid,0);
			}
		}
	}
    function beforeshow(grid){
    	grid.fireEvent('rowclick',this,0);
    }
    function rowclick(grid,rowIndex){
        if(grid.store.data.items.length<=rowIndex)return;
		document.getElementById('orbit').innerHTML=renderOrbitMap(grid.store.data.items[rowIndex].data.orbitMap,
			null, grid.store.data.items[rowIndex],rowIndex);
    }
    
});
</script>
</head>
<body>
<div id="menubar">
	<div style="margin: 2px;">
		<label style="padding-left: 5px;"><%=labelService.getLabelNameByKeyId("402881e80c7765f6010c78225e400052") %><!-- 项目状态 --></label>
		<span>
			<select id="objstatus" name="objstatus">
				<option value=""></option>
				<%
				List statusList = selectitemService.getSelectitemList("402882082e9d4d64012e9e347be10006",null);
				for(int i=0;i<statusList.size();i++){
					Selectitem status = (Selectitem)statusList.get(i);
				%>
				<option value="<%=status.getId()%>" <%if(objstatus.equals(status.getId())){%>selected<%}%> ><%=status.getObjname()%></option>
				<%}%>
			</select>
		</span>
		<%--<label style="padding-left: 10px;">产品类别</label>
		<span>
			<select id="objtype" name="objtype">
				<option value=""></option>
				<%
				List typeList = selectitemService.getSelectitemList("402882882ec214fb012ec270700f0282",null);
				for(int i=0;i<typeList.size();i++){
					Selectitem type = (Selectitem)typeList.get(i);
				%>
				<option value="<%=type.getId()%>" <%if(objtype.equals(type.getId())){%>selected<%}%>><%=type.getObjname()%></option>
				<%}%>
			</select>
		</span>
		--%><label style="padding-left: 10px;"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160056") %><!-- 项目负责人 --></label>
		<span style="width: 100px">
			<BUTTON type="button" class=Browser onclick="getrefobj('manager','managerName','402881e70bc70ed1010bc75e0361000f','/humres/base/humresview.jsp?id=','0');"></BUTTON>
			<INPUT type="hidden" name="manager" id="manager" value="<%=manager%>"> 
			<SPAN id=managerName><%=managerName%></SPAN>
		</span>
		
		<span style="margin: 10 0 0 10;color:blue;">
			<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0004") %><!-- 状态图标说明 -->: 
			<%
			List colorList = selectitemService.getSelectitemList("2c91a0302aa21947012aa2325769000e",null);
			for(int i=0;i<colorList.size();i++){
				Selectitem selectitem = (Selectitem)colorList.get(i);
				String color = selectitem.getObjdesc();
			%>
			
			<%if(selectitem.getId().equals("2c91a0302aa21947012aa232f1860011")){%><!-- 完成 -->
			<v:group style="position:relative;width:12;height:12;top:3" coordsize = "30,30">
				<v:oval style="position:relative;width:30;height:30;" strokeweight = "1px" strokecolor="<%=color%>">
					<v:fill type="gradient" color="<%=color%>" angle="225"></v:fill>
				</v:oval>
				<v:oval style="position:relative;width:10;height:10;top:10;left:10;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>" />
			</v:group>
			<%}else{%>
			<v:oval style="position:relative;width:12;height:12;top:3" strokeweight = "1px" strokecolor="<%=color%>">
				<v:fill type="gradient" color="<%=color%>" angle="225"></v:fill>
			</v:oval>
			<%}%>
			<%
				String showname = selectitem.getObjname();
				String sql = "select id,col1 from label where labelname ='"+showname+"'";
				List list = dataService.getValues(sql);
				if(list.size()>=1){//不管查询到几个 取第一个
					Map map  = (Map)list.get(0);
					String col1 = (String)map.get("col1");
					showname = labelService.getLabelNameByKeyId(col1);
				}
			
			%>
			<span style="margin: 0 5 0 0"> <%=showname%></span>
			<%}%>
		</span>
	</div>
</div>
<div id="orbit" style="height:95px;"></div>
<script type="text/javascript">
function refresh(){
	location.reload();
}
function openTask(projectid,id,objname){
	onUrl('/cpms/project/projectinfo.jsp?projectid='+projectid+'&taskid='+id,objname,'exec_'+id);
}
function search(){
    var data={objstatus:document.getElementById("objstatus").value,
    	    //objtype:document.getElementById("objtype").value,
    	    manager:document.getElementById("manager").value};
	store.baseParams=data;
	store.baseParams.datastatus='';
	store.baseParams.isindagate=''
	store.load({params:{start:0, limit:20,pagesize: 15}});
    //event.srcElement.disabled = false;
}
</script>
</body>
</html>
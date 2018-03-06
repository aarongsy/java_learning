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
<%
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
DataService dataService = new DataService();
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");

String projectid = StringHelper.null2String(request.getParameter("projectid"));
String sql = "select * from cpms_task where objlevel=1 and projectid='"+projectid+"' order by dsporder";
List list = dataService.getValues(sql);

String projectSQL = "select (select objname from humres where id=p.manager) as hname,p.* from cpms_project p where p.requestid='"+projectid+"'";
Map project = dataService.getValuesForMap(projectSQL);

String taskSrc = request.getParameter("taskid")==null?"":
	"/cpms/project/stageinfo.jsp?taskid="+request.getParameter("taskid")+"&projectid="+projectid;

//HashMap paravaluehm = new HashMap();
paravaluehm.put("{currentuser}",currentuser.getId());
paravaluehm.put("{currentdate}", DateHelper.getCurrentDate());
paravaluehm.put("{id}",projectid);
paravaluehm.put("{projectid}",projectid);
PagemenuService pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");
ArrayList<String> menuList=pagemenuService.getPagemenuStrExt("/cpms/project/projectinfo.jsp",paravaluehm);
String pageMenuStr = menuList.get(0);
String tabStr = menuList.get(1);
%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<title>项目导航</title>    
<script type="text/javascript">
        var contextPath='';
    </script>
<!-- ref in init.jsp
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script> -->
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<!-- ref in init.jsp
<script type="text/javascript" src="/js/main.js"></script> -->
<!-- ref in init.jsp
<link type="text/css" rel="stylesheet" href="/css/global.css">
<link type="text/css" rel="stylesheet" href="/js/ext/resources/css/ext-all.css" /> 
<link type="text/css" rel="stylesheet" href="/css/eweaver-default.css"> -->
<link type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
<script type="text/javascript">
var contentPanel;
Ext.onReady(function(){
	var tb = new Ext.Toolbar();
	tb.render('menubar');
	<%=pageMenuStr%>
	var taskinfoPanel = new Ext.Panel({
	    title:'项目导航',iconCls:Ext.ux.iconMgr.getIcon('matter'),
	    layout: 'border',
	    items: [{region:'center',autoScroll:true,contentEl:'projectPanel'}]
	});
	
	contentPanel = new Ext.TabPanel({
        region:'center',
        id:'tabPanel',
        deferredRender:false,
        enableTabScroll:false,
        autoScroll:false,
        activeTab:0,
        items:[taskinfoPanel]
    });
	<%=tabStr%>
	//addTab(contentPanel,'/workflow/request/formbase.jsp?requestid=<%=projectid%>','项目信息','package');
	//addTab(contentPanel,'/cpms/project/wbsview_execute.jsp?projectid=<%=projectid%>','进度视图','calendar_select_week');
	//addTab(contentPanel,'/cpms/project/wbsview_plan.jsp?projectid=<%=projectid%>','分解视图','calendar_edit');
	//addTab(contentPanel,'/cpms/project/wbsview_docflow.jsp?projectid=<%=projectid%>','文档流程视图','calendar_star');
	//addTab(contentPanel,'/cpms/comment/comment.jsp?objid=<%=projectid%>','协作交流','comments');
  	//Viewport
	var viewport = new Ext.Viewport({
	    layout: 'border',
	    items: [contentPanel]
	});
});
</script>
<style type="text/css">
v\:* { behavior: url(#default#VML);}
#menubar table {width:0}
</style>
</head>
<body>
<div id="projectPanel">
	<div id="menubar"></div>
	<div id="projectInfo" style="width:100%;padding: 10 10 0 10;">
		<table border="1" class="layouttable">
			<tr height="25px">
				<td width="10%" class="fieldname">项目名称</td>
				<td class="fieldvalue"><%=StringHelper.null2String(project.get("objname"))%></td>
				<td width="10%" class="fieldname">项目经理</td>
				<td class="fieldvalue" width="40%"><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=project.get("manager")%>','<%=StringHelper.null2String(project.get("hname"))%>','tab<%=project.get("manager")%>');">
					<%=StringHelper.null2String(project.get("hname"))%></a>
				</td>
			</tr>
			<tr height="25px">
				<td width="10%" class="fieldname">项目状态</td>
				<td class="fieldvalue" width="40%"><%=selectitemService.getSelectitemNameById(StringHelper.null2String(project.get("objstatus")))%></td>
				<td width="10%" class="fieldname">计划完成日期</td>
				<td class="fieldvalue" width="40%"><%=StringHelper.null2String(project.get("planfinishdate"))%></td>
			</tr>
		</table>
	</div>
	<div id="orbitInfo" style="padding: 10px;">
		<span style="font-weight:bold; color: #567f40">〖项目轨道图〗</span>
		<div id="orbitDiv" style="width:100%;vertical-align: middle;border: solid 1px #909090;padding:10 0 10 0;">
			<%
			for(int i=0;i<list.size();i++){
				Map stage = (Map)list.get(i);
				String status = stage.get("status")==null?"2c91a0302aa21947012aa232f186000f":(String)stage.get("status");
				Selectitem statusItem = selectitemService.getSelectitemById(status);
				String color = statusItem.getObjdesc();
				
				if(i==0){
			%>
				<v:line style="position:relative;" from="0,0" to="16,0" strokeweight = "0" strokecolor="#fff"/>
				
				<%if(status.equals("2c91a0302aa21947012aa232f1860011")){%><!-- 完成 -->
				<v:group style="position:relative;width:30;height:30;" coordsize = "30,30">
					<v:oval style="position:relative;width:30;height:30;cursor:hand;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>">
						<v:fill type="gradient" color="<%=color%>" angle="225"></v:fill>
					</v:oval>
					<v:oval style="position:relative;width:10;height:10;top:10;left:10;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>" />
				</v:group>
				<%}else{%>
				<v:oval style="position:relative;width:30;height:30;cursor:hand;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>">
					<v:fill type="gradient" color="<%=color%>" angle="225"></v:fill>
				</v:oval>
				<%}%>
				
				<a style="position: relative;float:left;width: 70px;height:40px;text-align: center;" href="javascript:openTask('<%=projectid%>','<%=stage.get("requestid")%>','<%=stage.get("objname")%>');"><%=stage.get("objname")%></a>
			<%}else{%>
				<v:line style="position:relative;top:-9;" from="0,0" to="30,0" strokeweight = "1.5px" strokecolor="#666666">
			    	<v:stroke EndArrow="Classic"/>
			    </v:line>
			    <%if(status.equals("2c91a0302aa21947012aa232f1860011")){%><!-- 完成 -->
				<v:group style="position:relative;width:30;height:30;" coordsize = "30,30">
					<v:oval style="position:relative;width:30;height:30;cursor:hand;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>">
						<v:fill type="gradient" color="<%=color%>" angle="225"></v:fill>
					</v:oval>
					<v:oval style="position:relative;width:10;height:10;top:10;left:10;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>" />
				</v:group>
				<%}else{%>
				<v:oval style="position:relative;width:30;height:30;cursor:hand;" strokeweight = "1px" strokecolor="<%=color%>" fillcolor = "<%=color%>">
					<v:fill type="gradient" color="<%=color%>" angle="225"></v:fill>
				</v:oval>
				<%}%>
				<a style="position: relative;float:left;width: 70px;height:40px;text-align: center;" href="javascript:openTask('<%=projectid%>','<%=stage.get("requestid")%>','<%=stage.get("objname")%>');"><%=stage.get("objname")%></a>
			<%}%>
			<%}%>
		</div>
		<div style="margin: 10 0 0 0;">
			状态图标说明: 
			<%
			List statusList = selectitemService.getSelectitemList("2c91a0302aa21947012aa2325769000e",null);
			for(int i=0;i<statusList.size();i++){
				Selectitem selectitem = (Selectitem)statusList.get(i);
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
			<span style="margin: 0 5 0 0"> <%=selectitem.getObjname()%></span>
			<%}%>
		</div>
	</div>
	<div id="stageInfo" style="width:100%;">
		<iframe id="stageframe" frameborder="0" width="100%" src="<%=taskSrc %>"></iframe>
	</div>

</div>
<script type="text/javascript">
function refresh(){
	location.reload();
}
function openTask(projectid,id){
	var frame=document.getElementById("stageframe");
	var url='/cpms/project/stageinfo.jsp?taskid='+id+'&projectid='+projectid;
	frame.contentWindow.location.href=url;
}
function resetHeight(height){
	var frame=document.getElementById("stageframe");
	frame.height = height;
}
</script>
</body>
</html>
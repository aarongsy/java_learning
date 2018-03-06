<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService" %>
<%@ page import="com.eweaver.base.orgunit.service.*" %>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	String path = request.getContextPath();
	//*******************配置全局变量*****************************
	DataService dataService = new DataService();
	OrgunitService orgunitService =((OrgunitService) BaseContext.getBean("orgunitService"));
	List result;//下拉框
	String requestId = request.getParameter("projectid");
	if (StringHelper.isEmpty(requestId) || requestId.equals("undefined"))
		return;
	result = dataService.getValues("select No,Name,State,Orgunit From uf_contract  where requestid='"+requestId+"'");
	String projectNo="",projectName="",projectState="";
	boolean isCanEdit = true;
	projectNo = StringHelper.null2String(((Map)result.get(0)).get("No")).toString();
	projectName = StringHelper.null2String(((Map)result.get(0)).get("Name")).toString();
	projectState = StringHelper.null2String(((Map)result.get(0)).get("State")).toString();
	//***********检查权限是否可以访问(当前用户属于分解角色组)**********************
	boolean isHumresAdmin = false;
  	HumresService humresService = (HumresService) BaseContext.getBean("humresService");
  	PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
  	String humresroleid = "402881182b2f6cc5012b2f77f48e000a";//监督角色id
	isHumresAdmin = permissionruleService.checkUserRole(eweaveruser.getId(),humresroleid,eweaveruser.getHumres().getOrgid());
	String[] orgunit = ((Map)result.get(0)).get("Orgunit").toString().split(",");
	String[] orgids =permissionruleService.getHumresFileds(eweaveruser.getHumres().getId(),humresroleid).split(",");
	List<String> userOrgids = new ArrayList<String>(Arrays.asList(orgids));
	boolean isHaveRight= true;//当前用户的事业部门必须是合同的事业部门
	for(String unit:orgunit){
		if(userOrgids.contains(unit)){
			isHaveRight = true; break;
		}
	}
	if(!(isHumresAdmin && isHaveRight)){
		StringBuffer sbOutput = new StringBuffer();
		sbOutput.append("<html><head><title>"+labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001c")+"</title>	</head><body>");//没有权限
		sbOutput.append("<table width='100%' height='20%' border='0' cellspacing='0' cellpadding='0'>");
		sbOutput.append("<tr><td ><div align='center'><img src='/images/silk/cancel.gif'>");
		sbOutput.append("<font size='2'><B>"+labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001d")+"</B></font></div></td></tr>");//对不起！您暂时没有权限，请与系统管理员联系。
		sbOutput.append("</table></body></html>");
		response.getWriter().print(sbOutput);
		return;
	}
	//***********检查权限结束******************************
	//如果合同已结项则不允许修改
	List<String> forbiddenList=new ArrayList<String>();
	forbiddenList.add("2c91a0302a8cef72012a8eabe0e803f2");
	forbiddenList.add("2c91a0302a8cef72012a8eabe0e803f3");
	forbiddenList.add("2c91a0302ab11213012ab12bf0f00021");
	if(forbiddenList.contains(projectState)){
		isCanEdit=false;
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60056") %><!-- 项目进度分解图 --></title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<!--edo css-->
	<link href="<%=path %>/project/scripts/edo/res/css/edo-all.css" rel="stylesheet" type="text/css" />
	<link href="<%=path %>/project/scripts/edo/res/product/project/css/project.css" rel="stylesheet" type="text/css" />
	<!--edo js-->
	<script src="<%=path %>/project/scripts/edo/edo.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/thirdlib/excanvas/excanvas.js" type="text/javascript"></script>
	
	<!-- add js -->
	<script src="<%=path %>/project/scripts/eweaver/ProjectService.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/wbscheck/menu.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/wbscheck/body.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/wbscheck/logic.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/wbscheck/banner.js" type="text/javascript"></script>
	<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
  </head>
  <body style="overflow:auto">
  	<div id="banner" style="height: 40px"></div>
  	<div id="view" style="width: 100%;overflow:hidden"></div>
  </body>
</html>
<script type="text/javascript">
 	//默认信息：项目ID,项目编号,项目名称,owner,事业部门,事业部门名称
 	var ProjectUID = "<%=requestId%>";
 	var ProjectNo = "<%=projectNo%>";
 	var ProjectName= "<%=projectName%>";
	var Owner = "<%=currentuser.getId()%>";
 	var Department = "<%=currentuser.getExtrefobjfield10()%>";
	var DepartmentName = "<%=orgunitService.getOrgunitName(currentuser.getExtrefobjfield10())%>";
	var isCanEdit = <%=isCanEdit%>;
	//dataproject用于维护gantt里面的数据结构
	var dataProject;
	//selectProject用于维护所有的下拉列表的数据
	var selectProject={};
	var isAdded=false;
	Edo.build({
	    id: 'project',
	    type: 'edogantt',
	    width: 0,
	    height: 0,  
	    startDate: new Date(2009, 0, 28),
	    finishDate: new Date(2011, 1, 30),
	    render: document.getElementById('view')
	});
	//设置tip信息
	project.gantt.taskTipRenderer = function(task, gantt, isTrack){  
	    if(isTrack){
	        var bl = task.Baseline ? task.Baseline[gantt.baselineIndex] : null;
	        return task.Name+"<br/><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60057") %>:"+(bl.Start?bl.Start.format('Y-m-d'):'')+//比较基准开始日期
	    	        "<br /><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60058") %>:"+(bl.Finish?bl.Finish.format('Y-m-d'):'');//比较基准完成日期
	    }else{            
	        return task.Name+"<br/><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fcf6370000a") %>:"+(task.Start?task.Start.format('Y-m-d'):'')+//开始日期
	        	"<br /><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005a") %>:"+(task.Finish?task.Finish.format('Y-m-d'):'');//完成日期
	    }
	}
	//将甘特图撑满页面
	function onWindowResize(){    
	    var size = Edo.util.Dom.getViewSize(document);
	    var hdSize = Edo.util.Dom.getSize(document.getElementById('banner'));
	    
	    project.set({
	        width: size.width,
	        height: (Math.floor((size.height - hdSize.height-5)/22)*22+5)
	    });
	}
	Edo.util.Dom.on(window, 'resize', onWindowResize);
	onWindowResize();
	//初始化WBS左侧数的数据
	loadNodes('getTasks','-1',true,
			function(data){
				dataProject = new Edo.data.DataGantt(data);
				dataProject.set('Deleted', []);
				project.set('data', dataProject);
				for(i=0;i<project.tree.data.children.length;i++){
					var r=project.tree.data.children[i];
					if(r && r.Model== SELECTID.zhurenwu){
						project.tree.data.collapse(r,true);
					}
					project.tree.data.iterateChildren(r, function(o){
						if(o && o.Model== SELECTID.zhurenwu){
							project.tree.data.collapse(o,true);
						}
					},project.tree.data);
				}
			}
	);
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
				data.unshift({ID:null,OBJNAME:''});
				selectProject[SELECTID.model] = data;
				//model1.set('data', selectProject[SELECTID.model]);
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
			//Status1.set('data', selectProject[SELECTID.Status]);
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
	//增加所属专业下拉框
	loadSubNodes({
		masterType: SELECTID.subject,
    	method: 'getSelectOperation'
    	},
			function(data){
				data.unshift({ID:null,OBJNAME:''});
				selectProject[SELECTID.subject] = data;
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
	//增加数据处理插件
	project.addPlugin(new GanttSchedule());
	project.addPlugin(new GanttMenu());
	//使甘特图可拖拽调节大小
	/*Edo.managers.ResizeManager.reg({
	    target: project
	});*/
</script>
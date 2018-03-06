<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/base/init.jsp"%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	String path = request.getContextPath();
	String templetID=request.getParameter("templetId").trim();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50049") %><!-- 任务模板 --></title>
    
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
	<script src="<%=path %>/project/scripts/eweaver/templet/menu.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/templet/body.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/templet/dialog.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/templet/logic.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/templet/banner.js" type="text/javascript"></script>
  </head>
  <body>
  	<div id="banner" style="height:40px"></div>
  	<div id="view"></div>
  </body>
</html>
<script type="text/javascript">
	var ProjectUID = "<%=templetID%>";
	var dataProject;
	var selectProject = {};
	var cutBoard=[];
	var isAdded=false;
	Edo.build({
	    id: 'project',
	    type: 'eweaverwbs',
	    width: 1100,
	    height: 450,  
	    startDate: new Date(2009, 0, 28),
	    finishDate: new Date(2011, 1, 30),
	    render: document.getElementById('view')
	});
	//将甘特图撑满页面
	function onWindowResize(){    
	    var size = Edo.util.Dom.getViewSize(document);
	    var hdSize = Edo.util.Dom.getSize(document.getElementById('banner'));
	    
	    project.set({
	        width: size.width,
	        height: size.height - hdSize.height
	    });
	    
	}
	Edo.util.Dom.on(window, 'resize', onWindowResize);
	onWindowResize();
	//加载列表数据
	loadNodes('getTasks','-1',true,
		function(data){
			dataProject = new Edo.data.DataGantt(data);
			dataProject.set('Deleted', []);
			project.set('data', dataProject);
		}
	);
	//增加任务模式下拉框
	loadSubNodes({
		masterType: SELECTID.model,
    	method: 'getSelectOperation'
    	},
			function(data){
				data.pop();//删除子节点
				for(var i=0;i<data.length;i++){
					var result = new c(data[i].ID);
					result();
				}
				data.unshift({ID:null,OBJNAME:''});
				selectProject[SELECTID.model] = data;
				model1.set('data', selectProject[SELECTID.model]);
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
				RiskLevel1.set('data', selectProject[SELECTID.RiskLevel]);
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
				Pri1.set('data', selectProject[SELECTID.Pri]);
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
				Subject1.set('data',selectProject[SELECTID.subject]);
			}
	);
	//增加任务状态下拉框
	loadSubNodes({
		masterType: SELECTID.Status,
    	method: 'getSelectOperation'
    	},
		function(data){
			selectProject[SELECTID.Status] = data;
		}
	);
	//增加右键菜单插件
	project.addPlugin(new WBSMenu());
	//增加数据处理插件
	project.addPlugin(new GanttSchedule());
</script>
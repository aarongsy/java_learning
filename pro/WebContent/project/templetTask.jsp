<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/base/init.jsp"%>
<%
	String path = request.getContextPath();
	DataService dataService = new DataService();
	List result;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50049") %><!-- 任务模板 --></title>
	<!--edo css-->
	<link href="<%=path %>/project/scripts/edo/res/css/edo-all.css" rel="stylesheet" type="text/css" />
	<link href="<%=path %>/project/scripts/edo/res/product/project/css/project.css" rel="stylesheet" type="text/css" />
	<!--edo js-->
	<script src="<%=path %>/project/scripts/edo/edo.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/thirdlib/excanvas/excanvas.js" type="text/javascript"></script>
	<!-- add js -->
	<script src="<%=path %>/project/scripts/eweaver/ProjectService.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/wbs/loadTemplet/body.js" type="text/javascript"></script>
	<script src="<%=path %>/project/scripts/eweaver/wbs/loadTemplet/logic.js" type="text/javascript"></script>
	<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	<style type="text/css">
	.x-toolbar TABLE{
		width:0px;
		}
	</style>
  </head>
  <body>
  	<div id="banner" style="width: 100%"></div>
  		<table>
  			<tr>
  			<td align="left">
  				 <%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff9588e0272") %><!-- 模板名称 -->:
  				 <select class="templetId" name="STATUS" style="width: 40%" id="templetId" onchange="templetChange()">
					<option value="" selected></option>
					<%
						result = dataService.getValues("select requestid,objname From uf_task_template");
						for(int i = 0;i<result.size();i++){%>
							<option value="<%=((Map)result.get(i)).get("requestid").toString() %>"><%=((Map)result.get(i)).get("objname").toString() %></option>
					<%}%>
				</select>
  			</td>  			
  			</tr>
  		</table>
  	<div id="view"></div>
  </body>
</html>
<script type="text/javascript">
var tb = new Ext.Toolbar();
tb.render('banner');
addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009") %>','S','accept',function(){onSubmit()});//提交
addBtn(tb,'<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>','C','erase',function(){onClose()});//关闭
	var ProjectUID = "";
	var dataProject;
	var selectProject = {};
	Edo.build({
	    id: 'project',
	    type: 'eweaverwbs',
	    width: 300,
	    height: 350,  
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
	        height: (Math.floor((size.height - hdSize.height-25)/22)*22+5)
	    });
	    
	}
	Edo.util.Dom.on(window, 'resize', onWindowResize);
	onWindowResize();
	//增加数据处理插件
	project.addPlugin(new GanttSchedule());
	
	function templetChange(){
		ProjectUID = document.getElementById('templetId').value;
		loadNodes('getCheckedTasks','-1',true,function(data){
			dataProject = new Edo.data.DataGantt(data);
			project.data.beginChange();
			project.set('data', dataProject);
			project.data.endChange();
		});
	}
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
	function onSubmit(){
		project.tree.data.iterateChildren(project.tree.data, function(o){
	    	if(o && o.Checked == 0){
	    		project.tree.data.remove(o);
	    	}
	    },project.tree);
		var input = window.parent.document.getElementById("tempTask");
        input.value=Edo.util.JSON.encode(project.tree.data.children);
        window.parent.addTasksAndClosePannel(true);
	}
	function onClose(){
		window.parent.addTasksAndClosePannel(false);
	}
  	</script>
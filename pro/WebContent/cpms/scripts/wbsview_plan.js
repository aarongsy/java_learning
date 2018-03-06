var tableconfig = {
	'name':'baseconfig','header':[
	 	{'name':'id','index':'id','type':'hidden'},
	 	{'name':'projectid','index':'projectid','type':'hidden'},
	 	{'name':'dsporder','index':'dsporder','type':'hidden'},
	 	{'name':'requestid','index':'requestid','type':'hidden'},
	 	{'name':'wbs','width':'30px','index':'wbs','type':'text'},
	 	{'name':'任务名称','width':'45%','index':'objname','type':'html',
	 		'render':function(task,value,cell){
		 		var html='<a '+task.getStyle()+'href=\'javascript:openTask("'+task.requestid+'","'+task.projectid+'","'+task.objname+'");\'>'+value+'</a>';
				var margin=15*(task.level);
				if(task.hasChild){
					html='<span style="margin-left:'+margin+'px"><img id="img_'+task.id
						+'" style="cursor:hand;" src="/cpms/images/plus.gif" align="absmiddle" onclick=javascript:clickNode("'+task.id+'");>'
						+html+'<span>';
				}else{
					margin+=16;
					html='<span style="margin-left:'+margin+'px">'+html+'</span>';
				}
				cell.innerHTML=html;
	 		},
	 		'projectRender':function(project,value,cell){
	 			var html='<a class="weight" href=\'javascript:openProject("'+project.id+'","'+project.objname+'");\'>'+value+'</a>';
				if(project.tasks.length>0){
					html='<img id="img_'+project.id	+'" style="cursor:hand;" src="/cpms/images/minus.gif" align="absmiddle" onclick=javascript:clickProject();>'	+html;
				}
				cell.innerHTML=html;
	 		}
	 	},
	 	{'name':'操作','width':'15%','index':'objpercent','type':'bar',
	 		'render':function(task,value,cell){
				var html='<img style="cursor:hand;" src=/cpms/images/add.gif title=\'添加子任务\' onclick=javascript:onAdd("'+task.projectid+'","'+task.requestid+'")> ';
				html += '<img style="cursor:hand;" src=/cpms/images/delete.gif title=\'删除\' onclick=javascript:onDelete("'+task.projectid+'","'+task.requestid+'")>';
				if(task.dsporder>1){
					html += '<img style="cursor:hand;" src=/cpms/images/moveup.gif title=\'上移\' onclick=javascript:onMoveUp("'+task.projectid+'","'+task.requestid+'")>';
				}else{
					html += '<img src="/cpms/images/up.gif">';
				}
				if(task.dsporder<task.brotherSize){
					html += '<img style="cursor:hand;" src=/cpms/images/movedown.gif title=\'下移\' onclick=javascript:onMoveDown("'+task.projectid+'","'+task.requestid+'")>';
				}else{
					html += '<img src="/cpms/images/down.gif">';
				}
				cell.innerHTML=html;
			},
			'projectRender':function(project,value,cell){
				var html='<img style="cursor:hand;" src=/cpms/images/add.gif title=\'添加子任务\' onclick=javascript:onAdd("'+project.id+'","")> ';
				cell.innerHTML=html;
	 		}
	 	},
	 	{'name':'责任人','width':'10%','index':'managername','type':'text'},
	 	{'name':'责任部门','width':'10%','index':'unitname','type':'text'},
	 	{'name':'计划开始日期','width':'10%','index':'planstart','type':'text'},
	 	{'name':'计划结束日期','width':'10%','index':'planfinish','type':'text'}]
};
var project,treetable;
function $(id){
	return document.getElementById(id);
}
function initWBS(name){
	treetable = new TreeTable(name);
	project = new Project(data);
	treetable.loadProject(project);
}
function openTask(id,projectid,objname){
	//onUrl('/cpms/project/taskedit.jsp?requestid='+id+'&projectid='+projectid,objname,'plan_'+id);
	onUrl('/cpms/project/taskinfo.jsp?requestid='+id+'&projectid='+projectid,objname,'plan_'+id);
}
function onAdd(projectid,pid){
	var url='/cpms/project/taskcreate.jsp?projectid='+projectid+'&pid='+pid;
	openchild(url,'新建任务','bullet_plus',800,450);
}
function onMoveUp(projectid,id){
	location.href="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=moveup&requestid="+id+"&projectid="+projectid;
}
function onMoveDown(projectid,id){
	location.href="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=movedown&requestid="+id+"&projectid="+projectid;
}
function onDelete(projectid,id){
	if(confirm("该操作将删除当前任务以及子任务！确定要删除吗?")){
		location.href="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=delete&requestid="+id+"&projectid="+projectid;
	}
}
function onImport(projectid){
	if(project.tasks.length>0){
		alert("任务已经初始化，不能重复导入");
		return;
	}
	var value = openDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=402882082e508505012e5130c9cf0028');
	if(value[0]!=''){
		location.href="/ServiceAction/com.eweaver.cpms.project.wbstemplate.ImportTasktemplateAction?action=import&tempid="+value[0]+"&projectid="+projectid+"&categoryid=402880ac2d823840012d825c62750003";
	}
}
function exportXML(projectid){
	location.href="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=exportXml&projectid="+projectid;
}
function importXML(projectid){
	if(project.tasks.length>0){
		alert("任务已经初始化，不能重复导入");
		return;
	}
	var value = openDialog('/base/popupmain.jsp?url=/document/file/fileuploadbrowser.jsp');
	if(value && value[0]){
		location.href="/ServiceAction/com.eweaver.cpms.project.task.TaskAction?action=importbympp&attachid="+value[0]+"&projectid="+projectid+"&categoryid=402880ac2d823840012d825c62750003";
	}
}
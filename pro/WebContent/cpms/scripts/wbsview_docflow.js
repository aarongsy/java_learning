var tableconfig = {
	'name':'baseconfig','header':[
	 	{'name':'id','index':'id','type':'hidden'},
	 	{'name':'projectid','index':'projectid','type':'hidden'},
	 	{'name':'requestid','index':'requestid','type':'hidden'},
	 	{'name':'wbs','width':'30px','index':'wbs','type':'text'},
	 	{'name':'任务名称','width':'25%','index':'objname','type':'html',
	 		'render':function(task,value,cell){
	 			var html='<a '+task.getStyle()+'href=\'javascript:openTask("'+task.projectid+'","'+task.requestid+'","'+task.objname+'");\'>'+value+'</a>';
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
	 	{'name':'相关流程','width':'25%','index':'flow','type':'html'},
	 	{'name':'相关文档','width':'25%','index':'doc1','type':'html'},
	 	{'name':'参考文档','width':'25%','index':'doc2','type':'html'}]
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
function openTask(projectid,id,objname){
	onUrl('/cpms/project/taskinfo_process.jsp?projectid='+projectid+'&taskid='+id,objname,'exec_'+id);
}
function refresh(){
	location.reload();
}
function openDoc(docid,title){
	onUrl('/document/base/docbaseview.jsp?id='+docid,title,'tab_'+docid);
}
function openFlow(requestid,title){
	onUrl('/workflow/request/workflow.jsp?requestid='+requestid,title,'tab_'+requestid);
}
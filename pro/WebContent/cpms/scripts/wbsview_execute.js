var tableconfig = {
	'name':'baseconfig','header':[
	 	{'name':'id','index':'id','type':'hidden'},
	 	{'name':'projectid','index':'projectid','type':'hidden'},
	 	{'name':'requestid','index':'requestid','type':'hidden'},
	 	{'name':'wbs','width':'30px','index':'wbs','type':'text'},
	 	{'name':'任务名称','width':'20%','index':'objname','type':'html',
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
	 	{'name':'任务状态','width':'10%','index':'statusname','type':'text'},
	 	{'name':'进度','width':'10%','index':'objpercent','type':'bar',
	 		'render':function(task,value,cell){
	 			var colorbd='#999';
				var colorbg='#ddd';
				var imgSrc='/cpms/images/bullet_orange.gif';
				if(value>0){
					colorbd='#50abff';
					colorbg='#d4e6ff';
					var imgSrc='/cpms/images/bullet_right.gif';
				}
				if(value==100){
					colorbd='#9fc54e';
					colorbg='#dbeace';
					var imgSrc='/cpms/images/bullet_tick.gif';
				}
				var div=document.createElement('div');
				div.className='taskProcess';
				var statusImg = document.createElement('img');
				statusImg.src=imgSrc;
				var outBar=document.createElement('div');
				outBar.style.backgroundColor=colorbg;
				outBar.style.borderColor=colorbd;
				var innerBar=document.createElement('div');
				innerBar.style.width=value+'px';
				innerBar.style.backgroundColor=colorbd;
				outBar.appendChild(innerBar);
				div.appendChild(statusImg);
				div.appendChild(outBar);
				div.appendChild(document.createTextNode(value+'%'));
				cell.appendChild(div);
	 		}
	 	},
	 	{'name':'责任人','width':'10%','index':'managername','type':'text'},
	 	{'name':'责任部门','width':'10%','index':'unitname','type':'text'},
	 	{'name':'计划开始','width':'10%','index':'planstart','type':'text'},
	 	{'name':'开始时间是否延迟','index':'delaystart','type':'hidden'},
	 	{'name':'完成时间是否延迟','index':'delayfinish','type':'hidden'},
	 	{'name':'计划结束','width':'10%','index':'planfinish','type':'text'},
	 	{'name':'实际开始','width':'10%','index':'startdate','type':'text',
	 		'render':function(task,value,cell){
	 			if(task.delaystart){
	 				cell.innerHTML='<span style="color:red">'+value+'</span>';
	 			}else{
	 				cell.innerHTML=value;
	 			}
	 		}
	 	},
	 	{'name':'实际结束','width':'10%','index':'finishdate','type':'text',
	 		'render':function(task,value,cell){
		 		if(task.delayFinish){
	 				cell.innerHTML='<span style="color:red">'+value+'</span>';
	 			}else{
	 				cell.innerHTML=value;
	 			}
	 		}
	 	}]
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
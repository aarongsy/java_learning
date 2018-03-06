var tableconfig = {'name':'WSBTemplateConfig','header':[
	{'name':'id','index':'id','type':'hidden'},
	{'name':'requestid','index':'requestid','type':'hidden'},
	{'name':'dsporder','index':'dsporder','type':'hidden'},
	{'name':'wbs','width':'30px','index':'wbs','type':'text'},
	{'name':'任务名称','width':'40%','index':'name','type':'html',
		'render':function(task,value,cell){
			var html='<a '+task.getStyle()+'href=javascript:openTask("'+task.requestid+'","'+task.name+'")>'+value+'</a>';
			var margin=15*(task.level);
			if(task.hasChild){
				html='<span style="margin-left:'+margin+'px"><img id="img_'+task.id
					+'" style="margin:0;cursor:hand;" src="/cpms/images/plus.gif" align="absmiddle" onclick=javascript:clickNode("'+task.id+'");>'
					+html+'<span>';
			}else{
				margin+=17;
				html='<span style="margin-left:'+margin+'px">'+html+'</span>';
			}
			cell.innerHTML=html;
		},
		'projectRender':function(project,value,cell){
 			//var html='<a class="weight" href=javascript:openProject("'+project.id+'","'+project.objname+'")>'+value+'</a>';
			var html=value;
			if(project.tasks.length>0){
				html='<img id="img_'+project.id	+'" style="margin:0 2 0 2;cursor:hand;" src="/cpms/images/minus.gif" align="absmiddle" onclick=javascript:clickProject();>'	+html;
			}
			cell.innerHTML=html;
 		}
	},
	{'name':'操作','width':'15%','index':'adddel','type':'actions',
		'render':function(task,value,cell){
			var html=' <img style="cursor:hand;" src=/cpms/images/add.gif title=\'添加子任务\' onclick=javascript:onAdd("'+task.id+'")>';
			html = html +'&nbsp;<img style="cursor:hand;" src=/cpms/images/delete.gif title=\'删除\' onclick=javascript:onDelete("'+task.id+'")>';
			if(task.dsporder>1){
				html = html+' <img style="cursor:hand;" src=/cpms/images/moveup.gif title=\'上移\' onclick=javascript:onUp("'+task.id+'")>';
			}else{
				html += ' <img src="/cpms/images/up.gif">';
			}
			if(task.dsporder<task.brotherSize){
				html = html+' <img style="cursor:hand;" src=/cpms/images/movedown.gif title=\'下移\' onclick=javascript:onDown("'+task.id+'")>';
			}else{
				html += ' <img src="/cpms/images/down.gif">';
			}
		//	html = html+'&nbsp;<img src=/cpms/images/moveleft.gif title=\'左移\' onclick=javascript:onLeft("'+task.id+'")>';
		//	html = html+'&nbsp;<img src=/cpms/images/moveright.gif title=\'右移\' onclick=javascript:onRight("'+task.id+'")>';
			cell.innerHTML=html;
		},
		'projectRender':function(project,value,cell){
			var html='<img style="cursor:hand;" src=/cpms/images/add.gif title=\'添加子任务\' onclick=javascript:onAdd("'+project.id+'","")> ';
			cell.innerHTML=html;
 		}
	},
	{'name':'任务类别','width':'15%','index':'tasktype','type':'text'},
	{'name':'责任部门','width':'15%','index':'orgunit','type':'text'},
	{'name':'工期','width':'15%','index':'duration','type':'text'}
	//{'name':'前置任务','width':'8%','index':'pertask','type':'text'},
	//{'name':'参考文档','width':'8%','index':'doclink','type':'text'},
	//{'name':'输出文档','width':'8%','index':'doctypelink','type':'text'},
	//{'name':'任务流程','width':'8%','index':'flow','type':'text'},
	//{'name':'监控点','width':'15%','index':'controlpoint','type':'text'}
	]};

var project,treetable;
function $(id){
	return document.getElementById(id);
}
function initWBS(name){
	$(name).innerHTML='';
	treetable = new TreeTable(name);
	project = new Project(data);
	treetable.loadProject(project);
}

function refresh(){
	location.reload();
}
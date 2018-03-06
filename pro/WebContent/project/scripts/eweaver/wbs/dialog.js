EdoGantt.showTaskWindow = function(type, task, dataProject, callback) {
	var page;
	var taskId;
	var pid = ProjectUID;
	var title;
	if (type == 'new') {
		title = "新增任务";
		page='addTask';
	}else if (type == 'edit') {
		taskId = 'bianji';
		title = "编辑任务";
		if (task.Model != SELECTID.zhurenwu)
			page='addSubProject';
		else
			page='addTask';
	}else if(type == 'view'){
		page='viewTask';
		taskId = 'chakan';
		title = "查看任务";
		if (task.Model != SELECTID.zhurenwu)
			page='viewSubProject';
	}else if(type == 'templet'){
		page='templetTask';
		pid = "-1";
		title = "模板导入";
	}else if(type == 'addSubProject'){
		page="addSubProject",
		title="新增机组/类别"
	}
	dlg0.setTitle(title);
	dlg0.getComponent('dlgpanel').setSrc(page+'.jsp?taskId='+ taskId + '&projectId='+pid);
	dlg0.show();
};

function closepannel(arg){
	dlg0.hide();
	project.data.beginChange();
	if(arg===1){
		isAdded = true;
		var NewTask = Edo.util.JSON.decode(document.getElementById("tempTask").value);
		//Edo.util.JSON.decode(cc));
		//alert(eval('(' + cc + ')'));
		var p,index;
		var task = project.tree.getSelected();
		if(task){
            p = project.tree.data.findParent(task);        
            index = p.children.indexOf(task);
        }else{
            p = project.tree.data;        
            index = project.tree.data.children.length-1;
        }
		project.tree.data.insert(index+1,NewTask, p);
		if(NewTask.Model == SELECTID.zhurenwu)
        	checkSubNodes(NewTask,NewTask.MasterType);
	}else if(arg===2){
		var NewTask = Edo.util.JSON.decode(document.getElementById("tempTask").value);
		var task = project.tree.getSelected();
		task.Start = NewTask.Start;
		task.Finish = NewTask.Finish;
		task.HopeStartDate = NewTask.HopeStartDate;
		task.HopeFinishDate = NewTask.HopeFinishDate;
		task.ReceiveDate = NewTask.ReceiveDate;
		if(NewTask.Model == SELECTID.zhurenwu)
        	checkSubNodes(task,NewTask.MasterType);
	}
	//保存到数据库
	if(!validate(project.data.children,1)){
		return false;
	}
    Edo.MessageBox.saveing('保存', '正在保存项目数据,请稍等...');
    var json = {
		children: project.data.children,
    	ProjectId: ProjectUID,
    	ParentTaskId: '-1',
    	Deleted: project.data.Deleted
    };
    ProjectService.set({
    	method: 'setTasks',
    	tasks: json
    },function(text){
    	if(isAdded){
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
    	}
        Edo.MessageBox.hide();
    }, function(msg, code){
        alert(msg);
        Edo.MessageBox.hide();
    });
    project.data.Deleted=[];
    //更新数据
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
	
	project.data.endChange();
}
function addTasksAndClosePannel(arg){
	dlg0.hide();
    if(arg){
    	isAdded = true;
		var tree = project.tree;
		var task = tree.getSelected();
		tree.data.beginChange();
		var p,index;
		var nodes = Edo.util.JSON.decode(document.getElementById("tempTask").value);
	    if(task){
	        p = tree.data.findParent(task);        
	        index = p.children.indexOf(task);
	    }else{
			p = tree.data;        
			index = tree.data.children.length-1;
	    }
	    var Status='2c91a0302aa21947012aa232f186000f';
//	    for(var i=0;i<selectProject[SELECTID.Status].length;i++){
//	    	if(selectProject[SELECTID.Status][i].OBJNAME == "未下达"){
//	    		Status = selectProject[SELECTID.Status][i].ID;
//	    		break;
//	    	}
//	    }
	    for(var i=0;i<nodes.length;i++){
	    	if(nodes[i].Checked == 1){
	    		nodes[i].IsTemplet = 0;
	    		nodes[i].ContractNo = ProjectNo;
	    		nodes[i].ContractName = ProjectName;
	    		nodes[i].Department = Department;
	    		nodes[i].DepartmentName = DepartmentName;
	    		nodes[i].CreateDate = null;
	    		if(nodes[i].Model != SELECTID.zixiangmu && !nodes[i].Status){
	    			nodes[i].Status = Status;
	    		}
	    		tree.data.insert(index+1,nodes[i], p);
	    		if(nodes[i].Model == SELECTID.zhurenwu){
	    			project.tree.select(nodes[i]);
	    			checkSubNodes(nodes[i],nodes[i].MasterType);
	    		}
    			project.tree.data.iterateChildren(nodes[i], function(o){
    		    	if(o && o.Model!= SELECTID.jiedian){
		    			o.IsTemplet = 0;
		    			o.ContractNo = ProjectNo;
		    			o.ContractName = ProjectName;
			    		o.Department = Department;
			    		o.DepartmentName = DepartmentName;
			    		o.CreateDate = null;
		    			if(!o.Status)
		    				o.Status = Status;
		    			if(o.Model==SELECTID.zhurenwu && o.MasterType){
		    				project.tree.select(o);
		    				checkSubNodes(o,o.MasterType);
		    			}
    		    	}
    		    },tree.data);
	    		index++;
	    	}
	    }
	    tree.data.endChange();
    }
}
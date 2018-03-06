GanttSchedule = function(){
    GanttSchedule.superclass.constructor.call(this);
}
GanttSchedule.extend(Edo.core.Component, {
    init: function(project){        
        this.project = project;
        //任务树单元格编辑提交处理
        project.tree.on('beforesubmitedit', this.onBeforeSubmitEdit, this);
        //监听beforecelledit事件, 禁止摘要任务的工期和日期编辑
        project.tree.on('beforecelledit', this.onBeforeCellEdit, this);
        project.tree.on('cellclick', this.onCellClick, this);
        project.tree.on('selectionchange',this.onSelectionchange,this);
    },
    onBeforeSubmitEdit: function(e){
        var dataGantt = this.project.data;
        var task = e.record; //获得当前行任务对象
        var column = e.column; //获得当前编辑的列对象
        dataGantt.beginChange();   
        switch(column.dataIndex){
            case 'Name':
                task.Name = e.value;
            break;
            case 'Start':
            	if(e.value==""){
            		task.Start = null;
            	}else{
	            	var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
	            	if(task.Finish && task.Finish<value){
	            		task.Start = task.Finish;
	            		alert('预计开始时间不能大于预计结束时间');
	            	}else{
	            		task.Start = value;
	            	}
            	}
            break;
            case 'Finish':
            	if(e.value==""){
            		task.Finish = null;
            	}else{
	            	if(task.Start){
	            		var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
	            		if(value<task.Start){
	            			task.Finish = task.Start;
	            			alert('预计结束时间不能小于预计开始时间');
	            		}else{
	            			task.Finish = value;
	            		}
	            	}else
	            		alert('请先填写预计开始时间');
            	}
            break;
            case 'PercentComplete':
                task.PercentComplete = e.value;
            break;
        }
        dataGantt.endChange();    
        return false;
    },
    onBeforeCellEdit: function(e){
    	if(e.record.Department!=Department){
    		//alert('你没有权限修改此业务部门的任务信息');
    		return false;
    	}
    	if(e.record.IsInWorkFlow===1){
    		return false;
    	}
    },
    onCellClick: function(e){
    	if(e.columnIndex===1 && isCanEdit){//删除
    		var r = project.tree.getSelected();
            if(r){
            	if(r.Department!=Department){
            		alert('对于非本事业部门的任务不可以进行删除操作！');
            		return false;
            	}
            	if(r.Model==SELECTID.jiedian) return;
            	if(r.Status=='2c91a0302aa21947012aa232f186000f' || 
            			r.Status=='2c91a0302aa21947012aa232f1860010' ||
            			r.Status==null){
            		var isCanDelete = true;
            		if(r.children){
                		project.tree.data.iterateChildren(r, function(o){
                	    	if(o.Status!='2c91a0302aa21947012aa232f186000f' && 
                        			o.Status!='2c91a0302aa21947012aa232f1860010' &&
                        			o.Status!=null){
                	    		isCanDelete = false;
                	    	}
                	    },project.tree);
            		}
            		if(!isCanDelete){
            			alert('对于含有执行状态的任务不可以进行删除操作！');
            			return;
            		}
            		project.data.Deleted.push(r.UID);
    	    		project.tree.data.remove(r);
            		var parentNode = project.tree.data.findParent(r);
                	if(parentNode && parentNode.children.length==0)
                		parentNode.__viewicon = false;
            	}
            	else
            		alert('对于进入执行状态的任务不可以进行删除操作！');
            }	
    	}
    },
    onSelectionchange: function(e){
    	if(e.selected){
	    	var tempValue= e.selected.MasterType;
	    	if(e.selected.Model && selectProject[e.selected.Model]){
	    		MasterType1.set('data', selectProject[e.selected.Model]);
	    	}else{
	    		MasterType1.set('data', []);
	    	}
	    	e.selected.MasterType =tempValue;
    	}
    }
});

function setTreeSelect(sels, Checked, deepSelect){//deepSelect:是否深度跟随选择
    project.tree.data.beginChange();      
    if(deepSelect){
    	project.tree.data.iterateChildren(sels, function(o){
            this.data.update(o, 'isSelect', Checked);
        },project.tree);
    }
    project.tree.data.update(sels, 'isSelect', Checked);
    project.tree.data.endChange();
}
/**
 * 检查节点是否需要子节点带入进来
 * @param node	节点
 * @param key	节点需要检查的关键字
 * @return
 */
function checkSubNodes(node,key){
	project.tree.data.beginChange();
	if(!node.children){
		node.children = [];
	}else{
		for(var i=0;i<node.children.length;){
			if(node.children[i].Model==SELECTID.jiedian){
	    		project.data.Deleted.push(node.children[i].UID);
	    		project.tree.data.remove(node.children[i]);
			}else
				i++;
		}
	}
	if(!selectProject[key]){//如果没有加载选择项则添加选择项
		loadSubNodes({
			masterType: key,
			method: 'getSubNodes'
			},
			function(data){
				if(!selectProject[key])
					selectProject[key] = data;
				for(var j=0;j<selectProject[key].length;j++){
					project.tree.data.insert(j,{
			            UID: new Date().getTime()+"",
			            Name: selectProject[key][j].TASKNAME,
			            CreateDate: new Date(),
			            Start: null,
			            Finish: null,
			            ContractNo: ProjectNo,
		    			ContractName: ProjectName,
		    			Model: SELECTID.jiedian,
		    			MasterType: selectProject[key][j].TASKTYPE,
			            PercentComplete: 0,
			            ParenttaskUID: '-1',
			            IsTemplet: 0,
			            Critical: selectProject[key][j].ISMAIN,
			            Checked: 1
			        },node);
				}
			}
		);
	}else{
		for(var j=0;j<selectProject[key].length;j++){
			project.tree.data.insert(j,{
	            UID: new Date().getTime()+"",
	            Name: selectProject[key][j].TASKNAME,
	            CreateDate: null,
	            Start: null,
	            Finish: null,
	            ContractNo: ProjectNo,
    			ContractName: ProjectName,
    			Model: SELECTID.jiedian,
    			MasterType: selectProject[key][j].TASKTYPE,
	            PercentComplete: 0,
	            ParenttaskUID: '-1',
	            IsTemplet: 0,
	            Critical: selectProject[key][j].ISMAIN,
	            Checked: 1
	        },node);
		}
	}
	project.tree.data.endChange();
}
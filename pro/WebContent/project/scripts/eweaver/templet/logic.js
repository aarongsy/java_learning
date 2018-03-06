GanttSchedule = function(){
    GanttSchedule.superclass.constructor.call(this);
}
GanttSchedule.extend(Edo.core.Component, {
    init: function(project){        
        this.project = project;
        this.istoggle = false;
        this.preSelect = null;
        this.Index = null;
        //任务树单元格编辑提交处理
        project.tree.on('beforesubmitedit', this.onBeforeSubmitEdit, this);
        //监听beforecelledit事件, 禁止摘要任务的工期和日期编辑
        //project.tree.on('beforecelledit', this.onBeforeCellEdit, this);   
        //监听beforetoggle时间
        //project.tree.on('beforetoggle', this.onBeforetoggle, this);
        //监听单元格点击事件
        //project.tree.on('cellclick', this.onCellclick, this);
        project.tree.on('selectionchange',this.onSelectionchange,this);
    },
    onBeforetoggle: function(e){
    	var record = project.tree.getSelected();
        var dataTree = project.tree.data;
        if(!record.children || record.children.length == 0){
        	project.tree.addItemCls(record, 'tree-node-loading');
        	loadNodes('getTasks',record.UID,false,
    			function(data){
    				dataTree.addRange(data, record);
    			}
        	);       
        }
        return true;
    },
    onCellclick: function(e){
    	if(e.columnIndex==1){
            var r = e.record;
            if(r){
                setTreeSelect(r, (r.Checked+1)%2, true);
            }
    	}
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
            case 'OfficeName':
            	task.OfficeName = e.value;
            break;
            case 'PrincipalName':
            	task.PrincipalName = e.value;
            break;
            case 'Critical':
            	task.Critical = e.value;
            break;
            case 'Description':
            	task.Description = e.value;
            break;
            case 'Require':
            	task.Require = e.value;
            break;
            case 'RiskLevel':
            	task.RiskLevel = e.value;
            break;
            case 'Pri':
            	task.Pri = e.value;
            break;
            
        }
        dataGantt.endChange();    
        return false;
    },
    onBeforeCellEdit: function(e){
        var r = e.record;
        var c = e.column;
        
        if(r.Summary ) {                                        
            if(['Start', 'Finish', 'Duration', 'Work'].indexOf(c.dataIndex) != -1){
                return false;
            }
        }
    },
    onSelectionchange: function(e){
    	var tempValue= e.selected.MasterType;
    	if(e.selected.Model && selectProject[e.selected.Model]){
    		MasterType1.set('data', selectProject[e.selected.Model]);
    	}else{
    		MasterType1.set('data', []);
    	}
    	e.selected.MasterType =tempValue;
    }
});

function setTreeSelect(sels, Checked, deepSelect){//deepSelect:是否深度跟随选择
    if(!Edo.isArray(sels)) sels = [sels];
    project.tree.data.beginChange();
    for(var i=0,l=sels.length; i<l; i++){
        var r = sels[i];        
        var cs = r.children;        
        if(deepSelect){
        	project.tree.data.iterateChildren(r, function(o){
                this.data.update(o, 'Checked', Checked);
            },project.tree);
        }
        project.tree.data.update(r, 'Checked', Checked);
        if(Checked==1)
        	checkParentSelect(r);//如果父类没有选择则一并选择
    }
    project.tree.data.endChange();
}
function checkParentSelect(childNode){
	var parentNode = project.tree.data.findParent(childNode);
	if(!parentNode.dataTable){
		parentNode.Checked = 1;
		checkParentSelect(parentNode);
	}
}
function getTreeSelect(tree){
    var sels = [];
    tree.data.source.each(function(node){        
        if(node.Checked) sels.add(node);
    });
    return sels;
}

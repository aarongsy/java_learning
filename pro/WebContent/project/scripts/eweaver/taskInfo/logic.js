GanttSchedule = function(){
    GanttSchedule.superclass.constructor.call(this);
}
GanttSchedule.extend(Edo.core.Component, {
    init: function(project){        
        this.project = project;
        project.tree.on('beforesubmitedit', this.onBeforeSubmitEdit, this);
    },
    onBeforeSubmitEdit: function(e){
	    var dataGantt = this.project.data;
	    var task = e.record;
	    var column = e.column;
	    dataGantt.beginChange();   
	    switch(column.dataIndex){
	        case 'IndentStartDate':
	        	if(e.value==""){
            		task.IndentStartDate = null;
            	}else{
	            	var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
		        	if(task.IndentFinishDate && task.IndentFinishDate<value){
		        		task.IndentStartDate = task.IndentFinishDate;
		        		alert('实际开始时间不能大于实际结束时间');
		        	}else{
		        		task.IndentStartDate = value;
		        	}
            	}
	        break;
	        case 'IndentFinishDate':
	        	if(e.value==""){
            		task.IndentFinishDate = null;
            	}else{
            		var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
		        	if(task.IndentStartDate){
		        		if(value<task.IndentStartDate){
		        			task.IndentFinishDate = task.IndentStartDate;
		        			alert('预计结束时间不能小于预计开始时间');
		        		}else{
		        			task.IndentFinishDate = value;
		        		}
		        	}else
		        		alert('请先填写预计开始时间');
            	}
	        break;
	        case 'Status':
	        	if(task.Model == SELECTID.jiedian){
	        		task.Status = e.value;
	        	}else{
	        		alert('只允许修改节点的任务状态');
	        	}
        	break;
	    }
	    dataGantt.endChange();    
	    return false;
	}
});

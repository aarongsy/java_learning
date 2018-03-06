GanttSchedule = function(){
    GanttSchedule.superclass.constructor.call(this);
}
GanttSchedule.extend(Edo.core.Component, {
    init: function(project){        
        this.project = project;
        project.tree.on('beforesubmitedit', this.onBeforeSubmitEdit, this);
        project.tree.on('beforecelledit', this.onBeforeCellEdit, this);
    },
    onBeforeSubmitEdit: function(e){
        var dataGantt = this.project.data;
        var task = e.record;
        var column = e.column;
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
	            	if(task.IndentStartDate){
	            		var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
	            		if(value<task.IndentStartDate){
	            			task.IndentFinishDate = task.IndentStartDate;
	            			alert('实际结束时间不能小于实际开始时间');
	            		}else{
	            			task.IndentFinishDate = value;
	            		}
	            	}else
	            		alert('请先填写实际开始时间');
            	}
            break;
            case 'HopeStartDate':
            	if(e.value==""){
            		task.HopeStartDate = null;
            	}else{
	            	var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
	            	if(task.HopeFinishDate && task.HopeFinishDate<value){
	            		task.HopeStartDate = task.HopeFinishDate;
	            		alert('要求开始时间不能大于要求结束时间');
	            	}else{
	            		task.HopeStartDate = value;
	            	}
            	}
            break;
            case 'HopeFinishDate':
            	if(e.value==""){
            		task.HopeFinishDate = null;
            	}else{
	            	if(task.HopeStartDate){
	            		var value = new Date(Date.parse(e.value.replace(/-/g, "/")));
	            		if(value<task.HopeStartDate){
	            			task.HopeFinishDate = task.HopeStartDate;
	            			alert('要求结束时间不能小于要求开始时间');
	            		}else{
	            			task.HopeFinishDate = value;
	            		}
	            	}else
	            		alert('请先填写要求开始时间');
            	}
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
    }
});
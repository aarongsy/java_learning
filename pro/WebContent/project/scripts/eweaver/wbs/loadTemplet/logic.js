GanttSchedule = function(){
    GanttSchedule.superclass.constructor.call(this);
}
GanttSchedule.extend(Edo.core.Component, {
    init: function(project){        
        this.project = project;
        this.istoggle = false;
        project.tree.on('beforetoggle', this.onBeforetoggle, this);
        project.tree.on('cellclick', this.onCellclick, this);
    },
    onBeforetoggle: function(e){
    	this.istoggle = true;
        return true;
    },
    onCellclick: function(e){
    	if(e.columnIndex===1 && !this.istoggle){
            var r = e.record;
            setTreeSelect(r, (r.Checked+1)%2, true);
    	}else{
    		this.istoggle = false;
    	}
    }
});
function setTreeSelect(sels, Checked, deepSelect){
    project.tree.data.beginChange();       
    if(deepSelect){
    	project.tree.data.iterateChildren(sels, function(o){
            this.data.update(o, 'Checked', Checked);
        },project.tree);
    }
    project.tree.data.update(sels, 'Checked', Checked);
    checkParentSelect(sels);
    project.tree.data.endChange();
}

function checkParentSelect(childNode){
	var parentNode = project.tree.data.findParent(childNode);
	if(!parentNode.dataTable){
		parentNode.Checked = 1;
		checkParentSelect(parentNode);
	}
}
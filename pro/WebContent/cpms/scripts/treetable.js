function TreeTable(container){
	this.container=null;
	this.rowIndex=1;
	this.headers=null;
	this.init=function(){
		var table = document.createElement('table');
		table.setAttribute('id','treetable');
		table.setAttribute('border',1);
		var header = table.insertRow(-1);
		header.className='header';
		this.headers = tableconfig.header;
		for(var i=0;i<this.headers.length;i++){
			var headerName = this.headers[i].name;
			var type = this.headers[i].type;
			if(type!='hidden'){
				var width = this.headers[i].width;
				var cell = header.insertCell(-1);
				cell.innerText=headerName;
				cell.style.width=width;
				//cell.setAttribute('width',width);
			}
		}
		$(container).appendChild(table);
		this.container=table;
	}
	this.loadProject=function(project){
		var row = this.container.insertRow(this.rowIndex);
		this.rowIndex++;
		for(var i=0;i<this.headers.length;i++){
			var index = this.headers[i].index;
			var type = this.headers[i].type;
			var value = project[index]?project[index]:'';
			if(type!='hidden'){
				var cell = row.insertCell(-1);
				this.renderProjectCell(value,cell,this.headers[i]);
			}
		}
		this.loadTask(project.tasks);
	}
	//加载任务
	this.loadTask=function(tasks){
		for(var j=0;j<tasks.length;j++){
			var task = tasks[j];
			if(task.rendered){
				var row = $(task.id);
				row.style.display='';
			}else{//没有加载到页面的任务在页面上生成
				var row = this.container.insertRow(this.rowIndex);
				this.rowIndex++;
				row.setAttribute('height','25px');
				row.setAttribute('id',task.id);
				row.onmouseover=function(){this.style.backgroundColor='#ffc';};
				row.onmouseout=function(){this.style.backgroundColor='';};
				for(var i=0;i<this.headers.length;i++){
					var type = this.headers[i].type;
					if(type!='hidden'){
						var cell = row.insertCell(-1);
						this.renderCell(task,cell,this.headers[i]);
					}
				}
				task.rendered=true;
			}
			this.expend(task);
		}
	}
	//渲染单元格数据展示
	this.renderCell=function(task,cell,config){
		var value = task[config.index];
		var render = config.render;
		if(!render){
			render = function(t,v,c){c.innerHTML=v;};
		}
		render(task,value,cell);
	}
	this.renderProjectCell=function(value,cell,config){
		var render = config.projectRender;
		if(!render){
			render = function(p,v,c){c.innerHTML=v;};
		}
		render(project,value,cell);
	}
	this.expend=function(task){
		if(task.hasChild){
			task.collapsed=false;
			var img = $('img_'+task.id);
			img.src='/cpms/images/minus.gif';
			this.loadTask(task.children);
		}
	}
	this.collapse=function(task){
		if(task.hasChild){
			task.collapsed=true;
			var img = $('img_'+task.id);
			img.src='/cpms/images/plus.gif';
			for(var j=0;j<task.children.length;j++){
				var child = task.children[j];
				if(child.rendered){
					var row = $(child.id);
					row.style.display='none';
					this.collapse(child);
				}
			}
		}
	}
	
	this.init();
}

function clickNode(id){
	var task =  project.get(id);
	if(task.collapsed){
		treetable.expend(task);
	}else{
		treetable.collapse(task);
	}
}
function clickProject(){
	var img = $('img_'+project.id);
	if(project.collapsed){
		project.collapsed=false;
		img.src='/cpms/images/plus.gif';
	}else{
		project.collapsed=true;
		img.src='/cpms/images/minus.gif';
	}
	for(var i=0;i<project.tasks.length;i++){
		var task = project.tasks[i];
		var row = $(task.id);
		if(project.collapsed){
			treetable.expend(task);
			row.style.display='';
		}else{
			treetable.collapse(task);
			row.style.display='none';
		}
	}
}
function Project(json){
	this.tasks = new Array();
	this.collapsed=true;
	this.init=function(){
		//加载项目属性(和任务列相同)
		for(var i=0;i<tableconfig.header.length;i++){
			var index = tableconfig.header[i].index;
			if(json[index]){
				this[index]=json[index];
			}
		}
		//加载任务
		if(json&&json.tasks){
			var length = json.tasks.length;
			for(var i=0;i<length;i++){
				var task = new Task(json.tasks[i],length);
				this.tasks.push(task);
			}
		}
	}
	this.get=function(taskId){
		for(var i=0;i<this.tasks.length;i++){
			task = this.tasks[i];
			if(task.id==taskId){
				return task;
			}else{
				var child = task.findChild(taskId);
				if(child){
					return child;
				}
			}
		}
	}
	this.init();
}
function Task(json,brotherSize,parent){
	this.hasChild=false;//是否有子任务
	this.parent=parent;//父节点
	this.level=1;//层级
	this.brotherSize=brotherSize;
	this.collapsed=true;//是否折叠状态
	this.rendered=false;//是否已经绘制到页面
	this.children=new Array();//子任务
	this.init=function(){
		for(var i=0;i<tableconfig.header.length;i++){
			var index = tableconfig.header[i].index;
			this[index]=json[index];//任务属性
		}
		if(parent){this.level=1*1+parent.level;}
		var childrenTasks=json.children;
		if(childrenTasks){
			this.hasChild=true;
			var length = childrenTasks.length;
			for(var j=0;j<childrenTasks.length;j++){
				var task = new Task(childrenTasks[j],length,this);
				this.children.push(task);
			}
		}
	}
	this.findChild=function(taskId){
		if(this.hasChild){
			for(var i=0;i<this.children.length;i++){
				var task =this.children[i];
				if(task.id==taskId){
					return task;
				}else{
					var child = task.findChild(taskId);
					if(child){
						return child;
					}
				}
			}
		}
	}
	this.getStyle=function(){
		if(this.level==1){
			return 'class="weight" ';
		}
		return '';
	}
	this.init();
}
function openProject(projectid,objname){
	var projectInfoTab=parent.contentPanel.getComponent('0');
	parent.contentPanel.setActiveTab(projectInfoTab);
}
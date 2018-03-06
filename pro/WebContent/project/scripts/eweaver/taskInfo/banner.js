 Edo.util.Dom.on(window, 'domload', function(){
	var bar = Edo.create({
	        type: 'box',      
	        padding: [1,1,1,1],
	        border: [0,0,0,0],
	        render: document.getElementById('banner'),
	        children: [
	            {
	                type: 'group',
	                cls: 'e-toolbar',
	                horizontalGap: 0,
	                verticalAlign: 'bottom',
	                layout: 'horizontal',
	                enable: isCanEdit,
	                children: [
	                    {
	                        id: 'refresh',
	                        type: 'button',                        
	                        icon: 'e-icon-refresh',
	                        text: '刷新',
	                        onclick: function(e){                            
	                    		refreshDocList();
								loadNodes('getSelfAndTasks',UID,true,function(data){
									dataProject = new Edo.data.DataGantt(data);
									project.set('data', dataProject);
								});
	                        }
	                    },{
	                        type: 'button',
	                        icon: 'e-icon-save',
	                        text: '保存',
	                        onclick: function(e){
		                    	Edo.MessageBox.saveing('保存', '正在保存项目数据,请稍等...');
						        var json = {
						    		children: project.data.children,
						        	ProjectId: ProjectUID,
						        	ParentTaskId: ParentTaskID,
						        	IsUpdate: '1',
						        	Deleted: []
						        };
						        ProjectService.set({
						        	method: 'setTasks',
						        	tasks: json
						        },function(text){
						            Edo.MessageBox.hide();
						        }, function(msg, code){
						            alert(msg);
						            Edo.MessageBox.hide();
						        });
						        project.data.Deleted=[];
	                        }
	                    }
	                ]
	            }
	        ]
	    }); 
});
GanttMenu = function(){
    GanttMenu.superclass.constructor.call(this);
};   
GanttMenu.extend(Edo.core.Component, {        
    init: function(owner){    
        if(this.owner) return;
        this.owner = owner;
        
        owner.on('contextmenu', this.oncontextmenu, this);        
    },
    destroy: function(){        
        this.owner.un('contextmenu', this.oncontextmenu, this);        
        GanttMenu.superclass.destroy.call(this);
    },
    oncontextmenu: function(e){
        var gantt = this.owner;
        if(gantt.enableMenu === false) return false;
        var ct = gantt;
        if(ct && !ct.within(e)) return;
        e.stopDefault();
        
        var menu = this.getMenu();
        Edo.managers.PopupManager.createPopup({
            target: menu,                                
            x: e.xy[0],
            y: e.xy[1],
            onout: function(e){
                Edo.managers.PopupManager.removePopup(menu);
            }
        });
    },    
    getMenu: function(){
    
    	owner = this.owner;
        var gantt = owner.gantt;
        var tree = owner.tree;
        
        function dateViewClick(e){            
            gantt.set('dateView', this.name);            
        }
        function viewModeClick(e){
            gantt.set('viewMode', this.name);
        }
                        
        if(!this.menu){
            this.menu = Edo.create({
                type: 'menu',
                autoHide: true,
                visible: false,
                width: 120,
                enable: isCanEdit,
                children: [
                    {
                        type: 'button',
                        icon: 'e-icon-new',
                        text: '插入机组/类别',
                        onclick: function(e){
                    		var task = project.tree.getSelected();
                    		if(task){
                    			var p = project.tree.data.findParent(task);
                    			if(p.Model && p.Model>=SELECTID.zhurenwu){
                    				alert('不能在低等级任务下创建高等级任务');
                    				return;
                    			}
                    		}
                    		EdoGantt.showTaskWindow('addSubProject',task);
                        }
                    },{
                        type: 'button',
                        icon: 'e-icon-new',
                        text: '插入任务',
                        onclick: function(e){
                    		var task = project.tree.getSelected();
                    		EdoGantt.showTaskWindow('new',task);
                        }
                    },{
                        type: 'hsplit'
                    },{
                        type: 'button',
                        icon: 'e-icon-gototask',
                        text: GanttMenu.gotoTask,
                        onclick: function(e){
                            var r = gantt.getSelected();
                            if(r){
                            	gantt.scrollIntoTask(r,true);
                            }
                        }
                    },{
                        type: 'button',icon: 'e-icon-upgrade',text: '升级',
                        onclick: function(e){                        
                            var r = project.tree.getSelected();
                            if(r){
                            	if(r.Model==SELECTID.jiedian){
                            		alert('节点不允许升级');
                            	}else{
                            		project.data.beginChange();
                            		if(r.children){
                            			var len=r.children.length;
                            			project.data.upgrade(r);
                            			for(var i=0;i<len;i++){
                            				project.tree.data.insert(0,r.children.pop(), r);
                            			}
                            		}else{
                            			project.data.upgrade(r);
                            		}
	                                project.data.endChange();
                            	}
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'button',icon: 'e-icon-downgrade',text: '降级',
                        onclick: function(e){
                            var r = project.tree.getSelected();
                            if(r){
                            	if(r.Model==SELECTID.jiedian){
                            		alert('节点不允许降级');
                            	}else{
                            		var p = project.tree.data.findParent(r);        
                                    var index = p.children.indexOf(r);
                                    if(index>0){
                                    	var pre =project.tree.data.getChildAt(p,index-1);
                                    	if(r.Model>=pre.Model){
    		                                project.data.downgrade(r);
    		                                project.data.endChange();
                                    	}else{
                                    		alert('任务模式验证错误，不能把高等级任务放在低等级任务之下');
                                    	}
                                    }else{
		                                project.data.downgrade(r);
		                                project.data.endChange();	                                    	
                                    }
                            	}
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'hsplit'
                    },{
                        type: 'button',text: '剪切',
                        onclick: function(e){                        
                            var r = project.tree.getSelected();
                            if(r){
                            	if(r.Model == SELECTID.jiedian){
                            		alert('节点不能被操作');
                            	}else{
	                            	cutBoard.push(r);
	                            	project.tree.data.remove(r);
                            	}
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'button',text: '粘贴',
                        onclick: function(e){
                            var r = project.tree.getSelected();
                            if(r){
                            	var maxNode=null;
                        		for(var i=0;i<cutBoard.length;i++){
                        			maxNode = maxNode?(maxNode.Model<cutBoard[i]?maxNode:cutBoard[i]):cutBoard[i];
                        		}
                        		var p = project.tree.data.findParent(r);
                        		if(maxNode && p.Model && maxNode.Model<p.Model){
                        			alert('任务模式验证错误，不能把高等级任务放在低等级任务之下');
                        		}else{
                        			project.data.move(cutBoard, r, 'append');
                        			cutBoard=[];
                        		}
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'hsplit'
                    },{
                        type: 'button',
                        icon: 'e-icon-edit',
                        text: '修改',
                        onclick: function(e){
                            var task = project.tree.getSelected();
                            if(task){
                            	if(task.Department!=Department){
                            		alert('对于非本事业部门的任务不可以进行修改操作！');
                            		return false;
                            	}
                            	if(task.IsInWorkFlow===1){
                            		alert('对于进入审批流程的任务不可以进行修改操作！');
                            		return false;
                            	}
                            	if(task.Model == SELECTID.jiedian){
                            		alert('节点不可修改');
                            		return false;                        
                            	}
                            	EdoGantt.showTaskWindow('edit', task,dataProject);
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'button',
                        text: '查看',
                        onclick: function(e){
                            var task = project.tree.getSelected();
                            if(task){ 
                            	if(task.Model == SELECTID.jiedian){
                            		alert('节点不可查看');
                            		return;
                            	}
                            	EdoGantt.showTaskWindow('view', task,dataProject);
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    }
                ],
                render: document.body
            });
        }        
        return this.menu;
    }
});

Edo.apply(GanttMenu, {
    gotoTask: '转到任务',
    upgradeTaskText: '升级',
    downgradeTaskText: '降级',
    addTask: '新增任务',
    editTask: '修改任务',
    deleteTask: '删除任务',
    
    trackText: '跟踪',
    progressLine: '进度线',    
    createbaseline: '设置比较基准',
    clearbaseline: '清除比较基准',
    viewAreaText: '视图显示区',
    showTreeAndGantt: '任务树和条形图',
    showTreeOnly: '只显示任务树',
    showGanttOnly: '只显示条形图',
    
    viewText: '视图',
    ganttView: '甘特图',
    trackView: '跟踪甘特图',
    
    selectTask: '请先选择一个任务'
});    
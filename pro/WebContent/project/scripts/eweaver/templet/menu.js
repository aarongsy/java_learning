WBSMenu = function(){
	WBSMenu.superclass.constructor.call(this);
};   
WBSMenu.extend(Edo.core.Component, {        
    init: function(owner){    
        if(this.owner) return;
        this.owner = owner;
        
        owner.on('contextmenu', this.oncontextmenu, this);        
    },
    destroy: function(){        
        this.owner.un('contextmenu', this.oncontextmenu, this);        
        WBSMenu.superclass.destroy.call(this);
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
    
        var gantt = owner = this.owner;
        if(gantt.tree) gantt = gantt.tree;
        
        function dateViewClick(e){            
        	owner.gantt.set('dateView', this.name);            
        }
        function viewModeClick(e){
        	owner.gantt.set('viewMode', this.name);
        }
                        
        if(!this.menu){
            this.menu = Edo.create({
                type: 'menu',
                autoHide: true,
                visible: false,
                width: 120,                
                children: [
                    {
                        type: 'button',
                        icon: 'e-icon-refresh',
                        text: '刷新',
                        name: 'refresh',
                        onclick: function(e){
	                		loadNodes('getTasks','-1',true,
                    				function(data){
                    					dataProject = new Edo.data.DataGantt(data);
                    					dataProject.set('Deleted', []);
                    					project.set('data', dataProject);
                    				}
                    			);
                        }
                    },{
                        type: 'hsplit'
                    },
                    {
                        type: 'button',
                        icon: 'e-icon-add',
                        text: '新增任务',
                        name: 'add',
                        onclick: function(e){
                    		isAdded = true;
                            var task = gantt.getSelected();
                            var p,index;
                            if(task){
                                p = gantt.data.findParent(task);        
                                index = p.children.indexOf(task)+1;
                            }else{
                            	p = null;        
                                index = gantt.data.children.length;
                            }
                        	gantt.data.insert(index, {
                                UID: new Date().getTime(),
                                Name: '',
                                Start: null,
                                Finish: null,
                                PercentComplete: 0,
                                CreateDate: new Date(),
                                parenttaskUID: '-1',
                                TaskNo: "",
                                Checked: 0,
                                Critical: 1,
                                IsTemplet: 1
                            }, p);
                        }
                    },{
                        type: 'button',
                        icon: 'e-icon-delete',                        
                        text: '删除任务',
                        name: 'delete',
                        onclick: function(e){
                            var r = gantt.getSelected();
                            if(r){
                            	project.tree.data.iterateChildren(r, function(o){
                        	    	if(o){
                        	    		project.data.Deleted.push(o.UID);
                        	    	}
                        	    },project.tree);
                            	project.data.Deleted.push(r.UID);
                                gantt.data.remove(r);
                                var parentNode = project.tree.data.findParent(r);
                            	if(parentNode && parentNode.children.length==0){
                            		parentNode.__viewicon = false;
                            	}
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'hsplit'
                    },{
                        type: 'button',icon: 'e-icon-upgrade',text: '升级',
                        onclick: function(e){                        
                            var r = project.tree.getSelected();
                            if(r){
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
                            }else{
                                alert("请先选择一个任务");
                            }
                        }
                    },{
                        type: 'button',icon: 'e-icon-downgrade',text: '降级',
                        onclick: function(e){
                            var r = project.tree.getSelected();
                            if(r){
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
                            	cutBoard.push(r);
                            	project.tree.data.remove(r);
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
                    }                 
                ],
                render: document.body
            });
        }        
        return this.menu;
    }
});   
 Edo.util.Dom.on(window, 'domload', function(){
	var bar = Edo.create({    
	        type: 'box',
	        render: document.getElementById('banner'),
	        children: [
	            {
	                type: 'group',
	                cls: 'e-toolbar',
	                horizontalGap: 0,
	                verticalAlign: 'bottom',
	                layout: 'horizontal',
	                children: [
	                    {
	                        type: 'button',                        
	                        icon: 'e-icon-refresh',
	                        text: '刷新',
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
	                        type: 'button',
	                        icon: 'e-icon-save',
	                        text: '保存',
	                        onclick: function(e){
		                    	if(!validate(project.data.children,2)){
	                    			return false;
	                    		}
	                            Edo.MessageBox.saveing('保存', '正在保存项目数据,请稍等...');
	                            var json = {
	                            	children: project.data.children,
	                            	ProjectId: ProjectUID,
	                            	ParentTaskId: '-1',
	                            	Deleted: project.data.Deleted
	                            };
	                            ProjectService.set({
	                            	method: 'setTasks',
	                                tasks: json
	                            },function(data){
	                                Edo.MessageBox.hide();
	                            	if(isAdded){
	                            		loadNodes('getTasks','-1',true,
	                        				function(data){
	                        					dataProject = new Edo.data.DataGantt(data);
	                        					dataProject.set('Deleted', []);
	                        					project.set('data', dataProject);
	                        				}
	                        			);
	                            	}
	                            }, function(msg, code){
	                                alert(msg);
	                                Edo.MessageBox.hide();
	                            });
	                        }
	                    },{
	                        type: 'split'
	                    },{
	                        type: 'button',
	                        icon: 'e-icon-new',
	                        text: '新增',
	                        onclick: function(e){
		                    	isAdded = true;
		                    	var gantt = project.tree;
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
	                        text: '删除',  
	                        onclick: function (e){
	                            var r = project.tree.getSelected();
	                            if(r){
	                            	project.tree.data.iterateChildren(r, function(o){
	                        	    	if(o){
	                        	    		project.data.Deleted.push(o.UID);
	                        	    	}
	                        	    },project.tree);
	                            	project.data.Deleted.push(r.UID);
	                            	project.tree.data.remove(r);
	                            	var parentNode = project.tree.data.findParent(r);
	                            	if(parentNode && parentNode.children.length==0){
	                            		parentNode.__viewicon = false;
	                            	}
	                            }else{
	                                alert("请先选择一个任务");
	                            }
	                        }
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
	                    },{
	                        type: 'split'
	                    },{
	                        type: 'button',text: '全部展开',
	                        onclick: function(e){
                				for(i=0;i<project.tree.data.children.length;i++){
                					project.tree.data.expand(project.tree.data.children[i],true);
                				}
	                        }
	                    },{
	                        type: 'button',text: '全部收缩',
	                        onclick: function(e){
                				for(i=0;i<project.tree.data.children.length;i++){
                					project.tree.data.collapse (project.tree.data.children[i],true);
                				}
	                        }
	                    }
	                ]
	            }
	        ]
	    });
});
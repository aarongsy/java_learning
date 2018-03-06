 Edo.util.Dom.on(window, 'domload', function(){
	var bar = Edo.create({    
	        type: 'box',
	        render: document.getElementById('banner'),
	        children: [
	            {
	                type: 'group',cls: 'e-toolbar',horizontalGap: 0,verticalAlign: 'bottom',layout: 'horizontal',
	                enable: isCanEdit,
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
	                    				for(i=0;i<project.tree.data.children.length;i++){
	                    					var r=project.tree.data.children[i];
	                    					if(r && r.Model== SELECTID.zhurenwu){
	                    						project.tree.data.collapse(r,true);
	                    					}
	                    					project.tree.data.iterateChildren(r, function(o){
	                    						if(o && o.Model== SELECTID.zhurenwu){
	                    							project.tree.data.collapse(o,true);
	                    						}
	                    					},project.tree.data);
	                    				}
	                    			}
		                    	);
	                        }
	                    },{                        
	                        type: 'button',
	                        icon: 'e-icon-save',
	                        text: '保存',
	                        onclick: function(e){
		                    	if(!validate(project.data.children,1)){
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
	                            },function(text){
	                            	if(isAdded){
	                            		loadNodes('getTasks','-1',true,
	                            				function(data){
	                            					dataProject = new Edo.data.DataGantt(data);
	                            					dataProject.set('Deleted', []);
	                            					project.set('data', dataProject);
	                            					for(i=0;i<project.tree.data.children.length;i++){
	                            						var r=project.tree.data.children[i];
	                            						if(r && r.Model== SELECTID.zhurenwu){
	                            							project.tree.data.collapse(r,true);
	                            						}
	                            						project.tree.data.iterateChildren(r, function(o){
	                            							if(o && o.Model== SELECTID.zhurenwu){
	                            								project.tree.data.collapse(o,true);
	                            							}
	                            						},project.tree.data);
	                            					}
	                            				}
	                            		);
	                            	}
	                                Edo.MessageBox.hide();
	                            }, function(msg, code){
	                                alert(msg);
	                                Edo.MessageBox.hide();
	                            });
	                            project.data.Deleted=[];
	                        }
	                    },{
	                        type: 'split'
	                    },{
	                        type: 'button',text: '视图',arrowMode: 'menu',
	                        menu: {
				                type: 'menu',                
				                minWidth: 120,
				                children:[
	                            {
	                            	type: 'button',text: '甘特图类别',arrowMode:'menu',
									menu:{
						                type: 'menu',  
						                autoHide: true,
						                minWidth: 120,
						                children:[
									      {
			                                type: 'button',text: '进度甘特图',
			                                onclick: function(e){
			                                    project.gantt.set('viewMode', 'gantt');
			                                }
									      },{
				                                type: 'button',text: '跟踪甘特图',
				                                onclick: function(e){
				                                    project.gantt.set('viewMode', 'track');
				                                }
				                            }
                                	]}
	                            },{
	                            	type: 'button',text: '显示内容',arrowMode:'menu',
									menu:{
						                type: 'menu',
						                autoHide: true,
						                minWidth: 120,
						                children:[
										{
										    type: 'button',text: '只显示任务树',
										    onclick: function(e){
										        project.gantt.set('visible', false);    
										        project.tree.set('verticalScrollPolicy', 'auto');
										        project.tree.set('visible', true);
										    }
										},{
										    type: 'button',text: '只显示甘特图',
										    onclick: function(e){
												project.tree.set('visible', false);
										        project.tree.set('verticalScrollPolicy', 'off');
										        project.gantt.set('visible', true);
										    }
										},{
										    type: 'button',text: '显示所有内容',
										    onclick: function(e){
												project.tree.set('visible', true);
												project.tree.set('verticalScrollPolicy', 'off');
												project.tree.set('autoColumns', false);
										        project.gantt.set('visible', true);    
										        
										    }
										}
									]}
		                        }
	                        ]}
	                    },{
	                        type: 'button',id: 'dateviewBtn',text: '周/天',arrowMode: 'menu',
	                        menu: [
	                            {
	                                type: 'button',text: '年/季',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'year-quarter');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text: '年/月',
	                                onclick: function(e){                                
	                                    project.gantt.set('dateView', 'year-month');                                    
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text: '年/周',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'year-week');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text: '年/天',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'year-day');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text:'季/月',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'quarter-month');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text:'季/周',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'quarter-week');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text:'季/天',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'quarter-day');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text: '月/周',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'month-week');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text: '月/天',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'month-day');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            },{
	                                type: 'button',text: '周/天',
	                                onclick: function(e){
	                                    project.gantt.set('dateView', 'week-day');
	                                    dateviewBtn.set('text', '日期 : '+this.text);
	                                }
	                            }
	                        ]
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
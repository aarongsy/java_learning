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
                enable: isCanEdit,
                width: 120,                
                children: [
					{
					    type: 'button',                        
					    icon: 'e-icon-refresh',
					    text: '刷新',
					    onclick: function(e){                            
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
					            alert("更新成功");
					            Edo.MessageBox.hide();
					        }, function(msg, code){
					            alert(msg);
					            Edo.MessageBox.hide();
					        });
					        project.data.Deleted=[];
					    }
					}                    
                ],
                render: document.body
            });
        }        
        return this.menu;
    }
});
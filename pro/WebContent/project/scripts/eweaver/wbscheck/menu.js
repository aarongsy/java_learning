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
                        icon: 'e-icon-gototask',
                        text: '转到任务',
                        onclick: function(e){
                            var r = gantt.getSelected();
                            if(r){
                            	gantt.scrollIntoTask(r,true);
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
EweaverWBS = function(){
	EweaverWBS.superclass.constructor.call(this);
    
    this.data = new Edo.data.DataGantt();
};   
EweaverWBS.extend(Edo.containers.Box, {        
    layout: 'horizontal',        
    
    _setData: function(value){    
        if(value.componentMode != 'data'){
            value = new Edo.data.DataGantt(value);
        }        
        if(this.data){
            this.data.un('datachange', this.onDataChange, this);
        }
        this.data = value;
        if(this.tree){            
            this.tree.set('data', this.data);    
        }
    },
    init: function(owner){   
    	this.border = [0,0,0,0];
    	this.padding = [0,0,0,0];
        this.set('children', [
            {
            	style: 'cursor:pointer;',name: 'tree',type: 'supertree',width: '100%', height: '100%',verticalScrollPolicy: 'auto',
            	collapseProperty: 'width',enableCollapse: true,splitRegion: 'west',enableCellEdit: false,
                treeColumn: 'taskname',
                columns: [
                    {header: '序号',width: 32,align: 'center',enableSort: false,dataIndex: '__index', cls: 'e-table-column-number', style: 'cursor:default;',
                        renderer: function(v, r, c, i, data){
                            return data.source.indexOf(r) + 1;
                        }
                    },
                    {
                        id: 'taskname',header: "任务名称",width: 240,dataIndex: 'Name',
                        renderer: function(v, r){
                        	var result = '<div class="e-tree-checkbox"><div class="e-tree-check-icon  '+(r.Checked == 1 ? 'e-table-checked' : '')+'"></div>'+v+'</div>';
                            if(r.Summary){
                                return '<b>'+result+'</b>';
                            }
                            return result;
                        }
                    },{
                    	id:'PrincipalName1',header: '负责人',width:  60,align: 'center',
                	    dataIndex: 'PrincipalName',
                	 	renderer: function(v, r, column, rowIndex, data, table){
                	         return "";
                	     }
                    },{
                        header: "任务模式",width:  70, dataIndex: 'Model',
                        renderer: function(v, r){   
                            var ds = window.parent.selectProject[SELECTID.model];
                            if(ds){
                                for(var i=0,l=ds.length; i<l; i++){
                                    var d = ds[i];
                                    if(v == d.ID) return d.OBJNAME;
                                }
                            }
                            return v;
                        }
                    },{
                        header: "任务类型",width:  70, dataIndex: 'MasterType',
                        renderer: function(v, r){
                            var ds = window.parent.selectProject[r.Model];
                            if(ds){
                                for(var i=0,l=ds.length; i<l; i++){
                                    var d = ds[i];
                                    if(v == d.ID) return d.OBJNAME;
                                }
                            }
                            return v;
                        }
                    },{
                        header: "风险等级",width:  60, dataIndex: 'RiskLevel',
                        renderer: function(v, r){
                            var ds = selectProject[SELECTID.RiskLevel];
                            if(ds){
                                for(var i=0,l=ds.length; i<l; i++){
                                    var d = ds[i];
                                    if(v == d.ID) return d.OBJNAME;
                                }
                            }
                            return v;
                        }
                    },{
                        header: "重要程度",width:  60, dataIndex: 'Pri',
                        renderer: function(v, r){
                            var ds = window.parent.selectProject[SELECTID.Pri];
                            if(ds){
                                for(var i=0,l=ds.length; i<l; i++){
                                    var d = ds[i];
                                    if(v == d.ID) return d.OBJNAME;
                                }
                            }
                            return v;
                        }
                    },{
                    	header:'任务描述',width: 150,align:'center',dataIndex:'Description'
                    },{
                    	header:'任务要求',width: 150,align:'center',dataIndex:'Require'
                    }
                 ]
            }
        ]);
        EweaverWBS.superclass.init.call(this);
        
        var tree = Edo.getByName('tree', this)[0];
        this.tree = tree;
        
        tree.set('data', this.data);
    }
});
EweaverWBS.regType('eweaverwbs');



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
      //如果已经生成UI
        if(this.tree){            
            this.tree.set('data', this.data);    
        }  
        this.data.on('datachange', this.onDataChange, this);
    },
    onDataChange: function(e){     
    },
    init: function(owner){   
    	this.border = [0,0,0,0];
    	this.padding = [0,0,0,0];
        this.set('children', [
            {
            	style: 'cursor:pointer;',name: 'tree',type: 'supertree',width: '100%', height: '100%',verticalScrollPolicy: 'auto',
            	collapseProperty: 'width',enableCollapse: true,splitRegion: 'west',cellEditAction: 'celldblclick',enableCellEdit: isCanEdit,
                treeColumn: 'taskname',
                columns: [                    
                      {
                        header: HeaderValue,width: '100%',headerAlign:'left',
                        columns: [
                            {header: '序号',width: 32,align: 'center',enableSort: false,dataIndex: '__index', cls: 'e-table-column-number', style: 'cursor:default;',
                                renderer: function(v, r, c, i, data){
                                    return data.source.indexOf(r) + 1;
                                }
                            },{
                        	    header: '任务编号',width:  130,dataIndex: 'TaskNo',
                        	 	renderer: function(v, r){
                                    return v;
                                }                         	    	
                        	},{
                                id: 'taskname',header: "任务名称",width: 160,align: 'center',dataIndex: 'Name',
                                renderer: function(v, r){
                                    if(r.Model!=SELECTID.jiedian){
                                    	var ds = selectProject[SELECTID.Status];
                                        if(ds){
                                            for(var i=0,l=ds.length; i<l; i++){
                                                var d = ds[i];
                                                if(r.Status == d.ID) return "<div style='color:"+d.OBJDESC+"'><b>"+v+"</b></div>";
                                            }
                                        }
                                    }
                                    return v;
                                }
                            },{
                        	    header: '实施部门',width:  60,dataIndex: 'OfficeName',
                        	 	renderer: function(v, r){
                                    return v;
                                }                         	    	
                        	},{
                            	header: '负责人',width:  50,align: 'center',dataIndex: 'PrincipalName',
                        	 	renderer: function(v, r, column, rowIndex, data, table){
                        	         return v;
                        	     }
                            },{
                        	    header: '风险等级',width:  55,dataIndex: 'RiskLevel',
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
                        	    header: '重要程度',width:  55,dataIndex: 'Pri',
                        	 	renderer: function(v, r){
	                        		var ds = selectProject[SELECTID.Pri];
	                                if(ds){
	                                    for(var i=0,l=ds.length; i<l; i++){
	                                        var d = ds[i];
	                                        if(v == d.ID) return d.OBJNAME;
	                                    }
	                                }
	                                return v;
                                }                         	    	
                        	}
//                        	,{
//                                header: "任务模式", dataIndex: 'Model',
//                                renderer: function(v, r){   
//                                    var ds = selectProject[SELECTID.model];
//                                    if(ds){
//                                        for(var i=0,l=ds.length; i<l; i++){
//                                            var d = ds[i];
//                                            if(v == d.ID) return d.OBJNAME;
//                                        }
//                                    }
//                                    return v;
//                                }
//                            }
                        	,{
                                header: "任务类型", dataIndex: 'MasterType',
                                renderer: function(v, r){
                                    var ds = selectProject[r.Model];
                                    if(ds){
                                        for(var i=0,l=ds.length; i<l; i++){
                                            var d = ds[i];
                                            if(v == d.ID) return d.OBJNAME;
                                        }
                                    }
                                    return v;
                                }
                            },{   
                                header: '预计开始',width:72,dataIndex: 'Start',
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },{
                                header: '预计完成',width:72,dataIndex: 'Finish',
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },{   
                                header: '实际开始',width:72,dataIndex: 'IndentStartDate',
                                editor: {
	                            	id: 'IndentStartDate1',type: 'text',readOnly: true,
	                    			onFocus:function(){
		                            	var date =project.tree.getSelected().IndentStartDate;
		                				if(date)
		                					document.getElementById('IndentStartDate1').childNodes[0].value=date.format('Y-m-d');
	                    				WdatePicker({
	                    					onpicked:function(){
	                    						IndentStartDate1.text=$dp.cal.getDateStr();
	                    					},
		                					oncleared:function(){
	                    						IndentStartDate1.text="";
		                					}
	                    				});
	                    			}
                                },
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },{
                                header: '实际完成',width:72,dataIndex: 'IndentFinishDate',
                                editor: {
                            		id: 'IndentFinishDate1',type: 'text',readOnly: true,
	                    			onFocus:function(){
		                            	var date =project.tree.getSelected().IndentFinishDate;
		                				if(date)
		                					document.getElementById('IndentFinishDate1').childNodes[0].value=date.format('Y-m-d');	
	                    				WdatePicker({
	                    					onpicked:function(){
	                    						IndentFinishDate1.text=$dp.cal.getDateStr();
	                    					},
		                					oncleared:function(){
	                    						IndentFinishDate1.text="";
		                					}
	                    				});
	                    			}
                                },
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },{
                        	    header: '任务状态',width:  60,dataIndex: 'Status',
                        	 	renderer: function(v, r){
                                    var ds = selectProject[SELECTID.Status];
                                    if(ds){
                                        for(var i=0,l=ds.length; i<l; i++){
                                            var d = ds[i];
                                            if(v == d.ID) return d.OBJNAME;
                                        }
                                    }
                                    return v;
                                }                         	    	
                        	},{
                                id: 'ReceiveDate1',header: '下达日期',dataIndex: 'ReceiveDate',
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },{
                        	    header: '所属专业',width:  70,dataIndex: 'Subject',
                        	 	renderer: function(v, r){
	                        		var ds = selectProject[SELECTID.subject];
	                                if(ds){
	                                    for(var i=0,l=ds.length; i<l; i++){
	                                        var d = ds[i];
	                                        if(v == d.ID) return d.OBJNAME;
	                                    }
	                                }
	                                return v;
                                }                         	    	
                        	},{
                            	header:'任务描述',width: 200,align:'center',dataIndex:'Description'
                            },{
                            	header:'任务要求',width: 200,align:'center',dataIndex:'Require'
                            }
                         ]
                     }
                ],
                onselectionchange: function(e){
                },
                onscroll: function(e){
                }
            }
        ]);
        EweaverWBS.superclass.init.call(this);
        var tree = Edo.getByName('tree', this)[0];
        this.tree = tree;
        tree.set('data', this.data);
    }
});
EweaverWBS.regType('eweaverwbs');



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
        this.data.on('datachange', this.onDataChange, this);
    },
    onDataChange: function(e){     
    },
    init: function(owner){            
    
        this.set('children', [
            {
            	style: 'cursor:pointer;',name: 'tree',type: 'supertree',width: '100%', height: '100%',verticalScrollPolicy: 'auto',
            	collapseProperty: 'width',enableCollapse: true,splitRegion: 'west',//cellEditAction: 'celldblclick',
                treeColumn: 'taskname',
                columns: [
                    {header: '序号',width: 32,align: 'center',enableSort: false,dataIndex: '__index', cls: 'e-table-column-number', style: 'cursor:default;',
                        renderer: function(v, r, c, i, data){
                            return data.source.indexOf(r) + 1;
                        }
                    },{
                        id: 'taskname',header: "任务名称",width: 210,align: 'center',dataIndex: 'Name',
                        editor: {
                            type: 'text'
                        },
                        renderer: function(v, r){
                        	if(r.Summary){
                                return '<b>'+v+'</b>';
                            }
                            return v;
                        }
                    },{
                	    header: '实施部门',width:  70,dataIndex: 'OfficeName',
                	    editor: { 
                         	type: 'search',readOnly: true,
                         	onclick:function(type,source){
                        		getBaseInfo(REQUESTID.department,
                        			function(data){
                            			var r = project.tree.getSelected();
                            			r.Office=data[0];
                            			r.OfficeName=data[1];
                        			}
                        		);
                     		}
                	 	},
                	 	renderer: function(v, r, column, rowIndex, data, table){
                	 		return v;
                	     }
                 	    	
                	},{
                    	id:'PrincipalName1',header: '负责人',width:  70,align: 'center',
                	    dataIndex: 'PrincipalName',
                	    editor: {
                         	id: 'editBox', 
                         	type: 'search',
                         	readOnly: true,
                         	onclick:function(type,source){
                    			getBaseInfo(REQUESTID.people,function(data){
                    				var r = project.tree.getSelected();
                        			r.Principal=data[0];
                        			r.PrincipalName=data[1];
                        			if(r.Model != SELECTID.zixiangmu){
                        			    for(var i=0;i<selectProject[SELECTID.Status].length;i++){
                        			    	if(selectProject[SELECTID.Status][i].OBJNAME == "进行中"){
                        			    		r.Status = selectProject[SELECTID.Status][i].ID;
                        			    		break;
                        			    	}
                        			    }
                        			}
                        			getOffice(r.Principal,function(data){
                        				r.Office=data[0];
                            			r.OfficeName=data[1];
                        			});
                        			getSubject(r.Principal,function(data){
                        				r.Subject=data.trim();
                        			});
                        			r.ReceiveDate=new Date();
                    			});
                     		}
                	 	},
                	 	renderer: function(v, r, column, rowIndex, data, table){
                	         return v;
                	     }
                    },{
                        header: "专业",width:  60, dataIndex: 'Subject',
                        editor: {
                            id: 'Subject1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID',
                            onselectionchange: function(e){
                    			if(project.tree.getSelected()){
                    				project.tree.getSelected().Subject = this.getValue();
                    			}
                    		}
                        },
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
                        header: "任务模式",width:  80, dataIndex: 'Model',
                        editor: {
                            id: 'model1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID',
                            onselectionchange: function(e){
                    			var r = project.tree.getSelected();
                    			if(r && this.getValue() != r.Model){
                    				var p = project.tree.data.findParent(r);
                                	if(p && this.getValue()<p.Model){
                                		alert('任务模式验证错误，不能把高等级任务放在低等级任务之下');
                                		return false;
                                	}
                    				project.data.beginChange(); 
                    				r.Model = this.getValue();
                    				r.MasterType = null;
                    				project.data.endChange(); 
                    				if(model1.getValue() && !selectProject[model1.getValue()]){
                                		//增加任务类型下拉框
                                		loadSubNodes({
                                			masterType: SELECTID.model,
                                			pid: this.getValue(),
                                	    	method: 'getSelectOperation'
                                	    	},
                                				function(data){
                                					data.unshift({ID:null,OBJNAME:''});
                                					selectProject[model1.getValue()] = data;
                                					MasterType1.set('data', selectProject[model1.getValue()]);
                                				}
                                		);
                            		}else if(model1.getValue() && selectProject[model1.getValue()]){
                            			var sdadsa = model1.getValue();
                            			MasterType1.set('data', selectProject[model1.getValue()]);
                            		}
                    			}
                    		}
                        },
                        renderer: function(v, r){   
                            var ds = selectProject[SELECTID.model];
                            if(ds){
                                for(var i=0,l=ds.length; i<l; i++){
                                    var d = ds[i];
                                    if(v == d.ID) return d.OBJNAME;
                                }
                            }
                            return v;
                        }
                    },{
                        header: "任务类型",width:  80, dataIndex: 'MasterType',
                        editor: {
                            id: 'MasterType1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID',
                            onselectionchange: function(e){
                				var selectNode=project.tree.getSelected();
                    			if(selectNode && selectNode.MasterType != this.getValue()
                    					&& (this.getValue()+"")!='undefined'){
                    				selectNode.MasterType = this.getValue();
                    				project.data.endChange();
                    			}
                    		}
                        },
                        renderer: function(v, r){
                        	if(r.Model && !selectProject[r.Model]){
                        		loadSubNodes({
                        			masterType: SELECTID.model,
                        			pid: r.Model,
                        	    	method: 'getSelectOperation'
                        	    	},
                        				function(data){
                        	    			project.tree.data.beginChange();
                        					data.unshift({ID:null,OBJNAME:''});
                        					selectProject[r.Model] = data;
                        					project.tree.data.endChange();
                        				}
                        		);
                        	}
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
                        header: "风险等级",width:  60, dataIndex: 'RiskLevel',
                        editor: {
                            id: 'RiskLevel1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID'
                        },
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
                        editor: {
                            id: 'Pri1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID'
                        },
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
                    },
                    Edo.lists.Table.createCheckColumn({
                        id:'Checked1',header: '是否有效',width:60,trueValue: '1', falseValue: '0', dataIndex: 'Checked',
                        onclick: function(type,source,checked){
                        	var r = project.tree.getSelected();
                            if(r){
                                setTreeSelect(r, (r.Checked+1)%2, true);
                            }
                    	}
                    }),{
                    	id:'Description1',header:'任务描述',width: 170,align:'center',
                    	dataIndex:'Description',
                    	editor:{
                    		type:'text'
                    	}
                    },{
                    	id:'Require1',header:'任务要求',width: 170,align:'center',
                    	dataIndex:'Require',
                    	editor:{
                    		type:'text'
                    	}
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



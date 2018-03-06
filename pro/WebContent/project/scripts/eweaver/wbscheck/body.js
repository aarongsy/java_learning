EdoGantt = function(){
    EdoGantt.superclass.constructor.call(this);
    
    this.data = new Edo.data.DataGantt();
};   
EdoGantt.extend(Edo.containers.Box, {        
    layout: 'horizontal',        
    padding: [0,0,0,0],
    border: [0,0,0,0],
    _setData: function(value){    
        if(value.componentMode != 'data'){
            value = new Edo.data.DataGantt(value);
        }        
        if(this.data){
            this.data.un('datachange', this.onDataChange, this);
        }
        this.data = value;
        
        if(this.gantt){            
            this.tree.set('data', this.data);
            this.gantt.set('data', this.data);     
            this.syncGanttDateViewRgion();      
        }        
        this.data.on('datachange', this.onDataChange, this);
    },
    onDataChange: function(e){
        this.syncGanttDateViewRgion();      
    },
    init: function(owner){            
    
        this.set('children', [        
            {
                name: 'tree',type: 'supertree',width: '100%', height: '100%',verticalScrollPolicy: 'off',collapseProperty: 'width',enableCollapse: true,splitRegion: 'west',
                treeColumn: 'taskname',enableCellEdit: isCanEdit,
                columns: [                    
                    {
                        header: "合同编号："+ProjectNo+"&nbsp;&nbsp;&nbsp;&nbsp;合同名称："+ProjectName,headerAlign:'left',
                        columns: [
                            {header: '序号',width: 32,align: 'center',enableSort: false,dataIndex: '__index', cls: 'e-table-column-number', style: 'cursor:default;',
                                renderer: function(v, r, c, i, data){
                                    return data.source.indexOf(r) + 1;
                                }
                            },{
                        	    header: '任务编号',width:  140,dataIndex: 'TaskNo',
                        	 	renderer: function(v, r){
                                    return v;
                                }                         	    	
                        	},{
                                id: 'taskname',header: '任务名称',width: 350, dataIndex: 'Name',
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
                        	    header: '业务部门',width:  70,dataIndex: 'DepartmentName',
                        	 	renderer: function(v, r){
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
                        	    header: '负责人',width:  50,
                        	    dataIndex: 'PrincipalName',
                        	    editor: { 
	                             	type: 'search',readOnly: true,
	                             	onclick:function(type,source){
	                            		getBaseInfo(REQUESTID.people,
	                            			function(data){
		                            			var r = project.tree.getSelected();
		                            			r.Principal=data[0];
		                            			r.PrincipalName=data[1];
		                            			if(r.Model != SELECTID.zixiangmu){
//		                            			    for(var i=0;i<selectProject[SELECTID.Status].length;i++){
//		                            			    	if(selectProject[SELECTID.Status][i].OBJNAME == "进行中"){
//		                            			    		r.Status = selectProject[SELECTID.Status][i].ID;
//		                            			    		break;
//		                            			    	}
//		                            			    }
		                            				if(data[0]=="")
		                            					r.Status = '2c91a0302aa21947012aa232f186000f';
		                            				else
		                            					r.Status = '2c91a0302aa21947012aa232f1860010';
		                            			}
		                            			getOffice(r.Principal,function(data){
		                            				r.Office=data[0];
			                            			r.OfficeName=data[1];
		                            			});
		                            			getSubject(r.Principal,function(data){
		                            				r.Subject=data.trim();
		                            			});
		                            			r.ReceiveDate=new Date();
	                            			}
	                            		);
	                         		}
                        	 	},
                        	 	renderer: function(v, r, column, rowIndex, data, table){
                        	 		return v;
                        	     }
                         	    	
                        	},{   
                                header: '预计开始',dataIndex: 'Start',width:  70,
                                editor: {
	                        		id: 'Start1',type: 'text',readOnly: true,
	                    			onFocus:function(){
		                				var date =project.tree.getSelected().Start;
		                				if(date)
		                					document.getElementById('Start1').childNodes[0].value=date.format('Y-m-d');
	                    				WdatePicker({
	                    					onpicked:function(){
	                    						Start1.text=$dp.cal.getDateStr();
	                    					},
		                					oncleared:function(){
	                    						Start1.text="";
		                					}
	                    				});
	                    			}
                                },
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },
                            {
                                header: '预计完成',dataIndex: 'Finish',width:  70,
                                editor: {
	                        		id: 'Finish1',type: 'text',readOnly: true,
	                                onFocus:function(){
		                				var date =project.tree.getSelected().Finish;
		                				if(date)
		                					document.getElementById('Finish1').childNodes[0].value=date.format('Y-m-d');
		                            	WdatePicker({
		                					onpicked:function(){
		                            			Finish1.text=$dp.cal.getDateStr();
		                					},
		                					oncleared:function(){
		                						Finish1.text="";
		                					}
		                				});
	                        		}
                                },
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },{   
                                header: '实际开始',dataIndex: 'IndentStartDate',width:  70,
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
                            },
                            {
                                header: '实际完成',dataIndex: 'IndentFinishDate',width:  70,
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
                                header: '下达日期',dataIndex: 'ReceiveDate',width:  70,
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
                                header: "任务模式", dataIndex: 'Model',cls:'e-table-hover',width:  60,
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
                                header: "任务类型", dataIndex: 'MasterType',width:  60,
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
                                header: "专业",width:  60, dataIndex: 'Subject',
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
                                    var ds = selectProject[SELECTID.Pri];
                                    if(ds){
                                        for(var i=0,l=ds.length; i<l; i++){
                                            var d = ds[i];
                                            if(v == d.ID) return d.OBJNAME;
                                        }
                                    }
                                    return v;
                                }
                            },{
                                header: "任务要求",width:  80, dataIndex: 'Require',
                                renderer: function(v, r){
                                    return v;
                                }
                            },{   
                                header: '要求开始',dataIndex: 'HopeStartDate',width:  70,
                                editor: {
	                        		id: 'HopeStartDate1',type: 'text',readOnly: true,
	                                onFocus:function(){
			            				var date =project.tree.getSelected().HopeStartDate;
			            				if(date)
			            					document.getElementById('HopeStartDate1').childNodes[0].value=date.format('Y-m-d');
		                            	WdatePicker({
		                					onpicked:function(){
		                            			HopeStartDate1.text=$dp.cal.getDateStr();
		                					},
		                					oncleared:function(){
		                						HopeStartDate1.text="";
		                					}
		                				});
	                        		}
                                },
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            },
                            {
                                header: '要求完成',dataIndex: 'HopeFinishDate',width:  70,
                                editor: {
	                        		id: 'HopeFinishDate1',type: 'text',readOnly: true,
	                                onFocus:function(){
			            				var date =project.tree.getSelected().HopeFinishDate;
			            				if(date)
			            					document.getElementById('HopeFinishDate1').childNodes[0].value=date.format('Y-m-d');
		                            	WdatePicker({
		                					onpicked:function(){
		                            			HopeFinishDate1.text=$dp.cal.getDateStr();
		                					},
		                					oncleared:function(){
		                						HopeFinishDate1.text="";
		                					}
		                				});
	                        		}
                                },
                                renderer: function(v){
                                    if(Edo.isDate(v)) return v.format('Y-m-d');
                                    return '';
                                }
                            }
                        ]
                    }
                ],
                onselectionchange: function(e){
                    var rs = this.getSelecteds();
                    
                    if(!rs.equals(gantt.getSelecteds())){                                        
                        gantt.selectRange(rs, false);
                    }
                },
                onscroll: function(e){                                                         
                    if(this.direction == 'vertical') {
                        gantt.set('scrollTop', e.scrollTop);
                        if(!gantt.autoScrollView) gantt.refresh();
                    }
                }
            },
            {
                name: 'gantt',type: 'gantt',width: '100%',height: '100%',elCls:'e-supergrid e-table e-dataview e-div',            
                scrollTipVisible: true,
                taskNameVisible: true,
                taskLineVisible: true,                          
                onselectionchange: function(e){
                    var rs = this.getSelecteds();
                    if(!rs.equals(tree.getSelecteds())){                                                                   
                        tree.selectRange(rs, false);
                    }
                },
                onscroll: function(e){
                    if(this.autoScrollView){
                        if(this.direction == 'vertical') tree.set('scrollTop', e.scrollTop);                
                    }
                },
                onscrollComplete: function(e){
                    if(!this.autoScrollView && this.direction == 'vertical'){
                        this.refresh();
                        tree.set('scrollTop', this.scrollTop);
                    }
                }
            }
        ]);
        EdoGantt.superclass.init.call(this);
        
        var tree = Edo.getByName('tree', this)[0];
        var gantt = Edo.getByName('gantt', this)[0];
        this.tree = tree;
        this.gantt = gantt;
        
        tree.set('data', this.data);
        gantt.set('data', this.data);
        
        this.syncGanttDateViewRgion();
    },
    syncGanttDateViewRgion: function(){
        if(!this.gantt) return;
        var dateRegion = this.getDateRegion();
        dateRegion[0] = dateRegion[0].add(Date.DAY,-3);
        dateRegion[1] = dateRegion[1].add(Date.DAY,13);
        this.gantt.set({
            startDate: dateRegion[0],
            finishDate: dateRegion[1]
        });
    },
    getDateRegion: function(){
        var start = finish = null;  
        
        var view = this.data.source;
        for(var i=0,l=view.length; i<l; i++){
            var t = view[i];
            if((t.Start && t.Start < start) || !start) start = t.Start;
            if((t.Finish && t.Finish > finish) || !finish) finish = t.Finish;
        }  
        if(!start){
            start = new Date();
            finish = new Date();
        }
        //start = start.add(Date.DAY, -3);
        return [start, finish];
    }
});
EdoGantt.regType('edogantt');
    
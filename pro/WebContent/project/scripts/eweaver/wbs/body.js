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
        
        //如果已经生成UI
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
                name: 'tree',type: 'supertree',width: '100%', height: '100%',verticalScrollPolicy: 'auto',collapseProperty: 'width',enableCollapse: true,splitRegion: 'west',
                treeColumn: 'taskname',enableCellEdit: isCanEdit,//,cls: 'e-table-sliver'
                columns: [                    
                    {
                        header: "合同编号："+ProjectNo+"&nbsp;&nbsp;&nbsp;&nbsp;合同名称："+ProjectName,headerAlign:'left',
                        columns: [
                            {header: '序号',width: 32,align: 'center',enableSort: false,dataIndex: '__index', cls: 'e-table-column-number', style: 'cursor:default;',
                                renderer: function(v, r, c, i, data){
                                    return data.source.indexOf(r) + 1;
                                }
                            },{
                            	header: '删除',width:32,
                        	 	renderer: function(v, r, column, rowIndex, data, table){
                        	 		return "<div align='center'><img src='/images/silk/delete1.gif'></div>";
                        	     }
                         	    	
                        	},{
                                id: 'taskname',header: '任务名称',width: 350, dataIndex: 'Name',
                                editor: {
                                    type: 'text'
                                },
                                renderer: function(v, r){
                                    if(r.Model!=SELECTID.jiedian){
                                    	var ds = selectProject[SELECTID.Status];
                                        if(ds){
                                            for(var i=0,l=ds.length; i<l; i++){
                                                var d = ds[i];
                                                if(r.Status == d.ID) return "<div style='color:"+d.OBJDESC+"'><b>"+v+"</b></div>";
                                            }
                                        }
                                        return "<b>"+v+"</b>";
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
                        	    header: '负责人',width:  50,dataIndex: 'PrincipalName',
                        	    editor: { 
	                             	type: 'search',readOnly: true,
	                             	onclick:function(type,source){
	                            		getBaseInfo(REQUESTID.people,
	                            			function(data){
	                            				var r = project.tree.getSelected();
		                            			r.Principal=data[0];
		                            			r.PrincipalName=data[1];
		                            			if(r.Model != SELECTID.zixiangmu){
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
                                header: '预计开始',dataIndex: 'Start',
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
                                header: '预计完成',dataIndex: 'Finish',
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
                                header: "任务模式", dataIndex: 'Model',cls:'e-table-hover',
                                renderer: function(v, r){   
                                    var ds = selectProject[SELECTID.model];
                                    if(ds){
                                        for(var i=0,l=ds.length; i<l; i++){
                                            var d = ds[i];
                                            if(v == d.ID){
                                            	if(v!=SELECTID.jiedian){
                                            		return '<B>'+d.OBJNAME+'</B>';
                                            	}else{
                                            		return d.OBJNAME;
                                            	}
                                            }
                                        }
                                    }
                                    return v;
                                }
                            },{
                                header: "任务类型", dataIndex: 'MasterType',
                                editor: {
                                    id: 'MasterType1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID',
                                    onselectionchange: function(e){
                            			var selectNode=project.tree.getSelected();
                            			if(selectNode && selectNode.MasterType != this.getValue()
                            					&& (this.getValue()+"")!='undefined'){
                            				selectNode.MasterType = this.getValue();
                                    		checkSubNodes(project.tree.getSelected(),this.getValue());
                            			}
                            		}
                                },
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
                                header: "重要程度",width:  60, dataIndex: 'Pri',
                                editor: {
                                    id: 'Pri1', type: 'combo', displayField: 'OBJNAME', valueField: 'ID',
                                    onselectionchange: function(e){
                            			if(project.tree.getSelected()){
                            				project.tree.getSelected().Pri = this.getValue();
                            			}
                            		}
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
                        	    header: '任务状态',width:  60,dataIndex: 'Status',
                        	 	renderer: function(v, r){
                                    var ds = selectProject[SELECTID.Status];
                                    if(ds){
                                        for(var i=0,l=ds.length; i<l; i++){
                                            var d = ds[i];
                                            if(v == d.ID) //return "<div style='color:"+d.OBJDESC+"'>"+d.OBJNAME+"</div>";
                                            	return d.OBJNAME;
                                        }
                                    }
                                    return v;
                                }                         	    	
                        	},{
                        	    header: '任务编号',width:  140,dataIndex: 'TaskNo',
                        	 	renderer: function(v, r){
                                    return v;
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
                    if(gantt.visible && this.direction == 'vertical') {
                        gantt.set('scrollTop', e.scrollTop);
                        if(!gantt.autoScrollView) gantt.refresh();
                    }
                }
            },
            {
                name: 'gantt',type: 'gantt',width: '100%',height: '100%',elCls:'e-supergrid e-table e-dataview e-div',        
                visible: false,
                scrollTipVisible: false,
                taskNameVisible: true,
                taskLineVisible: true,
                enableDragDrop: false,
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
        if(dateRegion[0])dateRegion[0] = dateRegion[0].add(Date.DAY,-3);
        if(dateRegion[1])dateRegion[1] = dateRegion[1].add(Date.DAY,13);
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
        return [start, finish];
    }
});
EdoGantt.regType('edogantt');
    
GraphEditor={};
mxGraph.prototype.click=function(b,a){
	grid.stopEditing();
	if(b.button==1){
		Ext.menu.MenuMgr.hideAll()
	}
	this.dispatchEvent("click",this,b,a);
	if(a!=null){
		if(a.vertex&&a.vertex==1){
			loadStore("node",a.id)
		}
		else{
			loadStore("export",a.id)
		}
	}
	if(this.isEnabled()&&!mxEvent.isConsumed(b)){
		if(a!=null){
			this.selectCellForEvent(a,b)
		}
		else{
			var c=null;
			if(this.swimlaneSelectionEnabled){
				var d=mxUtils.convertPoint(this.container,b.clientX,b.clientY);
				c=this.getSwimlaneAt(d.x,d.y)
			}
			if(c!=null){
				this.selectCellForEvent(c,b)
			}
			else{
				if(!mxEvent.isToggleEvent(b)){
					this.clearSelection()
				}
			}
		}
	}
};
mxGraph.prototype.labelChanged=function(a,d,c){
	var b=this.model.getValue(a);
	this.dispatchEvent("beforeLabelChanged",this,a,b,d,c);
	this.model.beginUpdate();
	try{
		this.model.setValue(a,d);
		if(a.edge==1){
			record=grid.store.query("realname","linkname").get(0)
		}
		else{
			record=grid.store.query("realname","objname").get(0)
		}
		if(record){
			record.beginEdit();
			record.set("value",d);
			record.endEdit()
		}
		if(this.isUpdateSize(a)){
			this.updateSize(a)
		}
		this.dispatchEvent("labelChanged",this,a,b,d,c)
	}
	finally{
		this.model.endUpdate()
	}
	this.dispatchEvent("afterLabelChanged",this,a,b,d,c)
};
nodetypestore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["1","开始节点"],["2","活动节点"],["3","子过程活动节点"],["4","结束节点"]]
});
joinstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["1","同步聚合"],["2","异或聚合"]]
});
splitstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["1","并行"],["2","异或"]]
});
remindstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["","流程提醒"],["4028819d0e521bf9010e5238bec2000c","不提醒"],["4028819d0e521bf9010e5238bec2000e","强制提醒"]]
});
timeoutstartstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["0","提交时间"],["1","接收时间"],["2","指定时间"]]
});
timeoutunitstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["1","小时"],["2","天"],["3","周"],["4","月"],["5","季度"]]
});
timeouttypestore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["0","常量"],["1","变量"]]
});
timeoutoptstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["0","忽略"],["1","自动执行"],["2","重定向"]]
});
ynstore=new Ext.data.SimpleStore({
	id:0,fields:["value","text"],data:[["0","否"],["1","是"]]
});
function dataRender(e,a,b,f,c){
	if((b.get("name")=="id"||b.get("name")=="节点名称")){
		return e
	}
	else{
		if(b.get("name")=="前驱转移关系"){
			var d=joinstore.getById(e);
			if(typeof(d)=="undefined"){
				return"未定义"
			}
			else{
				return d.get("text")
			}
		}
		else{
			if(b.get("name")=="后驱转移关系"){
				var d=splitstore.getById(e);
				if(typeof(d)=="undefined"){
					return"未定义"
				}
				else{
					return d.get("text")
				}
			}
			else{
				if(b.get("name")=="提醒类型"){
					var d=remindstore.getById(e);
					if(typeof(d)=="undefined"){
						return"流程提醒"
					}
					else{
						return d.get("text")
					}
				}
				else{
					if(b.get("name")=="退回节点"||b.get("name")=="重定向节点"){
						var d=nodestore.getById(e);
						if(typeof(d)=="undefined"){
							return"未定义"
						}
						else{
							return d.get("text")
						}
					}
					else{
						if(b.get("name")=="节点类型"){
							var d=nodetypestore.getById(e);
							if(typeof(d)=="undefined"){
								return"未定义"
							}
							else{
								return d.get("text")
							}
						}
						else{
							if(b.get("name")=="超时起始时间"){
								var d=timeoutstartstore.getById(e);
								if(typeof(d)=="undefined"){
									return"未定义"
								}
								else{
									return d.get("text")
								}
							}
							else{
								if(b.get("name")=="时间单位"){
									var d=timeoutunitstore.getById(e);
									if(typeof(d)=="undefined"){
										return"未定义"
									}
									else{
										return d.get("text")
									}
								}
								else{
									if(b.get("name")=="超时时间类型"){
										var d=timeouttypestore.getById(e);
										if(typeof(d)=="undefined"){
											return"未定义"
										}
										else{
											return d.get("text")
										}
									}
									else{
										if(b.get("name")=="超时操作"){
											var d=timeoutoptstore.getById(e);
											if(typeof(d)=="undefined"){
												return"未定义"
											}
											else{
												return d.get("text")
											}
										}
										else{
											if(b.get("name")=="Word模板"){
												var d=wordmoduleidstore.getById(e);
												if(typeof(d)=="undefined"){
													return"未定义"
												}
												else{
													return d.get("text")
												}
											}
											else{
												if(b.get("name")=="流转文档分类"){
													var d=worddocurlstore.getById(e);
													if(typeof(d)=="undefined"){
														return"未定义"
													}
													else{
														return d.get("text")
													}
												}
												else{
													if(b.get("name")=="超时变量"||b.get("name")=="Word模板字段"||b.get("name")=="流转文档名称"||b.get("name")=="套红模板字段"||b.get("name")=="Word套红模板字段"){
														var d=fieldstore.getById(e);
														if(typeof(d)=="undefined"){
															return"未定义"
														}
														else{
															return d.get("text")
														}
													}
													else{
														if(b.get("name")=="是否邮件提醒"||b.get("name")=="是否短消息提醒"||b.get("name")=="是否弹出式提醒"||b.get("name")=="是否rtx提醒"||b.get("name")=="是否会签"||b.get("name")=="是否允许退回"||b.get("name")=="是否自动流转"||b.get("name")=="是否提交前确认"||b.get("name")=="是否超时"||b.get("name")=="是否要盖章"||b.get("name")=="是否提交并反馈"||b.get("name")=="是否要生成公文"||b.get("name")=="是否允许打印"||b.get("name")=="公文可编辑"||b.get("name")=="是否保留痕迹"){
															var d=ynstore.getById(e);
															if(typeof(d)=="undefined"){
																return"未定义"
															}
															else{
																return d.get("text")
															}
														}
														else{
															return e
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
cm=new Ext.grid.ColumnModel([{
	id:"name",header:"属性",width:130,dataIndex:"name"
}
,{
	header:"值",width:80,dataIndex:"value",renderer:dataRender,editor:new Ext.form.TextField({
		allowBlank:false
	})
}
]);
function updateGrid(b){
	cells=b.getModel().getRoot().children[0].children;
	for(var a=0;a<cells.length;a++){
		cell=cells[a];
		cellstore=storemap.get("cell"+cell.id);
		if(cellstore){
			if(cell.edge==1){
				record=cellstore.query("realname","linkname").get(0)
			}
			else{
				record=cellstore.query("realname","objname").get(0)
			}
			if(record){
				record.beginEdit();
				record.set("value",cell.value);
				record.endEdit()
			}
		}
	}
	grid.reconfigure(store,cm)
}
function loadGraph(e){
	Ext.QuickTips.init();
	mxEvent.disableContextMenu(document.body);
	var a=new mxGraph();
	historys=new mxUndoManager();
	var n=mxUtils.load("resources/default-style.xml").getDocumentElement();
	var m=new mxCodec(n.ownerDocument);
	m.decode(n,a.getStylesheet());
	a.alternateEdgeStyle="vertical";
	var f=new MainPanel(a,historys);
	var o=new LibraryPanel();
	if(!grid){
		grid=new Ext.ux.maximgb.treegrid.GridPanel({
			id:"gridPanel",layout:"fit",split:true,region:"south",height:document.body.clientHeight*0.8,store:store,cm:cm,enableHdMenu:false,master_column_id:"name",autoExpandColumn:"name",loadMask:true,frame:true,clicksToEdit:1,viewConfig:{
				center:{
					autoScroll:true
				}
				,forceFit:true,enableRowBody:true,getRowClass:function(u,x,w,v){
					return"x-grid3-row-collapsed"
				}
			}
		});
		grid.on("cellclick",function(v,y,w,x){
			if(w==0){
				return
			}
			var u=v.store.getAt(y);
			if((u.get("name")=="id"||u.get("name")=="节点名称")||u.get("name")=="出口名称"){
				this.getColumnModel().setEditor(w,null)
			}
			else{
				if(u.get("name")=="前驱转移关系"){
					v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
						typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:joinstore
					})))
				}
				else{
					if(u.get("name")=="后驱转移关系"){
						v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
							typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:splitstore
							,listeners: {
								'select' : function(combo, record, index){
									if(combo.getValue() == '2'){	//异或
										showExclusivePriorityRow();
									}else{
										hiddenExclusivePriorityRow();
									}
								}
							}
						})))
					}else if(u.get("name")=="排他性优先级"){
						v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
							allowBlank:true,url:u.get("url")
						})));
					}else{
						if(u.get("name")=="提醒类型"){
							v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
								typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:remindstore
							})))
						}
						else{
							if(u.get("name")=="退回节点"){
								if(v.store.getAt(y-1).get("value")!=1){
									this.getColumnModel().setEditor(w,null)
								}
								else{
									v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
										typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:nodestore
									})))
								}
							}
							else{
								if(u.get("name")=="节点类型"){
									v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
										typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:nodetypestore
									})))
								}
								else{
									if(u.get("name")=="是否邮件提醒"||u.get("name")=="是否短消息提醒"||u.get("name")=="是否弹出式提醒"||u.get("name")=="是否rtx提醒"||u.get("name")=="是否会签"||u.get("name")=="是否允许退回"||u.get("name")=="是否自动流转"||u.get("name")=="是否提交前确认"||u.get("name")=="是否超时"||u.get("name")=="是否要盖章"||u.get("name")=="是否提交并反馈"||u.get("name")=="是否要生成公文"||u.get("name")=="是否允许打印"||u.get("name")=="公文可编辑"||u.get("name")=="是否保留痕迹"){
										v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
											typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:ynstore
										})))
									}
									else{
										if(u.get("name")=="条件"){
											v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
												allowBlank:true,url:u.get("url")
											})))
										}
										else{
											if(u.get("name")=="节点预处理页面"||u.get("name")=="节点后处理页面"){
												v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
													allowBlank:true,url:u.get("url")
												})))
											}
											else{
												if(u.get("name")=="数据接口"){
													v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
														allowBlank:true,url:u.get("url")
													})))
												}
												else{
													if(u.get("name")=="超时起始时间"){
														if(v.store.getAt(y-1).get("value")!=1){
															this.getColumnModel().setEditor(w,null)
														}
														else{
															v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:timeoutstartstore
															})))
														}
													}
													else{
														if(u.get("name")=="时间单位"){
															if(v.store.getAt(y-1).get("value")!=0&&v.store.getAt(y-1).get("value")!=1){
																this.getColumnModel().setEditor(w,null)
															}
															else{
																v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																	typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:timeoutunitstore
																})))
															}
														}
														else{
															if(u.get("name")=="超时时间类型"){
																if(v.store.getAt(y-3).get("value")!=1){
																	this.getColumnModel().setEditor(w,null)
																}
																else{
																	v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																		typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:timeouttypestore
																	})))
																}
															}
															else{
																if(u.get("name")=="超时常量"){
																	if(v.store.getAt(y-1).get("value")!=0){
																		this.getColumnModel().setEditor(w,null)
																	}
																	else{
																		this.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.TextField({})))
																	}
																}
																else{
																	if(u.get("name")=="超时变量"){
																		if(v.store.getAt(y-2).get("value")!=1){
																			this.getColumnModel().setEditor(w,null)
																		}
																		else{
																			v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																				typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:fieldstore
																			})))
																		}
																	}
																	else{
																		if(u.get("name")=="超时操作"){
																			if(v.store.getAt(y-6).get("value")!=1){
																				this.getColumnModel().setEditor(w,null)
																			}
																			else{
																				v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																					typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:timeoutoptstore
																				})))
																			}
																		}
																		else{
																			if(u.get("name")=="重定向节点"){
																				if(v.store.getAt(y-1).get("value")!=2){
																					this.getColumnModel().setEditor(w,null)
																				}
																				else{
																					v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																						typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:nodestore
																					})))
																				}
																			}
																			else{
																				if(u.get("name")=="Word模板字段"||u.get("name")=="套红模板字段"||u.get("name")=="Word套红模板字段"){
																					if(v.store.getAt(y-1).get("value")==null){
																						this.getColumnModel().setEditor(w,null)
																					}
																					else{
																						v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																							typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:fieldstore
																						})))
																					}
																				}
																				else{
																					if(u.get("name")=="流转文档名称"){
																						if(v.store.getAt(y-2).get("value")==null){
																							this.getColumnModel().setEditor(w,null)
																						}
																						else{
																							v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.ComboBox({
																								typeAhead:true,triggerAction:"all",mode:"local",valueField:"value",displayField:"text",emptyText:"Select a state...",store:fieldstore
																							})))
																						}
																					}
																					else{
																						if(u.get("name")=="Word模板"){
																							v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
																								allowBlank:true,store:wordmoduleidstore,url:u.get("url")
																							})))
																						}
																						else{
																							if(u.get("name")=="流转文档分类"){
																								if(v.store.getAt(y-3).get("value")==null){
																									this.getColumnModel().setEditor(w,null)
																								}
																								else{
																									v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
																										allowBlank:true,store:worddocurlstore,url:u.get("url")
																									})))
																								}
																							}
																							else{
																								if((u.get("name")=="基本属性"||u.get("name")=="接口属性")||u.get("name")=="其他属性"||u.get("name")=="超时属性"||u.get("name")=="高级属性"||u.get("name")=="公文属性"){
																									this.getColumnModel().setEditor(w,null)
																								}
																								else{
																									v.getColumnModel().setEditor(w,new Ext.grid.GridEditor(new Ext.form.TextField({})))
																								}
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		})
	}
	var r=new Ext.Viewport({
		layout:"border",items:[{
			xtype:"panel",region:"center",layout:"border",border:false,items:[new Ext.Panel({
				region:"west",layout:"border",split:true,width:240,collapsible:true,border:false,title:"自选图形",collapseMode:"mini",items:[o,grid]
			}),f]
		}
		]
	});
	f.graphPanel.body.dom.style.overflow="auto";
	if(mxClient.IS_MAC&&mxClient.IS_SF){
		a.addListener("size",function(u){
			u.container.style.overflow="auto"
		})
	}
	a.init(f.graphPanel.body.dom);
	a.setConnectable(true);
	a.setDropEnabled(true);
	a.setPanning(true);
	a.setTooltips(true);
	a.connectionHandler.createTarget=true;
	var q=new mxRubberband(a);
	var h=a.getDefaultParent();
	var b=mxUtils.load(e).getXml();
	n=b.documentElement;
	var m=new mxCodec(n.ownerDocument);
	a.getModel().beginUpdate();
	m.decode(n,a.getModel());
	a.getModel().endUpdate();
	var c=function(u,v){
		historys.undoableEditHappened(v)
	};
	a.getModel().addListener("undo",c);
	a.getView().addListener("undo",c);
	var j=f.graphPanel.getTopToolbar().items;
	var i=function(){
		var u=!a.isSelectionEmpty();
		j.get("cut").setDisabled(!u);
		j.get("copy").setDisabled(!u);
		j.get("delete").setDisabled(!u);
		j.get("italic").setDisabled(!u);
		j.get("bold").setDisabled(!u);
		j.get("underline").setDisabled(!u);
		j.get("fontcolor").setDisabled(!u);
		j.get("alignleft").setDisabled(!u);
		j.get("aligntop").setDisabled(!u)
	};
	a.selection.addListener("change",i);
	var g=function(){
		j.get("undo").setDisabled(!historys.canUndo());
		j.get("redo").setDisabled(!historys.canRedo())
	};
	historys.addListener("add",g);
	historys.addListener("undo",g);
	historys.addListener("redo",g);
	i();
	g();
	insertVertexTemplate(o,a,"节点","images/rounded.gif","rounded=1",100,40);
	insertEdgeTemplate(o,a,"连接","images/straight.gif","straight",100,100);
	insertEdgeTemplate(o,a,"横向连接","images/connect.gif",null,100,100);
	insertEdgeTemplate(o,a,"纵向连接","images/vertical.gif","vertical",100,100);
	insertAidTemplate(o,a,"矩形","images/rectangle.gif",null,100,40);
	insertAidTemplate(o,a,"三角形","images/triangle.gif","triangle",40,60);
	insertAidTemplate(o,a,"菱形","images/rhombus.gif","rhombus",60,60);
	insertAidTemplate(o,a,"直线","images/hline.gif","line",100,100);
	var t=a.createGroupCell;
	a.createGroupCell=function(){
		var u=t.apply(this,arguments);
		u.setStyle("group");
		return u
	};
	var p=a.connectionHandler.createEdge;
	a.connectionHandler.createEdge=function(){
		if(GraphEditor.edgeTemplate!=null){
			var u=a.cloneCells([GraphEditor.edgeTemplate])[0];
			return u
		}
		else{
			return p.apply(this,arguments)
		}
	};
	o.getSelectionModel().on("selectionchange",function(w,v){
		if(v!=null&&v.attributes.cells!=null){
			var u=v.attributes.cells[0];
			if(u!=null&&a.getModel().isEdge(u)){
				GraphEditor.edgeTemplate=u
			}
		}
	});

	var d=new Ext.ToolTip({
		target:a.container,html:""
	});
	d.disabled=true;
	a.tooltipHandler.show=function(v,u,w){
		if(v!=null&&v.length>0){
			if(d.body!=null){
				d.body.dom.firstChild.nodeValue=v
			}
			else{
				d.html=v
			}
			d.showAt([u,w+mxConstants.TOOLTIP_VERTICAL_OFFSET])
		}
	};
	a.tooltipHandler.hide=function(){
		d.hide()
	};
	var l=function(w){
		var v=a.getModel();
		var u=a.getCurrentRoot();
		var x="";
		while(u!=null&&v.getParent(v.getParent(u))!=null){
			if(a.isValidRoot(u)){
				x=" > "+a.convertValueToString(u)+x
			}
			u=a.getModel().getParent(u)
		}
		document.title="Graph Editor"+x
	};
	a.getView().addListener("down",l);
	a.getView().addListener("up",l);
	var k=function(u,v){
		a.selectCellsForEdit(v)
	};
	historys.addListener("undo",k);
	historys.addListener("redo",k);
	a.container.focus();
	var s=new mxKeyHandler(a);
	s.enter=function(){};
	s.bindKey(8,function(){
		a.collapse()
	});
	s.bindKey(13,function(){
		a.expand()
	});
	s.bindKey(33,function(){
		a.exitGroup()
	});
	s.bindKey(34,function(){
		a.enterGroup()
	});
	s.bindKey(36,function(){
		a.home()
	});
	s.bindKey(35,function(){
		a.refresh()
	});
	s.bindKey(37,function(){
		a.selectPrevious()
	});
	s.bindKey(38,function(){
		a.selectParent()
	});
	s.bindKey(39,function(){
		a.selectNext()
	});
	s.bindKey(40,function(){
		a.selectChild()
	});
	s.bindKey(46,function(){
		a.remove()
	});
	s.bindKey(107,function(){
		a.zoomIn()
	});
	s.bindKey(109,function(){
		a.zoomOut()
	});
	s.bindKey(113,function(){
		a.edit()
	});
	s.bindControlKey(65,function(){
		a.selectAll()
	});
	s.bindControlKey(89,function(){
		historys.redo();
		updateGrid(a)
	});
	s.bindControlKey(90,function(){
		historys.undo();
		updateGrid(a)
	});
	s.bindControlKey(88,function(){
		mxClipboard.cut(a)
	});
	s.bindControlKey(67,function(){
		mxClipboard.copy(a)
	});
	s.bindControlKey(86,function(){
		mxClipboard.paste(a)
	});
	s.bindControlKey(71,function(){
		a.group(null,20)
	});
	s.bindControlKey(85,function(){
		a.ungroup()
	})
}
function insertVertexTemplate(b,k,d,i,c,e,l,j,g){
	var m=[new mxCell((j!=null)?j:"",new mxGeometry(0,0,e,l),c)];
	m[0].vertex=true;
	var a=function(q,o,s){
		var p=(s!=null)?q.isValidDropTarget(s,m,o):false;
		var n=null;
		if(s!=null&&!p&&q.getModel().getChildCount(s)==0&&q.getModel().isVertex(s)==m[0].vertex){
			q.getModel().setStyle(s,c);
			n=[s]
		}
		else{
			if(s!=null&&!p){
				s=null
			}
			var r=q.getPointForEvent(o);
			n=q.move(m,r.x,r.y,true,s)
		}
		q.setSelectionCells(n)
	};
	var f=b.addTemplate(d,i,g,m);
	var h=function(n){
		if(f.ui.elNode!=null){
			var o=document.createElement("div");
			o.style.border="dashed black 1px";
			o.style.width=e+"px";
			o.style.height=l+"px";
			mxUtils.makeDraggable(f.ui.elNode,k,a,o,0,0)
		}
	};
	if(!f.parentNode.isExpanded()){
		b.on("expandnode",h)
	}
	else{
		h(f.parentNode)
	}
	return f
}
function insertEdgeTemplate(b,k,d,i,c,e,l,j,g){
	var m=[new mxCell((j!=null)?j:"",new mxGeometry(0,0,e,l),c)];
	m[0].geometry.setTerminalPoint(new mxPoint(0,l),true);
	m[0].geometry.setTerminalPoint(new mxPoint(e,0),false);
	m[0].edge=true;
	var a=function(q,o,s){
		var p=(s!=null)?q.isValidDropTarget(s,m,o):false;
		var n=null;
		if(s!=null&&!p){
			s=null
		}
		var r=q.getPointForEvent(o);
		n=q.move(m,r.x,r.y,true,s);
		GraphEditor.edgeTemplate=n[0];
		q.setSelectionCells(n)
	};
	var f=b.addTemplate(d,i,g,m);
	var h=function(n){
		if(f.ui.elNode!=null){
			var o=document.createElement("div");
			o.style.border="dashed black 1px";
			o.style.width=e+"px";
			o.style.height=l+"px";
			mxUtils.makeDraggable(f.ui.elNode,k,a,o,0,-5)
		}
	};
	if(!f.parentNode.isExpanded()){
		b.on("expandnode",h)
	}
	else{
		h(f.parentNode)
	}
	return f
}
function insertAidTemplate(a,h,c,f,b,d,i,g,e){
	if(b&&b=="line"){
		return insertEdgeTemplate(a,h,c,f,b,d,i,g,a.images)
	}
	return insertVertexTemplate(a,h,c,f,b,d,i,g,a.images)
};
function showExclusivePriorityRow(){ //显示排他性优先级行
	var exclusivePriorityRow = getExclusivePriorityRow();
	if(exclusivePriorityRow){
		//exclusivePriorityRow.style.display = "block";
		addClassToExclusivePriorityRow(exclusivePriorityRow, "gridRowShow");
	}
}
function hiddenExclusivePriorityRow(){ //隐藏排他性优先级行
	var exclusivePriorityRow = getExclusivePriorityRow();
	if(exclusivePriorityRow){
		//exclusivePriorityRow.style.display = "none";
		addClassToExclusivePriorityRow(exclusivePriorityRow, "gridRowHidden");
	}
}
function getExclusivePriorityRow(){	//获取排他性优先级行
	if(grid){
		var rowIndex = -1;
		var flag = 0;
		grid.store.each(function(r){  
        	if(r.get("realname") == "exclusivePriority"){
       			rowIndex = flag;
       			return;
       		}
       		flag++;
        });
		var exclusivePriorityRow = grid.getView().getRow(rowIndex);
		if(exclusivePriorityRow && exclusivePriorityRow.innerHTML.indexOf("排他性优先级") != -1){
			return exclusivePriorityRow;
		}
	}
	return null;
}

function addClassToExclusivePriorityRow(exclusivePriorityRow, cName){
	exclusivePriorityRow.className = exclusivePriorityRow.className.replace(" gridRowShow","");
	exclusivePriorityRow.className = exclusivePriorityRow.className.replace(" gridRowHidden","");
	exclusivePriorityRow.className = exclusivePriorityRow.className + " " + cName;
}
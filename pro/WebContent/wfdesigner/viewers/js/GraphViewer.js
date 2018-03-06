GraphViewer = {};
mxGraph.prototype.click = function(b, a) {
	if (b.button == 1) {
		Ext.menu.MenuMgr.hideAll()
	}
};
mxGraph.prototype.dblClick = function(b, a) {
};
mxVertexHandler.prototype.init = function() {
	this.bounds = new mxRectangle(this.state.x, this.state.y, this.state.width, this.state.height);
	this.selectionBorder = new mxRectangleShape(this.bounds, null);
	this.selectionBorder.dialect = (this.graph.dialect != mxConstants.DIALECT_SVG) ? mxConstants.DIALECT_VML : mxConstants.DIALECT_SVG;
	this.selectionBorder.init(this.graph.getView().getOverlayPane())
};
mxEdgeHandler.prototype.init = function() {
	this.points = new Array();
	this.abspoints = this.state.absolutePoints;
	this.shape = new mxPolyline(this.abspoints);
	this.shape.dialect = (this.graph.dialect != mxConstants.DIALECT_SVG) ? mxConstants.DIALECT_VML : mxConstants.DIALECT_SVG;
	this.shape.init(this.graph.getView().getOverlayPane());
	this.shape.node.style.cursor = "pointer";
	var b = this;
	mxEvent.addListener(this.shape.node, "mousedown", function(c) {
		b.graph.dispatchGraphEvent("mousedown", c, b.state.cell)
	});
	mxEvent.addListener(this.shape.node, "mouseup", function(c) {
		b.graph.dispatchGraphEvent("mouseup", c, b.state.cell)
	});
	this.label = new mxPoint(this.state.absoluteOffset.x, this.state.absoluteOffset.y);
	this.labelShape = new mxRectangleShape(new mxRectangle(), null, null);
	this.initBend(this.labelShape);
	var a = this.state.cell;
	this.redraw()
};
mxCellRenderer.prototype.installListeners = function(c) {
	var b = c.view.graph;
	if (b.dialect == mxConstants.DIALECT_SVG) {
		var a = "all";
		if (b.getModel().isEdge(c.cell) && c.shape.stroke != null && c.shape.fill == null) {
			a = "visibleStroke"
		}
		if (c.shape.innerNode != null) {
			c.shape.innerNode.setAttribute("pointer-events", a)
		} else {
			c.shape.node.setAttribute("pointer-events", a)
		}
	}
	var d = b.getCursorForCell(c.cell);
	if (d != null || b.isEnabled()) {
		if (d == null) {
			if (b.getModel().isEdge(c.cell)) {
			} else {
				if (b.isMovable(c.cell)) {
				}
			}
		}
		if (c.shape.innerNode != null && !b.getModel().isEdge(c.cell)) {
			c.shape.innerNode.style.cursor = d
		} else {
			c.shape.node.style.cursor = d
		}
	}
	if (c.text != null&&c.cell.id && c.cell.vertex && c.cell.id.length == 32) {
		var d = b.getCursorForCell(c.cell);
		if (d != null || (b.isEnabled() && b.isMovable(c.cell))) {
			c.text.node.style.cursor = d;
			if (c.cell.id.length == 32) {
				c.text.node.style.cursor = d || "pointer"
			}
		}
		mxEvent.addListener(c.text.node, "click", function(e) {
			showOperators(c.cell.id,c.cell.geometry.x, c.cell.geometry.y);
			b.dispatchGraphEvent("click", e, c.cell)
		});
	}
};
mxGraphHandler.prototype.mouseMove = function(b, a) {
};
mxGraphHandler.prototype.mouseUp = function(b, a) {
};
mxGraphHandler.prototype.mouseDown = function(b, a) {
};
mxKeyHandler.prototype.keyDown = function(b, a) {
};
var h;
function loadGraph(a) {
	//Ext.QuickTips.init();
	//mxEvent.disableContextMenu(document.body);
	h = new mxGraph();
	h.setCellStyles(mxConstants.STYLE_ALIGN, mxConstants.ALIGN_CENTER);
	var b = mxUtils.load("resources/default-style.xml").getDocumentElement();
	var c = new mxCodec(b.ownerDocument);
	c.decode(b, h.getStylesheet());
	h.alternateEdgeStyle = "vertical";
//	mainPanel = new MainPanel(h);
//	var f = new Ext.Viewport( {
//	layout : "border",
//	items : mainPanel
//	});
//	mainPanel.graphPanel.body.dom.style.overflow = "auto";
	if (mxClient.IS_MAC && mxClient.IS_SF) {
		h.addListener("size", function(j) {
			j.container.style.overflow = "auto"
		})
	}
	h.init(document.getElementById("graphDiv"));
	h.setConnectable(false);
	h.setDropEnabled(false);
	h.setPanning(false);
	h.setTooltips(false);
	h.connectionHandler.createTarget = false;
	var g = h.getDefaultParent();
	var e = mxUtils.load(a).getXml();
	b = e.documentElement;
	var c = new mxCodec(b.ownerDocument);
	h.getModel().beginUpdate();
	c.decode(b, h.getModel());
	h.getModel().endUpdate();
//	mxEvent.addMouseWheelListener(function(k, j) {
//		if (!mxEvent.isConsumed(k)) {
//			if (j) {
//				h.zoomIn()
//			} else {
//				h.zoomOut()
//			}
//			mxEvent.consume(k)
//		}
//	});
	
//	var i = new Ext.ToolTip( {
//	target : h.container,
//	html : ""
//	});
//	i.disabled = true;
	h.tooltipHandler.show = function(k, j, l) {
		if (k != null && k.length > 0) {
			if (i.body != null) {
				i.body.dom.firstChild.nodeValue = k
			} else {
				i.html = k
			}
			i.showAt( [ j, l + mxConstants.TOOLTIP_VERTICAL_OFFSET ])
		}
	};
//	h.tooltipHandler.hide = function() {
//		i.hide()
//	};
	var d = new mxKeyHandler(h);
	d.bindKey(107, function() {
		h.zoomIn()
	});
	d.bindKey(109, function() {
		h.zoomOut()
	})
	
	if(!jQuery.browser.msie){	//非IE,处理节点文本换行
		var $svgTexts = jQuery("#graphDiv svg g text");
		$svgTexts.each(function(i){
			if(jQuery(this).parent().css("cursor") == "pointer"){	//是节点
				var sourceTextVal = jQuery(this).text();
				if(sourceTextVal.indexOf(" ") != -1){
					var sourceY = jQuery(this).attr("y");
					if(!isNaN(sourceY)){
						sourceY = parseInt(sourceY);
						//确立起始Y轴坐标
						var beginY = sourceY - 10;
						var splitTexts = sourceTextVal.split(" ");
						for(var j = 0; j < splitTexts.length; j++){
							var cloneText = jQuery(this).clone();
							cloneText.text(splitTexts[j]);
							cloneText.attr("y", beginY);
							jQuery(this).parent().append(cloneText);
							beginY = beginY + 15;	//每次纵坐标向下偏移15
						}
						jQuery(this).remove();	//将源text删除
					}
				}
			}
		});
	}
};
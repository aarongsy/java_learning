MainPanel = function(b, c) {
	this.graphPanel = new Ext.Panel( {
	region : "center",
	border : false,
	tbar : [ {
	id : "print",
	text : "",
	iconCls : "print-icon",
	tooltip : "打印",
	handler : function() {
		mxUtils.print(b)
	},
	scope : this
	}, "-", {
	text : "",
	iconCls : "zoomin-icon",
	tooltip : "放大",
	scope : this,
	handler : function(d) {
		b.zoomIn()
	}
	}, {
	text : "",
	iconCls : "zoomout-icon",
	tooltip : "缩小",
	scope : this,
	handler : function(d) {
		b.zoomOut()
	}
	}, {
	text : "",
	iconCls : "zoomactual-icon",
	tooltip : "实际大小",
	scope : this,
	handler : function(d) {
		b.zoomActual()
	}
	} ],
	onContextMenu : function(g, i) {
		var f = !b.isSelectionEmpty();
		if (f) {
			if ((g.vertex && g.style && g.vertex == 1 && (typeof (g.style) == "undefined" || g.style.indexOf("rounded") > -1)) || (g.edge && (typeof (g.style) == "undefined" || g.style) && g.edge == 1 && (typeof (g.style) == "undefined" || g.style
					.indexOf("line") == -1))) {
			} else {
				return
			}
		}
		if (!f) {
			return
		}
		var h = false;
		var d = false;
		if (g.vertex && g.style && g.vertex == 1 && (typeof (g.style) == "undefined" || g.style.indexOf("rounded") > -1)) {
			h = true
		}
		if (g.edge && (typeof (g.style) == "undefined" || g.style) && g.edge == 1 && (typeof (g.style) == "undefined" || g.style
				.indexOf("line") == -1)) {
			d = true
		}
		if (d) {
			return
		}
	},
	onContextHide : function() {
		if (this.ctxNode) {
			this.ctxNode.ui.removeClass("x-node-ctx");
			this.ctxNode = null
		}
	}
	});
	MainPanel.superclass.constructor.call(this, {
	region : "center",
	layout : "fit",
	items : this.graphPanel
	});
	var a = this;
	b.panningHandler.popup = function(e, g, d, f) {
		a.graphPanel.onContextMenu(d, f)
	};
	b.panningHandler.hideMenu = function() {
		if (a.graphPanel.menuPanel != null) {
			a.graphPanel.menuPanel.hide()
		}
	};
	this.graphPanel.on("resize", function() {
		b.sizeDidChange()
	})
};
Ext.extend(MainPanel, Ext.Panel, {
	movePreview : function(a, b) {
	}
});
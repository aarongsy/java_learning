LightPortalTab = function(g, t, n, f, a, h, m, r, d, o, u, e, j, b, s, p) {
    this.index = g;
    this.tabId = t;
    this.tabServerId = n;
    this.tabLabel = f;
    this.tabURL = a;
    this.tabIsCloseable = h;
    this.tabIsEditable = m;
    this.tabIsMoveable = r;
    this.allowAddContent = d;
    this.tabColor = (Light.isEmpty(o) || o == "null") ? "": o;
    this.defaulted = u;
    this.between = e;
    this.widths = j;
    this.absolute = s;
    this.isManage = (typeof(p) == "boolean" && p);
    type = b.substring(b.length - 1);
    if (!type.charAt(0).isDigit()) {
        type = "1"
    }
    this.portletWindowAppearance = "WindowAppearance" + type;
    this.portlets = new Array();
    this.loaded = false;
    var c = 0;
    for (var q = 0; q < j.length; q++) {
        c += j[q] + e
    }
    if (Light.portal.layout.width > c) {
        var l = Light.portal.layout.width - c;
        var k = parseInt(l / j.length);
        for (var q = 0; q < j.length; q++) {
            j[q] += k
        }
    }
    if (Light.portal.layout.width < c) {
        var l = c - Light.portal.layout.width;
        var k = l / j.length;
        for (var q = 0; q < j.length; q++) {
            j[q] -= k
        }
    }
    log("initialize portal tab")
};
LightPortalTab.prototype.open = function(e) {
    var b = document.createElement("span");
    b.setAttribute("id", "tabSpan" + this.tabId);
    b.className = this.tabColor;
    b.setAttribute("tabColor", this.tabColor);
    if (this.tabIsCloseable) {
        var c = document.createElement("div");
        c.className = "portal-tab-handle";
        c.innerHTML = this.tabLabel;
        var d = document.createElement("img");
        d.src = Light.portal.contextPath + "/light/images/closeTab.gif";
        d.className = "portal-tab-button";
        d.onclick = function() {
            e.close()
        };
        b.appendChild(c);
        b.appendChild(d)
    } else {
        b.innerHTML = '<div class="portal-tab-handle">' + this.tabLabel + "</div>"
    }
    var f = document.createElement("li");
    f.className = this.tabColor;
    f.setAttribute("id", this.tabId);
    f.setAttribute("tabId", this.tabId);
    f.setAttribute("tabLabel", this.tabLabel);
    f.setAttribute("tabColor", this.tabColor);
    f.onclick = function() {
        Light.portal.tabs[e.index].focus();
        Light.portal.tabs[e.index].refresh()
    };
    f.setAttribute("tabIsCloseable", "0");
    if (this.tabIsCloseable) {
        f.setAttribute("tabIsCloseable", "1")
    }
    f.setAttribute("isFocused", "true");
    f.appendChild(b);
    var a = document.createElement("div");
    a.setAttribute("id", "panel_" + this.tabId);
    a.setAttribute("panelURL", this.tabURL);
    a.setAttribute("tabColor", this.tabColor);
    a.className = this.tabColor + "Panel";
    document.getElementById("tabPanels").appendChild(a)
};
LightPortalTab.prototype.insert = function(f) {
    var c = document.createElement("span");
    c.setAttribute("id", "tabSpan" + this.tabId);
    c.className = this.tabColor;
    c.setAttribute("tabColor", this.tabColor);
    if (this.tabIsCloseable) {
        var d = document.createElement("div");
        d.className = "portal-tab-handle";
        d.innerHTML = this.tabLabel;
        var e = document.createElement("img");
        e.src = Light.portal.contextPath + "/light/images/closeTab.gif";
        e.className = "portal-tab-button";
        e.onclick = function() {
            f.close()
        };
        c.appendChild(d);
        c.appendChild(e)
    } else {
        c.innerHTML = '<div class="portal-tab-handle">' + this.tabLabel + "</div>"
    }
    var g = document.createElement("li");
    g.className = this.tabColor;
    g.setAttribute("id", this.tabId);
    g.setAttribute("tabId", this.tabId);
    g.setAttribute("tabLabel", this.tabLabel);
    g.setAttribute("tabColor", this.tabColor);
    g.onclick = function() {
        Light.portal.tabs[f.index].focus();
        Light.portal.tabs[f.index].refresh()
    };
    g.setAttribute("tabIsCloseable", "0");
    if (this.tabIsCloseable) {
        g.setAttribute("tabIsCloseable", "1")
    }
    g.setAttribute("isFocused", "true");
    g.appendChild(c);
    var a = document.getElementById("tabMenuAddTab");
    document.getElementById("tabList").insertBefore(g, a);
    var b = document.createElement("div");
    b.setAttribute("id", "panel_" + this.tabId);
    b.setAttribute("panelURL", this.tabURL);
    b.setAttribute("tabColor", this.tabColor);
    b.className = this.tabColor + "Panel";
    document.getElementById("tabPanels").appendChild(b)
};
LightPortalTab.prototype.focus = function() {
    Light.portal.currentTabId = "tab_page" + this.index;
    if(targetPortalTabId == ""){	//当指定了id显示具体tab时(targetPortalTabId不为空),不记录cookie
		var cookieExpires = new Date(); //cookie有效期
		cookieExpires.setTime(cookieExpires.getTime() + 30*24*60*60*1000);	//30天
    	Light.setCookie(Light._CURRENT_TAB, "tab_page" + this.index, cookieExpires);
    }
    var currentFocusedTabId = Light.portal.GetFocusedTabId();
    for (i = 0; i < Light.portal.tabs.length; i++) {
        if (Light.portal.tabs[i]) {
            if (Light.portal.tabs[i].index == this.index) {
                document.getElementById("panel_tab_page" + this.index).style.display = "block"
            } else {
                document.getElementById("panel_tab_page" + Light.portal.tabs[i].index).style.display = "none"
            }
        }
    }
    
    if(Light.portal.addBtn){
    	Light.portal.addBtn.setVisible(this.isManage);
    }
    if (this.absolute == 1) {
        items = [{
            iconCls: Ext.ux.iconMgr.getIcon("bullet_tick"),
            text: this.tabLabel
        }]
    } else {
        items = [{
            id: "expand",
            iconCls: Ext.ux.iconMgr.getIcon("arrow_out_longer"),
            disabled: true,
            text: "全部展开"
        },
        {
            id: "collapse",
            iconCls: Ext.ux.iconMgr.getIcon("arrow_in_longer"),
            text: "全部收缩"
        },
        "-", {
            iconCls: Ext.ux.iconMgr.getIcon("bullet_tick"),
            text: this.tabLabel
        }]
    }
    contextMenu = new Ext.menu.Menu({
        items: items,
        listeners: {
            itemclick: function(item) {
                switch (item.id) {
                case "collapse":
                    contextMenu.items.item(1).disable();
                    contextMenu.items.item(0).enable();
                    Light.portal.collapseAll();
                    break;
                case "expand":
                    contextMenu.items.item(0).disable();
                    contextMenu.items.item(1).enable();
                    Light.portal.expandAll();
                    break
                }
            }
        }
    });
    Ext.getBody().on("contextmenu",
    function(e) {
        contextMenu.showAt(e.getXY());
        e.stopEvent()
    });
    if (this.tabId != currentFocusedTabId) {
        eval("if (window.tabBlur" + currentFocusedTabId + ") { tabBlur" + currentFocusedTabId + "(); }");
        eval("if (window.tabFocus" + this.tabId + ") { tabFocus" + this.tabId + "(); }")
    }
};
LightPortalTab.prototype.refresh = function() {
    if (this.absolute != 1) {
        if (!this.loaded) {
            this.getPortletsByTab(this.index);
            this.loaded = true
        } else {
            this.rePositionAll()
        }
        Light.portal.refreshPortalMenu(this)
    } else {
        if (!this.loaded) {
            this.getPortletsByTab(this.index);
            this.loaded = true
        }
    }
    if(Light.portal.addBtn){
    	Light.portal.addBtn.setVisible(this.isManage);
    }
};
LightPortalTab.prototype.close = function() {
    var f = "";
    var b = false;
    var e = confirm(LightResourceBundle._COMMAND_CLOSE_TAB);
    if (!e) {
        return
    }
    var d = this.tabServerId;
    var a = document.getElementById("tabList");
    for (i = 0; i < a.childNodes.length; i++) {
        if (a.childNodes[i] && a.childNodes[i].tagName == "LI") {
            if (a.childNodes[i].getAttribute("id") == this.tabId) {
                a.removeChild(a.childNodes[i])
            }
        }
    }
    var c = document.getElementById("tabPanels");
    for (i = 0; i < c.childNodes.length; i++) {
        if (c.childNodes[i] && c.childNodes[i].tagName == "DIV") {
            if (c.childNodes[i].getAttribute("id") == "panel_" + this.tabId) {
                c.removeChild(c.childNodes[i])
            }
        }
    }
    for (i = 0; i < a.childNodes.length - 1; i++) {
        if (a.childNodes[i] && a.childNodes[i].tagName == "LI") {
            f = a.childNodes[i].getAttribute("id");
            if (a.childNodes[i].getAttribute("tabColor") + "current" == a.childNodes[i].className) {
                b = true
            }
        }
    }
    if (!b) {
        Light.portal.tabs[f.substring(8, f.length)].focus();
        if (!Light.portal.tabs[f.substring(8, f.length)].loaded) {
            Light.portal.tabs[f.substring(8, f.length)].refresh()
        }
    }
    Light.ajax.sendRequest(Light.portal.contextPath + Light.deleteTabRequest, {
        parameters: "tabId=" + d
    })
};
LightPortalTab.prototype.getPortletsByTab = function(c) {
    var a = this.tabServerId;
    var d = this;
    var b = {
        method: "post",
        postBody: "tabId=" + a,
        onSuccess: function(e) {
            d.responseGetPortletsByTab(e)
        },
        on404: function(e) {
            alert('Error 404: location "' + e.statusText + '" was not found.')
        },
        onFailure: function(e) {
            alert("Error " + e.status + " -- " + e.statusText)
        }
    };
    Light.ajax.sendRequest(Light.portal.contextPath + Light.getPortletsByTabRequest, b)
};
LightPortalTab.prototype.responseGetPortletsByTab = function(t) {
    var responseText = t.responseText;
    if (responseText.length <= 0) {
        Light.portal.footer.reposition();
        return
    }
    var portlets = responseText.split(";");
    var portletsCount = portlets.length;
    var maxPortlet = null;
    for (var i = 0; i < portletsCount; i++) {
        var vPortlet = null;
        var newPortlet = "new PortletWindow(new " + this.portletWindowAppearance + "(), " + this.index + "," + portlets[i] + ")";
        var vPortlet = eval(newPortlet);
        var id = Light._PC_PREFIX + this.index + "_" + vPortlet.position + "_" + vPortlet.index;
        Light.executePortlet(id);
        if (vPortlet.state == Light._MAXIMIZED_STATE) {
            maxPortlet = vPortlet
        }
    }
};
LightPortalTab.prototype.resize = function() {
    var a = 0;
    for (var c = 0; c < this.widths.length; c++) {
        a += this.widths[c] + this.between
    }
    if (Light.portal.layout.width > a) {
        var d = Light.portal.layout.width - a;
        var b = parseInt(d / this.widths.length);
        for (var c = 0; c < this.widths.length; c++) {
            this.widths[c] += b
        }
    }
    if (Light.portal.layout.width < a) {
        var d = a - Light.portal.layout.width;
        var b = parseInt(d / this.widths.length);
        for (var c = 0; c < this.widths.length; c++) {
            this.widths[c] -= b
        }
    }
    this.reLayout();
    Light.portal.refreshPortalMenu(this)
};
LightPortalTab.prototype.reLayout = function() {
    var d = null;
    for (var c = 0; c < this.portlets.length; c++) {
        if (this.portlets[c] != null) {
            for (var b = 0; b < this.portlets[c].length; b++) {
                d = this.portlets[c][b];
                if (d != null && Light.portal.tabs[d.tIndex].absolute != 1) {
                    if (d != null && !d.maximized) {
                    	d.width = this.widths[c];
                    	if(d.colspan > 0){
					    	for(var q=d.position+1;q<d.position+d.colspan;q++){
					    		if(this.widths.length > q)
					    			d.width+= this.between + this.widths[q];
					    	}
					    }
                        d.left = this.between;
                        if (d.position == 0) {
                            d.width += d.left;
                            d.left = 0
                        }
                        for (var a = 0; a < d.position; a++) {
                            d.left += this.widths[a] + this.between
                        }
                    }
                } else {
                    if (d != null && !d.maximized) {
                        d.width = 1;
                        for (w = c; w < c + d.colspan; w++) {
                            if (w > c) {
                                d.width += this.between
                            }
                            d.width += this.widths[w]
                        }
                        d.left = this.between;
                        if (d.position == 0) {
                            d.width += d.left;
                            d.left = 0
                        }
                        for (var a = 0; a < d.position; a++) {
                            d.left += this.widths[a] + this.between
                        }
                        d.window.position(d)
                    }
                }
            }
        }
    }
    if (this.absolute != 1) {
        this.rePositionAll()
    }
};
LightPortalTab.prototype.rePositionAll = function() {
    for (var b = 0; b < this.portlets.length; b++) {
        if (this.portlets[b] != null) {
            for (var a = 0; a < this.portlets[b].length; a++) {
                if (this.portlets[b][a] != null && !this.portlets[b][a].maximized) {
                    this.rePositionPortlets(this.portlets[b][a]);
                    break
                }
            }
        }
    }
    Light.portal.footer.reposition()
};
LightPortalTab.prototype.getTop = function(){
	return 0;
};
LightPortalTab.prototype.rePositionPortlets = function(g) {
	var rowBetween = 10;   
	if(g.window.layout != null){
		rowBetween = g.window.layout.rowBetween;
	}else if(g.layout != null){
		rowBetween = g.layout.rowBetween;
	}
     
    var b = g.position;
    var d = g.index;
    var a = 0;
    var f = 0;
    var c = 0;
    var noTitleFlag = 0;
    for (var e = 0; e < this.portlets[b].length; e++) {
    	if(this.portlets[b][e] != null){ 
	    	//check colspan columns    
	      	if(b > 0){
		      for(var j=0;j<b;j++){
		      	if(this.portlets[j] != null && this.portlets[j][e-c] != null){
		      		if(this.portlets[j][e-c].colspan + this.portlets[j][e-c].position > b){	      			
		      			a = this.portlets[j][e-c].top+this.portlets[j][e-c].getHeight();
		      		}
		      	}
		      }
	      	}
	        if (e >= d && this.portlets[b][e] != null && !this.portlets[b][e].maximized) {
	        	this.portlets[b][e].top = ((a == 0) ? this.getTop() : 0) + a + rowBetween ;
	            this.portlets[b][e].refreshPosition();
	        }
	        //check colspan columns, make this portlet's top is lower than all upper portlets and sort all the followings   
	      	if(b > 0){
		      for(var j=0;j<b;j++){
		      	if(this.portlets[j] != null && this.portlets[j][e+1] != null){
		      		if(this.portlets[j][e+1].colspan + this.portlets[j][e+1].position > b){
		      			if(this.portlets[j][e+1].top < parseInt(this.portlets[b][e].top) + parseInt(this.portlets[b][e].getHeight()) + rowBetween){
		      				this.portlets[j][e+1].top = parseInt(this.portlets[b][e].top) + parseInt(this.portlets[b][e].getHeight()) + rowBetween;
		      				this.portlets[j][e+1].refreshPosition();
		      				for(var k=0;k<=j;k++){
		      					var top = this.portlets[j][e+1].top + this.portlets[j][e+1].getHeight() + rowBetween;
		      					if(this.portlets[k] != null){
		      						for(var m=e+2;m<this.portlets[k].length;m++){
		      							if(this.portlets[k][m] != null){
		      								this.portlets[k][m].top = top;
		      								this.portlets[k][m].refreshPosition();
		      								top = this.portlets[k][m].top + this.portlets[k][m].getHeight() + rowBetween;
		      							}
		      						}
		      					} 
		      				}
		      			}	      			
		      		}
		      	}
		      }
	      	}
	        if (this.portlets[b][e] != null && !this.portlets[b][e].maximized) {
	        	a = this.portlets[b][e].top+this.portlets[b][e].getHeight();   
	        }
	        if (this.portlets[b][e] != null && this.portlets[b][e].maximized) {
	            a = this.portlets[b][e].getHeight();
	            f = e;
	            c = 0;
	        }
        }
        if (this.portlets[b][e] == null) {
            c++;
        }
    }
    //check colspan columns
    if(g.colspan > 0){
	   for(var i= b + 1;i< b + g.colspan;i++){
	   		if(this.portlets[i] != null && this.portlets[i][g.index] != null){
	   			this.rePositionPortlets(this.portlets[i][g.index]);
	   		}
	   }
	}
    Light.portal.footer.reposition();
};
LightPortalTab.prototype.getPortletIndex = function(a) {
    var d = true;
    var b = 0;
    if (Light.portal.tabs[this.index].portlets[a] != null) {
        for (var c = 0; c < Light.portal.tabs[this.index].portlets[a].length; c++) {
            if (Light.portal.tabs[this.index].portlets[a][c] == null) {
                d = false;
                b = c;
                break
            }
        }
        if (d) {
            b = Light.portal.tabs[this.index].portlets[a].length
        }
    } else {
        Light.portal.tabs[this.index].portlets[a] = new Array()
    }
    return b
};
LightPortalTab.prototype.showOtherPortlets = function() {
    for (var b = 0; b < this.portlets.length; b++) {
        if (this.portlets[b] != null) {
            for (var a = 0; a < this.portlets[b].length; a++) {
                if (this.portlets[b][a] != null) {
                    this.portlets[b][a].show()
                }
            }
        }
    }
};
LightPortalTab.prototype.hideOtherPortlets = function() {
    for (var b = 0; b < this.portlets.length; b++) {
        if (this.portlets[b] != null) {
            for (var a = 0; a < this.portlets[b].length; a++) {
                if (this.portlets[b][a] != null && !this.portlets[b][a].maximized) {
                    this.portlets[b][a].hide()
                }
            }
        }
    }
};
LightPortalTab.prototype.collapseAll = function() {
    for (var b = 0; b < this.portlets.length; b++) {
        if (this.portlets[b] != null) {
            for (var a = 0; a < this.portlets[b].length; a++) {
                if (this.portlets[b][a] != null && !this.portlets[b][a].minimized) {
                    this.portlets[b][a].minimize()
                }
            }
        }
    }
};
LightPortalTab.prototype.expandAll = function() {
    for (var b = 0; b < this.portlets.length; b++) {
        if (this.portlets[b] != null) {
            for (var a = 0; a < this.portlets[b].length; a++) {
                if (this.portlets[b][a] != null && this.portlets[b][a].minimized) {
                    this.portlets[b][a].minimize()
                }
                if (this.portlets[b][a] != null && this.portlets[b][a].maximized) {
                    this.portlets[b][a].maximize()
                }
            }
        }
    }
};
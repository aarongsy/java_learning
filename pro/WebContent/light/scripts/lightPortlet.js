PortletWindow = function(j, D, t, H, J, E, f, c, z, v, A, d, s, l, g, b, m, k, I, o, G, e, F, r, a, n, C,configInfo){
	this.portletConfig = new lightPortletConfig(configInfo);	//创建portletConfig
	this.styleConfig = this.portletConfig.portletStyle;		//在portlet中创建对portletStyle的引用,方便调用
	this.styleConfig.hasHeader = (Light.portal.tabs[D].isManage || this.styleConfig.hasHeader);	//系统管理员一定有标题栏
    this.window = j;
    this.mode = Light._VIEW_MODE;
    if (r == 1) {
        this.mode = Light._EDIT_MODE
    }
    if (r == 2) {
        this.mode = Light._HELP_MODE
    }
    if (r == 3) {
        this.mode = Light._CONFIG_MODE
    }
    this.state = Light._NORMAL_STATE;
    if (F == 1) {
        this.state = Light._MINIMIZED_STATE
    }
    if (F == 2) {
        this.state = Light._MAXIMIZED_STATE
    }
    this.tIndex = D;
    this.serverId = t;
    this.position = H;
    this.title = J;
    this.icon = E;
    this.url = f;
    this.request = c;
    this.requestUrl = z;
    this.closeable = v;
    this.refreshMode = A;
    this.editMode = d;
    this.helpMode = s;
    //this.configMode = l;
    this.configMode = v;
    this.autoRefreshed = g;
    this.clientCached = b;
    this.periodTime = m;
    this.allowJS = k;
    this.barBgColor = I;
    this.barFontColor = o;
    this.contentBgColor = G;
    this.parameter = e;
    this.colspan = a;
    this.left = 0;
    this.top = n;
    this.width = null;
    this.height = C;
    this.oldleft = 0;
    this.oldtop = n;
    this.oldwidth = null;
    this.oldheight = C;
    this.index = Light.portal.tabs[this.tIndex].getPortletIndex(this.position);
    var u = 0;
    var q = 0;
    var w = 0;
    for (var B = 0; B < Light.portal.tabs[this.tIndex].portlets[this.position].length; B++) {
        if (B == this.index) {
            break
        }
        if (Light.portal.tabs[this.tIndex].portlets[this.position][B] != null && !Light.portal.tabs[this.tIndex].portlets[this.position][B].maximized) {
            u += Light.portal.tabs[this.tIndex].portlets[this.position][B].window.container.clientHeight
        }
        if (Light.portal.tabs[this.tIndex].portlets[this.position][B] == null) {
            w++
        }
        if (Light.portal.tabs[this.tIndex].portlets[this.position][B] != null && Light.portal.tabs[this.tIndex].portlets[this.position][B].maximized) {
            u = Light.portal.tabs[this.tIndex].portlets[this.position][B].window.container.clientHeight;
            q = B;
            w = 0
        }
		//check colspan columns    
		if(this.position > 0){
			for(var j=0;j<this.position;j++){
				if(Light.portal.tabs[this.tIndex].portlets[j] != null && Light.portal.tabs[this.tIndex].portlets[j][B] != null){
					if(Light.portal.tabs[this.tIndex].portlets[j][B].colspan > this.position){
						u += Light.portal.tabs[this.tIndex].portlets[j][B].getHeight()+this.window.layout.rowBetween;
					}
				}
			}
		}                  
    }
    if (Light.portal.tabs[this.tIndex].absolute != 1) {
        this.top = this.window.top + u + this.window.layout.rowBetween * (B - q - w);
        this.height = null
    }
    this.left = Light.portal.tabs[this.tIndex].between;
    this.oldleft = this.left;
    this.oldtop = this.top;
    this.refreshWidth();
    /*
    if (Light.portal.tabs[this.tIndex].absolute != 1) {
        this.width = Light.portal.tabs[this.tIndex].widths[this.position]
    }
    else {
        this.width = 0;
        for (B = 0; B < this.colspan; B++) {
            this.width += Light.portal.tabs[this.tIndex].widths[this.position + B];
            if (B > 0) {
                this.width += Light.portal.tabs[this.tIndex].between
            }
        }
    }*/
    if (this.position == 0) {
        this.width += this.left;
        this.left = 0
    }
    for (var B = 0; B < this.position; B++) {
        this.left += Light.portal.tabs[this.tIndex].widths[B] + Light.portal.tabs[this.tIndex].between
    }
    Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
    this.window.render(this);
    this.minimized = false;
    this.maximized = false;
    this.moveable = false;
    this.mouseDownX = 0;
    this.mouseDownY = 0;
    this.refreshPosition();
    this.loading = "<br/><span class='portlet-rss'><img src='" + Light.portal.contextPath + "/light/images/spacer.gif' height='10' style='border: 0px' width='100' alt='' /><img src='" + Light.portal.contextPath + "/light/images/loading.gif' border='0' />&nbsp;&nbsp;Loading...</span>";
    this.content = null;
    this.window.container.innerHTML = this.loading;
    if (Light.portal.tabs[this.tIndex].absolute != 1) {
        Light.portal.tabs[this.tIndex].rePositionPortlets(this)
    }
    if (this.autoRefreshed) {
        this.firstTimeAutoRefreshed = true;
        this.autoRefresh()
    }
    pleft = this.left;
    if (Light.portal.tabs[this.tIndex].absolute == 1 && v == 1) {
        this.resizer = new Ext.Resizable(this.window.container.parentNode, {
            handles: "s e",
            maxWidth: Light.portal.layout.width - pleft,
            transparent: true
        });
        var x = this.resizer.el.getSize();
        this.resizer.el.setSize(x.width, x.height);
        this.resizer.on("beforeresize", function(h, i){
            h.startX = i.getPageX();
            h.startY = i.getPageY()
        });
        this.resizer.on("resize", function(K, i, y, L){
            p = Light.getPortletById(K.getEl().dom.id);
            wids = Light.portal.tabs[p.tIndex].widths;
            mouseupX = L.getPageX();
            mouseupY = L.getPageY();
            pos = 0;
            for (B = 0; B < wids.length; B++) {
                wid = wids[B];
                mouseupX = mouseupX - wid;
                if (mouseupX > wids[B + 1] / 2) {
                    pos++
                }
                else {
                    break
                }
            }
            clientwidth = 0;
            for (B = 0; B < pos + 1; B++) {
                clientwidth += wids[B];
                clientwidth += Light.portal.tabs[p.tIndex].between
            }
            if ((i - p.width) != 2) {
                try {
                    K.resizeTo(p.width, y)
                } 
                catch (L) {
                }
            }
            if (i - p.width > 50 || i - p.width < -50) {
                p.width = clientwidth - p.left;
                //p.colspan = (pos + 1 - p.position);
                p.window.position(p);
                p.changePosition()
            }
            else {
                if (y - p.window.container.clientHeight != 22) {
                    p.height = mouseupY - p.top;
                    p.window.position(p);
                    p.changePosition()
                }
            }
        })
    }
};

PortletWindow.prototype.refreshWidth = function(){
	this.width = Light.portal.tabs[this.tIndex].widths[this.position];
     //check colspan columns
    if(this.colspan > 0){
    	for(var i=this.position+1;i<this.position+this.colspan;i++){
    		if(Light.portal.tabs[this.tIndex].widths.length > i)
    			this.width+= Light.portal.tabs[this.tIndex].between + Light.portal.tabs[this.tIndex].widths[i];
    	}
    }
};
PortletWindow.prototype.getHeight = function(){
	return this.window.window.clientHeight;
};
PortletWindow.prototype.focus = function(){
    this.window.focus(this)
};
PortletWindow.prototype.show = function(){
    this.window.show(this)
};
PortletWindow.prototype.hide = function(){
    this.window.hide(this)
};
PortletWindow.prototype.moveBegin = function(d){
    document.body.ondragstart = function(){
        return false
    };
    if (document.all) {
        d = event
    }
    var a = d.clientX;
    var f = d.clientY;
    this.focus();
    this.moveable = true;
    this.mouseDownX = a;
    this.mouseDownY = f;
    this.moveBeginX = a;
    this.moveBeginY = f;
    Light.portal.moveTimer = 0;
    this.startMoveTimer(this);
    var c = document.getElementById("panel_tab_page" + this.tIndex);
    var b = d.target || d.srcElement;
    b = _getParentObj(b, "portlet2");
    Light.portal.highLight.style.height = b.clientHeight + "px";
    Light.portal.highLight.style.visibility = "hidden";
    c.appendChild(Light.portal.highLight)
};
function _getParentObj(c, b){
    var a = c.className;
    while (typeof(a) == "undefined" || a != b) {
        c = c.parentNode;
        if (c.tagName.toLowerCase() == "body") {
            break
        }
        a = c.className
    }
    return c
}

PortletWindow.prototype.moveEnd = function(){
    if (this.moveable) {
        var g = this.mouseDownX - this.moveBeginX;
        var c = this.mouseDownY - this.moveBeginY;
        if (Light.portal.tabs[this.tIndex].absolute != 1) {
            if (this.moveToColumn != this.position) {
                if (this.moveToColumn > this.position) {
                    this.moveRight(this.moveToColumn)
                }
                else {
                    if (this.moveToColumn < this.position) {
                        this.moveLeft(this.moveToColumn)
                    }
                }
            }
            else {
                if (this.mouseDownY > this.moveBeginY) {
                    this.moveDown()
                }
                else {
                    if (this.mouseDownY < this.moveBeginY) {
                        this.moveUp()
                    }
                }
            }
            this.lastAction = null;
            this.moveable = false;
            var f = document.getElementById("panel_tab_page" + this.tIndex);
            f.removeChild(Light.portal.highLight);
            if (!this.minimized) {
                this.refresh(false)
            }
        }
        else {
            var f = document.getElementById("panel_tab_page" + this.tIndex);
            f.removeChild(Light.portal.highLight);
            if (Light.portal.tabs[this.tIndex].portlets[this.moveToColumn] == null) {
                Light.portal.tabs[this.tIndex].portlets[this.moveToColumn] = new Array()
            }
            var a = Light.portal.tabs[this.tIndex].portlets[this.moveToColumn].length;
            var e = this.position;
            var b = this.index;
            this.position = this.moveToColumn;
            this.index = a;
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            this.window.container.parentNode.id = "portlet_" + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
            Light.portal.tabs[this.tIndex].portlets[e][b] = null;
            this.left = Light.portal.tabs[this.tIndex].between;
            //this.width = Light.portal.tabs[this.tIndex].widths[this.position];
            this.refreshWidth();
            if (this.position == 0) {
                this.width += this.left;
                this.left = 0
            }
            for (var d = 0; d < this.position; d++) {
                this.left += Light.portal.tabs[this.tIndex].widths[d] + Light.portal.tabs[this.tIndex].between
            }
            //this.colspan = 1;
            this.window.position(this);
            if (!this.minimized) {
                this.changePosition()
            }
        }
        if (Light.portal.tabs[this.tIndex].absolute != 1) {
        	Light.portal.tabs[this.tIndex].rePositionAll();
        }
    }
    document.body.onselectstart = function(){
        return true
    };
    document.body.ondragstart = function(){
        return true
    }
};
PortletWindow.prototype.move = function(d){
    if (this.moveable) {
        var h = d.clientX;
        var f = d.clientY;
        this.left += h - this.mouseDownX;
        this.top += f - this.mouseDownY;
        var g = "left";
        if (h > this.mouseDownX) {
            g = "right"
        }
        this.refreshPosition();
        this.mouseDownX = h;
        this.mouseDownY = f;
        var j = this.mouseDownX - this.moveBeginX;
        var c = this.mouseDownY - this.moveBeginY;
        var k = 0;
        var a = -1;
        for (var b = 0; b < Light.portal.tabs[this.tIndex].widths.length; b++) {
            if (b > 0) {
                k += Light.portal.tabs[this.tIndex].widths[b - 1] + Light.portal.tabs[this.tIndex].between * (b - 1)
            }
            if (g == "left") {
                if (this.left < k + Light.portal.tabs[this.tIndex].widths[b]) {
                    a = b;
                    break
                }
            }
            else {
                if (this.left + this.width > k) {
                    a = b
                }
            }
        }
        this.moveToColumn = a;
        if (Light.portal.tabs[this.tIndex].absolute != 1) {
            Light.portal.highLight.style.visibility = "visible";
            if (a != this.position) {
                if (a > this.position) {
                    this.highLightX(1, a)
                }
                else {
                    if (a < this.position) {
                        this.highLightX(2, a)
                    }
                }
            }
            else {
                if (this.mouseDownY > this.moveBeginY) {
                    this.highLight(3)
                }
                else {
                    if (this.mouseDownY < this.moveBeginY) {
                        this.highLight(4)
                    }
                }
            }
        }
        else {
            this.highLightThis(true)
        }
    }
};
PortletWindow.prototype.startMoveTimer = function(a){
    if (Light.portal.moveTimer >= 0 && Light.portal.moveTimer < 10) {
        Light.portal.moveTimer++;
        setTimeout((function(){
            a.startMoveTimer(a)
        }), 15)
    }
    if (Light.portal.moveTimer == 10) {
        Light.portal.dragDropPortlet = a;
        a.refreshPosition()
    }
};
PortletWindow.prototype.refreshPosition = function(){
    this.window.position(this)
};
var refarr;
PortletWindow.prototype.autoRefresh = function(){
    if (this.autoRefreshed) {
        if (this.firstTimeAutoRefreshed) {
            this.firstTimeAutoRefreshed = false
            
        }
        else {
            this.selfRefresh()
        }
        //_portlet = this;
        setTimeout(weaverBind(this,this.autoRefresh), this.periodTime * 60 * 1000);
    }
};
PortletWindow.prototype.selfRefresh = function(){
    if (!this.minimized) {
        if (this.mode == Light._VIEW_MODE) {
            Light.portal.tabs[this.tIndex].rePositionPortlets(this);
            this.refreshAction = true;
            Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
        }
    }
};
PortletWindow.prototype.refresh = function(a){
    if (this.refreshMode || !this.clientCached) {
        if (a == null || a == true) {
            this.window.container.innerHTML = this.loading
        }
        if (Light.portal.tabs[this.tIndex].absolute != 1) {
            Light.portal.tabs[this.tIndex].rePositionPortlets(this)
        }
        this.refreshAction = true;
        Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
    }
};
PortletWindow.prototype.changePosition = function(){
    var a = "responseId=" + Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index + "&tabId=" + Light.portal.tabs[this.tIndex].tabServerId + "&portletId=" + this.serverId + "&column=" + this.position + "&y=" + this.top + "&colspan=" + this.colspan + "&height=" + (this.window.container.clientHeight + 22) + "&row=" + this.index;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.changePositionRequest, {
        parameters: a
    });
    if (this.moveable && Light.portal.tabs[this.tIndex].absolute != 1) {
        Light.portal.tabs[this.tIndex].rePositionPortlets(this);
    }
};
PortletWindow.prototype.rememberMode = function(b){
    var a = "mode=" + b + "&portletId=" + this.serverId;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.rememberMode, {
        parameters: a
    })
};
PortletWindow.prototype.refreshButtons = function(){
    this.window.refreshButtons(this)
};
PortletWindow.prototype.edit = function(){
    if (this.editMode) {
        if (this.clientCached) {
            this.content = this.window.container.innerHTML
        }
        this.mode = Light._EDIT_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.refreshButtons()
    }
};
PortletWindow.prototype.cancelEdit = function(){
    if (this.editMode) {
        this.mode = Light._VIEW_MODE;
        if (this.clientCached && this.content != null) {
            this.window.container.innerHTML = this.content
        }
        else {
            var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.executeRender(a)
        }
        this.refreshButtons()
    }
};
PortletWindow.prototype.help = function(){
    if (this.helpMode) {
        if (this.clientCached) {
            this.content = this.window.container.innerHTML
        }
        this.mode = Light._HELP_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.refreshButtons()
    }
};
PortletWindow.prototype.cancelHelp = function(){
    if (this.helpMode) {
        this.mode = Light._VIEW_MODE;
        if (this.clientCached && this.content != null) {
            this.window.container.innerHTML = this.content
        }
        else {
            var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.executeRender(a)
        }
        this.refreshButtons()
    }
};
PortletWindow.prototype.config = function(){
    if (this.configMode) {
        if (this.clientCached) {
            this.content = this.window.container.innerHTML
        }
        this.mode = Light._CONFIG_MODE;
        /*
        var a = {
            id: Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index,
            title: this.title,
            barBgColor: this.barBgColor,
            barFontColor: this.barFontColor,
            contentBgColor: this.contentBgColor,
            textColor: this.textColor,
            transparent: this.transparent
        };
        this.window.container.innerHTML = TrimPath.processDOMTemplate("configMode.jst", a);
        Light.portal.responsePortlet(a.id);*/
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.refreshButtons()
    }
};
PortletWindow.prototype.cancelConfig = function(){
    if (this.configMode) {
        this.mode = Light._VIEW_MODE;
        if (this.clientCached && this.content != null) {
            this.window.container.innerHTML = this.content
        }
        else {
            var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.executeRender(a)
        }
        this.refreshButtons()
    }
};
PortletWindow.prototype.highLightX = function(l, b){
    var n = null;
    var d = null;
    var c = true;
    var g = 0;
    if (Light.portal.tabs[this.tIndex].portlets[b] == null) {
        Light.portal.tabs[this.tIndex].portlets[b] = new Array()
    }
    if (Light.portal.tabs[this.tIndex].portlets[b] != null) {
        var e = b;
        var k = Light.portal.tabs[this.tIndex].portlets[e].length;
        for (var h = 0; h < k; h++) {
            if (Light.portal.tabs[this.tIndex].portlets[e][h] != null) {
                if (g == 0) {
                    g = Light.portal.tabs[this.tIndex].portlets[e][h].left
                }
                if (this.top < Light.portal.tabs[this.tIndex].portlets[e][h].top) {
                    n = Light.portal.tabs[this.tIndex].portlets[e][h];
                    break
                }
            }
        }
        if (n == null) {
            for (var h = k - 1; h >= 0; h--) {
                if (Light.portal.tabs[this.tIndex].portlets[e][h] != null) {
                    d = Light.portal.tabs[this.tIndex].portlets[e][h];
                    break
                }
            }
        }
    }
    else {
        c = false
    }
    if (c) {
        var j = g;
        var f = this.window.top + 5;
        var m = Light.portal.tabs[this.tIndex].widths[b];
        var a = 5;
        if (n != null) {
            f = n.top - this.window.layout.rowBetween + 2;
            j = n.left;
            m = n.width
        }
        else {
            if (d != null) {
            	var total = Light.portal.tabs[this.tIndex].portlets[b].length;     
			    for(var i=0;i<Light.portal.tabs[this.tIndex].portlets[b].length;i++) {        	      
			      if(Light.portal.tabs[this.tIndex].portlets[this.position][i] == null){
			         total--;
			      }	                  
			    }
                f = d.top + d.window.container.clientHeight + this.window.layout.rowBetween * total;
            }
        }
        if (n != null) {
            f = n.top - 5;
            j = n.left;
            m = n.width
        }
        else {
            if (d != null) {
                f = d.top + d.window.container.clientHeight + d.window.layout.rowBetween - 5
            }
        }
        if (b == 0) {
            m += Light.portal.tabs[this.tIndex].between;
            j = 0
        }
        if (document.all) {
            Light.portal.highLight.style.posLeft = j;
            Light.portal.highLight.style.posTop = f
        }
        else {
            Light.portal.highLight.style.left = j;
            Light.portal.highLight.style.top = f
        }
        Light.portal.highLight.style.width = m;
        Light.portal.highLight.style.zIndex = ++Light.maxZIndex
    }
    else {
        Light.portal.highLight.style.visibility = "hidden"
    }
};
PortletWindow.prototype.highLight = function(l){
    var n = null;
    var b = true;
    if (l == 1) {
        var e = Light.portal.tabs[this.tIndex].widths.length;
        if (this.position + 1 < e && Light.portal.tabs[this.tIndex].portlets[this.position + 1] == null) {
            Light.portal.tabs[this.tIndex].portlets[this.position + 1] = new Array()
        }
        if (Light.portal.tabs[this.tIndex].portlets[this.position + 1] != null) {
            var d = this.position + 1;
            var j = Light.portal.tabs[this.tIndex].portlets[d].length;
            for (var g = 0; g < j; g++) {
                if (Light.portal.tabs[this.tIndex].portlets[d][g] != null && this.top < Light.portal.tabs[this.tIndex].portlets[d][g].top) {
                    n = Light.portal.tabs[this.tIndex].portlets[d][g];
                    break
                }
            }
        }
        else {
            b = false
        }
    }
    if (l == 2) {
        if (this.position > 0) {
            var d = this.position - 1;
            if (Light.portal.tabs[this.tIndex].portlets[d] == null) {
                Light.portal.tabs[this.tIndex].portlets[d] = new Array()
            }
            var j = Light.portal.tabs[this.tIndex].portlets[d].length;
            for (var g = 0; g < j; g++) {
                if (Light.portal.tabs[this.tIndex].portlets[d][g] != null && this.top < Light.portal.tabs[this.tIndex].portlets[d][g].top) {
                    n = Light.portal.tabs[this.tIndex].portlets[d][g];
                    break
                }
            }
        }
        else {
            b = false
        }
    }
    if (l == 3) {
        var k = this.index + 1;
        for (var g = k; g < Light.portal.tabs[this.tIndex].portlets[this.position].length; g++) {
            if (Light.portal.tabs[this.tIndex].portlets[this.position][g] != null) {
                n = Light.portal.tabs[this.tIndex].portlets[this.position][g];
                break
            }
        }
        if (n == null) {
            b = false
        }
    }
    if (l == 4) {
        if (this.index > 0) {
            var k = this.index - 1;
            for (var g = k; g >= 0; g--) {
                if (Light.portal.tabs[this.tIndex].portlets[this.position][g] != null) {
                    n = Light.portal.tabs[this.tIndex].portlets[this.position][g];
                    break
                }
            }
            if (n == null) {
                b = false
            }
        }
        else {
            b = false
        }
    }
    if (b) {
        var h;
        var f;
        var m;
        var a = 5;
        if (n != null) {
            if (l != 3) {
                f = n.top - 5
            }
            else {
                f = n.top + n.window.container.clientHeight + n.window.layout.rowBetween - 5
            }
            h = n.left;
            m = n.width
        }
        else {
            var c = null;
            var d = 0;
            if (l == 1) {
                d = this.position + 1
            }
            if (l == 2) {
                d = this.position - 1
            }
            var j = Light.portal.tabs[this.tIndex].portlets[d].length;
            for (var g = j - 1; g >= 0; g--) {
                if (Light.portal.tabs[this.tIndex].portlets[d][g] != null) {
                    c = Light.portal.tabs[this.tIndex].portlets[d][g];
                    break
                }
            }
            if (c != null) {
                h = c.left;
                f = c.top + c.window.container.clientHeight + this.window.layout.rowBetween;
                m = c.width
            }
            else {
                h = Light.portal.tabs[this.tIndex].between;
                for (var g = 0; g < d; g++) {
                    h += Light.portal.tabs[this.tIndex].widths[g] + Light.portal.tabs[this.tIndex].between
                }
                f = this.window.top + this.window.layout.rowBetween;
                m = Light.portal.tabs[this.tIndex].widths[d]
            }
        }
        if (document.all) {
            Light.portal.highLight.style.posLeft = h;
            Light.portal.highLight.style.posTop = f
        }
        else {
            Light.portal.highLight.style.left = h;
            Light.portal.highLight.style.top = f
        }
        Light.portal.highLight.style.width = m;
        Light.portal.highLight.style.zIndex = ++Light.maxZIndex
    }
    else {
        Light.portal.highLight.style.visibility = "hidden"
    }
};
PortletWindow.prototype.highLightThis = function(d){
    if (d) {
        var c = this.left;
        var e = this.top;
        var a = this.width;
        var b = this.window.container.clientHeight + 22;
        Light.portal.highLight.style.visibility = "visible";
        if (document.all) {
            Light.portal.highLight.style.posLeft = c;
            Light.portal.highLight.style.posTop = e
        }
        else {
            Light.portal.highLight.style.left = c;
            Light.portal.highLight.style.top = e
        }
        Light.portal.highLight.style.width = a;
        Light.portal.highLight.style.height = b;
        Light.portal.highLight.style.zIndex = ++Light.maxZIndex
    }
    else {
        Light.portal.highLight.style.visibility = "hidden"
    }
};
PortletWindow.prototype.moveCancel = function(){
    this.buttonIsClicked = true
};
PortletWindow.prototype.moveAllowed = function(){
    this.buttonIsClicked = false
};
PortletWindow.prototype.moveUp = function(){
    if (this.index > 0) {
        var c = null;
        var e = 0;
        var b = this.index;
        var a = this.index - 1;
        for (var d = a; d >= 0; d--) {
            if (Light.portal.tabs[this.tIndex].portlets[this.position][d] != null) {
                c = Light.portal.tabs[this.tIndex].portlets[this.position][d];
                e = d;
                break
            }
        }
        if (c != null) {
            c.index = this.index;
            this.index = e;
            c.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + c.position + "_" + c.index;
            c.dom.id = "portlet_" + this.tIndex + "_" + c.position + "_" + c.index;
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            this.dom.id = "portlet_" + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][e] = this;
            Light.portal.tabs[this.tIndex].portlets[this.position][b] = c;
            c.changePosition();
            c.lastAction = null;
            if (!c.minimized) {
                c.refresh(false)
            }
            this.left = Light.portal.tabs[this.tIndex].between;
            if (this.position == 0) {
                this.left = 0
            }
            for (var d = 0; d < this.position; d++) {
                this.left += Light.portal.tabs[this.tIndex].widths[d] + Light.portal.tabs[this.tIndex].between
            }
            this.changePosition()
        }
    }
};
PortletWindow.prototype.moveDown = function(){
    var c = null;
    var e = 0;
    var b = this.index;
    var a = this.index + 1;
    for (var d = a; d < Light.portal.tabs[this.tIndex].portlets[this.position].length; d++) {
        if (Light.portal.tabs[this.tIndex].portlets[this.position][d] != null) {
            c = Light.portal.tabs[this.tIndex].portlets[this.position][d];
            e = d;
            break
        }
    }
    if (c != null) {
        c.index = this.index;
        this.index = e;
        c.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + c.position + "_" + c.index;
        c.dom.id = "portlet_" + this.tIndex + "_" + c.position + "_" + c.index;
        this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        this.dom.id = "portlet_" + this.tIndex + "_" + this.position + "_" + this.index;
        Light.portal.tabs[this.tIndex].portlets[this.position][e] = this;
        Light.portal.tabs[this.tIndex].portlets[this.position][b] = c;
        this.changePosition();
        this.left = Light.portal.tabs[this.tIndex].between;
        if (this.position == 0) {
            this.left = 0
        }
        for (var d = 0; d < this.position; d++) {
            this.left += Light.portal.tabs[this.tIndex].widths[d] + Light.portal.tabs[this.tIndex].between
        }
        c.changePosition();
        c.lastAction = null;
        if (!c.minimized) {
            c.refresh(false)
        }
    }
};
PortletWindow.prototype.moveLeft = function(b){
    if (this.position > 0) {
        var n = null;
        var m = 0;
        var e = this.position;
        var l = this.index;
        var f = b;
        if (Light.portal.tabs[this.tIndex].portlets[f] == null) {
            Light.portal.tabs[this.tIndex].portlets[f] = new Array()
        }
        var k = Light.portal.tabs[this.tIndex].portlets[f].length;
        for (var h = 0; h < k; h++) {
            if (Light.portal.tabs[this.tIndex].portlets[f][h] != null && this.top < Light.portal.tabs[this.tIndex].portlets[f][h].top) {
                n = Light.portal.tabs[this.tIndex].portlets[f][h];
                m = n.index;
                break
            }
        }
        if (n != null) {
            for (var h = k - 1; h >= 0; h--) {
                if (Light.portal.tabs[this.tIndex].portlets[f][h] != null) {
                    var c = Light.portal.tabs[this.tIndex].portlets[f][h];
                    c.index++;
                    c.window.container.id = Light._PC_PREFIX + c.tIndex + "_" + c.position + "_" + c.index;
                    Light.portal.tabs[this.tIndex].portlets[f][h + 1] = c;
                    Light.portal.tabs[this.tIndex].portlets[f][h + 1].changePosition();
                    Light.portal.tabs[this.tIndex].portlets[f][h] = null;
                    c.lastAction = null;
                    if (!c.minimized) {
                        c.refresh(false)
                    }
                    if (c.serverId == n.serverId) {
                        break
                    }
                }
            }
            this.position = f;
            this.index = m;
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
            Light.portal.tabs[this.tIndex].portlets[e][l] = null;
            this.left = Light.portal.tabs[this.tIndex].between;
            //this.width = Light.portal.tabs[this.tIndex].widths[this.position];
            this.refreshWidth();  
            if (this.position == 0) {
                this.width += this.left;
                this.left = 0
            }
            for (var h = 0; h < this.position; h++) {
                this.left += Light.portal.tabs[this.tIndex].widths[h] + Light.portal.tabs[this.tIndex].between
            }
            this.changePosition()
        }
        else {
            this.position = f;
            var g = true;
            for (var h = k - 1; h >= 0; h--) {
                if (Light.portal.tabs[this.tIndex].portlets[f][h] != null) {
                    var a = Light.portal.tabs[this.tIndex].portlets[f][h];
                    this.index = a.index + 1;
                    g = false;
                    break
                }
            }
            if (g) {
                this.index = 0;
            }
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
            Light.portal.tabs[this.tIndex].portlets[e][l] = null;
            this.left = Light.portal.tabs[this.tIndex].between;
            //this.width = Light.portal.tabs[this.tIndex].widths[this.position];
            this.refreshWidth();
            if (this.position == 0) {
                this.width += this.left;
                this.left = 0
            }
            for (var h = 0; h < this.position; h++) {
                this.left += Light.portal.tabs[this.tIndex].widths[h] + Light.portal.tabs[this.tIndex].between
            }
            this.changePosition()
        }
        var d = Light.portal.tabs[this.tIndex].portlets[e].length;
        for (var h = l + 1; h < d; h++) {
            if (Light.portal.tabs[this.tIndex].portlets[e][h] != null) {
                var j = Light.portal.tabs[this.tIndex].portlets[e][h];
                Light.portal.tabs[this.tIndex].rePositionPortlets(j);
                break
            }
        }
    }
};
PortletWindow.prototype.moveRight = function(b){
    columns = Light.portal.tabs[this.tIndex].widths.length;
    if (this.position + 1 < columns && Light.portal.tabs[this.tIndex].portlets[this.position + 1] == null) {
        Light.portal.tabs[this.tIndex].portlets[this.position + 1] = new Array()
    }
    if (Light.portal.tabs[this.tIndex].portlets[this.position + 1] != null) {
        var n = null;
        var m = 0;
        var e = this.position;
        var l = this.index;
        var f = b;
        var k = Light.portal.tabs[this.tIndex].portlets[f].length;
        for (var h = 0; h < k; h++) {
            if (Light.portal.tabs[this.tIndex].portlets[f][h] != null && this.top < Light.portal.tabs[this.tIndex].portlets[f][h].top) {
                n = Light.portal.tabs[this.tIndex].portlets[f][h];
                m = n.index;
                break
            }
        }
        if (n != null) {
            for (var h = k - 1; h >= 0; h--) {
                if (Light.portal.tabs[this.tIndex].portlets[f][h] != null) {
                    var c = Light.portal.tabs[this.tIndex].portlets[f][h];
                    c.index++;
                    c.window.container.id = Light._PC_PREFIX + c.tIndex + "_" + c.position + "_" + c.index;
                    Light.portal.tabs[this.tIndex].portlets[f][h + 1] = c;
                    Light.portal.tabs[this.tIndex].portlets[f][h + 1].changePosition();
                    Light.portal.tabs[this.tIndex].portlets[f][h] = null;
                    c.lastAction = null;
                    if (!c.minimized) {
                        c.refresh(false)
                    }
                    if (c.serverId == n.serverId) {
                        break
                    }
                }
            }
            this.position = f;
            this.index = m;
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
            Light.portal.tabs[this.tIndex].portlets[e][l] = null;
            this.left = Light.portal.tabs[this.tIndex].between;
            //this.width = Light.portal.tabs[this.tIndex].widths[this.position];
            this.refreshWidth();
            if (this.position == 0) {
                this.width += this.left;
                this.left = 0
            }
            for (var h = 0; h < this.position; h++) {
                this.left += Light.portal.tabs[this.tIndex].widths[h] + Light.portal.tabs[this.tIndex].between
            }
            this.changePosition()
        }
        else {
            this.position = f;
            var g = true;
            for (var h = k - 1; h >= 0; h--) {
                if (Light.portal.tabs[this.tIndex].portlets[f][h] != null) {
                    var a = Light.portal.tabs[this.tIndex].portlets[f][h];
                    this.index = a.index + 1;
                    g = false;
                    break
                }
            }
            if (g) {
                this.index = 0;
            }
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
            Light.portal.tabs[this.tIndex].portlets[e][l] = null;
            this.left = Light.portal.tabs[this.tIndex].between;
            //this.width = Light.portal.tabs[this.tIndex].widths[this.position];
            this.refreshWidth();
            if (this.position == 0) {
                this.width += this.left;
                this.left = 0
            }
            for (var h = 0; h < this.position; h++) {
                this.left += Light.portal.tabs[this.tIndex].widths[h] + Light.portal.tabs[this.tIndex].between
            }
            this.changePosition()
        }
        var d = Light.portal.tabs[this.tIndex].portlets[e].length;
        for (var h = l + 1; h < d; h++) {
            if (Light.portal.tabs[this.tIndex].portlets[e][h] != null) {
                var j = Light.portal.tabs[this.tIndex].portlets[e][h];
                Light.portal.tabs[this.tIndex].rePositionPortlets(j);
                break
            }
        }
    }
};
PortletWindow.prototype.minimize = function(){
    this.minimized = !this.minimized;
    if (this.minimized) {
        this.state = Light._MINIMIZED_STATE;
        if (this.maximized) {
            this.maximize(false);
            this.minimized = true
        }
        var b = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' height='20' style='border: 0px' width='200' alt='' />";
        this.window.container.innerHTML = b
    }
    else {
        this.state = Light._NORMAL_STATE
    }
    this.window.minimize(this);
    Light.portal.tabs[this.tIndex].rePositionPortlets(this);
    var a = 0;
    if (this.minimized) {
        a = 1
    }
    var c = "state=" + a + "&portletId=" + this.serverId;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.rememberState, {
        parameters: c
    });
    if (!this.minimized) {
        Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
    }
};
PortletWindow.prototype.maximize = function(h){
    this.maximized = !this.maximized;
    if (!this.maximized) {
        this.state = Light._NORMAL_STATE;
        Light.portal.tabs[this.tIndex].showOtherPortlets();
        if (Light.portal.tabs[this.tIndex].absolute != 1) {
            var k = 0;
            var d = 0;
            var g = 0;
            var b = Light.portal.tabs[this.tIndex].portlets[this.position];
            var c = b.length;
            for (var f = 0; f < c; f++) {
                if (f == this.index) {
                    break
                }
                if (b[f] != null && !b[f].maximized) {
                    k += b[f].window.container.clientHeight
                }
                if (b[f] == null) {
                    g++
                }
                if (b[f] != null && b[f].maximized) {
                    k = b[f].window.container.clientHeight;
                    d = f;
                    g = 0
                }
            }
            this.top = this.window.top + k + this.window.layout.rowBetween * (f - d - g);
            //this.width = Light.portal.tabs[this.tIndex].widths[this.position];
            this.refreshWidth();
            this.left = Light.portal.tabs[this.tIndex].between;
            this.height = this.oldHeight;
            if (this.position == 0) {
                this.width += this.left;
                this.left = 0
            }
            for (var f = 0; f < this.position; f++) {
                this.left += Light.portal.tabs[this.tIndex].widths[f] + Light.portal.tabs[this.tIndex].between
            }
        }
        else {
            this.top = this.oldtop;
            this.left = this.oldleft;
            this.width = this.oldwidth;
            this.height = this.oldheight
        }
        Light.portal.container.style.zIndex = 1
    }
    else {
        this.state = Light._MAXIMIZED_STATE;
        Light.portal.tabs[this.tIndex].hideOtherPortlets();
        if (Light.portal.tabs[this.tIndex].absolute == 1) {
            this.oldleft = this.left;
            this.oldtop = this.top;
            this.oldwidth = this.width;
            this.oldheight = this.height
        }
        this.oldHeight = this.window.container.clientHeight + 22;
        this.left = 0;
        this.top = this.window.top;
        this.width = Light.portal.layout.width;
        var j = this.heigt;
        this.height = Light.portal.layout.height;
        Light.portal.container.style.zIndex = ++Light.maxZIndex;
        Light.portal.body.container.style.zIndex = ++Light.maxZIndex;
        Light.portal.menu.container.style.zIndex = ++Light.maxZIndex;
        Light.portal.footer.container.style.zIndex = ++Light.maxZIndex
    }
    this.window.maximize(this);
    if (Light.portal.tabs[this.tIndex].absolute != 1) {
        Light.portal.tabs[this.tIndex].rePositionPortlets(this)
    }
    if (h == null || h == true) {
        var a = 0;
        if (this.maximized) {
            a = 2
        }
        var e = "state=" + a + "&portletId=" + this.serverId;
        Light.ajax.sendRequest(Light.portal.contextPath + Light.rememberState, {
            parameters: e
        });
        Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
    }
};
PortletWindow.prototype.close = function(){
    var a = confirm(LightResourceBundle._COMMAND_CLOSE_PORTLET);
    if (!a) {
        return
    }
    if (this.maximized) {
        Light.portal.tabs[this.tIndex].showOtherPortlets()
    }
    this.window.close(this);
    Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = null;
    if (Light.portal.tabs[this.tIndex].absolute != 1) {
        Light.portal.tabs[this.tIndex].rePositionPortlets(this)
    }
    Light.ajax.sendRequest(Light.portal.contextPath + Light.deletePortletRequest, {
        parameters: "portletId=" + this.serverId + "&tabId=" + Light.portal.tabs[this.tIndex].tabServerId
    })
};
PortletWindow.prototype.refreshWindow = function(){
    this.window.refreshWindow(this)
};
PortletWindow.prototype.refreshHeader = function(){
    this.window.refreshHeader(this)
};
PortletPopupWindow = function(g, v, n, y, c, s, A, w, e, a, t, q, u, b, m, j, f, i, h, z, k, x, d){
	this.portletConfig = new lightPortletConfig();	//赋值一个默认的配置
	this.styleConfig = this.portletConfig.portletStyle;
	
    this.window = g;
    this.popup = true;
    this.mode = Light._VIEW_MODE;
    this.state = Light._NORMAL_STATE;
    this.tIndex = v;
    this.serverId = n;
    this.position = y;
    this.left = c;
    this.width = s;
    this.title = A;
    this.icon = w;
    this.url = e;
    this.request = a;
    this.requestUrl = t;
    this.closeable = q;
    this.refreshMode = u;
    this.editMode = b;
    this.helpMode = m;
    this.configMode = j;
    this.autoRefreshed = f;
    this.periodTime = i;
    this.allowJS = h;
    this.barBgColor = z;
    this.barFontColor = k;
    this.className = "portlet-popup";
    this.contentBgColor = "#EEF6FF";
    if (x != "") {
        this.contentBgColor = x
    }
    this.parameter = d;
    this.index = Light.portal.tabs[this.tIndex].getPortletIndex(this.position);
    var o = 0;
    var l = 0;
    var r = 0;
    this.originalTop = this.top;
    this.originalWidth = this.width;
    this.originalLeft = this.left;
    Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = this;
    this.window.render(this);
    this.minimized = false;
    this.maximized = false;
    this.moveable = false;
    this.mouseDownX = 0;
    this.mouseDownY = 0;
    this.refreshPosition();
    this.loading = "<br/><span class='portlet-rss'><img src='" + Light.portal.contextPath + "/light/images/spacer.gif' height='30' style='border: 0px' width='100' alt='' /><img src='" + Light.portal.contextPath + "/light/images/loading.gif' border='0' />&nbsp;&nbsp;Loading...</span>";
    this.window.container.innerHTML = this.loading;
    this.focus();
    if (this.autoRefreshed) {
        this.firstTimeAutoRefreshed = true;
        this.autoRefresh(this)
    }
};
PortletPopupWindow.prototype.getHeight = function(){
   return this.window.container.clientHeight;
}
PortletPopupWindow.prototype.rememberMode = function(a){
};
PortletPopupWindow.prototype.focus = function(){
    this.window.focus(this)
};
PortletPopupWindow.prototype.show = function(){
    this.window.show(this)
};
PortletPopupWindow.prototype.hide = function(){
    this.window.hide(this)
};
PortletPopupWindow.prototype.moveBegin = function(b){
    document.body.onselectstart = function(){
        return false
    };
    document.body.ondragstart = function(){
        return false
    };
    if (document.all) {
        b = event
    }
    var a = b.clientX;
    var c = b.clientY;
    this.focus();
    this.moveable = true;
    this.mouseDownX = a;
    this.mouseDownY = c;
    this.moveBeginX = a;
    this.moveBeginY = c;
    Light.portal.moveTimer = 0;
    this.startMoveTimer(this)
};
PortletPopupWindow.prototype.moveEnd = function(){
    if (this.moveable) {
        this.moveable = false;
        this.originalLeft = this.left;
        this.originalTop = this.top
    }
};
PortletPopupWindow.prototype.move = function(b){
    if (this.moveable) {
        var a = b.clientX;
        var c = b.clientY;
        this.left += a - this.mouseDownX;
        this.top += c - this.mouseDownY;
        this.refreshPosition();
        this.mouseDownX = a;
        this.mouseDownY = c
    }
};
PortletPopupWindow.prototype.startMoveTimer = function(a){
    if (Light.portal.moveTimer >= 0 && Light.portal.moveTimer < 10) {
        Light.portal.moveTimer++;
        setTimeout((function(){
            a.startMoveTimer(a)
        }), 15)
    }
    if (Light.portal.moveTimer == 10) {
        Light.portal.dragDropPortlet = this;
        a.refreshPosition()
    }
};
PortletPopupWindow.prototype.refreshPosition = function(){
    this.window.position(this);
    this.focus()
};
PortletPopupWindow.prototype.autoRefresh = function(a){
    if (a.autoRefreshed) {
        if (a.firstTimeAutoRefreshed) {
            a.firstTimeAutoRefreshed = false
        }
        else {
            a.refresh()
        }
        alert("time:" + a.periodTime * 60 * 1000);
        setTimeout((function(){
            a.autoRefresh(a)
        }), a.periodTime * 60 * 1000)
    }
};
PortletPopupWindow.prototype.refresh = function(a){
    if (a == null || a == true) {
        this.window.container.innerHTML = this.loading
    }
    Light.portal.tabs[this.tIndex].rePositionPortlets(this);
    this.refreshAction = true;
    Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
};
PortletPopupWindow.prototype.changePosition = function(){
    var a = "responseId=" + Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index + "&tabId=" + Light.portal.tabs[this.tIndex].tabServerId + "&portletId=" + this.serverId + "&column=" + this.position + "&row=" + this.index;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.changePositionRequest, {
        parameters: a
    });
    Light.portal.tabs[this.tIndex].rePositionPortlets(this)
};
PortletPopupWindow.prototype.edit = function(){
    if (this.editMode) {
        this.mode = Light._EDIT_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.window.refreshButtons(this)
    }
};
PortletPopupWindow.prototype.cancelEdit = function(){
    if (this.editMode) {
        this.mode = Light._VIEW_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.window.refreshButtons(this)
    }
};
PortletPopupWindow.prototype.help = function(){
    if (this.helpMode) {
        this.mode = Light._HELP_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.window.refreshButtons(this)
    }
};
PortletPopupWindow.prototype.cancelHelp = function(){
    if (this.helpMode) {
        this.mode = Light._VIEW_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.window.refreshButtons(this)
    }
};
PortletPopupWindow.prototype.config = function(){
    if (this.configMode) {
        this.mode = Light._CONFIG_MODE;
        this.window.refreshButtons(this);
        var a = {
            id: Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index,
            title: this.title,
            barBgColor: this.barBgColor,
            barFontColor: this.barFontColor,
            contentBgColor: this.contentBgColor,
            textColor: this.textColor,
            transparent: this.transparent
        };
        this.window.container.innerHTML = TrimPath.processDOMTemplate("configMode.jst", a);
        Light.portal.responsePortlet(a.id)
    }
};
PortletPopupWindow.prototype.cancelConfig = function(){
    if (this.configMode) {
        this.mode = Light._VIEW_MODE;
        var a = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        Light.executeRender(a);
        this.window.refreshButtons(this)
    }
};
PortletPopupWindow.prototype.moveCancel = function(){
    this.buttonIsClicked = true
};
PortletPopupWindow.prototype.moveAllowed = function(){
    this.buttonIsClicked = false
};
PortletPopupWindow.prototype.moveUp = function(){
    if (this.index > 0) {
        var c = null;
        var e = 0;
        var b = this.index;
        var a = this.index - 1;
        for (var d = a; d >= 0; d--) {
            if (Light.portal.tabs[this.tIndex].portlets[this.position][d] != null) {
                c = Light.portal.tabs[this.tIndex].portlets[this.position][d];
                e = d;
                break
            }
        }
        if (c != null) {
            c.index = this.index;
            this.index = e;
            c.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + c.position + "_" + c.index;
            this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
            Light.portal.tabs[this.tIndex].portlets[this.position][e] = this;
            Light.portal.tabs[this.tIndex].portlets[this.position][b] = c;
            c.changePosition();
            c.lastAction = null;
            if (!c.minimized) {
                c.refresh(false)
            }
            this.left = Light.portal.tabs[this.tIndex].between;
            if (this.position == 0) {
                this.left = 0
            }
            for (var d = 0; d < this.position; d++) {
                this.left += Light.portal.tabs[this.tIndex].widths[d] + Light.portal.tabs[this.tIndex].between
            }
            this.changePosition()
        }
    }
};
PortletPopupWindow.prototype.moveDown = function(){
    var c = null;
    var e = 0;
    var b = this.index;
    var a = this.index + 1;
    for (var d = a; d < Light.portal.tabs[this.tIndex].portlets[this.position].length; d++) {
        if (Light.portal.tabs[this.tIndex].portlets[this.position][d] != null) {
            c = Light.portal.tabs[this.tIndex].portlets[this.position][d];
            e = d;
            break
        }
    }
    if (c != null) {
        c.index = this.index;
        this.index = e;
        c.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + c.position + "_" + c.index;
        c.dom.id = "portlet_" + this.tIndex + "_" + c.position + "_" + c.index;
        this.window.container.id = Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index;
        this.dom.id = "portlet_" + this.tIndex + "_" + this.position + "_" + this.index;
        Light.portal.tabs[this.tIndex].portlets[this.position][e] = this;
        Light.portal.tabs[this.tIndex].portlets[this.position][b] = c;
        this.changePosition();
        this.left = Light.portal.tabs[this.tIndex].between;
        if (this.position == 0) {
            this.left = 0
        }
        for (var d = 0; d < this.position; d++) {
            this.left += Light.portal.tabs[this.tIndex].widths[d] + Light.portal.tabs[this.tIndex].between
        }
        c.changePosition();
        c.lastAction = null;
        if (!c.minimized) {
            c.refresh(false)
        }
    }
};
PortletPopupWindow.prototype.moveLeft = function(){
};
PortletPopupWindow.prototype.moveRight = function(){
};
PortletPopupWindow.prototype.minimize = function(){
    this.minimized = !this.minimized;
    if (this.minimized) {
        this.state = Light._MINIMIZED_STATE;
        if (this.maximized) {
            this.maximize(false);
            this.minimized = true
        }
        var a = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' height='20' style='border: 0px' width='200' alt='' />";
        this.window.container.innerHTML = a
    }
    else {
        this.state = Light._NORMAL_STATE
    }
    this.window.minimize(this);
    Light.portal.tabs[this.tIndex].rePositionPortlets(this);
    if (!this.minimized) {
        Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
    }
};
PortletPopupWindow.prototype.maximize = function(b){
    this.maximized = !this.maximized;
    if (!this.maximized) {
        this.state = Light._NORMAL_STATE;
        Light.portal.tabs[this.tIndex].showOtherPortlets();
        var a = 0;
        var d = 0;
        var c = 0;
        this.top = this.originalTop;
        this.width = this.originalWidth;
        this.left = this.originalLeft;
        Light.portal.container.style.zIndex = 1
    }
    else {
        this.state = Light._MAXIMIZED_STATE;
        Light.portal.tabs[this.tIndex].hideOtherPortlets();
        this.left = this.window.left;
        this.top = this.window.top;
        this.width = Light.portal.layout.width;
        Light.portal.container.style.zIndex = ++Light.maxZIndex;
        Light.portal.body.container.style.zIndex = ++Light.maxZIndex;
        Light.portal.menu.container.style.zIndex = ++Light.maxZIndex;
        Light.portal.footer.container.style.zIndex = ++Light.maxZIndex
    }
    this.window.maximize(this);
    Light.portal.tabs[this.tIndex].rePositionPortlets(this);
    if (b == null || b == true) {
        Light.executeRefresh(Light._PC_PREFIX + this.tIndex + "_" + this.position + "_" + this.index)
    }
};
PortletPopupWindow.prototype.close = function(){
    if (this.maximized) {
        Light.portal.tabs[this.tIndex].showOtherPortlets()
    }
    this.window.close(this);
    Light.portal.tabs[this.tIndex].portlets[this.position][this.index] = null;
    Light.portal.tabs[this.tIndex].rePositionPortlets(this)
};
PortletPopupWindow.prototype.refreshWindow = function(){
    this.window.refreshWindow(this)
};
PortletPopupWindow.prototype.refreshHeader = function(){
    this.window.refreshHeader(this)
};

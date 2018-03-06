function WindowAppearance(){
    this.left = 0;
    this.top = 5
}

WindowAppearance.prototype.render = function(a){
};
WindowAppearance.prototype.focus = function(a){
};
WindowAppearance.prototype.show = function(a){
};
WindowAppearance.prototype.hide = function(a){
};
WindowAppearance.prototype.position = function(a){
};
WindowAppearance.prototype.minimize = function(a){
};
WindowAppearance.prototype.maximize = function(a){
};
WindowAppearance.prototype.close = function(a){
};
WindowAppearance.prototype.refreshWindow = function(a){
};
WindowAppearance.prototype.refreshHeader = function(a){
};
WindowAppearance.prototype.refreshButtons = function(a){
};
WindowAppearance1.prototype = new WindowAppearance;
WindowAppearance1.prototype.constructor = WindowAppearance1;
function WindowAppearance1(){
    WindowAppearance.call(this);
    this.layout = {
        titleRelativeLeft: 5,
        titleRelativeTop: -8,
        buttonRelative: 16,
        upRelativeRight: 94,
        downRelativeRight: 78,
        minRelativeRight: 52,
        maxRelativeRight: 36,
        closeRelativeRight: 20,
        buttonRelativeTop: -6,
        rowBetween: 12
    }
}

WindowAppearance1.prototype.render = function(b){
    this.container = this.createPortletContainer(b);
    this.header = this.createPortletHeader(b);
    this.minButton = this.createPortletMinButton(b);
    this.maxButton = this.createPortletMaxButton(b);
    this.createPortletRestoreMinButton(b);
    this.createPortletRestoreMaxButton(b);
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    a.appendChild(this.container);
    a.appendChild(this.header);
    a.appendChild(this.minButton);
    a.appendChild(this.maxButton);
    if (b.closeable) {
        this.closeButton = this.createPortletCloseButton(b);
        a.appendChild(this.closeButton)
    }
    if (b.configMode) {
        if (b.mode == Light._CONFIG_MODE) {
            this.configButton = this.createPortletCancelConfigButton(b);
            this.createPortletConfigButton(b)
        }
        else {
            this.configButton = this.createPortletConfigButton(b);
            this.createPortletCancelConfigButton(b)
        }
        a.appendChild(this.configButton)
    }
    if (b.helpMode) {
        if (b.mode == Light._HELP_MODE) {
            this.helpButton = this.createPortletCancelHelpButton(b);
            this.createPortletHelpButton(b)
        }
        else {
            this.helpButton = this.createPortletHelpButton(b);
            this.createPortletCancelHelpButton(b)
        }
        a.appendChild(this.helpButton)
    }
    if (b.editMode) {
        if (b.mode == Light._EDIT_MODE) {
            this.editButton = this.createPortletCancelEditButton(b);
            this.createPortletEditButton(b)
        }
        else {
            this.editButton = this.createPortletEditButton(b);
            this.createPortletCancelEditButton(b)
        }
        a.appendChild(this.editButton)
    }
    if (b.refreshMode) {
        this.refreshButton = this.createPortletRefreshButton(b);
        a.appendChild(this.refreshButton)
    }
};
WindowAppearance1.prototype.focus = function(b){
    var a = ++Light.maxZIndex;
    if (b.popup != null) {
        a = a + 1000
    }
    this.container.style.zIndex = a;
    Light.maxZIndex++;
    this.header.style.zIndex = ++a;
    if (b.refreshMode) {
        this.refreshButton.style.zIndex = a
    }
    if (b.editMode) {
        this.editButton.style.zIndex = a
    }
    if (b.helpMode) {
        this.helpButton.style.zIndex = a
    }
    if (b.configMode) {
        this.configButton.style.zIndex = a
    }
    this.minButton.style.zIndex = a;
    this.maxButton.style.zIndex = a;
    if (b.closeable) {
        this.closeButton.style.zIndex = a
    }
};
WindowAppearance1.prototype.show = function(a){
    this.container.style.visibility = "visible";
    this.header.style.visibility = "visible";
    if (a.refreshMode) {
        this.refreshButton.style.visibility = "visible"
    }
    if (a.editMode) {
        this.editButton.style.visibility = "visible"
    }
    if (a.helpMode) {
        this.helpButton.style.visibility = "visible"
    }
    if (a.configMode) {
        this.configButton.style.visibility = "visible"
    }
    this.minButton.style.visibility = "visible";
    this.maxButton.style.visibility = "visible";
    if (a.closeable) {
        this.closeButton.style.visibility = "visible"
    }
};
WindowAppearance1.prototype.hide = function(a){
    this.container.style.visibility = "hidden";
    this.header.style.visibility = "hidden";
    if (a.refreshMode) {
        this.refreshButton.style.visibility = "hidden"
    }
    if (a.editMode) {
        this.editButton.style.visibility = "hidden"
    }
    if (a.helpMode) {
        this.helpButton.style.visibility = "hidden"
    }
    if (a.configMode) {
        this.configButton.style.visibility = "hidden"
    }
    this.minButton.style.visibility = "hidden";
    this.maxButton.style.visibility = "hidden";
    if (a.closeable) {
        this.closeButton.style.visibility = "hidden"
    }
};
WindowAppearance1.prototype.position = function(b){
    this.container.style.width = b.width;
    if (document.all) {
        this.container.style.posLeft = b.left;
        if (b.popup != null) {
            b.top = b.top - this.layout.rowBetween
        }
        this.container.style.posTop = b.top;
        this.header.style.posLeft = b.left + this.layout.titleRelativeLeft;
        this.header.style.posTop = b.top + this.layout.titleRelativeTop;
        var a = this.layout.minRelativeRight + this.layout.buttonRelative;
        if (b.configMode) {
            this.configButton.style.posLeft = b.left + b.width - a;
            this.configButton.style.posTop = b.top + this.layout.buttonRelativeTop;
            a = a + this.layout.buttonRelative
        }
        if (b.helpMode) {
            this.helpButton.style.posLeft = b.left + b.width - a;
            this.helpButton.style.posTop = b.top + this.layout.buttonRelativeTop;
            a = a + this.layout.buttonRelative
        }
        if (b.editMode) {
            this.editButton.style.posLeft = b.left + b.width - a;
            this.editButton.style.posTop = b.top + this.layout.buttonRelativeTop;
            a = a + this.layout.buttonRelative
        }
        if (b.refreshMode) {
            this.refreshButton.style.posLeft = b.left + b.width - a;
            this.refreshButton.style.posTop = b.top + this.layout.buttonRelativeTop
        }
        this.minButton.style.posLeft = b.left + b.width - this.layout.minRelativeRight;
        this.minButton.style.posTop = b.top + this.layout.buttonRelativeTop;
        this.maxButton.style.posLeft = b.left + b.width - this.layout.maxRelativeRight;
        this.maxButton.style.posTop = b.top + this.layout.buttonRelativeTop;
        if (b.closeable) {
            this.closeButton.style.posLeft = b.left + b.width - this.layout.closeRelativeRight;
            this.closeButton.style.posTop = b.top + this.layout.buttonRelativeTop
        }
    }
    else {
        this.container.style.left = b.left;
        this.container.style.top = b.top;
        this.header.style.left = b.left + this.layout.titleRelativeLeft;
        this.header.style.top = b.top + this.layout.titleRelativeTop;
        var a = this.layout.minRelativeRight + this.layout.buttonRelative;
        if (b.configMode) {
            this.configButton.style.left = b.left + b.width - a;
            this.configButton.style.top = b.top + this.layout.buttonRelativeTop;
            a = a + this.layout.buttonRelative
        }
        if (b.helpMode) {
            this.helpButton.style.left = b.left + b.width - a;
            this.helpButton.style.top = b.top + this.layout.buttonRelativeTop;
            a = a + this.layout.buttonRelative
        }
        if (b.editMode) {
            this.editButton.style.left = b.left + b.width - a;
            this.editButton.style.top = b.top + this.layout.buttonRelativeTop;
            a = a + this.layout.buttonRelative
        }
        if (b.refreshMode) {
            this.refreshButton.style.left = b.left + b.width - a;
            this.refreshButton.style.top = b.top + this.layout.buttonRelativeTop
        }
        this.minButton.style.left = b.left + b.width - this.layout.minRelativeRight;
        this.minButton.style.top = b.top + this.layout.buttonRelativeTop;
        this.maxButton.style.left = b.left + b.width - this.layout.maxRelativeRight;
        this.maxButton.style.top = b.top + this.layout.buttonRelativeTop;
        if (b.closeable) {
            this.closeButton.style.left = b.left + b.width - this.layout.closeRelativeRight;
            this.closeButton.style.top = b.top + this.layout.buttonRelativeTop
        }
    }
    this.focus(b)
};
WindowAppearance1.prototype.minimize = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    if (b.minimized) {
        a.removeChild(this.minButton);
        this.minButton = this.createPortletRestoreMinButton(b);
        a.appendChild(this.minButton)
    }
    else {
        a.removeChild(this.minButton);
        this.minButton = this.createPortletMinButton(b);
        a.appendChild(this.minButton)
    }
    this.position(b)
};
WindowAppearance1.prototype.maximize = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    if (!b.maximized) {
        a.removeChild(this.maxButton);
        this.maxButton = this.createPortletMaxButton(b);
        a.appendChild(this.maxButton)
    }
    else {
        a.removeChild(this.maxButton);
        this.maxButton = this.createPortletRestoreMaxButton(b);
        a.appendChild(this.maxButton)
    }
    this.position(b)
};
WindowAppearance1.prototype.close = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    a.removeChild(this.container);
    a.removeChild(this.header);
    if (b.refreshMode) {
        a.removeChild(this.refreshButton)
    }
    if (b.editMode) {
        a.removeChild(this.editButton)
    }
    if (b.helpMode) {
        a.removeChild(this.helpButton)
    }
    if (b.configMode) {
        a.removeChild(this.configButton)
    }
    a.removeChild(this.minButton);
    a.removeChild(this.maxButton);
    a.removeChild(this.closeButton)
};
WindowAppearance1.prototype.refreshWindow = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    a.removeChild(this.container);
    this.container = this.createPortletContainer(b);
    a.appendChild(this.container);
    this.refreshHeader(b);
    this.position(b)
};
WindowAppearance1.prototype.refreshHeader = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    a.removeChild(this.header);
    this.header = this.createPortletHeader(b);
    if (document.all) {
        this.header.style.posLeft = b.left + this.layout.titleRelativeLeft;
        this.header.style.posTop = b.top + this.layout.titleRelativeTop
    }
    else {
        this.header.style.left = b.left + this.layout.titleRelativeLeft;
        this.header.style.top = b.top + this.layout.titleRelativeTop
    }
    a.appendChild(this.header)
};
WindowAppearance1.prototype.refreshButtons = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    if (b.editMode) {
        a.removeChild(this.editButton);
        if (b.mode == Light._EDIT_MODE) {
            this.editButton = this.createPortletCancelEditButton(b)
        }
        else {
            this.editButton = this.createPortletEditButton(b)
        }
        this.editButton.style.visibility = "hidden"
    }
    if (b.helpMode) {
        a.removeChild(this.helpButton);
        if (b.mode == Light._HELP_MODE) {
            this.helpButton = this.createPortletCancelHelpButton(b)
        }
        else {
            this.helpButton = this.createPortletHelpButton(b)
        }
        this.helpButton.style.visibility = "hidden"
    }
    if (b.configMode) {
        a.removeChild(this.configButton);
        if (b.mode == Light._CONFIG_MODE) {
            this.configButton = this.createPortletCancelConfigButton(b)
        }
        else {
            this.configButton = this.createPortletConfigButton(b)
        }
        this.configButton.style.visibility = "hidden"
    }
    if (b.editMode) {
        a.appendChild(this.editButton)
    }
    if (b.helpMode) {
        a.appendChild(this.helpButton)
    }
    if (b.configMode) {
        a.appendChild(this.configButton)
    }
    this.position(b);
    if (b.editMode) {
        this.editButton.style.visibility = "visible"
    }
    if (b.helpMode) {
        this.helpButton.style.visibility = "visible"
    }
    if (b.configMode) {
        this.configButton.style.visibility = "visible"
    }
};
WindowAppearance1.prototype.createPortletContainer = function(b){
    var a = document.createElement("div");
    a.id = Light._PC_PREFIX + b.tIndex + "_" + b.position + "_" + b.index;
    a.style.position = "absolute";
    if (b.className != null) {
        a.className = b.className
    }
    else {
        a.className = "portlet"
    }
    a.style.width = b.width;
    a.style.zIndex = ++Light.maxZIndex;
    if (b.contentBgColor.length > 0) {
        a.style.backgroundColor = b.contentBgColor
    }
    else {
        if (Light.portal.portletWindowTransparent == false) {
            a.style.backgroundColor = "#ffffff"
        }
    }
    return a
};
WindowAppearance1.prototype.createPortletHeader = function(c){
    var a = document.createElement("div");
    a.id = "portletheader_" + c.position + "_" + c.index;
    a.style.position = "absolute";
    a.className = "portlet-header";
    if (Light.portal.tabs[c.tIndex].tabIsMoveable) {
        a.onmousedown = function(d){
            c.moveBegin(d)
        };
        a.style.cursor = "move"
    }
    var b = "";
    if (c.icon.length > 0) {
        if (c.icon.substring(0, 4) == "http") {
            b = "<img src='" + c.icon + "' style='border: 0px;' height='16' width='16'/>&nbsp;"
        }
        else {
            b = "<img src='" + Light.portal.contextPath + c.icon + "' style='border: 0px;' height='16' width='16'/>&nbsp;"
        }
    }
    if (c.url.length > 0) {
        b = b + "<a href='" + c.url + "' target='_blank'>";
        if (c.barFontColor.length > 0) {
            b = b + "<font color='" + c.barFontColor + "'>"
        }
        b = b + c.title;
        if (c.barFontColor.length > 0) {
            b = b + "</font>"
        }
        b = b + "</a>"
    }
    else {
        b = b + c.title
    }
    a.innerHTML = b;
    a.style.zIndex = Light.maxZIndex++;
    if (c.barBgColor.length > 0) {
        a.style.backgroundColor = c.barBgColor
    }
    if (c.barFontColor.length > 0) {
        a.style.color = c.barFontColor
    }
    return a
};
WindowAppearance1.prototype.createPortletRefreshButton = function(d){
    var a = "<span title='" + LightResourceBundle._REFRESH_PORTLET + "'><img src='" + Light.portal.contextPath + "/light/images/refresh_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.refresh()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletEditButton = function(d){
    var a = "<span title='" + LightResourceBundle._EDIT_MODE + "'><img src='" + Light.portal.contextPath + "/light/images/edit_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.edit()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletCancelEditButton = function(d){
    var a = "<span title='" + LightResourceBundle._VIEW_MODE + "'><img src='" + Light.portal.contextPath + "/light/images/leave_edit_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.cancelEdit()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletHelpButton = function(d){
    var a = "<span title='" + LightResourceBundle._HELP_MODE + "'><img src='" + Light.portal.contextPath + "/light/images/help_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.help()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletCancelHelpButton = function(d){
    var a = "<span title='" + LightResourceBundle._VIEW_MODE + "'><img src='" + Light.portal.contextPath + "/light/images/leave_help_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.cancelHelp()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletConfigButton = function(d){
    var a = "<span title='" + LightResourceBundle._CONFIG_MODE + "'><img src='" + Light.portal.contextPath + "/light/images/config_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.config()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletCancelConfigButton = function(d){
    var a = "<span title='" + LightResourceBundle._VIEW_MODE + "'><img src='" + Light.portal.contextPath + "/light/images/leave_config_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var b = document.createElement("a");
    b.innerHTML = a;
    b.href = "javascript:void(0)";
    b.onclick = function(){
        d.cancelConfig()
    };
    c.appendChild(b);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletMinButton = function(d){
    var b = "<span title='" + LightResourceBundle._MINIMIZED + "'><img src='" + Light.portal.contextPath + "/light/images/min_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var a = document.createElement("a");
    a.innerHTML = b;
    a.href = "javascript:void(0)";
    a.onclick = function(){
        d.minimize()
    };
    c.appendChild(a);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletRestoreMinButton = function(d){
    var b = "<span title='" + LightResourceBundle._RESTORE_MINIMIZED + "'><img src='" + Light.portal.contextPath + "/light/images/restore_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var c = document.createElement("div");
    c.className = "portlet-header-button";
    var a = document.createElement("a");
    a.innerHTML = b;
    a.href = "javascript:void(0)";
    a.onclick = function(){
        d.minimize()
    };
    c.appendChild(a);
    c.style.zIndex = Light.maxZIndex;
    return c
};
WindowAppearance1.prototype.createPortletMaxButton = function(d){
    var a = "<span title='" + LightResourceBundle._MAXIMIZED + "'><img src='" + Light.portal.contextPath + "/light/images/max_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var b = document.createElement("div");
    b.className = "portlet-header-button";
    var c = document.createElement("a");
    c.innerHTML = a;
    c.href = "javascript:void(0)";
    c.onclick = function(){
        d.maximize()
    };
    b.appendChild(c);
    b.style.zIndex = Light.maxZIndex;
    return b
};
WindowAppearance1.prototype.createPortletRestoreMaxButton = function(d){
    var a = "<span title='" + LightResourceBundle._RESTORE_MAXIMIZED + "'><img src='" + Light.portal.contextPath + "/light/images/restore_on.gif' style='border: 0px;' height='14' width='14' /></span>";
    var b = document.createElement("div");
    b.className = "portlet-header-button";
    var c = document.createElement("a");
    c.innerHTML = a;
    c.href = "javascript:void(0)";
    c.onclick = function(){
        d.maximize()
    };
    b.appendChild(c);
    b.style.zIndex = Light.maxZIndex;
    return b
};
WindowAppearance1.prototype.createPortletCloseButton = function(d){
    var a = "<span title='" + LightResourceBundle._CLOSE + "'><img src='" + Light.portal.contextPath + "/light/images/close_on.gif' style='border: 0px;' height='14' width='14'/></span>";
    var b = document.createElement("div");
    b.className = "portlet-header-button";
    var c = document.createElement("a");
    c.innerHTML = a;
    c.href = "javascript:void(0)";
    c.onclick = function(){
        d.close()
    };
    b.appendChild(c);
    b.style.zIndex = Light.maxZIndex;
    return b
};
WindowAppearance2.prototype = new WindowAppearance;
WindowAppearance2.prototype.constructor = WindowAppearance2;
function WindowAppearance2(){
    this.layout = {
        rowBetween: 10
    }
}

WindowAppearance2.prototype.render = function(b){
    this.window = this.createPortletWindow(b);
    b.dom = this.window;
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    if(b.styleConfig.hasHeader){	//包含标题栏
    	this.header = this.createPortletHeader(b, this);
	    this.headerButton = this.createPortletButton(b, 0);
	    this.header.appendChild(this.headerButton);
	    this.changeHeaderForCornerStyle(b);	//改变标题以适应圆角显示
    	this.window.appendChild(this.header);
    }
    this.container = this.createPortletContainer(b);
    this.window.appendChild(this.container);
	if(b.styleConfig.hasFooter){	//包含底部
	    this.footer = this.createPortletFooter(b, this);
	    this.footerButton = this.createPortletButton(b, 1);
	    this.positionFooterButton();
	    this.footer.appendChild(this.footerButton);
	    this.changeFooterForCornerStyle(b);	//改变底部以适应圆角显示
	    this.window.appendChild(this.footer);
    }
    this.window.style.overflowX = "hidden";
    if(a.innerHTML.indexOf("portlet_"+b.tIndex+"_11_")==-1 || (a.innerHTML.indexOf("portlet_"+b.tIndex+"_11_")>-1 && this.window.outerHTML.indexOf("portlet_"+b.tIndex+"_11_"))==-1)
    	a.appendChild(this.window)
};

//使用绝对定位将底部按钮区域定位在footer的右下角
WindowAppearance2.prototype.positionFooterButton = function(){
	this.footerButton.style.position="absolute";
	this.footerButton.style.bottom="1px";
	this.footerButton.style.right="2px";
};

//改变标题以适应圆角显示
WindowAppearance2.prototype.changeHeaderForCornerStyle = function(b){
    if(b.styleConfig.hasHeader && b.styleConfig.headerCornerStyle == 0){	//圆角
		var innerDiv = document.createElement("div");
	    var innerDiv2 = document.createElement("div");
	    var innerDiv3 = document.createElement("div");
	    
	    innerDiv.title = "cornerDiv";
	    innerDiv2.title = "cornerDiv";
	    innerDiv3.title = "cornerDiv";
	    
	    innerDiv.style.cssText = "height:1px;overflow:hidden;margin-left:3px;background-color: " + b.styleConfig.headerBGColor + ";background-image:url(" + Light.portal.contextPath + b.styleConfig.headerBGImage + ");background-repeat:" + b.styleConfig.headerBGImageRepeat;
	    innerDiv2.style.cssText = "height:1px;overflow:hidden;margin-left:2px;background-color: " + b.styleConfig.headerBGColor + ";background-image:url(" + Light.portal.contextPath + b.styleConfig.headerBGImage + ");background-repeat:" + b.styleConfig.headerBGImageRepeat;
	    innerDiv3.style.cssText = "height:1px;overflow:hidden;margin-left:1px;background-color: " + b.styleConfig.headerBGColor + ";background-image:url(" + Light.portal.contextPath + b.styleConfig.headerBGImage + ");background-repeat:" + b.styleConfig.headerBGImageRepeat;
	    
	    var outerDiv = document.createElement("div");
	    this.header.style.height = b.styleConfig.headerHeight - 3;
	    outerDiv.appendChild(innerDiv);
	    outerDiv.appendChild(innerDiv2);
	    outerDiv.appendChild(innerDiv3);
	    outerDiv.appendChild(this.header);
	    
	    outerDiv.style.height = b.styleConfig.headerHeight;
	    this.header = outerDiv;
    }
};

//改变底部以适应圆角显示
WindowAppearance2.prototype.changeFooterForCornerStyle = function(b){
	if(b.styleConfig.hasFooter && b.styleConfig.footerCornerStyle == 0){	//圆角显示
	    var innerDiv = document.createElement("div");
	    var innerDiv2 = document.createElement("div");
	    var innerDiv3 = document.createElement("div");
	    
	    innerDiv.title = "cornerDiv";
	    innerDiv2.title = "cornerDiv";
	    innerDiv3.title = "cornerDiv";
	    
	    innerDiv.style.cssText = "height:1px;overflow:hidden;margin-left:1px;background-color: " + b.styleConfig.footerBGColor + ";background-image:url(" + Light.portal.contextPath + b.styleConfig.footerBGImage + ");background-repeat:" + b.styleConfig.footerBGImageRepeat;
	    innerDiv2.style.cssText = "height:1px;overflow:hidden;margin-left:2px;background-color: " + b.styleConfig.footerBGColor + ";background-image:url(" + Light.portal.contextPath + b.styleConfig.footerBGImage + ");background-repeat:" + b.styleConfig.footerBGImageRepeat;
	    innerDiv3.style.cssText = "height:1px;overflow:hidden;margin-left:3px;background-color: " + b.styleConfig.footerBGColor + ";background-image:url(" + Light.portal.contextPath + b.styleConfig.footerBGImage + ");background-repeat:" + b.styleConfig.footerBGImageRepeat;
	    
	    var outerDiv = document.createElement("div");
	    this.footer.style.height = b.styleConfig.footerHeight - 3;
	    outerDiv.appendChild(this.footer);
	    outerDiv.appendChild(innerDiv);
	    outerDiv.appendChild(innerDiv2);
	    outerDiv.appendChild(innerDiv3);
	    
	    outerDiv.style.height = b.styleConfig.footerHeight;
	    this.footer = outerDiv;
	}
};

WindowAppearance2.prototype.focus = function(b){
    var a = ++Light.maxZIndex;
    if (b.popup != null) {
        a = a + 1000
    }
    this.window.style.zIndex = a
};
WindowAppearance2.prototype.show = function(a){
    this.window.style.visibility = "visible"
};
WindowAppearance2.prototype.hide = function(a){
    this.window.style.visibility = "hidden"
};
WindowAppearance2.prototype.position = function(c){
    try {
        this.window.style.width = c.width;
        //获取左右边框的宽度
        var windowLeftBorderStyle = this.window.style.borderLeftStyle;
        var windowLeftBorderWidth;
        if(windowLeftBorderStyle == "none" || windowLeftBorderStyle == "hidden"){
        	windowLeftBorderWidth = 0;
        }else{
        	windowLeftBorderWidth = parseInt(this.window.style.borderLeftWidth) || 1;
        }
        var windowRightBorderStyle = this.window.style.borderRightStyle;
        var windowRightBorderWidth;
        if(windowRightBorderStyle == "none" || windowRightBorderStyle == "hidden"){
        	windowRightBorderWidth = 0;
        }else{
        	windowRightBorderWidth = parseInt(this.window.style.borderRightWidth) || 1;
        }
        this.container.style.width = (c.width - windowLeftBorderWidth - windowRightBorderWidth);
        if(this.header){
        	this.header.style.width = (c.width - windowLeftBorderWidth - windowRightBorderWidth);
        }
    } 
    catch (b) {
    }
    if (!Light.isEmpty(c.height) && parseInt(c.height) > 0) {
    	var headerHeight = 0;
    	if(this.header){
    		headerHeight = this.header.clientHeight;
    	}
        this.container.style.height = (c.height - headerHeight) > 0 ? c.height - headerHeight : 0;
        this.container.style.overflowY = "auto"
    }
    var a = c.top;
    if (c.popup != null) {
        a = c.top - this.layout.rowBetween;
    }
    if (document.all) {
        this.window.style.posLeft = c.left;
        if (c.popup == null) {
            this.window.style.posTop = a
        }
    }
    else {
        this.window.style.left = c.left;
        this.window.style.top = a
    }
    this.focus(c);
    var flag = 3;
    if(c.styleConfig.hasHeader && c.styleConfig.headerCornerStyle == 0){	//根据定位的宽度调整顶部圆角的显示
    	 for(var i = 0; i < this.header.childNodes.length; i++){
	    	var headerChild = this.header.childNodes[i];
	    	if(headerChild.title == "cornerDiv"){
	    		headerChild.style.width = c.width - (flag * 2);
	    		flag--;
	    	}
	    }
    }
    var flag2 = 1;
    if(c.styleConfig.hasFooter && c.styleConfig.footerCornerStyle == 0){	//根据定位的宽度调整底部圆角的显示
	    for(var i = 0; i < this.footer.childNodes.length; i++){
	    	var footerChild = this.footer.childNodes[i];
	    	if(footerChild.title == "cornerDiv"){
	    		footerChild.style.width = c.width - (flag2 * 2);
	    		flag2++;
	    	}
	    }
    }
};
WindowAppearance2.prototype.minimize = function(a){
    this.refreshButtons(a);
};
WindowAppearance2.prototype.maximize = function(a){
    this.refreshButtons(a);
};
WindowAppearance2.prototype.close = function(b){
    var a = document.getElementById("panel_tab_page" + b.tIndex);
    if(b.styleConfig.hasHeader){
    	this.window.removeChild(this.header);
    }
    this.window.removeChild(this.container);
    if(b.styleConfig.hasFooter){
    	this.window.removeChild(this.footer);
    }
    a.removeChild(this.window)
};
WindowAppearance2.prototype.refreshWindow = function(a){
    this.window.removeChild(this.header);
    this.window.removeChild(this.container);
    this.header = this.createPortletHeader(a, this);
    this.headerButton = this.createPortletButton(a, 0);
    this.container = this.createPortletContainer(a);
    this.header.appendChild(this.headerButton);
    this.window.appendChild(this.header);
    this.window.appendChild(this.container);
    this.position(a)
};
WindowAppearance2.prototype.refreshHeader = function(a){
	if(a.styleConfig.hasHeader){
	    this.window.removeChild(this.header);
	    this.header = this.createPortletHeader(a, this);
	    this.headerButton = this.createPortletButton(a, 0);
	    this.header.appendChild(this.headerButton);
	    this.changeHeaderForCornerStyle(a);
	    this.window.insertBefore(this.header, this.container);
    }
};
WindowAppearance2.prototype.refreshButtons = function(a){
	if(a.styleConfig.hasHeader){
	    this.window.removeChild(this.header);
	    this.header = this.createPortletHeader(a, this);
	    this.headerButton = this.createPortletButton(a, 0);
	    this.header.appendChild(this.headerButton);
	    this.changeHeaderForCornerStyle(a);
	    this.window.insertBefore(this.header, this.container);
    }
    if(a.styleConfig.hasFooter){
    	this.window.removeChild(this.footer);
	    this.footer = this.createPortletFooter(a, this);
	    this.footerButton = this.createPortletButton(a, 1);
	    this.positionFooterButton();
	    this.footer.appendChild(this.footerButton);
	    this.changeFooterForCornerStyle(a);
	    this.window.appendChild(this.footer);
    }
    this.position(a)
};
WindowAppearance2.prototype.createPortletWindow = function(b){
    var a = document.createElement("div");
    a.id = "portlet_" + b.tIndex + "_" + b.position + "_" + b.index;
    a.style.padding = "0 0 0 0";
    a.style.position = "absolute";
    if (Light.portal.portletWindowTransparent == false) {
        a.style.backgroundColor = "#ffffff"
    }
    else {
        a.style.backgroundColor = ""
    }
    a.style.zIndex = ++Light.maxZIndex;
    if(b.styleConfig.isNoStyle()){	//没有为该门户元素显式的配置样式
    	a.className = "portlet";
    }else{
	    a.style.fontSize = b.styleConfig.windowFontSize;
	    a.style.fontFamily = b.styleConfig.windowFontFamily;
	    a.style.borderTop = b.styleConfig.windowTopBorderWidth + "px " + b.styleConfig.windowTopBorderStyle + " " + b.styleConfig.windowTopBorderColor;
	    a.style.borderRight = b.styleConfig.windowRightBorderWidth + "px " + b.styleConfig.windowRightBorderStyle + " " + b.styleConfig.windowRightBorderColor;
	    a.style.borderBottom = b.styleConfig.windowBottomBorderWidth + "px " + b.styleConfig.windowBottomBorderStyle + " " + b.styleConfig.windowBottomBorderColor;
	    a.style.borderLeft = b.styleConfig.windowLeftBorderWidth + "px " + b.styleConfig.windowLeftBorderStyle + " " + b.styleConfig.windowLeftBorderColor;
    	if(b.styleConfig.windowBGColor != null && b.styleConfig.windowBGColor != ""){	//背景颜色不为空
    		a.style.backgroundColor = b.styleConfig.windowBGColor;
    	}
    }
    return a
};
WindowAppearance2.prototype.createPortletHeader = function(e, c){
    var a = document.createElement("div");
    if(e.styleConfig.isNoStyle()){	//没有为该门户元素显式的配置样式
    	a.className="portlet-header";
    }else{
	    a.style.height = e.styleConfig.headerHeight;
	    a.style.backgroundColor = e.styleConfig.headerBGColor;
	    a.style.backgroundImage = "url(" + Light.portal.contextPath + e.styleConfig.headerBGImage + ")";
	    a.style.backgroundRepeat = e.styleConfig.headerBGImageRepeat;
    }
    if (e.barBgColor.length > 0) {
        a.style.backgroundColor = e.barBgColor
    }
    if (!e.maximized && Light.portal.tabs[e.tIndex].tabIsMoveable) {
        a.onmousedown = function(f){
            e.moveBegin(f)
        };
        a.style.cursor = "move"
    }
    a.onmouseover = function(f){
        c.headerButton.style.visibility = "visible"
    };
    a.onmouseout = function(f){
        c.headerButton.style.visibility = "hidden"
    };
    var d = document.createElement("div");
    var b = "";
    if (!Light.isEmpty(e.icon) && e.icon != "null") {
        if (e.icon.substring(0, 4) == "http") {
            b = "<img src='" + e.icon + "'/>&nbsp;"
        }
        else {
            b = "<img src='" + Light.portal.contextPath + e.icon + "'/>&nbsp;"
        }
    }
    if (!Light.isEmpty(e.url) && e.url != "null") {
        b += "<a href='" + e.url + "' target='_blank'>";
        if (e.barFontColor.length > 0) {
            b = b + "<span><font color='" + e.barFontColor + "'>"
        }
        b = b + e.title;
        if (e.barFontColor.length > 0) {
            b = b + "</font></span>"
        }
        b = b + "</a>"
    }
    else {
        b = b + "<span>" + e.title + "</span>"
    }
    d.className = "portlet-header-title";
    d.innerHTML = b;
    if (e.barBgColor.length > 0) {
        d.style.backgroundColor = e.barBgColor
    }
    if (e.barFontColor.length > 0) {
        d.style.color = e.barFontColor
    }
    a.appendChild(d);
    
    return a
};
WindowAppearance2.prototype.createPortletFooter = function(e, c){
    var a = document.createElement("div");
    a.className = "portlet-footer";
    a.style.height = e.styleConfig.footerHeight;
    a.style.backgroundColor = e.styleConfig.footerBGColor;
    a.style.backgroundImage = "url(" + Light.portal.contextPath + e.styleConfig.footerBGImage + ")";
    a.style.backgroundRepeat = e.styleConfig.footerBGImageRepeat;
    a.onmouseover = function(f){
        c.footerButton.style.visibility = "visible"
    };
    a.onmouseout = function(f){
        c.footerButton.style.visibility = "hidden"
    };
    return a;
};
WindowAppearance2.prototype.createPortletHeaderButton = function(n){
    var d = " <span title='" + LightResourceBundle._REFRESH_PORTLET + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/refresh_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var j = " <span title='" + LightResourceBundle._EDIT_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/edit_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' BORDER='0' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var i = " <span title='" + LightResourceBundle._VIEW_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/leave_edit_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var l = " <span title='" + LightResourceBundle._HELP_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/help_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var k = " <img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/leave_help_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/>";
    var e = " <span title='" + LightResourceBundle._CONFIG_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/config_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var s = " <span title='" + LightResourceBundle._VIEW_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/leave_config_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var p = " <span title='" + LightResourceBundle._MINIMIZED + "'><img id='pngIcoMin' src='" + Light.portal.contextPath + "/light/images/min_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var r = " <span title='" + LightResourceBundle._RESTORE + "'><img id='pngIcoMax' src='" + Light.portal.contextPath + "/light/images/restore_on.gif' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var q = " <span title='" + LightResourceBundle._MAXIMIZED + "'><img id='pngIcoMax' src='" + Light.portal.contextPath + "/light/images/max_on.gif' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var a = " <span title='" + LightResourceBundle._CLOSE + "'><img id='pngIcoClose' src='" + Light.portal.contextPath + "/light/images/close_on.gif' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var h = document.createElement("div");
    h.id = "portletHB_" + n.tIndex + "_" + n.position + "_" + n.index;
    h.className = "portlet2-header-button";
    h.style.visibility = "hidden";
    if (document.all) {
        if (n.refreshMode) {
            var b = document.createElement("a");
            b.innerHTML = d;
            b.href = "javascript:void(0)";
            b.onclick = function(){
                n.refresh();
                n.moveAllowed()
            };
            b.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(b)
        }
        if (n.editMode) {
            var m = document.createElement("a");
            m.href = "javascript:void(0)";
            if (n.mode == Light._EDIT_MODE) {
                m.innerHTML = i;
                m.onclick = function(){
                    n.cancelEdit();
                    n.moveAllowed()
                }
            }
            else {
                m.innerHTML = j;
                m.onclick = function(){
                    n.edit();
                    n.moveAllowed()
                }
            }
            m.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(m)
        }
        if (n.helpMode) {
            var o = document.createElement("a");
            o.href = "javascript:void(0)";
            if (n.mode == Light._HELP_MODE) {
                o.innerHTML = k;
                o.onclick = function(){
                    n.cancelHelp();
                    n.moveAllowed()
                }
            }
            else {
                o.innerHTML = l;
                o.onclick = function(){
                    n.help();
                    n.moveAllowed()
                }
            }
            o.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(o)
        }
        if (n.configMode) {
            var t = document.createElement("a");
            t.href = "javascript:void(0)";
            if (n.mode == Light._CONFIG_MODE) {
                t.innerHTML = s;
                t.onclick = function(){
                    n.cancelConfig();
                    n.moveAllowed()
                }
            }
            else {
                t.innerHTML = e;
                t.onclick = function(){
                    n.config();
                    n.moveAllowed()
                }
            }
            t.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(t);
        }
        if (Light.portal.tabs[n.tIndex].absolute != 1) {
            var g = document.createElement("a");
            if (n.minimized) {
                g.innerHTML = r
            }
            else {
                g.innerHTML = p
            }
            g.href = "javascript:void(0)";
            g.onclick = function(){
                n.minimize();
                n.moveAllowed()
            };
            g.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(g)
        }
        var f = document.createElement("a");
        if (n.maximized) {
            f.innerHTML = r
        }
        else {
            f.innerHTML = q
        }
        f.href = "javascript:void(0)";
        f.onclick = function(){
            n.maximize();
            n.moveAllowed()
        };
        f.onmousedown = function(){
            n.moveCancel()
        };
        h.appendChild(f);
        if (n.closeable) {
            var c = document.createElement("a");
            c.innerHTML = a;
            c.href = "javascript:void(0)";
            c.onclick = function(){
                n.close();
                n.moveAllowed()
            };
            c.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(c)
        }
    }
    else {
        if (n.refreshMode) {
            var b = document.createElement("input");
            b.type = "image";
            b.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            b.src = Light.portal.contextPath + "/light/images/refresh_on.gif";
            b.onclick = function(){
                n.refresh();
                n.moveAllowed()
            };
            b.onmousedown = function(){
                n.moveCancel()
            };
            b.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            b.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(b)
        }
        if (n.editMode) {
            var m = document.createElement("input");
            m.type = "image";
            m.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            if (n.mode == Light._EDIT_MODE) {
                m.src = Light.portal.contextPath + "/light/images/leave_edit_on.gif";
                m.onclick = function(){
                    n.cancelEdit();
                    n.moveAllowed()
                }
            }
            else {
                m.src = Light.portal.contextPath + "/light/images/edit_on.gif";
                m.onclick = function(){
                    n.edit();
                    n.moveAllowed()
                }
            }
            m.onmousedown = function(){
                n.moveCancel()
            };
            m.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            m.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(m)
        }
        if (n.helpMode) {
            var o = document.createElement("input");
            o.type = "image";
            o.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            if (n.mode == Light._HELP_MODE) {
                o.src = Light.portal.contextPath + "/light/images/leave_help_on.gif";
                o.onclick = function(){
                    n.cancelHelp();
                    n.moveAllowed()
                }
            }
            else {
                o.src = Light.portal.contextPath + "/light/images/help_on.gif";
                o.onclick = function(){
                    n.help();
                    n.moveAllowed()
                }
            }
            o.onmousedown = function(){
                n.moveCancel()
            };
            o.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            o.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(o)
        }
        if (n.configMode) {
            var t = document.createElement("input");
            t.type = "image";
            t.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            if (n.mode == Light._CONFIG_MODE) {
                t.src = Light.portal.contextPath + "/light/images/leave_config_on.gif";
                t.onclick = function(){
                    n.cancelConfig();
                    n.moveAllowed()
                }
            }
            else {
                t.src = Light.portal.contextPath + "/light/images/config_on.gif";
                t.onclick = function(){
                    n.config();
                    n.moveAllowed()
                }
            }
            t.onmousedown = function(){
                n.moveCancel()
            };
            t.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            t.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(t)
        }
        var g = document.createElement("input");
        g.type = "image";
        g.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
        if (n.minimized) {
            g.src = Light.portal.contextPath + "/light/images/restore_on.gif"
        }
        else {
            g.src = Light.portal.contextPath + "/light/images/min_on.gif"
        }
        g.onclick = function(){
            n.minimize();
            n.moveAllowed()
        };
        g.onmousedown = function(){
            n.moveCancel()
        };
        g.onmouseover = function(){
            this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
        };
        g.onmouseout = function(){
            this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
        };
        h.appendChild(g);
        var f = document.createElement("input");
        f.type = "image";
        f.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
        if (n.maximized) {
            f.src = Light.portal.contextPath + "/light/images/restore_on.gif"
        }
        else {
            f.src = Light.portal.contextPath + "/light/images/max_on.gif"
        }
        f.onclick = function(){
            n.maximize();
            n.moveAllowed()
        };
        f.onmousedown = function(){
            n.moveCancel()
        };
        f.onmouseover = function(){
            this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
        };
        f.onmouseout = function(){
            this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
        };
        h.appendChild(f);
        if (n.closeable) {
            var c = document.createElement("input");
            c.type = "image";
            c.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            c.src = Light.portal.contextPath + "/light/images/close_on.gif";
            c.onclick = function(){
                n.close();
                n.moveAllowed()
            };
            c.onmousedown = function(){
                n.moveCancel()
            };
            c.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            c.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(c)
        }
    }
    return h
};

//position 0标题 1底部
WindowAppearance2.prototype.createPortletButton = function(n, position){
	//是否拥有管理的按钮(这里管理的按钮指"编辑" "配置" "删除")
	//底部栏不显示管理的按钮
	var hasManagerBtn = (position == 0);
	//是否拥有刷新按钮,如果是标题栏,则根据样式"标题栏是否包含刷新按钮"的值决定。否则，则是底部，则使用样式"底部是否包含刷新按钮"的值决定
	//(最小化,最大化按钮类同)
	var hasRefreshBtn = (position == 0 ? n.styleConfig.hasHeaderRefreshBtn : n.styleConfig.hasFooterRefreshBtn);
	var hasMinBtn = (position == 0 ? n.styleConfig.hasHeaderMinBtn : n.styleConfig.hasFooterMinBtn);
	var hasMaxBtn = (position == 0 ? n.styleConfig.hasHeaderMaxBtn : n.styleConfig.hasFooterMaxBtn);
	//刷新,最小化,最大化按钮的图片路径
	var refreshBtnPath = (position == 0 ? n.styleConfig.headerRefreshBtnPath : n.styleConfig.footerRefreshBtnPath);
	var minBtnPath = (position == 0 ? n.styleConfig.headerMinBtnPath : n.styleConfig.footerMinBtnPath);
	var maxBtnPath = (position == 0 ? n.styleConfig.headerMaxBtnPath : n.styleConfig.footerMaxBtnPath);
    var d = " <span title='" + LightResourceBundle._REFRESH_PORTLET + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + refreshBtnPath + "'  height='14' width='14' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' /></span>";
    var j = " <span title='" + LightResourceBundle._EDIT_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/edit_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' BORDER='0' /></span>";
    var i = " <span title='" + LightResourceBundle._VIEW_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/leave_edit_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var l = " <span title='" + LightResourceBundle._HELP_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/help_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var k = " <img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/leave_help_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' />";
    var e = " <span title='" + LightResourceBundle._CONFIG_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/config_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var s = " <span title='" + LightResourceBundle._VIEW_MODE + "'><img id='pngIcoUp' src='" + Light.portal.contextPath + "/light/images/leave_config_on.gif'  style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var p = " <span title='" + LightResourceBundle._MINIMIZED + "'><img id='pngIcoMin' src='" + Light.portal.contextPath + minBtnPath + "' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var r = " <span title='" + LightResourceBundle._RESTORE + "'><img id='pngIcoMax' src='" + Light.portal.contextPath + "/light/images/restore_on.gif' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var q = " <span title='" + LightResourceBundle._MAXIMIZED + "'><img id='pngIcoMax' src='" + Light.portal.contextPath + maxBtnPath + "' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var a = " <span title='" + LightResourceBundle._CLOSE + "'><img id='pngIcoClose' src='" + Light.portal.contextPath + "/light/images/close_on.gif' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' /></span>";
    var h = document.createElement("div");
    h.id = "portletHB_" + n.tIndex + "_" + n.position + "_" + n.index;
    if(position == 0){
    	h.className = "portlet-header-button";
    }else{
    	h.className = "portlet-footer-button";
    }
    h.style.visibility = "hidden";
    if (document.all) {
        if (n.refreshMode && hasRefreshBtn) {
            var b = document.createElement("a");
            b.id = 'a_refresh_' + n.serverId;
            b.innerHTML = d;
            b.href = "javascript:void(0)";
            b.onclick = function(){
                n.refresh();
                n.moveAllowed()
            };
            b.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(b)
        }
        if (n.helpMode) {
            var o = document.createElement("a");
            o.href = "javascript:void(0)";
            if (n.mode == Light._HELP_MODE) {
                o.innerHTML = k;
                o.onclick = function(){
                    n.cancelHelp();
                    n.moveAllowed()
                }
            }
            else {
                o.innerHTML = l;
                o.onclick = function(){
                    n.help();
                    n.moveAllowed()
                }
            }
            o.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(o)
        }
        if (Light.portal.tabs[n.tIndex].absolute != 1 && hasMinBtn) {
            var g = document.createElement("a");
            if (n.minimized) {
                g.innerHTML = r
            }
            else {
                g.innerHTML = p
            }
            g.href = "javascript:void(0)";
            g.onclick = function(){
                n.minimize();
                n.moveAllowed()
            };
            g.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(g)
        }
        if(hasMaxBtn){
	        var f = document.createElement("a");
	        if (n.maximized) {
	            f.innerHTML = r
	        }
	        else {
	            f.innerHTML = q
	        }
	        f.href = "javascript:void(0)";
	        f.onclick = function(){
	            n.maximize();
	            n.moveAllowed()
	        };
	        f.onmousedown = function(){
	            n.moveCancel()
	        };
	        h.appendChild(f);
        }
        if (n.editMode && hasManagerBtn) {
            var m = document.createElement("a");
            m.href = "javascript:void(0)";
            if (n.mode == Light._EDIT_MODE) {
                m.innerHTML = i;
                m.onclick = function(){
                    n.cancelEdit();
                    n.moveAllowed()
                }
            }
            else {
                m.innerHTML = j;
                m.onclick = function(){
                    n.edit();
                    n.moveAllowed()
                }
            }
            m.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(m)
        }
        if (n.configMode && hasManagerBtn) {
            var t = document.createElement("a");
            t.href = "javascript:void(0)";
            if (n.mode == Light._CONFIG_MODE) {
                t.innerHTML = s;
                t.onclick = function(){
                    n.cancelConfig();
                    n.moveAllowed()
                }
            }
            else {
                t.innerHTML = e;
                t.onclick = function(){
                    n.config();
                    n.moveAllowed()
                }
            }
            t.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(t);
        }
        if (n.closeable && hasManagerBtn) {
            var c = document.createElement("a");
            c.innerHTML = a;
            c.href = "javascript:void(0)";
            c.onclick = function(){
                n.close();
                n.moveAllowed()
            };
            c.onmousedown = function(){
                n.moveCancel()
            };
            h.appendChild(c)
        }
    }
    else {
      	if (n.refreshMode && hasRefreshBtn) {
            var b = document.createElement("input");
            b.type = "image";
            b.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            b.src = Light.portal.contextPath + "/light/images/refresh_on.gif";
            b.onclick = function(){
                n.refresh();
                n.moveAllowed()
            };
            b.onmousedown = function(){
                n.moveCancel()
            };
            b.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            b.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(b)
        }
        if (n.helpMode) {
            var o = document.createElement("input");
            o.type = "image";
            o.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            if (n.mode == Light._HELP_MODE) {
                o.src = Light.portal.contextPath + "/light/images/leave_help_on.gif";
                o.onclick = function(){
                    n.cancelHelp();
                    n.moveAllowed()
                }
            }
            else {
                o.src = Light.portal.contextPath + "/light/images/help_on.gif";
                o.onclick = function(){
                    n.help();
                    n.moveAllowed()
                }
            }
            o.onmousedown = function(){
                n.moveCancel()
            };
            o.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            o.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(o)
        }
        if(hasMinBtn){
	        var g = document.createElement("input");
	        g.type = "image";
	        g.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
	        if (n.minimized) {
	            g.src = Light.portal.contextPath + "/light/images/restore_on.gif"
	        }
	        else {
	            g.src = Light.portal.contextPath + "/light/images/min_on.gif"
	        }
	        g.onclick = function(){
	            n.minimize();
	            n.moveAllowed()
	        };
	        g.onmousedown = function(){
	            n.moveCancel()
	        };
	        g.onmouseover = function(){
	            this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
	        };
	        g.onmouseout = function(){
	            this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
	        };
	        h.appendChild(g);
        }
        if(hasMaxBtn){
	        var f = document.createElement("input");
	        f.type = "image";
	        f.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
	        if (n.maximized) {
	            f.src = Light.portal.contextPath + "/light/images/restore_on.gif"
	        }
	        else {
	            f.src = Light.portal.contextPath + "/light/images/max_on.gif"
	        }
	        f.onclick = function(){
	            n.maximize();
	            n.moveAllowed()
	        };
	        f.onmousedown = function(){
	            n.moveCancel()
	        };
	        f.onmouseover = function(){
	            this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
	        };
	        f.onmouseout = function(){
	            this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
	        };
	        h.appendChild(f);
        }
        if (n.editMode && hasManagerBtn) {
            var m = document.createElement("input");
            m.type = "image";
            m.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            if (n.mode == Light._EDIT_MODE) {
                m.src = Light.portal.contextPath + "/light/images/leave_edit_on.gif";
                m.onclick = function(){
                    n.cancelEdit();
                    n.moveAllowed()
                }
            }
            else {
                m.src = Light.portal.contextPath + "/light/images/edit_on.gif";
                m.onclick = function(){
                    n.edit();
                    n.moveAllowed()
                }
            }
            m.onmousedown = function(){
                n.moveCancel()
            };
            m.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            m.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(m)
        }
        if (n.configMode && hasManagerBtn) {
            var t = document.createElement("input");
            t.type = "image";
            t.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            if (n.mode == Light._CONFIG_MODE) {
                t.src = Light.portal.contextPath + "/light/images/leave_config_on.gif";
                t.onclick = function(){
                    n.cancelConfig();
                    n.moveAllowed()
                }
            }
            else {
                t.src = Light.portal.contextPath + "/light/images/config_on.gif";
                t.onclick = function(){
                    n.config();
                    n.moveAllowed()
                }
            }
            t.onmousedown = function(){
                n.moveCancel()
            };
            t.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            t.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(t)
        }
        if (n.closeable && hasManagerBtn) {
            var c = document.createElement("input");
            c.type = "image";
            c.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);");
            c.src = Light.portal.contextPath + "/light/images/close_on.gif";
            c.onclick = function(){
                n.close();
                n.moveAllowed()
            };
            c.onmousedown = function(){
                n.moveCancel()
            };
            c.onmouseover = function(){
                this.setAttribute("style", "border: 0px;-MozOpacity:1;filters.alpha(opacity=70);")
            };
            c.onmouseout = function(){
                this.setAttribute("style", "border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);")
            };
            h.appendChild(c)
        }
    }
    return h
};


WindowAppearance2.prototype.createPortletContainer = function(b){
    var a = document.createElement("div");
    a.id = Light._PC_PREFIX + b.tIndex + "_" + b.position + "_" + b.index;
    a.onmousedown = function(){
        b.focus()
    };
    if (b.contentBgColor.length > 0) {
        a.style.backgroundColor = b.contentBgColor
    }
    else {
        if (Light.portal.portletWindowTransparent == false) {
            a.style.backgroundColor = "#ffffff"
        }
        else {
            a.style.backgroundColor = ""
        }
    }
    return a
};

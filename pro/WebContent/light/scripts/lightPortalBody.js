LightPortalBody = function(a){
    this.layout = {
        left: 0,
        right: 80,
        top: 0
    };
    this.portal = a;
    if (this.portal == null) {
        this.portal = Light.portal
    }
    this.container = this.createContainer(null);
    log("initialize portal body")
};
LightPortalBody.prototype.createContainer = function(){
    var a = document.createElement("div");
    a.id = "portalBody";
    a.className = "portal-body";
    a.innerHTML = "<div id='tabs' class='portal-tabs' ><ul id='tabList'></ul></div><div id='tabPanels' class='portal-tab-panels' ></div>";
    a.style.zIndex = ++Light.maxZIndex;
    if (document.all) {
        a.style.posLeft = this.layout.left;
        a.style.posTop = this.layout.top + parseInt(this.portal.header.layout.height)
    }
    else {
        a.style.left = this.layout.left;
        a.style.top = this.layout.top + parseInt(this.portal.header.layout.height)
    }
    return a
};

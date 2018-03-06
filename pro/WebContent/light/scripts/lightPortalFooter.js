LightPortalFooter = function(a){
    this.layout = {
        left: 10,
        right: 0,
        top: 150
    };
    this.portal = a;
    if (this.portal == null) {
        this.portal = Light.portal
    }
    this.container = this.createContainer(null);
    log("initialize portal footer")
};
LightPortalFooter.prototype.createContainer = function(){
    var b = document.createElement("span");
    return b;
    var b = document.createElement("div");
    b.id = "portalFooter";
    b.className = "portal-footer";
    var a = " <a href='http://light.dev.java.net/' target='_blank' ><img src='" + Light.portal.contextPath + "/light/images/portalLogo.gif' style= 'border: 0px;-moz-opacity:0.5;filter:alpha(opacity=50);'  onmouseover= 'this.style.MozOpacity=1;this.filters.alpha.opacity=100'  onmouseout= 'this.style.MozOpacity=0.5;this.filters.alpha.opacity=50'  /></a>";
    a = "<a href='http://light.dev.java.net/' target='_blank' >Powered by Light Portal</a>";
    b.innerHTML = a;
    if (document.all) {
        b.style.posLeft = this.layout.left;
        b.style.posTop = this.portal.body.layout.top + this.layout.top
    }
    else {
        b.style.left = this.layout.left;
        b.style.top = this.portal.body.layout.top + this.layout.top
    }
    b.style.zIndex = ++Light.maxZIndex;
    return b
};
LightPortalFooter.prototype.reposition = function(){
    return;
    var a = this.portal.getMaxHeight();
    if (document.all) {
        this.container.style.posTop = a
    }
    else {
        this.container.style.top = a
    }
    if (a > this.portal.layout.height) {
        this.portal.container.style.height = a
    }
};

LightPortalHeader = function(d, b, a, c){
    this.layout = {
        left: 0,
        right: 0,
        top: 0,
        height: 0
    };
    this.title = b;
    this.image = a;
    this.portal = d;
    if (this.portal == null) {
        this.portal = Light.portal
    }
    this.container = this.createContainer();
    log("initialize portal header")
};
LightPortalHeader.prototype.createContainer = function(){
    var b = document.createElement("span");
    return b;
    var b = document.createElement("div");
    b.className = "portal-header";
    if (this.image.length > 0) {
        if (this.image != "no") {
            b.style.background = "url('" + this.image + "')"
        }
        else {
            if (this.portal.bgImage.length > 0 && this.portal.bgImage != "no") {
                b.style.background = "url('" + this.portal.bgImage + "')"
            }
            else {
                if (document.all) {
                    var d = document.styleSheets[0].rules
                }
                else {
                    var d = document.styleSheets[0].cssRules
                }
                var c = d[0].style.background;
                if (c == "") {
                    c = "#ffffff"
                }
                b.style.background = c
            }
        }
    }
    b.style.height = this.layout.height;
    var g = document.createElement("span");
    g.className = "portal-header-title";
    if (this.title.trim().length == 0) {
        g.innerHTML = "<input type='text' name='portalTitle' class='portal-header-title-edit' size='24' value='' onchange=\"javascript:Light.portal.saveTitle();\" onblur=\"javascript:Light.portal.saveTitle();\"/>"
    }
    else {
        g.innerHTML = "<span class='portal-header-title-view' >" + this.title + "</span>"
    }
    b.appendChild(g);
    var f = document.createElement("span");
    f.className = "portal-header-logo";
    var e = navigator.appVersion.split("MSIE");
    var a = parseFloat(e[1]);
    var h = " <img src='" + this.portal.contextPath + "/light/images/logo.png'style='border: 0px;'/>";
    if ((a >= 5.5) && (document.body.filters)) {
        h = "<span style=\"border: 0px; display:inline-block; width: 200px; height: 80px;filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + this.portal.contextPath + "/light/images/logo.png',sizingMethod='scale');\"></span>"
    }
    f.innerHTML = h;
    b.appendChild(f);
    b.style.zIndex = ++Light.maxZIndex;
    return b
};

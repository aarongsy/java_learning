LightPortalMenu = function(h, c, f, b, e, d, g, a){
    this.layout = {
        left: 0,
        right: 0,
        top: 0
    };
    this.portal = h;
    if (this.portal == null) {
        this.portal = Light.portal
    }
    this.allowLookAndFeel = c;
    this.allowLayout = f;
    this.allowAddTab = b;
    this.allowAddContent = e;
    this.allowSignIn = d;
    this.allowTurnOff = g;
    this.allowChangeLocale = a;
    this.container = this.createContainer(null);
    log("initialize portal Menu")
};
var expanded = true;
LightPortalMenu.prototype.createContainer = function(b){
    var l = document.createElement("div");
    l.id = "portalMenu";
    l.className = "portal-header-menu-item";
    l.style.position = "absolute";
    var r = document.createElement("span");
    r.className = "portal-header-menu-item";
    var s = document.createElement("span");
    s.innerHTML = "<img src='" + Light.portal.contextPath + "/js/ext/resources/images/default/layout/ns-expand.gif' style='border: 0px'   title='全部收缩'/>";
    s.onclick = d;
    r.appendChild(s);
    function d(){
        if (expanded) {
            expanded = false;
            s.innerHTML = "<img src='" + Light.portal.contextPath + "/js/ext/resources/images/default/layout/ns-collapse.gif' style='border: 0px'   title='全部展开'/>";
            Light.portal.collapseAll()
        }
        else {
            expanded = true;
            s.innerHTML = "<img src='" + Light.portal.contextPath + "/js/ext/resources/images/default/layout/ns-expand.gif' style='border: 0px'   title='全部收缩'/>";
            Light.portal.expandAll()
        }
    }
    if (this.allowLookAndFeel) {
        var q = document.createElement("a");
        q.innerHTML = LightResourceBundle._MENU_LOOK_AND_FEEL;
        q.href = "javascript:void(0)";
        q.onclick = function(){
            Light.portal.changeTheme()
        };
        r.appendChild(q);
        var j = document.createElement("span");
        j.className = "portal-header-menu-item-separater";
        j.innerHTML = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' style='border: 0px' />";
        r.appendChild(j)
    }
    if (this.allowLayout && (b == null || b.tabIsEditable)) {
        var p = document.createElement("a");
        p.innerHTML = LightResourceBundle._MENU_LAYOUT;
        p.href = "javascript:void(0)";
        p.onclick = function(){
            Light.portal.editTab()
        };
        r.appendChild(p);
        var g = document.createElement("span");
        g.className = "portal-header-menu-item-separater";
        g.innerHTML = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' style='border: 0px' />";
        r.appendChild(g)
    }
    if (this.allowAddContent && (b == null || b.allowAddContent)) {
        var o = document.createElement("a");
        o.innerHTML = LightResourceBundle._MENU_ADD_CONTENT;
        o.href = "javascript:void(0)";
        o.onclick = function(){
            Light.portal.addContent()
        };
        r.appendChild(o);
        var f = document.createElement("span");
        f.className = "portal-header-menu-item-separater";
        f.innerHTML = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' style='border: 0px' />";
        r.appendChild(f)
    }
    if (this.allowSignIn) {
        var n = document.createElement("a");
        var k = Light.getCookie(Light._LOGINED_USER_ID);
        if (Light.getCookie(Light._LOGINED_USER_ID) != null && Light.getCookie(Light._LOGINED_USER_ID) != "") {
            n.innerHTML = LightResourceBundle._MENU_SIGN_OUT;
            n.href = "javascript:void(0)";
            n.onclick = function(){
                Light.portal.logout()
            }
        }
        else {
            n.innerHTML = LightResourceBundle._MENU_SIGN_IN;
            n.href = "javascript:void(0)";
            n.onclick = function(){
                Light.portal.login()
            }
        }
        r.appendChild(n);
        var e = document.createElement("span");
        e.className = "portal-header-menu-item-separater";
        e.innerHTML = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' style='border: 0px' />";
        r.appendChild(e)
    }
    if (this.allowSignIn && Light.getCookie(Light._LOGINED_USER_ID) != null && Light.getCookie(Light._LOGINED_USER_ID) != "") {
        var n = document.createElement("a");
        n.innerHTML = LightResourceBundle._MENU_MY_PROFILE;
        n.href = "javascript:void(0)";
        n.onclick = function(){
            Light.portal.editProfile()
        };
        r.appendChild(n);
        var c = document.createElement("span");
        c.className = "portal-header-menu-item-separater";
        c.innerHTML = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' style='border: 0px' />";
        r.appendChild(c)
    }
    if (this.allowTurnOff) {
        var m = document.createElement("a");
        m.innerHTML = LightResourceBundle._MENU_TURN_OFF;
        m.href = "javascript:void(0)";
        m.onclick = function(){
            Light.switchPortal()
        };
        r.appendChild(m);
        var a = document.createElement("span");
        a.className = "portal-header-menu-item-separater";
        a.innerHTML = "<img src='" + Light.portal.contextPath + "/light/images/spacer.gif' style='border: 0px' />";
        r.appendChild(a)
    }
    if (this.allowChangeLocale) {
        var t = document.createElement("span");
        var h = "<select name='psEngine' size='1' class='portlet-form-select' onChange='javascript:changeLocale(this.value)'>";
        for (i = 0; i < Light.supportLocale.length; i++) {
            if (Light.locale == Light.supportLocale[i][1]) {
                h += "<option value='" + Light.supportLocale[i][1] + "' SELECTED>" + Light.supportLocale[i][0] + "</option>"
            }
            else {
                h += "<option value='" + Light.supportLocale[i][1] + "'>" + Light.supportLocale[i][0] + "</option>"
            }
        }
        h += "</select>";
        t.innerHTML = h;
        r.appendChild(t)
    }
    l.appendChild(r);
    l.style.zIndex = ++Light.maxZIndex;
    if (this.portal.layout.width <= 0) {
        this.portal.layout.width = Ext.getBody().getSize().width
    }
    if (this.portal.layout.height <= 0) {
        this.portal.layout.height = Ext.getBody().getSize().height
    }
    l.style.width = this.portal.layout.width;
    if (document.all) {
        l.style.posLeft = this.layout.left;
        l.style.top = parseInt(this.portal.header.layout.height)
    }
    else {
        l.style.left = this.layout.left;
        l.style.top = parseInt(this.portal.header.layout.height)
    }
    return l
};

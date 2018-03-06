Light.setCookie = function(b, d, a, f, c, e) {
    document.cookie = b + "=" + escape(d) + ((a) ? "; expires=" + a.toGMTString() : "") + ((f) ? "; path=" + f: "") + ((c) ? "; domain=" + c: "") + ((e) ? "; secure": "")
};
Light.getCookie = function(c) {
    var b = document.cookie;
    var e = c + "=";
    var d = b.indexOf("; " + e);
    if (d == -1) {
        d = b.indexOf(e);
        if (d != 0) {
            return null
        }
    } else {
        d += 2
    }
    var a = document.cookie.indexOf(";", d);
    if (a == -1) {
        a = b.length
    }
    return unescape(b.substring(d + e.length, a))
};
Light.deleteCookie = function(a, c, b) {
    if (Light.getCookie(a)) {
        document.cookie = a + "=" + ((c) ? "; path=" + c: "") + ((b) ? "; domain=" + b: "") + "; expires=Thu, 01-Jan-70 00:00:01 GMT"
    }
};
Light.getScrollerWidth = function() {
    if (Light.scrollWidth != null) {
        return Light.scrollWidth
    }
    var d = null;
    var c = null;
    var a = 0;
    var b = 0;
    d = document.createElement("div");
    d.style.position = "absolute";
    d.style.top = "-1000px";
    d.style.left = "-1000px";
    d.style.width = "100px";
    d.style.height = "50px";
    d.style.overflow = "hidden";
    c = document.createElement("div");
    c.style.width = "100%";
    c.style.height = "200px";
    d.appendChild(c);
    document.body.appendChild(d);
    a = c.offsetWidth;
    d.style.overflow = "auto";
    b = c.offsetWidth;
    document.body.removeChild(document.body.lastChild);
    Light.scrollWidth = (a - b);
    return Light.scrollWidth
};
String.prototype.isDigit = function() {
    if (this.length > 1) {
        return false
    }
    var a = "1234567890";
    if (a.indexOf(this) != -1) {
        return true
    }
    return false
};
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "")
};
function log(a) {
    if (Light.logLevel != "DEBUG") {
        return
    }
    if (!log.window_ || log.window_.closed) {
        var c = window.open("", null, "width=400,height=200,scrollbars=yes,resizable=yes,status=no,location=no,menubar=no,toolbar=no");
        if (!c) {
            return
        }
        var b = c.document;
        b.write("<html><head><title>Debug Log</title></head><body></body></html>");
        b.close();
        log.window_ = c
    }
    var d = log.window_.document.createElement("div");
    d.appendChild(log.window_.document.createTextNode(a));
    log.window_.document.body.appendChild(d);
    d = null
};
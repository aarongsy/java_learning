
if (window.DOMParser && window.XMLSerializer && window.Node && Node.prototype && Node.prototype.__defineGetter__) {
    if (!Document.prototype.loadXML) {
        Document.prototype.loadXML = function(b){
            var c = (new DOMParser()).parseFromString(b, "text/xml");
            while (this.hasChildNodes()) {
                this.removeChild(this.lastChild)
            }
            for (var a = 0; a < c.childNodes.length; a++) {
                this.appendChild(this.importNode(c.childNodes[a], true))
            }
        }
    }
    Document.prototype.__defineGetter__("xml", function(){
        return (new XMLSerializer()).serializeToString(this)
    })
}
Light.Ajax = function(){
    log("initialize Light.Ajax")
};
Light.Ajax.prototype.sendRequestAndUpdate = function(e, a, b){
    var c = Light.getPortletById(a);
    var d = b.parameters;
    if (b.postBody != null && b.postBody.length > 0) {
        d = b.postBody
    }
    Ext.Ajax.request({
        url: Light.portal.contextPath + c.requestUrl,
        params: d,
        success: function(f){
            Light.ajax.onRequestComplete(f)
        }
    })
};
Light.Ajax.prototype.sendRequest = function(c, a){
    var b = a.parameters;
    if (a.postBody != null && a.postBody.length > 0) {
        b = a.postBody
    }
    Ext.Ajax.request({
        url: c,
        params: b,
        success: function(d){
            if (a.onSuccess != null) {
                a.onSuccess(d)
            }
        }
    })
};
Light.Ajax.prototype.onRequestComplete = function(d){
    if (d.responseText != null) {
        try {
            var c = d.responseText;
            var b = c.indexOf("id='");
            c = c.substring(b + 4);
            b = c.indexOf("'");
            var a = c.substring(0, b);
            b = c.indexOf("<div>");
            c = c.substring(b);
            b = c.indexOf("</response>");
            c = c.substring(0, b);
            Light.portal.setPortletContent(a, c)
        } 
        catch (f) {
        }
    }
    else {
    }
};
Light.Ajax.prototype.processAjaxResponse = function(c){
    for (var b = 0; b < c.length; b++) {
        var d = c[b];
        if (d.nodeType != 1) {
            continue
        }
        var a = d.getAttribute("id");
        Light.portal.setPortletContent(a, Light.ajax.getContentAsString(d))
    }
};
Light.Ajax.prototype.getContentAsString = function(a){
    return a.xml != undefined ? Light.ajax.getContentAsStringIE(a) : Light.ajax.getContentAsStringMozilla(a)
};
Light.Ajax.prototype.getContentAsStringIE = function(a){
    var c = "";
    for (var b = 0; b < a.childNodes.length; b++) {
        var d = a.childNodes[b];
        if (d.nodeType == 4) {
            c += d.nodeValue
        }
        else {
            c += d.xml
        }
    }
    return c
};
Light.Ajax.prototype.getContentAsStringMozilla = function(b){
    var a = new XMLSerializer();
    var d = "";
    for (var c = 0; c < b.childNodes.length; c++) {
        var e = b.childNodes[c];
        if (e.nodeType == 4) {
            d += e.nodeValue
        }
        else {
            d += a.serializeToString(e)
        }
    }
    return d
};
Light.Ajax.prototype.getXmlHttpObject = function(){
    var a;
    try {
        a = new ActiveXObject("Msxml2.XMLHTTP")
    } 
    catch (c) {
        try {
            a = new ActiveXObject("Microsoft.XMLHTTP")
        } 
        catch (b) {
            a = false
        }
    }
    if (!a && typeof XMLHttpRequest != "undefined") {
        try {
            a = new XMLHttpRequest()
        } 
        catch (c) {
            a = false
        }
    }
    return a
};

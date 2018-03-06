function showRssDesc(i, h, a){
    if (Light.portal == null) {
        return
    }
    var c = Light.portal.GetFocusedTabId();
    var b = c.substring(8, c.length);
    var m = Light.getPortletById(a);
    if (m == null) {
        return
    }
    var l = document.getElementById("panel_tab_page" + b);
    var d = document.getElementById("rssDesc");
    if (d != null) {
        l.removeChild(d)
    }
    var g = document.createElement("div");
    g.id = "rssDesc";
    g.style.position = "absolute";
    g.onmouseout = function(){
        hideRssDesc()
    };
    var k = 0;
    var j = 0;
    if (window.event) {
        k = event.clientX + document.body.scrollLeft + 10;
        j = event.clientY + document.body.scrollTop - 100
    }
    else {
        k = i.pageX + 10;
        j = i.pageY - 100
    }
    if (document.all) {
        g.style.posLeft = k;
        g.style.posTop = j
    }
    else {
        g.style.left = k;
        g.style.top = j
    }
    g.style.zIndex = Light.maxZIndex;
    l.appendChild(g);
    var f = "index=" + h + "&" + m.parameter
}

hideRssDesc = function(){
    var c = Light.portal.GetFocusedTabId();
    var a = c.substring(8, c.length);
    var d = document.getElementById("panel_tab_page" + a);
    var b = document.getElementById("rssDesc");
    if (b != null) {
        d.removeChild(b)
    }
};
function responseRssDesc(i){
    var e = i.responseText;
    var b = Light.portal.GetFocusedTabId();
    var a = b.substring(8, b.length);
    var h = document.getElementById("panel_tab_page" + a);
    var c = document.getElementById("rssDesc");
    var g = 100;
    var f = 100;
    if (c != null) {
        if (document.all) {
            g = c.style.posLeft;
            f = c.style.posTop
        }
        else {
            g = c.style.left;
            f = c.style.top
        }
        h.removeChild(c);
        var d = document.createElement("div");
        d.id = "rssDesc";
        d.style.position = "absolute";
        d.style.width = 300;
        d.onmouseout = function(){
            hideRssDesc()
        };
        d.className = "portlet-popup";
        d.innerHTML = e;
        if (document.all) {
            d.style.posLeft = g;
            d.style.posTop = f
        }
        else {
            d.style.left = g;
            d.style.top = f
        }
        d.style.zIndex = Light.maxZIndex + 10;
        h.appendChild(d)
    }
}

function editRssPortlet(b){
    var j = document.forms["form_" + b]["prFeed"].value;
    var h = document.forms["form_" + b]["prTitle"].value;
    var title = h;
    while(h.indexOf('&')>=0){
    	h = h.replace("&","\\U0026");
    }while(h.indexOf('+')>=0){
    	h = h.replace("+","\\U002B");
    }while(h.indexOf('%')>=0){
    	h = h.replace("%","\\U0025");
    }
    var g = document.forms["form_" + b]["prIcon"].value;
    var a = document.forms["form_" + b]["prUrl"].value;
    var c = document.forms["form_" + b]["prAuto"].value;
    var e = document.forms["form_" + b]["prMinute"].value;
    var f = document.forms["form_" + b]["prItems"].value;
    if (c == "1" && e == "0") {
        alert(LightResourceBundle._ERROR_MINUTE_RATE);
        return
    }
    var i = Light.getPortletById(b);
    i.title = title;
    i.icon = g;
    i.url = a;
    i.parameter = "feed=" + j;
    i.refreshHeader();
    if (c == "1") {
        i.autoRefreshed = true
    }
    else {
        i.autoRefreshed = false
    }
    i.periodTime = e * 60000;
    i.autoRefresh();
    var d = "responseId=" + b + "&tabId=" + Light.portal.tabs[i.tIndex].tabServerId + "&portletId=" + i.serverId + "&mode=" + Light._EDIT_MODE + "&action=edit&title=" + h + "&url=" + a + "&icon=" + g + "&autoRefresh=" + c + "&minute=" + e + "&items=" + f + "&feed=" + j;
    Light.ajax.sendRequestAndUpdate(i.request, b, {
        evalScripts: i.allowJS,
        parameters: d
    });
    i.cancelEdit();
}

function keyDownSearchWeather(b, c){
    var a;
    if (window.event) {
        keyID = window.event.keyCode
    }
    else {
        keyID = b.which
    }
    if (keyID == 13) {
        searchWeatherLocation(c)
    }
    return !(keyID == 13)
}

function searchWeatherLocation(d){
    var c = document.forms["form_" + d]["pwLocation"].value;
    var b = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&locName=" + c;
    Light.ajax.sendRequestAndUpdate(b.request, d, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function selectWeatherLocation(g){
    var e = document.forms["form_" + g]["pwLocId"].value;
    if (!e) {
        var a = document.forms["form_" + g]["pwLocId"].length;
        for (var c = 0; c < a; c++) {
            if (document.forms["form_" + g]["pwLocId"][c].checked) {
                e = document.forms["form_" + g]["pwLocId"][c].value
            }
        }
    }
    var d = document.forms["form_" + g]["pwUnit"].value;
    var f = Light.getPortletById(g);
    var b = "responseId=" + g + "&tabId=" + Light.portal.tabs[f.tIndex].tabServerId + "&portletId=" + f.serverId + "&action=select&locId=" + e + "&unit=" + d;
    Light.ajax.sendRequestAndUpdate(f.request, g, {
        evalScripts: f.allowJS,
        parameters: b
    })
}

function keyDownEditWeather(b, c){
    var a;
    if (window.event) {
        keyID = window.event.keyCode
    }
    else {
        keyID = b.which
    }
    if (keyID == 13) {
        editWeatherLocation(c)
    }
    return !(keyID == 13)
}

function editWeatherLocation(d){
    var c = document.forms["form_" + d]["pwLocation"].value;
    var b = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&mode=" + Light._EDIT_MODE + "&locName=" + c;
    Light.ajax.sendRequestAndUpdate(b.request, d, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

changeStatus = function(d, a){
    var c = Light.getPortletById(d);
    var b = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&action=changeStatus&name=" + encodeURIComponent(a);
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: b
    })
};
function previousImage(d){
    var b = document.forms["form_" + d]["pvNumber"].value;
    b = parseInt(b) - 1;
    var c = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&" + c.parameter + "&number=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    })
}

function nextImage(d){
    var b = document.forms["form_" + d]["pvNumber"].value;
    b = parseInt(b) + 1;
    var c = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&" + c.parameter + "&number=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    })
}

function previousVideo(d){
    var b = document.forms["form_" + d]["pvNumber"].value;
    b = parseInt(b) - 1;
    var c = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&" + c.parameter + "&number=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    })
}

function nextVideo(d){
    var b = document.forms["form_" + d]["pvNumber"].value;
    b = parseInt(b) + 1;
    var c = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&" + c.parameter + "&number=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    })
}

function editViewerPortlet(g){
    var d = document.forms["form_" + g]["prFeed"].value;
    var f = document.forms["form_" + g]["prTitle"].value;
    var c = document.forms["form_" + g]["prIcon"].value;
    var a = document.forms["form_" + g]["prUrl"].value;
    var e = Light.getPortletById(g);
    e.title = f;
    e.icon = c;
    e.url = a;
    e.parameter = "feed=" + d;
    e.refreshHeader();
    var b = "responseId=" + g + "&tabId=" + Light.portal.tabs[e.tIndex].tabServerId + "&portletId=" + e.serverId + "&mode=" + Light._EDIT_MODE + "&action=edit&title=" + f + "&url=" + a + "&icon=" + c + "&feed=" + d;
    Light.ajax.sendRequestAndUpdate(e.request, g, {
        evalScripts: e.allowJS,
        parameters: b
    })
}

function createPopupDiv(a, o, d, i, j, c){
    var g = document.getElementById(a);
    if (g != null) {
        return
    }
    var h = Light.portal.GetFocusedTabId();
    var f = h.substring(8, h.length);
    var m = document.getElementById("panel_tab_page" + f);
    var b = document.createElement("div");
    b.id = a;
    b.style.position = "absolute";
    b.className = "portlet-popup";
    if (d != null) {
        b.style.width = d
    }
    b.innerHTML = TrimPath.processDOMTemplate(o, i);
    var l = 0;
    var k = 0;
    if (window.event) {
        l = event.clientX + document.body.scrollLeft;
        k = event.clientY + document.body.scrollTop - 100
    }
    else {
        l = j.pageX;
        k = j.pageY - 100
    }
    if (document.all) {
        b.style.posLeft = 280;
        b.style.posTop = 0
    }
    else {
        b.style.left = l;
        b.style.top = k
    }
    var n = Light.getPortletById(c);
    b.style.zIndex = Light.maxZIndex + 1500;
    m.appendChild(b)
}

changeNoteRow = function(d, h){
    var b = document.forms["form_" + h]["content"];
    var c = b.value;
    var g = parseInt(c.length / b.cols);
    for (var a = 0; a < c.length; a++) {
        if (c.charAt(a) == "\n") {
            g++
        }
    }
    b.rows = g + 2;
    var f = Light.getPortletById(h);
    Light.portal.tabs[f.tIndex].rePositionPortlets(f)
};
function showBookmarkDesc(i, h, a){
    if (Light.portal == null) {
        return
    }
    var c = Light.portal.GetFocusedTabId();
    var b = c.substring(8, c.length);
    var m = Light.getPortletById(a);
    if (m == null) {
        return
    }
    var l = document.getElementById("panel_tab_page" + b);
    var d = document.getElementById("bookmarkDesc");
    if (d != null) {
        l.removeChild(d)
    }
    var g = document.createElement("div");
    g.id = "bookmarkDesc";
    g.style.position = "absolute";
    g.onmouseout = function(){
        hideBookmarkDesc()
    };
    var k = 0;
    var j = 0;
    if (window.event) {
        k = event.clientX + document.body.scrollLeft + 10;
        j = event.clientY + document.body.scrollTop - 100
    }
    else {
        k = i.pageX + 10;
        j = i.pageY - 100
    }
    if (document.all) {
        g.style.posLeft = k;
        g.style.posTop = j
    }
    else {
        g.style.left = k;
        g.style.top = j
    }
    g.style.zIndex = Light.maxZIndex;
    l.appendChild(g);
    var f = "index=" + h + "&" + m.parameter;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.getBookmarkDesc, {
        parameters: f,
        onSuccess: responseBookmarkDesc
    })
}

hideBookmarkDesc = function(){
    var c = Light.portal.GetFocusedTabId();
    var a = c.substring(8, c.length);
    var d = document.getElementById("panel_tab_page" + a);
    var b = document.getElementById("bookmarkDesc");
    if (b != null) {
        d.removeChild(b)
    }
};
function responseBookmarkDesc(i){
    var e = i.responseText;
    var b = Light.portal.GetFocusedTabId();
    var a = b.substring(8, b.length);
    var h = document.getElementById("panel_tab_page" + a);
    var c = document.getElementById("bookmarkDesc");
    var g = 100;
    var f = 100;
    if (c != null) {
        if (document.all) {
            g = c.style.posLeft;
            f = c.style.posTop
        }
        else {
            g = c.style.left;
            f = c.style.top
        }
        h.removeChild(c);
        var d = document.createElement("div");
        d.id = "bookmarkDesc";
        d.style.position = "absolute";
        d.style.width = 300;
        d.onmouseout = function(){
            hideBookmarkDesc()
        };
        d.className = "portlet-popup";
        d.innerHTML = e;
        if (document.all) {
            d.style.posLeft = g;
            d.style.posTop = f
        }
        else {
            d.style.left = g;
            d.style.top = f
        }
        d.style.zIndex = Light.maxZIndex + 10;
        h.appendChild(d)
    }
}

function showDeliDesc(i, h, a){
    if (Light.portal == null) {
        return
    }
    var c = Light.portal.GetFocusedTabId();
    var b = c.substring(8, c.length);
    var m = Light.getPortletById(a);
    if (m == null) {
        return
    }
    var l = document.getElementById("panel_tab_page" + b);
    var d = document.getElementById("bookmarkDesc");
    if (d != null) {
        l.removeChild(d)
    }
    var g = document.createElement("div");
    g.id = "bookmarkDesc";
    g.style.position = "absolute";
    g.onmouseout = function(){
        hideDeliDesc()
    };
    var k = 0;
    var j = 0;
    if (window.event) {
        k = event.clientX + document.body.scrollLeft + 10;
        j = event.clientY + document.body.scrollTop - 100
    }
    else {
        k = i.pageX + 10;
        j = i.pageY - 100
    }
    if (document.all) {
        g.style.posLeft = k;
        g.style.posTop = j
    }
    else {
        g.style.left = k;
        g.style.top = j
    }
    g.style.zIndex = Light.maxZIndex;
    l.appendChild(g);
    var f = "index=" + h + "&" + m.parameter;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.getDeliDesc, {
        parameters: f,
        onSuccess: responseDeliDesc
    })
}

hideDeliDesc = function(){
    var c = Light.portal.GetFocusedTabId();
    var a = c.substring(8, c.length);
    var d = document.getElementById("panel_tab_page" + a);
    var b = document.getElementById("bookmarkDesc");
    if (b != null) {
        d.removeChild(b)
    }
};
function responseDeliDesc(i){
    var e = i.responseText;
    var b = Light.portal.GetFocusedTabId();
    var a = b.substring(8, b.length);
    var h = document.getElementById("panel_tab_page" + a);
    var c = document.getElementById("bookmarkDesc");
    var g = 100;
    var f = 100;
    if (c != null) {
        if (document.all) {
            g = c.style.posLeft;
            f = c.style.posTop
        }
        else {
            g = c.style.left;
            f = c.style.top
        }
        h.removeChild(c);
        var d = document.createElement("div");
        d.id = "bookmarkDesc";
        d.style.position = "absolute";
        d.style.width = 300;
        d.onmouseout = function(){
            hideDeliDesc()
        };
        d.className = "portlet-popup";
        d.innerHTML = e;
        if (document.all) {
            d.style.posLeft = g;
            d.style.posTop = f
        }
        else {
            d.style.left = g;
            d.style.top = f
        }
        d.style.zIndex = Light.maxZIndex + 10;
        h.appendChild(d)
    }
}

function startCallback(b){
    var a = Light.getPortletById(b);
    return true
}

function completeCallback(b){
    var a = Light.getPortletById(b);
    a.refresh()
}

setColor = function(e, d, b){
    var c = Light.getPortletById(e);
    if (c == null) {
        return
    }
    if (d == 1) {
        c.barBgColor = b;
        c.refreshHeader()
    }
    if (d == 2) {
        c.barFontColor = b;
        c.refreshHeader()
    }
    if (d == 3) {
        c.contentBgColor = b;
        var a = document.forms["form_" + e];
        a.style.background = b
    }
};
function configPortlet(d){
    var c = Light.getPortletById(d);
    var form = document.forms["form_" + d];
    var configId = form["configId"].value;
    var portletStyleId = form["portletStyleId"].value;
    var colspan = form["colspan"].value;
    c.colspan = parseInt(colspan);
  	c.refreshWidth();
  	if (c.position == 0) {
        c.width += Light.portal.tabs[c.tIndex].between;
    }
    c.refreshWindow();
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&configId=" + configId + "&portletStyleId=" + portletStyleId + "&colspan=" + colspan;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.configPortlet, {
        parameters: a,
        onSuccess: responseChangeMode
    })
}

function cancelConfigPortlet(d){
	var b = Light.getPortletById(d);
    b.cancelConfig()
}

function responseChangeMode(a){
    var c = a.responseText;
    var b = Light.getPortletById(c);
    b.cancelConfig();
    if (Light.portal.tabs[b.tIndex].absolute != 1) {
    	Light.portal.tabs[b.tIndex].rePositionAll();
    }
}

function defaultConfigPortlet(d){
    var c = document.forms["form_" + d]["pcTitle"].value;
    var b = Light.getPortletById(d);
    b.title = c;
    b.barBgColor = "";
    b.barFontColor = "";
    b.contentBgColor = "";
    b.textColor = "";
    b.refreshWindow();
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&title=" + encodeURIComponent(c);
    Light.ajax.sendRequest(Light.portal.contextPath + Light.changeMode, {
        parameters: a,
        onSuccess: responseChangeMode
    })
};

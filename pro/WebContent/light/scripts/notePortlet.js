saveNote = function(c){
    var a = document.forms["form_" + c]["content"].value;
    var b = "content=" + encodeURIComponent(a);
    Light.ajax.sendRequest(Light.portal.contextPath + Light.saveNote, {
        parameters: b,
        onSuccess: null
    })
};
function configNote(h){
    var g = document.forms["form_" + h]["pcTitle"].value;
    var f = document.forms["form_" + h]["pcBarBgColor"].value;
    var a = document.forms["form_" + h]["pcBarFontColor"].value;
    var b = document.forms["form_" + h]["pcContentBgColor"].value;
    var d = document.forms["form_" + h]["pcTextColor"].value;
    var e = Light.getPortletById(h);
    e.title = g;
    e.barBgColor = f;
    e.barFontColor = a;
    e.contentBgColor = b;
    e.refreshWindow();
    var c = "responseId=" + h + "&tabId=" + Light.portal.tabs[e.tIndex].tabServerId + "&portletId=" + e.serverId + "&mode=" + Light._EDIT_MODE + "&action=config&title=" + encodeURIComponent(g) + "&barBgColor=" + f + "&barFontColor=" + a + "&contentBgColor=" + b + "&textColor=" + d;
    Light.ajax.sendRequestAndUpdate(e.request, h, {
        evalScripts: e.allowJS,
        parameters: c
    })
}

function resetNote(d){
    var c = document.forms["form_" + d]["pcTitle"].value;
    var b = Light.getPortletById(d);
    b.title = c;
    b.barBgColor = "";
    b.barFontColor = "";
    b.contentBgColor = "";
    b.refreshWindow();
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=reset&action=config&title=" + encodeURIComponent(c);
    Light.ajax.sendRequestAndUpdate(b.request, d, {
        evalScripts: b.allowJS,
        parameters: a
    })
};

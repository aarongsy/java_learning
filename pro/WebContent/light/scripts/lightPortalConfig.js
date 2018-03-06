function changeLocale(a){
    if (Light.getCookie(Light._USER_LOCALE) != null && Light.getCookie(Light._USER_LOCALE) != "") {
        Light.deleteCookie(Light._USER_LOCALE)
    }
    var b = new Date();
    b.setFullYear(b.getFullYear() + 1);
    Light.setCookie(Light._USER_LOCALE, a, b);
    var c = "locale=" + a;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.changeLocale, {
        parameters: c,
        onSuccess: responseChangeLocale
    })
}

function responseChangeLocale(){
    window.location.reload(true)
}

function changeTheme(a){
    var g = document.forms["form_" + a]["ptTheme"].length;
    var d = null;
    for (var e = 0; e < g; e++) {
        if (document.forms["form_" + a]["ptTheme"][e].checked) {
            d = document.forms["form_" + a]["ptTheme"][e].value
        }
    }
    var h = null;
    if (typeof Light.portal.newBgImage != "undefined") {
        h = Light.portal.newBgImage
    }
    g = document.forms["form_" + a]["ptBg"].length;
    for (var e = 0; e < g; e++) {
        if (document.forms["form_" + a]["ptBg"][e].checked && document.forms["form_" + a]["ptBg"][e].value != "more") {
            h = document.forms["form_" + a]["ptBg"][e].value
        }
    }
    var b = null;
    if (typeof Light.portal.header.newImage != "undefined") {
        b = Light.portal.header.newImage
    }
    g = document.forms["form_" + a]["ptHeader"].length;
    for (var e = 0; e < g; e++) {
        if (document.forms["form_" + a]["ptHeader"][e].checked && document.forms["form_" + a]["ptHeader"][e].value != "more") {
            b = document.forms["form_" + a]["ptHeader"][e].value
        }
    }
    var f = document.forms["form_" + a]["ptHeaderHeight"].value;
    var j = document.forms["form_" + a]["ptFontSize"].value;
    var c = "";
    if (d != null) {
        c = "theme=" + d
    }
    if (h != null) {
        if (c.length > 0) {
            c = c + "&bgImage=" + h
        }
        else {
            c = "bgImage=" + h
        }
    }
    if (b != null) {
        if (c.length > 0) {
            c = c + "&headerImage=" + b
        }
        else {
            c = "headerImage=" + b
        }
    }
    if (f != null) {
        if (c.length > 0) {
            c = c + "&headerHeight=" + f
        }
        else {
            c = "headerHeight=" + f
        }
    }
    if (j != null) {
        if (c.length > 0) {
            c = c + "&fontSize=" + j
        }
        else {
            c = "fontSize=" + j
        }
    }
    if (c.length > 0) {
        Light.ajax.sendRequest(Light.portal.contextPath + Light.changeTheme, {
            parameters: c,
            onSuccess: responseChangeTheme
        })
    }
}

function responseChangeTheme(){
    window.location.reload(true)
}

function changeTabColumns(d){
    var b = document.forms["form_" + d]["ptColumns"].value;
    var c = Light.getPortletById(d);
    var d = Light._PC_PREFIX + c.tIndex + "_" + c.position + "_" + c.index;
    var a = "responseId=" + d + "&columns=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    })
}

function changeCurrentTabColumns(d){
    var b = document.forms["form_" + d]["ptColumns"].value;
    var c = Light.getPortletById(d);
    var d = Light._PC_PREFIX + c.tIndex + "_" + c.position + "_" + c.index;
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&columns=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    })
}

function addAutoTab(a){
    var h = "New Tab";
    var g = "PortletWindow2";
    var d = 3;
    var j = 10;
    var c = "&width0=300&width1=300&width2=300";
    var b = "1";
    var f = "0";
    var e = "title=" + encodeURIComponent(h) + "&windowType=" + g + "&columns=" + d + c + "&between=" + j + "&closeable=" + b + "&defaulted=" + f;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.addTabRequest, {
        parameters: e,
        onSuccess: responseAddTab
    })
}

function addTab(a){
    var j = document.forms["form_" + a]["ptTitle"].value;
    var h = document.forms["form_" + a]["ptWindow"].value;
    var d = parseInt(document.forms["form_" + a]["ptColumns"].value);
    var l = document.forms["form_" + a]["ptBetween"].value;
    var c = "";
    for (var f = 0; f < d; f++) {
        c += "&width" + f + "=" + document.forms["form_" + a]["ptWidth" + f].value
    }
    var b = "0";
    if (document.forms["form_" + a]["ptClose"].checked) {
        b = "1"
    }
    var g = "0";
    if (document.forms["form_" + a]["ptDefault"].checked) {
        g = "1"
    }
    var e = "title=" + encodeURIComponent(j) + "&windowType=" + h + "&columns=" + d + c + "&between=" + l + "&closeable=" + b + "&defaulted=" + g;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.addTabRequest, {
        parameters: e,
        onSuccess: responseAddTab
    });
    var k = Light.getPortletById(a);
    k.close(true)
}

function responseAddTab(t){
    var portalTab = t.responseText;
    var vPortalTab = eval(portalTab);
    vPortalTab.insert(vPortalTab);
    Light.portal.tabs[vPortalTab.index] = vPortalTab
}

function editTab(b){
    var q = Light.getPortletById(b);
    var d = parseInt(document.forms["form_" + b]["ptColumns"].value);
    var n = true;
    var o = Light.portal.tabs[q.tIndex].portlets.length;
    if (Light.portal.tabs[q.tIndex].portlets.length > d) {
        for (var h = d; h < Light.portal.tabs[q.tIndex].portlets.length; h++) {
            if (h <= 10 && Light.portal.tabs[q.tIndex].portlets[h] != null) {
                for (var g = 0; g < Light.portal.tabs[q.tIndex].portlets[h].length; g++) {
                    if (Light.portal.tabs[q.tIndex].portlets[h][g] != null) {
                        n = false;
                        break
                    }
                }
            }
        }
    }
    if (!n) {
        alert("New allowed columns cannot smaller than current columns, if you want decrease columns, please delete that columns' contents or move to other column");
        return
    }
    var p = document.forms["form_" + b]["ptTitle"].value;
    var m = document.forms["form_" + b]["ptWindow"].value;
    var r = document.forms["form_" + b]["ptBetween"].value;
    var c = "";
    for (var f = 0; f < d; f++) {
        c += "&width" + f + "=" + document.forms["form_" + b]["ptWidth" + f].value
    }
    var a = "0";
    if (document.forms["form_" + b]["ptClose"].checked) {
        a = "1"
    }
    var l = "0";
    if (document.forms["form_" + b]["ptDefault"].checked) {
        l = "1"
    }
    var e = "title=" + encodeURIComponent(p) + "&tabId=" + Light.portal.tabs[q.tIndex].tabServerId + "&windowType=" + m + "&columns=" + d + c + "&between=" + r + "&closeable=" + a + "&defaulted=" + l;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.editTabRequest, {
        parameters: e,
        onSuccess: responseEditTab
    })
}

function responseEditTab(){
    window.location.reload(true)
}

function responseEditTab2(p){
    if (Light.getCookie(Light._ON) == "on") {
        var a = Light.portal.GetFocusedTabId();
        var h = a.substring(8, a.length);
        var l = p.responseText.split("-");
        var b = l[0];
        var f = l[1];
        var m = l[2];
        var n = l[3];
        if (n == 0) {
            n = false
        }
        else {
            n = true
        }
        var o = l[4];
        var g = l[5];
        if (g == 1) {
            defaultTab = i
        }
        var k = parseInt(l[6]);
        var c = l[7].split(",");
        var d = new Array();
        for (var e = 0; e < c.length; e++) {
            d[e] = parseInt(c[e])
        }
        Light.portal.tabs[h].between = k;
        Light.portal.tabs[h].widths = d;
        Light.portal.tabs[h].reLayout()
    }
}

function addContentMouseDown(a){
    if (a.className == "") {
        a.className = "portlet-header"
    }
    else {
        a.className = ""
    }
}

function addContent(e, a){
    var b = parseInt(document.forms["form_" + e]["pcColumn"].value);
    var d = Light.getPortletById(e);
    var c = "portletObjectRefName=" + a + "&tabId=" + Light.portal.tabs[d.tIndex].tabServerId + "&column=" + b;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.addContentRequest, {
        parameters: c,
        onSuccess: responseAddContent
    })
}

function responseAddContent(t){
    if (Light.getCookie(Light._ON) == "on") {
        var currentTabId = Light.portal.GetFocusedTabId();
        var index = currentTabId.substring(8, currentTabId.length);
        var newPortlet = "new PortletWindow(new " + Light.portal.tabs[index].portletWindowAppearance + "(), " + index + "," + t.responseText + ")";
        var portlet = eval(newPortlet);
        var id = Light._PC_PREFIX + index + "_" + portlet.position + "_" + portlet.index;
        Light.executePortlet(id)
    }
}

function showAddFeed(b, d){
    var c = Light.getPortletById(d);
    if (c == null) {
        return
    }
    var a = {
        title: LightResourceBundle._CLOSE,
        id: d
    };
    createPopupDiv("addFeed", "addFeed.jst", 300, a, b, d)
}

function hideAddFeed(){
    var c = Light.portal.GetFocusedTabId();
    var a = c.substring(8, c.length);
    var d = document.getElementById("panel_tab_page" + a);
    var b = document.getElementById("addFeed");
    if (b != null) {
        d.removeChild(b)
    }
}

function addFeed(d){
    var b = document.forms.myFeedForm["pcFeed"].value;
    var c = Light.getPortletById(d);
    var a = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&action=addFeed&feed=" + b;
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: a
    });
    hideAddFeed()
}

function showMyFeed(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=showMyFeed";
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function hideMyFeed(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=hideMyFeed";
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function showFeaturedFeed(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=showFeaturedFeed";
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function hideFeaturedFeed(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=hideFeaturedFeed";
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function showDictionary(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=showDictionary";
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function hideDictionary(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&action=hideDictionary";
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function showDictionaryFeed(d, a){
    var c = Light.getPortletById(d);
    var b = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&action=showDictionaryFeed&name=" + encodeURIComponent(a);
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: b
    })
}

function hideDictionaryFeed(d, a){
    var c = Light.getPortletById(d);
    var b = "responseId=" + d + "&tabId=" + Light.portal.tabs[c.tIndex].tabServerId + "&portletId=" + c.serverId + "&action=hideDictionaryFeed&name=" + encodeURIComponent(a);
    Light.ajax.sendRequestAndUpdate(c.request, d, {
        evalScripts: c.allowJS,
        parameters: b
    })
}

function loginPortal(g){
    var c = document.forms["form_" + g]["userId"].value;
    var b = document.forms["form_" + g]["password"].value;
    if (document.forms["form_" + g]["rememberMe"].checked) {
        var a = new Date();
        var d = Date.parse(a);
        a.setFullYear(a.getFullYear() + 1);
        Light.setCookie(Light._REMEMBERED_USER_ID, c, a);
        Light.setCookie(Light._REMEMBERED_USER_PASSWORD, b, a)
    }
    else {
        Light.deleteCookie(Light._REMEMBERED_USER_ID);
        Light.deleteCookie(Light._REMEMBERED_USER_PASSWORD)
    }
    var f = Light.getPortletById(g);
    var e = "portletId=" + f.serverId + "&tabId=" + Light.portal.tabs[f.tIndex].tabServerId + "&userId=" + c + "&password=" + b;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.loginRequest, {
        parameters: e,
        onSuccess: responseLogin
    })
}

function responseLogin(b){
    var a = b.responseText;
    if (a == "-1") {
        alert("This User ID is not signed up yet , please sign up first.");
        Light.deleteCookie(Light._REMEMBERED_USER_ID);
        Light.deleteCookie(Light._REMEMBERED_USER_PASSWORD)
    }
    else {
        if (a == "-2") {
            alert("you input wrong password , please try again.");
            Light.deleteCookie(Light._REMEMBERED_USER_ID);
            Light.deleteCookie(Light._REMEMBERED_USER_PASSWORD)
        }
        else {
            Light.setCookie(Light._LOGINED_USER_ID, a);
            Light.deleteCookie(Light._CURRENT_TAB);
            Light.deleteCookie(Light._IS_SIGN_OUT);
            window.location.reload(true)
        }
    }
}

function showSignUp(c){
    var b = Light.getPortletById(c);
    b.mode = Light._EDIT_MODE;
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&mode=" + Light._EDIT_MODE;
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function signUpPortal(a){
    var g = document.forms["form_" + a]["plUserId"].value;
    var m = document.forms["form_" + a]["plPassword"].value;
    var j = document.forms["form_" + a]["plConfirmPassword"].value;
    var l = document.forms["form_" + a]["plFirstName"].value;
    var b = document.forms["form_" + a]["plMiddleName"].value;
    var n = document.forms["form_" + a]["plLastName"].value;
    var h = document.forms["form_" + a]["plEmail"].value;
    if (g == null || g == "" || m == null || m == "" || j == null || j == "" || l == null || l == "" || n == null || n == "") {
        alert(LightResourceBundle._ERROR_FIELDS_REQUIRED);
        return
    }
    if (m != j) {
        alert(LightResourceBundle._ERROR_PASSWORD_NOT_EQUAL);
        return
    }
    var f = document.forms["form_" + a]["plChannels"].length;
    var e = "";
    for (var d = 0; d < f; d++) {
        if (document.forms["form_" + a]["plChannels"][d].checked) {
            e += document.forms["form_" + a]["plChannels"][d].value + ","
        }
    }
    var k = Light.getPortletById(a);
    var c = "portletId=" + k.serverId + "&tabId=" + Light.portal.tabs[k.tIndex].tabServerId + "&userId=" + g + "&password=" + m + "&firstName=" + l + "&middleName=" + b + "&lastName=" + n + "&email=" + h + "&channels=" + e;
    if (document.forms["form_" + a]["plShowLocale"].checked) {
        c += +"&showLocale=" + document.forms["form_" + a]["plShowLocale"].value
    }
    Light.ajax.sendRequest(Light.portal.contextPath + Light.signUpRequest, {
        parameters: c,
        onSuccess: responseSignUpPortal
    })
}

function responseSignUpPortal(b){
    var a = b.responseText;
    if (a == "-1") {
        alert("This User ID have already registered before, please try other User ID.")
    }
    else {
        if (a == "-2") {
            alert("System busy, please try later.")
        }
        else {
            Light.setCookie(Light._LOGINED_USER_ID, a);
            window.location.reload(true)
        }
    }
}

function cancelSignUpPortal(c){
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId;
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
}

function saveProfile(a){
    var l = document.forms["form_" + a]["plPassword"].value;
    var h = document.forms["form_" + a]["plConfirmPassword"].value;
    var k = document.forms["form_" + a]["plFirstName"].value;
    var b = document.forms["form_" + a]["plMiddleName"].value;
    var m = document.forms["form_" + a]["plLastName"].value;
    var g = document.forms["form_" + a]["plEmail"].value;
    if (l == null || l == "" || h == null || h == "" || k == null || k == "" || m == null || m == "") {
        alert(LightResourceBundle._ERROR_FIELDS_REQUIRED);
        return
    }
    if (l != h) {
        alert(LightResourceBundle._ERROR_PASSWORD_NOT_EQUAL);
        return
    }
    var f = document.forms["form_" + a]["plChannels"].length;
    var e = "";
    for (var d = 0; d < f; d++) {
        if (document.forms["form_" + a]["plChannels"][d].checked) {
            e += document.forms["form_" + a]["plChannels"][d].value + ","
        }
    }
    var j = Light.getPortletById(a);
    var c = "portletId=" + j.serverId + "&tabId=" + Light.portal.tabs[j.tIndex].tabServerId + "&password=" + l + "&firstName=" + k + "&middleName=" + b + "&lastName=" + m + "&email=" + g + "&channels=" + e;
    if (document.forms["form_" + a]["plShowLocale"].checked) {
        c += "&showLocale=1"
    }
    Light.ajax.sendRequest(Light.portal.contextPath + Light.profileRequest, {
        parameters: c,
        onSuccess: responseSaveProfile
    })
}

function responseSaveProfile(b){
    var a = b.responseText;
    if (a == "-1") {
        alert("This User is not exist.")
    }
    else {
        if (a == "-2") {
            alert("System busy, please try later.")
        }
        else {
            window.location.reload(true)
        }
    }
}

function showMoreBgImage(b, d){
    var c = Light.getPortletById(d);
    if (c == null) {
        return
    }
    var a = {
        bgImage: Light.portal.bgImage,
        ok: LightResourceBundle._BUTTON_OK,
        cancel: LightResourceBundle._BUTTON_CANCEL,
        id: d
    };
    createPopupDiv("moreBgImage", "moreBgImage.jst", null, a, b, d)
}

function saveBgImage(d){
    var a = document.forms.form_moreBgImage["ptBg"].length;
    var b = "";
    for (var c = 0; c < a; c++) {
        if (document.forms.form_moreBgImage["ptBg"][c].checked) {
            b = document.forms.form_moreBgImage["ptBg"][c].value
        }
    }
    Light.portal.newBgImage = b;
    if (b.length > 0) {
        var a = document.forms["form_" + d]["ptBg"].length;
        for (var c = 0; c < a; c++) {
            if (document.forms["form_" + d]["ptBg"][c].value = "more") {
                document.forms["form_" + d]["ptBg"][c].checked = true
            }
            else {
                document.forms["form_" + d]["ptBg"][c].checked = false
            }
        }
    }
    cancelBgImage()
}

function cancelBgImage(){
    var c = Light.portal.GetFocusedTabId();
    var a = c.substring(8, c.length);
    var d = document.getElementById("panel_tab_page" + a);
    var b = document.getElementById("moreBgImage");
    if (b != null) {
        d.removeChild(b)
    }
}

function showMoreHeaderImage(b, d){
    var c = Light.getPortletById(d);
    if (c == null) {
        return
    }
    var a = {
        headerImage: Light.portal.headerImage,
        ok: LightResourceBundle._BUTTON_OK,
        cancel: LightResourceBundle._BUTTON_CANCEL,
        id: d
    };
    createPopupDiv("moreHeaderImage", "moreHeaderImage.jst", null, a, b, d)
}

function saveHeaderImage(d){
    var a = document.forms.form_moreHeaderImage["ptHeader"].length;
    var c = "";
    for (var b = 0; b < a; b++) {
        if (document.forms.form_moreHeaderImage["ptHeader"][b].checked) {
            c = document.forms.form_moreHeaderImage["ptHeader"][b].value
        }
    }
    Light.portal.header.newImage = c;
    if (c.length > 0) {
        var a = document.forms["form_" + d]["ptHeader"].length;
        for (var b = 0; b < a; b++) {
            if (document.forms["form_" + d]["ptHeader"][b].value = "more") {
                document.forms["form_" + d]["ptHeader"][b].checked = true
            }
            else {
                document.forms["form_" + d]["ptHeader"][b].checked = false
            }
        }
    }
    cancelHeaderImage()
}

function cancelHeaderImage(){
    var c = Light.portal.GetFocusedTabId();
    var a = c.substring(8, c.length);
    var d = document.getElementById("panel_tab_page" + a);
    var b = document.getElementById("moreHeaderImage");
    if (b != null) {
        d.removeChild(b)
    }
};

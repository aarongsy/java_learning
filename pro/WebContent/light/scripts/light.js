var Light = {
    Version: "1.0.0",
    _ON: "LightPortalOn",
    _DEFAULT_CONTEXT_PATH: "",
    _USER_ID: "LightPortalUserId",
    _LOGINED_USER_ID: "LightPortalLoginedUserId",
    _REMEMBERED_USER_ID: "LightPortalRememberedUserId",
    _REMEMBERED_USER_PASSWORD: "LightPortalRememberedUserPassword",
    _IS_SIGN_OUT: "LightPortalIsSignOut",
    _USER_LOCALE: "LightPortalUserLocale",
    _CURRENT_TAB: "LightPortalCurrentTab",
    _PC_PREFIX: "portletContent_",
    _VIEW_MODE: "view",
    _EDIT_MODE: "edit",
    _HELP_MODE: "help",
    _CONFIG_MODE: "config",
    _NORMAL_STATE: "normal",
    _MINIMIZED_STATE: "minimized",
    _MAXIMIZED_STATE: "maximized",
    maxZIndex: 1,
    checkLoginRequest: "checkLogin.lp",
    getPortalRequest: "getPortal.lp",
    getPortalTabsByUserRequest: "/getPortalTabsByUser.lp",
    getPortletsByTabRequest: "/getPortletsByTab.lp",
    getViewTemplateRequest: "/getViewTemplate.lp",
    changeTitle: "/changeTitle.lp",
    changeLocale: "/changeLocale.lp",
    lookAndFeelRequest: "/lookAndFeel.lp",
    changeTheme: "/changeTheme.lp",
    addTabRequest: "/addTab.lp",
    editTabRequest: "/editTab.lp",
    addContentRequest: "/addContent.lp",
    loginRequest: "/login.lp",
    logoutRequest: "/logout.lp",
    signUpRequest: "/signUp.lp",
    profileRequest: "/profile.lp",
    deletePortletRequest: "/deletePortlet.lp",
    deleteTabRequest: "/deleteTab.lp",
    changePositionRequest: "/changePosition.lp",
    countLightRequest: "/countLight.lp",
    getRssDesc: "/getRssDesc.lp",
    uploadOpml: "/uploadOpml.lp",
    getFeedbackDesc: "/getFeedbackDesc.lp",
    getUserDetail: "/getUserDetail.lp",
    getTodoDesc: "/getTodoDesc.lp",
    getBookmarkDesc: "/getBookmarkDesc.lp",
    getDeliDesc: "/getDeliDesc.lp",
    editTabTitleRequest: "/editTabTitle.lp",
    rememberState: "/rememberState.lp",
    rememberMode: "/rememberMode.lp",
    listenServer: "/listenServer.lp",
    changeMode: "/changeMode.lp",
    saveNote: "/saveNote.lp",
    configPortlet: "/configPortlet.lp",
    portal: null,
    ajax: null,
    serverError: false,
    logLevel: "INFO",
    isEmpty: function(a) {
        return (typeof(a) == "undefined" || a == null || a.toString() == "")
    }
};
Light.refreshPortal = function() {
    Light.switchPortal()
};
Ext.EventManager.onWindowResize(function() {
    if (Light.getCookie(Light._ON) == "on") {
    	/*
	    * EWV2013055366 ie10新老皮肤protal页面上靠右会有空白
	    * 因为页面加载时container的宽度使用scrollWidth去定义，因为页面尚无内容，没有滚动条，所以获取的宽度没有受滚动条的影响。
	    * 而在页面resize的时候，如果因为门户元素比较多而出现了滚动条，那么IE10中用scrollWidth获取宽度时会减去滚动条的宽度。
	    * 从而导致两次获取宽度不一致，所以就会出现页面在最小化再最大化的时候页面右边还是会有空白。
	    * 所以在resize时将scrollWidth改为offsetWidth。
	    */
    	var w = document.documentElement.offsetWidth * currentPortalTabScrolls - 30;
        Light.portal.resize(w)
    }
});
Light.switchPortal = function() {
    if (Light.portal == null) {
        Light.portal = new LightPortal();
        Light.ajax = new Light.Ajax()
    }
    if (Light.portal.turnedOn) {
        Light.portal.turnOff()
    } else {
        Light.portal.turnOn();
        Light.init()
    }
};
Light.supportLocale = new Array(new Array("English", "en"), new Array("Simplified Chinese", "zh_CN"), new Array("Traditional Chinese", "zh_TW"));
Light.getPortletById = function(f) {
    var c = f.split("_");
    var d = c[1];
    var a = c[2];
    var b = c[3];
    var e = Light.portal.tabs[d].portlets[a][b];
    return e
};
Light.executeAction = function(p, k, v, b, d, m, e, g) {
    var t = Light.getPortletById(p);
    if (e != null) {
        if (e == "maximized") {
            t.window.maximize(t)
        }
        if (e == "minimized") {
            t.window.minimize(t)
        }
    }
    var q = new Array();
    var h = document.getElementById(p);
    var c = h.getElementsByTagName("form");
    if (c != null && c.length > 0) {
        k = c[0]
    }
    if (k != null && k.elements != null) {
        for (var x = 0; x < k.elements.length; x++) {
            var a = k.elements[x].name;
            var y = k.elements[x].value;
            var f = k.elements[x].type;
            if (!a) {
                var z = k.elements[x].length;
                for (var w = 0; w < z; w++) {
                    if (k.elements[x][w].checked) {
                        a = k.elements[x][w].name;
                        y = k.elements[x][w].value
                    }
                }
            } else {
                if (f == "checkbox" && !k.elements[x].checked) {
                    y = null
                }
            }
            if (f == "radio" && !k.elements[x].checked) {
                y = null
            }
            if (y != null && y.length > 0) {
                if (f != "button" && f != "submit") {
                    if (f == "select-multiple") {
                        var l = k.elements[x].options;
                        for (var s = 0; s < l.length; s++) {
                            if (l[s].selected) {
                                q.push(a + "=" + encodeURIComponent(l[s].value))
                            }
                        }
                    } else {
                        q.push(a + "=" + encodeURIComponent(y))
                    }
                } else {
                    if (v == null) {
                        if (b == null) {
                            q.push(a + "=" + encodeURIComponent(y))
                        } else {
                            if (b == a) {
                                q.push(a + "=" + encodeURIComponent(y))
                            }
                        }
                    }
                }
            }
        }
    }
    var u = "responseId=" + p + "&tabId=" + Light.portal.tabs[t.tIndex].tabServerId + "&portletId=" + t.serverId;
    if (t.parameter.length > 0) {
        u = u + "&" + t.parameter
    }
    var o = null;
    if (document.mode != null) {
        o = document.mode;
        t.mode = document.mode
    } else {
        if (m != null) {
            o = m;
            t.mode = m
        } else {
            o = Light._VIEW_MODE;
            t.mode = Light._VIEW_MODE
        }
    }
    if (t.refreshButtons) {
        t.refreshButtons()
    }
    u = u + "&mode=" + o;
    if (t.maximized) {
        u = u + "&state=maximized"
    }
    if (v != null && v.length > 0) {
        u = u + "&action=" + v
    }
    if (d != null && d.length > 0) {
        u = u + "&parameter=" + d
    }
    for (var x = 0; x < q.length; x++) {
        u = u + "&" + q[x]
    }
    if (g != null) {
        var r = g.split(";");
        for (var x = 0; x < r.length; x++) {
            if (r[x].length > 0) {
                u = u + "&" + r[x]
            }
        }
    }
    if (document.resetLastAction != null) {
        t.lastAction = null
    }
    Light.ajax.sendRequestAndUpdate(t.request, p, {
        evalScripts: t.allowJS,
        parameters: u
    });
    document.currentForm = null;
    document.pressed = null;
    document.pressedName = null;
    document.parameter = null;
    document.mode = null
};
Light.executeRefresh = function(f) {
    var e = Light.getPortletById(f);
    if (e.lastAction != null) {
        var d = e.lastAction.split("&");
        for (var b = 0; b < d.length; b++) {
        	if (d[b].indexOf("mode") >= 0) {
        		d[b] = "mode="+e.mode;
        	}
        }
        var c;
        var a = -1;
        for (var b = 0; b < d.length; b++) {
            if (d[b].indexOf("state") >= 0) {
                a = b;
                break
            }
        }
        for (var b = 0; b < d.length; b++) {
            if (b == 0) {
                c = d[b]
            }
            if (b != a) {
                c = c + "&" + d[b]
            }
        }
        if (e.maximized) {
            c = c + "&state=maximized"
        }
        if (e.refreshAction) {
            e.refreshAction = false;
            c = c + "&refresh=true"
        }
        Light.ajax.sendRequestAndUpdate(e.request, f, {
            evalScripts: e.allowJS,
            parameters: c
        })
    } else {
        Light.executePortlet(f)
    }
};
Light.executeRender = function(b, g, a, d, h) {
    var j = Light.getPortletById(b);
    if (a != null) {
        if (a == "maximized" && !j.maximized) {
            j.window.maximize(j)
        }
        if (a == "normal" && j.maximized) {
            j.window.maximize(j)
        }
        if (a == "minimized") {
            if (!j.maximized) {
                j.window.minimize(j)
            }
            return
        }
    }
    if (g == null) {
        g = j.mode
    } else {
        j.mode = g;
        j.refreshButtons()
    }
    var c = "responseId=" + b + "&tabId=" + Light.portal.tabs[j.tIndex].tabServerId + "&portletId=" + j.serverId + "&mode=" + g + "&isRenderUrl=true";
    if (j.parameter.length > 0) {
        c = c + "&" + j.parameter
    }
    if (j.maximized) {
        c = c + "&state=maximized"
    }
    if (d != null) {
        var e = d.split(";");
        for (var f = 0; f < e.length; f++) {
            if (e[f].length > 0) {
                c = c + "&" + e[f]
            }
        }
    }
    if (h != null && h.length > 0) {
        c = c + "&parameter=" + h
    }
    j.lastAction = c;
    Light.ajax.sendRequestAndUpdate(j.request, b, {
        evalScripts: j.allowJS,
        parameters: c
    });
    log("ajax.sendRequestAndUpdate...>>>" + j.request);
    document.parameter = null
};
Light.executePortlet = function(c) {
    var b = Light.getPortletById(c);
    var a = "responseId=" + c + "&tabId=" + Light.portal.tabs[b.tIndex].tabServerId + "&portletId=" + b.serverId + "&mode=" + b.mode;
    if (b.parameter.length > 0) {
        a = a + "&" + b.parameter
    }
    if (b.maximized) {
        a = a + "&state=maximized"
    }
    if (b.refreshAction) {
        b.refreshAction = false;
        a = a + "&refresh=true"
    }
    b.lastAction = a;
    Light.ajax.sendRequestAndUpdate(b.request, c, {
        evalScripts: b.allowJS,
        parameters: a
    })
};
Light.init = function() {
    Light.portal.moveTimer = -1;
    Light.portal.dragDropPortlet = null;
    document.body.onmousemove = function(a) {
        if (Light.portal.moveTimer == -1) {
            return
        }
        if (document.all) {
            a = event
        }
        if (Light.portal.dragDropPortlet != null) {
            Light.portal.dragDropPortlet.move(a)
        }
        return false
    };
    document.body.onmouseup = function(a) {
        Light.portal.moveTimer = -1;
        if (document.all) {
            a = event
        }
        if (Light.portal.dragDropPortlet != null) {
            Light.portal.dragDropPortlet.moveEnd(a);
            Light.portal.dragDropPortlet = null;
            document.body.onselectstart = null;
            document.body.ondragstart = null
        }
        return false
    };
    Light.portal.highLight = Light.createHightLight();
    Light.getViewTemplate();
    log("initialize Light")
};
Light.createHightLight = function() {
    var b = document.createElement("div");
    var a = "#ff0000";
    b.style.borderWidth = "1px";
    b.style.borderStyle = "dashed";
    b.style.borderColor = a;
    if (document.all) {
        b.style.posLeft = 0;
        b.style.posTop = 0
    } else {
        b.style.left = 0;
        b.style.top = 0
    }
    b.style.width = 0;
    b.style.height = 0;
    b.style.position = "absolute";
    return b
};
Light.getViewTemplate = function() {
    var a = contextPath;
    a += Light.getViewTemplateRequest;
    Light.ajax.sendRequest(a, {
        onSuccess: Light.setViewTemplate
    })
};
Light.setViewTemplate = function(b) {
    var a = document.createElement("div");
    a.id = "viweTemplate";
    a.style.display = "none";
    a.innerHTML = b.responseText;
    document.body.appendChild(a);
    a = null
};
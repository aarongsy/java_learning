LightPortal = function() {
    this.layout = {
        left: 0,
        top: 0,
        width: document.documentElement.scrollWidth * currentPortalTabScrolls - 30,
        height: document.documentElement.scrollHeight - 80
    };
    this.turnedOn = false;
    this.tabs = new Array();
    this.currentTabId = null;
    this.addBtn = null;
    log("initialize LightPortal")
};
LightPortal.prototype.rePositionCurrentTab = function(){
	var currentTabId = this.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
    this.tabs[index].rePositionAll();
}
LightPortal.prototype.turnOn = function() {
    this.turnOnLoginUser()
};
LightPortal.prototype.turnOnLoginUser = function() {
    var b = Light.getCookie(Light._LOGINED_USER_ID);
    var a = {
        method: "post",
        postBody: "userId=" + b,
        onSuccess: function(c) {
            Light.portal.responseTurnOnLoginUser(c)
        },
        on404: function(c) {
            alert('Error 404: location "' + c.statusText + '" was not found.')
        },
        onFailure: function(c) {
            alert("Error " + c.status + " -- " + c.statusText)
        }
    };
    Light.ajax.sendRequest(Light.checkLoginRequest, a)
};
LightPortal.prototype.responseTurnOnLoginUser = function(b) {
    var a = b.responseText;
    if (a != "-1") {
        Light.setCookie(Light._LOGINED_USER_ID, a);
        Light.portal.turnOnUser(a)
    } else {
        Light.portal.turnOnRememberLoginUser()
    }
};
LightPortal.prototype.turnOnRememberLoginUser = function() {
    var b = Light.getCookie(Light._REMEMBERED_USER_ID);
    var a = Light.getCookie(Light._REMEMBERED_USER_PASSWORD);
    if (b != null && b != "" && a != null && a != "" && (Light.getCookie(Light._IS_SIGN_OUT) == null || Light.getCookie(Light._IS_SIGN_OUT) == "")) {
        var c = "userId=" + b + "&password=" + a;
        Light.ajax.sendRequest(Light.portal.contextPath + Light.loginRequest, {
            parameters: c,
            onSuccess: Light.portal.responseTurnOnRememberLoginUser
        })
    } else {
        Light.portal.turnOnRememberUser()
    }
};
LightPortal.prototype.responseTurnOnRememberLoginUser = function(c) {
    var b = c.responseText;
    if (b != "-1" && b != "-2") {
        Light.setCookie(Light._LOGINED_USER_ID, b);
        Light.deleteCookie(Light._CURRENT_TAB);
        var a = {
            method: "post",
            postBody: "userId=" + b,
            onSuccess: function(d) {
                Light.portal.responseTurnOn(d)
            },
            on404: function(d) {
                alert('Error 404: location "' + d.statusText + '" was not found.')
            },
            onFailure: function(d) {
                alert("Error " + d.status + " -- " + d.statusText)
            }
        };
        Light.ajax.sendRequest(Light.getPortalRequest, a)
    } else {
        Light.deleteCookie(Light._REMEMBERED_USER_ID);
        Light.deleteCookie(Light._REMEMBERED_USER_PASSWORD);
        Light.portal.turnOnRememberUser()
    }
};
LightPortal.prototype.turnOnRememberUser = function() {
    var b = Light.getCookie(Light._USER_ID);
    if (b == null || b == "") {
        var a = new Date();
        var c = Date.parse(a);
        a.setFullYear(a.getFullYear() + 1);
        b = c;
        Light.setCookie(Light._USER_ID, b, a)
    }
    Light.portal.turnOnUser(b)
};
LightPortal.prototype.turnOnUser = function(b) {
    var a = {
        method: "post",
        postBody: "userId=" + b,
        onSuccess: function(c) {
            Light.portal.createPortal(c);
            log("Light.portal.createPortal(userId:" + b + ")...")
        },
        on404: function(c) {
            alert('Error 404: location "' + c.statusText + '" was not found.')
        },
        onFailure: function(c) {
            alert("Error " + c.status + " -- " + c.statusText)
        }
    };
    Light.ajax.sendRequest(Light.getPortalRequest, a)
};
LightPortal.prototype.createPortal = function(b) {
    var e = b.responseText.split(",");
    this.contextPath = e[0];
    if (Light.isEmpty(this.contextPath)) {
        this.contextPath = Light._DEFAULT_CONTEXT_PATH
    }
    Light.locale = e[9];
    this.bgImage = e[10];
    this.fontSize = e[13];
    var d = e[1];
    var c = e[11];
    var a = e[12];
    this.header = new LightPortalHeader(this, d, c, a);
    this.allowLookAndFeel = true;
    this.allowLayout = true;
    this.allowAddTab = true;
    this.allowAddContent = true;
    this.allowSignIn = true;
    this.allowTurnOff = true;
    this.allowChangeLocale = true;
    if (e[2] == 0) {
        this.allowLookAndFeel = false
    }
    if (e[3] == 0) {
        this.allowLayout = false
    }
    if (e[4] == 0) {
        this.allowAddTab = false
    }
    if (e[6] == 0) {
        this.allowSignIn = false
    }
    if (e[7] == 0) {
        this.allowTurnOff = false
    }
    if (e[8] == 0) {
        this.allowChangeLocale = false
    }
    this.menu = new LightPortalMenu(this, this.allowLookAndFeel, this.allowLayout, this.allowAddTab, this.allowAddContent, this.allowSignIn, this.allowTurnOff, this.allowChangeLocale);
    this.body = new LightPortalBody(this);
    this.footer = new LightPortalFooter(this);
    this.container = this.createPortalContainer();
    this.container.appendChild(this.body.container);
    this.container.appendChild(this.footer.container);
    document.body.appendChild(this.container);
    Light.setCookie(Light._ON, "on");
    this.turnedOn = true;
    this.getPortalTabsByUser()
};
LightPortal.prototype.getPortalTabsByUser = function() {
    var a = {
        method: "post",
        postBody: "",
        onSuccess: function(b) {
            Light.portal.responseGetPortalTabsByUser(b)
        },
        on404: function(b) {
            alert('Error 404: location "' + b.statusText + '" was not found.')
        },
        onFailure: function(b) {
            alert("Error " + b.status + " -- " + b.statusText)
        }
    };
    Light.ajax.sendRequest(Light.portal.contextPath + Light.getPortalTabsByUserRequest, a)
};
function openTab(a) {
	
	var isNewSkin = top.document.getElementById("isNewSkin");//新皮肤
	if(isNewSkin){
		var isSysAdmin = top.document.getElementById('isSysAdmin').value;
		var $menu = jQuery(top.document.getElementById('portalMenu'));
		if(isSysAdmin==0){
			var portalAdminArray = top.portalAdminArray;
			var liTab_PortletConfig = top.document.getElementById('liTab_PortletConfig');
			if(portalAdminArray&&portalAdminArray.length>0){
				var flag = false;
				for(var i=0;i<portalAdminArray.length;i++){
					if(a==portalAdminArray[i]){
						flag = true;
						if(!liTab_PortletConfig){
							$menu.append("<li id='liTab_PortletConfig' style='padding-left:5px;'><a href='javascript:void(0);' onclick='javascript:addPortletContent();'><span style='width:16px;height:16px;background:url(/images/silk/cog.gif) no-repeat;display:block;float:left;margin-right:3px;'></span>添加门户元素</a></li>");
						}
						break;
					}
				}
				
				if(!flag&&liTab_PortletConfig){
					liTab_PortletConfig.parentNode.removeChild(liTab_PortletConfig);
				}
			}
		}
	}
	
    Light.portal.tabs[a].focus();
    Light.portal.tabs[a].refresh();
    resizeMainPageBodyHeight();/*调整主页面的body高度*/
}
LightPortal.prototype.responseGetPortalTabsByUser = function(t) {
	var defaultTab = 0;
    var responseText = t.responseText;
    var o = Ext.decode(responseText);
    
    //从Cookie中获取PortalTabId
    var currentTabId = -1;
	var currentTab = Light.getCookie(Light._CURRENT_TAB);
	if(currentTab!=null){
		currentTabId = currentTab.substring(8, currentTab.length);
	}
    var portalTabScrolls = eval('('+o.scrolls+')');
    var portalTabMenus = eval(o.menus);
    var portalTabMenusId = new Array();
    
    var scrolls = 1;
    for(var i=0;i<portalTabMenus.length;i++){
    	portalTabMenusId.push(portalTabMenus[i].id);
    }
 	//如果Cookie中的TabID不在当前用户所能查看的PortalTab中,默认取第一个PortalTab.
	if((","+o.validtabs+",").indexOf(","+currentTabId+",")==-1){
		currentTabId = portalTabMenusId[0];
	}
	//获取PortalTab对应的滚屏数
	scrolls = eval("portalTabScrolls.tab"+currentTabId);
    if(top.frames[1] && top.frames[1].name=="leftFrame"){//使用的是main.jsp页面
		var portalTab = top.frames[1].contentPanel.items.get(0);
		var pttb = portalTab.getTopToolbar();
		//清除Portal Toolbar所有子项
		pttb.items.clear();
		//pttb.doLayout();
	    //添加Portal菜单
	    for(var i=0;i<portalTabMenus.length;i++){
			pttb.add(portalTabMenus[i]);
		}
	    pttb.add('->');
	   
		if(top.frames[1]){
			//创建PortalTab的滚屏按钮
			top.frames[1].createPDot(pttb, scrolls);
			//创建PortalTab的添加元素按钮
			this.addBtn = new Ext.Toolbar.Button({
				id:'btnCog',text:'<img src="/images/silk/cog.gif"/>',handler:function(){
			    	var w = top.frames[1].contentPanel.getActiveTab().getFrameWindow();
			    	w.Light.portal.addContent();
			    }
			});
		    pttb.add(this.addBtn);
		}
		pttb.doLayout();
		pttb.show();
	}
	
	currentPortalTabScrolls = scrolls;
	//根据滚屏数重新调整PortalTab宽度
	Light.portal.resize(document.documentElement.scrollWidth * scrolls - 30);    
  
    var tabs = o.tabs;
    var portalTabs = tabs.split(";");
    var lastopenedtab = "";
    var isvalid = false;
    var isvalid_targetTab = false;	//判断指定id的tab用户是否有权限查看
    if (Light.getCookie(Light._CURRENT_TAB) != null && Light.getCookie(Light._CURRENT_TAB) != "") {
        lastopenedtab = Light.getCookie(Light._CURRENT_TAB)
    }
    for (var i = 0; i < portalTabs.length; i++) {
        var vPortalTab = eval(portalTabs[i]);
        if(typeof vPortalTab == "undefined"){
        	return false;
        }
        vPortalTab.open(vPortalTab);
        this.tabs[vPortalTab.index] = vPortalTab;
        if (lastopenedtab == vPortalTab.tabId) {
            isvalid = true
        }
        if (i == 0) {
            defaultTab = vPortalTab.index
        }
        if (vPortalTab.defaulted) {
            defaultTab = vPortalTab.index
        }
        if("tab_page" + targetPortalTabId == vPortalTab.tabId){
        	isvalid_targetTab = true;
        } 
    }
    if (isvalid) {
        defaultTab = lastopenedtab.substring(8, lastopenedtab.length)
    }
    defaultTab = currentTabId;
    if(targetPortalTabId != ""){	//指定了查看具体id的tab
    	if(isvalid_targetTab){	//有权限,到指定id的tab
    		defaultTab = targetPortalTabId;
    	}else{	//没有权限,直接返回,显示空白页
    		return;
    	}
    }
    if(!defaultTab && Light.portal.addBtn){
    	Light.portal.addBtn.setVisible(this.isManage);
    	return false;
    }
    if(top.frames[1] && top.frames[1].name=="leftFrame"){//使用的是main.jsp页面
    	if(typeof(top.frames[1].addClassToCurrentPortalTabBtn) == "function" && targetPortalTabId == ""){	//不是使用菜单的方式直接访问具体的tab
    		top.frames[1].addClassToCurrentPortalTabBtn(defaultTab, true);
    	}
    }
    this.tabs[defaultTab].focus();
    this.tabs[defaultTab].refresh()
};
LightPortal.prototype.addTabMenu = function() {
    if (Light.portal.menu.allowAddTab) {
        var a = document.createElement("span");
        a.setAttribute("id", "tabSpan");
        a.className = "";
        a.setAttribute("tabColor", "");
        var b = document.createElement("div");
        b.className = "portal-tab-handle";
        b.innerHTML = "<a href='javascript:void(0);'>" + LightResourceBundle._MENU_ADD_TAB + "</a>";
        var c = document.createElement("img");
        c.src = Light.portal.contextPath + "/light/images/add.gif";
        c.className = "portal-tab-button";
        c.style.height = 16;
        c.style.width = 16;
        c.align = "middle";
        a.appendChild(c);
        a.appendChild(b);
        var d = document.createElement("li");
        d.className = this.tabColor;
        d.id = "tabMenuAddTab";
        d.setAttribute("id", "tabMenuAddTab");
        d.setAttribute("tabId", "");
        d.setAttribute("tabLabel", LightResourceBundle._MENU_ADD_TAB);
        d.setAttribute("tabColor", "");
        d.onclick = function() {
            addAutoTab();
            log("addAutoTab...")
        };
        d.setAttribute("tabIsCloseable", "0");
        d.setAttribute("isFocused", "true");
        d.appendChild(a);
        document.getElementById("tabList").appendChild(d)
    }
};
LightPortal.prototype.autoListenServer = function() {
    this.listenServer()
};
LightPortal.prototype.listenServer = function() {
    var a = {
        method: "post",
        postBody: "",
        onSuccess: function(b) {
            Light.portal.responseListenServer(b)
        },
        on404: function(b) {
            Light.serverError = true;
            alert('Error 404: location "' + b.statusText + '" was not found.')
        },
        onFailure: function(b) {
            Light.serverError = true;
            alert("Error " + b.status + " -- " + b.statusText)
        }
    };
    Light.ajax.sendRequest(Light.portal.contextPath + Light.listenServer, a)
};
LightPortal.prototype.responseListenServer = function(a) {
    if (!Light.serverError) {
        setTimeout("Light.portal.autoListenServer()", 10000)
    }
    if (a.responseText == null) {
        return
    }
    var b = a.responseText.split(",");
    if (b == null || b.length <= 1) {
        return
    }
};
LightPortal.prototype.turnOff = function() {
    this.container.removeChild(this.header.container);
    this.container.removeChild(this.menu.container);
    this.container.removeChild(this.body.container);
    this.container.removeChild(this.footer.container);
    document.body.removeChild(this.container);
    Light.deleteCookie(Light._ON);
    Light.deleteCookie(Light._CURRENT_TAB);
    for (var b = 0; b < this.tabs.length; b++) {
        for (var a = 0; a < this.tabs[b].portlets.length; a++) {
            this.tabs[b].portlets[a] = new Array()
        }
    }
    this.tabs = new Array();
    this.turnedOn = false;
    document.body.onselectstart = null;
    document.body.ondragstart = null;
    document.body.onmousemove = null;
    document.body.onmouseup = null
};
LightPortal.prototype.GetFocusedTabId = function() {
    return this.currentTabId
};
LightPortal.prototype.changeTheme = function() {
    var currentTabId = this.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
    var window = eval("new " + this.tabs[index].portletWindowAppearance + "()");
    var vPortlet = new PortletPopupWindow(window, index, 0, 11, 150, 600, LightResourceBundle._MENU_LOOK_AND_FEEL, "", "", "themePortlet", Light.portal.contextPath + "/themePortlet.lp", true, false, false, false, false, false, 0, false, "", "", "", "");
    this.tabs[index].rePositionAll();
    var id = Light._PC_PREFIX + index + "_" + vPortlet.position + "_" + vPortlet.index;
    var pars = "responseId=" + id + "&tabId=" + this.tabs[index].tabServerId;
    Light.ajax.sendRequestAndUpdate(vPortlet.request, id, {
        evalScripts: vPortlet.allowJS,
        parameters: pars
    })
};
LightPortal.prototype.editTab = function() {
    var currentTabId = this.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
    var window = eval("new " + this.tabs[index].portletWindowAppearance + "()");
    var vPortlet = new PortletPopupWindow(window, index, 0, 11, 280, 400, LightResourceBundle._MENU_LAYOUT, "", "", "tabPortlet", Light.portal.contextPath + "/tabPortlet.lp", true, false, false, false, false, false, 0, false, "", "", "", "");
    this.tabs[index].rePositionAll();
    var id = Light._PC_PREFIX + index + "_" + vPortlet.position + "_" + vPortlet.index;
    var pars = "responseId=" + id + "&tabId=" + this.tabs[index].tabServerId;
    Light.ajax.sendRequestAndUpdate(vPortlet.request, id, {
        evalScripts: vPortlet.allowJS,
        parameters: pars
    })
};
LightPortal.prototype.addTab = function() {
    var currentTabId = this.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
    var window = eval("new " + this.tabs[index].portletWindowAppearance + "()");
    var vPortlet = new PortletPopupWindow(window, index, 0, 11, 280, 400, LightResourceBundle._MENU_ADD_TAB, "", "", "tabPortlet", Light.portal.contextPath + "/tabPortlet.lp", true, false, false, false, false, false, 0, false, "", "", "", "");
    this.tabs[index].rePositionAll();
    var id = Light._PC_PREFIX + index + "_" + vPortlet.position + "_" + vPortlet.index;
    var pars = "responseId=" + id;
    Light.ajax.sendRequestAndUpdate(vPortlet.request, id, {
        evalScripts: vPortlet.allowJS,
        parameters: pars
    })
};
LightPortal.prototype.addContent = function() {
    var currentTabId = this.GetFocusedTabId();
    if(currentTabId==null){
    	return false;
    }
    var index = currentTabId.substring(8, currentTabId.length);
    var window = eval("new " + this.tabs[index].portletWindowAppearance + "()");
    var vPortlet = new PortletPopupWindow(window, index, 0, 11, 280, 300, LightResourceBundle._MENU_ADD_CONTENT, "", "", "contentPortlet", Light.portal.contextPath + "/contentPortlet.lp", true, false, false, false, false, false, 0, false, "", "", "", "");
    if (this.tabs[index].absolute != 1) {
        this.tabs[index].rePositionAll()
    }
    var id = Light._PC_PREFIX + index + "_" + vPortlet.position + "_" + vPortlet.index;
    var pars = "responseId=" + id + "&tabId=" + this.tabs[index].tabServerId;
    Light.ajax.sendRequestAndUpdate(vPortlet.request, id, {
        evalScripts: vPortlet.allowJS,
        parameters: pars
    })
};
LightPortal.prototype.login = function() {
    var currentTabId = this.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
    var window = eval("new " + this.tabs[index].portletWindowAppearance + "()");
    var vPortlet = new PortletPopupWindow(window, index, 0, 11, 280, 400, LightResourceBundle._MENU_SIGN_IN, "", "", "userPortlet", Light.portal.contextPath + "/userPortlet.lp", true, false, false, false, false, false, 0, false, "", "", "", "");
    this.tabs[index].rePositionAll();
    var id = Light._PC_PREFIX + index + "_" + vPortlet.position + "_" + vPortlet.index;
    var pars = "responseId=" + id + "&tabId=" + this.tabs[index].tabServerId;
    Light.ajax.sendRequestAndUpdate(vPortlet.request, id, {
        evalScripts: vPortlet.allowJS,
        parameters: pars
    })
};
LightPortal.prototype.logout = function() {
    Light.deleteCookie(Light._LOGINED_USER_ID);
    Light.deleteCookie(Light._CURRENT_TAB);
    var a = new Date();
    a.setFullYear(a.getFullYear() + 1);
    Light.setCookie(Light._IS_SIGN_OUT, "true");
    var b = {
        method: "post",
        postBody: "",
        onSuccess: function(c) {
            Light.portal.responseLogout(c)
        },
        on404: function(c) {
            alert('Error 404: location "' + c.statusText + '" was not found.')
        },
        onFailure: function(c) {
            alert("Error " + c.status + " -- " + c.statusText)
        }
    };
    Light.ajax.sendRequest(Light.portal.contextPath + Light.logoutRequest, b)
};
LightPortal.prototype.responseLogout = function(a) {
    window.location.reload(true)
};
LightPortal.prototype.editProfile = function() {
    var currentTabId = this.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
    var window = eval("new " + this.tabs[index].portletWindowAppearance + "()");
    var vPortlet = new PortletPopupWindow(window, index, 0, 11, 280, 400, LightResourceBundle._MENU_MY_PROFILE, "", "", "userPortlet", Light.portal.contextPath + "/userPortlet.lp", true, false, false, false, false, false, 0, false, "", "", "", "");
    vPortlet.mode = Light._CONFIG_MODE;
    this.tabs[index].rePositionAll();
    var id = Light._PC_PREFIX + index + "_" + vPortlet.position + "_" + vPortlet.index;
    var pars = "responseId=" + id + "&tabId=" + this.tabs[index].tabServerId + "&mode=" + Light._CONFIG_MODE;
    Light.ajax.sendRequestAndUpdate(vPortlet.request, id, {
        evalScripts: vPortlet.allowJS,
        parameters: pars
    })
};
LightPortal.prototype.editTitle = function(a) {
    a.className = "portal-header-title-edit";
    a.innerHTML = "<input type='text' name='portalTitle' class='portal-header-title-edit' size='24' value=\"" + this.header.title + '" onchange="javascript:Light.portal.saveTitle();" onblur="javascript:Light.portal.saveTitle();"/>';
    document.all.portalTitle.focus()
};
LightPortal.prototype.viewTitle = function(a) {
    a.className = "portal-header-title-view";
    a.style.backgroundColor = "";
    a.innerHTML = this.header.title
};
LightPortal.prototype.saveTitle = function(b) {
    var b = document.all.portalTitle.value;
    this.header.title = b;
    this.container.removeChild(this.header.container);
    this.header.container = this.header.createContainer();
    this.container.insertBefore(this.header.container, this.body.container);
    var a = "title=" + encodeURIComponent(b);
    Light.ajax.sendRequest(Light.portal.contextPath + Light.changeTitle, {
        parameters: a
    })
};
LightPortal.prototype.saveTabTitle = function(a) {
    var e = document.all.portalTabTitle.value;
    var f = Light.portal.GetFocusedTabId();
    Light.portal.tabs[a].editTitle = false;
    if (Light.portal.tabs[a].tabIsCloseable) {
        var b = document.createElement("div");
        b.className = "portal-tab-handle";
        b.innerHTML = e;
        var c = document.createElement("img");
        c.src = Light.portal.contextPath + "/light/images/closeTab.gif";
        c.className = "portal-tab-button";
        c.onclick = function() {
            Light.portal.tabs[a].close()
        };
        document.getElementById("tabSpan" + f).innerHTML = "";
        document.getElementById("tabSpan" + f).appendChild(b);
        document.getElementById("tabSpan" + f).appendChild(c)
    } else {
        document.getElementById("tabSpan" + f).innerHTML = '<div class="portal-tab-handle">' + e + "</div>"
    }
    var d = "title=" + encodeURIComponent(e) + "&tabId=" + Light.portal.tabs[a].tabServerId;
    Light.ajax.sendRequest(Light.portal.contextPath + Light.editTabTitleRequest, {
        parameters: d
    })
};
LightPortal.prototype.setPortletContent = function(responseId, inHTML) {
    var portletIds = responseId.split("_");
    var tIndex = portletIds[1];
    var position = portletIds[2];
    var index = portletIds[3];
    var portlet = Light.getPortletById(responseId);
    Light.portal.tabs[tIndex].portlets[position][index].window.container.innerHTML = inHTML;
    if (portlet.allowJS) {
        var scriptFragment = "(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)";
        var matchAll = new RegExp(scriptFragment, "img");
        var scripts = inHTML.match(matchAll);
        if (scripts != null) {
            for (var i = 0; i < scripts.length; i++) {
                var script = scripts[i];
                var scriptBegin = "(?:<script.*?>)";
                script = script.replace(new RegExp(scriptBegin, "img"), "");
                var scriptEnd = "(?:<\/script>)";
                script = script.replace(new RegExp(scriptEnd, "img"), "");
                try {
                    eval(script)
                } catch(e) {}
            }
        } else {
            var scriptFragment2 = "(?:<script.*?>)";
            matchAll = new RegExp(scriptFragment2, "im");
            var scripts = inHTML.match(matchAll);
            if (scripts != null) {
                for (var i = 0; i < scripts.length; i++) {
                    var script = scripts[i];
                    var s = document.createElement("script");
                    s.type = "text/javascript";
                    var indx = script.indexOf("src=");
                    script = script.substring(indx + 5);
                    indx = script.indexOf(".js");
                    script = script.substring(0, indx + 3);
                    s.src = script;
                    document.getElementsByTagName("head")[0].appendChild(s)
                }
            }
        }
        inHTML = inHTML.replace(matchAll, "")
    }
    if (Light.portal.tabs[tIndex].absolute != 1) {
        Light.portal.tabs[tIndex].rePositionPortlets(Light.portal.tabs[tIndex].portlets[position][index])
    }
    resizeMainPageBodyHeight();/*调整主页面的body高度*/
};
LightPortal.prototype.responsePortlet = function(b) {
    var d = b.split("_");
    var e = d[1];
    var a = d[2];
    var c = d[3];
    Light.portal.tabs[e].rePositionPortlets(Light.portal.tabs[e].portlets[a][c]);
    this.resize()
};
LightPortal.prototype.createPortalContainer = function() {
    var a = document.createElement("div");
    a.className = "portal-container";
    if (this.bgImage.length > 0) {
        if (this.bgImage != "no") {
            a.style.background = "url('" + this.bgImage + "')"
        } else {
            a.style.background = "#ffffff"
        }
    }
    a.style.fontSize = 12 + parseInt(this.fontSize);
    a.style.width = Light.portal.layout.width;
    a.style.height = Light.portal.layout.height;
    a.style.zIndex = ++Light.maxZIndex;
    return a
};
LightPortal.prototype.refreshPortalHeader = function() {
    this.container.removeChild(this.header.container);
    this.header.container = this.header.createContainer();
    this.container.appendChild(this.header.container)
};
LightPortal.prototype.refreshPortalMenu = function(a) {};
LightPortal.prototype.collapseAll = function() {
    var a = this.GetFocusedTabId();
    var b = a.substring(8, a.length);
    this.tabs[b].collapseAll()
};
LightPortal.prototype.expandAll = function() {
    var a = this.GetFocusedTabId();
    var b = a.substring(8, a.length);
    this.tabs[b].expandAll()
};
LightPortal.prototype.resize = function(layoutWidth) {
    //var c = document.documentElement.scrollWidth - 30;
	var c = layoutWidth;
	
	/*
    * EWV2013055366 ie10新老皮肤protal页面上靠右会有空白
    * Light.getScrollerWidth方法会模拟使用两个div,通过代码使其出现滚动条，然后以此来计算浏览器中滚动条的宽度
    * 该方法在IE8,9,IE10兼容性视图中都返回0，而在IE10中此方法会返回一个有效值。
    * 此处采用IE10不进行减去滚动条宽度的方式来解决,是因为LightPortal.layout.width初始值已经减去了30，应该是考虑了滚动条的宽度
    * 而此时如果再进行一个减去滚动条宽度的操作，那么因为IE10计算滚动条宽度有有效值的原因，页面右边就会出现一些空白。
    */
    if (document.all && !isIE10Browser()) {
        c = c - Light.getScrollerWidth()
    }
    Light.portal.layout.width = c;
    Light.portal.layout.height = document.documentElement.scrollHeight - 80;
    if (this.container && Light.portal.layout.width>0 && Light.portal.layout.height>0) {
        this.container.style.width = Light.portal.layout.width;
        this.container.style.height = Light.portal.layout.height;
    }
    var a = Light.portal.GetFocusedTabId();
    if (typeof(a) == "string") {
        var b = a.substring(8, a.length);
        this.tabs[b].resize()
    }
};
LightPortal.prototype.getMaxHeight = function() {
    var f = new Array();
    var e = 0;
    var a = this.GetFocusedTabId();
    var c = a.substring(8, a.length);
    for (var d = 0; d < this.tabs[c].portlets.length; d++) {
        if (this.tabs[c].portlets[d] != null) {
            for (var b = 0; b < this.tabs[c].portlets[d].length; b++) {
                if (this.tabs[c].portlets[d][b] != null && this.tabs[c].portlets[d][b].maximized) {
                    e = this.tabs[c].portlets[d][b].top + this.tabs[c].portlets[d][b].window.container.clientHeight;
                    break
                }
                if (this.tabs[c].portlets[d][b] != null && !this.tabs[c].portlets[d][b].maximized) {
                    f[d] = this.tabs[c].portlets[d][b].top + this.tabs[c].portlets[d][b].window.container.clientHeight
                }
            }
        }
        if (e > 0) {
            break
        }
    }
    if (e == 0) {
        for (var d = 0; d < f.length; d++) {
            if (f[d] > e) {
                e = f[d]
            }
        }
    }
    e = e + Light.portal.footer.layout.top;
    if (e < 300) {
        e = 300
    }
    return e
};
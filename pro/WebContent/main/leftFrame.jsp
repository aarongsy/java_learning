<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.*" %>
<%@ page import="com.eweaver.humres.base.service.*" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ page import="com.eweaver.base.menu.MenuDisPositionEnum"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="org.light.portal.core.service.PortalService"%>
<%@ taglib uri="/WEB-INF/tlds/authz.tld" prefix="authz"%>

<%
String userAgent = StringHelper.null2String(request.getHeader("User-Agent"));
boolean fromMobile = userAgent.toLowerCase().indexOf("mobile")!=-1;

MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService") ;
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
String orgid = currentuser.getOrgid();
//List menuList = menuorgService.getMenuByOrgSetting(null);//根据menuorg设置的组织,岗位,人员返回应该显示的菜单项
List menuList = menuorgService.getMenuByOrgSetting2(null,MenuDisPositionEnum.left,null);

int menubarNum = 0;
StringBuffer menubars = new StringBuffer();
String accordianItems="";
for(int i=0;i<menuList.size();i++){
	Menu menu = (Menu)menuList.get(i);
	if (menu.getId().equals("4028808e13e143670113e1aab8a6000c")) continue ;
    String _menuname = labelCustomService.getLabelNameByMenuForCurrentLanguage(menu);
	String _imgfile=StringHelper.filterJString2(StringHelper.null2String(menu.getImgfile()));
	_imgfile = StringHelper.isEmpty(_imgfile) ? "javascript:false" : _imgfile;
	String _id=menu.getId();
	String _pid=menu.getPid();

        String expand="false";
        if(i==2)
        expand="true";
		menubars.append("var treePanel"+menu.getId()+" = new Ext.tree.TreePanel({\n" +
"            animate:true,\n" +
"            title: '<img class=menubar src=\\'"+request.getContextPath()+_imgfile+"\\'/>&nbsp;&nbsp;"+_menuname+"',\n" +
"            useArrows :true,\n" +
"            containerScroll: true,\n" +
"            collapsed : "+expand+",\n" +
"            autoScroll  : true,\n" +
"            rootVisible:false,\n" +
"            root:new Ext.tree.AsyncTreeNode({\n" +
"                text: '"+_menuname+"',\n" +
"                id: '"+menu.getId()+"',\n" +
"                allowDrag:false,\n" +
"                allowDrop:false\n" +
"            }),\n" +
"            loader:new Ext.tree.TreeLoader({\n" +
"                dataUrl: '"+request.getContextPath()+"/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getMenuStr',\n" +
"                preloadChildren:true\n" +
"            }),\n" +
"            listeners:{\n" +
"                'expand':function(p){ p.getRootNode().expand();cp.set('menubar','"+menu.getId()+"');\n" +
"                }\n" +
"            }\n" +
"        });\n");
        accordianItems+=",treePanel"+menu.getId();
	}
    %>
   <authz:authorize ifAllGranted="AUTH_402881dc0d7cf641010d7cfb03d10016">
		<%
        Menu menu=menuService.getMenu("4028808e13e143670113e1aab8a6000c");
		String _imgfile=StringHelper.filterJString2(StringHelper.null2String(menu.getImgfile()));
		
		menubars.append("var treePanel"+menu.getId()+" = new Ext.tree.TreePanel({\n" +
"            animate:true,\n" +
"            title: '<img class=menubar src=\\'"+request.getContextPath()+_imgfile+"\\'/>&nbsp;&nbsp;"+labelCustomService.getLabelNameByMenuForCurrentLanguage(menu)+"',\n" +
"            useArrows :true,\n" +
"            containerScroll: true,\n" +
"            collapsed : false,\n" +
"            autoScroll  : true,\n" +
"            rootVisible:false,\n" +
"            root:new Ext.tree.AsyncTreeNode({\n" +
"                text: '"+menu.getMenuname()+"',\n" +
"                id: '"+menu.getId()+"',\n" +
"                allowDrag:false,\n" +
"                allowDrop:false\n" +
"            }),\n" +
"            loader:new Ext.tree.TreeLoader({\n" +
"                dataUrl: '"+request.getContextPath()+"/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getMenuStr&setup=true',\n" +
"                preloadChildren:true\n" +
"            })\n," +
"            listeners:{\n" +
"                'expand':function(p){ p.getRootNode().expand();cp.set('menubar','"+menu.getId()+"');\n" +
"                }\n" +
"            }\n" +
"        });\n");
         accordianItems+=",treePanel"+menu.getId();
		%>
		</authz:authorize>
<%
    if(accordianItems.indexOf(",")==0){
      accordianItems=accordianItems.substring(1);
}

//获取当前用户门户tab的名称
PortalService portalService = (PortalService)BaseContext.getBean("portalService");
String currentPortalTabName = portalService.getCurrentPortalTabName(request);
%>
<html>
<head>
<title></title>
<style type="text/css">
   img.menubar {height:16px;width:16px;vertical-align:middle;}
   .portalIcon {background-image:url(/images/portal.gif);}
   .x-panel-btns-ct {
          padding: 0px;
      }
    #msgremind ul {list-style-type:disc;margin:20px;padding:0px;}
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
      .x-panel-btns-ct table {width:0}
      
.portalTabDot{
	width: 10px;
	height: 13px;
	border: 0;
	background: url(/images/main/dot_white.gif) no-repeat;
	margin: 0 3px;
	padding-bottom: 2px;
	cursor: hand;
}
.active{
	width: 16px;
	height: 16px;
	background: url(/images/main/dot_white2.gif) no-repeat;
	color: #000;
	font-family: arial;
	font-weight: bold;
	font-size: 9px;
}
/*当前门户tab页的样式定义*/
.x-toolbar table.currPortalTabBtn .x-btn-center .x-btn-text{
	font-weight: bold;	
}
</style>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/TabCloseMenu.js"></script>
<script type="text/javascript" src="/js/ext/ux/MessageBus.js"></script>
<script type="text/javascript" src="/js/ext/ux/DDTabPanel.js"></script>
<script type="text/javascript" src="/js/ext/ux/storemenu.js"></script>
<script type="text/javascript" src="/js/ext/ux/ToolbarLayout.js"></script>
<script type="text/javascript" src="/js/ext/ux/TabCloseButtonEweaver.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/ux/css/DDTabPanel.css" />
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/ux/css/ToolbarLayout.css" />
<jsp:include page="/main/pubLeftFrame.jsp"></jsp:include>
<script type="text/javascript">
    var currentItem;
    var contentPanel;
    Ext.SSL_SECURE_URL='<%= request.getContextPath()%>/blank.htm';
var accordion;

    var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
    //Ext.QuickTips.init();
    
    Ext.layout.Accordion.prototype.renderItem = function(c){
        if(currentItem)
        this.activeItem=currentItem;
        if(this.animate === false){
            c.animCollapse = false;
        }
        c.collapsible = true;
        if(this.autoWidth){
            c.autoWidth = true;
        }
        if(this.titleCollapse){
            c.titleCollapse = true;
        }
        if(this.hideCollapseTool){
            c.hideCollapseTool = true;
        }
        if(this.collapseFirst !== undefined){
            c.collapseFirst = this.collapseFirst;
        }
        if(!this.activeItem && !c.collapsed){
            this.activeItem = c;
        }else if(this.activeItem!=c){
            c.collapsed = true;
        }

        Ext.layout.Accordion.superclass.renderItem.apply(this, arguments);
        c.header.addClass('x-accordion-hd');
        c.on('beforeexpand', this.beforeExpand, this);
    };
    Ext.onReady(function() {
		<%=menubars.toString()%>
        var currentMenubar=cp.get('menubar');
        if(!Ext.isEmpty(currentMenubar)){
            try{
        currentItem=eval("treePanel"+currentMenubar);
            }catch(e){};
        }
        var fill=cp.get('fill');
        if(!Ext.isEmpty(fill)&&fill=='false'){
            fill=false;
        }else
        fill=true;
        accordion = new Ext.Panel({
            id:'accordion',
            region:'west',
            margins:'0 0 0 5',
            hideBorders: true,
            autoScroll:true,
            collapsible: true,
            collapseMode:'mini',
            split:true,
            width: 180,
            title:'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000c") %>',//菜单导航
            layout:'accordion',
            layoutConfig: {
                //activeOnTop: true,
                fill:fill,
                animate: true
            },
            items: [<%=accordianItems%>]
        });

        
		var portalTabToolbar = new Ext.Toolbar({});
        
        contentPanel =new Ext.ux.panel.DDTabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            //autoScroll:true,
            plugins: [new Ext.ux.TabCloseMenu()],
            activeTab:0,
            items:[{
                title: "<%=currentPortalTabName%>",
                iconCls:'portalIcon',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{ id:'portalframe', name:'portalframe', frameborder:0 },
                    eventsFollowFrameLinks : false
                },
                frameStyle: {
                	padding: '0 0 22px 0'
                },
                defaultSrc:'/portal.jsp',
                closable:false,
                autoScroll:true,
                listeners:{'activate':function(p){
                  var o = document.getElementById('btnTabClose');
                  if(o&&o.style.display!='none') o.style.display='none';
                  if(p.getFrameWindow().Light) {
                      try {
                          portalobj = p.getFrameWindow().Light;
                          var tabId = portalobj.portal.GetFocusedTabId();
                          if (typeof(tabId) == 'undefined') return;
                          var index = tabId.substring(8, tabId.length);//tab id perfix tab_page
                          portalobj.portal.tabs[index].rePositionAll();
                      } catch(e) {p.getFrameWindow().location='/portal.jsp';
                      }
                  }
                }},
                tbar: portalTabToolbar
            }]
        });

        var viewport = new Ext.Viewport({
        layout: 'border',
        items: [accordion,contentPanel]
	   });
        if(currentItem){
        currentItem.expand();
        count=0;
            currentItem.on('expandnode', function(n) {
                n.eachChild(function() {
                    count++;
                });
                lo = accordion.getLayout();
                if (fill &&count>3&& lo.activeItem.getBox().height < 200) {
                    cp.set("fill", 'false');
                    //window.location.reload();
                } else
                    cp.set("fill", 'true');
            })


        }
    });
    function onUrl(url, title, id, inactive, image, onCloseCallbackFn) {
        if (contextPath != '' && url.indexOf('http:') == -1 && (url.indexOf(contextPath) == -1 || url.indexOf(contextPath) > 1))
            url = contextPath + url+'&tabId='+id;
		
        if (id) {
            var tab = contentPanel.getComponent(id);
            if (tab) {
                if (id.indexOf('qs') == 0) {
                    if (Ext.isGecko)
                        url = decodeURI(url);
                    else
                        ;
                    con = url.substring(url.lastIndexOf('&') + 1);
                    conname = con.substring(0, con.indexOf('='));
                    conval = con.substring(con.indexOf('=') + 1);
                    if(Ext.get('quicksearch').first()){
                       Ext.get('quicksearch').first().remove(); 
                    }
                    Ext.getDom('quicksearch').action = url.substring(0, url.lastIndexOf('&'));
                    Ext.getDom('quicksearch').target = id + 'frame';
                    Ext.get('quicksearch').insertFirst({tag:'input',type:'hidden',name:conname,value:conval});
                    Ext.getDom('quicksearch').submit();
                }
                if (inactive)
                    ;
                else
                    contentPanel.setActiveTab(tab);
                return;
            }
        } else
            id = Ext.id();

        var max = 20;
        var maxTab = 10;
        if (contentPanel.items.length >= maxTab) {
            contentPanel.items.each(function() {
                if (this.closable) {
                    contentPanel.remove(this);
                    return false;
                }
            });
        }
        if (!title)
            title = '';
        if (title.length > max)
            title = "<font ext:qtip='" + title + "'>" + title.substring(0, max) + "...</font>";
        var p;
        if (id.indexOf('qs') == 0) {
            p = contentPanel.add({
                id:id,
                iconCls:image ? Ext.ux.iconMgr.getIcon(image) : null,
                title: title,
                xtype     :'iframepanel',
                frameConfig: {
                    id:id + 'frame',
                    name:id + 'frame',
                    frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            });
            if (inactive)
                ;
            else
                contentPanel.setActiveTab(p);
            //Ext.get('quicksearch').first().remove();
            if (Ext.isGecko)
                url = decodeURI(url);
            else
                ;
            con=url.substring(url.lastIndexOf('&')+1);
            conname=con.substring(0,con.indexOf('='));
            conval=con.substring(con.indexOf('=')+1);
            if(Ext.get('quicksearch').first()){
                       Ext.get('quicksearch').first().remove();
                    }
            Ext.getDom('quicksearch').action = url.substring(0,url.lastIndexOf('&'));
            Ext.getDom('quicksearch').target = id + 'frame';
            Ext.get('quicksearch').insertFirst({tag:'input',type:'hidden',name:conname,value:conval});
            Ext.getDom('quicksearch').submit();
            return;
        } else {
            if (Ext.isGecko)
                ;
            else
                url = encodeURI(url);
            p = contentPanel.add({
                id:id,
                iconCls:image ? Ext.ux.iconMgr.getIcon(image) : null,
                title: title,
                xtype     :'iframepanel',
                frameConfig: {
                    id:id + 'frame',
                    name:id + 'frame',
                    frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                <%if(fromMobile){%>plugins: new Ext.ux.TabCloseButtonEweaver(),<%}%>
                defaultSrc:{url:url,discardUrl:true},
                autoScroll:true
            });            
        }
        if (inactive)
            ;
        else
            contentPanel.setActiveTab(p);
        
        p.onCloseCallbackFn = onCloseCallbackFn;
        
        contentPanel.on('beforeremove', function(c, p) {
            if (p.removed)
                return true;
         	p.removed = true;
         	if(p.onCloseCallbackFn && typeof(p.onCloseCallbackFn) == "function"){
         		try{
         			p.onCloseCallbackFn();
         		}catch(e){
         		}
         	}
         	//禁用掉关闭的tab页面的附件
         	var iframeWindow = p.getFrameWindow();
			if(iframeWindow && typeof(iframeWindow.destroyAllMultiUploadObj) == "function"){
				iframeWindow.destroyAllMultiUploadObj();
			}
            contentPanel.remove(p);
            return false;
        });
    }
    function doRefresh(){
    	if(contentPanel.getActiveTab().defaultSrc=='/portal.jsp'){
    		var t = contentPanel.getActiveTab().getTopToolbar();
    		if(t){
    			t.hide();
    		}
    	}
        contentPanel.getActiveTab().getFrameWindow().location.reload(true);
    }
    function doBack(){
        contentPanel.getActiveTab().getFrameWindow().history.back();
    }
    function doForward(){
        contentPanel.getActiveTab().getFrameWindow().history.forward();
    }
    function doDestroy(){
        contentPanel.items.each(function(item){
                     if(this.closable){
                      contentPanel.remove(item);      
                     }
                    });
    }
    function hideContextMenu(){
        Ext.menu.MenuMgr.hideAll();
    }

    function subscribe(subject) {
        Ext.ux.util.MessageBus.subscribe(
                subject,
                function(subject, content) {
                    if (subject == 'refreshtab') {
                        contentPanel.items.each(function(item) {
                            if (item.id.indexOf(content) > -1||item.getFrameWindow().location.href.indexOf(content)>-1) {
                                item.getFrameWindow().location.reload(true);
                            }
                        });
                    }
                    if (subject == 'refreshstore') {
                        contentPanel.items.each(function(item) {
                            if (item.id.indexOf(content) > -1||item.getFrameWindow().location.href.indexOf(content)>-1) {
                                if (item.getFrameWindow().store){
                                    item.getFrameWindow().store.load();
                                }
                            }
                        });
                    }
                }
                );
    }
    subscribe('refreshtab');
    subscribe('refreshstore');
    function publish(subject,content){
        Ext.ux.util.MessageBus.publish(subject, content);
    }

var dotCurrent = 1;

/**
 * 点击滚屏按钮滑动门户,并设置滚屏按钮的CSS。
 */
function portalTabSlide(ele){
	var dots = ele.parentNode.childNodes;//alert(dots.length);
	var dotTarget = ele.getAttribute('dotid');

	if(dotCurrent==dotTarget){
		return false;
	}

	for(var i=0;i<dots.length;i++){
		if(dots[i].getAttribute('dotid')==dotTarget){
			dots[i].setAttribute('className', 'portalTabDot active');
			dots[i].innerText = dotTarget;
		}else{
			dots[i].setAttribute('className', 'portalTabDot');
			dots[i].innerText = '';
		}
	}

	var w = contentPanel.getActiveTab().getFrameWindow();
	/*
	var temp = w.pageWidth() * (dotTarget - dotCurrent);
	w.$('.portlet2').each(function(i){
  		w.$(this).animate({"left": "-="+temp+"px"}, 500);
  	});
	*/
	w.slidePortal(dotTarget);
	w.document.body.focus();
	
	dotCurrent = dotTarget;
}
/**
 * 
 * @param {Object} scrolls
 */
function createPDot(objToolbar, scrolls){
	var box = document.createElement("span");
	box.id = 'pDotBox';
	for(var i=1;i<=scrolls;i++){
		if(i==1){
			box.innerHTML += '<button class="portalTabDot active" dotid="'+i+'" id="pDot'+i+'" onclick="portalTabSlide(this)">'+i+'</button>';
		}else{
			box.innerHTML += '<button class="portalTabDot" dotid="'+i+'" id="pDot'+i+'" onclick="portalTabSlide(this)"></button>';	
		}
	}
	objToolbar.add(box);
}
/**
 * 根据PortalTab设置的滚屏数加载滚屏按钮。
 * @param {Object} scrolls
 */
function loadPDot(scrolls){
	var box = Ext.get("pDotBox").dom;
	if(box){
		box.innerHTML = "";
		for(var i=1;i<=scrolls;i++){
			if(i==1){
				box.innerHTML += '<button class="portalTabDot active" dotid="'+i+'" id="pDot'+i+'" onclick="portalTabSlide(this)">'+i+'</button>';
			}else{
				box.innerHTML += '<button class="portalTabDot" dotid="'+i+'" id="pDot'+i+'" onclick="portalTabSlide(this)"></button>';	
			}
		}
	}
}
/**
 * 打开PortalTab,并根据滚屏数调整PortalContainer的宽度。
 * @param {Object} i
 */
function openTab(i, portalTabName){
	Ext.Ajax.request({
		url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.portal.servlet.PortalAction?action=getPortalTabScrolls',
		params:{tabId: i},
		success: function(response, options){
			var scrolls = response.responseText;
			var portalTab = contentPanel.items.get(0);
			var w = portalTab.getFrameWindow();
			var portalTabWidth = w.document.documentElement.offsetWidth * scrolls - 30;
			w.Light.portal.layout.width = portalTabWidth;
			w.currentPortalTabScrolls = scrolls;
			loadPDot(scrolls);
			portalTabSlide(document.getElementById('pDot1'));
			w.openTab(i);
			w.Light.portal.resize(portalTabWidth);
			w.document.body.focus();
			if(portalTabName){
				portalTab.setTitle(portalTabName);
			}
			addClassToCurrentPortalTabBtn(i, true);
		}
	});
}

function addClassToCurrentPortalTabBtn(tabId, isFindParant){
	var matchBtnTable = null;
	Ext.each(Ext.query(".x-toolbar table.x-btn"), function(){
		Ext.fly(this).removeClass('currPortalTabBtn'); 
		var btnTableId = this.getAttribute("id");
		if(btnTableId == tabId){
			matchBtnTable = this;
			Ext.fly(this).addClass('currPortalTabBtn'); 
			return;
		}
	});
	if(matchBtnTable == null && isFindParant){	//查找顶级tabid,并增加样式设置
		Ext.Ajax.request({
			url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.portal.servlet.PortalAction?action=getTopParentTabid',
			params:{tabId: tabId},
			success: function(response, options){
				var topParentTabid = response.responseText;
				addClassToCurrentPortalTabBtn(topParentTabid, false);	//递归，但是仍未找到的话不再查找顶级tabid
			}
		});
	}
}
</script>
</head>
<body class="ytheme-gray" >
<script>Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';</script>
<form id="quicksearch" name="quicksearch" method="post"></form>
<button type=button id="btnTabClose" style="display:none;position:absolute;z-index:9999;top:0;width:30px;height:30px;border:0;padding:0;margin:0;background:url(/images/fancy_close.png);" onclick="javascript:var o=contentPanel;if(o)o.remove(o.getActiveTab());"></button>
</body>
</html>

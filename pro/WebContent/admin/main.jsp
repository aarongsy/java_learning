<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.humres.base.model.*" %>
<%@ page import="com.eweaver.humres.base.service.*" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
List menuList = menuService.getSubMenus("4028808e13e143670113e1aab8a6000c","1","1");
StringBuffer menubars = new StringBuffer();
String accordianItems="";
for(int i=0;i<menuList.size();i++){
	Menu menu = (Menu)menuList.get(i);
	String _id=menu.getId();
	String _pid=menu.getPid();
	if (_id.equals("4028808e13e143670113e1aab8a6000c")) continue ;
    String _menuname="";
    if(StringHelper.isEmpty(_menuname)){_menuname=menu.getMenuname();}
	String _imgfile=StringHelper.filterJString2(StringHelper.null2String(menu.getImgfile()));

	String expand="false";
    if(i==2)	expand="true";
	menubars.append("var treePanel"+menu.getId()+" = new Ext.tree.TreePanel({\n" +
"            animate:true,\n" +
"            title: '<img class=menubar src=\\'"+_imgfile+"\\'/>&nbsp;&nbsp;"+_menuname+"',\n" +
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
"                dataUrl: '/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getMenuStr&setup=true&menutype=1',\n" +
"                preloadChildren:true\n" +
"            }),\n" +
"            listeners:{\n" +
"                'expand':function(p){ p.getRootNode().expand();cp.set('menubar','"+menu.getId()+"');\n" +
"                }\n" +
"            }\n" +
"        });\n");
        accordianItems+=",treePanel"+menu.getId();
	}
if(accordianItems.indexOf(",")==0){
   accordianItems=accordianItems.substring(1);
}
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
</style>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/TabCloseMenu.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/notification.js"></script>
<script type="text/javascript" src="/js/ext/ux/MessageBus.js"></script>
<script type="text/javascript" src="/js/popup.js"></script>
<script type="text/javascript" src="/js/ext/ux/DDTabPanel.js"></script>
<link rel="stylesheet" type="text/css" href="/js/ext/ux/css/DDTabPanel.css" />
<script type="text/javascript">
    var currentItem;
    var contentPanel;
    var commonDialog;
    Ext.SSL_SECURE_URL='/blank.htm';

    var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
    Ext.QuickTips.init();
    
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
        var accordion = new Ext.Panel({
            id:'accordion',
            region:'west',
            margins:'0 0 5 5',
            autoScroll:true,
            collapsible: true,
            collapseMode:'mini',
            split:true,
            width: 175,
            title:'管理菜单',
            layout:'accordion',
            layoutConfig: {
                //activeOnTop: true,
                fill:fill,
                animate: true
            },
            items: [<%=accordianItems%>]
        });
        contentPanel =new Ext.ux.panel.DDTabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            plugins: new Ext.ux.TabCloseMenu(),
            activeTab:0,
            items:[{
                title: '运行桌面',
                iconCls:Ext.ux.iconMgr.getIcon('house'),
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{ id:'portalframe', name:'portalframe', frameborder:0 },
                    eventsFollowFrameLinks : false
                },
                defaultSrc:'/admin/admin.jsp',
                closable:false,
                autoScroll:true,
                listeners:{'activate':function(p){
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
                }}
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
                    window.location.reload();
                } else
                    cp.set("fill", 'true');
            })


        }


        //common dialog
        if(!commonDialog){
            commonDialog = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:viewport.getSize().width*0.8,
                height:viewport.getSize().height*0.8,
                buttons: [{
                    text     : '关闭',
                    handler  : function(){
                        commonDialog.hide();
                        commonDialog.getComponent('commondlg').setSrc('about:blank');
                    }
                }],
                items:[{
                id:'commondlg',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }]
            });
        }
        commonDialog.render(Ext.getBody());
        //send();
        //window.setInterval("send()", 5 * 60 * 1000);        
    });
    function onUrl(url, title, id, inactive, image) {
        if (contextPath != '' && url.indexOf('http:') == -1 && (url.indexOf(contextPath) == -1 || url.indexOf(contextPath) > 1))
            url = contextPath + url;

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
                defaultSrc:{url:url,discardUrl:true},
                autoScroll:true
            });
        }
        if (inactive)
            ;
        else
            contentPanel.setActiveTab(p);
        contentPanel.on('beforeremove', function(c, p) {
            if (p.removed)
                return true;
           /* var url = p.getFrameWindow().location.href;
            var iseditwf = false; //流程
            var iseditfb = false; //表单
            var iseditdoc = false;//文档
            var isedithumres = false;//人员
            if (url.indexOf("workflow.jsp") > -1) {
                if (p.getFrame().getDom('bView') && p.getFrame().getDom('bView').value == 0)
                    iseditwf = true;
            }
            if (url.indexOf("formbase.jsp") > -1) {
                if (p.getFrame().getDom('notifyclose') && p.getFrame().getDom('notifyclose').value == 1)
                    iseditfb = true;
            }
            if (url.indexOf("docbasecreate.jsp") > -1 || url.indexOf("docbasemodify.jsp") > -1) {
                iseditdoc = true;
            }
            if (url.indexOf("humresmodify.jsp") > -1 || url.indexOf("humrescreate.jsp") > -1) {
                isedithumres = true;
            }
            if (iseditfb || iseditwf || iseditdoc || isedithumres) {
                Ext.Msg.buttonText = {yes:'是',no:'否'};
                //为了使确认对话框不被WebOffice控件覆盖，使用系统确认框
                if(confirm('您确定要关闭当前输入窗口吗?')){*/
                	p.removed = true;
                    contentPanel.remove(p);
                //}
                /*Ext.MessageBox.confirm('', '您确定要关闭当前输入窗口吗?', function (btn, text) {
                    if (btn == 'yes') {
                        p.removed = true;
                        contentPanel.remove(p);
                    }
                });*/
            /*} else {
                return true;
            }*/
            return false;
        });
    }
    function doRefresh(){
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
                       contentPanel.remove(item);                      
                    });
    }
    function hideContextMenu(){
        Ext.menu.MenuMgr.hideAll();
    }
    function openWin(url, title, image, width, height) {
        if(contextPath!=''&&url.indexOf('http:')==-1&&url.indexOf(contextPath)==-1)
        url=contextPath+url;
        if(title)
        commonDialog.setTitle(title);
        else
        commonDialog.setTitle('');
        if(image)
        commonDialog.setIconClass(Ext.ux.iconMgr.getIcon(image));
        else
        commonDialog.setIconClass(null);
        if(width)
        commonDialog.setWidth(width);
        if(height)
        commonDialog.setHeight(height);
        commonDialog.getComponent('commondlg').setSrc(url);
        commonDialog.show();

    }

     var notify;

    function pop(msg,title,showtime,icon) {
        if(!notify){
        notify=new Ext.ux.Notification({
            iconCls:    icon?Ext.ux.iconMgr.getIcon(icon): Ext.ux.iconMgr.getIcon('lightbulb'),
            title:      title?title:'提示',
            html:       msg,
            autoDestroy: true,
            hideDelay:  showtime?showtime:3000
        }).show(document);
        }else{
        notify.setDelay(3000);
        notify.setTitle(title?title:'提示');
        notify.setMessage(msg);
        notify.setDelay(showtime?showtime:3000);
        notify.show(document);
        }
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
    function doPopup(o){
     if(!o==""){
         if(Ext.isIE){
         setPoppupHeight(o.substring(0,o.indexOf(",")));
         handlenewrequest(o.substring(o.indexOf(",")+1)) ;
         }else{
             msg='<div id=msgremind style=\"overflow:auto;text-align: left;\">'+o.substring(o.indexOf(",")+1)+'</div><div style=\"text-align: center;\"><a id=sysRemindInfo onclick=\"onUrl(\'/notify/SysRemindInfoFrame.jsp\', \'消息提醒\', \'tab402880351e44500a011e4465e0cf0023\', false, \'bell\');\" href=\"#\">我要处理</a></div>';
             pop(msg,'消息提醒') ;
         }
     }
}

function send(){
    //doPopup("1,<tr><td width='13'><img src='/images/PopupMsgDot.gif'></td><td>test message</td></tr>");
    //NotifyService.pullNotify(doPopup);
}
</script>
</head>
<body class="ytheme-gray" onunload="doDestroy()">
<script>Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';</script>
<form id="quicksearch" name="quicksearch" method="post">
<div id="headerTabs">
		<ul>
			<li class="more"><a href="javascript:showOrHideMoreTabs();"><p></p></a></li>
		</ul>
	</div>
</form>


</body>
</html>

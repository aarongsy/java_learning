
    var currentItem=null;
    var contentPanel=null;
    var commonDialog=null;
    Ext.SSL_SECURE_URL='/blank.htm';


    var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
    
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
		Ext.QuickTips.init();
        //common dialog
        if(!commonDialog){
        	var items=[{
                id:'commondlg',
                region:'center',
                /*xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },*/
                autoScroll:true
            }];
            var btns=[{
                    text     : '关闭',
                    handler  : function(){
                        commonDialog.hide();
                        commonDialog.getComponent('commondlg').setSrc('about:blank');
                    }
                }];
            commonDialog = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
                buttons: btns,
                items:items
            });
        }
        commonDialog.render(Ext.getBody());
        //send();
        //window.setInterval("send()", 5 * 60 * 1000);        
    });

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
                	return null;
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
    //subscribe('refreshtab');
    //subscribe('refreshstore');

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
    NotifyService.pullNotify(doPopup);
}
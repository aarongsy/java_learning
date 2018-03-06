/**
该js中保存的方法为leftFrame.jsp和index.jsp共用
**/
var notify;
var commonDialog;

window.onload = function(){
	//common dialog
    if(!commonDialog){
        commonDialog = new Ext.Window({
            layout:'border',
            closeAction:'hide',
            plain: true,
            modal :true,
            width:document.body.offsetWidth*0.8,
            height:document.body.offsetHeight*0.8,
            buttons: [{
                text     : '关闭',//关闭
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
};

function pop(msg,title,showtime,icon) {
    if(!notify){
	    notify=new Ext.ux.Notification({
	        iconCls:    icon?Ext.ux.iconMgr.getIcon(icon): Ext.ux.iconMgr.getIcon('lightbulb'),
	        title:      title?title:'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d") %>',//提示
	        html:       msg,
	        autoDestroy: true,
	        hideDelay:  showtime?showtime:3000
	    }).show(document);
    }else{
	    notify.setDelay(3000);
	    notify.setTitle(title?title:'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d") %>');//提示
	    notify.setMessage(msg);
	    notify.setDelay(showtime?showtime:3000);
	    notify.show(document);
    }
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
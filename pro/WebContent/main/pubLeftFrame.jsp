<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.label.service.LabelService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%
	LabelService labelService = (LabelService)BaseContext.getBean("labelService");
%>
<html>
<head>
<script type='text/javascript' src='/dwr/interface/NotifyService.js'></script>
<script type='text/javascript' src='/dwr/interface/DataService.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type="text/javascript" src="/js/popup.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/notification.js"></script>
<script type="text/javascript">
DWREngine.setErrorHandler(dwrErrorHandlerWeaver);
function dwrErrorHandlerWeaver(msg , ex){
	var message = '<%=labelService.getLabelNameByKeyId("402883053c09ccf4013c09ccf4b00000") %>';//您的会话已超时，请重新登录。
	alert(message);
	window.top.location.href="/main/login.jsp";
}
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

	send();
    window.setInterval("send()", 5 * 60 * 1000); 
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

function closeWin(){
	if(commonDialog){
		commonDialog.hide();
	}
}

function doPopup(o){
     if(!o==""){
         if(Ext.isIE){
         setPoppupHeight(o.substring(0,o.indexOf(",")));
       //获取系统设置中超时提醒设置时间，如果设置为0，则不隐藏，默认150，不能设置为负数
         var sql = "select ITEMVALUE from SETITEM where id='402883c33c8f80bf013c8f80c4480293'";
         var timeout=0;
         DWREngine.setAsync(false);
         DataService.getValue(sql,function(value){
        	 timeout=value;
         });
         DWREngine.setAsync(true);
         handlenewrequest(o.substring(o.indexOf(",")+1),timeout);
         }else{
             msg='<div id=msgremind style=\"overflow:auto;text-align: left;\">'+o.substring(o.indexOf(",")+1)+'</div><div style=\"text-align: center;\"><a id=sysRemindInfo onclick=\"onUrl(\'/notify/SysRemindInfoFrame.jsp\', \'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000e") %>\', \'tab402880351e44500a011e4465e0cf0023\', false, \'bell\');\" href=\"#\"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000f") %></a></div>';//消息提醒  我要处理
             pop(msg,'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000e") %>') ;//消息提醒
         }
     }
}

function send(){
    //doPopup("1,<tr><td width='13'><img src='/images/PopupMsgDot.gif'></td><td>test message</td></tr>");
    NotifyService.pullNotify(doPopup);
    warnRemind();
    warnWebRemind();
}

function warnRemind() {
	Ext.Ajax.request({    
         url : contextPath+'/ServiceAction/com.eweaver.task.servlet.JobRemindAction?action=pop',    
         timeout:240000,               
         success : function(response) {                       
              var respText = response.responseText;  
               doPopup(respText);
          }                      
	})
}
function warnWebRemind() {
	Ext.Ajax.request({    
          url : contextPath+'/ServiceAction/com.eweaver.task.servlet.JobRemindAction?action=isneedopen',    
          timeout:240000,               
          success : function(response) {                       
               var respText = response.responseText;  
               if(respText != '0') {
                   window.open(contextPath+'/ServiceAction/com.eweaver.task.servlet.JobRemindAction?action=web');
               }
           }                      
	})
}
</script>
</head>
<body></body>
</html>
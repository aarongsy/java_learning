function CLASS_MSN_MESSAGE(id,width,height,caption,title,message,target,action){
    this.id     = id;
    this.title  = title;
    this.caption= caption;
    this.message= message;
    this.target = target;
    this.action = action;
    this.width    = width?width:200;
    this.height = height?height:120;
    this.timeout= 150;
    this.speed    = 20;
    this.step    = 1;
    this.right    = screen.width -1;
    this.bottom = screen.height;
    this.left    = this.right - this.width;
    this.top    = this.bottom - this.height;
    this.timer    = 0;
    this.pause    = false;
    this.close    = false;
    this.autoHide    = true;
    this.url    = "";
    this.liststr  = "";
}


 //隐藏消息方法

CLASS_MSN_MESSAGE.prototype.hide = function(){
    if(this.onunload()){

        var offset  = this.height>this.bottom-this.top?this.height:this.bottom-this.top;
        var me  = this;

        if(this.timer>0){
            window.clearInterval(me.timer);
        }

        var fun = function(){
            if(me.pause==false||me.close){
                var x  = me.left;
                var y  = 0;
                var width = me.width;
                var height = 0;
                if(me.offset>0){
                    height = me.offset;
                }

                y  = me.bottom - height;

                if(y>=me.bottom){
                    window.clearInterval(me.timer);
                    me.Pop.hide();
                } else {
                    me.offset = me.offset - me.step;
                }
                me.Pop.show(x,y,width,height);
            }
        }

        this.timer = window.setInterval(fun,this.speed)
    }
}


//    消息卸载事件，可以重写

CLASS_MSN_MESSAGE.prototype.onunload = function() {
    return true;
}

 //  消息命令事件，要实现自己的连接，请重写它


CLASS_MSN_MESSAGE.prototype.oncommand = function(url){
    //this.close = true;
    //this.hide();
   window.open(contextPath+url);
}


//   消息显示方法

CLASS_MSN_MESSAGE.prototype.show = function(){

    var oPopup = window.createPopup(); //IE5.5+
    oPopup.document.createStyleSheet(contextPath+"/js/ext/resources/css/ext-all.css");
    if(style!=""&&style!="default")
    oPopup.document.createStyleSheet(contextPath+"/js/ext/resources/css/xtheme-"+style+".css");
    var s = oPopup.document.createStyleSheet();
    s.addRule('.remind', 'background-image:url(../images/silk/bell.gif);');
    s.addRule('ul', 'list-style-type:disc;margin:20px;padding:0px;');
    this.Pop = oPopup;
    var link = this.url;
    var w = this.width;
    var h = this.height;
    var dealLabel = "我要处理";

      var  str="<div class=\"x-window x-notification x-resizable-pinned\" \n" +
"     HEIGHT: " + h + "px;>\n" +
"    <div class=\"x-window-tl\">\n" +
"        <div class=\"x-window-tr\">\n" +
"            <div class=\"x-window-tc\">\n" +
"                <div class=\"x-window-header x-unselectable x-panel-icon remind\" \n" +
"                     style=\"-moz-user-select: none;\">\n" +
"                    <div class=\"x-tool x-tool-close\" id=btSysClose> </div>\n" +
"                    <span class=\"x-window-header-text\" >消息提醒</span></div>\n" +
"            </div>\n" +
"        </div>\n" +
"    </div>\n" +
"    <div class=\"x-window-bwrap\" >\n" +
"        <div class=\"x-window-ml\">\n" +
"            <div class=\"x-window-mr\">\n" +
"                <div class=\"x-window-mc\">\n" +
"                    <div class=\"x-window-body\"  style=\"width: 186px; height:"+(h-30)+"px;\">\n" +
"<div style=\"overflow:auto;height:"+(h-45)+"px;\">"+this.message+
"</div><div style=\"text-align: center;\"><a id=sysRemindInfo href='#'>"+dealLabel+"</a></div>"+
"                    </div>\n" +
"                </div>\n" +
"            </div>\n" +
"        </div>\n" +
"        <div class=\"x-window-bl x-panel-nofooter\">\n" +
"            <div class=\"x-window-br\">\n" +
"                <div class=\"x-window-bc\"/>\n" +
"            </div>\n" +
"        </div>\n" +
"    </div>\n" +
"</div>"

    oPopup.document.body.innerHTML = str;

    this.offset  = 0;
    var me  = this;

    oPopup.document.body.onmouseover = function(){me.pause=true;}
    oPopup.document.body.onmouseout = function(){me.pause=false;}
    var currentdate=0;
    var times = 0;
    var fun = function(){
        var x  = me.left;
        var y  = 0;
        var width    = me.width;
        var height    = me.height;

            if(me.offset>me.height){
                height = me.height;
            } else {
                height = me.offset;
            }

        y  = me.bottom - me.offset;
        if(y<=me.top){
            //me.timeout--;
            //if(me.timeout==0){
        	if(Math.round((new Date().getTime()-currentdate)/1000)==me.timeout){
                window.clearInterval(me.timer);
                if(me.autoHide){
                    me.hide();
                }
            }
        } else {
            me.offset = me.offset + me.step;
        }
        if (times == 0) currentdate = new Date().getTime();
        times++;
        me.Pop.show(x,y,width,height+17);

    }

    this.timer = window.setInterval(fun,this.speed)

    var btClose = oPopup.document.getElementById("btSysClose");

    btClose.onclick = function(){
        me.close = true;
        me.hide();
    }

    var sysRemindInfo = oPopup.document.getElementById("sysRemindInfo");

    sysRemindInfo.onclick = function(){
    	me.hide();
        onUrl(contextPath+"/notify/SysRemindInfoFrame.jsp","消息提醒","tab402880351e44500a011e4465e0cf0023",false,"bell");
    }

}

// 设置速度方法

CLASS_MSN_MESSAGE.prototype.speed = function(s){
    var t = 20;
    try {
        t = praseInt(s);
    } catch(e){}
    this.speed = t;
}


//设置步长方法

CLASS_MSN_MESSAGE.prototype.step = function(s){
    var t = 1;
    try {
        t = praseInt(s);
    } catch(e){}
    this.step = t;
}

CLASS_MSN_MESSAGE.prototype.rect = function(left,right,top,bottom){
    try {
        this.left        = left    !=null?left:this.right-this.width;
        this.right        = right    !=null?right:this.left +this.width;
        this.bottom        = bottom!=null?(bottom>screen.height?screen.height:bottom):screen.height;
        this.top        = top    !=null?top:this.bottom - this.height;
    } catch(e){}
}


var count =5;
var  MSG1Array = new Array();
function handlenewrequest(str) {
	hideMSG1();
    var height = 120 + count * 17;

    var MSG1 = new CLASS_MSN_MESSAGE("",210,height,"提醒","消息提醒",str,"","");
    MSG1.rect(null,null,null,screen.height-60);
    MSG1.speed    = 30;
    MSG1.step    = 10;

    MSG1.show();
	MSG1Array.push(MSG1);
}

function handlenewrequest(str,timeout) {
	hideMSG1();
    var height = 120 + count * 17;
    var MSG1 = new CLASS_MSN_MESSAGE("",210,height,"提醒","消息提醒",str,"","");
    MSG1.rect(null,null,null,screen.height-60);
    MSG1.speed    = 30;
    MSG1.step    = 10;
    if (timeout != '0')
    	MSG1.timeout = timeout;
    else 
    	MSG1.timeout = 1000000000000000;
    MSG1.show();
	MSG1Array.push(MSG1);
}

function hideMSG1(){
	for(var i=0;i<MSG1Array.length;i++){
		var MSG1 = MSG1Array[i];
		if(MSG1){
			MSG1.hide();
			MSG1Array.remove(MSG1);
		}
	}
}

function setPoppupHeight(num) {
    count = num * 1 + 1;
}



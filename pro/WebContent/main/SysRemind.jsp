<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp" %>

<HTML><HEAD>
<script type='text/javascript' src='/dwr/interface/NotifyService.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

<style type="text/css">
TABLE.MenuPopUp {
	BACKGROUND-COLOR: #4A96EB;
	BORDER-BOTTOM: #000000 1px outset;
	BORDER-LEFT: #000000 1px outset;
	BORDER-RIGHT: #000000 1px outset;
	BORDER-TOP: #000000 1px outset;
	FILTER: alpha(OPACITY = 100);
	FONT-SIZE: 8pt;
	MARGIN: 0px;
	WIDTH: 100%
}
TR.MenuPopUp {
	BACKGROUND-COLOR: gray;
	PADDING-BOTTOM: 2px;
	PADDING-TOP: 2px
}
TD.MenuPopUp {
	COLOR: white;
	HEIGHT: 24px;
	PADDING-LEFT: 3px;
	TEXT-ALIGN: left
}
TD.MenuPopUpFocus {
	COLOR: red;
	CURSOR: hand;
	HEIGHT: 24px;
	PADDING-LEFT: 3px;
	TEXT-ALIGN: left;
	BBORDER: #660099 2px inset;
	BBACKGROUND-COLOR: #000033
}

TD.MenuPopUpSelected {
	COLOR: white;
	HEIGHT: 24px;
	TEXT-ALIGN: left
}
.line {
	font-size: 1px;
	position: absolute;
	z-index: 50;
	border-left: 1px solid black;
	border-bottom: 1px solid black
}
</style>
</head>
 <SCRIPT language=JavaScript>
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
   window.open(""+url);
}  
  
  
//   消息显示方法  

CLASS_MSN_MESSAGE.prototype.show = function(){  

    var oPopup = window.createPopup(); //IE5.5+
    oPopup.document.createStyleSheet("<%= request.getContextPath()%>/js/ext/resources/css/ext-all.css");
    <%if(!style.equals("")&&!style.equals("default")){%>
    oPopup.document.createStyleSheet("<%= request.getContextPath()%>/js/ext/resources/css/xtheme-<%=style%>.css");
    <%}%>
    var s = oPopup.document.createStyleSheet();
    s.addRule('.remind', 'background-image:url(/oa/images/silk/bell.gif);');
    s.addRule('ul', 'list-style-type:disc;margin:20px;padding:0px;');
    this.Pop = oPopup;  
    var link = this.url;
    var w = this.width;  
    var h = this.height;
    var dealLabel = "<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000f") %>";//我要处理

      var  str="<div class=\"x-window x-notification x-resizable-pinned\" \n" +
"     HEIGHT: " + h + "px;>\n" +
"    <div class=\"x-window-tl\">\n" +
"        <div class=\"x-window-tr\">\n" +
"            <div class=\"x-window-tc\">\n" +
"                <div class=\"x-window-header x-unselectable x-panel-icon remind\" \n" +
"                     style=\"-moz-user-select: none;\">\n" +
"                    <div class=\"x-tool x-tool-close\" id=btSysClose> </div>\n" +
"                    <span class=\"x-window-header-text\" ><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000e") %></span></div>\n" + //消息提醒
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
            me.timeout--; 
            if(me.timeout==0){ 
                window.clearInterval(me.timer);  
                if(me.autoHide){
                    me.hide(); 
                }
            } 
        } else { 
            me.offset = me.offset + me.step; 
        } 
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
        onUrl("/notify/SysRemindInfoFrame.jsp","消息提醒","tab402880351e44500a011e4465e0cf0023",false,"bell");
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
</SCRIPT> 
 
 
<script language=javascript>
lightstatus2 = "off";

img1click = "off";
img2click = "off";
img3click = "off";
img4click = "off";

var count =5;

function handlenewrequest(str) {

    var height = 120 + count * 17;

    var MSG1 = new CLASS_MSN_MESSAGE("",210,height,"<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002a") %>","<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000e") %>",str,"","");//提醒  消息提醒    
    MSG1.rect(null,null,null,screen.height-60); 
    MSG1.speed    = 30; 
    MSG1.step    = 10; 
    //alert(MSG1.top);
    //MSG1.url = "http://www.google.com";
    //MSG1.liststr = str;
    MSG1.show();
    
}

function setPoppupHeight(num) {
    count = num * 1 + 1;
}

function turnlighton(index, status) {
    switch (index) {
        case 1: if (status == "on") {
            img1.src = "/images/dh/img1.gif";
            img1.style.cursor = "hand";
            img1click = "on";
        } else {
            img1.src = "/images/dh/img1-2.gif";
            img1.style.cursor = "text";
            img1click = "off";
        }
        break;
        case 2: if (status == "on") {
            img2.src = "/images/dh/img2.gif";
            img2.style.cursor = "hand";
            lightstatus2 = "on";
            img2click = "on";
        } else {
            img2.src = "/images/dh/img2-2.gif";
            img2.style.cursor = "text";
            lightstatus2 = "off";
            img2click = "off";
        }
        break;
        case 3: if (status == "on") {
            img3.src = "/images/dh/img3.gif";
            img3.style.cursor = "hand";
            img3click = "on";
        } else {
            img3.src = "/images/dh/img3-2.gif";
            img3.style.cursor = "text";
            img3click = "off";
        }
        break;
        case 4: if (status == "on") {
            img4.src = "/images/dh/img4.gif";
            img4.style.cursor = "hand";
            img4click = "on";
        } else {
            img4.src = "/images/dh/img4-2.gif";
            img4.style.cursor = "text";
            img4click = "off";
        }
        break;
        default:
    }
}

function doPopup(o){
     if(!o==""){
         if(Ext.isIE){
         setPoppupHeight(o.substring(0,o.indexOf(",")));
         handlenewrequest(o.substring(o.indexOf(",")+1)) ;
         }else{
             msg='<div id=msgremind style=\"overflow:auto;text-align: left;\">'+o.substring(o.indexOf(",")+1)+'</div><div style=\"text-align: center;\"><a id=sysRemindInfo href=\"#\">我要处理</a></div>';
             pop(msg,'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000e") %>') ;//消息提醒
             sysRemindInfo.onclick = function() {
                 onUrl("/notify/SysRemindInfoFrame.jsp", "<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000e") %>", "tab402880351e44500a011e4465e0cf0023", false, "bell");//消息提醒
             }
         }
     }
}
 
function send(){
    //doPopup("1,<tr><td width='13'><img src='/images/PopupMsgDot.gif'></td><td>test message</td></tr>");
    NotifyService.pullNotify(doPopup);
}

send();

window.setInterval("send()", 5 * 60 * 1000);

</script>

<div style="left:0;top:0;height:18;width:90"> 
    <img id=img1 src="/images/dh/img1-2.gif" onclick="" title="">
    <img id=img2 src="/images/dh/img2-2.gif" onclick="" title="">
    <img id=img3 src="/images/dh/img3-2.gif" onclick="" title="">
    <img id=img4 src="/images/dh/img4-2.gif" onclick="" title="">
</div>

<BODY >
</BODY>
</HTML>
<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.*" %>

<%

	String loginid = StringHelper.null2String(request.getParameter("loginid"));
	String psw = StringHelper.null2String(request.getParameter("psw"));
	String width = StringHelper.null2String(request.getParameter("width"));
	String height = StringHelper.null2String(request.getParameter("height"));
%>
<style type="text/css" media="screen">
object:focus {
	outline: none;
}

#flashContent {
	display: none;
}
</style>

<script type="text/javascript" src="/messager/flex/swfobject.js"></script>
<script type="text/javascript">  
    var swfVersionStr = "10.0.0";            
    var xiSwfUrlStr = "/messager/flex/playerProductInstall.swf";
    var flashvars = {
    		loginid:"<%=loginid%>",
    	    psw:"<%=psw%>",
    		remoteEcologyServer:"",
    		remoteServiceUrl:"<%= request.getContextPath()%>/ServiceAction/com.eweaver.im.servlet.MessagerServlet",
    		remoteOpenFireServer:Config.JABBERSERVER
    };
    var params = {};
    params.quality = "high";
    params.bgcolor = "#ffffff";
    params.allowscriptaccess = "sameDomain";
    params.allowfullscreen = "true";
    //params.wmode="transparent";
    var attributes = {};
    attributes.id = "wmForWeb";
    attributes.name = "wmForWeb";
    attributes.align = "middle";
    swfobject.embedSWF(
        "/messager/flex/wmForWeb.swf", "flashContent", 
        "<%=width%>", "<%=height%>", 
             swfVersionStr, xiSwfUrlStr, 
             flashvars, params, attributes);			
swfobject.createCSS("#flashContent", "display:block;text-align:left;");
     </script>
<div id="flashContent">
<p>To view this page ensure that Adobe Flash Player version 10.0.0
or greater is installed.</p>
<script type="text/javascript"> 
				var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
				document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
								+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
			</script></div>




<script language="javascript">	
	var isMesasgerUnavailable=true; 
	var jidCurrent="<%=loginid%>"+"@"+Config.JABBERSERVER;
	var windowTitleOld=window.document.title;
	/*For common*/
	function getUserIconPath(loginid) {
		str = document.getElementById("wmForWeb").getUserIconPath(loginid);
		return str;
	}
	function changeMessageWindowIcon(item) {
		if (ControlWindow.isWindowExist(item.loginid)) {
			ControlWindow.getWindow(item.loginid).changeLogo(getUserStateImg(item.state));
		}
	}
	function reloadMyLogo(){	
		document.getElementById("wmForWeb").reloadMyLogo();	
	}	
	function logoutForMessager() {
		try {
			document.getElementById("wmForWeb").doDisconnect();
		} catch (e) {
		}
	}
	function openHistory(item) {
		try {
			openPage("allhistory",jidCurrent,"聊天记录");
		} catch (e) {
			
		}
	}
	
	
	/*For Presence Manager begin..............*/
	function getUserStateImg(state) {
		switch (state) {
		case "Free To Chat":
			return "/messager/images/status/im_free_chat.png";
		case "Available":
			return "/messager/images/status/im_available.png";
		case "Away":
			return "/messager/images/status/im_away.png";
		case "On Phone":
			return "/messager/images/status/on-phone.png";
		case "Extended Awa":
			return "/messager/images/status/im_away.png";
		case "On The Road":
			return "/messager/images/status/airplane.png";
		case "Do Not Disturb":
			return "/messager/images/status/im_dnd.png";
		case "msg":
			return "/messager/images/msgComing.gif";
		default:
			return "/messager/images/status/im_unavailable.png";
		}
	}
	function changeMyPrense(user) {		
        if (user.sign=="Available"){
            user.sign="在线";
        } else if (user.sign=="unavailable") {
           user.sign="离线";
        }
		if (user.state == "unavailable") {
			$("#divMessager").fadeOut("normal"); 	
			isMessagerShow=false;

			$("#imgMsgStateBar").attr("src", getUserStateImg(user.state));
			$("#imgMsgStateBar").attr("title", user.sign);

			$("#imgMsgStateBar").attr("isMsgAlert", "false");
			isMesasgerUnavailable = true;
		} else {
			if ($("#imgMsgStateBar").attr("isMsgAlert") != "true") {
				$("#imgMsgStateBar").attr("src", getUserStateImg(user.state));
				$("#imgMsgStateBar").attr("title", user.sign);
			}
			isMesasgerUnavailable = false;
		}
	}
	/*For Msg Manager begin..............*/
	function isMessageWindowShow(msg) {
		var fromJid = msg.fromJid;
		if (ControlWindow.isWindowExist(fromJid)) {
			var win = ControlWindow.getWindow(fromJid);
			return win.isShow;

		} else {
			return false;
		}
	}

	function messageWindowShow(msg, user) {
		var img = getUserStateImg(user.state);
		var win = ControlWindow.getWindow(user.loginid, user.lastname, img, img,user);
		win.show();
		if(msg!=null){		
			ControlWindow.getWindow(msg.fromJid).receive(msg.body, msg.fromJid,msg.receiveTime)
		}
	}

	function messagerIconStateShow(count, state, sign) {
		if (count > 0) {
			$("#imgMsgStateBar").attr("src", getUserStateImg("msg"));
			$("#imgMsgStateBar").attr("title", "你有" + count + "条短消息");
			$("#imgMsgStateBar").attr("isMsgAlert", "true");
		} else {
			$("#imgMsgStateBar").attr("src", getUserStateImg(state));
			$("#imgMsgStateBar").attr("title", sign);
			$("#imgMsgStateBar").attr("isMsgAlert", "false");
		}
	}
	function windowTitleMsg(strMsg) {
		if ($.trim(strMsg) != "") {	
			TitleFlash.setTitle(strMsg);
			TitleFlash.go();
		} else {
			//alert(windowTitleOld)
			TitleFlash.stop();
			window.setTimeout(function() {
				document.title=windowTitleOld;	
			}, 1000);
		}
	}
	function doShowAllTempMsg() {
		try{		
			document.getElementById("wmForWeb").popAllMsg();
		} catch(e){}
	}
	function sendMessage(sendto, msg) {
		//msg=msg+"&nbsp;";
		document.getElementById("wmForWeb").sendMessage(sendto, msg);
	}

	/*For TitleFlash.................
	 * 
	 * TitleFlash.stop();
	 * TitleFlash.setTitle(str);
	 * TitleFlash.go();
	 */
	var TitleFlash = (function() {
		var msg = "";
		var msgud = " " + msg;
		var isStop=false;

		function titleScroll() {
			try{

				if (msgud.length < msg.length)
					msgud += " - " + msg;
				msgud = msgud.substring(1, msgud.length);
	
				if (!isStop) {
					T = window.setTimeout(function() {
						titleScroll()
					}, 500)
					
					document.title = msgud.substring(0, msg.length);
				} else {
					msg = "";
					msgud = " " + msg;
				}
			} catch(e){
			}

		}
		return {
			setTitle : function(title) {
				msg = title;
			},
			go : function() {
				titleScroll();
			},
			stop : function() {
				isStop=true
			}
		}

	})();


	 var Page={
		showMessage:function(loginid){
	 		document.getElementById("wmForWeb").popSomeBodyMsg(loginid);
		}
	 }
</script>

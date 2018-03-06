var userOnlineIdList=new ArrayList();
var userOnlineMuList=new ArrayList();



var ControlUser={
	initOnlineUsrNum:0,
	firstJid:'',
	addOnlineUser:function(jid,type,show,status){
		var loginid=Util.cutResourceAtFlag(jid);
		userOnlineIdList.add(loginid);
		
		$(".imgOnlineState_"+loginid).attr("src","/messager/images/icon-available.gif");
		$(".ins_imgOnlineState_"+loginid).css("background-image","url('/messager/images/hrm-online.gif')")
		
		ControlUser.initOnlineUsrNum++;	
	},
	removeOnlineUser:function(jid,type){
		var loginid=Util.cutResourceAtFlag(jid);
		userOnlineIdList.remove(loginid);
		
		$(".imgOnlineState_"+loginid).attr("src","/messager/images/icon-offline.gif");
		$(".ins_imgOnlineState_"+loginid).css("background-image","url('/messager/images/hrm-offline.gif')")
		
		ControlUser.initOnlineUsrNum--;	
	},
	isUserOnline:function(loginid){
		return userOnlineIdList.indexOf(loginid)!=-1;
	},
	changeStatus:function (val,away,prio) {
		Debug.log("changeStatus: "+val+","+away+","+prio, 2);
		
		onlstat = val;
		if (away){
			onlmsg = away;
		}

		if (prio && !isNaN(prio))	{
			onlprio = prio;
		}
		if (!con.connected() && val != 'offline') {
			Login.doLogin(jid,psw,Debug);	
			//init();
			return;
		}

		var aPresence = new JSJaCPresence();
		switch(val) {
			case "unavailable":
				val = "invisible";
				aPresence.setType('invisible');
				break;
			case "offline":				
				val = "unavailable";
				aPresence.setType('unavailable');
				con.send(aPresence);
				con.disconnect();

				Debug.log("changeStatus:offline  ...TODO", 2);
				/*
				var img = eval(val+"Led");
				statusLed.src = img.src;
				if (away) {
					statusMsg.value = away;
				}
				else {
					statusMsg.value = onlstatus[val];
				}
				cleanUp();
				*/
				return;
				break;
			case "available":
				val = 'available'; // needed for led in status bar
				if (away)
					aPresence.setStatus(away);
				if (prio && !isNaN(prio))
					aPresence.setPriority(prio);
				else
					aPresence.setPriority(onlprio);			
				break;
			case "chat":
				if (prio && !isNaN(prio))
					aPresence.setPriority(prio);
				else
					aPresence.setPriority(onlprio);			
			default:
				if (away) {
					aPresence.setStatus(away);
				}

				if (prio && !isNaN(prio)) {
					aPresence.setPriority(prio);
				} else{
					aPresence.setPriority('0');
				}

				aPresence.setShow(val);
		}
		con.send(aPresence);
		
		//修改用户状态及其它
		ControlUser.UpdateUserState(val,away);

	},
	getUserStateImg:function(state){
		switch(state) {
			case "available":
				return "/messager/images/icon-available.gif"; 
				//return "/messager/images/icon-available.gif";
				
			case "connect":
				return "/images/images/logining.gif";
			case "offline":
				return "/messager/images/icon-offline.gif";
			case "msg":
				return "/messager/images/msg.gif";				
			default:
				return "";
		}
	}
}
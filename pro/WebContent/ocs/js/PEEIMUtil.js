/**
 * ActiveX Util
 * v1.0
 */

if (PEEIM == null) var PEEIM = {};
PEEIM.ActiveName = 'PEEim.PEEIMCOM';
PEEIM.engine = null;

/*
 * 验证Eim是否安装了。
 * Eim安装后会向系统注册这个对象，可以根据此对象能否实例化来判读客户端是否安装。
 */
PEEIM.isInstall = function (){
	if(PEEIM.engine == null){
		try{
			PEEIM.engine = new ActiveXObject(PEEIM.ActiveName);
		}catch(e){
			//alert(e);
		}
	}
	return PEEIM.engine != null;
}

/*
 * 启动Eim客户端
 */
PEEIM.RunEim = function (userName,password){
	if(PEEIM.isInstall()){
		PEEIM.engine.RunEim(userName, password);
	}else{
		alert("您没有安装OCS客户端！");
	}
}

/*
 * 打开聊天对话窗口
 */
PEEIM.OpenChatDial = function (loginName){
	if(loginName != null && PEEIM.isInstall()){
		PEEIM.engine.OpenChatDial(loginName, '');
	}
}


/*
 * 退出客户端
 */
PEEIM.ExitEim = function (){
	if(PEEIM.isInstall()){
		PEEIM.engine.ExitEim();
	}
}

/*
 * 显示客户端
 */
PEEIM.ShowEim = function (){
	if(PEEIM.isInstall()){
		PEEIM.engine.ShowEim();
	}
}



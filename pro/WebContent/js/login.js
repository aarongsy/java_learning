function getErrorMessage(keywordid, labelParams){
	var language = getSelectElementLanguage();
	if(language == ""){
		language = "zh_CN";
	}
	if(!labelParams){
		labelParams = [];
	}
	var labelname = jQuery.ajax({
		url: "/ServiceAction/com.eweaver.base.security.servlet.LoginAction?action=getLabelNameByKeyId",
		data: {keywordid : keywordid, language : language, labelParams : labelParams.toString()},
		async: false
	}).responseText;
	return labelname;
}
function getDynamicpass(username,pass,obj) {
	Ext.Ajax.request({    
		  url : '/ServiceAction/com.eweaver.base.security.servlet.LoginAction',    
		 params : {    
				j_username:username,
				action:'getDynamicPass',
				j_password:pass,
				isautosend:'1'			
		  },    
		  success : function(response) {

			  	if(response.responseText == 'nomount') {
			  		alert(getErrorMessage("402881e43c2385f6013c2385f672000e", [username]));	//账号:{0}不存在,无法获取动态密码	  		
			  	} else if(response.responseText == 'passerror') {
		  			alert(getErrorMessage("402881e43c2385f6013c2385f6720011"));		//密码错误,无法获取动态密码  			
			  	} else if(response.responseText == 'nophone') {
			  		alert(getErrorMessage("402881e43c2385f6013c2385f6720014"));		//无法找到关联手机,无法发送动态密码	  		
			  	} else if(response.responseText == 'stop') {
			  		alert(getErrorMessage("402881e43c2385f6013c2385f6720017"));		//动态密码功能未启用,无需动态密码即可登录	
			  	} else if(response.responseText == 'success') {
			  		alert(getErrorMessage("402881e43c2385f6013c2385f672001a"));		//动态密码已发送
                    obj.disabled=true;
			  		setTimeout("resetSend()",30000);
			  		return;
			  	} else if(response.responseText == 'fail') {
			  		alert(getErrorMessage("402881e43c2385f6013c2385f682001d"));		//动态密码发送失败
			  	}
			  	//obj.disabled=false;
			},
			failure : function(response) {   
				Ext.Msg.alert(getErrorMessage("402881e43c2385f6013c2385f6820020"));    //错误, 无法访问后台
			}    
		})  
}

function resetSend() {
    var obj = document.getElementById('dynamicpassBtn');
    obj.disabled=false;
}
function checkDynamicpass(obj) {
    var uname = document.getElementById("uname").value;
    var pass = document.getElementById("j_password").value;
    var msgdiv = document.getElementById('messageDiv');
	if(!uname || uname == '') {
		msgdiv.innerHTML = getErrorMessage("402881e43c2385f6013c2385f6720002");	//请输入用户名
		return;
	} else if(!pass || pass == '') {
		msgdiv.innerHTML = getErrorMessage("402881e43c2385f6013c2385f6720005");	//请输入密码
		return;
	}
	msgdiv.innerHTML='';
	obj.disabled=true;
	getDynamicpass(uname,pass,obj); 
}

function checkUsbExt(username,pass) {
	Ext.Ajax.request({    
		  url : '/ServiceAction/com.eweaver.base.security.servlet.LoginAction',   
		  async:false,
		  params : {    
				j_username:username,
				action:'checkUsb',
				j_password:pass    
		  },    
		  success : function(response) {    
			  	if(response.responseText == 'nomount') {
			  		//alert('账号:'+username+'不存在');			  		
			  	} else if(response.responseText == 'passerror') {
		  			//alert('密码错误');		  			
			  	} else if(response.responseText == 'serverkey') {
			  		//alert('账号:'+username+'密钥没有设置,USBKey被忽略,将以普通方式登录');			  		
			  	} else if(response.responseText == 'success') {
			  		document.getElementById("isusb").value="1";
			  		return;
			  	} 
			  	document.getElementById("isusb").value="0";
			},
			failure : function(response) {   
				Ext.Msg.alert(getErrorMessage("402881e43c2385f6013c2385f6820020"));    //错误, 无法访问后台
			}    
		})
}

function checkUsb(username,pass) {	
	var url = '/ServiceAction/com.eweaver.base.security.servlet.LoginAction?action=checkUsb';
	jQuery.ajaxSetup({async: false});
	var params = {j_username:username,j_password:pass};
	var isSuccess = false;
	jQuery.post(url,params,function(data){
		//alert(data);
		if(data == 'nomount') {
	  		document.getElementById("isusb").value="0";
	  		return;
	  	} else if(data == 'passerror') {
  			document.getElementById("isusb").value="0";
  			return;
	  	} else if(data == 'stop') {
  			document.getElementById("isusb").value="0";
  			isSuccess = true;
  			return;
	  	} else if(data == 'serverkey') {
	  		alert(getErrorMessage("402881e43c23ab8d013c23ab8dbb0000", [username]));	//账号:{0}密钥没有设置,USBKey被忽略,将以普通方式登录
	  		isSuccess = true;
	  		document.getElementById("isusb").value="0";
	  	} else if(data == 'success') {
	  		isSuccess = true;
	  		document.getElementById("isusb").value="1";
	  		return;
	  	} 
	});
	return isSuccess;
}

function checkIsIP(username,pass,ip) {	
	var url = '/ServiceAction/com.eweaver.base.security.servlet.LoginAction?action=checkIsIP&ip='+ip;
	jQuery.ajaxSetup({async: false});
	var params = {j_username:username,j_password:pass};
	var isSuccess = false;
	jQuery.post(url,params,function(data){
		var msg = document.getElementById('messageDiv');
		 if(data == 'noIP') {
  			isSuccess = true;
		}else if(data == 'nouser') {
			msg.innerText = getErrorMessage("402881e43c23091a013c23091be3000b");	//用户名不存在
  			isSuccess = false;
		}else if(data == 'forbidIP') {
  			isSuccess = true;
	  	} else if(data == 'fail') {
	  		alert(getErrorMessage("402881e43c2385f6013c2385f672000b", [document.getElementById("uname").value])); //账号:{0}被限制为仅内网IP登陆，请与管理员联系
	  		isSuccess = false;
	  	} else if(data == 'success') {
	  		isSuccess = true;
	  	}
	});
	return isSuccess;
}

function checkDynamicpassLogin(username,pass,isautosend) {	
	var url = '/ServiceAction/com.eweaver.base.security.servlet.LoginAction?action=getDynamicPass&isautosend='+isautosend;
	//alert(url);
	jQuery.ajaxSetup({async: false});
	var params = {j_username:username,j_password:pass};
	var isSuccess = false;
	jQuery.post(url,params,function(data){	
		if(data == 'nomount') {
			document.getElementById("sendpass").value="0";
			return;
	  	} else if(data == 'passerror') {
	  		document.getElementById("sendpass").value="0";
	  		return;
	  	} else if(data == 'stop') {
	  		document.getElementById("sendpass").value="0";
	  		isSuccess = true;
	  	} else if(data == 'nophone') {
	  		alert(getErrorMessage("402881e43c23ab8d013c23ab8dbc0003"));	//发送动态密码时,无法找到关联手机
	  		document.getElementById("sendpass").value="1";
	  		isSuccess = true;
	  		return;
	  	}  else if(data == 'start') {
	  		document.getElementById("sendpass").value="1";
	  		isSuccess = true;
	  		return;
	  	} else if(data == 'success') {
	  		alert(getErrorMessage("402881e43c2385f6013c2385f672001a"));	//动态密码已发送
	  		document.getElementById("sendpass").value="1";
	  		return;
	  	} else if(data == 'fail') {
	  		alert(getErrorMessage("402881e43c2385f6013c2385f682001d"));	//动态密码发送失败
	  		document.getElementById("sendpass").value="1";
	  		return;
	  	} 
	});
	return isSuccess;
}
function login(){
    if(document.getElementById("uname").value && document.getElementById("j_password").value){
    	var uname=document.getElementById("uname").value;

    	document.getElementById("j_username").value=uname;
    	//alert(document.getElementById("j_username").value);
    	var pass = document.getElementById("j_password").value;
    	var isusbObj = document.getElementById("isusb");
    	var isIP = document.getElementById('isIP');
    	
    		if(isIP.value=='1'){
    		var ip = document.getElementById('ip').value;
    		if(ip!='127.0.0.1'){//本机IP不用验证
	    		var userIsIP = checkIsIP(uname,pass,ip);
				if(!userIsIP) {
		    		return false;
		    	}
    		}
    	}
    	var sendpassObj = document.getElementById("sendpass")
    	if(isusbObj.value == '1') {
    		var issuccess = checkUsb(uname,pass);
	    	if(issuccess && isusbObj.value == '1') {
                //alert('usb');
	    		loadObject();
	    		//alert('v');
				var rs = Validate();
				//alert(rs);
	    		return rs;
	    	}
    	} 
    	 	    	
    
    	if(isusbObj.value != '1' && sendpassObj.value == '1') {
    		var dynpass = document.getElementById('dynamicpass').value;
    		if(dynpass != '') {
    			return true;
    		}
    		var isok = checkDynamicpassLogin(uname,pass,0);
	    	if(isok && document.getElementById("sendpass").value == '1') {
	    		document.getElementById('dynamicpass').style.display='';
	    		document.getElementById('dynamicpassBtn').style.display='';
	    		positionLanguage();	    		
	    		if(dynpass == '') {	    			
	    			//alert('请输入动态密码');
	    			return false;
	    		}
	    	} else if(document.getElementById("sendpass").value == '0')  {
	    		document.getElementById('dynamicpass').style.display='none';
	    		document.getElementById('dynamicpassBtn').style.display='none';	    	
	    	}
    	}
    	
    	return true;
    } else {
		if(document.getElementById("uname").value ==''){
		    alert(getErrorMessage("402881e43c2385f6013c2385f6720002"));	//请输入用户名
		} else if(document.getElementById("j_password").value=='') {
			alert(getErrorMessage("402881e43c2385f6013c2385f6720005"));	//请输入密码
		}
	}
    return false;
}
function submitForm(){
	document.getElementById("isusb").value="1";
	//alert('submit');
	form1.submit();
}

function loadObject(){
	var myObject = document.createElement('object');
	document.getElementById("mybody").appendChild(myObject);
	myObject.setAttribute('id','htactx');
	myObject.setAttribute('name','htactx');
	myObject.setAttribute('codebase','/plugin/HTActX.cab#version=1,0,0,1');
	myObject.classid= "clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E";
    //alert('u');
}
//聊天面板
/*
*多了一个属性SendTo必设
*
*/
function  MessageWindow(para){	
	BaseWindow.call(this,para)
	this.para=para;
	this.objBody=null;
	this.lastMsgTime="";
	this.lastFormJid="";
}

MessageWindow.prototype=new BaseWindow();

MessageWindow.prototype._setName=function(){	
	this._verifyObjWindow();
	this.objWindow.find(".name").html(rMsg.messageWindowChatWith+this.para.name+rMsg.messageWindowChat);
}

MessageWindow.prototype._limitLength = function(value, byteLength) {  
	var newvalue = value.replace(/[^\x00-\xff]/g, "**"); 	
	var length = newvalue.length;  
	//当填写的字节数小于设置的字节数  
	if (length * 1 <=byteLength * 1){  
		return true;  
	}  
	/**var limitDate = newvalue.substr(0, byteLength);  
	var count = 0;  
	var limitvalue = "";  
	for (var i = 0; i < limitDate.length; i++) {  
			 var flat = limitDate.substr(i, 1);  
			if (flat == "*") {  
				count++;  
			}  
	}  
	var size = 0;  
	var istar = newvalue.substr(byteLength * 1 - 1, 1);//校验点是否为“×”  
	
	//if 基点是×; 判断在基点内有×为偶数还是奇数   
	if (count % 2 == 0) {  
			  //当为偶数时  
			size = count / 2 + (byteLength * 1 - count);  
			limitvalue = value.substr(0, size);  
	} else {  
			//当为奇数时  
			size = (count - 1) / 2 + (byteLength * 1 - count);  
			limitvalue = value.substr(0, size);  
	}  **/
	var mornval = length*1-byteLength*1;
	alert("最大输入" + byteLength + "个字节（相当于"+byteLength /2+"个汉字）！超过" + mornval + "个字节,相当于"+mornval/2+"个汉字");  
	return false;  
}  

MessageWindow.prototype._createMessage=function(){
	var str=	
			"<table height='100%' width='100%'><tr><td  width='100%'>"+
			"<div class='msg'>"+
			"	<div class='info'></div>" +									
			"	<div class='input'>" +
			"		<table width='100%' height='100%'><tr><td width='100%'><textarea class='textareabase' style='white-space:normal;word-break:break-all;'/></td><td width='58'><span class='btnSend'  ACCESSKEY='S'></span></td></tr></table>" +
			"	</div>" +
			"	<div class='toolbar'/>" +
			"</div>"+
			"</td><td>"+
			"	<div class='user'><table  width='100%' height='100%'><tr height='*'><td><div style='text-align:center;vertical-align :middle;background:url(/messager/images/window-user.gif) no-repeat center center;height:80;padding:10px;'>";
	if(Util.null2String(this.para.user.messagerurl)!="") str+="<img src='"+Util.null2String(this.para.user.messagerurl)+"' align='absmiddle'   height='69' width='69'>";
	str+="	</div></td></tr><tr height='150'><td>"+
			
			"<table width=\"100%\"><colgroup><col width=\"40%\"><col width=\"*\"></colgroup>"+
			"<tr><td class='userfield' nowrap>姓<span class='space'/>名：</td><td class='uservalue'>"+Util.null2String(this.para.user.lastname)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>分<span class='space'/>部：</td><td class='uservalue'>"+Util.null2String(this.para.user.subcompany)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>部<span class='space'/>门：</td><td class='uservalue'>"+Util.null2String(this.para.user.department)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>直接上级：</td><td class='uservalue'>"+Util.null2String(this.para.user.superior)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>岗<span class='space'/>位：</td><td class='uservalue'>"+Util.null2String(this.para.user.jobtitle)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>电<span class='space'/>话：</td><td class='uservalue'>"+Util.null2String(this.para.user.telephone)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>移动电话：</td><td class='uservalue'>"+Util.null2String(this.para.user.mobile)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>电子邮件：</td><td class='uservalue'>"+Util.null2String(this.para.user.email)+"</td></tr>"+
			
			"</table>"+
			
			"</td></tr><tr height='50'><td align='right'><img src='/messager/images/window-logo.png'></td></tr></table></div> "+
			"</td></tr></table>";
	this.objBody.append(str);

	var $this=this;
	this.objBody.find(".textareabase").bind('keypress', function(e) {
		
		var code = (e.keyCode ? e.keyCode : e.which);
		
		if(code==13){//enter
			var value=$this.objBody.find(".textareabase").val();
			$this.send(value);					
			return false;
		} 
	});	
	
	
	this.objBody.find(".input").children("textarea").bind('focus', function(e) {		
		$this.send(Config.FocusFlag);	
	});	
	this.objBody.find(".input").children("textarea").bind('blur', function(e) {		
		$this.send(Config.BlurFlag);
	});	
	
	this.objBody.find(".btnSend").bind('click', function(e) {
			var value=$this.objBody.find(".textareabase").val();		
			if($this._limitLength(value,1000)) {
				$this.send(value);	
	        }						
	});	
}

MessageWindow.prototype._setLogo=function(){	
	this._verifyObjWindow();
	this.objWindow.find(".logo").append("<img src='"+this.para.userImg+"'>");
	this.objWindow.find(".logo").append("<div class='inputstateIcon'  style='position:absolute;left:20px;top:11px;display:none'>" +
			"<img src='/messager/images/input.gif' height='12px'>" +
			"</div>");
}
MessageWindow.prototype.hide=function(){
	if(this.isShow){
		ControlWindow.intMessagerWindowNum--;
		this.objWindow.fadeOut("fast");
		this.isShow=false;	
	}	
}
MessageWindow.prototype._createToolbar=function(){	
	this.objBody.find(".msg .toolbar").append(
			"<div style='float:left'><span id='btnSelectedAcc_"+this.para.id+"' style='left:0;'/></div>"+	
			"<div style='float:right'>"+
			"	<span class='button'   style='padding-top:3;padding-left:1'  onclick='openPage(\"history\",\""+this.para.sendTo+"\",this.firstChild.title)'><img src='/messager/images/history.gif'  align='absmiddle'  title='"+rMsg.toolHistory+"' /></span>"+
			"</div>"
	);
	
	var $this=this;
	this.objBody.find(".msg .toolbar").children(".button").click(function(){
		if(this.type=="alert"){
			 $this.send(Config.AlertFlag)
		}		
	});
}
MessageWindow.prototype._fixMessageBody=function(){		
	var infoHeight=parseInt(this.objBody[0].style.height)-60-25;
	this.objBody.find(".info").height(infoHeight);
}


MessageWindow.prototype._subShow=function(){
	if(this.cusData.firstShow!="false"){
		var infoHeight=parseInt(this.objBody.find(".user")[0].clientHeight)-60-25;
		this.objBody.find(".info").height(infoHeight);
		this.cusData.firstShow="false";
	} 
	ControlWindow.intMessagerWindowNum++;
	//this.objBody.find(".info").html("");
	//this.objBody.find(".input").children("textarea")[0].focus();	
}
MessageWindow.prototype.showMessage=function(msg,fromJid,strTime){
	if($.trim(msg)=="") return;
	//var myImg=document.getElementById("imgMyLogo").src;
	var myImg=""; 
	var msgTime;
	if(strTime==null){
		msgTime=Util.getCurrentTimeForMsg();
	} else {
		msgTime=strTime;
	}
	var img="";
	var info=this.objBody.find(".info");
	if(msgTime==this.lastMsgTime&&this.lastFormJid==fromJid){
		this.objBody.find(".tdMsgs:last").append("<div style='white-space:normal;word-break:break-all;'>"+msg+"</div>");
		//jQuery("#divMessager").fadeOut("normal");
		//jQuery("#divMessager").fadeIn("normal");
	} else { 
		var showName="";
		if(fromJid=="me"){
			img=getUserIconPath(Util.cutResourceAtFlag(jidCurrent));
			this.lastFormJid="me";
			showName=nickname;
		} else {
			img=getUserIconPath(Util.cutResourceAtFlag(fromJid));
			this.lastFormJid=fromJid;
			 showName=this.para.name;
		}		
		if(this.lastMsgTime!=""){
			//this.objBody.find(".tdMsgs:last").append("<div style='color:#808080'>"+this.lastMsgTime+"</div>");
		}		
		if(img==null){
			img="/messager/images/icon-blue.gif";
		}
		var strDiv="<table width='90%'><tr><td valign='top' width='36px'><img src='"+img+"' width='33px'/></td>"+
			   "	<td  valign='top' class='tdMsgs'>"+
			   "		<div><b>"+showName+":</b><font style='color:#808080'>"+msgTime+"</font></div>"+
			   "<div style='white-space:normal;word-break:break-all;'>"+msg+"</div>"+
			   "	</td>"+
			   "</tr></table>";	
		//info.width=300;
		//info.height=300;
		//this.objWindow.find(".content").css("float");
		//alert(this.objWindow.find(".content").css("float"));
		info.append(strDiv);
		//alert(this.objWindow.css("position"));
		//document.getElementById("info").innerHTML=document.getElementById("info").innerHTML+strDiv;
		//$(strDiv).appendTo(info);
		//this.objWindow.find(".content").css("float","left")
		//jQuery("#divMessager").fadeOut("normal");
		//jQuery("#divMessager").fadeIn("normal");
	}
	this.lastMsgTime=msgTime;
	
	//显示消息
	info[0].scrollTop=info[0].scrollTop+info[0].offsetHeight;
	this.show();
}
MessageWindow.prototype.send=function(msg,isNeedChangeStr){
	if($.trim(msg)=="") return;
	msg=this.changeStr(msg,isNeedChangeStr);
	//send 消息	
	sendMessage(this.para.sendTo,msg);	
	if(
			$.trim(msg)!=Config.FocusFlag&&
			$.trim(msg)!=Config.BlurFlag&&
			$.trim(msg)!=Config.AlertFlag&&
			$.trim(msg)!=Config.OnlineFlag
	){
		this.showMessage(msg,"me");
		
		//清空消息
		this.objBody.find(".textareabase").val('');
	}
}
MessageWindow.prototype.changeStr=function(str,isNeedChangeStr){
	if(isNeedChangeStr==false) {
		return  str;
	}else {
		str=str.replace(/</g,"&lt;");
		str=str.replace(/>/g,"&gt;");
		return str;
	}
}
MessageWindow.prototype.receive=function(msg,fromJid,receiveTime){	
	if($.trim(msg)==""){
		return;	
	}else if($.trim(msg)==Config.AlertFlag){
		//doShowSomeBodyTempMsg(fromJid);
		return ;		
	} else if($.trim(msg)==Config.FocusFlag){			
		this.objWindow.find(".logo").children(".inputstateIcon").show();
		return ;
	}else if($.trim(msg)==Config.BlurFlag){
		this.objWindow.find(".logo").children(".inputstateIcon").hide();
		return ;
	}else if($.trim(msg)==Config.OnlineFlag){		 
		return ;
	}
	//Multimedia.playSound("reciveMessage");
	this.showMessage(msg,fromJid,receiveTime);
}

//重载 BaseWindow的以下方法
MessageWindow.prototype._setButtons=function(){		
	
}

MessageWindow.prototype._fixSize=function(){	
	this._fixWindow();
	this._fixMessageBody();
}
MessageWindow.prototype._initAccessory=function(){
	getUploader(this,this.para.id,this.para.sendTo)
}
MessageWindow.prototype._create=function(){		
	this._createBase();
	this.objBody=this.objWindow.find(".body");
	this._createMessage();
	this._createToolbar();		
}
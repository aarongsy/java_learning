jQuery.noConflict();
function LoadContent(path,portletId,id){
	jQuery.ajax({
		url: path+"?mode=view&portletId="+portletId,
		cache: false,
		//ifModified:true,
		dataType:'html',
		timeout:1000*10,
		success: function(html){
			jQuery("#"+id).html(html);
		},
		error:function(req,status,err){
			jQuery("#"+id).html("<i>Element.id="+portletId+"加载数据错误(status:"+status+")!</i>");
		}
	});
}
function stopBubble(e){//如果提供了事件对象，则这是一个非IE浏览器
	if (e && e.preventDefault) {
      e.preventDefault();
      e.stopPropagation();
    } else {
      event.returnValue = false;//IE下这一句是关键，要不然href地址会跳转
      event.cancelBubble = true;
    }
}
function LoginSystem(){
	var user=jQuery("#username");
	var pass=jQuery("#password");
	if(jQuery.trim(user.val())==''){
		alert('用户名不能为空!');
		user.focus();return;
	}
	if(jQuery.trim(pass.val())==''){
		alert('密码不能为空!');
		pass.focus();return;
	}
	var toUrl='/index.jsp?id=4028803222b9d5820122ba18bfe00004';
	var formData={'j_username':user.val(),'j_password':pass.val()};
	jQuery.post("/j_acegi_security_check", formData, function(text){
		if(text=='success')location.replace(toUrl);
		else alert('登录失败!');
	}, 'text');
}	

if(typeof(top.frames[1])=='undefined')top.frames[1]=window;
var Gtitle='title';//保存标题的全局变量
function onUrl(url,e){
	if(typeof(url)=='object'){
		stopBubble(e);
		var frame=document.getElementById('appFrame');
		//alert(frame+',type:'+typeof(frame));
		if(typeof(frame)=='object'){
			sUrl=url.getAttribute('href');
			var pos=sUrl.lastIndexOf('toUrl=');
			frame.src=sUrl.substring(pos+6);
		}else{
			var params={id:'4028803222b9d5820122ba18bfe00004',toUrl:url.getAttribute('href')};
			var sUrl='/index.jsp?'+jQuery.param(params);
			location.href=sUrl;
		}
		return false;
	}else{
		var params={id:'4028803222b9d5820122ba18bfe00004',toUrl:url};
		var sUrl='/index.jsp?'+jQuery.param(params);
		Gtitle=''+e;
		var win=window.open(sUrl,'_blank');
	}
}
/*
function publish(subject,content){
	Ext.ux.util.MessageBus.publish(subject, content);
}
function doPopup(o){
     if(!o==""){
         if(Ext.isIE){
         setPoppupHeight(o.substring(0,o.indexOf(",")));
         handlenewrequest(o.substring(o.indexOf(",")+1)) ;
         }else{
             msg='<div id=msgremind style=\"overflow:auto;text-align: left;\">'+o.substring(o.indexOf(",")+1)+'</div><div style=\"text-align: center;\"><a id=sysRemindInfo onclick=\"onUrl(\'<%=request.getContextPath()%>/notify/SysRemindInfoFrame.jsp\', \'消息提醒\', \'tab402880351e44500a011e4465e0cf0023\', false, \'bell\');\" href=\"#\">我要处理</a></div>';
             pop(msg,'消息提醒') ;
         }
     }
}
*/
function frameLoaded(oFrame){
	if(location.href.indexOf('toUrl')<=0)return;
	document.title=oFrame.contentWindow.document.title;
}

function hideRssDesc(){
	return false;
}

function initMenu(){
	var options = {hoverOpenDelay:100,hideDelay:200,minWidth: 120, 
		arrowSrc: '/images/arrow_right.gif', onClick:function(e, menuItem){
			return false;
		}//end.function.
	};
	jQuery('ul.menuTitle').menu(options);
}

function initElement(){
	jQuery.each(jQuery('span.portletElement'),function(n,oSpan){
		if(oSpan.getAttribute('_path')!=null) LoadContent(oSpan.getAttribute('_path'),oSpan.getAttribute('_id'),oSpan.id);
	});
}
function showRssDesc(){return false;}
jQuery(document).ready(function(){
	initMenu();//由于有些div隐藏域和Tab及menu的初始化会修改DOM树,所以执行有顺序关系
	jQuery("div.tabs ul").idTabs({ start:1, change:false },true);//initTab.	
	initElement();
});

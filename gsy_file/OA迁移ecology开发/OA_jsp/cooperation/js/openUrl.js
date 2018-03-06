/**
*在当前区域打开
*/
function onCP_openUrl(url) {
	window.location.href = url;
}

function onP_openURL(iframeid, url) {
	if (window.frames[iframeid]) {
		//var src = window.frames[iframeid].document.location.href + "";
		//if (src.indexOf(url) <= -1) {
			window.frames[iframeid].document.location.href = url;
		//}
	}
}

function onPP_openURL(iframeid, url) {
    if (parent.frames[iframeid]) {
		//var src = parent.frames[iframeid].document.location.href + "";
		//if (src.indexOf(url) <= -1) {
			parent.frames[iframeid].document.location.href = url;
		//}
	}
}

function onPPP_openURL(iframeid, url) {
    if (parent.parent.frames[iframeid]) {
		//var src = parent.parent.frames[iframeid].document.location.href + "";
		//if (src.indexOf(url) <= -1) {
			parent.parent.frames[iframeid].document.location.href = url;
		//}
	}
}

/**
 * 刷新
 * @param {Object} iframeid
 */
function refParentPage(iframeid) {
    if (parent.frames[iframeid]) {
		parent.frames[iframeid].document.location.reload();
	}
}        
function refCurrentPage(iframeid) {
    if (parent.frames[iframeid]) {
		parent.frames[iframeid].document.location.reload();
	}
}
/**此方法仅适合addfunctionlist.jsp、participantlist.jsp、participantlist2.jsp、participantlist3.jsp、replycoworklist.jsp中在软件模式下使用
eg:jQuery(function(){setIframeHeight_();});
*/
function setIframeHeight_IsSoftware(){
    var frameRight = window.parent.parent.parent.document.getElementById("frameRight");
	var replyframe1 = window.parent.parent.document.getElementById("replyframe1");
	var replyframe = window.parent.document.getElementById("replyframe");
	   if(frameRight && replyframe1 && replyframe){
	            replyframe1.style.height= "auto";
				replyframe.style.height= "auto";
				frameRight.style.height = "auto";
	       try{
				var bHeight_1 = frameRight.contentWindow.document.body.scrollHeight;
				var dHeight_1 = frameRight.contentWindow.document.documentElement.scrollHeight;
				var height1 = Math.min(bHeight_1, dHeight_1);
				//alert(height1+"frameRight的高度");
				var bHeight_2 = replyframe1.contentWindow.document.body.scrollHeight;
				var dHeight_2 = replyframe1.contentWindow.document.documentElement.scrollHeight;
				var height2 = Math.max(bHeight_2, dHeight_2);
				//alert(height2+"replyframe1的高度");
				var bHeight_3 = replyframe.contentWindow.document.body.scrollHeight;
				var dHeight_3 = replyframe.contentWindow.document.documentElement.scrollHeight;
				var height3 = Math.max(bHeight_3, dHeight_3);
			    //alert(height3+"replyframe的高度");
				replyframe1.style.height= height3+50;
				replyframe.style.height= height3+50;
				frameRight.style.height = height1;
		   }catch (ex){
		  
		   }
	   }
}
/**此方法仅适合addfunctionlist.jsp、participantlist.jsp、participantlist2.jsp、participantlist3.jsp、replycoworklist.jsp中在网站模式下使用*/
function setIframeHeight_IsWebsite(){
    var frameRight  = window.parent.parent.parent.document.getElementById("frameRight");
	var replyframe1 = window.parent.parent.document.getElementById("replyframe1");
	var replyframe  = window.parent.document.getElementById("replyframe");
	   if(frameRight && replyframe1 && replyframe){
	            replyframe1.style.height= "auto";
				replyframe.style.height= "auto";
				frameRight.style.height = "auto";
	       try{
				var bHeight_1 = frameRight.contentWindow.document.body.scrollHeight;
				var dHeight_1 = frameRight.contentWindow.document.documentElement.scrollHeight;
				var height1 = Math.max(bHeight_1, dHeight_1);
				//alert(height1+"frameRight的高度");
				var bHeight_2 = replyframe1.contentWindow.document.body.scrollHeight;
				var dHeight_2 = replyframe1.contentWindow.document.documentElement.scrollHeight;
				var height2 = Math.max(bHeight_2, dHeight_2);
				//alert(height2+"replyframe1的高度");
				var bHeight_3 = replyframe.contentWindow.document.body.scrollHeight;
				var dHeight_3 = replyframe.contentWindow.document.documentElement.scrollHeight;
				var height3 = Math.max(bHeight_3, dHeight_3);
			    //alert(height3+"replyframe的高度");
				replyframe1.style.height= height3+50;
				replyframe.style.height= height3+50;
				frameRight.style.height = height3+300;
				window.parent.parent.resizeMainPageBodyHeight();
				// alert(frameRight.style.height+"*******");
		   }catch (ex){
		  
		   }
	   }
}

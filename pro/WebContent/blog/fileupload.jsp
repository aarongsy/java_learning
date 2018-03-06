<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String fieldid = StringHelper.null2String(request.getParameter("fieldid"));
%>
<html>
<head>
<style type="text/css">
body{
	background-color: #fff;
	padding-left: 2px;
}
#processDiv{
	color:#4e82c1;
	z-index:2000;
	position:absolute;
	font-size: 10px;
}
#processDiv #processBorder {
	height: 10px;width: 80%;
	border: 1px solid #ccc;
	float:left;
	font-size: 10px;
}
#processDiv #processBar {
  	height: 10px;
  	margin: 1px;
	width:0;
	font-size: 10px;
	background-image:url("/images/base/processbar_bg.gif");
}
#bytesRead,#percent {
  	margin:2px;
	color:#cc0000;
	font-size: 10px;
	position: absolute;
	top: 0px;
	left: 40%;
}
.uploadfile{
	overflow:hidden;
	position:relative;
	
}
.uploadfile :hover{
	text-decoration: underline;
}
.uploadfile input{
	opacity:0;
	filter:alpha(opacity=0);
	position:absolute;
	font-size:14px;
	top:0;
	left:0;
	width:1px;
	z-index: 1000;
}
/*.appItem_bg{background: url('/blog/images/appItem-bg.png');height: 40px;padding-left: 0px;padding-top:0px}*/
</style>
<script src="/js/sack.js" language="JavaScript" type="text/javascript"></script>
<script language="javascript">
var ajax = new sack();
function f$(id){
	return document.getElementById(id);
}
function checkStatus(){
	ajax.setVar("action", "getStatus");
	ajax.requestURL = "/ServiceAction/com.eweaver.base.file.FileUploadAction";
	ajax.method = "GET";
	ajax.onCompletion = processStateChange;
	ajax.runAJAX();
}
function processStateChange(){
	var xml = ajax.responseXML;
	if(!xml){window.setTimeout("checkStatus();", 500);}
	var errorMessage = xml.getElementsByTagName("error")[0];
	var isNotFinished = xml.getElementsByTagName("finished")[0];
	var myBytesRead = xml.getElementsByTagName("bytes_read")[0];
	var myContentLength = xml.getElementsByTagName("content_length")[0];
	var myPercent = xml.getElementsByTagName("percent_complete")[0];
	
	if(errorMessage){//上传过程发生异常
		errorMessage = errorMessage.firstChild.data;
		showErrorMessage(errorMessage);
		return;
	}
	if ((!isNotFinished) && (!myPercent)){//上传过程尚未开始
		window.setTimeout("checkStatus();", 500);
	}else{
		myBytesRead = myBytesRead.firstChild.data;
		myContentLength = myContentLength.firstChild.data;
		if (myPercent){
			myPercent = myPercent.firstChild.data;
			changeStatusBar(myPercent,myBytesRead,myContentLength)
			window.setTimeout("checkStatus();", 500);
		}else{
			var attachid = xml.getElementsByTagName("attachid")[0].firstChild.data;
			var attachname = xml.getElementsByTagName("attachname")[0].firstChild.data;
			finishProcess(myContentLength,attachid,attachname);
		}
	}
}
function uploadFlie(file){
	if(file.value=="")	return;
	preShowProcess();
	checkStatus();
	if(parent){
		//parent.disabledButton();
	}
	document.uploadForm.submit();	
}
function preShowProcess(){
	f$("processBar").style.width = 0;
	f$("percent").innerHTML = "";
	f$("bytesRead").innerHTML = "";
	f$("processDiv").style.display='';
	f$("uploadForm").style.display='none';
}
function changeStatusBar(myPercent,myBytesRead,myContentLength){
	f$("processBar").style.width = myPercent + "%";
	f$("percent").innerHTML = myPercent + "%";
	f$("bytesRead").innerHTML = myBytesRead + " KB ";
}
function finishProcess(myContentLength,attachid,attachname){
	f$("processBar").style.width = 100 + "%";
	f$("percent").innerHTML = 100 + "%";
	f$("bytesRead").innerHTML = myContentLength + " KB ";
	if(parent){
		parent.addAttach(attachid,attachname,f$("fieldid").value);
		//parent.enableButton();
	}
	setTimeout(hiddenBar,500);
}
function hiddenBar(){
	f$("processDiv").style.display='none';
	f$("uploadForm").style.display='';
}
function showErrorMessage(errorMessage){
	switch(errorMessage){
		case "SizeLimitException":
			f$("percent").innerHTML = "文件大小超过限制,不能上传";//
			f$("bytesRead").innerHTML = "";
			//alert(f$("percent").innerHTML);
			break;
		case "Exception":
			f$("percent").innerHTML = "文件上传过程发生异常";//
			f$("bytesRead").innerHTML = "";
			//alert(f$("percent").innerHTML);
			break;
		default:
			break;
	}
	if(parent){
		parent.enableButton();
	}
	setTimeout(hiddenBar,3000);
}
</script>
</head>
<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<input type="hidden" name="fieldid" id="fieldid" value="<%=fieldid%>"/>
<iframe id='target_upload' name='target_upload' src='' style='display:none'></iframe>
<form enctype="multipart/form-data" id ="uploadForm" name ="uploadForm" method="post"
	action="/ServiceAction/com.eweaver.base.file.FileUploadAction?action=uploadFile" target="target_upload">
	<table width="100%" height="100%" border="0"><tr><td valign="top" class="appItem_bg">
	<a class="uploadfile" href="javascript:;" style="color: #1d76a4 !important;font-family: 微软雅黑!important"> <img src="/images/base/browser.gif" align="absmiddle"/> 附件
		<input type="file" name=attach1 id=attach1 contentEditable="false" onchange = "javascript:uploadFlie(this);">
	</a>
	</td></tr>
	</table>
</form>
<div id="processDiv" style='display:none'>
	<div id="processBorder">
		<span id="percent"></span>
		<span id="bytesRead" style="display: none;"></span>
		<div id="processBar"></div>
	</div>
</div>
</body>
</html>
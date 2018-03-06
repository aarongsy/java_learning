<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String type = request.getParameter("type");
String formActionType = StringHelper.null2String(request.getParameter("formActionType"));	//来自什么操作类型的上传(如操作的是分类则为category)
String formActionObjid = StringHelper.null2String(request.getParameter("formActionObjid"));	//该类型对应的数据id(如操作的是分类则为categoryid)
%>
<html>
<head>
<style type="text/css">
body{
	background-color: #efefde;
}
#processDiv{
	color:#4e82c1;
	z-index:2000;
	position:absolute;
}
#processDiv #processBorder {
	height: 15px;width: 450px;
	border: 1px solid #ccc;
	float:left;
}
#processDiv #processBar {
  	height: 15px;
  	margin: 1px;
	width:0;
	background-image:url("/images/base/processbar_bg.gif");
}
#processDiv #percent {
  	margin:0 5 0 5;
	color:#cc0000;
}
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
		parent.disabledButton();
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
		parent.addAttach(attachid,attachname,f$("type").value);
		parent.enableButton();
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
<body>
<input type="hidden" name="type" id="type" value="<%=type%>"/>
<iframe id='target_upload' name='target_upload' src='' style='display:none'></iframe>
<form enctype="multipart/form-data" id ="uploadForm" name ="uploadForm" method="post"
	action="/ServiceAction/com.eweaver.base.file.FileUploadAction?action=uploadFile" target="target_upload">
	<input type="file" name=attach1 id=attach1 style="width: 100%" contentEditable="false" onchange = "javascript:uploadFlie(this);">
	<input type="hidden" name="formActionType" value="<%=formActionType %>"/>
	<input type="hidden" name="formActionObjid" value="<%=formActionObjid %>"/>
</form>
<div id="processDiv" style='display:none'>
	<div id="processBorder">
		<div id="processBar"></div>
	</div>
	<span id="percent"></span>
	<span id="bytesRead"></span>
</div>
</body>
</html>
<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
	String albumId = StringHelper.null2String(request.getParameter("albumId"));
%>
<html>
<head>
<title>photo upload</title>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<link type="text/css" rel="stylesheet" href="/js/jquery/plugins/uploadify/uploadify.css"/> 
<style type="text/css">
.uploadBtn{
	width: 80px;
	height: 31px;
	position: absolute;
	top: 10px;
	left: 120px;
	cursor: pointer;
}
.uploadBtn:hover{
	background-color: #606060;
	background-image: linear-gradient(top, #606060 0%, #808080 100%);
	background-image: -o-linear-gradient(top, #606060 0%, #808080 100%);
	background-image: -moz-linear-gradient(top, #606060 0%, #808080 100%);
	background-image: -webkit-linear-gradient(top, #606060 0%, #808080 100%);
	background-image: -ms-linear-gradient(top, #606060 0%, #808080 100%);
	background-image: -webkit-gradient(
		linear,
		left bottom,
		left top,
		color-stop(0, #606060),
		color-stop(1, #808080)
	);
	background-position: center bottom;
}
.uploadify-queue-item{
	max-width: 550px;
}
#fileQueue{
	border: 1px double #333;
	height: 290px;
	overflow: auto;
	background-image: url("/js/jquery/plugins/uploadify/uploadQueueBG.png");
	background-repeat: no-repeat;
	background-position: 120px 110px;
}

</style>
<script type="text/javascript">
$(function(){
	
	$("#file_upload").uploadify({
    	'height'        : 27, 
    	'width'         : 80,  
    	'buttonText'    : '选择文件',
        'swf'           : '/js/jquery/plugins/uploadify/uploadify.swf',
        'uploader'      : '/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=uploadPhotos',
        'auto'          : false,
        'fileTypeExts'  : '*.gif;*.jpg;*.jpeg;*.png',
        'fileTypeDesc'  : '图片',
        'formData'      : {'albumId':'<%=albumId%>'},
        'queueID'       : 'fileQueue',
        'onUploadStart' : function(file) {},
        'onQueueComplete' : function(){
        	alert("上传完毕");
        	if(parent && parent.closeWinAndRePagination){
        		parent.closeWinAndRePagination();
        	}
        }
    });
});

function doPhotoUpload(){
	$('#file_upload').uploadify('upload','*');
}
</script>
</head>
<body style="padding: 10px;">
	<input type="file" name="uploadify" id="file_upload" />  
	<input type="button" class="uploadify-button uploadBtn" value="上传" onclick="javascript:doPhotoUpload();"/>
	<div id="fileQueue">
	
	</div>
</body>
</html>
<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.app.album.service.AlbumService"%>
<%@ page import="com.eweaver.app.album.model.Photo"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%
	String id = StringHelper.null2String(request.getParameter("id"));
	String albumId = StringHelper.null2String(request.getParameter("albumId"));
	AlbumService albumService = (AlbumService)BaseContext.getBean("albumService");
	List<Photo> photoList = albumService.getPhotosByAlbumId(albumId);
	JSONArray jsonArray = new JSONArray();
	for(Photo photo : photoList){
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("id", photo.getId());
    	jsonObject.put("objname", photo.getObjname());
    	jsonObject.put("attachId", photo.getAttachId());
    	jsonObject.put("dsporder", photo.getDsporder());
    	jsonObject.put("albumId", photo.getAlbumId());
    	jsonArray.add(jsonObject);
	}
%>
<html>
<head>
<title>photo view</title>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<style type="text/css">
#photoName{
	width: 100%;
	text-align: center;
	margin-top: 10px;
}
#photoName span{
	font-family: Microsoft YaHei;
}
#photoName span.name{
	font-size: 16px;
}
#photoName span.count{
	font-size: 12px;
	margin-left: 5px;
}
#photoView{
	position: absolute;
	top: 35px;
	text-align: center;
	border: 1px solid #E5E6E6;
	width: 800px;
	min-height: 450px;
	padding: 10px;
}
#photoImg{
	max-width: 778px;
}
#photoHandler_prev{
	position: absolute;
	top: 200px;
	left: 20px;
	cursor: pointer;
}
#photoHandler_next{
	position: absolute;
	top: 200px;
	right: 20px;
	cursor: pointer;
}
</style>
<script type="text/javascript">
var currentPhotoId = '<%=id%>';
var photos = $.parseJSON('<%=jsonArray.toString()%>');
Ext.onReady(function(){
	positionPhotoView();
	
	bindFunWhenImgOnload("photoImg",function(){
		positionPhotoImg();
		<% if(currentSysModeIsWebsite){ //网站模式%>
			resizeMainPageBodyHeight();
		<% } %>
	});
	showPhoto(currentPhotoId);
});

function bindFunWhenImgOnload(imgId, callbackFunction){
	var imgObj = document.getElementById(imgId);
	if (imgObj.attachEvent){    
		imgObj.attachEvent("onload", callbackFunction);
	}else { 
		imgObj.onload = callbackFunction;
	}
}

function positionPhotoView(){
	var documentWidth = $(document.body).width();
	
	var $photoView = $("#photoView");
	$photoView.css("left",(documentWidth - $photoView.outerWidth(true))/2 + "px");
}

function positionPhotoImg(){
	var $photoView = $("#photoView");
	var $photoImg = $("#photoImg");
	
	var photoViewHeight = $photoView.height();
	var photoImgHeight = $photoImg.outerHeight(true);
	
	var t = (photoViewHeight - photoImgHeight) / 2;
	$photoImg.css("margin-top", t + "px");
}

function getPhotoById(photoId){
	return 	photos[getPhotoIndex(photoId)];
}

function getPhotoIndex(photoId){
	for(var i = 0; i < photos.length; i++){
		if(photos[i].id == photoId){
			return i;
		}
	}
}

function isFirstPhoto(photoId){
	return getPhotoIndex(photoId) == 0;
}

function isLastPhoto(photoId){
	return getPhotoIndex(photoId) == (photos.length - 1);
}

function doPrevPhotoView(){
	if(isFirstPhoto(currentPhotoId)){
		
	}else{
		var currentPhotoIndex = getPhotoIndex(currentPhotoId);
		showPhoto(photos[currentPhotoIndex - 1].id);
	}
}

function doNextPhotoView(){
	if(isLastPhoto(currentPhotoId)){
		
	}else{
		var currentPhotoIndex = getPhotoIndex(currentPhotoId);
		showPhoto(photos[currentPhotoIndex + 1].id);
	}
}

function showPhoto(photoId){
	var photo = getPhotoById(photoId);
	
	var $photoName = $("#photoName");
	$photoName.html("<span class=\"name\">" + photo.objname + "</span>");
	$photoName.append("<span class=\"count\">("+(getPhotoIndex(photo.id)+1)+"/"+photos.length+")</span>")
	
	var $photoImg = $("#photoImg");
	$photoImg.css("margin-top", "0px");
	$photoImg.attr("src", "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + photo.attachId);
	$photoImg.attr("title", photo.objname);
	
	currentPhotoId = photo.id;
	
}
</script>
</head>
<body>
	<div id="photoName"></div>
	<div id="photoView">
		<img id="photoImg"/>
	</div>
	<div id="photoHandler_prev">
		<img src="/images/arrow_all_out.gif" title="上一张" onclick="doPrevPhotoView();"/>
	</div>
	<div id="photoHandler_next">
		<img src="/images/arrow_all.gif" title="下一张" onclick="doNextPhotoView();"/>
	</div>
</body>
</html>
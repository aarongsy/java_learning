<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.app.album.service.AlbumService"%>
<%
	String albumId = StringHelper.null2String(request.getParameter("albumId"));
	AlbumService albumService = (AlbumService)BaseContext.getBean("albumService");
	int photoCount = albumService.getPhotoCountByAlbumId(albumId);
	boolean isAlbumManager = albumService.theCurrentUserIsAlbumManager();
%>
<html>
<head>
<title>photo list</title>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type='text/javascript' src='/js/jquery/plugins/pagination/jquery.pagination.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/pagination/pagination.css"/>
<style type="text/css">
#photoList{	/*皮肤列表框对应的样式*/
	height: 460px;	/*高度足够大,在js中会做调整*/
}
#photoList ul{
	margin: 0px;
	padding: 0px;
	list-style: none;
}
#photoList ul li{
	text-align: center;
	width: 160px;
	float: left;
	display: inline;
	margin: 5px 0px 5px 30px;
}
#photoList ul li span.photo{
	position: relative;
	width: 160px;
	height: 120px;
	display: block;
	background: url("/images/application/photopreview-bg.png") no-repeat;
	overflow: hidden;
}
#photoList ul li span.photo:hover{
	background: url("/images/application/photopreview-available-bg.png") no-repeat;
}
#photoList ul li span.selected{
	background: url("/images/application/photopreview-available-bg.png") no-repeat;
}
#photoList ul li span.photo a{
	position:absolute;
	width: 140px;
	height: 100px;
	overflow: hidden;
	top: 10px;
	left: 10px;
	cursor: pointer;
}
#photoList ul li span.photo a img{
	width: 138px;
	height: 98px;
	border: 1px solid #CDCDCD;
}
#photoList ul li span.photoInfo{
	display: block;
	height: 20px;
	padding-left: 5px;
	position: relative;
}
#photoList ul li span.photoInfo span{
	display: block;
	float: left;
}
#photoList ul li span.photoInfo span.photo-cb{
	overflow: hidden;
	height: 20px;
}
#photoList ul li span.photoInfo span.photo-name{
	font-family: Microsoft YaHei;
	color: #0282C4;
	width: auto;
	max-width: 100px;
	height: 20px;
	overflow: hidden;
}
#photoList ul li span.photoInfo span.photo-handler{
	height: 20px;
	margin-left: 2px;
	position: relative;
}
#photoList ul li span.photoInfo span.photo-handler img{
	cursor: pointer;
}
#photoList ul li span.photoInfo span.photo-handler img.edit{
	position: absolute;
	top: 0px;
	left: 0px;
	width: 16px;
	height: 16px;
}
#photoList ul li span.photoInfo span.photo-handler img.delete{
	position: absolute;
	top: 0px;
	left: 16px;
	width: 16px;
	height: 16px;
}
#photoList ul li span.photoInfo span.photo-nameEdit{
	height: 20px;
	overflow: hidden;
	display: none;
}
#photoList ul li span.photoInfo span.photo-nameEdit{
	display: none;
}
#photoList ul li span.photoInfo span.photo-nameEdit .photoNameTxt{
	width: 90px;
	height: 15px;
}
#photoList ul li span.photoInfo span.photo-nameEdit .photoNameSaveBtn{
	width: 35px;
	height: 18px;
	font-size: 10px;
}
.cbox{
	height:13px; 
	vertical-align:text-top; 
	margin-top:2px;
	margin-right: 2px;
}
.pagination{
	position: absolute;
	bottom: 10px;
	right: 20px;
}
#checkAll{
	position: absolute;
	left: 35px;
	bottom: 10px;
}
<%if(!isAlbumManager){%>
#photoList ul li span.photoInfo span.photo-cb{
	display: none !important;
}
#photoList ul li span.photoInfo span.photo-handler{
	display: none !important;
}
#photoList ul li span.photoInfo span.photo-name{
	max-width: none;
	width: 150px;
}
#checkAll{
	display: none !important;
}
<%}%>
</style>
<script type="text/javascript">
var cPageIndex = 0;	//页面索引初始值    
var pageSize;	   //每页显示条目数

Ext.onReady(function(){
	var tb = new Ext.Toolbar();
	tb.render('pagemenubar');
	tb.addButton([
		{
			text: "上传相片(U)",
			key: "u",
			alt:true,
			iconCls:Ext.ux.iconMgr.getIcon('arrow_up'),
	        handler:uploadPhoto
		},
		{
			text: "删除相片(D)",
			key: "d",
			alt:true,
			iconCls:Ext.ux.iconMgr.getIcon('delete'),
	        handler:deletePhotos
		},
		{
			text: "移动相片(M)",
			key: "m",
			alt:true,
			iconCls:Ext.ux.iconMgr.getIcon('arrow_branch'),
	        handler:forMovePhotos
		},
		{
			text: "编辑相册(E)",
			key: "e",
			alt:true,
			iconCls:Ext.ux.iconMgr.getIcon('application_edit'),
	        handler:function(){window.location = "/app/album/albummodify.jsp?id=<%=albumId%>";}
		}
	]);
	
	<%if(!isAlbumManager){%>
		tb.hide();
	<%}%>
	
	pageSize = calculatePageSize();
	
	<% if(photoCount > 0){ %>
		doPhotoPagination(<%=photoCount%>);	
	<% } %>
	
	$(window).resize(function(){
		if($("#photoList ul li").not("#placeholderPhoto").length > 0){
			pageSize = calculatePageSize();
			reDoPhotoPagination();
		}
	});
});
	
function uploadPhoto(){
	openPhotoDialog("/app/album/photoupload.jsp?albumId=<%=albumId%>","上传相片",600,400);
}

var photoDialog;
function openPhotoDialog(url,title,width,height){
	var config = {
	    layout:'border',
	    closeAction:'close',
	    plain: true,
	    modal :true,
	    items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }]
	};
   	photoDialog = new Ext.Window(config);
    photoDialog.render(Ext.getBody());
    photoDialog.setTitle(title);
    photoDialog.setWidth(width);
    photoDialog.setHeight(height);
    photoDialog.getComponent('commondlg').setSrc(url);
    photoDialog.show();
}

function closePhotoDialog(){
	if(photoDialog){
		photoDialog.close();
	}
}

function doPhotoPagination(photoCount){
	var maxPageIndex;
	if(photoCount % pageSize == 0){
		maxPageIndex = parseInt(photoCount / pageSize) - 1;
	}else{
		maxPageIndex = parseInt(photoCount / pageSize);
	}
	maxPageIndex = maxPageIndex < 0 ? 0 : maxPageIndex;
	if(cPageIndex > maxPageIndex){
		cPageIndex = maxPageIndex;
	}
	$("#photoPagination").pagination(photoCount, {    
		callback: PageCallback,    
		link_to: 'javascript:void(0);',
		prev_text: '上一页',       //上一页按钮里text    
		next_text: '下一页',       //下一页按钮里text    
		items_per_page: pageSize,  //显示条数    
		num_display_entries: 6,    //连续分页主体部分分页条目数    
		current_page: cPageIndex,   //当前页索引    
		num_edge_entries: 2        //两侧首尾分页条目数    
	});    

	//翻页回调函数
	function PageCallback(index, jq) { 
		Ext.Ajax.request({   
			url: "/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=getPhotos",   
			method : 'post',
			params:{   
				albumId : '<%=albumId%>',
				pageno : index + 1,
				pagesize : pageSize
			}, 
			success: function (response)    
	        {   
				cPageIndex = index;
				var datas = Ext.decode(response.responseText);
				fillPhotos(datas);
	        },
		 	failure: function(response,opts) {    
			 	Ext.Msg.alert('pagination error : \n', response.responseText);   
			}  
		}); 
	}  
	
	//填充数据
	function fillPhotos(datas){
		var html = "<ul>";
		var results = datas["result"];
		for(var i = 0; i < results.length; i++){
			var result = results[i];
			html += "<li id=\"photoLi_"+result["id"]+"\">";
			html += "<span class=\"photo\">";
			html +=		"<a href=\"javascript:viewPhoto('"+result["id"]+"');\" class=\"photo-img\"><img src=\"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+result["attachId"]+"\"/></a>";
			html += "</span>";
			html += "<span class=\"photoInfo\">";
			html += 	"<span class=\"photo-cb\"><input type=\"checkbox\" class=\"cbox\" name=\"photoId\" value=\""+result["id"]+"\"/></span>";
			html += 	"<span class=\"photo-name\">"+result["objname"]+"</span>";
			html += 	"<span class=\"photo-handler\"><img src=\"/images/silk/page_white_edit.gif\" title=\"编辑：重命名\" class=\"edit\" onclick=\"javascript:doEditPhotoName('"+result["id"]+"');\"/><img src=\"/images/base/delete.GIF\" title=\"删除\" class=\"delete\" onclick=\"javascript:deletePhoto('"+result["id"]+"');\"/></span>";
			html += 	"<span class=\"photo-nameEdit\"><input type=\"text\" id=\"photoName_"+result["id"]+"\" class=\"photoNameTxt\" value=\""+result["objname"]+"\"/><input type=\"button\" value=\"保存\" class=\"photoNameSaveBtn\" onclick=\"javascript:savePhotoName('"+result["id"]+"')\"/></span>";
			html += "</span>";
			html += "</li>";
		}
		html += "</ul>";
		$("#photoList").html(html);
	}
}

function calculatePageSize(){
	var docWidth = $(document.body).width();
	var docHeight = $(window).height();
	
	var $photo = $("#photoList ul li");
	var photoWidth = $photo.outerWidth(true);
	var photoHeight = $photo.find("span.photo").outerHeight(true) + $photo.find("span.photoInfo").outerHeight(true) + ($photo.outerHeight(true) - $photo.height());
	
	var pagemenubarHeight = $("#pagemenubar").outerHeight(true);
	var footerHeight = 30;
	
	
	var cols = parseInt(docWidth / photoWidth);
	var rows = parseInt((docHeight - pagemenubarHeight - footerHeight) / photoHeight);
	
	return cols * rows;
}

function reDoPhotoPagination(){
	Ext.Ajax.request({   
		url: "/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=getPhotoCount",   
		method : 'post',
		params:{   
			albumId : '<%=albumId%>'
		}, 
		success: function (response)    
        {   
			doPhotoPagination(response.responseText);
			var photoCount = parseInt(response.responseText);
			if(photoCount > 0){
				$("#checkAll").show();
			}else{
				$("#photoPagination").find("*").remove();
				$("#checkAll").hide();
			}
        },
	 	failure: function(response,opts) {    
		 	Ext.Msg.alert('getPhotoCount error : \n', response.responseText);   
		}  
	}); 
}

function closeWinAndRePagination(){
	reDoPhotoPagination();
	closePhotoDialog();
}

function doEditPhotoName(photoId){
	var $photoLi = $("#photoLi_" + photoId);
	$photoLi.find(".photoInfo .photo-name").hide();
	$photoLi.find(".photoInfo .photo-handler").hide();
	$photoLi.find(".photoInfo .photo-nameEdit").show();
}

function savePhotoName(photoId){
	var $photoName = $("#photoName_" + photoId);
	if($.trim($photoName.val()) == ""){
		alert("相片名称不能为空！");
		$photoName[0].focus();
		return;
	}
	Ext.Ajax.request({   
		url: "/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=updatePhotoName",   
		method : 'post',
		params:{   
			id : photoId,
			objname: $photoName.val()
		}, 
		success: function (response)    
        {   
			if(response.responseText == "success"){
				var $photoLi = $("#photoLi_" + photoId);
				$photoLi.find(".photoInfo .photo-name").html($photoName.val());
				$photoLi.find(".photoInfo .photo-name").show();
				$photoLi.find(".photoInfo .photo-handler").show();
				$photoLi.find(".photoInfo .photo-nameEdit").hide();
				if(top.pop){
					top.pop("<span>操作成功！<span>");
				}else{
					alert("操作成功！");
				}
			}else{
				alert("操作失败！");
			}
        },
	 	failure: function(response,opts) {    
		 	Ext.Msg.alert('updatePhotoName error : \n', response.responseText);   
		}  
	}); 
}

function deletePhoto(photoId){
	if(!confirm("确认要删除此相片吗？")){
		return;
	}
	Ext.Ajax.request({   
		url: "/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=deletePhoto",   
		method : 'post',
		params:{   
			id : photoId
		}, 
		success: function (response)    
        {   
			if(response.responseText == "success"){
				reDoPhotoPagination();
				if(top.pop){
					top.pop("<span>操作成功！<span>");
				}else{
					alert("操作成功！");
				}
			}else{
				alert("操作失败！");
			}
        },
	 	failure: function(response,opts) {    
		 	Ext.Msg.alert('deletePhoto error : \n', response.responseText);   
		}  
	}); 
}

function deletePhotos(){
	var checkedPhotoIds = getCheckedPhotoIds();
	if(checkedPhotoIds == ""){
		alert("请先选择要删除的相片！");
		return;
	}
	if(confirm("确定要删除这些选中的相片吗？")){
		Ext.Ajax.request({   
			url: "/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=deletePhotos",   
			method : 'post',
			params:{   
				ids : checkedPhotoIds
			}, 
			success: function (response)    
	        {   
				if(response.responseText == "success"){
					reDoPhotoPagination();
					if(top.pop){
						top.pop("<span>操作成功！<span>");
					}else{
						alert("操作成功！");
					}
				}else{
					alert("操作失败！");
				}
	        },
		 	failure: function(response,opts) {    
			 	Ext.Msg.alert('deletePhotos error : \n', response.responseText);   
			}  
		}); 
	}
}

function forMovePhotos(){
	var checkedPhotoIds = getCheckedPhotoIds();
	if(checkedPhotoIds == ""){
		alert("请先选择要移动的相片！");
		return;
	}
	openPhotoDialog("/app/album/albumchoose.jsp","相册选择",600,400);
}

function movePhotos(toAlbumId){
	if(toAlbumId == '<%=albumId%>'){	//移动的目录和当前目录是同一目录
		if(top.pop){
			top.pop("<span>操作成功！<span>");
		}else{
			alert("操作成功！");
		}
		closePhotoDialog();
	}else{
		var checkedPhotoIds = getCheckedPhotoIds();
		Ext.Ajax.request({   
			url: "/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=movePhotos",   
			method : 'post',
			params:{   
				ids : checkedPhotoIds,
				albumId: toAlbumId
			}, 
			success: function (response)    
	        {   
				if(response.responseText == "success"){
					if(top.pop){
						top.pop("<span>操作成功！<span>");
					}else{
						alert("操作成功！");
					}
					closeWinAndRePagination();
				}else{
					alert("操作失败！");
				}
	        },
		 	failure: function(response,opts) {    
			 	Ext.Msg.alert('movePhotos error : \n', response.responseText);   
			}  
		}); 
	}
}

function getCheckedPhotoIds(){
	var checkedPhotoIds = "";
	$("input[type='checkbox'][name='photoId']:checked").each(function(i){
		checkedPhotoIds = checkedPhotoIds + this.value + ",";
	});
	if(checkedPhotoIds != ""){
		checkedPhotoIds = checkedPhotoIds.substring(0, checkedPhotoIds.length - 1);
	}
	return checkedPhotoIds;
}

function checkOrUnCheckAll(cb){
	var photoIds = document.getElementsByName("photoId");
	if(photoIds){
		for(var i = 0; i < photoIds.length; i++){
			photoIds[i].checked = cb.checked;
		}
	}
}

function viewPhoto(photoId){
	var photoName = $("#photoName_" + photoId).val();
	onUrl("/app/album/photoview.jsp?id="+photoId+"&albumId=<%=albumId%>", "相片-"+photoName, "tab"+photoId);
}
</script>
</head>
<body>
<div id="pagemenubar"></div>
<div id="photoList">
	<ul style="display: none;">
		<li id="placeholderPhoto">
			<span class="photo">
				<a onclick="" class="photo-img"><img src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=402881e43b68ceaa013b68d5ac330003" title=""/></a>
			</span>
			<span class="photoInfo">
				<span class="photo-cb"><input type="checkbox" class="cbox"/></span>
				<span class="photo-name">占位的相片</span>
				<span class="photo-handler"><img src="/images/silk/page_white_edit.gif" title="" class="edit"/><img src="/images/base/delete.GIF" class="delete"/></span>
				<span class="photo-nameEdit"><input type="text" class="photoNameTxt"/><input type="button" value="保存" class="photoNameSaveBtn"/></span>
			</span>
		</li>
	</ul>
</div>
<div id="checkAll" <%if(photoCount <= 0){%>style="display: none;"<%}%>>
	<input type="checkbox" id="checkAllPhoto" class="cbox" onclick="checkOrUnCheckAll(this);"/> 全选
</div>
<div id="photoPagination" class="pagination">

</div>
</body>
</html>
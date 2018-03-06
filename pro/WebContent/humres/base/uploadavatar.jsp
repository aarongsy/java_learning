<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%
	String humresId = StringHelper.null2String(request.getParameter("id"));
	HumresService humresService = (HumresService)BaseContext.getBean("humresService");
	Humres humres = humresService.getHumresById(humresId);
	response.setHeader("Cache-Control", "no-store,no-cache,must-revalidate");  
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");  
	response.setHeader("Pragma", "no-cache");  
%>
<html>
<head>    
<title></title>
<meta http-equiv="pragma" content="no-cache">  
<meta http-equiv="cache-control" content="no-cache">  
<meta http-equiv="expires" content="0"> 
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
	var mooCrop;
	function showAvatarPicDiv(){
		var avatarPicDiv = document.getElementById("avatarPicDiv");
		avatarPicDiv.style.display = "block";
		var avatarPic = document.getElementById("avatarPic");
		avatarPic.src = "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=humres.getImgfile() %>&" + Math.random();
		avatarPic.onreadystatechange = function(){	//图片加载完毕
			if(avatarPic.readyState=="complete"||avatarPic.readyState=="loaded"){ 
				mooCrop = new MooCrop("avatarPic",{
				 	'handleColor' : '#333333',
				 	'handleWidth' : '5px',
				 	'handleHeight' : '5px',
				 	'min': { 'width' : 200, 'height' : 250 },
				 	'showHandles' : true
				});
            } 
		};
	}

	//保存切割后的头像'width','height','top','left','right','bottom' 
	function saveCutAvatar(){
		if(mooCrop){
			var cropInfo = mooCrop.getCropInfo();
			//alert("width:" + cropInfo.width + " height:" + cropInfo.height + " top:" + cropInfo.top + " left:" +cropInfo.left+ " right:" +cropInfo.right+ " bottom:"+cropInfo.bottom);
			Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.humres.base.servlet.HumresInfoAction?action=saveCutAvatar',   
				method : 'post',
				params:{   
					x : cropInfo.left,
					y : cropInfo.top,
					width : cropInfo.width,
					height : cropInfo.height,
					sourceAttachid : '<%=humres.getImgfile()%>'
				}, 
				success: function (response){   
					parent.innerFunction(reload,response.responseText);
		        },
			 	failure: function(response,opts) {
				 	Ext.Msg.alert('saveCutAvatar Error', response.responseText);   
				}
			});
		}
	}
	function reload(){}
	
	function submitForUploadAvatar(){
		var avatar = document.getElementById("avatar");
		if(avatar.value == ""){
			alert("<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0045")%>");//请点击浏览选择图片后再执行上传！
			return;
		}
		var suffix = avatar.value.substring(avatar.value.lastIndexOf("."));
		if (suffix != ".jpg" && suffix != ".JPG" && suffix != ".gif"
				&& suffix != ".GIF" && suffix != ".jpeg" && suffix != ".JPEG"
				&& suffix != ".png" && suffix != ".PNG"){
			alert("<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0046")%>");//请上传图片格式的文件！
			return;
		}
		var uploadAvatarForm = document.forms["uploadAvatarForm"];
		uploadAvatarForm.action = "/ServiceAction/com.eweaver.humres.base.servlet.HumresInfoAction?action=uploadAvatar&humresId=<%=humresId%>";
		uploadAvatarForm.submit();
	}
</script>
</head>
<body>
<form action="" id="uploadAvatarForm" name="uploadAvatarForm" method="post" enctype="multipart/form-data">
	<div style="padding-left: 10px;padding-top: 10px;">
		<div id="avatarPicDiv" style="display: none;padding-bottom: 10px;">
			<div><img id="avatarPic" src=""/></div>
		</div>
		<div id="uploadDiv">
			<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0047")%>：<!-- 上传照片 -->
			<input id="avatar" name="avatar" type="file" style="width: 400px;" onchange="submitForUploadAvatar();"/>
		</div>
	</div>
</form>
</body>
</html>
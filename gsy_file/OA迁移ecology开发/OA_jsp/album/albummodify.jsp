<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.app.album.service.AlbumService"%>
<%@page import="com.eweaver.app.album.model.Album"%>
<%@ include file="/base/init.jsp"%>
<%
	AlbumService albumService = (AlbumService)BaseContext.getBean("albumService");
	String pid = StringHelper.null2String(request.getParameter("pid"));
	if(pid.equals("r00t")){
		pid = "";
	}
	String id = StringHelper.null2String(request.getParameter("id"));
	Album album = albumService.getAlbumById(id);
	if(StringHelper.isEmpty(pid)){
		pid = StringHelper.null2String(album.getPid());
	}
%>
<html>
<head>
<title>album modify</title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
<style type="text/css">
.inputstyle{
	width: 60%;
}
</style>
<script type="text/javascript">
	Ext.onReady(function(){
		document.getElementById("pagemenubar").style.width = document.body.clientWidth + "px";
		var tb = new Ext.Toolbar();
		tb.render('pagemenubar');
		addBtn(tb,'确定','S','accept',function(){$("#AlbumForm").submit();});
		<% if(!StringHelper.isEmpty(id)){ //modify%>
			addBtn(tb,'管理相片','M','anchor',function(){window.location = "/app/album/photolist.jsp?albumId=<%=id%>";});
		<% } %>
		
		$("#AlbumForm").ajaxForm({
			beforeSubmit:function(){
				var flag = true;
				$('#objnamespan').html("");
				if($('#objname').val() == ''){
					$('#objnamespan').html("请填写名称!");
					flag = false;
				}
				return flag;
			},
	        success: function(responseText, statusText, xhr, $form){
	        	if(responseText != "error"){
	        		var pAlbumTree = parent.albumTree;
	        		var pSelectNode = pAlbumTree.getSelectionModel().getSelectedNode();
	        		<% if(!StringHelper.isEmpty(id)){ //modify%>
	        			if(pSelectNode != null && pSelectNode.parentNode != null){
							pSelectNode.parentNode.reload();
							setTimeout(function(){
	        					pAlbumTree.getSelectionModel().select(pAlbumTree.getNodeById('<%=id%>'));
	        				},500);
						}
	        			if(top.pop){
							top.pop("<span>操作成功！<span>");
						}
	        		<% }else{ //create%>
	        			if(pSelectNode != null){
	        				pSelectNode.reload();
	        				setTimeout(function(){
	        					if(pSelectNode.lastChild != null){
	        						pAlbumTree.getSelectionModel().select(pSelectNode.lastChild);
	        					}
	        					window.location = "/app/album/photolist.jsp?albumId=" + responseText;
	        				},500);
	        				
	        			}
	        		<% } %>
	        	}else{
	        		alert("保存失败");
	        	}
	        }
		}); 
	});
</script>
</head>
<body>
<div id="pagemenubar"></div>
<form id="AlbumForm" action="/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=createOrModifyAlbum" method="post">
<input type="hidden" name="pid" value="<%=pid %>"/>
<table>
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>
	<tr>
		<td class="FieldName">ID</td>
		<td class="FieldValue">
			<input class="inputstyle" type="text" name="id"  id="id" value="<%=StringHelper.null2String(id)%>" readonly/>
		</td>
	</tr>
	<tr>
		<td class="FieldName">名称</td>
		<td class="FieldValue">
			<input class="inputstyle" type="text" name="objname"  id="objname" onchange="checkInput('objname','objnamespan')" value="<%=StringHelper.null2String(album.getObjname())%>"/>
			<span id="objnamespan" style="color: red;font-weight: bold;padding-left: 5px;">
   				<% if(StringHelper.isEmpty(album.getObjname())){%>
					<img src="/images/base/checkinput.gif">
				<% } %>
          	</span>
		</td>
	</tr>
	<tr>
		<td class="FieldName">相片存放路径</td>
		<td class="FieldValue">
			<input class="inputstyle" type="text" name="photoSavePath"  id="photoSavePath" value="<%=StringHelper.null2String(album.getPhotoSavePath())%>"/>
		</td>
	</tr>
	<tr>
		<td class="FieldName">显示顺序</td>
		<td class="FieldValue">
			<input class="inputstyle" type="text" name="dsporder"  id="dsporder" value="<%=StringHelper.null2String(album.getDsporder())%>"/>
		</td>
	</tr>
</table>
</form>
</body>
</html>
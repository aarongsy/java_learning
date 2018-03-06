<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<title>album choose</title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/TreeCheckNodeUI.js"></script>
<style type="text/css">
.x-panel-body{
	border: none;
}
</style>
<script type="text/javascript">
	Ext.SSL_SECURE_URL='about:blank';
	Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';
	
	var checkedAlbumId = "";
	Ext.onReady(function(){
		document.getElementById("pagemenubar").style.width = document.body.clientWidth + "px";
		var tb = new Ext.Toolbar();
		tb.render('pagemenubar');
		addBtn(tb,'确定','S','accept',function(){
			if(checkedAlbumId == ""){
				alert("请选择目标相册！");
				return;
			}
			if(parent && parent.movePhotos){
				parent.movePhotos(checkedAlbumId);
				tb.disable();
			}
		});
		
		var albumChooseTree = new Ext.tree.TreePanel({
			checkModel: 'single',
			animate: true,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            region:'center',
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '相册类别',
                id:'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
			loader:new Ext.tree.TreeLoader({
				dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.album.servlet.AlbumAction?action=getAlbums&browser=1",
				preloadChildren:false,
				baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
			})
		});
		albumChooseTree.on('checkchange',function(n,c){
			checkedAlbumId = n.id ;
		});
		albumChooseTree.render(Ext.getBody());
	});
</script>
</head>
<body>
<div id="pagemenubar"></div>
</body>
</html>
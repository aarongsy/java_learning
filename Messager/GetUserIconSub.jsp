<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page import="com.eweaver.base.util.*" %>
<head>
<%
	String imagefileid = StringHelper.null2String(request.getParameter("imagefileid"));



%>
<script type="text/javascript" src="/messager/jquery.js"></script>
<link rel="stylesheet" type="text/css"
	href="/messager/imgareaselect/css/imgareaselect-default.css" />
<script type="text/javascript"
	src="/messager/imgareaselect/scripts/jquery.imgareaselect.pack.js"></script>
</head>
<body>
	<div id="divContent">
		<img style='float: left; margin-right: 10px;' src='/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imagefileid%>' id='ferret' />
	</div>
</body>
</html>
<script LANGUAGE="JavaScript">
	var widthImg=1;
	var heightImg=1;

	$(document).ready( function() {
		$(parent.document.body).find("#imagefileid").val("<%=imagefileid%>");
		widthImg=parseInt($('#ferret').width());
		heightImg=parseInt($('#ferret').height());		
		
		$(parent.document.getElementById('divTargetImg')).append(
				'<div style="float:\'left\';position:\'relative\';overflow:\'hidden\';width:\'100px\';height:\'100px\'">'+
				'<img src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imagefileid%>" style="position: relative;" /><div>');

		$('#ferret').imgAreaSelect( {
			aspectRatio : '1:1',
			onSelectChange : preview,
			x1 : 0,
			y1 : 0,
			x2 : 100,
			y2 : 100,
			maxWidth : 330,
			maxHeight : 330,
			onSelectEnd: function (img, selection) {
	            $(parent.document.body).find('input[name=x1]').val(selection.x1);
	            $(parent.document.body).find('input[name=y1]').val(selection.y1);
	            $(parent.document.body).find('input[name=x2]').val(selection.x2);
	            $(parent.document.body).find('input[name=y2]').val(selection.y2);            
	        }			
		});		
	});
	
	function preview(img, selection) {
		var scaleX = 100 / (selection.width || 1);
		var scaleY = 100 / (selection.height || 1);		
		$(parent.document.getElementById('divTargetImg')).find('img').css( {
			width : Math.round(scaleX * widthImg) + 'px',
			height : Math.round(scaleY * heightImg) + 'px',
			marginLeft : '-' + Math.round(scaleX * selection.x1) + 'px',
			marginTop : '-' + Math.round(scaleY * selection.y1) + 'px'
		});
	}
	
	
</script>
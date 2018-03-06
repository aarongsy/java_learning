<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<title></title>
<style type="text/css">
	.x-toolbar table {width:0}
	#pagemenubar table {width:0}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {width:0}
</style>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/portal/style/js/portletstylelist.js"></script>
</head>
<body style="margin:0px;padding:0px">
<div id="stylePanel">
<div id="pagemenubar"></div>
	<form id="EweaverForm" name="EweaverForm" action="" method="post">
		<table>
			<tbody>
				<tr class="title">
					<td class="FieldName" nowrap width="65px;">样式名称：</td>
					<td class="FieldValue" nowrap>
						<input type="text" id="objname" name="objname" value="" style="width: 120px;"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
</html>
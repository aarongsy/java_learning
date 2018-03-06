<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.LabelType"%>
<%@page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ include file="/base/init.jsp"%>
<%
%>
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
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/base/label/js/labelchoose_system.js"></script>
<script type="text/javascript">
</script>
</head>
<body style="margin:0px;padding:0px">
<div id="labelPanel">
<div id="pagemenubar"></div>
	<form id="EweaverForm" name="EweaverForm" action="" method="post">
		<table>
			<tbody>
				<tr class="title">
					<td class="FieldName" nowrap width="80px;">标签关键字：</td>
					<td class="FieldValue" nowrap>
						<input type="text" id="keyword" name="keyword" value="" style="width: 120px;"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
</html>
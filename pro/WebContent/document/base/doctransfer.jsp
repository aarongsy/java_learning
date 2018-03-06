<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@page import="com.eweaver.base.DataService"%>
<%
	String flag = StringHelper.null2String(request.getParameter("flag"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980025")%></title><!-- 虚拟目录 -->
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<style type="text/css">
	.x-toolbar table {
		width: 0
	}
	a {
		color: blue;
		cursor: pointer;
	}
	#pagemenubar table {
		width: 0
	}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {
		width: 0
	}
</style>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="./js/doctransfer.js"></script>
<script type="text/javascript">
	function getBrowser(url, inputname, inputspan, isneed) {
		url = url + "&level=1";
		//url = url + "&sqlwhere=" + "1!=1) or (isdelete!=1 and moduleid = '402880732813ed87012814269eed0004' and (select count(1) from category b where b.pid = a.id)=0";
		var id;
	    try {
	    	id = window.showModalDialog("/base/popupmain.jsp?url=" + url);
	    } catch(e) {
	        
		}
		if (id!=null) {
			if (id[0] != '0') {
				document.all(inputname).value = id[0];
				document.all(inputspan).innerHTML = id[1];
		    }else{
				document.all(inputname).value = '';
				if (isneed == '0')
					document.all(inputspan).innerHTML = '';
				else
					document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
			}
		}
	}
</script>
</head>
<body>
	<div id="divSearch" style="height: 70px;">
	<div id="pagemenubar"></div>
	<input type="hidden" id="flag" value="<%=flag %>"/>
	<form id="EweaverForm" name="EweaverForm" action="" method="post">
		<table>
			<thead>
				<tr>
					<th width="70px;"></th>
					<th width="20%"></th>
					<th width="80px"></th>
					<th width="*"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="right"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980027")%>：</td><!-- 源子目录 -->
					<td>
						<button type="button" class=Browser onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser.jsp?id=4028bc5c1bba3f4a011bba4216110002&rootId=40288148117d0ddc01117d8c36e00dd4&optType=0', 'source', 'sourcespan', '1');"></button>
				        <input type="hidden" name="source" id="source" value=""><span id="sourcespan"></span>
					</td>
					<td><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980026")%>：</td><!-- 目标子目录 -->
					<td>
						<button type="button" class=Browser onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser.jsp?id=4028bc5c1bba3f4a011bba4216110002&rootId=40288148117d0ddc01117d8c36e00dd4&optType=0', 'target', 'targetspan', '1');"></button>
				        <input type="hidden" name="target" id="target" value="">   
				        <span id="targetspan"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</body>
</html>
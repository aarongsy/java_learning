<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980019")%></title><!-- 知识推送 -->
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/datapicker/css/WdatePicker.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript">
	var load="<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>";
	var a1="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009") %>";
	var a2="<%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %>";
	var a3="<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e") %>";
	var a4="<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd72253df000c") %>";
	var a5="<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008") %>";
	var a6="<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006") %>";
	var a7="<%=labelService.getLabelNameByKeyId("402881eb0bd6f028010bd6fede180002") %>";
	var a8="<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019") %>";
	var a9="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980023") %>";
	var a10="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20f004d") %>";
	var a11="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980024") %>";
	var a12="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20e0041") %>";
	var a13="<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa862c2ed0004") %>";
	var a14="<%=labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042") %>";
	var up="<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>";
	var down="<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>";
	var colsdy="<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>";
	
	var b2="<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>";
	var b3="<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>";
	var b4="<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>";
	var b5="<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>";
	var b6="<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>";
	var b7="<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>";
	var b8="<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %>";
	var b9="<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %>";
	var b10="<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>";
</script>
<script type="text/javascript" src="./js/docpushlist.js"></script>
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
<script type="text/javascript">
	function getBrowser(url, inputname, inputspan, isneed) {
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
	<div id="divSearch">
	<div id="pagemenubar"></div>
	<form id="EweaverForm" name="EweaverForm" action="/ServiceAction/com.eweaver.document.base.servlet.DocPushAction?action=push" method="post">
		<table>
			<tbody>
				<tr class="title">
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%>：</td><!-- 标题 -->
					<td class="FieldValue" nowrap>
						<input type="text" id="subject" name="subject" value="">
					</td>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd72253df000c")%>：</td><!--创建日期  -->
					<td class="FieldValue" nowrap>
						<input type="text" id="mincreatedate" name="mincreatedate" value="" onclick="WdatePicker({dateFmt: 'yyyy-MM-dd'})">
						--
						<input type="text" id="maxcreatedate" name="maxcreatedate" value="" onclick="WdatePicker({dateFmt: 'yyyy-MM-dd'})">
					</td>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006")%>：</td><!--创建者  -->
					<td class="FieldValue" nowrap>
						<button type="button" class="Browser" onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp?type=browser', 'UserIDs', 'UserIDsSpan', '1');"></button>
				        <input type="hidden" name="UserIDs" id="UserIDs" value="">   
				        <span id="UserIDsSpan"></span>
					</td>
				</tr>
				<tr class="title">
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881eb0bd6f028010bd6fede180002")%>：</td><!-- 附件数 -->
					<td class="FieldValue" nowrap>
						<input type="text" id="attachnum" name="attachnum" value="">
					</td>
					<!-- <td class="FieldName" nowrap>状态：</td>
					<td class="FieldValue" nowrap>
						<select id="status" name="status">
							<option value=""></option>
							<option value="-1">作废</option>
							<option value="0">草稿</option>
							<option value="1">正式</option>
						</select>
					</td> -->
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%>：</td><!-- 分类 -->
					<td class="FieldValue" nowrap>
						<button type="button" class="Browser" onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser.jsp?id=4028bc5c1bba3f4a011bba4216110002&rootId=40288148117d0ddc01117d8c36e00dd4&optType=0', 'CategoryIDs', 'CategoryIDsSpan', '1');"></button>
				        <input type="hidden" name="CategoryIDs" id="CategoryIDs" value="">   
				        <span id="CategoryIDsSpan"></span>
					</td>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e")%>：</td><!-- 摘要 -->
					<td class="FieldValue" nowrap>
						<input type="text" id="abstract" name="abstract" value="">
					</td>
				</tr>
				<tr class="title">
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980023")%>：</td><!-- 推送人 -->
					<td class="FieldValue" nowrap>
						<button type="button" class="Browser" onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp?type=browser', 'PusherIDs', 'PusherIDsSpan', '1');"></button>
				        <input type="hidden" name="PusherIDs" id="PusherIDs" value="">   
				        <span id="PusherIDsSpan"></span>
					</td>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980024")%>：</td><!-- 推送日期 -->
					<td class="FieldValue" nowrap>
						<input type="text" id="minpushdate" name="minpushdate" value="" onclick="WdatePicker({dateFmt: 'yyyy-MM-dd'})">
						--
						<input type="text" id="maxpushdate" name="maxpushdate" value="" onclick="WdatePicker({dateFmt: 'yyyy-MM-dd'})">
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</body>
</html>
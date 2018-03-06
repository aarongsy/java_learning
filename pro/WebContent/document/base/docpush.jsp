<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%
	EweaverUser user = BaseContext.getRemoteUser();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980019")%></title><!-- 知识推送 -->
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript">
	var doc="<%=labelService.getLabelNameByKeyId("402881e90c63546b010c638e0ea0002f") %>";
	var pushdate="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980024") %>";
	var dic="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980021") %>";
	var pushtime="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20e0041") %>";
	var puser="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20e0043") %>";
	var pstat="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20e0045") %>";
	var porg="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20e0047") %>";
	var minlevel="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20e0049") %>";
	var maxlevel="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20f004b") %>";
	var pushdes="<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20f004d") %>";
	var load="<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>";
	var up="<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>";
	var down="<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>";
	var colsdy="<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>";
	var del="<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>";
	var suredel="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075") %>";
	var a1="<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>";
	var a2="<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>";
	var a3="<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>";
	var a4="<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>";
	var a5="<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>";
	var a6="<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>";
	var a7="<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>";
	var a8="<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %>";
	var a9="<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %>";
	var a10="<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>";
</script>
<script type="text/javascript" src="./js/docpush.js"></script>
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
function onChangeShareType() {
	var dom1 = document.getElementById("showUserIDs");
	var dom2 = document.getElementById("showStationIDs");
	var dom3 = document.getElementById("showOrgObjID");
	var dom4 = document.getElementById("showseclevel");

	/*document.getElementById("UserIDs").value = "";
	document.getElementById("StationIDs").value = "";
	document.getElementById("OrgObjID").value = "";
	document.getElementById("minseclevel").value = "";
	document.getElementById("maxseclevel").value = "";*/
	
	switch (this.value) {
	case "1":
		dom1.style.display = "block";
		dom2.style.display = "none";
		dom3.style.display = "none";
		dom4.style.display = "none";
		break;
	case "2":
		dom1.style.display = "none";
		dom2.style.display = "block";
		dom3.style.display = "none";
		dom4.style.display = "none";
		break;
	case "3":
		dom1.style.display = "none";
		dom2.style.display = "none";
		dom3.style.display = "block";
		dom4.style.display = "none";
		break;
	case "4":
		dom1.style.display = "none";
		dom2.style.display = "none";
		dom3.style.display = "none";
		dom4.style.display = "block";
		break;
	}
}

function getBrowser(url, inputname, inputspan, isneed) {
	var id;
    try {
    	id = window.showModalDialog("/base/popupmain.jsp?url=" + url,'','dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
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

function onShowMutiResource(tdname, inputname) {
	var id;
    try {
	    id = window.showModalDialog("/base/popupmain.jsp?url=/humres/base/humresbrowserm.jsp?sqlwhere=hrstatus%3D'4028804c16acfbc00116ccba13802935'&humresidsin=" + document.all(inputname).value,'','dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
    } catch(e) {
		    
    }
	if (id != null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(tdname).innerHTML = id[1];
	    } else {
			document.all(inputname).value = '';
			document.all(tdname).innerHTML = '';
		}
	}
}

function onshowOrgObjID(tdname, inputname){
	var id;
    try {
	    id = window.showModalDialog("/base/refobj/treeviewerBrowser.jsp?id=402880321d600142011d602857ee0004");
    } catch (e) {
        
	}
	if (id != null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(tdname).innerHTML = id[1];
	    } else {
			document.all(inputname).value = '';
			document.all(tdname).innerHTML = '';
		}
	}
}

Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>";//加载...

    var dom = document.getElementById("ShareType");
	dom.onchange = onChangeShareType;
    
	var tb = new Ext.Toolbar({
	    renderTo: "pagemenubar",
	    items: [{
	        text: "<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")%>(S)",//提交
	        key: "s",
	        alt: true,
	        handler: function(){
				switch (parseInt(dom.value)) {
				case 1:
					var v = document.getElementById("UserIDs").value;
					if (v == "") {
				    	alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98001a")%>");//人员不能为空!
				    	return;
			    	} else {
						if (v.indexOf("<%=user.getId()%>") != -1) {
					    	alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98001b")%>");//不能给自己推荐文档!
					    	return;
				    	}
			    	}
					break;
				case 2:
					if (document.getElementById("StationIDs").value == "") {
				    	alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98001c")%>");//岗位不能为空!
				    	return;
			    	}
					break;
				case 3:
					if (document.getElementById("OrgObjID").value == "") {
				    	alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98001d")%>");//部门不能为空!
				    	return;
			    	}
					break;
				case 4:
					if (document.getElementById("minseclevel").value == "") {
				    	alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98001e")%>");//安全级别下限不能为空!
				    	return;
			    	}
					break;
				}
				if (document.getElementById("docbaseIDs").value == "" && document.getElementById("categoryID").value == "") {
			    	alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98001f")%>");//文档和目录不能同时为空!
		    	} else {
		            document.EweaverForm.submit();
		    	}
	        }
	    }]
	});
	
	/*$(document).keydown(function(event){
	    if (event.keyCode == 13) {
	    	document.EweaverForm.submit();
	    }
	});*/
});
</script>
</head>
<body>
	<div id="divSearch" style="height: 180px;">
	<div id="pagemenubar"></div>
	<form id="EweaverForm" name="EweaverForm" action="/ServiceAction/com.eweaver.document.base.servlet.DocPushAction?action=push" method="post">
		<table>
			<thead>
				<tr>
					<th width="10%"></th>
					<th width="*"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<select id="ShareType" name="ShareType" onchange="onChangeShareType()">
							<option value="1" selected><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980020")%></option><!--人员  -->
							<option value="2"><%=labelService.getLabelNameByKeyId("402881e510e569090110e56e72330003")%></option><!-- 岗位 -->
							<option value="3"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%></option><!-- 部门 -->
							<option value="4"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774cceb80008")%></option><!--安全级别  -->
						</select>
					</td>
				</tr>
				<tr id="showUserIDs">
					<td><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980020")%>：</td><!-- 人员 -->
					<td>
						 <span id="showUserIDs">
					        <button type="button" class=Browser style="display: block;" onclick="onShowMutiResource('UserIDsSpan', 'UserIDs')"></button>
					        <input type="hidden" name="UserIDs" id="UserIDs" value="">   
					        <span id="UserIDsSpan"></span>
				         </span>
					</td>
				</tr>
				<tr id="showStationIDs" style="display: none;">
					<td><%=labelService.getLabelNameByKeyId("402881e510e569090110e56e72330003")%>：</td><!-- 岗位 -->
					<td>
						<span id="">
							<button type="button" class=Browser style="display: block;" onclick="javascript:getBrowser('/humres/base/stationlist.jsp?type=browser', 'StationIDs', 'StationIDsSpan', '1');"></button>
							<input type="hidden" name="StationIDs" id="StationIDs" value="">   
							<span id="StationIDsSpan"></span>
				        </span>
					</td>
				</tr>
				<tr id="showOrgObjID" style="display: none;">
					<td><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%>：</td><!-- 部门 -->
					<td>
						<span id="">
							<button type="button" class="Browser" style="display: block;" onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser.jsp?id=402880321d600142011d602857ee0004', 'OrgObjID', 'OrgObjIDSpan', '1');"></button>
							<input type="hidden" name="OrgObjID" id="OrgObjID" value="">
							<span id="OrgObjIDSpan"></span>
						</span>
					</td>
				</tr>
				<tr id="showseclevel" style="display: none;">
					<td><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774cceb80008")%>：</td><!-- 安全级别 -->
					<td>
						<span id="">
							<input type="text" id="minseclevel" name="minseclevel" size="6" value="10">
							--
							<input type="text" id=maxseclevel" name="maxseclevel" size="6" value="">
						</span>
					</td>
				</tr>
				<tr>
					<td><%=labelService.getLabelNameByKeyId("402881e90c63546b010c638e0ea0002f")%>：</td><!-- 文档 -->
					<td>
						<span id="">
							<button type="button" class=Browser onclick="javascript:getBrowser('/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browserm=1&reportid=402880321ce00d9c011ce019ae0e0002&keyfield=id', 'docbaseIDs', 'docbaseIDsSpan', '1');"></button>
							<input type="hidden" name="docbaseIDs" id="docbaseIDs" value="">
							<span id="docbaseIDsSpan"></span>
				        </span>
					</td>
				</tr>
				<tr>
					<td><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980021")%>：</td><!--目录 -->
					<td>
						<span id="">
							<button type="button" class=Browser onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser.jsp?id=4028bc5c1bba3f4a011bba4216110002&rootId=40288148117d0ddc01117d8c36e00dd4&optType=0', 'categoryID', 'categoryIDSpan', '1');"></button>
							<input type="hidden" name="categoryID" id="categoryID" value="">
							<span id="categoryIDSpan"></span>
				        </span>
					</td>
				</tr>
				<tr>
					<td valign="top"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980022")%>：</td><!--推荐说明  -->
					<td>
						<textarea id="reason" name="reason" rows="3" cols="100"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</body>
</html>
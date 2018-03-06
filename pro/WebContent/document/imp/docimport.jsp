<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<html>
	<head>
		<title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980040")%></title><!-- 文档批量导入 -->
		<script type="text/javascript" src="/js/sack.js"></script>
	</head>
	<body>
		<div style="border: solid 1px #ccc;font-weight: bold;width: 100%;padding: 2px;"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980040")%></div><!-- 文档批量导入 -->
		<div >
			<button type="button" onclick="importDoc();"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190071")%></button><!-- 导入 -->
		</div>
		<form action="" name="EweaverForm" id="EweaverForm" method="post">
			<table border="1" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tr>
					<td>
						<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980041")%><!-- 文件路径 -->
					</td>
					<td>
						<input readonly type=text style="WIDTH: 80%;" name="addedFile"
							id="addedFile">
						<img id="addfileCheck" src="/images/base/checkinput.gif"/>
						<button type="button" onclick="javascript:addFile();">
							<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980042")%><!-- 选择文件 -->
						</button>
					</td>
				</tr>
				<TR>
					<TD noWrap>
						<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890001")%><!-- 文档作者 -->
					</TD>
					<TD >
						<button type=button class=Browser name="button_creator"
							onclick="javascript:getrefobj('creator','creatorspan','402881e70bc70ed1010bc75e0361000f','','/humres/base/humresview.jsp?id=','0');"></button>
						<input type="hidden" name="creator" id="creator" value=""
							style="width: 80%">
						<span id="creatorspan" name="creatorspan"></span>
					</TD>
				</TR>
				<TR>
					<TD noWrap>
						<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda6ab3b001b")%><!-- 文档分类 -->
					</TD>
					<TD >
						<button type=button class=Browser name="button_categoryids"
							onclick="javascript:getrefobj('categoryids','categoryidsspan','4028819b124662b301125662b73603e7','','','1');"></button>
						<input type="hidden" name="categoryids" value=""
							style="width: 80%">
						<span id="categoryidsspan" name="categoryidsspan"><img src="/images/base/checkinput.gif"/> </span>
					</TD>
				</TR>

				<tr>
					<td></td>
					<td></td>
				</tr>
			</table>
		</form>
		<br>
		<table id="fileTable" border="1" cellpadding="0" cellspacing="0" style="display: ">
		<caption style="font-weight: bold;text-align: left"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980043")%></caption><!-- 导入进度 -->
		<tr style="background-color: #eee">
			<td width="30px" nowrap="nowrap"><%=labelService.getLabelNameByKeyId("402883d934c095220134c09523720000")%></td><!-- 序号 -->
			<td width="80%"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003c")%></td><!-- 文件名 -->
			<td width="20%"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980044")%></td><!-- 导入状态 -->
		</tr>
		</table>
	</body>
<script type="text/javascript">
function addFile(){
    var url = '/document/imp/filebrowser.jsp';
    openWin(url, 600, 800);
}

function openWin(url, height, width){
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2 - 30;
    window.open(url, "", "height=" + height + ", width=" + width + ", top=" + top + ", left=" + left + ", toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}
function getrefobj(inputname,inputspan,refid,viewurl,isneed){
    if(inputname.substring(3,(inputname.length-6))){
        if(document.getElementById(inputname.substring(3,(inputname.length-6)))){
 			document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
        }
    }
	var id;
	try{
		id=openDialog(contextPath+'/base/popupmain.jsp?url='+contextPath+'/base/refobj/baseobjbrowser.jsp?id='+refid);
	}catch(e){}
	if (id!=null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
		}else{
			document.all(inputname).value = '';
			if (isneed=='0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
			}
        }
     }
}
function importDoc(){
	if(!document.getElementById("addedFile").value){
		alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980045")%>");//目录路径未填写！
		return;
	}
	if(!document.getElementById("categoryids").value){
		alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980046")%>");//文档分类未填写！
		return;
	}
	listFile();
}
var ajax = new sack();
function $(id){
	return document.getElementById(id);
}
function listFile(){
	ajax.resetData();
	ajax.setVar("action", "listFile");
	ajax.setVar("filePath", $("addedFile").value);
	ajax.requestURL = "/ServiceAction/com.eweaver.document.imp.DocImportAction";
	ajax.method = "GET";
	ajax.onCompletion = function(){
		var xml = ajax.responseXML;
		var files = xml.getElementsByTagName("files")[0].childNodes;
		var table = $("fileTable");
		for(var i=0;i<files.length;i++){
			var fileName = files[i].text;
			var row = table.insertRow();
			row.style.height="25px";
			var cell1 = row.insertCell();
			cell1.innerText=i+1;
			var cell2 = row.insertCell();
			cell2.innerText =fileName;
			var cell3 = row.insertCell();
			cell3.innerText ="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980047")%>";//等待
			cell3.style.color="#ccc";
		}
		doImport(table.rows[1]);
	};
	ajax.runAJAX();
}
function doImport(row){
	var nextRow = row.nextSibling;
	var fileName = row.cells[1].innerText;
	ajax.resetData();
	ajax.setVar("action", "import");
	ajax.setVar("fileName", fileName);
	ajax.setVar("categoryids", $("categoryids").value);
	ajax.setVar("creator", $("creator").value);
	ajax.requestURL = "/ServiceAction/com.eweaver.document.imp.DocImportAction";
	ajax.method = "GET";
	ajax.onCompletion = function(){
		var xml = ajax.responseXML;
		var status = xml.getElementsByTagName("status")[0].text;
		var color = xml.getElementsByTagName("color")[0].text;
		row.cells[2].style.color=color;
		row.cells[2].innerText=status;
		if(nextRow){
			doImport(nextRow);
		}else{
			alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980048")%>");//导入完成
			$("addedFile").value="";
			$("addfileCheck").style.display="";
		}
	};
	ajax.runAJAX();
}
</script>
</html>

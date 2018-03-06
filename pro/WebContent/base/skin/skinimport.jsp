<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
	var tb;
	Ext.onReady(function(){
		Ext.QuickTips.init();
		tb = new Ext.Toolbar();
	 	tb.render('pagemenubar');
	 	addBtn(tb,'提交','S','accept',function(){onSubmit();});
	 	addBtn(tb,'关闭','C','exclamation',function(){if(parent.closeSkinDialog){parent.closeSkinDialog();}});
	});
	
	function getImportModeVal(){
		var importModes = document.getElementsByName("importMode");
		var checkedV;
		for(var i = 0; i < importModes.length; i++){
			if(importModes[i].checked){
				checkedV = importModes[i].value;
				break;
			}
		}
		return checkedV;
	}
	
	function controlOverrideSkinTRShowOrHide(){
		var checkedV = getImportModeVal();
		var overrideSkinTR = document.getElementById("overrideSkinTR");
		if(checkedV == "1"){
			overrideSkinTR.style.display = "block";
		}else{
			overrideSkinTR.style.display = "none";
		}
	}
</script>
</head>
<body style="overflow: hidden;">
  <div id="pagemenubar"></div>
  <form action="/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=importSkin" method="post" id="SkinForm" enctype="multipart/form-data">
	  <table style="margin-top: 10px;line-height: 30px;">
	  	<colgroup>
	  		<col width="120px"/>
	  	</colgroup>
		<tr>
			<td class="FieldName">请上传皮肤文件：</td>
			<td class="FieldValue">
				<input type="file" id="skinfile" name="skinfile" onchange="checkInput('skinfile','skinfilespan')"/>
				<span id="skinfilespan" name="skinfilespan" style="color: red"/>
					<img src="/images/base/checkinput.gif"/>
				</span>
			</td>
		</tr>
		<tr>
			<td class="FieldName">请选择导入模式：</td>
			<td class="FieldValue">
				<input type="radio" name="importMode" value="0" checked="checked" onclick="javascript:controlOverrideSkinTRShowOrHide();">创建新的皮肤
				<input type="radio" name="importMode" value="1" onclick="javascript:controlOverrideSkinTRShowOrHide();">覆盖现有的皮肤
			</td>
		</tr>
		<tr id="overrideSkinTR" style="display: none;">
			<td class="FieldName">请选择要覆盖的皮肤：</td>
			<td class="FieldValue">
				<%
					List<Skin> skinList = skinService.getAllSkin();
				%>
				<select id="overrideSkin" name="overrideSkin" onchange="checkInput('overrideSkin','overrideSkinspan')">
					<option></option>
					<%	for(Skin skin : skinList){ %>
							<option value="<%=skin.getId() %>">
								<%=skin.getObjname() %>
								<%if(skin.getIsDefault() == 1){%>
									[默认皮肤]	
								<%} %>
								<%if(!skin.isEnabled()){%>
									[已禁用]	
								<%} %>
							</option>
					<%	} %>
				</select>
				<span id="overrideSkinspan" name="overrideSkinspan" style="color: red"/>
					<img src="/images/base/checkinput.gif"/>
				</span>
			</td>
		</tr>
	  </table>
  </form>
</body>
<script type="text/javascript">
	function onSubmit(){
		var submitFlag = true;
		var skinfile = document.getElementById("skinfile");
		if(skinfile.value == ""){
			document.getElementById("skinfilespan").innerHTML = "请上传皮肤文件";
			submitFlag = false;
		}else{
			var skinfileSuffix = skinfile.value.substring(skinfile.value.lastIndexOf("."));
			if(skinfileSuffix != '.zip' && skinfileSuffix != '.ZIP' && skinfileSuffix != '.rar' && skinfileSuffix != '.RAR'){
				document.getElementById("skinfilespan").innerHTML = "请上传一个皮肤压缩文件";
				submitFlag = false;
			}
		}
		
		var importModeVal = getImportModeVal();
		if(importModeVal == "1"){
			var overrideSkin = document.getElementById("overrideSkin");
			if(overrideSkin.value == ""){
				document.getElementById("overrideSkinspan").innerHTML = "请选择要覆盖的皮肤";
				submitFlag = false;
			}
		}
		if(submitFlag){
			var SkinForm = document.getElementById("SkinForm");
			SkinForm.submit();
			tb.disable();
		}
	}
</script>
</html>

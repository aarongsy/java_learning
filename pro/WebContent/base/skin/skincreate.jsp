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
</script>
</head>
<body style="overflow: hidden;">
  <div id="pagemenubar"></div>
  <form action="/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=createSkin" method="post" id="SkinForm" enctype="multipart/form-data">
	  <table style="margin-top: 15px;line-height: 30px;">
	  	<tr>
			<td class="FieldName" nowrap>皮肤名称：</td>
			<td nowrap>
				<input type="text" id="objname" name="objname" class="inputstyle" onchange="checkInput('objname','objnamespan')"/>
				<span id="objnamespan" name="objnamespan" style="color: red"/>
					<img src="/images/base/checkinput.gif"/>
				</span>
			</td>
		</tr>
		<tr>
			<td class="FieldName" nowrap width="80px;">预览效果图：</td>
			<td nowrap>
				<input type="file" id="previewPicPath" name="previewPicPath" onchange="checkInput('previewPicPath','previewPicPathspan')"/>
				<span id="previewPicPathspan" name="previewPicPathspan" style="color: red"/>
					<img src="/images/base/checkinput.gif"/>
				</span>
			</td>
		</tr>
		<tr>
			<td class="FieldName" nowrap width="80px;">皮肤类型：</td>
			<td nowrap>
				<select name="skinType" id="skinType" onchange="checkInput('skinType','skinTypespan')">
					<option value=""></option>
					<option value="0">软件模式皮肤</option>
					<option value="1">网站模式皮肤</option>
				</select>
				<span id="skinTypespan" name="skinTypespan" style="color: red"/>
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
		var objname = document.getElementById("objname");
		var previewPicPath = document.getElementById("previewPicPath");
		var skinType = document.getElementById("skinType");
		if(objname.value == ""){
			document.getElementById("objnamespan").innerHTML = "请输入皮肤名称";
			submitFlag = false;
		}
		if(previewPicPath.value == ""){
			document.getElementById("previewPicPathspan").innerHTML = "请选择效果图";
			submitFlag = false;
		}
		if(skinType.value == ""){
			document.getElementById("skinTypespan").innerHTML = "请选择皮肤类型";
			submitFlag = false;
		}
		if(submitFlag){
			var SkinForm = document.getElementById("SkinForm");
			SkinForm.submit();
			tb.disable();
		}
	}
</script>
</html>

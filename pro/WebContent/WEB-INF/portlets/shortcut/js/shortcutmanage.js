$(function(){
	$("#levelMenu ul li a").first().click();
	loadSelectedElement();
	bindAjaxSubmitWithManualEnterForm();
});
function openChildMenuDiv(levelMenuId){
	//改变左侧一级菜单的背景颜色
	$("#levelMenu ul li a p").css("background-color","");
	$("#levelMenu_" + levelMenuId + " p").css("background-color","#DFDFDF");
	
	//改变右侧子菜单的显示(隐藏)
	$("#childMenu div").hide();
	$("#childMenu_" + levelMenuId).show();
}
function loadSelectedElement(){
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.shortcut.servlet.ShortCutAction?action=getCurrentUserShortCut"),
	 	data: "{}",
	 	async: false,
	 	success: function(responseText, textStatus) 
	 	{
	 		//加载之前清空之前已存在的数据(如果有的话)
	 		$("#selectedElement div ul *").remove();
	 		
	 		var shortCutDatas = eval("(" + responseText + ")");
	 		for(var i = 0; i < shortCutDatas.length; i++){
	 			var shortCutData = shortCutDatas[i];
	 			createSelectedElementHtml(shortCutData["id"],shortCutData["dataSourceId"],shortCutData["dataSourceType"],shortCutData["data"]["imgpath"],shortCutData["data"]["objname"]);
	 			if(shortCutData["dataSourceType"] == 0){	//如果是菜单数据,选中checkbox
	 				$("#cb_" + shortCutData["dataSourceId"]).attr("checked",true);
	 			}
	 		}
	 		if(shortCutDatas.length == 0){	//无数据(默认使用tab页作为页面打开方式)
	 			$("input[name='openMode']").val([2]);
	 		}else{	//根据数据为页面打开方式赋值
	 			$("input[name='openMode']").val([shortCutDatas[0]["openMode"]]);
	 		}
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}
function createOrDeleteSelectedElement(cb, dataSourceId, dataSourceImgPath, dataSourceObjName){
	if(cb.checked){
		createSelectedElement(dataSourceId,dataSourceImgPath,dataSourceObjName, '0');
	}else{
		deleteSelectedElement(dataSourceId, '0');
	}
}
function createSelectedElement(dataSourceId, dataSourceImgPath, dataSourceObjName, dataSourceType){
	var param = "&dataSourceType="+dataSourceType + "&dataSourceId=" + dataSourceId + "&openMode=" + getCurrentOpenModeVal();
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.shortcut.servlet.ShortCutAction?action=createShortCut" + param),
	 	data: "{}",
	 	async: false,
	 	success: function(responseText, textStatus) 
	 	{
	 		var datas = responseText.split(":");
	 		if(datas[0] == "success"){
	 			createSelectedElementHtml(datas[1], dataSourceId, dataSourceType, dataSourceImgPath, dataSourceObjName);
	 		}else{	//失败
	 			if(dataSourceType == '0'){	//菜单
	 				$("#cb_" + dataSourceId).attr("checked",false);	//取消选中
	 			}
	 			alert("error:\n" + responseText);
	 		}
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}
function createSelectedElementHtml(shortcutId, dataSourceId, dataSourceType, dataSourceImgPath, dataSourceObjName){
	var selectedElementHtml = 
	  "<li id=\"selElement_"+dataSourceId+"\">" + 
	  	"<input type=\"hidden\" name=\"shortcutId\" value=\""+shortcutId+"\"/>" +
		"<span class=\"icon\"><img src=\""+dataSourceImgPath+"\" align=\"middle\"/></span>" +
		"<span class=\"text\">"+dataSourceObjName+"</span>" +
		"<span class=\"handler\"><img src=\"/images/iconDelete.gif\" align=\"middle\" onclick=\"confirmDeleteSelectedElement('"+dataSourceId+"','"+dataSourceType+"')\" title=\"删除\"/></span>" +
	  "</li>";
	$("#selectedElement div ul").append(selectedElementHtml);
}
function confirmDeleteSelectedElement(dataSourceId, dataSourceType){	//这个删除加一个确认操作(通过菜单勾选的删除不加,勾选弹出确认会很让人烦的)
	if(confirm("您确定要删除吗?")){
		deleteSelectedElement(dataSourceId, dataSourceType);
	}
}
function deleteSelectedElement(dataSourceId, dataSourceType){
	var shortcutId = $("#selElement_" + dataSourceId + " input:hidden").first().val();
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.shortcut.servlet.ShortCutAction?action=deleteShortCut&id=" + shortcutId),
	 	data: "{}",
	 	async: false,
	 	success: function(responseText, textStatus) 
	 	{
	 		if(responseText == "success"){
	 			$("#selElement_" + dataSourceId).remove();
				$("#cb_" + dataSourceId).attr("checked",false);
	 		}else{	//失败
	 			if(dataSourceType == '0'){	//菜单
	 				$("#cb_" + dataSourceId).attr("checked",true);	//继续选中
	 			}
	 			alert("error:\n" + responseText);
	 		}
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}
function getCurrentOpenModeVal(){
	return $("input[name='openMode'][checked]").val();
}
function modifyOpenMode(){
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.shortcut.servlet.ShortCutAction?action=modifyOpenMode&openMode=" + getCurrentOpenModeVal()),
	 	data: "{}",
	 	async: false,
	 	success: function(responseText, textStatus) 
	 	{
	 		if(responseText == "success"){
	 			//暂时不做操作
	 		}else{	//失败
	 			alert("error:\n" + responseText);
	 		}
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}
function createManualEnterDialog(){
	$("#manualEnter").dialog({
		title: '手动输入',
		width: 350,
		height:300,
		buttons: {
			"完成": function() {
				submitManualEnterForm();
			}
		}
	});
}
function bindAjaxSubmitWithManualEnterForm(){
	$("#manualEnterForm").ajaxForm({
		beforeSubmit:function(){
			var flag = true;
			var tipMessage = "";
			if($('#customData_objname').val() == ''){
				tipMessage += "请填写入口名称\n";
				flag = false;
			}
			if($('#customData_picPath').val() == ''){
				tipMessage += "请选择对应图片\n";
				flag = false;
			}
			if($('#customData_openUrl').val() == ''){
				tipMessage += "请填写链接路径";
				flag = false;
			}
			if(!flag){
				tipMessage = "无法提交表单,您需要完成以下输入:\n" + tipMessage + "\n[如果您只是想关闭窗口,请点击右上角的关闭图标关闭此窗口]";
				alert(tipMessage);
			}
			return flag;
		},
        success: function(responseText, statusText, xhr, $form){
        	if(responseText == "success"){
        		resetManualEnterForm();	//重置表单数据
        		$("#manualEnter").dialog("close");	//关闭窗体
        		loadSelectedElement();	//重新加载已选择列表
        	}else{
        		alert("error:\n" + responseText);
        	}
        }
	}); 
}
function submitManualEnterForm(){
	var action = "/ServiceAction/com.eweaver.base.shortcut.servlet.ShortCutAction?action=createShortCutWithCustomData&openMode=" + getCurrentOpenModeVal();
	$("#manualEnterForm").attr("action",action);
	$("#manualEnterForm").submit();
}
function resetManualEnterForm(){
	$('#customData_objname').val("");
	$('#customData_openUrl').val("");
	var file = $('#customData_picPath');
	file.after(file.clone().val(""));
	file.remove();   
	
	$('#customData_objnamespan').html("<img src=\"/images/base/checkinput.gif\"/>");
	$('#customData_openUrlspan').html("<img src=\"/images/base/checkinput.gif\"/>");
	$('#customData_picPathspan').html("<img src=\"/images/base/checkinput.gif\"/>");
}
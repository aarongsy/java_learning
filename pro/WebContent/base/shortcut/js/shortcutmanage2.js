$(function(){
	Ext.QuickTips.init();
	var tb = new Ext.Toolbar();
	tb.render('pagemenubar');
	addBtn(tb,'确定','O','accept',function(){submitShortcutForm();});
	
	$("#levelMenu ul li a").first().click();
});
function submitShortcutForm(){
	$("#shortcutForm").submit();
}
function openChildMenuDiv(levelMenuId){
	//改变左侧一级菜单的背景颜色
	$("#levelMenu ul li a p").css("background-color","");
	$("#levelMenu_" + levelMenuId + " p").css("background-color","#DFDFDF");
	
	//改变右侧子菜单的显示(隐藏)
	$("#childMenu div").hide();
	$("#childMenu_" + levelMenuId).show();
}
function createOrDeleteSelectedElement(cb, shortcutId, shortcutImgPath, shortcutName, shortcutUrl){
	if(cb.checked){
		var shortcutOpenMode = '2';//默认打开方式为tab页
		var shortcutDsporder = getMaxDsporderWidthSelected() + 1;
		createSelectedElement(shortcutId, shortcutImgPath, shortcutName, shortcutUrl, shortcutOpenMode, shortcutDsporder);
	}else{
		deleteSelectedElement(shortcutId);
	}
}
function createSelectedElement(shortcutId, shortcutImgPath, shortcutName, shortcutUrl, shortcutOpenMode, shortcutDsporder){
	var selectedElementHtml = 
	  "<li id=\"selElement_"+shortcutId+"\">" + 
	  	createSelectedElementInnerHtml(shortcutId, shortcutImgPath, shortcutName, shortcutUrl, shortcutOpenMode, shortcutDsporder) + 
	  "</li>";
	$("#selectedElement div ul").append(selectedElementHtml);
}
function createSelectedElementInnerHtml(shortcutId, shortcutImgPath, shortcutName, shortcutUrl,shortcutOpenMode,shortcutDsporder){
	var selectedElementInnerHtml = 
	  	"<input type=\"hidden\" name=\"shortcutId\" value=\""+shortcutId+"\"/>" +
	  	"<input type=\"hidden\" name=\"shortcutImgPath\" value=\""+shortcutImgPath+"\"/>" +
	  	"<input type=\"hidden\" name=\"shortcutName\" value=\""+shortcutName+"\"/>" +
	  	"<input type=\"hidden\" name=\"shortcutUrl\" value=\""+shortcutUrl+"\"/>" +
	  	"<input type=\"hidden\" name=\"shortcutOpenMode\" value=\""+shortcutOpenMode+"\"/>" +
	  	"<input type=\"hidden\" name=\"shortcutDsporder\" value=\""+shortcutDsporder+"\"/>" +
		"<span class=\"icon\"><img src=\""+shortcutImgPath+"\" align=\"middle\"/></span>" +
		"<span class=\"text\">"+decodeURIComponent(shortcutName)+"</span>" +
		"<span class=\"handler\">" +
		"<img src=\"/images/application/fam/pencil.png\" align=\"middle\" onclick=\"editSelectedElement('"+shortcutId+"','"+shortcutImgPath+"','"+shortcutName.ReplaceAll("'", "\\'")+"','"+shortcutUrl+"','"+shortcutOpenMode+"',"+shortcutDsporder+")\" title=\"编辑\"/>" +
		"<img src=\"/images/iconDelete.gif\" align=\"middle\" onclick=\"confirmDeleteSelectedElement('"+shortcutId+"')\" title=\"删除\"/>" +
		"</span>";
	return selectedElementInnerHtml;
}
function sortSelectedElement(){
	var array = new Array();
	var $selectedUL = $("#selectedElement div ul");
	$selectedUL.children("li").each(function(index){
		var $selectedLI = $(this);
		var $shortcutId = $selectedLI.find("input[type='hidden'][name='shortcutId']");
		var $shortcutDsporder = $selectedLI.find("input[type='hidden'][name='shortcutDsporder']");
		array.push({"shortcutId":$shortcutId.val(),"shortcutDsporder":$shortcutDsporder.val()});
	});
	
	array.sort(function(a, b){
		return parseInt(a.shortcutDsporder) - parseInt(b.shortcutDsporder);
	});
	
	var $selectedULClone = $selectedUL.clone(true);
	
	$selectedUL.find("*").remove();
	
	for(var i = 0; i < array.length; i++){
		var shortcutId = array[i].shortcutId;
		$selectedUL.append($("#selElement_"+shortcutId, $selectedULClone));
	}
	
	$selectedULClone.remove();
}
function getMaxDsporderWidthSelected(){
	var maxDsporder = 0;
	var $selectedUL = $("#selectedElement div ul");
	$selectedUL.children("li").each(function(index){
		var $selectedLI = $(this);
		var $shortcutDsporder = $selectedLI.find("input[type='hidden'][name='shortcutDsporder']");
		var shortcutDsporder = parseInt($shortcutDsporder.val());
		if(maxDsporder < shortcutDsporder){
			maxDsporder = shortcutDsporder;
		}
	});
	return maxDsporder;
}
function confirmDeleteSelectedElement(shortcutId){	//这个删除加一个确认操作(通过菜单勾选的删除不加,勾选弹出确认会很让人烦的)
	deleteSelectedElement(shortcutId);
}
function deleteSelectedElement(shortcutId){
	$("#selElement_" + shortcutId).remove();
	$("#cb_" + shortcutId).attr("checked",false);
}
function getCurrentOpenModeVal(){
	return $("input[name='openMode'][checked]").val();
}
function editSelectedElement(shortcutId, shortcutImgPath, shortcutName, shortcutUrl ,shortcutOpenMode, shortcutDsporder){
	$('#customData_id').val(shortcutId);
	$('#customData_objname').val(decodeURIComponent(shortcutName));
	$('#customData_openUrl').val(shortcutUrl);
	$('#customData_picPath').val(shortcutImgPath);
	$("input[name='customData_openMode'][value='"+shortcutOpenMode+"']").attr("checked",'checked');
	$('#customData_dsporder').val(shortcutDsporder);
	$('#theType').val("1");	
	$('#customData_objnamespan').html("");
	$('#customData_openUrlspan').html("");
	$('#customData_picPathspan').html("");
	$('#customData_dsporderspan').html("");
	$('#customData_languagespan').html("");
	
	var shortcutIdsOfHidden = $("#shortcutIdsOfHidden").val();
	var isModify = shortcutIdsOfHidden.indexOf(shortcutId) != -1;
	if(isModify){	//快速入口元素已创建到数据库中了
		labelDialogWidth = 500;	//modify in main.js
		var portletId = $("#portletId").val();
		var keyword = portletId + "|" + "shortcut_"+shortcutId;
		
		var labelCount = jQuery.ajax({
			url: "/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelCountWithSync&keyword=shortcut_"+shortcutId,
			async: false,
			cache: false
		}).responseText;
	
	    labelCount = parseInt(labelCount);
	    
	    var labelImgPath = "/images/base/label_empty.jpg";
	    if(labelCount > 1){
	    	labelImgPath = "/images/base/label.gif";
	    }
				    
		var languageLabelHtml = "<img align='middle' src='"+labelImgPath+"' title='多语言标签' style='margin-left:4px;cursor: pointer;' onclick=\"openLabel('"+keyword+"','Shortcut');\">";
		$('#customData_languagespan').html(languageLabelHtml);
	}
	createManualEnterDialog();
}

function createManualEnterShortcut(){
	$('#theType').val("0");	
	resetManualEnterForm();
	var maxDsporder = getMaxDsporderWidthSelected() + 1;
	$('#customData_dsporder').val(maxDsporder);
	$('#customData_dsporderspan').html("");
	createManualEnterDialog();
}

function createManualEnterDialog(){
	$("#manualEnter").dialog({
		title: '手动输入',
		width: 350,
		height:320,
		buttons: {
			"完成": function() {
				createOrEditSelectedElement();
			}
		}
	});
}
function validateEnter(){
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
		tipMessage += "请填写链接路径\n";
		flag = false;
	}
	if($('#customData_dsporder').val() == ''){
		tipMessage += "请填写显示顺序";
		flag = false;
	}else{
		var numberReg = /^\d+$/;
		if(!numberReg.test($('#customData_dsporder').val())){
			tipMessage += "显示顺序必须是数字,并且大于等于0";
			flag = false;
		}
	}
	if(!flag){
		tipMessage = "无法完成操作,您需要完成以下输入:\n" + tipMessage + "\n[如果您只是想关闭窗口,请点击右上角的关闭图标关闭此窗口]";
		alert(tipMessage);
	}
	return flag;
}
function createOrEditSelectedElement(){
	if(validateEnter()){
		if($('#theType').val() == "0"){//create
			var shortcutId = "custom_";	//用户手动输入的快捷方式
			for(var i = 0; i < 32; i++){
				shortcutId += Math.floor(Math.random()*10); 
			}
			var shortcutOpenMode = $("input[name='customData_openMode']:checked").val();
			createSelectedElement(shortcutId, $('#customData_picPath').val(), $('#customData_objname').val(), $('#customData_openUrl').val(), shortcutOpenMode, $('#customData_dsporder').val());
		}else if($('#theType').val() == "1"){//edit
			var shortcutId = $('#customData_id').val();
			var shortcutName = $('#customData_objname').val();
			var shortcutUrl = $('#customData_openUrl').val();
			var shortcutImgPath = $('#customData_picPath').val();
			var shortcutOpenMode = $("input[name='customData_openMode']:checked").val();
			var shortcutDsporder = $('#customData_dsporder').val();
			$("#selElement_" + shortcutId).html(createSelectedElementInnerHtml(shortcutId, shortcutImgPath, encodeURIComponent(shortcutName), shortcutUrl, shortcutOpenMode, shortcutDsporder));
		}
		sortSelectedElement();
		resetManualEnterForm();
		$("#manualEnter").dialog("close");
	}
}
function resetManualEnterForm(){
	$('#customData_id').val("");
	$('#customData_objname').val("");
	$('#customData_openUrl').val("");
	$('#customData_picPath').val("");
	$("input[name='customData_openMode'][value='2']").attr("checked",'checked');
	$('#customData_dsporder').val("");
	$('#customData_objnamespan').html("<img src=\"/images/base/checkinput.gif\"/>");
	$('#customData_openUrlspan').html("<img src=\"/images/base/checkinput.gif\"/>");
	$('#customData_picPathspan').html("<img src=\"/images/base/checkinput.gif\"/>");
	$('#customData_dsporderspan').html("<img src=\"/images/base/checkinput.gif\"/>");
	$('#customData_languagespan').html("");
}
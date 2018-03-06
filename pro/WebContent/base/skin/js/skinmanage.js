$(function(){
	Ext.QuickTips.init();
	var tb = new Ext.Toolbar();
	tb.render('pagemenubar');
	addBtn(tb,'新增','A','add',function(){addSkin();});
	addBtn(tb,'保存','S','accept',function(){modifySkin();});
	addBtn(tb,'导入皮肤','I','tb_import',function(){importSkin();});
	addBtn(tb,'导出皮肤','E','tb_export',function(){exportSkin();});
	addBtn(tb,'删除','D','delete',function(){deleteSkin();});
	
	$("#cssData").tabs();
	
	$("#SkinForm").ajaxForm({
			beforeSubmit:function(){
				var flag = true;
				$('#objnamespan').html("");
				$('#objnamespan').css('display','none');
				if($('#objname').val() == ''){
					$('#objnamespan').css('display','inline');
					$('#objnamespan').html("请填写样式名称");
					flag = false;
				}
				var $isDefaultObj = $("input[type='radio'][name='isDefault']:checked");
				if($isDefaultObj.length == 0){
					$isDefaultObj = $("#isDefault");
				}
				$('#isEnabledSpan').html("");
				$('#isEnabledSpan').hide();
				if($isDefaultObj.val() == "1"){
					var $isEnabledObj = $("input[type='radio'][name='isEnabled']:checked");
					if($isEnabledObj.val() == "0"){
						$('#isEnabledSpan').html("默认的皮肤不能被设置为禁用,请更正!");
						$('#isEnabledSpan').show();
						flag = false;
					}
				}
				return flag;
			},
	        success: function(responseText, statusText, xhr, $form){
	        	if(responseText == "success"){
	        		loadAllSkinInfo($("#id").val());
	        		if(top.pop){
						top.pop("<span>保存成功！<span>");
					}else{
						alert("保存成功！");
					}
	        	}else{
	        		alert("error:\n" + responseText);
	        	}
	        }
	}); 
	loadAllSkinInfo();
	
	$("#editMode").bind("click", changeEditMode);
	
	var bodyWidth = $(document.body).width();
	var skinListWidth = $('#skinList').outerWidth(true);
	var skinDataWidth = bodyWidth - skinListWidth - 20;
	$('#skinData').width(skinDataWidth);
	$('#cssData').width(skinDataWidth - 40);
	$('#cssData div textarea').width(skinDataWidth - 40);
});
var isMaxEditMode = false;
function changeEditMode(){
	if(!isMaxEditMode){
		var w = $('#skinList').outerWidth(true) + $('#skinData').outerWidth(true) - 12;
		$("#cssData").css({
			'position' : 'absolute',
			'top' : '5px',
			'left' : '0px',
			'margin' : '0px',
			'margin-left' : '10px',
			'width' : w + 'px',
			'height' : '478px'
		});
		$("#cssData div textarea").css({
			'width' : w + 'px',
			'height' : '443px'
		});
		$("#editMode").html("恢复正常");
		isMaxEditMode = true;
	}else{
		var w = $('#skinData').width() - 40;
		$("#cssData").css({
			'position' : 'relative',
			'margin' : '15px',
			'width' : w + 'px',
			'height' : '382px'
		});
		$("#cssData div textarea").css({
			'width' : w + 'px',
			'height' : '347px'
		});
		$("#editMode").html("最大化编辑");
		isMaxEditMode = false;
	}
}
function addSkin(){
	openSkinDialog('/base/skin/skincreate.jsp','新增皮肤',400,200);
}

function colseSkinDialogForAdd(checkedSkinId){
	closeSkinDialog();
	loadAllSkinInfo(checkedSkinId);
}
function modifySkin(){
	$("#SkinForm").submit();
}
function importSkin(){
	openSkinDialog('/base/skin/skinimport.jsp','导入皮肤',480,180);
}
function colseSkinDialogForImport(checkedSkinId){
	closeSkinDialog();
	loadAllSkinInfo(checkedSkinId);
}
function exportSkin(){
	if($("#id").val() == ''){
		alert("请选择一种皮肤导出");
		return;
	}
	if(confirm("您确定要导出皮肤 ["+ $("#objname").val() + "] 吗?")){
		location.href = "/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=exportSkin&id=" + $("#id").val();
	}
}
function deleteSkin(){
	if($("#isSystem").val() == '1'){
		alert("系统皮肤不能删除");
	}else if($("#isDefault").val() == '1'){
		alert("默认皮肤不能删除");
	}else if($("#basePath").val().indexOf("/css/skins/syscomes_skin") != -1){
		alert("系统自带的皮肤不能删除");
	}else{
		if(confirm("您确定要删除皮肤 ["+ $("#objname").val() + "] 吗?")){
			$.ajax({
			 	type: "POST",
			 	contentType: "application/json",
			 	url: encodeURI("/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=deleteSkin&id=" + $("#id").val()),
			 	data: "{}",
			 	async: false,
			 	success: function(responseText, textStatus) 
			 	{
			 		if(responseText == "success"){
		        		loadAllSkinInfo();
		        		if(top.pop){
							top.pop("<span>删除成功！<span>");
						}else{
							alert("删除成功！");
						}
		        	}else{
		        		alert("error:\n" + responseText);
		        	}
			 	},
			 	error: function (XMLHttpRequest, textStatus, errorThrown) {
				    alert(errorThrown);
				}
			});
		}
	}
}
function loadAllSkinInfo(checkedSkinId){
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=getAllSkinWithJson"),
	 	data: "{}",
	 	async: false,
	 	success: function(data, textStatus) 
	 	{
	 		var allSkin = eval("(" + data + ")");
	 		var dataListUL = $('#skinList .content ul');
	 		var html = "";
	 		for(var i = 0; i < allSkin.length; i++){
	 			var defalutSkinHtml = "";
	 			if(allSkin[i]["isDefault"] == 1){
	 				defalutSkinHtml = "<span class=\"default\">[ 默认皮肤 ]</span>";
	 			}
	 			var className = "website";
	 			if(allSkin[i]["skinType"] == '0'){
	 				className = "software";
	 			}
	 			html += "<li isEnabled=\""+allSkin[i]["isEnabled"]+"\"><a id=\"list"+allSkin[i]["id"]+"\" onclick=\"loadSkinInfo('"+allSkin[i]["id"]+"')\">" +
								"<p class=\""+className+"\">" +
	  								"<span class=\"previewpic\"><img src=\""+allSkin[i]["previewPicPath"]+"\" align=\"center\"/></span>" +
	  								"<span class=\"skinName\">"+allSkin[i]["objname"]+"</span>" + 
	  								defalutSkinHtml + 
								"</p>" +
							"</a>" +
						"</li>";
	 		}
	 		dataListUL.html(html);
	 		if(checkedSkinId){	//选中指定的皮肤
	 			var beCheckedSkin = $('#list' + checkedSkinId);
	 			var isHideUnEnabledSKin = document.getElementById("isHideUnEnabledSKin");
	 			if(isHideUnEnabledSKin.checked){
	 				if(beCheckedSkin.parent().attr("isEnabled") == "0"){
	 					//因为默认的皮肤不能被设置为禁用,那么在列表中总有一个皮肤是启用的
	 					var $enabledSkinListObj = $("#skinList .content ul li[isEnabled='1']");
	 					$enabledSkinListObj.first().find("a").click();
	 				}else{
	 					beCheckedSkin.click()
	 				}
	 			}else{
	 				beCheckedSkin.click()
	 			}
	 		}else{	//选中第一个皮肤(页面加载后)
	 			$("#skinList .content ul li:first-child a").click();
	 		}
	 		controlUnEnabledSKinShowOrHide();
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}

function loadSkinInfo(skinId){
	colorTheListA(skinId);
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=getSkinByIdWithJson&id="+skinId),
	 	data: "{}",
	 	async: false,
	 	success: function(data, textStatus) 
	 	{
	 		var skinData = eval("(" + data + ")");
	 		$('#id').val(skinData["id"]);
	 		$('#objname').val(skinData["objname"]);
	 		$('#basePath').val(skinData["basePath"]);
	 		$('#previewPicPath').val(skinData["previewPicPath"]);
	 		$('#isSystem').val(skinData["isSystem"]);
	 		$('#globalCss').val(skinData["globalCss"]);
	 		$('#mainCss').val(skinData["mainCss"]);
	 		$('#portalCss').val(skinData["portalCss"]);
	 		$('#shortcutCss').val(skinData["shortcutCss"]);
	 		$('#workflowCss').val(skinData["workflowCss"]);
	 		$("input[name='skinType']").val([skinData["skinType"].toString()]);
	 		
	 		if(skinData["isDefault"] == 1){
	 			$("#isDefaultTD").html("是<input type=\"hidden\" id=\"isDefault\" name=\"isDefault\" value=\"1\"/>");
	 		}else{
	 			$("#isDefaultTD").html("<input type=\"radio\" name=\"isDefault\" value=\"1\"/>是&nbsp;"+
  							"<input type=\"radio\" name=\"isDefault\" value=\"0\"/>否");
  				$("input[name='isDefault']").val([skinData["isDefault"].toString()]);
	 		}
	 		$("input[name='isHideMainPageLeft']").val([skinData["isHideMainPageLeft"].toString()]);
	 		$("input[name='isEnabled']").val([skinData["isEnabled"].toString()]);
	 		
	 		$("#menuImgPath").val(skinData["menuImgPath"]);
	 		if(skinData["menuImgPath"] != null || skinData["menuImgPath"] != ''){
	 			$("#menuImgPathSpan").html("此处" + skinData["menuImgPath"] + "为相对路径, 其对应的完整路径为:" + skinData["basePath"] + "/" + skinData["menuImgPath"]);
	 		}
	 		controlIsEnabledTipShowOrHide();
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}

function radioChecked(n,v){
	$("input[type='radio'][name='"+n+"']").each(function(i){
		if($(this).val() == v){
			$(this).attr("checked","checked");
			return;
		}
	});;
}

function controlUnEnabledSKinShowOrHide(){
	var isHideUnEnabledSKin = document.getElementById("isHideUnEnabledSKin");
	var $unEnabledSkinListObj = $("#skinList .content ul li[isEnabled='0']");
	if(isHideUnEnabledSKin.checked){
		$unEnabledSkinListObj.hide();
	}else{
		$unEnabledSkinListObj.show();
	}
}

function controlIsEnabledTipShowOrHide(){
	var v = $("input[type='radio'][name='isEnabled']:checked").val();
	var isEnabled = (v == "1");
	if(isEnabled){
		$("#isEnabledTip").hide();
	}else{
		$("#isEnabledTip").show();
	}
}

function colorTheListA(skinId){
	$("#skinList .content ul li a p").bind("mouseover",function(){
		$(this).css("background-color","#DFDFDF");
	});
	$("#skinList .content ul li a p").bind("mouseout",function(){
		$(this).css("background-color","transparent");
	});
	
	$("#skinList .content ul li a p").css("background-color","transparent");
	$("#list" + skinId + " p").css("background-color","#DFDFDF");
	
	$("#list" + skinId + " p").unbind("mouseout");
}

var skinDialog;
function openSkinDialog(url,title,width,height){
	var config = {
	    layout:'border',
	    closeAction:'close',
	    plain: true,
	    modal :true,
	    items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }]
	};
	if(getCurrentSysMode() == "1"){
		config["y"] = 100;
	}
   	skinDialog = new Ext.Window(config);
    skinDialog.render(Ext.getBody());
    skinDialog.setTitle(title);
    skinDialog.setWidth(width);
    skinDialog.setHeight(height);
    skinDialog.getComponent('commondlg').setSrc(url);
    skinDialog.show();
}

function closeSkinDialog(){
	if(skinDialog){
		skinDialog.close();
	}
}
var initPreviewContentWidth;
$(function(){
	Ext.QuickTips.init();
	var tb = new Ext.Toolbar();
	tb.render('pagemenubar');
	addBtn(tb,'保存','S','accept',function(){onSave();});
	
	$("#windowBGColor").modcoder_excolor();
	
	$("#windowTopBorderColor").modcoder_excolor();
	$("#windowRightBorderColor").modcoder_excolor();
	$("#windowBottomBorderColor").modcoder_excolor();
	$("#windowLeftBorderColor").modcoder_excolor();
	
	$("#headerBGColor").modcoder_excolor();
	$("#footerBGColor").modcoder_excolor();
	
	$("#rightDiv").tabs();
	
	$("#EweaverForm").ajaxForm({
        success: function(responseText, statusText, xhr, $form){
        	if(responseText == "success"){
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
	
	initPreviewContentWidth = $("#previewContent").outerWidth();
});

function onSave(){
	if($("#objname").val() == ""){
		$("#objnameTipMessage").html("样式名称不能为空");
		return;
	}
	$("#EweaverForm").submit();
}
function showOrHiddenInfo(img, infoId){
	var info = document.getElementById(infoId);
	if(info){
		var infoDisplay = info.style.display;
		if(infoDisplay == "block"){
			info.style.display = "none";
			img.src = "/images/arrow_hidden.jpg";
		}else if(infoDisplay == "none"){
			info.style.display = "block";
			img.src = "/images/arrow_show.jpg";
		}
	}
}
function showOrHiddenDiv(eleName, divID){
	var eles = document.getElementsByName(eleName);
	var v = -1;
	for(var i = 0; eles && i < eles.length; i++){
		var ele = eles[i];
		if(ele.checked){
			v = ele.value;
			break;
		}
	}
	if(v != -1){
		var displayStyle;
		if(v == "1"){
			displayStyle = "block";
		}else{
			displayStyle = "none";
		}
		document.getElementById(divID).style.display = displayStyle;
	}
}
function doChecked(eleName, v){
	var eles = document.getElementsByName(eleName);
	for(var i = 0; eles && i < eles.length; i++){
		var ele = eles[i];
		if(ele.value == v){
			ele.checked = true;
			break;
		}
	}
}

function doSelected(eleId, v){
	var ele = document.getElementById(eleId);
	for(var i = 0; ele && i < ele.options.length; i++){
		var opt = ele.options[i];
		if(opt.value == v){
			opt.selected = true;
			break;
		}
	}
}

function changeImmediatePreview(flag){
	$("#closeImmediatePreview").css('display','none');
	$("#openImmediatePreview").css('display','none');
	if(flag == 0){ //关闭
		$("#openImmediatePreview").css('display','inline');
		$(document.body).unbind('click');
	}else{	//打开
		$("#closeImmediatePreview").css('display','inline');
		$(document.body).bind('click', function() {
  			doPreview();
		});
	}
}

function doPreview(){
	//删除所有的子节点(包含其下级子节点)
	$("#previewContent *").remove();
	
	//窗体本身的样式
	$("#previewContent").css({
		'font-size' : $('#windowFontSize').val(),
		'font-family': $('#windowFontFamily').val(),
    	'border-top': $('#windowTopBorderWidth').val() + "px " +  $('#windowTopBorderStyle').val() + " " +  $('#windowTopBorderColor').val(),
    	'border-right': $('#windowRightBorderWidth').val() + "px " + $('#windowRightBorderStyle').val() + " " + $('#windowRightBorderColor').val(),
    	'border-bottom': $('#windowBottomBorderWidth').val() + "px " + $('#windowBottomBorderStyle').val() + " " + $('#windowBottomBorderColor').val(),
    	'border-left': $('#windowLeftBorderWidth').val() + "px " + $('#windowLeftBorderStyle').val() + " " + $('#windowLeftBorderColor').val(),
    	'background-color': $('#windowBGColor').val()
	});
	
	var borderWidth = 0;
	if(!($('#windowLeftBorderStyle').val() == "none" || $('#windowLeftBorderStyle').val() == "hidden")){
		borderWidth += parseInt($('#windowLeftBorderWidth').val()) || 1;
	}
	
	if(!($('#windowRightBorderStyle').val() == "none" || $('#windowRightBorderStyle').val() == "hidden")){
		borderWidth += parseInt($('#windowRightBorderWidth').val()) || 1;
	}
	$("#previewContent").width(initPreviewContentWidth - borderWidth);
	
	//标题栏样式
	var hasHeader = ($("input[name='hasHeader']:checked").val() == "1");
	if(hasHeader){	//包含标题栏
		var headerDiv = $('<div></div>');
		headerDiv.css({
			'height': $('#headerHeight').val() + 'px',
			'background-color': $('#headerBGColor').val(),
			'background-image': 'url(' + $('#headerBGImage').val() + ')',
			'background-repeat': $('#headerBGImageRepeat').val()
		});
		
		//标题文字的样式(暂未加入定义,使用本身的css样式)
		var title = document.createElement("div");
	    var titleSpan = "<span>文档</span>";
	    title.className = "portlet-header-title";
	    title.innerHTML = titleSpan;
	    headerDiv.append(title);
    	
    	//标题栏按钮
   		var headerButton = createPortletButton(0);
	    headerDiv.append(headerButton);
	    
	    //标题栏是否是圆角(是圆角则增加圆角样式显示)
		var isRounded = ($("input[name='headerCornerStyle']:checked").val() == "0");
		if(isRounded){	//是圆角
			var innerDiv = document.createElement("div");
		    var innerDiv2 = document.createElement("div");
		    var innerDiv3 = document.createElement("div");
		    
		    var baseCssText = "height:1px;overflow:hidden;background-color:"+$('#headerBGColor').val()+";background-image:url(" + $('#headerBGImage').val() + ");background-repeat:" + $('#headerBGImageRepeat').val();
		    innerDiv.style.cssText = "width:374px;margin-left:3px;" + baseCssText;
		    innerDiv2.style.cssText = "width:376px;margin-left:2px;" + baseCssText;
		    innerDiv3.style.cssText = "width:378px;margin-left:1px;" + baseCssText;
		    
		    var outerDiv = document.createElement("div");
		    headerDiv.css({'height': ($('#headerHeight').val() - 3) + 'px'});
		    outerDiv.appendChild(innerDiv);
		    outerDiv.appendChild(innerDiv2);
		    outerDiv.appendChild(innerDiv3);
		    outerDiv.appendChild(headerDiv[0]);
		    $("#previewContent")[0].appendChild(outerDiv);
		}else{
			$("#previewContent").append(headerDiv);
		}
		
	}
	
	//创建内容
	var contentDiv = $('<div></div>');
	
	var contentHtml = "";
	contentHtml += "<table align=\"center\" class=\"Econtent\" style=\"width: 100%;\" border=\"0\" cellSpacing=\"1\">";
	for(var i = 0; i < 10; i++){
		contentHtml += 	"<tr class=\"row\">";
		contentHtml += 		"<td width=\"2%\" align=\"center\" class=\"itemIcon\"></td>";
		contentHtml +=		"<td width=\"98%\" align=\"left\" class=\"subject\">";
		contentHtml +=			"<a href=\"javascript:void(0);\" style=\"color: #000;\">此内容是以文档元素的内容为例</a>";
		contentHtml +=		"</td>";
		contentHtml += 	"</tr>";
		contentHtml += 	"<tr height=\"1\">";
		contentHtml += 		"<td class=\"line\" colspan=\"2\"></td>";
		contentHtml += 	"</tr>";
	}
	contentHtml += "</table>";
	
	contentDiv.html(contentHtml);
	contentDiv.css({
		'height': '224'
	});
	$("#previewContent").append(contentDiv);
	
	//底部样式
	var hasFooter = ($("input[name='hasFooter']:checked").val() == "1");
	if(hasFooter){
		var footerDiv = $('<div></div>');
		footerDiv.css({
			'height': $('#footerHeight').val() + 'px',
			'background-color': $('#footerBGColor').val(),
			'background-image': 'url(' + $('#footerBGImage').val() + ')',
			'background-repeat': $('#footerBGImageRepeat').val(),
			'position': 'relative'	//相对定位(以使底部按钮绝对定位时以此div为参照物)
		});
		
		//底部按钮
   		var footerButton = createPortletButton(1);
   		//绝对定位到底部的右下角
   		footerButton.style.position="absolute";
		footerButton.style.bottom="0px";
		footerButton.style.right="2px";
	    footerDiv.append(footerButton);
		
		//标题栏是否是圆角(是圆角则增加圆角样式显示)
		var isRounded = ($("input[name='footerCornerStyle']:checked").val() == "0");
		if(isRounded){	//是圆角
			var innerDiv = document.createElement("div");
		    var innerDiv2 = document.createElement("div");
		    var innerDiv3 = document.createElement("div");
		    
		    var baseCssText = "height:1px;overflow:hidden;background-color:"+$('#footerBGColor').val()+";background-image:url(" + $('#footerBGImage').val() + ");background-repeat:" + $('#footerBGImageRepeat').val();
		    innerDiv.style.cssText = "width:378px;margin-left:1px;" + baseCssText;
		    innerDiv2.style.cssText = "width:376px;margin-left:2px;" + baseCssText;
		    innerDiv3.style.cssText = "width:374px;margin-left:3px;" + baseCssText;
		    
		    var outerDiv = document.createElement("div");
		    footerDiv.css({'height': ($('#footerHeight').val() - 3) + 'px'});
		    outerDiv.appendChild(footerDiv[0]);
		    outerDiv.appendChild(innerDiv);
		    outerDiv.appendChild(innerDiv2);
		    outerDiv.appendChild(innerDiv3);
		    $("#previewContent")[0].appendChild(outerDiv);
		}else{
			$("#previewContent").append(footerDiv);
		}
	}
}

function createPortletButton(position){
	//是否拥有刷新按钮,如果是标题栏,则根据样式"标题栏是否包含刷新按钮"的值决定。否则，则是底部，则使用样式"底部是否包含刷新按钮"的值决定
	//(最小化,最大化按钮类同)
	var hasRefreshBtn = (position == 0 ? ($("input[name='hasHeaderRefreshBtn']:checked").val() == "1") : ($("input[name='hasFooterRefreshBtn']:checked").val() == "1"));
	var hasMinBtn = (position == 0 ? ($("input[name='hasHeaderMinBtn']:checked").val() == "1") : ($("input[name='hasFooterMinBtn']:checked").val() == "1"));
	var hasMaxBtn = (position == 0 ? ($("input[name='hasHeaderMaxBtn']:checked").val() == "1") : ($("input[name='hasFooterMaxBtn']:checked").val() == "1"));
	//刷新,最小化,最大化按钮的图片路径
	var refreshBtnPath = (position == 0 ? $('#headerRefreshBtnPath').val() : $('#footerRefreshBtnPath').val());
	var minBtnPath = (position == 0 ? $('#headerMinBtnPath').val() : $('#footerMinBtnPath').val());
	var maxBtnPath = (position == 0 ? $('#headerMaxBtnPath').val() : $('#footerMaxBtnPath').val());
    var refresh = " <span title='刷新'><img id='pngIcoUp' src='" + refreshBtnPath + "'  height='14' width='14' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var min = " <span title='最小化'><img id='pngIcoMin' src='" + minBtnPath + "' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var max = " <span title='最大化'><img id='pngIcoMax' src='" + maxBtnPath + "' style='border: 0px;-moz-opacity:0.5;filter:alpha(opacity=30);' height='14' width='14' onmouseover='this.style.MozOpacity=1;this.filters.alpha.opacity=70' onmouseout='this.style.MozOpacity=0.5;this.filters.alpha.opacity=30'/></span>";
    var h = document.createElement("div");
    h.className = "portlet-header-button";
    if (hasRefreshBtn) {
        var b = document.createElement("a");
        b.innerHTML = refresh;
        b.href = "javascript:void(0)";
        h.appendChild(b)
    }
    if (hasMinBtn) {
        var g = document.createElement("a");
        g.innerHTML = min;
        g.href = "javascript:void(0)";
        h.appendChild(g)
    }
    if(hasMaxBtn){
        var f = document.createElement("a");
        f.innerHTML = max;
        f.href = "javascript:void(0)";
        h.appendChild(f);
    }
    return h;
}
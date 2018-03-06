jQuery.fn.CRselectBox = jQuery.fn.sBox = function(){
	var _self = this;
	/*�����ṹ*/
	var _parent = _self.parent();
	var wrapHtml = '<div class="CRselectBox"></div>';
	var $wrapHtml = $(wrapHtml).appendTo(_parent);
	var selectedOptionValue = _self.find("option:selected").attr("value");
	var selectedOptionTxt = _self.find("option:selected").text();
	var name = _self.attr("name");
	var id = _self.attr("id");
	var inputHtml = '<input type="hidden" value="'+selectedOptionValue+'" name="'+name+'" id="'+id+'"/>';
	$(inputHtml).appendTo($wrapHtml);
	var inputTxtHtml = '<input type="hidden" value="'+selectedOptionTxt+'" name="'+name+'_CRtext" id="'+id+'_CRtext"/>';
	$(inputTxtHtml).appendTo($wrapHtml);
	var aHtml = '<a class="CRselectValue" href="#" title="'+selectedOptionTxt+'">'+selectedOptionTxt+'</a>';
	$(aHtml).appendTo($wrapHtml);
	var ulHtml = '<ul class="CRselectBoxOptions"></ul>';
	var $ulHtml = $(ulHtml).appendTo($(document.body));
	var liHtml = "";
	_self.find("option").each(function(){
		if($(this).attr("selected")){
			liHtml += '<li class="CRselectBoxItem"><a href="#" class="selected" rel="'+$(this).attr("value")+'">'+$(this).text()+'</a></li>';
		}else{
			liHtml += '<li class="CRselectBoxItem"><a href="#" rel="'+$(this).attr("value")+'">'+$(this).text()+'</a></li>';
		}
	});
	$(liHtml).appendTo($ulHtml);
	/*���Ч��*/
	$( $wrapHtml, _parent).hover(function(){
		$(this).addClass("CRselectBoxHover");
	},function(){
		$(this).removeClass("CRselectBoxHover");
	});
	$wrapHtml.click(function(){
		$(this).blur();	
		$ulHtml.show();
		return false;
	});
	$(".CRselectValue",$wrapHtml).click(function(){
		$(this).blur();	
		$ulHtml.show();
		return false;
	});
	$(".CRselectBoxItem a",$ulHtml).click(function(){
		$(this).blur();
		var value = $(this).attr("rel");
		var txt = $(this).text();
		$("#"+id).val(value);
		$("#"+id+"_CRtext").val(txt);
		$(".CRselectValue",$wrapHtml).text(txt);
		$(".CRselectValue",$wrapHtml).attr("title", txt);
		$(".CRselectBoxItem a",$ulHtml).removeClass("selected");
		$(this).addClass("selected");
		$ulHtml.hide();
		return false;
	});
	$(document).click(function(event){
		if( $(event.target).attr("class") != "CRselectBox" ){
			$ulHtml.hide();
		}
	});
	_self.remove();
	var ul_top = 0;
	var ul_left = 0;
	if(ul_top && ul_left){
		ul_top = $wrapHtml.offset().top + $wrapHtml.outerHeight(true) + 1; 
		ul_left = $wrapHtml.offset().left; 
	}
	$ulHtml.css("top", ul_top + "px");
	$ulHtml.css("left", ul_left + "px");
	return _self;
}


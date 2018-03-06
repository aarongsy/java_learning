(function($) {

	$.fn.doSwitch = function(settings) {
	
		//默认参数
		var config = {
			fadeOutSpeed : 150,	//淡出时的速度
			direction : 'left',		//滑动显现时的方向(left:从左向右滑出,right: 从右向左滑出)
			slideSpeed : 100,		//滑动速度
			attrName : 'href',		//元素的属性名称,此属性名称中的内容用于标识该元素用于控制哪个元素,A标签可使用href,如控制元素不是A标签可使用其他的属性来代替，如title
			eventName: 'click',		//事件名称，用于配置当出现哪种事件时触发操作
			isRepeatedResponse: false	//是否重复响应,false 指重复操作控制元素时，仅第一次时进行切换，接下来的将不做处理, 除非被控制元素改变。true反之。
		};
		
		if (settings) $.extend(config, settings);
		
		var contents = new Array();	//存放所有控制和被控制的对象(jquery对象)
		
		var $preBeControlledObj = null;
		
		this.each(function(i) {
			var $controlObj = $(this);	//控制对象
			var $beControlledObj = $($controlObj.attr(config.attrName));	//被控制对象
			if(config.attrName == "href"){	//若使用的是href属性，则获取到其值后将其还原成javascript:void(0);
				$controlObj.attr(config.attrName, "javascript:void(0);");
			}
			$controlObj.bind(config.eventName, function(){
				if(!config.isRepeatedResponse && $preBeControlledObj == $beControlledObj){	//控制重复响应
					return;
				}
				switchIt($beControlledObj);
			});
			contents.push({'controlObj':$controlObj, 'beControlledObj':$beControlledObj});
		});
		
		hideAllBeControlledObj();
		
		switchFirst();
		
		//隐藏所有被控制的对象
		function hideAllBeControlledObj(){
			for(var i = 0; i < contents.length; i++){
				contents[i]['beControlledObj'].css("display", "none");
			}
		}
		
		//进行切换的方法
		function switchIt($beControlledObj){
			if($preBeControlledObj == null){
				$beControlledObj.css("display", "block");
			}else{
				$preBeControlledObj.fadeOut(config.fadeOutSpeed,function(){
					$beControlledObj.css("display", "block");
					$beControlledObj.slideIt({direction:config.direction,changeSpeed:config.slideSpeed});
				});
			}
			$preBeControlledObj = $beControlledObj;
		}
		
		//切换到第一个
		function switchFirst(){
			if(contents.length > 0){
				var $firstControlObj = contents[0]['controlObj']
				eval("$firstControlObj." + config.eventName + "();");
			}
		}
		return this;
		
	};
	
})(jQuery);

(function($) {
	$.fn.slideIt = function(settings,callback) {
		//默认参数
		var config = {
			direction : 'left',
			showHide : 'show',
			changeSpeed : 600
		};
		
		if (settings) $.extend(config, settings);
		
		this.each(function(i) {	
			$(this).css({left:'auto',right:'auto',top:'auto',bottom:'auto'});
			var measurement = (config.direction == 'left') || (config.direction == 'right') ? $(this).outerWidth() : $(this).outerHeight();
			var startStyle = {};
			startStyle['position'] = $(this).css('position') == 'static' ? 'relative' : $(this).css('position');
			startStyle[config.direction] = (config.showHide == 'show') ? '-20px' : 0;
			var endStyle = {};
			endStyle[config.direction] = config.showHide == 'show' ? 0 : '-'+measurement+'px';
			$(this).css(startStyle).animate(endStyle,config.changeSpeed,callback);
		});
	
		return this;
		
	};

})(jQuery);
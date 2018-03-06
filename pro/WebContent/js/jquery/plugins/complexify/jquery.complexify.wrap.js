(function($) {

	$.fn.complexifyWrap = function(settings) {
	
		//默认参数
		var config = {
			basic : {
				minimumChars: 6,		//密码最小长度(此选项用于有需要限制密码长度时使用，根据此选项回调函数中会有相应的是否合法的参数可使用)
				strengthScaleFactor: 0.7	//强度比例 (该值约大，对于密码的强度越高(得到的分数会越低)。该值越小，则情况相反)
			},
			status : [
				{
					text : '',
					minScore : 0,
					maxScore : 0,
					textColor: '',
					barBgColor: ''
				},
				{
					text : '弱',
					minScore : 1,
					maxScore : 30,
					textColor: 'red',
					barBgColor: 'red'
				},
				{
					text : '中等',
					minScore : 31,
					maxScore : 70,
					textColor: '#f0a00a',
					barBgColor: '#f0a00a'
				},
				{
					text : '强',
					minScore : 71,
					maxScore : 100,
					textColor: 'green',
					barBgColor: 'green'
				}
			]
		};
		
		if (settings) $.extend(config, settings);
		
		//添加显示区域
		var $complexitybox = $("<div class=\"complexitybox\"></div>");
		$complexitybox.append("<div class=\"complexitytip\">密码强度：<span class=\"status\"></span></div>");
		$complexitybox.append("<div class=\"complexitywrap\"><div class=\"complexity\">0%</div></div>");
		$(this).parent().append($complexitybox);
		
		$(this).bind("focus", function(){
			$complexitybox.slideDown(80);
		});
		
		$(this).bind("blur", function(){
			$complexitybox.slideUp(80);
		});
		
		$(this).complexify(config.basic, function(valid, complexity){
			complexity = Math.round(complexity);
			var currStatus;
			$.each(config.status, function(i, s){
				if(s.minScore <= complexity && complexity <= s.maxScore){
					currStatus = s;
					return;
				}
			});
			if(currStatus){
				$complexitybox.find(".complexitytip .status").css("color", currStatus.textColor);
				$complexitybox.find(".complexitytip .status").html(currStatus.text);
				$complexitybox.find(".complexity").animate({'width':complexity + '%'},200).css('background-color', currStatus.barBgColor);
			}
			$complexitybox.find(".complexity").html(complexity + '%');
		});
		
		return this;
		
	};
	
})(jQuery);
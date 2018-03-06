/**
* 此JS文件主要用于存放表单或者流程中需要使用JS处理的浏览器兼容性相关问题的代码
* 放置在此文件中的代码应有如下两个特性：
* 1.代码是用来处理浏览器兼容性相关的
* 2.代码是表单和流程可以共用的
* (jQuery和Ext在该文件的代码中均是可以使用的框架)
*/


/**
* 此段代码解决IE10以下的浏览器(IE8,9)在页面使用了doctype之后toolbar按钮宽度变形的问题
* (暂时发现只有宽度固定才可以解决这个问题)
*/
Ext.onReady(function() {
	if(jQuery.browser.msie && !isIE10Browser()){	//是IE,但不是IE10     注： 方法isIE10Browser定义在/js/main.js中
		var $btnObjs = jQuery(".x-toolbar .x-btn-center .x-btn-text");
		$btnObjs.each(function(i){
			var btnText = jQuery(this).text();
			var fixedWidth = 12 * btnText.length + 2;	//按照每个字体12像素计算，左右余白2像素。
			jQuery(this).css("width", fixedWidth + "px");
		});
	}
});